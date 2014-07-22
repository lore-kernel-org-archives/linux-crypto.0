From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Tue, 22 Jul 2014 18:59:50 -0400
Message-ID: <20140722225950.GU25291@thunk.org>
References: <20140721112102.19300.qmail@ns.horizon.com>
 <1405956426.2319.37.camel@localhost>
 <1405990940.28229.4.camel@localhost>
 <20140722044409.GE24960@thunk.org>
 <1406022592.2407.9.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Spelvin <linux@horizon.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51128 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866AbaGVW7z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Jul 2014 18:59:55 -0400
Content-Disposition: inline
In-Reply-To: <1406022592.2407.9.camel@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 22, 2014 at 11:49:52AM +0200, Hannes Frederic Sowa wrote:
> 
> I think a lot of checks are of the type "if (getrandom() < 0)", so this
> actually was the kind of programming errors I wanted to guard against. 
> Also, on some systems it is very likely that we return a short write to
> user space, so it prevents this very common situation. Even if one would
> like to extract 64 bytes randomness, one would often need two calls to
> getrandom() on my virtualized systems. Would be great to know that in
> blocking mode, either I get a -1 or the buffer is always filled and I
> won't need to do pointer arithmetic to fill the rest of the buffer.

But why would you need to use GRND_RANDOM in your scenario, and accept
your application potentially getting stalled and stuck in amber for
perhaps hours?  If you are going to accept your application stalling
like that, you can do the pointer arithmatic.  It's really not hard,
and someone who can't do that, again, shouldn't be allowd anywhere
near crypto code in the first place (and if they are, they'll probably
be making lots of other, equally fatal if not more so, newbie
mistakes).

							- Ted
