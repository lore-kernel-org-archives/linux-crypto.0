From: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: Is kernel optimized with dead store removal?
Date: Thu, 25 Feb 2010 12:06:35 +0100
Message-ID: <19334.22971.970220.245930@pilspetsen.it.uu.se>
References: <4B85A49E.6000803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "lkml" <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fanny.its.uu.se ([130.238.4.241]:35546 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530Ab0BYLGq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2010 06:06:46 -0500
In-Reply-To: <4B85A49E.6000803@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Roel Kluin writes:
 > According to http://cwe.mitre.org/data/slices/2000.html#14 due to optimization
 > A call to memset() can be removed as a dead store when the buffer is not used
 > after its value is overwritten. Does this optimization also occur during
 > compilation of the Linux kernel? Then I think I may have found some
 > vulnerabilities. One is sha1_update() where memset(temp, 0, sizeof(temp)); may
 > be removed.

Any such dead store removal is up to the compiler and the lifetime
of the object being clobbered. For 'auto' objects the optimization
is certainly likely.

This is only a problem if the memory (a thread stack, say) is recycled
and leaked uninitialized to user-space, but such bugs are squashed
fairly quickly upon discovery.

(checking gcc-4.4.3)
It seems that memset((volatile void*)&some_local_var, 0, sizeof(...))
just provokes a warning about the invalid type of memset()'s first
parameter, but then still optimizes the operation away.

You might need to call an out-of-line helper function for this to work.
