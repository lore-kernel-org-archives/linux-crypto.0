Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A74C4361B
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 02:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B0EB239E5
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 02:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgLPCdT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Dec 2020 21:33:19 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9448 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbgLPCdT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Dec 2020 21:33:19 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CwfKM1vggzhrLl;
        Wed, 16 Dec 2020 10:32:07 +0800 (CST)
Received: from [10.67.103.10] (10.67.103.10) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Wed, 16 Dec 2020
 10:32:29 +0800
Subject: Re: Fwd: Re: [PATCH v4 3/5] crypto: expose elliptic curve parameters
 as Crypto APIs
To:     Vitaly Chikunov <vt@altlinux.org>
References: <20201211131349.pe6i5wafg2kq2w35@altlinux.org>
 <75a25392-464d-b76e-ba92-4287e24acbf7@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
From:   yumeng <yumeng18@huawei.com>
Message-ID: <b8746428-dfbd-145d-ed3a-4420c49d14bf@huawei.com>
Date:   Wed, 16 Dec 2020 10:32:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <75a25392-464d-b76e-ba92-4287e24acbf7@huawei.com>
Content-Type: text/plain; charset="koi8-r"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.10]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> Meng,
> 
> It looks like not just definitions but some static data is moved to
> includes. Why?
> 
> Thanks,

Yes, as both 'crypto' and HPRE use elliptic curves parameters, once
we keep them in 'include/crypto/ecc_curve_defs.h', crypto drivers
can use curves parameters without redefining them.

Thanks,


> On Fri, Dec 11, 2020 at 02:30:32PM +0800, Meng Yu wrote:
>> Move elliptic curves definition to 'include/crypto/ecc_curve_defs.h',
>> so all can use it,
>> 
>> Signed-off-by: Meng Yu <yumeng18@huawei.com>
>> Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
>> ---
>>  crypto/ecc.c                    |  1 -
>>  crypto/ecc.h                    | 37 +----------------
>>  crypto/ecc_curve_defs.h         | 57 -------------------------
>>  crypto/ecrdsa_defs.h            |  2 +-
>>  include/crypto/ecc_curve_defs.h | 92 +++++++++++++++++++++++++++++++++++++++++
>>  5 files changed, 95 insertions(+), 94 deletions(-)
>>  delete mode 100644 crypto/ecc_curve_defs.h
>>  create mode 100644 include/crypto/ecc_curve_defs.h
>> 
>> diff --git a/crypto/ecc.c b/crypto/ecc.c
>> index c80aa25..f23efdd 100644
>> --- a/crypto/ecc.c
>> +++ b/crypto/ecc.c
>> @@ -35,7 +35,6 @@
>>  #include <linux/ratelimit.h>
>>  
>>  #include "ecc.h"
>> -#include "ecc_curve_defs.h"
>>  
>>  typedef struct {
>>  	u64 m_low;
>> diff --git a/crypto/ecc.h b/crypto/ecc.h
>> index d4e546b..e5afaf3 100644
>> --- a/crypto/ecc.h
>> +++ b/crypto/ecc.h
>> @@ -26,6 +26,8 @@
>>  #ifndef _CRYPTO_ECC_H
>>  #define _CRYPTO_ECC_H
>>  
>> +#include <crypto/ecc_curve_defs.h>
>> +
>>  /* One digit is u64 qword. */
>>  #define ECC_CURVE_NIST_P192_DIGITS  3
>>  #define ECC_CURVE_NIST_P256_DIGITS  4
>> @@ -33,44 +35,9 @@
>>  
>>  #define ECC_DIGITS_TO_BYTES_SHIFT 3
>>  
>> -/**
>> - * struct ecc_point - elliptic curve point in affine coordinates
>> - *
>> - * @x:		X coordinate in vli form.
>> - * @y:		Y coordinate in vli form.
>> - * @ndigits:	Length of vlis in u64 qwords.
>> - */
>> -struct ecc_point {
>> -	u64 *x;
>> -	u64 *y;
>> -	u8 ndigits;
>> -};
>> -
>>  #define ECC_POINT_INIT(x, y, ndigits)	(struct ecc_point) { x, y, ndigits }
>>  
>>  /**
>> - * struct ecc_curve - definition of elliptic curve
>> - *
>> - * @name:	Short name of the curve.
>> - * @g:		Generator point of the curve.
>> - * @p:		Prime number, if Barrett's reduction is used for this curve
>> - *		pre-calculated value 'mu' is appended to the @p after ndigits.
>> - *		Use of Barrett's reduction is heuristically determined in
>> - *		vli_mmod_fast().
>> - * @n:		Order of the curve group.
>> - * @a:		Curve parameter a.
>> - * @b:		Curve parameter b.
>> - */
>> -struct ecc_curve {
>> -	char *name;
>> -	struct ecc_point g;
>> -	u64 *p;
>> -	u64 *n;
>> -	u64 *a;
>> -	u64 *b;
>> -};
>> -
>> -/**
>>   * ecc_is_key_valid() - Validate a given ECDH private key
>>   *
>>   * @curve_id:		id representing the curve to use
>> diff --git a/crypto/ecc_curve_defs.h b/crypto/ecc_curve_defs.h
>> deleted file mode 100644
>> index 69be6c7..0000000
>> --- a/crypto/ecc_curve_defs.h
>> +++ /dev/null
>> @@ -1,57 +0,0 @@
>> -/* SPDX-License-Identifier: GPL-2.0 */
>> -#ifndef _CRYTO_ECC_CURVE_DEFS_H
>> -#define _CRYTO_ECC_CURVE_DEFS_H
>> -
>> -/* NIST P-192: a = p - 3 */
>> -static u64 nist_p192_g_x[] = { 0xF4FF0AFD82FF1012ull, 0x7CBF20EB43A18800ull,
>> -				0x188DA80EB03090F6ull };
>> -static u64 nist_p192_g_y[] = { 0x73F977A11E794811ull, 0x631011ED6B24CDD5ull,
>> -				0x07192B95FFC8DA78ull };
>> -static u64 nist_p192_p[] = { 0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFEull,
>> -				0xFFFFFFFFFFFFFFFFull };
>> -static u64 nist_p192_n[] = { 0x146BC9B1B4D22831ull, 0xFFFFFFFF99DEF836ull,
>> -				0xFFFFFFFFFFFFFFFFull };
>> -static u64 nist_p192_a[] = { 0xFFFFFFFFFFFFFFFCull, 0xFFFFFFFFFFFFFFFEull,
>> -				0xFFFFFFFFFFFFFFFFull };
>> -static u64 nist_p192_b[] = { 0xFEB8DEECC146B9B1ull, 0x0FA7E9AB72243049ull,
>> -				0x64210519E59C80E7ull };
>> -static struct ecc_curve nist_p192 = {
>> -	.name = "nist_192",
>> -	.g = {
>> -		.x = nist_p192_g_x,
>> -		.y = nist_p192_g_y,
>> -		.ndigits = 3,
>> -	},
>> -	.p = nist_p192_p,
>> -	.n = nist_p192_n,
>> -	.a = nist_p192_a,
>> -	.b = nist_p192_b
>> -};
>> -
>> -/* NIST P-256: a = p - 3 */
>> -static u64 nist_p256_g_x[] = { 0xF4A13945D898C296ull, 0x77037D812DEB33A0ull,
>> -				0xF8BCE6E563A440F2ull, 0x6B17D1F2E12C4247ull };
>> -static u64 nist_p256_g_y[] = { 0xCBB6406837BF51F5ull, 0x2BCE33576B315ECEull,
>> -				0x8EE7EB4A7C0F9E16ull, 0x4FE342E2FE1A7F9Bull };
>> -static u64 nist_p256_p[] = { 0xFFFFFFFFFFFFFFFFull, 0x00000000FFFFFFFFull,
>> -				0x0000000000000000ull, 0xFFFFFFFF00000001ull };
>> -static u64 nist_p256_n[] = { 0xF3B9CAC2FC632551ull, 0xBCE6FAADA7179E84ull,
>> -				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFF00000000ull };
>> -static u64 nist_p256_a[] = { 0xFFFFFFFFFFFFFFFCull, 0x00000000FFFFFFFFull,
>> -				0x0000000000000000ull, 0xFFFFFFFF00000001ull };
>> -static u64 nist_p256_b[] = { 0x3BCE3C3E27D2604Bull, 0x651D06B0CC53B0F6ull,
>> -				0xB3EBBD55769886BCull, 0x5AC635D8AA3A93E7ull };
>> -static struct ecc_curve nist_p256 = {
>> -	.name = "nist_256",
>> -	.g = {
>> -		.x = nist_p256_g_x,
>> -		.y = nist_p256_g_y,
>> -		.ndigits = 4,
>> -	},
>> -	.p = nist_p256_p,
>> -	.n = nist_p256_n,
>> -	.a = nist_p256_a,
>> -	.b = nist_p256_b
>> -};
>> -
>> -#endif
>> diff --git a/crypto/ecrdsa_defs.h b/crypto/ecrdsa_defs.h
>> index 170baf0..2074099 100644
>> --- a/crypto/ecrdsa_defs.h
>> +++ b/crypto/ecrdsa_defs.h
>> @@ -13,7 +13,7 @@
>>  #ifndef _CRYTO_ECRDSA_DEFS_H
>>  #define _CRYTO_ECRDSA_DEFS_H
>>  
>> -#include "ecc.h"
>> +#include <crypto/ecc_curve_defs.h>
>>  
>>  #define ECRDSA_MAX_SIG_SIZE (2 * 512 / 8)
>>  #define ECRDSA_MAX_DIGITS (512 / 64)
>> diff --git a/include/crypto/ecc_curve_defs.h b/include/crypto/ecc_curve_defs.h
>> new file mode 100644
>> index 0000000..1080766
>> --- /dev/null
>> +++ b/include/crypto/ecc_curve_defs.h
>> @@ -0,0 +1,92 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _CRYTO_ECC_CURVE_DEFS_H
>> +#define _CRYTO_ECC_CURVE_DEFS_H
>> +
>> +/**
>> + * struct ecc_point - elliptic curve point in affine coordinates
>> + *
>> + * @x:		X coordinate in vli form.
>> + * @y:		Y coordinate in vli form.
>> + * @ndigits:	Length of vlis in u64 qwords.
>> + */
>> +struct ecc_point {
>> +	u64 *x;
>> +	u64 *y;
>> +	u8 ndigits;
>> +};
>> +
>> +/**
>> + * struct ecc_curve - definition of elliptic curve
>> + *
>> + * @name:	Short name of the curve.
>> + * @g:		Generator point of the curve.
>> + * @p:		Prime number, if Barrett's reduction is used for this curve
>> + *		pre-calculated value 'mu' is appended to the @p after ndigits.
>> + *		Use of Barrett's reduction is heuristically determined in
>> + *		vli_mmod_fast().
>> + * @n:		Order of the curve group.
>> + * @a:		Curve parameter a.
>> + * @b:		Curve parameter b.
>> + */
>> +struct ecc_curve {
>> +	char *name;
>> +	struct ecc_point g;
>> +	u64 *p;
>> +	u64 *n;
>> +	u64 *a;
>> +	u64 *b;
>> +};
>> +
>> +/* NIST P-192: a = p - 3 */
>> +static u64 nist_p192_g_x[] = { 0xF4FF0AFD82FF1012ull, 0x7CBF20EB43A18800ull,
>> +				0x188DA80EB03090F6ull };
>> +static u64 nist_p192_g_y[] = { 0x73F977A11E794811ull, 0x631011ED6B24CDD5ull,
>> +				0x07192B95FFC8DA78ull };
>> +static u64 nist_p192_p[] = { 0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFFFFFFFFFEull,
>> +				0xFFFFFFFFFFFFFFFFull };
>> +static u64 nist_p192_n[] = { 0x146BC9B1B4D22831ull, 0xFFFFFFFF99DEF836ull,
>> +				0xFFFFFFFFFFFFFFFFull };
>> +static u64 nist_p192_a[] = { 0xFFFFFFFFFFFFFFFCull, 0xFFFFFFFFFFFFFFFEull,
>> +				0xFFFFFFFFFFFFFFFFull };
>> +static u64 nist_p192_b[] = { 0xFEB8DEECC146B9B1ull, 0x0FA7E9AB72243049ull,
>> +				0x64210519E59C80E7ull };
>> +static struct ecc_curve nist_p192 = {
>> +	.name = "nist_192",
>> +	.g = {
>> +		.x = nist_p192_g_x,
>> +		.y = nist_p192_g_y,
>> +		.ndigits = 3,
>> +	},
>> +	.p = nist_p192_p,
>> +	.n = nist_p192_n,
>> +	.a = nist_p192_a,
>> +	.b = nist_p192_b
>> +};
>> +
>> +/* NIST P-256: a = p - 3 */
>> +static u64 nist_p256_g_x[] = { 0xF4A13945D898C296ull, 0x77037D812DEB33A0ull,
>> +				0xF8BCE6E563A440F2ull, 0x6B17D1F2E12C4247ull };
>> +static u64 nist_p256_g_y[] = { 0xCBB6406837BF51F5ull, 0x2BCE33576B315ECEull,
>> +				0x8EE7EB4A7C0F9E16ull, 0x4FE342E2FE1A7F9Bull };
>> +static u64 nist_p256_p[] = { 0xFFFFFFFFFFFFFFFFull, 0x00000000FFFFFFFFull,
>> +				0x0000000000000000ull, 0xFFFFFFFF00000001ull };
>> +static u64 nist_p256_n[] = { 0xF3B9CAC2FC632551ull, 0xBCE6FAADA7179E84ull,
>> +				0xFFFFFFFFFFFFFFFFull, 0xFFFFFFFF00000000ull };
>> +static u64 nist_p256_a[] = { 0xFFFFFFFFFFFFFFFCull, 0x00000000FFFFFFFFull,
>> +				0x0000000000000000ull, 0xFFFFFFFF00000001ull };
>> +static u64 nist_p256_b[] = { 0x3BCE3C3E27D2604Bull, 0x651D06B0CC53B0F6ull,
>> +				0xB3EBBD55769886BCull, 0x5AC635D8AA3A93E7ull };
>> +static struct ecc_curve nist_p256 = {
>> +	.name = "nist_256",
>> +	.g = {
>> +		.x = nist_p256_g_x,
>> +		.y = nist_p256_g_y,
>> +		.ndigits = 4,
>> +	},
>> +	.p = nist_p256_p,
>> +	.n = nist_p256_n,
>> +	.a = nist_p256_a,
>> +	.b = nist_p256_b
>> +};
>> +
>> +#endif
>> -- 
>> 2.8.1
> .
> 
