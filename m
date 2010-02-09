From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] dm-crypt: disable block encryption with arc4
Date: Wed, 10 Feb 2010 07:42:54 +1100
Message-ID: <20100209204254.GB26258@gondor.apana.org.au>
References: <20100209073718.GA17612@gondor.apana.org.au> <Pine.LNX.4.64.1002090900050.19526@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mbroz@redhat.com, linux-crypto@ml.breakpoint.cc,
	dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53507 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752627Ab0BIUnA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 15:43:00 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1002090900050.19526@hs20-bc2-1.build.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 09, 2010 at 09:02:35AM -0500, Mikulas Patocka wrote:
> 
> What is the fix for arc4? Copy the internal state after a key schedule and 
> restore it with every encryption?

arc4 should be a blkcipher, not a cipher.  Then it can have an IV
which is where thie should be stored.
 
> I think blacklisting "arc4" is better, because it provides a fix now. 
> Otherwise, people will just keep on arguing what is the "clean" solution 
> and nothing gets done.

The crypto layer makes no guarantee that every algorithm that is
available is suitable for a particular application such as disk
encryption.  FWIW we also export an algorithm called null!

People should not be making uninformed choices on crypto algorithms.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
