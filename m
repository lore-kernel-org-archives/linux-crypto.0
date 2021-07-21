Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486A4C12002
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 12:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26C8A6121E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 12:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbhGUL34 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Jul 2021 07:29:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25054 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236765AbhGUL34 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jul 2021 07:29:56 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16LC2siw105881;
        Wed, 21 Jul 2021 08:10:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=j4u8BqA42tjXeh/DryDQIP/SBRVwP+9xAMLbvz0lXuc=;
 b=VgO3UPGe3/AoJXNckNFKUyQ3VhYRzmzwqzZm/Xuw6zx9dilgBbo/ydLTT4OG4AUv5kYT
 TCJIvTcIp/4TcYv+E9d0v7eXsFkSJ2xz2lGxFeRpgsvLnjEt2mcoxw3Ezt6SqganksTF
 kZoJ0GO4MVp4i1bmvcdZ2Vq1nICwD2ie9kivT4MpRy/5SpHIe0eF66Nsih/lIVOcAJdW
 KTU+CqDXp0S6E75GNr+qvAAl+N2dbF3jJ4qQYLzyCVMtGCkVFbyV7LNX9EB2u0hO/aNr
 CXxBrqCz7+0SFZwx2C0l5K4Rvk1qlq/aiKeAEx3lCyTSNlF/z3PhaMa4pG+8GL9RWqq7 GA== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39xjrk12ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jul 2021 08:10:22 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16LC3kNs009841;
        Wed, 21 Jul 2021 12:10:22 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 39upudm8aj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jul 2021 12:10:21 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16LCALed53936462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 12:10:21 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F28FAC05F;
        Wed, 21 Jul 2021 12:10:21 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE279AC066;
        Wed, 21 Jul 2021 12:10:20 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 21 Jul 2021 12:10:20 +0000 (GMT)
Subject: Re: [PATCH] crypto: ecc: handle unaligned input buffer in
 ecc_swap_digits
To:     Mian Yousaf Kaukab <ykaukab@suse.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au, tiwai@suse.de,
        guillaume.gardet@arm.com
References: <20210721083905.15144-1-ykaukab@suse.de>
From:   Stefan Berger <stefanb@linux.ibm.com>
Message-ID: <1662e2df-34e9-d8fa-4a24-e579618f635e@linux.ibm.com>
Date:   Wed, 21 Jul 2021 08:10:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210721083905.15144-1-ykaukab@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: N4ujAXeTq72On5MSSCq_jwEuR8auDImn
X-Proofpoint-ORIG-GUID: N4ujAXeTq72On5MSSCq_jwEuR8auDImn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-21_05:2021-07-21,2021-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 mlxscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 adultscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107210069
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 7/21/21 4:39 AM, Mian Yousaf Kaukab wrote:
> ecdsa_set_pub_key() makes an u64 pointer at 1 byte offset of the key.
> This results in an unaligned u64 pointer. This pointer is passed to
> ecc_swap_digits() which assumes natural alignment.
>
> This causes a kernel crash on an armv7 platform:
> [    0.409022] Unhandled fault: alignment exception (0x001) at 0xc2a0a6a9
> ...
> [    0.416982] PC is at ecdsa_set_pub_key+0xdc/0x120
> ...
> [    0.491492] Backtrace:
> [    0.492059] [<c07c266c>] (ecdsa_set_pub_key) from [<c07c75d4>] (test_akcipher_one+0xf4/0x6c0)
>
> Handle unaligned input buffer in ecc_swap_digits() by replacing
> be64_to_cpu() to get_unaligned_be64(). Change type of in pointer to
> void to reflect it doesn’t necessarily need to be aligned.
>
> Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature verification")
> Reported-by: Guillaume Gardet <guillaume.gardet@arm.com>
> Suggested-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>


Tested-by: Stefan Berger <stefanb@linux.ibm.com>


> ---
>   crypto/ecc.h | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/ecc.h b/crypto/ecc.h
> index a006132646a4..1350e8eb6ac2 100644
> --- a/crypto/ecc.h
> +++ b/crypto/ecc.h
> @@ -27,6 +27,7 @@
>   #define _CRYPTO_ECC_H
>   
>   #include <crypto/ecc_curve.h>
> +#include <asm/unaligned.h>
>   
>   /* One digit is u64 qword. */
>   #define ECC_CURVE_NIST_P192_DIGITS  3
> @@ -46,13 +47,13 @@
>    * @out:      Output array
>    * @ndigits:  Number of digits to copy
>    */
> -static inline void ecc_swap_digits(const u64 *in, u64 *out, unsigned int ndigits)
> +static inline void ecc_swap_digits(const void *in, u64 *out, unsigned int ndigits)
>   {
>   	const __be64 *src = (__force __be64 *)in;
>   	int i;
>   
>   	for (i = 0; i < ndigits; i++)
> -		out[i] = be64_to_cpu(src[ndigits - 1 - i]);
> +		out[i] = get_unaligned_be64(&src[ndigits - 1 - i]);
>   }
>   
>   /**
