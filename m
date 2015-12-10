From: Zain <zain.wang@rock-chips.com>
Subject: Re: [RFC PATCH V2] Crypto: rockchip/crypto - add hash support for
 crypto engine in rk3288
Date: Thu, 10 Dec 2015 09:24:01 +0800
Message-ID: <5668D431.8080407@rock-chips.com>
References: <1449656202-17363-1-git-send-email-zain.wang@rock-chips.com>
 <20151209105519.GB11883@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: heiko@sntech.de, herbert@gondor.apana.org.au, davem@davemloft.net,
	eddie.cai@rock-chips.com, linux-rockchip@lists.infradead.org,
	linux-crypto@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.138]:35017 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbbLJBYN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 20:24:13 -0500
In-Reply-To: <20151209105519.GB11883@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

=E5=9C=A8 2015=E5=B9=B412=E6=9C=8809=E6=97=A5 18:55, LABBE Corentin =E5=
=86=99=E9=81=93:
> Hello
>
> I have some comments below.
Thanks for your comments.:-)
>
> On Wed, Dec 09, 2015 at 06:16:42PM +0800, Zain Wang wrote:
>> Add md5 sha1 sha256 support for crypto engine in rk3288.
>> This patch can't support multiple updatings because of limited of IC=
,
>> as result, it can't support import and export too.
>>
>> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
>> ---
>>
>> Changes in V2:
>> - add some comments to code.
>> - fix some issues about zero message process.
>>
>>  drivers/crypto/rockchip/Makefile                   |   1 +
>>  drivers/crypto/rockchip/rk3288_crypto.c            |  33 +-
>>  drivers/crypto/rockchip/rk3288_crypto.h            |  50 ++-
>>  drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |  20 +-
>>  drivers/crypto/rockchip/rk3288_crypto_ahash.c      | 383 ++++++++++=
+++++++++++
>>  5 files changed, 469 insertions(+), 18 deletions(-)
>>  create mode 100644 drivers/crypto/rockchip/rk3288_crypto_ahash.c
>>
>> @@ -194,6 +221,12 @@ struct rk_crypto_info {
>>  			 struct scatterlist *sg_dst);
>>  	void (*unload_data)(struct rk_crypto_info *dev);
>>  };
>> +/* the private variable of hash */
>> +struct rk_ahash_ctx {
>> +	struct rk_crypto_info		*dev;
>> +	int				FLAG_FINUP;
> Why this variable is uppercase ?
There is no special reason, flag_finup may be better here.:-)
>
>> +
>> +
>> +static void zero_message_process(struct ahash_request *req)
>> +{
>> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
>> +	int rk_digest_size;
>> +
>> +	rk_digest_size =3D crypto_ahash_digestsize(tfm);
>> +
>> +	if (rk_digest_size =3D=3D SHA1_DIGEST_SIZE)
>> +		memcpy(req->result, sha1_zero_message_hash, rk_digest_size);
>> +	else if (rk_digest_size =3D=3D SHA256_DIGEST_SIZE)
>> +		memcpy(req->result, sha256_zero_message_hash, rk_digest_size);
>> +	else if (rk_digest_size =3D=3D MD5_DIGEST_SIZE)
>> +		memcpy(req->result, md5_zero_message_hash, rk_digest_size);
> A switch would be more pretty, and eventualy handle invalid rk_digest=
_size value.
Good idea. I will use a switch in next version.
>
>> +}
>> +
>> +static void rk_ahash_crypto_complete(struct rk_crypto_info *dev, in=
t err)
>> +{
>> +	if (dev->ahash_req->base.complete)
>> +		dev->ahash_req->base.complete(&dev->ahash_req->base, err);
>> +}
>> +
>> +static void rk_ahash_hw_init(struct rk_crypto_info *dev)
>> +{
>> +	int reg_status =3D 0;
>> +
>> +	reg_status =3D CRYPTO_READ(dev, RK_CRYPTO_CTRL) |
>> +		     RK_CRYPTO_HASH_FLUSH | _SBF(0xffff, 16);
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_CTRL, reg_status);
>> +
>> +	reg_status =3D CRYPTO_READ(dev, RK_CRYPTO_CTRL);
>> +	reg_status &=3D (~RK_CRYPTO_HASH_FLUSH);
>> +	reg_status |=3D _SBF(0xffff, 16);
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_CTRL, reg_status);
>> +
>> +	memset_io(dev->reg + RK_CRYPTO_HASH_DOUT_0, 0, 32);
>> +}
>> +
>> +static void rk_ahash_reg_init(struct rk_crypto_info *dev)
>> +{
>> +	rk_ahash_hw_init(dev);
>> +
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_INTENA, RK_CRYPTO_HRDMA_ERR_ENA |
>> +					    RK_CRYPTO_HRDMA_DONE_ENA);
>> +
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_INTSTS, RK_CRYPTO_HRDMA_ERR_INT |
>> +					    RK_CRYPTO_HRDMA_DONE_INT);
>> +
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_HASH_CTRL, dev->mode |
>> +					       RK_CRYPTO_HASH_SWAP_DO);
>> +
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_CONF, RK_CRYPTO_BYTESWAP_HRFIFO |
>> +					  RK_CRYPTO_BYTESWAP_BRFIFO |
>> +					  RK_CRYPTO_BYTESWAP_BTFIFO);
>> +}
>> +
>> +static int rk_ahash_init(struct ahash_request *req)
>> +{
>> +	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
>> +	struct rk_ahash_ctx *tctx =3D crypto_tfm_ctx(req->base.tfm);
>> +	struct rk_crypto_info *dev =3D NULL;
>> +	int rk_digest_size;
>> +
>> +	dev =3D tctx->dev;
>> +	dev->left_bytes =3D 0;
>> +	dev->aligned =3D 0;
>> +	dev->ahash_req =3D req;
>> +	dev->mode =3D 0;
>> +	dev->align_size =3D 4;
>> +	dev->sg_dst =3D NULL;
>> +
>> +	tctx->first_op =3D 1;
>> +
>> +	rk_digest_size =3D crypto_ahash_digestsize(tfm);
>> +	if (!rk_digest_size)
>> +		dev_err(dev->dev, "can't get digestsize\n");
> You print an error but continue, it is strange.
Hmm... It's my mistake.
=46irst, dev_warn more pretty then dev_err, if I want continuation.
And then I guess I can remove it if I made sure .digestsize had been se=
t
in rk_crypto_tmp.
>
>> +	if (rk_digest_size =3D=3D SHA1_DIGEST_SIZE)
>> +		dev->mode =3D RK_CRYPTO_HASH_SHA1;
>> +	else if (rk_digest_size =3D=3D SHA256_DIGEST_SIZE)
>> +		dev->mode =3D RK_CRYPTO_HASH_SHA256;
>> +	else if (rk_digest_size =3D=3D MD5_DIGEST_SIZE)
>> +		dev->mode =3D RK_CRYPTO_HASH_MD5;
> A switch will be better here.
Ok, it will be fixed in next version.
>
> Regards
>
>
>
>
Thanks,
Zain
