From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-crypt] cryptsetup with arc4 cipher
Date: Sat, 8 Aug 2009 13:13:41 +1000
Message-ID: <20090808031341.GA14304@gondor.apana.org.au>
References: <20090805203017.GA5875@Chamillionaire.breakpoint.cc> <20090808030831.GA14172@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mbroz@redhat.com, sb-lst@enotty.net, dm-crypt@saout.de,
	linux-crypto@vger.kernel.org, Tan Swee Heng <thesweeheng@gmail.com>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44620 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932939AbZHHDOG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2009 23:14:06 -0400
Content-Disposition: inline
In-Reply-To: <20090808030831.GA14172@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Aug 08, 2009 at 01:08:32PM +1000, Herbert Xu wrote:
>
> I noticed that salsa seems to be broken in the same way, but at
> least it should be easy to fix.
> 
> arc4 on the other hand needs to be converted to a blkcipher.

In fact the internal state shouldn't be kept in the tfm at all.
I'll change it into an IV in order to allow continuation.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
