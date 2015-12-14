From: Zain <zain.wang@rock-chips.com>
Subject: Re: [RFC PATCH V3] Crypto: rockchip/crypto - add hash support for
 crypto engine in rk3288
Date: Mon, 14 Dec 2015 09:50:38 +0800
Message-ID: <566E206E.7000802@rock-chips.com>
References: <1449799103-24221-1-git-send-email-zain.wang@rock-chips.com>
 <20151211085458.GA14705@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: heiko@sntech.de, herbert@gondor.apana.org.au, davem@davemloft.net,
	eddie.cai@rock-chips.com, linux-rockchip@lists.infradead.org,
	linux-crypto@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.138]:34894 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbbLNBu5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 13 Dec 2015 20:50:57 -0500
In-Reply-To: <20151211085458.GA14705@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

=E5=9C=A8 2015=E5=B9=B412=E6=9C=8811=E6=97=A5 16:54, LABBE Corentin =E5=
=86=99=E9=81=93:
> Hello
>
> I have some minor comments below.
>
> On Fri, Dec 11, 2015 at 09:58:23AM +0800, Zain Wang wrote:
>> Add md5 sha1 sha256 support for crypto engine in rk3288.
>> This patch can't support multiple updatings because of limited of IC=
,
>> as result, it can't support import and export too.
>>
>> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
>> ---
>>
>> Changes in V3:
>> - add switch instead of multiple if.
>>
>> Changes in V2:
>> - add some comments to code.
>> - fix some issues about zero message process.
>>
>>  drivers/crypto/rockchip/Makefile                   |   1 +
>>  drivers/crypto/rockchip/rk3288_crypto.c            |  33 +-
>>  drivers/crypto/rockchip/rk3288_crypto.h            |  50 ++-
>>  drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |  20 +-
>>  drivers/crypto/rockchip/rk3288_crypto_ahash.c      | 394 ++++++++++=
+++++++++++
>>  5 files changed, 480 insertions(+), 18 deletions(-)
>>  create mode 100644 drivers/crypto/rockchip/rk3288_crypto_ahash.c
>>
>> diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypt=
o/rockchip/rk3288_crypto.h
>> index 604ffe7..01d8299 100644
>> --- a/drivers/crypto/rockchip/rk3288_crypto.h
>> +++ b/drivers/crypto/rockchip/rk3288_crypto.h
>> @@ -6,6 +6,10 @@
>>  #include <crypto/algapi.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/delay.h>
>> +#include <crypto/internal/hash.h>
>> +
>> +#include "crypto/md5.h"
>> +#include "crypto/sha.h"
> It is proper to include with <> not ""
Ok, done!
>> diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers=
/crypto/rockchip/rk3288_crypto_ahash.c
>> new file mode 100644
>> index 0000000..a5795f6
>> --- /dev/null
>> +++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
>> @@ -0,0 +1,394 @@
>> +/*
>> + * Crypto acceleration support for Rockchip RK3288
>> + *
>> + * Copyright (c) 2015, Fuzhou Rockchip Electronics Co., Ltd
>> + *
>> + * Author: Zain Wang <zain.wang@rock-chips.com>
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify it
>> + * under the terms and conditions of the GNU General Public License=
,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * Some ideas are from marvell/cesa.c and s5p-sss.c driver.
>> + */
>> +#include "rk3288_crypto.h"
>> +
>> +/*
>> + * IC can not process zero message hash,
>> + * so we put the fixed hash out when met zero message.
>> + */
>> +const static u8 *sha1_zero_message_hash =3D {
>> +	"\xda\x39\xa3\xee\x5e\x6b\x4b\x0d\x32\x55"
>> +	"\xbf\xef\x95\x60\x18\x90\xaf\xd8\x07\x09"
>> +};
>> +
>> +const static u8 *sha256_zero_message_hash =3D {
>> +	"\xe3\xb0\xc4\x42\x98\xfc\x1c\x14"
>> +	"\x9a\xfb\xf4\xc8\x99\x6f\xb9\x24"
>> +	"\x27\xae\x41\xe4\x64\x9b\x93\x4c"
>> +	"\xa4\x95\x99\x1b\x78\x52\xb8\x55"
>> +};
>> +
>> +const static u8 *md5_zero_message_hash =3D {
>> +	"\xd4\x1d\x8c\xd9\x8f\x00\xb2\x04"
>> +	"\xe9\x80\x09\x98\xec\xf8\x42\x7e"
>> +};
>> +
>> +
>> +static int zero_message_process(struct ahash_request *req)
>> +{
>> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
>> +
>> +	switch (crypto_ahash_digestsize(tfm)) {
>> +	case SHA1_DIGEST_SIZE:
>> +		memcpy(req->result, sha1_zero_message_hash, SHA1_DIGEST_SIZE);
>> +		break;
>> +	case SHA256_DIGEST_SIZE:
>> +		memcpy(req->result, sha256_zero_message_hash,
>> +		       SHA256_DIGEST_SIZE);
>> +		break;
>> +	case MD5_DIGEST_SIZE:
>> +		memcpy(req->result, md5_zero_message_hash, MD5_DIGEST_SIZE);
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +		break;
>> +	}
> You could store crypto_ahash_digestsize result and use it in memcpy.
> You could also store the name of xxx_zero_message_hash in crypto_alg =
like n2 do.
> Perhaps a combination of the two could produce more generic code.
You are right, it will fix it as your first way.
>> +struct rk_crypto_tmp rk_ahash_sha256 =3D {
>> +	.type =3D ALG_TYPE_HASH,
>> +	.alg.hash =3D {
>> +	.init =3D rk_ahash_init,
>> +	.update =3D rk_ahash_update,
>> +	.final =3D rk_ahash_final,
>> +	.finup =3D rk_ahash_finup,
>> +	.digest =3D rk_ahash_digest,
>> +		.halg =3D {
>> +			 .digestsize =3D SHA256_DIGEST_SIZE,
>> +			 .statesize =3D sizeof(struct sha256_state),
>> +			 .base =3D {
>> +				  .cra_name =3D "sha256",
>> +				  .cra_driver_name =3D "rk-sha256",
>> +				  .cra_priority =3D 300,
>> +				  .cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					       CRYPTO_ALG_NEED_FALLBACK,
>> +				  .cra_blocksize =3D SHA256_BLOCK_SIZE,
>> +				  .cra_ctxsize =3D sizeof(struct rk_ahash_ctx),
>> +				  .cra_alignmask =3D 0,
>> +				  .cra_init =3D rk_cra_hash_init,
>> +				  .cra_exit =3D rk_cra_hash_exit,
>> +				  .cra_module =3D THIS_MODULE,
>> +				  }
>> +			 }
>> +	}
>> +};
>> +
>> +struct rk_crypto_tmp rk_ahash_md5 =3D {
>> +	.type =3D ALG_TYPE_HASH,
>> +	.alg.hash =3D {
>> +		.init =3D rk_ahash_init,
>> +		.update =3D rk_ahash_update,
>> +		.final =3D rk_ahash_final,
>> +		.finup =3D rk_ahash_finup,
>> +		.digest =3D rk_ahash_digest,
>> +		.halg =3D {
>> +			 .digestsize =3D MD5_DIGEST_SIZE,
>> +			 .statesize =3D sizeof(struct md5_state),
>> +			 .base =3D {
>> +				  .cra_name =3D "md5",
>> +				  .cra_driver_name =3D "rk-md5",
>> +				  .cra_priority =3D 300,
>> +				  .cra_flags =3D CRYPTO_ALG_ASYNC |
>> +					       CRYPTO_ALG_NEED_FALLBACK,
> You said that the driver need a fallback, but I do not see any use of=
 it.
I will remove it.
The idea of this part is from mv_ceas.c, and I forgot to remove it that
I did not use a fallback actually.:'(
>
> Regards
>
>
>
>
Thanks,
Zain
