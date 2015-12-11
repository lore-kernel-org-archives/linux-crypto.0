From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [RFC PATCH V3] Crypto: rockchip/crypto - add hash support for
 crypto engine in rk3288
Date: Fri, 11 Dec 2015 09:54:58 +0100
Message-ID: <20151211085458.GA14705@Red>
References: <1449799103-24221-1-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: heiko@sntech.de, herbert@gondor.apana.org.au, davem@davemloft.net,
	eddie.cai@rock-chips.com, linux-rockchip@lists.infradead.org,
	linux-crypto@vger.kernel.org
To: Zain Wang <zain.wang@rock-chips.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:34389 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbbLKIzD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Dec 2015 03:55:03 -0500
Received: by mail-wm0-f52.google.com with SMTP id c17so3218566wmd.1
        for <linux-crypto@vger.kernel.org>; Fri, 11 Dec 2015 00:55:02 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1449799103-24221-1-git-send-email-zain.wang@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

I have some minor comments below.

On Fri, Dec 11, 2015 at 09:58:23AM +0800, Zain Wang wrote:
> Add md5 sha1 sha256 support for crypto engine in rk3288.
> This patch can't support multiple updatings because of limited of IC,
> as result, it can't support import and export too.
> 
> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
> ---
> 
> Changes in V3:
> - add switch instead of multiple if.
> 
> Changes in V2:
> - add some comments to code.
> - fix some issues about zero message process.
> 
>  drivers/crypto/rockchip/Makefile                   |   1 +
>  drivers/crypto/rockchip/rk3288_crypto.c            |  33 +-
>  drivers/crypto/rockchip/rk3288_crypto.h            |  50 ++-
>  drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |  20 +-
>  drivers/crypto/rockchip/rk3288_crypto_ahash.c      | 394 +++++++++++++++++++++
>  5 files changed, 480 insertions(+), 18 deletions(-)
>  create mode 100644 drivers/crypto/rockchip/rk3288_crypto_ahash.c
> 
> diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
> index 604ffe7..01d8299 100644
> --- a/drivers/crypto/rockchip/rk3288_crypto.h
> +++ b/drivers/crypto/rockchip/rk3288_crypto.h
> @@ -6,6 +6,10 @@
>  #include <crypto/algapi.h>
>  #include <linux/interrupt.h>
>  #include <linux/delay.h>
> +#include <crypto/internal/hash.h>
> +
> +#include "crypto/md5.h"
> +#include "crypto/sha.h"

It is proper to include with <> not ""

> diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
> new file mode 100644
> index 0000000..a5795f6
> --- /dev/null
> +++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
> @@ -0,0 +1,394 @@
> +/*
> + * Crypto acceleration support for Rockchip RK3288
> + *
> + * Copyright (c) 2015, Fuzhou Rockchip Electronics Co., Ltd
> + *
> + * Author: Zain Wang <zain.wang@rock-chips.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * Some ideas are from marvell/cesa.c and s5p-sss.c driver.
> + */
> +#include "rk3288_crypto.h"
> +
> +/*
> + * IC can not process zero message hash,
> + * so we put the fixed hash out when met zero message.
> + */
> +const static u8 *sha1_zero_message_hash = {
> +	"\xda\x39\xa3\xee\x5e\x6b\x4b\x0d\x32\x55"
> +	"\xbf\xef\x95\x60\x18\x90\xaf\xd8\x07\x09"
> +};
> +
> +const static u8 *sha256_zero_message_hash = {
> +	"\xe3\xb0\xc4\x42\x98\xfc\x1c\x14"
> +	"\x9a\xfb\xf4\xc8\x99\x6f\xb9\x24"
> +	"\x27\xae\x41\xe4\x64\x9b\x93\x4c"
> +	"\xa4\x95\x99\x1b\x78\x52\xb8\x55"
> +};
> +
> +const static u8 *md5_zero_message_hash = {
> +	"\xd4\x1d\x8c\xd9\x8f\x00\xb2\x04"
> +	"\xe9\x80\x09\x98\xec\xf8\x42\x7e"
> +};
> +
> +
> +static int zero_message_process(struct ahash_request *req)
> +{
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +
> +	switch (crypto_ahash_digestsize(tfm)) {
> +	case SHA1_DIGEST_SIZE:
> +		memcpy(req->result, sha1_zero_message_hash, SHA1_DIGEST_SIZE);
> +		break;
> +	case SHA256_DIGEST_SIZE:
> +		memcpy(req->result, sha256_zero_message_hash,
> +		       SHA256_DIGEST_SIZE);
> +		break;
> +	case MD5_DIGEST_SIZE:
> +		memcpy(req->result, md5_zero_message_hash, MD5_DIGEST_SIZE);
> +		break;
> +	default:
> +		return -EINVAL;
> +		break;
> +	}

You could store crypto_ahash_digestsize result and use it in memcpy.
You could also store the name of xxx_zero_message_hash in crypto_alg like n2 do.
Perhaps a combination of the two could produce more generic code.

> +struct rk_crypto_tmp rk_ahash_sha256 = {
> +	.type = ALG_TYPE_HASH,
> +	.alg.hash = {
> +	.init = rk_ahash_init,
> +	.update = rk_ahash_update,
> +	.final = rk_ahash_final,
> +	.finup = rk_ahash_finup,
> +	.digest = rk_ahash_digest,
> +		.halg = {
> +			 .digestsize = SHA256_DIGEST_SIZE,
> +			 .statesize = sizeof(struct sha256_state),
> +			 .base = {
> +				  .cra_name = "sha256",
> +				  .cra_driver_name = "rk-sha256",
> +				  .cra_priority = 300,
> +				  .cra_flags = CRYPTO_ALG_ASYNC |
> +					       CRYPTO_ALG_NEED_FALLBACK,
> +				  .cra_blocksize = SHA256_BLOCK_SIZE,
> +				  .cra_ctxsize = sizeof(struct rk_ahash_ctx),
> +				  .cra_alignmask = 0,
> +				  .cra_init = rk_cra_hash_init,
> +				  .cra_exit = rk_cra_hash_exit,
> +				  .cra_module = THIS_MODULE,
> +				  }
> +			 }
> +	}
> +};
> +
> +struct rk_crypto_tmp rk_ahash_md5 = {
> +	.type = ALG_TYPE_HASH,
> +	.alg.hash = {
> +		.init = rk_ahash_init,
> +		.update = rk_ahash_update,
> +		.final = rk_ahash_final,
> +		.finup = rk_ahash_finup,
> +		.digest = rk_ahash_digest,
> +		.halg = {
> +			 .digestsize = MD5_DIGEST_SIZE,
> +			 .statesize = sizeof(struct md5_state),
> +			 .base = {
> +				  .cra_name = "md5",
> +				  .cra_driver_name = "rk-md5",
> +				  .cra_priority = 300,
> +				  .cra_flags = CRYPTO_ALG_ASYNC |
> +					       CRYPTO_ALG_NEED_FALLBACK,

You said that the driver need a fallback, but I do not see any use of it.

Regards
