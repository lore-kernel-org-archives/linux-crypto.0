From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix key pointer size warning
Date: Thu, 1 Dec 2016 20:53:58 +0800
Message-ID: <20161201125358.GA2249@gondor.apana.org.au>
References: <201611290428.uAmzPb1J%fengguang.wu@intel.com>
 <1480407769-15336-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Dan Douglass <dan.douglass@nxp.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56245 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757962AbcLAMyI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2016 07:54:08 -0500
Content-Disposition: inline
In-Reply-To: <1480407769-15336-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 29, 2016 at 10:22:49AM +0200, Horia Geantă wrote:
> When building on 32-bit, compiler issues [-Wint-to-pointer-cast] warnings:
> 
> drivers/crypto/caam/caamalg_desc.c: In function 'cnstr_shdsc_aead_null_encap':
> drivers/crypto/caam/caamalg_desc.c:67:27: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>    append_key_as_imm(desc, (void *)adata->key, adata->keylen_pad,
> [...]
> 
> Since in all these cases the u64 "key" member of alginfo struct holds
> a uintptr_t value, we can safely remove the warnings by explicitly casting
> to uinptr_t (before any other existing cast).
> 
> Fixes: 8cea7b66b821 ("crypto: caam - refactor encryption descriptors generation")
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Thanks for the patch.  I think Arnd's version is cleaner though
so I'll take that instead.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
