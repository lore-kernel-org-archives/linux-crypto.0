Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42346ECE588
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 10:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1B6A2089C
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 10:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfJOKOS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Oct 2019 06:14:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727307AbfJOKOS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Oct 2019 06:14:18 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9FAB0Xg086824
        for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2019 06:14:14 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vn9tq56ng-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2019 06:14:13 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.ibm.com>;
        Tue, 15 Oct 2019 11:14:09 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 15 Oct 2019 11:14:06 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9FADXE434341214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 10:13:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 751A142042;
        Tue, 15 Oct 2019 10:14:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37EA44204C;
        Tue, 15 Oct 2019 10:14:03 +0000 (GMT)
Received: from [10.0.2.15] (unknown [9.145.82.252])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Oct 2019 10:14:03 +0000 (GMT)
Subject: Re: [RFT PATCH 3/3] crypto: s390/des - convert to skcipher API
To:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-s390@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20191012201809.160500-1-ebiggers@kernel.org>
 <20191012201809.160500-4-ebiggers@kernel.org>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Tue, 15 Oct 2019 12:14:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191012201809.160500-4-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19101510-0012-0000-0000-00000358358D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101510-0013-0000-0000-000021934AD7
Message-Id: <5b517312-60a1-e7c4-645d-e23fccd666b0@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-15_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910150092
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12.10.19 22:18, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> Convert the glue code for the S390 CPACF implementations of DES-ECB,
> DES-CBC, DES-CTR, 3DES-ECB, 3DES-CBC, and 3DES-CTR from the deprecated
> "blkcipher" API to the "skcipher" API.  This is needed in order for the
> blkcipher API to be removed.
>
> Note: I made CTR use the same function for encryption and decryption,
> since CTR encryption and decryption are identical.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/s390/crypto/des_s390.c | 419 +++++++++++++++---------------------
>  1 file changed, 172 insertions(+), 247 deletions(-)
>
> diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
> index 439b100c6f2e..bfbafd35bcbd 100644
> --- a/arch/s390/crypto/des_s390.c
> +++ b/arch/s390/crypto/des_s390.c
> @@ -17,6 +17,7 @@
>  #include <linux/mutex.h>
>  #include <crypto/algapi.h>
>  #include <crypto/internal/des.h>
> +#include <crypto/internal/skcipher.h>
>  #include <asm/cpacf.h>
>  
>  #define DES3_KEY_SIZE	(3 * DES_KEY_SIZE)
> @@ -45,6 +46,12 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
>  	return 0;
>  }
>  
> +static int des_setkey_skcipher(struct crypto_skcipher *tfm, const u8 *key,
> +			       unsigned int key_len)
> +{
> +	return des_setkey(crypto_skcipher_tfm(tfm), key, key_len);
> +}
> +
>  static void s390_des_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>  	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
> @@ -79,28 +86,30 @@ static struct crypto_alg des_alg = {
>  	}
>  };
>  
> -static int ecb_desall_crypt(struct blkcipher_desc *desc, unsigned long fc,
> -			    struct blkcipher_walk *walk)
> +static int ecb_desall_crypt(struct skcipher_request *req, unsigned long fc)
>  {
> -	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct s390_des_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct skcipher_walk walk;
>  	unsigned int nbytes, n;
>  	int ret;
>  
> -	ret = blkcipher_walk_virt(desc, walk);
> -	while ((nbytes = walk->nbytes) >= DES_BLOCK_SIZE) {
> +	ret = skcipher_walk_virt(&walk, req, false);
> +	while ((nbytes = walk.nbytes) != 0) {
>  		/* only use complete blocks */
>  		n = nbytes & ~(DES_BLOCK_SIZE - 1);
> -		cpacf_km(fc, ctx->key, walk->dst.virt.addr,
> -			 walk->src.virt.addr, n);
> -		ret = blkcipher_walk_done(desc, walk, nbytes - n);
> +		cpacf_km(fc, ctx->key, walk.dst.virt.addr,
> +			 walk.src.virt.addr, n);
> +		ret = skcipher_walk_done(&walk, nbytes - n);
>  	}
>  	return ret;
>  }
>  
> -static int cbc_desall_crypt(struct blkcipher_desc *desc, unsigned long fc,
> -			    struct blkcipher_walk *walk)
> +static int cbc_desall_crypt(struct skcipher_request *req, unsigned long fc)
>  {
> -	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct s390_des_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct skcipher_walk walk;
>  	unsigned int nbytes, n;
>  	int ret;
>  	struct {
> @@ -108,99 +117,69 @@ static int cbc_desall_crypt(struct blkcipher_desc *desc, unsigned long fc,
>  		u8 key[DES3_KEY_SIZE];
>  	} param;
>  
> -	ret = blkcipher_walk_virt(desc, walk);
> -	memcpy(param.iv, walk->iv, DES_BLOCK_SIZE);
> +	ret = skcipher_walk_virt(&walk, req, false);
> +	if (ret)
> +		return ret;
> +	memcpy(param.iv, walk.iv, DES_BLOCK_SIZE);
>  	memcpy(param.key, ctx->key, DES3_KEY_SIZE);
> -	while ((nbytes = walk->nbytes) >= DES_BLOCK_SIZE) {
> +	while ((nbytes = walk.nbytes) != 0) {
>  		/* only use complete blocks */
>  		n = nbytes & ~(DES_BLOCK_SIZE - 1);
> -		cpacf_kmc(fc, &param, walk->dst.virt.addr,
> -			  walk->src.virt.addr, n);
> -		ret = blkcipher_walk_done(desc, walk, nbytes - n);
> +		cpacf_kmc(fc, &param, walk.dst.virt.addr,
> +			  walk.src.virt.addr, n);
> +		memcpy(walk.iv, param.iv, DES_BLOCK_SIZE);
> +		ret = skcipher_walk_done(&walk, nbytes - n);
>  	}
> -	memcpy(walk->iv, param.iv, DES_BLOCK_SIZE);
>  	return ret;
>  }
>  
> -static int ecb_des_encrypt(struct blkcipher_desc *desc,
> -			   struct scatterlist *dst, struct scatterlist *src,
> -			   unsigned int nbytes)
> +static int ecb_des_encrypt(struct skcipher_request *req)
>  {
> -	struct blkcipher_walk walk;
> -
> -	blkcipher_walk_init(&walk, dst, src, nbytes);
> -	return ecb_desall_crypt(desc, CPACF_KM_DEA, &walk);
> +	return ecb_desall_crypt(req, CPACF_KM_DEA);
>  }
>  
> -static int ecb_des_decrypt(struct blkcipher_desc *desc,
> -			   struct scatterlist *dst, struct scatterlist *src,
> -			   unsigned int nbytes)
> +static int ecb_des_decrypt(struct skcipher_request *req)
>  {
> -	struct blkcipher_walk walk;
> -
> -	blkcipher_walk_init(&walk, dst, src, nbytes);
> -	return ecb_desall_crypt(desc, CPACF_KM_DEA | CPACF_DECRYPT, &walk);
> +	return ecb_desall_crypt(req, CPACF_KM_DEA | CPACF_DECRYPT);
>  }
>  
> -static struct crypto_alg ecb_des_alg = {
> -	.cra_name		=	"ecb(des)",
> -	.cra_driver_name	=	"ecb-des-s390",
> -	.cra_priority		=	400,	/* combo: des + ecb */
> -	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
> -	.cra_blocksize		=	DES_BLOCK_SIZE,
> -	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
> -	.cra_type		=	&crypto_blkcipher_type,
> -	.cra_module		=	THIS_MODULE,
> -	.cra_u			=	{
> -		.blkcipher = {
> -			.min_keysize		=	DES_KEY_SIZE,
> -			.max_keysize		=	DES_KEY_SIZE,
> -			.setkey			=	des_setkey,
> -			.encrypt		=	ecb_des_encrypt,
> -			.decrypt		=	ecb_des_decrypt,
> -		}
> -	}
> +static struct skcipher_alg ecb_des_alg = {
> +	.base.cra_name		=	"ecb(des)",
> +	.base.cra_driver_name	=	"ecb-des-s390",
> +	.base.cra_priority	=	400,	/* combo: des + ecb */
> +	.base.cra_blocksize	=	DES_BLOCK_SIZE,
> +	.base.cra_ctxsize	=	sizeof(struct s390_des_ctx),
> +	.base.cra_module	=	THIS_MODULE,
> +	.min_keysize		=	DES_KEY_SIZE,
> +	.max_keysize		=	DES_KEY_SIZE,
> +	.setkey			=	des_setkey_skcipher,
> +	.encrypt		=	ecb_des_encrypt,
> +	.decrypt		=	ecb_des_decrypt,
>  };
>  
> -static int cbc_des_encrypt(struct blkcipher_desc *desc,
> -			   struct scatterlist *dst, struct scatterlist *src,
> -			   unsigned int nbytes)
> +static int cbc_des_encrypt(struct skcipher_request *req)
>  {
> -	struct blkcipher_walk walk;
> -
> -	blkcipher_walk_init(&walk, dst, src, nbytes);
> -	return cbc_desall_crypt(desc, CPACF_KMC_DEA, &walk);
> +	return cbc_desall_crypt(req, CPACF_KMC_DEA);
>  }
>  
> -static int cbc_des_decrypt(struct blkcipher_desc *desc,
> -			   struct scatterlist *dst, struct scatterlist *src,
> -			   unsigned int nbytes)
> +static int cbc_des_decrypt(struct skcipher_request *req)
>  {
> -	struct blkcipher_walk walk;
> -
> -	blkcipher_walk_init(&walk, dst, src, nbytes);
> -	return cbc_desall_crypt(desc, CPACF_KMC_DEA | CPACF_DECRYPT, &walk);
> +	return cbc_desall_crypt(req, CPACF_KMC_DEA | CPACF_DECRYPT);
>  }
>  
> -static struct crypto_alg cbc_des_alg = {
> -	.cra_name		=	"cbc(des)",
> -	.cra_driver_name	=	"cbc-des-s390",
> -	.cra_priority		=	400,	/* combo: des + cbc */
> -	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
> -	.cra_blocksize		=	DES_BLOCK_SIZE,
> -	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
> -	.cra_type		=	&crypto_blkcipher_type,
> -	.cra_module		=	THIS_MODULE,
> -	.cra_u			=	{
> -		.blkcipher = {
> -			.min_keysize		=	DES_KEY_SIZE,
> -			.max_keysize		=	DES_KEY_SIZE,
> -			.ivsize			=	DES_BLOCK_SIZE,
> -			.setkey			=	des_setkey,
> -			.encrypt		=	cbc_des_encrypt,
> -			.decrypt		=	cbc_des_decrypt,
> -		}
> -	}
> +static struct skcipher_alg cbc_des_alg = {
> +	.base.cra_name		=	"cbc(des)",
> +	.base.cra_driver_name	=	"cbc-des-s390",
> +	.base.cra_priority	=	400,	/* combo: des + cbc */
> +	.base.cra_blocksize	=	DES_BLOCK_SIZE,
> +	.base.cra_ctxsize	=	sizeof(struct s390_des_ctx),
> +	.base.cra_module	=	THIS_MODULE,
> +	.min_keysize		=	DES_KEY_SIZE,
> +	.max_keysize		=	DES_KEY_SIZE,
> +	.ivsize			=	DES_BLOCK_SIZE,
> +	.setkey			=	des_setkey_skcipher,
> +	.encrypt		=	cbc_des_encrypt,
> +	.decrypt		=	cbc_des_decrypt,
>  };
>  
>  /*
> @@ -232,6 +211,12 @@ static int des3_setkey(struct crypto_tfm *tfm, const u8 *key,
>  	return 0;
>  }
>  
> +static int des3_setkey_skcipher(struct crypto_skcipher *tfm, const u8 *key,
> +				unsigned int key_len)
> +{
> +	return des3_setkey(crypto_skcipher_tfm(tfm), key, key_len);
> +}
> +
>  static void des3_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
>  {
>  	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
> @@ -266,87 +251,53 @@ static struct crypto_alg des3_alg = {
>  	}
>  };
>  
> -static int ecb_des3_encrypt(struct blkcipher_desc *desc,
> -			    struct scatterlist *dst, struct scatterlist *src,
> -			    unsigned int nbytes)
> +static int ecb_des3_encrypt(struct skcipher_request *req)
>  {
> -	struct blkcipher_walk walk;
> -
> -	blkcipher_walk_init(&walk, dst, src, nbytes);
> -	return ecb_desall_crypt(desc, CPACF_KM_TDEA_192, &walk);
> +	return ecb_desall_crypt(req, CPACF_KM_TDEA_192);
>  }
>  
> -static int ecb_des3_decrypt(struct blkcipher_desc *desc,
> -			    struct scatterlist *dst, struct scatterlist *src,
> -			    unsigned int nbytes)
> +static int ecb_des3_decrypt(struct skcipher_request *req)
>  {
> -	struct blkcipher_walk walk;
> -
> -	blkcipher_walk_init(&walk, dst, src, nbytes);
> -	return ecb_desall_crypt(desc, CPACF_KM_TDEA_192 | CPACF_DECRYPT,
> -				&walk);
> +	return ecb_desall_crypt(req, CPACF_KM_TDEA_192 | CPACF_DECRYPT);
>  }
>  
> -static struct crypto_alg ecb_des3_alg = {
> -	.cra_name		=	"ecb(des3_ede)",
> -	.cra_driver_name	=	"ecb-des3_ede-s390",
> -	.cra_priority		=	400,	/* combo: des3 + ecb */
> -	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
> -	.cra_blocksize		=	DES_BLOCK_SIZE,
> -	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
> -	.cra_type		=	&crypto_blkcipher_type,
> -	.cra_module		=	THIS_MODULE,
> -	.cra_u			=	{
> -		.blkcipher = {
> -			.min_keysize		=	DES3_KEY_SIZE,
> -			.max_keysize		=	DES3_KEY_SIZE,
> -			.setkey			=	des3_setkey,
> -			.encrypt		=	ecb_des3_encrypt,
> -			.decrypt		=	ecb_des3_decrypt,
> -		}
> -	}
> +static struct skcipher_alg ecb_des3_alg = {
> +	.base.cra_name		=	"ecb(des3_ede)",
> +	.base.cra_driver_name	=	"ecb-des3_ede-s390",
> +	.base.cra_priority	=	400,	/* combo: des3 + ecb */
> +	.base.cra_blocksize	=	DES_BLOCK_SIZE,
> +	.base.cra_ctxsize	=	sizeof(struct s390_des_ctx),
> +	.base.cra_module	=	THIS_MODULE,
> +	.min_keysize		=	DES3_KEY_SIZE,
> +	.max_keysize		=	DES3_KEY_SIZE,
> +	.setkey			=	des3_setkey_skcipher,
> +	.encrypt		=	ecb_des3_encrypt,
> +	.decrypt		=	ecb_des3_decrypt,
>  };
>  
> -static int cbc_des3_encrypt(struct blkcipher_desc *desc,
> -			    struct scatterlist *dst, struct scatterlist *src,
> -			    unsigned int nbytes)
> +static int cbc_des3_encrypt(struct skcipher_request *req)
>  {
> -	struct blkcipher_walk walk;
> -
> -	blkcipher_walk_init(&walk, dst, src, nbytes);
> -	return cbc_desall_crypt(desc, CPACF_KMC_TDEA_192, &walk);
> +	return cbc_desall_crypt(req, CPACF_KMC_TDEA_192);
>  }
>  
> -static int cbc_des3_decrypt(struct blkcipher_desc *desc,
> -			    struct scatterlist *dst, struct scatterlist *src,
> -			    unsigned int nbytes)
> +static int cbc_des3_decrypt(struct skcipher_request *req)
>  {
> -	struct blkcipher_walk walk;
> -
> -	blkcipher_walk_init(&walk, dst, src, nbytes);
> -	return cbc_desall_crypt(desc, CPACF_KMC_TDEA_192 | CPACF_DECRYPT,
> -				&walk);
> +	return cbc_desall_crypt(req, CPACF_KMC_TDEA_192 | CPACF_DECRYPT);
>  }
>  
> -static struct crypto_alg cbc_des3_alg = {
> -	.cra_name		=	"cbc(des3_ede)",
> -	.cra_driver_name	=	"cbc-des3_ede-s390",
> -	.cra_priority		=	400,	/* combo: des3 + cbc */
> -	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
> -	.cra_blocksize		=	DES_BLOCK_SIZE,
> -	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
> -	.cra_type		=	&crypto_blkcipher_type,
> -	.cra_module		=	THIS_MODULE,
> -	.cra_u			=	{
> -		.blkcipher = {
> -			.min_keysize		=	DES3_KEY_SIZE,
> -			.max_keysize		=	DES3_KEY_SIZE,
> -			.ivsize			=	DES_BLOCK_SIZE,
> -			.setkey			=	des3_setkey,
> -			.encrypt		=	cbc_des3_encrypt,
> -			.decrypt		=	cbc_des3_decrypt,
> -		}
> -	}
> +static struct skcipher_alg cbc_des3_alg = {
> +	.base.cra_name		=	"cbc(des3_ede)",
> +	.base.cra_driver_name	=	"cbc-des3_ede-s390",
> +	.base.cra_priority	=	400,	/* combo: des3 + cbc */
> +	.base.cra_blocksize	=	DES_BLOCK_SIZE,
> +	.base.cra_ctxsize	=	sizeof(struct s390_des_ctx),
> +	.base.cra_module	=	THIS_MODULE,
> +	.min_keysize		=	DES3_KEY_SIZE,
> +	.max_keysize		=	DES3_KEY_SIZE,
> +	.ivsize			=	DES_BLOCK_SIZE,
> +	.setkey			=	des3_setkey_skcipher,
> +	.encrypt		=	cbc_des3_encrypt,
> +	.decrypt		=	cbc_des3_decrypt,
>  };
>  
>  static unsigned int __ctrblk_init(u8 *ctrptr, u8 *iv, unsigned int nbytes)
> @@ -364,128 +315,90 @@ static unsigned int __ctrblk_init(u8 *ctrptr, u8 *iv, unsigned int nbytes)
>  	return n;
>  }
>  
> -static int ctr_desall_crypt(struct blkcipher_desc *desc, unsigned long fc,
> -			    struct blkcipher_walk *walk)
> +static int ctr_desall_crypt(struct skcipher_request *req, unsigned long fc)
>  {
> -	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct s390_des_ctx *ctx = crypto_skcipher_ctx(tfm);
>  	u8 buf[DES_BLOCK_SIZE], *ctrptr;
> +	struct skcipher_walk walk;
>  	unsigned int n, nbytes;
>  	int ret, locked;
>  
>  	locked = mutex_trylock(&ctrblk_lock);
>  
> -	ret = blkcipher_walk_virt_block(desc, walk, DES_BLOCK_SIZE);
> -	while ((nbytes = walk->nbytes) >= DES_BLOCK_SIZE) {
> +	ret = skcipher_walk_virt(&walk, req, false);
> +	while ((nbytes = walk.nbytes) >= DES_BLOCK_SIZE) {
>  		n = DES_BLOCK_SIZE;
>  		if (nbytes >= 2*DES_BLOCK_SIZE && locked)
> -			n = __ctrblk_init(ctrblk, walk->iv, nbytes);
> -		ctrptr = (n > DES_BLOCK_SIZE) ? ctrblk : walk->iv;
> -		cpacf_kmctr(fc, ctx->key, walk->dst.virt.addr,
> -			    walk->src.virt.addr, n, ctrptr);
> +			n = __ctrblk_init(ctrblk, walk.iv, nbytes);
> +		ctrptr = (n > DES_BLOCK_SIZE) ? ctrblk : walk.iv;
> +		cpacf_kmctr(fc, ctx->key, walk.dst.virt.addr,
> +			    walk.src.virt.addr, n, ctrptr);
>  		if (ctrptr == ctrblk)
> -			memcpy(walk->iv, ctrptr + n - DES_BLOCK_SIZE,
> +			memcpy(walk.iv, ctrptr + n - DES_BLOCK_SIZE,
>  				DES_BLOCK_SIZE);
> -		crypto_inc(walk->iv, DES_BLOCK_SIZE);
> -		ret = blkcipher_walk_done(desc, walk, nbytes - n);
> +		crypto_inc(walk.iv, DES_BLOCK_SIZE);
> +		ret = skcipher_walk_done(&walk, nbytes - n);
>  	}
>  	if (locked)
>  		mutex_unlock(&ctrblk_lock);
>  	/* final block may be < DES_BLOCK_SIZE, copy only nbytes */
>  	if (nbytes) {
> -		cpacf_kmctr(fc, ctx->key, buf, walk->src.virt.addr,
> -			    DES_BLOCK_SIZE, walk->iv);
> -		memcpy(walk->dst.virt.addr, buf, nbytes);
> -		crypto_inc(walk->iv, DES_BLOCK_SIZE);
> -		ret = blkcipher_walk_done(desc, walk, 0);
> +		cpacf_kmctr(fc, ctx->key, buf, walk.src.virt.addr,
> +			    DES_BLOCK_SIZE, walk.iv);
> +		memcpy(walk.dst.virt.addr, buf, nbytes);
> +		crypto_inc(walk.iv, DES_BLOCK_SIZE);
> +		ret = skcipher_walk_done(&walk, 0);
>  	}
>  	return ret;
>  }
>  
> -static int ctr_des_encrypt(struct blkcipher_desc *desc,
> -			   struct scatterlist *dst, struct scatterlist *src,
> -			   unsigned int nbytes)
> -{
> -	struct blkcipher_walk walk;
> -
> -	blkcipher_walk_init(&walk, dst, src, nbytes);
> -	return ctr_desall_crypt(desc, CPACF_KMCTR_DEA, &walk);
> -}
> -
> -static int ctr_des_decrypt(struct blkcipher_desc *desc,
> -			   struct scatterlist *dst, struct scatterlist *src,
> -			   unsigned int nbytes)
> +static int ctr_des_crypt(struct skcipher_request *req)
>  {
> -	struct blkcipher_walk walk;
> -
> -	blkcipher_walk_init(&walk, dst, src, nbytes);
> -	return ctr_desall_crypt(desc, CPACF_KMCTR_DEA | CPACF_DECRYPT, &walk);
> +	return ctr_desall_crypt(req, CPACF_KMCTR_DEA);
>  }
>  
> -static struct crypto_alg ctr_des_alg = {
> -	.cra_name		=	"ctr(des)",
> -	.cra_driver_name	=	"ctr-des-s390",
> -	.cra_priority		=	400,	/* combo: des + ctr */
> -	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
> -	.cra_blocksize		=	1,
> -	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
> -	.cra_type		=	&crypto_blkcipher_type,
> -	.cra_module		=	THIS_MODULE,
> -	.cra_u			=	{
> -		.blkcipher = {
> -			.min_keysize		=	DES_KEY_SIZE,
> -			.max_keysize		=	DES_KEY_SIZE,
> -			.ivsize			=	DES_BLOCK_SIZE,
> -			.setkey			=	des_setkey,
> -			.encrypt		=	ctr_des_encrypt,
> -			.decrypt		=	ctr_des_decrypt,
> -		}
> -	}
> +static struct skcipher_alg ctr_des_alg = {
> +	.base.cra_name		=	"ctr(des)",
> +	.base.cra_driver_name	=	"ctr-des-s390",
> +	.base.cra_priority	=	400,	/* combo: des + ctr */
> +	.base.cra_blocksize	=	1,
> +	.base.cra_ctxsize	=	sizeof(struct s390_des_ctx),
> +	.base.cra_module	=	THIS_MODULE,
> +	.min_keysize		=	DES_KEY_SIZE,
> +	.max_keysize		=	DES_KEY_SIZE,
> +	.ivsize			=	DES_BLOCK_SIZE,
> +	.setkey			=	des_setkey_skcipher,
> +	.encrypt		=	ctr_des_crypt,
> +	.decrypt		=	ctr_des_crypt,
> +	.chunksize		=	DES_BLOCK_SIZE,
>  };
>  
> -static int ctr_des3_encrypt(struct blkcipher_desc *desc,
> -			    struct scatterlist *dst, struct scatterlist *src,
> -			    unsigned int nbytes)
> -{
> -	struct blkcipher_walk walk;
> -
> -	blkcipher_walk_init(&walk, dst, src, nbytes);
> -	return ctr_desall_crypt(desc, CPACF_KMCTR_TDEA_192, &walk);
> -}
> -
> -static int ctr_des3_decrypt(struct blkcipher_desc *desc,
> -			    struct scatterlist *dst, struct scatterlist *src,
> -			    unsigned int nbytes)
> +static int ctr_des3_crypt(struct skcipher_request *req)
>  {
> -	struct blkcipher_walk walk;
> -
> -	blkcipher_walk_init(&walk, dst, src, nbytes);
> -	return ctr_desall_crypt(desc, CPACF_KMCTR_TDEA_192 | CPACF_DECRYPT,
> -				&walk);
> +	return ctr_desall_crypt(req, CPACF_KMCTR_TDEA_192);
>  }
>  
> -static struct crypto_alg ctr_des3_alg = {
> -	.cra_name		=	"ctr(des3_ede)",
> -	.cra_driver_name	=	"ctr-des3_ede-s390",
> -	.cra_priority		=	400,	/* combo: des3 + ede */
> -	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
> -	.cra_blocksize		=	1,
> -	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
> -	.cra_type		=	&crypto_blkcipher_type,
> -	.cra_module		=	THIS_MODULE,
> -	.cra_u			=	{
> -		.blkcipher = {
> -			.min_keysize		=	DES3_KEY_SIZE,
> -			.max_keysize		=	DES3_KEY_SIZE,
> -			.ivsize			=	DES_BLOCK_SIZE,
> -			.setkey			=	des3_setkey,
> -			.encrypt		=	ctr_des3_encrypt,
> -			.decrypt		=	ctr_des3_decrypt,
> -		}
> -	}
> +static struct skcipher_alg ctr_des3_alg = {
> +	.base.cra_name		=	"ctr(des3_ede)",
> +	.base.cra_driver_name	=	"ctr-des3_ede-s390",
> +	.base.cra_priority	=	400,	/* combo: des3 + ede */
> +	.base.cra_blocksize	=	1,
> +	.base.cra_ctxsize	=	sizeof(struct s390_des_ctx),
> +	.base.cra_module	=	THIS_MODULE,
> +	.min_keysize		=	DES3_KEY_SIZE,
> +	.max_keysize		=	DES3_KEY_SIZE,
> +	.ivsize			=	DES_BLOCK_SIZE,
> +	.setkey			=	des3_setkey_skcipher,
> +	.encrypt		=	ctr_des3_crypt,
> +	.decrypt		=	ctr_des3_crypt,
> +	.chunksize		=	DES_BLOCK_SIZE,
>  };
>  
> -static struct crypto_alg *des_s390_algs_ptr[8];
> +static struct crypto_alg *des_s390_algs_ptr[2];
>  static int des_s390_algs_num;
> +static struct skcipher_alg *des_s390_skciphers_ptr[6];
> +static int des_s390_skciphers_num;
>  
>  static int des_s390_register_alg(struct crypto_alg *alg)
>  {
> @@ -497,10 +410,22 @@ static int des_s390_register_alg(struct crypto_alg *alg)
>  	return ret;
>  }
>  
> +static int des_s390_register_skcipher(struct skcipher_alg *alg)
> +{
> +	int ret;
> +
> +	ret = crypto_register_skcipher(alg);
> +	if (!ret)
> +		des_s390_skciphers_ptr[des_s390_skciphers_num++] = alg;
> +	return ret;
> +}
> +
>  static void des_s390_exit(void)
>  {
>  	while (des_s390_algs_num--)
>  		crypto_unregister_alg(des_s390_algs_ptr[des_s390_algs_num]);
> +	while (des_s390_skciphers_num--)
> +		crypto_unregister_skcipher(des_s390_skciphers_ptr[des_s390_skciphers_num]);
>  	if (ctrblk)
>  		free_page((unsigned long) ctrblk);
>  }
> @@ -518,12 +443,12 @@ static int __init des_s390_init(void)
>  		ret = des_s390_register_alg(&des_alg);
>  		if (ret)
>  			goto out_err;
> -		ret = des_s390_register_alg(&ecb_des_alg);
> +		ret = des_s390_register_skcipher(&ecb_des_alg);
>  		if (ret)
>  			goto out_err;
>  	}
>  	if (cpacf_test_func(&kmc_functions, CPACF_KMC_DEA)) {
> -		ret = des_s390_register_alg(&cbc_des_alg);
> +		ret = des_s390_register_skcipher(&cbc_des_alg);
>  		if (ret)
>  			goto out_err;
>  	}
> @@ -531,12 +456,12 @@ static int __init des_s390_init(void)
>  		ret = des_s390_register_alg(&des3_alg);
>  		if (ret)
>  			goto out_err;
> -		ret = des_s390_register_alg(&ecb_des3_alg);
> +		ret = des_s390_register_skcipher(&ecb_des3_alg);
>  		if (ret)
>  			goto out_err;
>  	}
>  	if (cpacf_test_func(&kmc_functions, CPACF_KMC_TDEA_192)) {
> -		ret = des_s390_register_alg(&cbc_des3_alg);
> +		ret = des_s390_register_skcipher(&cbc_des3_alg);
>  		if (ret)
>  			goto out_err;
>  	}
> @@ -551,12 +476,12 @@ static int __init des_s390_init(void)
>  	}
>  
>  	if (cpacf_test_func(&kmctr_functions, CPACF_KMCTR_DEA)) {
> -		ret = des_s390_register_alg(&ctr_des_alg);
> +		ret = des_s390_register_skcipher(&ctr_des_alg);
>  		if (ret)
>  			goto out_err;
>  	}
>  	if (cpacf_test_func(&kmctr_functions, CPACF_KMCTR_TDEA_192)) {
> -		ret = des_s390_register_alg(&ctr_des3_alg);
> +		ret = des_s390_register_skcipher(&ctr_des3_alg);
>  		if (ret)
>  			goto out_err;
>  	}

Tested with extended selftests and own tests via AF_ALG interface, works.
Thanks for this great work.
reviewed-by: Harald Freudenberger <freude@linux.ibm.com>

