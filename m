From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH crypto 1/4] AES-NI: Move key_length in struct
	crypto_aes_ctx to be the last field
Date: Fri, 9 Jan 2009 16:50:16 +1100
Message-ID: <20090109055016.GA13304@gondor.apana.org.au>
References: <1231120927.5937.26.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36915 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751765AbZAIFuX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Jan 2009 00:50:23 -0500
Content-Disposition: inline
In-Reply-To: <1231120927.5937.26.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 05, 2009 at 10:02:07AM +0800, Huang Ying wrote:
> The Intel AES-NI AES acceleration instructions need key_enc, key_dec
> in struct crypto_aes_ctx to be 16 byte aligned, it make this easier to
> move key_length to be the last one.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Patch applied.
  
>  struct crypto_aes_ctx {
> -	u32 key_length;
>  	u32 key_enc[AES_MAX_KEYLENGTH_U32];
>  	u32 key_dec[AES_MAX_KEYLENGTH_U32];
> +	u32 key_length;
>  };

I added a comment here so people don't break this down the track.

+/*
+ * Please ensure that the first two fields are 16-byte aligned
+ * relative to the start of the structure, i.e., don't move them!
+ */

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
