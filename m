Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C49C48BE9
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 10:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09DDE2063F
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 10:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbfFXKKG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 06:10:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8776 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730384AbfFXKKG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 06:10:06 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5OA79ir026073
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 06:10:05 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tasms02bn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 06:10:04 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.ibm.com>;
        Mon, 24 Jun 2019 11:10:03 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 24 Jun 2019 11:10:01 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5OAA0L742074156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 10:10:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19CCB42054;
        Mon, 24 Jun 2019 10:10:00 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E05EC42047;
        Mon, 24 Jun 2019 10:09:59 +0000 (GMT)
Received: from [10.0.2.15] (unknown [9.152.224.114])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jun 2019 10:09:59 +0000 (GMT)
Subject: Re: [RFC PATCH 02/30] crypto: s390/des - switch to new verification
 routines
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
 <20190622003112.31033-3-ard.biesheuvel@linaro.org>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Mon, 24 Jun 2019 12:10:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190622003112.31033-3-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19062410-0016-0000-0000-0000028BD53A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062410-0017-0000-0000-000032E94087
Message-Id: <a25731e1-236b-05bd-f211-788f1734d364@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240085
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22.06.19 02:30, Ard Biesheuvel wrote:
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/s390/crypto/des_s390.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
> index 1f9ab24dc048..4e4061885b0d 100644
> --- a/arch/s390/crypto/des_s390.c
> +++ b/arch/s390/crypto/des_s390.c
> @@ -15,7 +15,7 @@
>  #include <linux/crypto.h>
>  #include <linux/fips.h>
>  #include <crypto/algapi.h>
> -#include <crypto/des.h>
> +#include <crypto/internal/des.h>
>  #include <asm/cpacf.h>
>
>  #define DES3_KEY_SIZE	(3 * DES_KEY_SIZE)
> @@ -34,14 +34,11 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
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
> +	err = des_verify_key(tfm, key, key_len);
> +	if (unlikely(err))
> +		return err;
>
>  	memcpy(ctx->key, key, key_len);
>  	return 0;
> @@ -226,7 +223,7 @@ static int des3_setkey(struct crypto_tfm *tfm, const u8 *key,
>  	struct s390_des_ctx *ctx = crypto_tfm_ctx(tfm);
>  	int err;
>
> -	err = __des3_verify_key(&tfm->crt_flags, key);
> +	err = crypto_des3_ede_verify_key(tfm, key, key_len);
>  	if (unlikely(err))
>  		return err;
>
Fine with me, Thanks,
Acked-by: Harald Freudenberger <freude@linux.ibm.com>

