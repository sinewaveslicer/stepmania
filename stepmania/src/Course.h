#pragma once
/*
-----------------------------------------------------------------------------
 Course: Course

 Desc: A queue of songs and notes.

 Copyright (c) 2001-2002 by the person(s) listed below.  All rights reserved.
	Chris Danford
-----------------------------------------------------------------------------
*/

#include "GameConstantsAndTypes.h"
class Song;
struct Notes;

const int MAX_COURSE_STAGES = 100;

class Course
{
public:
	Course()
	{
		m_NotesType	= NOTES_TYPE_INVALID;
		m_iStages = 0;
		for( int i=0; i<MAX_COURSE_STAGES; i++ )
		{
			m_apSongs[i] = NULL;
			m_apNotes[i] = NULL;
		}
	}

	CString		m_sName;
	CString		m_sBannerPath;
	CString		m_sCDTitlePath;
	NotesType	m_NotesType;
	int			m_iStages;
	Song*		m_apSongs[MAX_COURSE_STAGES];
	Notes*		m_apNotes[MAX_COURSE_STAGES];

	void AddStage( Song* pSong, Notes* pNotes )
	{
		ASSERT( m_iStages <= MAX_COURSE_STAGES );
		m_apSongs[m_iStages] = pSong;
		m_apNotes[m_iStages] = pNotes;
		m_iStages++;
	}

};
