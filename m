From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: limit the contribution of the hw rng to at most
 half
Date: Fri, 18 Jul 2014 02:23:56 -0400
Message-ID: <20140718062356.GC1491@thunk.org>
References: <1405591436-15445-1-git-send-email-tytso@mit.edu>
 <53C80A6D.5010201@zytor.com>
 <20140717220806.GW1491@thunk.org>
 <53C85D50.5040901@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42529 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283AbaGRHQO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Jul 2014 03:16:14 -0400
Content-Disposition: inline
In-Reply-To: <53C85D50.5040901@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 17, 2014 at 04:33:36PM -0700, H. Peter Anvin wrote:
> 
> I just want to make sure we don't negatively impact the real security of
> users because of "optics".  We already have a lot of problems with
> people extracting long-living keys from /dev/urandom because /dev/random
> is too slow.

With a system with RDRAND, we're mixing arch_get_rand_long() as part
of the extraction process (as the seed for the SHA's IV).  So if you
trust RDRAND, then using /dev/urandom even when the entropy count is
zero is going to be secure.  If you don't trust RDRAND, then the
RDSEED entropy accounting is going to be extremely disturbing.

So the only way that we could be impacting the "real security" of
users, would be if RDRAND was back-doored, but RDSEED wasn't.  And
that doesn't seem like a terribly likely scenario to me, but what do I
know?  :-)

						- Ted
