Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:38992 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfADKUk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jan 2019 05:20:40 -0500
Date: Fri, 4 Jan 2019 13:20:36 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dhowells@redhat.com, davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] akcipher: Introduce verify2 for public key algorithms
Message-ID: <20190104102035.42qwwv4komjvnswh@sole.flsd.net>
References: <20181211165938.1150-1-vt@altlinux.org>
 <20181213101233.6t7d5mxxkkavo46h@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20181213101233.6t7d5mxxkkavo46h@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 13, 2018 at 06:12:33PM +0800, Herbert Xu wrote:
> Vitaly Chikunov <vt@altlinux.org> wrote:
> > Current akcipher .verify() just decrypts signature to uncover message
> > hash, which is then verified in upper level public_key_verify_signature
> > by memcmp with the expected signature value, which is never passed into
> > verify().
> > 
> > This approach is incompatible with ECDSA algorithms, because, to verify
> > a signature ECDSA algorithm also needs a hash value as input; also, hash
> > is used in ECDSA (together with a signature divided into halves `r||s`),
> > not to produce hash, but to produce a number, which is then compared to
> > `r` (first part of the signature) to determine if the signature is
> > correct.  Thus, for ECDSA, nor requirements of .verify() itself, nor its
> > output expectations in public_key_verify_signature aren't satisfied.
> > 
> > Make alternative .verify2() call which gets hash value and produce
> > complete signature check (without any output, thus max_size() call will
> > not be needed for verify2() operation).
> > 
> > If .verify2() call is present, it should be used in place of .verify().
> > 
> > Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> 
> We should convert all existing users to this interface and not
> have both verify/verify2 forever.

This will be hard to do since there is at least tree device that use
this interface (and who know how much out of tree):

  drivers$ git grep cra_name.*rsa
  crypto/caam/caampkc.c:          .cra_name = "rsa",
  crypto/ccp/ccp-crypto-rsa.c:            .cra_name = "rsa",
  crypto/qat/qat_common/qat_asym_algs.c:          .cra_name = "rsa",

Interface seems to be designed that verify() call is interchangeable
with encrypt().

Two verify does not seem that bad since there is common code for the old
interface that removes code duplication and simplifies driver
implementation (RSA drivers only need to implement encrypt).

But, I would remove scatterlist from the new interface. Signature
verification is not some multi-block encryption. And basically,
public_key_verify_signature just doing sg_init_one for both required
src/dst buffers.

ps. And also, in the future, I would allow akcipher to access `struct
public_key` and `struct public_key_signature` so it could distinguish
when the key is already validated and skip expensive validation other
time verify2 is used with the same key. Or maybe flag 'key validation is
needed' should be maintained outside of akcipher and passed to it in the
request.

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
