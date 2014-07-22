From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Tue, 22 Jul 2014 00:44:09 -0400
Message-ID: <20140722044409.GE24960@thunk.org>
References: <20140721112102.19300.qmail@ns.horizon.com>
 <1405956426.2319.37.camel@localhost>
 <1405990940.28229.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Spelvin <linux@horizon.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48907 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbaGVEoc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Jul 2014 00:44:32 -0400
Content-Disposition: inline
In-Reply-To: <1405990940.28229.4.camel@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 22, 2014 at 03:02:20AM +0200, Hannes Frederic Sowa wrote:
> 
> Ted, would it make sense to specifiy a 512 byte upper bound limit for
> random entropy extraction (I am not yet convinced to do that for
> urandom) and in case the syscall should block we make sure that we
> extract the amount of bytes the user requested?

On some systems, it's still possible that with a large /dev/random
extraction, you could end up blocking for hours.  So either the
getrandom(2) syscall needs to be uninterruptible, which has one set of
problems (and not just the user typing ^C, but also things like being
able to process alarms, which is highly problematic indeed), or you
need to allow it to be interruptible by a signal, in which case
userspace needs to check the error return for things like EINTR
anyway.  And if you have to check the error return, you might as well
check the number of bytes returned.

Yes, one could in theory set up a new variant of "uninterruptible"
signals that only exited if the signal caused the process to exit, and
otherwise, forced a system call restart even if SA_INTERRUPTIBLE was
not set in sigalarim, but that's add *way* more complexity than this
deserves.

Basically, I view /dev/random as an advanced call, and someone who
uses it should know what they are doing.  It's not the default for a
reason.

						- Ted
