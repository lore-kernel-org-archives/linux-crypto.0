From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-crypt] cryptsetup with arc4 cipher
Date: Sat, 8 Aug 2009 13:08:32 +1000
Message-ID: <20090808030831.GA14172@gondor.apana.org.au>
References: <20090805203017.GA5875@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mbroz@redhat.com, sb-lst@enotty.net, dm-crypt@saout.de,
	linux-crypto@vger.kernel.org, Tan Swee Heng <thesweeheng@gmail.com>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34080 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932873AbZHHDJG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2009 23:09:06 -0400
Content-Disposition: inline
In-Reply-To: <20090805203017.GA5875@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc> wrote:
> 
> The long story:
> ARC4 is a stream cipher and not a block cipher. Its internal state is
> reseted in setkey() and every crypto request (encrypt/decrypt don't
> matter) update the internal state of the stream cipher. That's why you
> get a different result every time you read the same block.

Actually I think that's a bug.  These ciphers really should not
modify their tfm state between operations.  Requiring a setkey
before each new operation precludes parallel processing.

I noticed that salsa seems to be broken in the same way, but at
least it should be easy to fix.

arc4 on the other hand needs to be converted to a blkcipher.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
