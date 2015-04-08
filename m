From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 01/16] crypto: sha1: implement base layer for SHA-1
Date: Wed, 8 Apr 2015 21:19:16 +0800
Message-ID: <20150408131916.GA29646@gondor.apana.org.au>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
 <1428396724-19962-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, samitolvanen@google.com, jussi.kivilinna@iki.fi,
	stockhausen@collogia.de
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50416 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbbDHNTa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Apr 2015 09:19:30 -0400
Content-Disposition: inline
In-Reply-To: <1428396724-19962-2-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 07, 2015 at 10:51:49AM +0200, Ard Biesheuvel wrote:
>
> +typedef void (sha1_block_fn)(int blocks, u8 const *src, u32 *state,
> +			     const u8 *head, void *p);

Does this really need five arguments? First of all we can get rid
of head by just calling this function twice.  The last argument
appears to only be used by arm64 where it is simply another way
of saying (sctx->count + len) % SHA_BLOCK_SIZE != 0.  So why not
get rid of it and just use the conditional?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
