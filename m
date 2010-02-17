From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: converting sync driver to async
Date: Wed, 17 Feb 2010 08:08:17 +0800
Message-ID: <20100217000817.GA11975@gondor.apana.org.au>
References: <311e0d1f1002160806j37c8d358xe3bc83805adee176@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: avital sela <avitalsela95@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59402 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933630Ab0BQAIT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2010 19:08:19 -0500
Content-Disposition: inline
In-Reply-To: <311e0d1f1002160806j37c8d358xe3bc83805adee176@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 16, 2010 at 06:06:37PM +0200, avital sela wrote:
> Hello,
> 
> I have written sha and aes HW accelerator drivers for our custom
> drivers (thanks for your patient help) and they work great.
> To exploit the full potential of the HW I want to port them to the
> ASYNC interface and have some questions.
> 1. Using my current setup I see the following results (measured with iperf)
> no ipsec  -85 mbits
> ESP in tunnel mode with null algs  - 45 mbits
> ESP in tunnel mode with aes and sha1 - 32 mbits
> Is it reasonable to have the throughput drop so much even without any
> actual crypto going on? Can this mostly be attributed to the bigger
> packets ?

That should be easy to tell.  Just disable GSO/SG/checksum offload
on the physical interface and retest with no ipsec.

> My understanding of the results is that the maximum throughput I can
> hope to achieve on this systen by only improving the crypto drivers is
> 45 mbits?

Yes.

> 2. Is there any comparison somewhere between OCF performance and Acrypto?

Not that I'm aware unfortunately.

> 3. Using drivers/crypto/talitos as a reference I am setting the alg
> name to "authenc(hmac(sha1),cbc(aes))",cra_flags to
> CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
>    and cra_type to &crypto_aead_type. My existing driver had a
> cra_list field. Is that required for this type of driver as well?

The cra_list field does not have to be initialised so no you
don't need to make it explicit.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
