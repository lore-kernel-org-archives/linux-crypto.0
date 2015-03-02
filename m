From: Martin Hicks <mort@bork.org>
Subject: Re: [PATCH 0/2] crypto: talitos: Add AES-XTS mode
Date: Mon, 2 Mar 2015 17:09:24 -0500
Message-ID: <20150302220923.GC30523@darwin.bork.org>
References: <1424451610-5786-1-git-send-email-mort@bork.org>
 <54F464E4.8080204@freescale.com>
 <54F475A8.6030105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>,
	Martin Hicks <mort@bork.org>,
	Kim Phillips <kim.phillips@freescale.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from darwin.bork.org ([65.49.60.145]:39315 "EHLO darwin.bork.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbbCBWJY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Mar 2015 17:09:24 -0500
Content-Disposition: inline
In-Reply-To: <54F475A8.6030105@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Mon, Mar 02, 2015 at 03:37:28PM +0100, Milan Broz wrote:
> 
> If crypto API allows to encrypt more sectors in one run
> (handling IV internally) dmcrypt can be modified of course.
> 
> But do not forget we can use another IV (not only sequential number)
> e.g. ESSIV with XTS as well (even if it doesn't make much sense, some people
> are using it).

Interesting, I'd not considered using XTS with an IV other than plain/64.
The talitos hardware would not support aes/xts in any mode other than
plain/plain64 I don't think...Although perhaps you could push in an 8-byte
IV and the hardware would interpret it as the sector #.

> Maybe the following question would be if the dmcrypt sector IV algorithms
> should moved into crypto API as well.
> (But because I misused dmcrypt IVs hooks for some additional operations
> for loopAES and old Truecrypt CBC mode, it is not so simple...)

Speaking again with talitos in mind, there would be no advantage for this
hardware.  Although larger requests are possible only a single IV can be
provided per request, so for algorithms like AES-CBC and dm-crypt 512byte IOs
are the only option (short of switching to 4kB block size).

mh

-- 
Martin Hicks P.Eng.    |      mort@bork.org
Bork Consulting Inc.   |  +1 (613) 266-2296
