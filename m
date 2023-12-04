Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384C0D7
	for <linux-crypto@vger.kernel.org>; Sun,  3 Dec 2023 18:14:24 -0800 (PST)
Received: from kwepemm000005.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Sk6f31PBbzWj4w
	for <linux-crypto@vger.kernel.org>; Mon,  4 Dec 2023 10:13:31 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemm000005.china.huawei.com (7.193.23.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 10:14:21 +0800
Subject: Re: [PATCH 10/19] crypto: hisilicon/sec2 - Remove cfb and ofb
From: liulongfang <liulongfang@huawei.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Linux Crypto Mailing List
	<linux-crypto@vger.kernel.org>
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
 <E1r8g9A-005ILj-Sb@formenos.hmeau.com>
 <2f75977b-1383-908d-bf32-5084ef260c53@huawei.com>
Message-ID: <382efecd-5b2c-a328-3ef3-16d4b2b66590@huawei.com>
Date: Mon, 4 Dec 2023 10:14:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2f75977b-1383-908d-bf32-5084ef260c53@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm000005.china.huawei.com (7.193.23.27)
X-CFilter-Loop: Reflected

On 2023/12/1 11:37, liulongfang wrote:
> On 2023/11/30 20:28, Herbert Xu wrote:
>> Remove the unused CFB/OFB implementation.
>>
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>> ---
>>
>>  drivers/crypto/hisilicon/sec2/sec_crypto.c |   24 ------------------------
>>  1 file changed, 24 deletions(-)
>>
>> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
>> index 6fcabbc87860..a1b65391f792 100644
>> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
>> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
>> @@ -879,15 +879,11 @@ static int sec_setkey_##name(struct crypto_skcipher *tfm, const u8 *key,\
>>  GEN_SEC_SETKEY_FUNC(aes_ecb, SEC_CALG_AES, SEC_CMODE_ECB)
>>  GEN_SEC_SETKEY_FUNC(aes_cbc, SEC_CALG_AES, SEC_CMODE_CBC)
>>  GEN_SEC_SETKEY_FUNC(aes_xts, SEC_CALG_AES, SEC_CMODE_XTS)
>> -GEN_SEC_SETKEY_FUNC(aes_ofb, SEC_CALG_AES, SEC_CMODE_OFB)
>> -GEN_SEC_SETKEY_FUNC(aes_cfb, SEC_CALG_AES, SEC_CMODE_CFB)
>>  GEN_SEC_SETKEY_FUNC(aes_ctr, SEC_CALG_AES, SEC_CMODE_CTR)
>>  GEN_SEC_SETKEY_FUNC(3des_ecb, SEC_CALG_3DES, SEC_CMODE_ECB)
>>  GEN_SEC_SETKEY_FUNC(3des_cbc, SEC_CALG_3DES, SEC_CMODE_CBC)
>>  GEN_SEC_SETKEY_FUNC(sm4_xts, SEC_CALG_SM4, SEC_CMODE_XTS)
>>  GEN_SEC_SETKEY_FUNC(sm4_cbc, SEC_CALG_SM4, SEC_CMODE_CBC)
>> -GEN_SEC_SETKEY_FUNC(sm4_ofb, SEC_CALG_SM4, SEC_CMODE_OFB)
>> -GEN_SEC_SETKEY_FUNC(sm4_cfb, SEC_CALG_SM4, SEC_CMODE_CFB)
>>  GEN_SEC_SETKEY_FUNC(sm4_ctr, SEC_CALG_SM4, SEC_CMODE_CTR)
>>  
>>  static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
>> @@ -2197,16 +2193,6 @@ static struct sec_skcipher sec_skciphers[] = {
>>  		.alg = SEC_SKCIPHER_ALG("xts(aes)", sec_setkey_aes_xts,	SEC_XTS_MIN_KEY_SIZE,
>>  					SEC_XTS_MAX_KEY_SIZE, AES_BLOCK_SIZE, AES_BLOCK_SIZE),
>>  	},
>> -	{
>> -		.alg_msk = BIT(4),
>> -		.alg = SEC_SKCIPHER_ALG("ofb(aes)", sec_setkey_aes_ofb,	AES_MIN_KEY_SIZE,
>> -					AES_MAX_KEY_SIZE, SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE),
>> -	},
>> -	{
>> -		.alg_msk = BIT(5),
>> -		.alg = SEC_SKCIPHER_ALG("cfb(aes)", sec_setkey_aes_cfb,	AES_MIN_KEY_SIZE,
>> -					AES_MAX_KEY_SIZE, SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE),
>> -	},
>>  	{
>>  		.alg_msk = BIT(12),
>>  		.alg = SEC_SKCIPHER_ALG("cbc(sm4)", sec_setkey_sm4_cbc,	AES_MIN_KEY_SIZE,
>> @@ -2222,16 +2208,6 @@ static struct sec_skcipher sec_skciphers[] = {
>>  		.alg = SEC_SKCIPHER_ALG("xts(sm4)", sec_setkey_sm4_xts,	SEC_XTS_MIN_KEY_SIZE,
>>  					SEC_XTS_MIN_KEY_SIZE, AES_BLOCK_SIZE, AES_BLOCK_SIZE),
>>  	},
>> -	{
>> -		.alg_msk = BIT(15),
>> -		.alg = SEC_SKCIPHER_ALG("ofb(sm4)", sec_setkey_sm4_ofb,	AES_MIN_KEY_SIZE,
>> -					AES_MIN_KEY_SIZE, SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE),
>> -	},
>> -	{
>> -		.alg_msk = BIT(16),
>> -		.alg = SEC_SKCIPHER_ALG("cfb(sm4)", sec_setkey_sm4_cfb,	AES_MIN_KEY_SIZE,
>> -					AES_MIN_KEY_SIZE, SEC_MIN_BLOCK_SZ, AES_BLOCK_SIZE),
>> -	},
>>  	{
>>  		.alg_msk = BIT(23),
>>  		.alg = SEC_SKCIPHER_ALG("ecb(des3_ede)", sec_setkey_3des_ecb, SEC_DES3_3KEY_SIZE,
>>
>> .
>>
> Hi,Herbert:
> Removed OFB and CFB modes. There are still some codes that need to be deleted.
> I wrote the complete patch content below:
> 
> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
>  static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
> @@ -2032,8 +2028,6 @@ static int sec_skcipher_cryptlen_check(struct sec_ctx *ctx,
>  			ret = -EINVAL;
>  		}
>  		break;
> -	case SEC_CMODE_CFB:
> -	case SEC_CMODE_OFB:
>  	case SEC_CMODE_CTR:
>  		if (unlikely(ctx->sec->qm.ver < QM_HW_V3)) {
>  			dev_err(dev, "skcipher HW version error!\n");
> 
> 
> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.h
> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.h
> @@ -37,8 +37,6 @@ enum sec_mac_len {
>  enum sec_cmode {
>  	SEC_CMODE_ECB    = 0x0,
>  	SEC_CMODE_CBC    = 0x1,
> -	SEC_CMODE_CFB    = 0x2,
> -	SEC_CMODE_OFB    = 0x3,
>  	SEC_CMODE_CTR    = 0x4,
>  	SEC_CMODE_CCM    = 0x5,
>  	SEC_CMODE_GCM    = 0x6,
> 
>

Hi Herbert:
After reviewing the code, I found that there is still a place where the code
needs to be modified.
A register value indicating OFB and CFB modes needs to be updated:

--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -159,7 +159,7 @@ static const struct hisi_qm_cap_info sec_basic_info[] = {
 	{SEC_CORE_NUM_CAP, 0x313c, 8, GENMASK(7, 0), 0x4, 0x4, 0x4},
 	{SEC_CORES_PER_CLUSTER_NUM_CAP, 0x313c, 0, GENMASK(7, 0), 0x4, 0x4, 0x4},
 	{SEC_CORE_ENABLE_BITMAP, 0x3140, 32, GENMASK(31, 0), 0x17F, 0x17F, 0xF},
-	{SEC_DRV_ALG_BITMAP_LOW, 0x3144, 0, GENMASK(31, 0), 0x18050CB, 0x18050CB, 0x187F0FF},
+	{SEC_DRV_ALG_BITMAP_LOW, 0x3144, 0, GENMASK(31, 0), 0x18050CB, 0x18050CB, 0x18670CF},
 	{SEC_DRV_ALG_BITMAP_HIGH, 0x3148, 0, GENMASK(31, 0), 0x395C, 0x395C, 0x395C},
 	{SEC_DEV_ALG_BITMAP_LOW, 0x314c, 0, GENMASK(31, 0), 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF},
 	{SEC_DEV_ALG_BITMAP_HIGH, 0x3150, 0, GENMASK(31, 0), 0x3FFF, 0x3FFF, 0x3FFF},

Thanks,
Longfang.

> Thanks,
> Longfang.
> 
> .
> 
