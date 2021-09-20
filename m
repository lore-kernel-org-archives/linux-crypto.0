Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB90C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Sep 2021 16:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38CC560FA0
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Sep 2021 16:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhITQ2E (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Sep 2021 12:28:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229914AbhITQ2D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Sep 2021 12:28:03 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KEqS38015556;
        Mon, 20 Sep 2021 12:25:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lpNrgIClxc6uLVdhpRODsqe2CwZ4gaIwdYn9KTYhxjg=;
 b=bVV+d8fw8Nsko5z3lEo0WjfF0gGd2ah77lwsXtvHiw6F0OBC/kS4Ylbl5AZ2CCjFGXs9
 GIb3BsRtQW90T9LkKV15pvIKLZILxG0nAwa+rRWiV3JdDWB1UR4WXhueGoQISGhBngo6
 h/QKWVZWxGa8oaNj6yxFq9tBDVsYn1/hksAJl3gx8UV8pAujaLkKXbvpE9qgvkjJ9y4z
 fIi/k9KWL+s8D9dmkErl0WNh9phnpdcXZXUYgBKbPGXB2fjxzi8mZD0YZGwG0VSk/WKL
 xPyLLYmzKNfprZShUWYMmPTzk0Ir0ZrNDBVKjQzL/cIuNoKgjMbHytZHp2kDmbg9nRbI OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b5w06yf5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 12:25:21 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KEqVOE016056;
        Mon, 20 Sep 2021 12:25:20 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b5w06yf53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 12:25:20 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KGD58D026265;
        Mon, 20 Sep 2021 16:25:20 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 3b57r9ukv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 16:25:20 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KGPJ2D26411338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 16:25:19 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24B07136053;
        Mon, 20 Sep 2021 16:25:19 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94A2F13606A;
        Mon, 20 Sep 2021 16:25:18 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 16:25:18 +0000 (GMT)
Subject: Re: [PATCH] crypto: ecc: fix CRYPTO_DEFAULT_RNG dependency
To:     Arnd Bergmann <arnd@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210920100551.1568868-1-arnd@kernel.org>
From:   Stefan Berger <stefanb@linux.ibm.com>
Message-ID: <599e065b-d4c7-957c-ed54-c88217f9a5af@linux.ibm.com>
Date:   Mon, 20 Sep 2021 12:25:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210920100551.1568868-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1XavsnLjDrmIQgQHz4UfxU8VvvwVcUlU
X-Proofpoint-GUID: CUpOHnl2rtn0oJEaGWLg0fi7N-xIKen-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 clxscore=1011 suspectscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 impostorscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200100
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 9/20/21 6:05 AM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> The ecc.c file started out as part of the ECDH algorithm but got
> moved out into a standalone module later. It does not build without
> CRYPTO_DEFAULT_RNG, so now that other modules are using it as well we
> can run into this link error:
>
> aarch64-linux-ld: ecc.c:(.text+0xfc8): undefined reference to `crypto_default_rng'
> aarch64-linux-ld: ecc.c:(.text+0xff4): undefined reference to `crypto_put_default_rng'
>
> Move the 'select CRYPTO_DEFAULT_RNG' statement into the correct symbol.
>
> Fixes: 0d7a78643f69 ("crypto: ecrdsa - add EC-RDSA (GOST 34.10) algorithm")
> Fixes: 4e6602916bc6 ("crypto: ecdsa - Add support for ECDSA signature verification")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>


> ---
>   crypto/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 536df4b6b825..285f82647d2b 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -233,12 +233,12 @@ config CRYPTO_DH
>   
>   config CRYPTO_ECC
>   	tristate
> +	select CRYPTO_RNG_DEFAULT
>   
>   config CRYPTO_ECDH
>   	tristate "ECDH algorithm"
>   	select CRYPTO_ECC
>   	select CRYPTO_KPP
> -	select CRYPTO_RNG_DEFAULT
>   	help
>   	  Generic implementation of the ECDH algorithm
>   
