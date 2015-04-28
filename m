From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] SP800-38F / RFC3394 key wrapping
Date: Tue, 28 Apr 2015 04:45:17 +0200
Message-ID: <1742335.S7ujyfP8MQ@myon.chronox.de>
References: <1515730.LIeS5qas5m@myon.chronox.de> <20150428010941.GA28820@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34564 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082AbbD1CrD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2015 22:47:03 -0400
In-Reply-To: <20150428010941.GA28820@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 28. April 2015, 09:09:41 schrieb Herbert Xu:

Hi Herbert,

> On Sun, Apr 26, 2015 at 12:07:31AM +0200, Stephan Mueller wrote:
> > Hi,
> > 
> > Please note that this patch will conflict with the DRBG patch for
> > additional seeding sent earlier today. Both add test vectors in
> > testmgr.c between the existing hmac() and lrw() due to the ordering
> > requirements of testmgr.c.
> 
> Can you clarify the use case of this algorithm? In particular,
> who is going to use it in the kernel? This doesn't seem to be
> a candidate for use via algif since there aren't any or aren't
> likely going to be any hardware implementations.
> 
> If we can narrow down who is going to use it perhaps we can then
> figure out the appropriate interface for this.

The use case I see goes along the lines of dm-crypt and Ext4 crypto, or 
ecryptfs:

For the key wrapping they all do, I am thinking about suggesting KW as it has 
one advantage no other cipher currently has: it is an authenticated decryption 
where I still only need one symmetric key. Yes, KW is inefficient compared to 
other ciphers, but for handling small data blobs, it should be just fine.

For example, dm-crypt: dm-crypt currently uses the same cipher used for the 
bulk encryption to wrap the LUKS header. Obviously we miss the authentication 
check of the data blob. So, we could use other authenticated schemas, like GCM 
or authenc(). But they all need either two keys or AAD for which the common 
mechanisms typically have no provisions. Therefore, KW is a drop-in 
replacement for standard symmetric ciphers where one want authentication as 
well.

-- 
Ciao
Stephan
