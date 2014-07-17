From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 18:30:29 -0400
Message-ID: <20140717223029.GY1491@thunk.org>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
 <20140717161215.GA14951@infradead.org>
 <20140717170115.GO1491@thunk.org>
 <CAComcpM9-sUwzT9BPFT7BJjk97V0kj996D=AaivDpeTZUNbiew@mail.gmail.com>
 <20140717173433.GQ1491@thunk.org>
 <CAComcpPkOM9oy9tYcDqVfF3siKT_RLe54qskhUJRPLWm-MukEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-api <linux-abi@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Bob Beck <beck@openbsd.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41956 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbaGQWah (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jul 2014 18:30:37 -0400
Content-Disposition: inline
In-Reply-To: <CAComcpPkOM9oy9tYcDqVfF3siKT_RLe54qskhUJRPLWm-MukEA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 17, 2014 at 11:45:56AM -0600, Bob Beck wrote:
> we have diffs pending that will do the syscall method until we start
> to see it in libc :)

One warning --- please don't check in the syscall number until it
actually hits mainline.  Kees has another patch outstanding for
seccomp(2) that is using the same syscall numbers I have in my patch.
Please treat the numbers in my patch as placeholders until it has been
accepted and we see what numbers we actually get assigned.

Thanks,

						- Ted
