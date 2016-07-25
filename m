From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] /dev/random driver changes for 4.8
Date: Mon, 25 Jul 2016 10:24:07 -0400
Message-ID: <20160725142407.GG10966@thunk.org>
References: <20160725064424.GA29098@thunk.org>
 <20160725171515.737d61ae@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41598 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbcGYOYM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jul 2016 10:24:12 -0400
Content-Disposition: inline
In-Reply-To: <20160725171515.737d61ae@canb.auug.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 25, 2016 at 05:15:15PM +1000, Stephen Rothwell wrote:
> Hi Ted,
> 
> On Mon, 25 Jul 2016 02:44:24 -0400 Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > The following changes since commit 1a695a905c18548062509178b98bc91e67510864:
> > 
> >   Linux 4.7-rc1 (2016-05-29 09:29:24 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus
> > 
> > for you to fetch changes up to 86a574de4590ffe6fd3f3ca34cdcf655a78e36ec:
> > 
> >   random: strengthen input validation for RNDADDTOENTCNT (2016-07-03 17:09:33 -0400)
> 
> Of course none of this has been in linux-next since the random tree was
> dropped in March because it had not been updated for more than a year at
> that point.
> 
> However, at least half of these look like bug fixes (cced to stable).
> 
> Should I reinstate the random tree to linux-next?

Yes, please do.  It was getting zero-day checks, and I assumed it was
in linux-next; I should have checked, though.

							- Ted
