From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 08:52:36 -0400
Message-ID: <20140717125236.GM1491@thunk.org>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717120949.GB24362@distanz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
	linux-crypto@vger.kernel.org, beck@openbsd.org
To: Tobias Klauser <tklauser@distanz.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40786 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbaGQMwr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jul 2014 08:52:47 -0400
Content-Disposition: inline
In-Reply-To: <20140717120949.GB24362@distanz.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 17, 2014 at 02:09:49PM +0200, Tobias Klauser wrote:
> 
> > +/*
> > + * Flags for getrandom(2)
> > + *
> > + * GAND_BLOCK 		Allow getrandom(2) to block
> > + * GAND_RANDOM		Use the /dev/random pool instead of /dev/urandom
> > + */
> 
> Very minor nitpick: These should probably read GRND_BLOCK/GRND_RANDOM as
> well, no?

Thanks, typo.  I'll get this fixed up.

	       	    	     	   - Ted
