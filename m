From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-devel] Desynchronizing dm-raid1
Date: Wed, 14 May 2008 09:14:57 +0800
Message-ID: <20080514011457.GB18728@gondor.apana.org.au>
References: <E1JtKQL-0004Nm-00@gondolin.me.apana.org.au> <Pine.LNX.4.64.0805061849020.7260@engineering.redhat.com> <Pine.LNX.4.64.0805122325050.373@engineering.redhat.com> <20080513033822.GA9604@gondor.apana.org.au> <Pine.LNX.4.64.0805131622120.486@engineering.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
	malahal@us.ibm.com
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48827 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757960AbYENBPB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 May 2008 21:15:01 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805131622120.486@engineering.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 13, 2008 at 04:35:03PM -0400, Mikulas Patocka wrote:
>
> And where would you propose to place this bit?
> 
> One possibility would be struct crypto_tfm->crt_flags
> Another possibility is struct crypto_alg->cra_flags

The latter definitely because this is an algorithm property.

> Can chaining mode change the value of the flag? (I presume that yes)

If you mean templates like CBC then it depends.  You should
set it to zero by default for safety but most of them should
be able to turn it on once audited.

If it turns out that the majority of algorithms support this,
you could even decide to only select those algorithms that do.
Suppose your bit is

	CRYPTO_ALG_FOO

then you could do

	crypto_alloc_blkcipher(name, CRYPTO_ALG_FOO, CRYPTO_ALG_FOO)

to demand only those algorithms that comply.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
