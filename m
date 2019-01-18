Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48462 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbfARKzx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 05:55:53 -0500
Date: Fri, 18 Jan 2019 18:55:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: shash - require neither or both ->export() and
 ->import()
Message-ID: <20190118105551.vve56jx2cdoa3lbp@gondor.apana.org.au>
References: <20190107030720.9971-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190107030720.9971-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 06, 2019 at 07:07:20PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Prevent registering shash algorithms that implement ->export() but not
> ->import(), or ->import() but not ->export().  Such cases don't make
> sense and could confuse the check that shash_prepare_alg() does for just
> ->export().
> 
> I don't believe this affects any existing algorithms; this is just
> preventing future mistakes.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/shash.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
