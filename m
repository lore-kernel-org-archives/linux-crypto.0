Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:50394 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbeLMKMl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 05:12:41 -0500
Date: Thu, 13 Dec 2018 18:12:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: dhowells@redhat.com, davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] akcipher: Introduce verify2 for public key algorithms
Message-ID: <20181213101233.6t7d5mxxkkavo46h@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181211165938.1150-1-vt@altlinux.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Vitaly Chikunov <vt@altlinux.org> wrote:
> Current akcipher .verify() just decrypts signature to uncover message
> hash, which is then verified in upper level public_key_verify_signature
> by memcmp with the expected signature value, which is never passed into
> verify().
> 
> This approach is incompatible with ECDSA algorithms, because, to verify
> a signature ECDSA algorithm also needs a hash value as input; also, hash
> is used in ECDSA (together with a signature divided into halves `r||s`),
> not to produce hash, but to produce a number, which is then compared to
> `r` (first part of the signature) to determine if the signature is
> correct.  Thus, for ECDSA, nor requirements of .verify() itself, nor its
> output expectations in public_key_verify_signature aren't satisfied.
> 
> Make alternative .verify2() call which gets hash value and produce
> complete signature check (without any output, thus max_size() call will
> not be needed for verify2() operation).
> 
> If .verify2() call is present, it should be used in place of .verify().
> 
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>

We should convert all existing users to this interface and not
have both verify/verify2 forever.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
