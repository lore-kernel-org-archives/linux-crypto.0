Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDCAC10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 13:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 508CD2084D
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 13:37:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="PSP0xJzi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfDLNg7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:36:59 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:12058 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726755AbfDLNg6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 09:36:58 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3CDYuT6025603;
        Fri, 12 Apr 2019 15:36:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=STMicroelectronics;
 bh=U22Rdy9cYH5n9zmQMcQ8mu2jBRdCAG1yX3S/KA6/hAQ=;
 b=PSP0xJziOPC8XCKVwn6r12papWIhfr39kccPaS3gneo6hMmsZfFSb/VJeQtekgQGGG8m
 eO30hLLbj1QUHzwhwAdqtMRNs4C6Oa2QxyB6YhBj+70ZCyhcielJAtx1UfUyeDa0hv+n
 udSsskyULXlphN87MA8dy2lpke7MjmNT+Gol3PIgSrHm095uWGsego91ji7Bwh8GbSqj
 VcH96anKol+KWfk674AnWkj3frjV2cBlVpLdRg0GXHPUMSzJmScHVDvsnqhRtXvkF1OJ
 7iwYxiIxlpCO7E/HVvlrR/rAG+WNz0vILp1vOePKbWommIG0raoaqEgR9SzbafRaDrIF 4g== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2rprcfvr4a-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 12 Apr 2019 15:36:45 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 5380E38;
        Fri, 12 Apr 2019 13:36:45 +0000 (GMT)
Received: from Webmail-eu.st.com (sfhdag7node2.st.com [10.75.127.20])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 3EC8F2610;
        Fri, 12 Apr 2019 13:36:45 +0000 (GMT)
Received: from SFHDAG7NODE2.st.com (10.75.127.20) by SFHDAG7NODE2.st.com
 (10.75.127.20) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Fri, 12 Apr
 2019 15:36:44 +0200
Received: from SFHDAG7NODE2.st.com ([fe80::d548:6a8f:2ca4:2090]) by
 SFHDAG7NODE2.st.com ([fe80::d548:6a8f:2ca4:2090%20]) with mapi id
 15.00.1347.000; Fri, 12 Apr 2019 15:36:44 +0200
From:   Lionel DEBIEVE <lionel.debieve@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 21/24] crypto: stm32 - Forbid 2-key 3DES in FIPS mode
Thread-Topic: [PATCH 21/24] crypto: stm32 - Forbid 2-key 3DES in FIPS mode
Thread-Index: AQHU8TTFCRuds6k4ekSq1IliwMtfUA==
Date:   Fri, 12 Apr 2019 13:36:44 +0000
Message-ID: <a0be98ce-da8e-8b86-59a3-4fc837496f9b@st.com>
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
 <E1hEVQU-0006oc-Sr@gondobar>
In-Reply-To: <E1hEVQU-0006oc-Sr@gondobar>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.75.127.51]
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <4D6988D287F7BD45836700CB567BCEBE@st.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-12_08:,,
 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On 4/11/19 10:51 AM, Herbert Xu wrote:

> This patch forbids the use of 2-key 3DES (K1 =3D=3D K3) in FIPS mode.
>    =20
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>
>   drivers/crypto/stm32/stm32-cryp.c |   15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm=
32-cryp.c
> index 23b0b7bd64c7..5785f3e235ce 100644
> --- a/drivers/crypto/stm32/stm32-cryp.c
> +++ b/drivers/crypto/stm32/stm32-cryp.c
> @@ -762,10 +762,17 @@ static int stm32_cryp_des_setkey(struct crypto_ablk=
cipher *tfm, const u8 *key,
>   static int stm32_cryp_tdes_setkey(struct crypto_ablkcipher *tfm, const =
u8 *key,
>   				  unsigned int keylen)
>   {
> -	if (keylen !=3D (3 * DES_KEY_SIZE))
> -		return -EINVAL;
> -	else
> -		return stm32_cryp_setkey(tfm, key, keylen);
> +	u32 flags;
> +	int err;
> +
> +	flags =3D crypto_ablkcipher_get_flags(tfm);
> +	err =3D __des3_verify_key(&flags, key);
> +	if (unlikely(err)) {
> +		crypto_ablkcipher_set_flags(tfm, flags);
> +		return err;
> +	}
> +
> +	return stm32_cryp_setkey(tfm, key, keylen);
>   }
>  =20
>   static int stm32_cryp_aes_aead_setkey(struct crypto_aead *tfm, const u8=
 *key,
>
I was currently going to send patches around des and tdes key verification.=
 Is there any plan
to do the same factorization on des key check?

Regarding this patch, ok for me.

- Lionel

Acked-by: Lionel Debieve<lionel.debieve@st.com>
Tested-by: Lionel Debieve<lionel.debieve@st.com>

