Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 714CCC31E40
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 06:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C85B2086D
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 06:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbfHFGM6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 02:12:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5464 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731560AbfHFGM6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 02:12:58 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x766CNMI038798
        for <linux-crypto@vger.kernel.org>; Tue, 6 Aug 2019 02:12:57 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2u732g9wjy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2019 02:12:56 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.ibm.com>;
        Tue, 6 Aug 2019 07:12:54 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 6 Aug 2019 07:12:51 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x766CoDv23199800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Aug 2019 06:12:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAB654204B;
        Tue,  6 Aug 2019 06:12:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7383A4203F;
        Tue,  6 Aug 2019 06:12:50 +0000 (GMT)
Received: from [10.0.2.15] (unknown [9.152.224.114])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Aug 2019 06:12:50 +0000 (GMT)
Subject: Re: [PATCH v4 02/30] crypto: s390/des - switch to new verification
 routines
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
 <20190805170037.31330-3-ard.biesheuvel@linaro.org>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Tue, 6 Aug 2019 08:12:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805170037.31330-3-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19080606-0008-0000-0000-00000305AC71
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19080606-0009-0000-0000-0000A17FB431
Message-Id: <db6265bc-b460-a4a0-f3ed-9635cc618b6e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060074
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 05.08.19 19:00, Ard Biesheuvel wrote:
> Acked-by: Harald Freudenberger <freude@linux.ibm.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/s390/crypto/des_s390.c | 25 +++++++++-----------
>  1 file changed, 11 insertions(+), 14 deletions(-)
>
> diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
> index 374b42fc7637..f56a84751fdb 100644
> --- a/arch/s390/crypto/des_s390.c
> +++ b/arch/s390/crypto/des_s390.c
> @@ -16,7 +16,7 @@
>  #include <linux/fips.h>
>  #include <linux/mutex.h>
>  #include <crypto/algapi.h>
> -#include <crypto/des.h>
> +#include <crypto/internal/des.h>
>  #include <asm/cpacf.h>
>
>  #define DES3_KEY_SIZE	(3 * DES_KEY_SIZE)
> @@ -35,27 +35,24 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
>  		      unsigned int key_len)
>  {
>  	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
> -	u32 tmp[DES_EXPKEY_WORDS];
> +	int err;
>
> -	/* check for weak keys */
> -	if (!des_ekey(tmp, key) &&
> -	    (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
> -		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
> -		return -EINVAL;
> -	}
> +	err = crypto_des_verify_key(tfm, key);
> +	if (err)
> +		return err;
>
>  	memcpy(ctx->key, key, key_len);
>  	return 0;
>  }
>
> -static void des_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +static void crypto_des_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>  	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
>
>  	cpacf_km(CPACF_KM_DEA, ctx->key, out, in, DES_BLOCK_SIZE);
>  }
>
> -static void des_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +static void crypto_des_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>  	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
>
> @@ -76,8 +73,8 @@ static struct crypto_alg des_alg = {
>  			.cia_min_keysize	=	DES_KEY_SIZE,
>  			.cia_max_keysize	=	DES_KEY_SIZE,
>  			.cia_setkey		=	des_setkey,
> -			.cia_encrypt		=	des_encrypt,
> -			.cia_decrypt		=	des_decrypt,
> +			.cia_encrypt		=	crypto_des_encrypt,
> +			.cia_decrypt		=	crypto_des_decrypt,
>  		}
>  	}
>  };
> @@ -227,8 +224,8 @@ static int des3_setkey(struct crypto_tfm *tfm, const u8 *key,
>  	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
>  	int err;
>
> -	err = __des3_verify_key(&tfm->crt_flags, key);
> -	if (unlikely(err))
> +	err = crypto_des3_ede_verify_key(tfm, key);
> +	if (err)
>  		return err;
>
>  	memcpy(ctx->key, key, key_len);

add my

reviewed-by Harald Freudenberger <freude@de.ibm.com>

however, could you please choose another prefix when there's a symbol
collision instead of the "crypto_" maybe "s390_" or something like "des_s390_xxx".
Thanks

