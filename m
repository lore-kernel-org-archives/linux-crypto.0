Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC7FC433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 08:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88A1C2080D
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 08:49:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="g4DJs4ie"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGUItr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 04:49:47 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:60628 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbgGUItq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 04:49:46 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06L8lWgT029098;
        Tue, 21 Jul 2020 10:49:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : references
 : from : message-id : date : mime-version : in-reply-to : content-type :
 content-transfer-encoding; s=STMicroelectronics;
 bh=/AMDsnmMg6e/KnTUQmRcMKb3eBNXg2kCGXVP0hShHgw=;
 b=g4DJs4ieF2zv3OGN1dEjUEqs22wd8iCWYk7iYbc1UvKXGxAfALWM6GEDbFmwnJr6IhTT
 l6aO6UzrvXDvF+oCQGrb3qGnU07f+GQH/kZ/xNrV/D3FHhss/eeJ4rbCyPOSfSAPeRFu
 F/9kihhF2d9ROkkYRxuvRyKwkEXWz0ugqacIrrCQcoMg67rUGC3BWO9KuPy0C3yk0Bqj
 VYYSqdr7KuMNFErcDB6PslyyNCFweARRXF7ByYUfHVjRnYfSItDp0MwXDVihjoxu7+WJ
 HvKIyzgownPsVXvMhCDIVydtfI+gOkfJOCShlU9l9NJ7WkCdGRkZBSeaadvTn51o2jIx qg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 32bsfpcs82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 10:49:21 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 110D110002A;
        Tue, 21 Jul 2020 10:49:19 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id E28822A7526;
        Tue, 21 Jul 2020 10:49:18 +0200 (CEST)
Received: from lmecxl0912.lme.st.com (10.75.127.44) by SFHDAG3NODE2.st.com
 (10.75.127.8) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue, 21 Jul
 2020 10:49:18 +0200
Subject: Re: [PATCH for v5.9] ARM: STM32: Replace HTTP links with HTTPS ones
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        <linux@armlinux.org.uk>, <mcoquelin.stm32@gmail.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
References: <20200719094948.57487-1-grandmaster@al2klimov.de>
From:   Alexandre Torgue <alexandre.torgue@st.com>
Message-ID: <43c11c7a-269e-cc41-6934-0d2e0dec3226@st.com>
Date:   Tue, 21 Jul 2020 10:49:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200719094948.57487-1-grandmaster@al2klimov.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.44]
X-ClientProxiedBy: SFHDAG7NODE1.st.com (10.75.127.19) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_02:2020-07-21,2020-07-21 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Alexander

On 7/19/20 11:49 AM, Alexander A. Klimov wrote:
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>    If not .svg:
>      For each line:
>        If doesn't contain `\bxmlns\b`:
>          For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
> 	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>              If both the HTTP and HTTPS versions
>              return 200 OK and serve the same content:
>                Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>

This patch touch 2 different subsystems. Can you please split it ?

Regards
Alex


> ---
>   Continuing my work started at 93431e0607e5.
>   See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
>   (Actually letting a shell for loop submit all this stuff for me.)
> 
>   If there are any URLs to be removed completely
>   or at least not (just) HTTPSified:
>   Just clearly say so and I'll *undo my change*.
>   See also: https://lkml.org/lkml/2020/6/27/64
> 
>   If there are any valid, but yet not changed URLs:
>   See: https://lkml.org/lkml/2020/6/26/837
> 
>   If you apply the patch, please let me know.
> 
>   Sorry again to all maintainers who complained about subject lines.
>   Now I realized that you want an actually perfect prefixes,
>   not just subsystem ones.
>   I tried my best...
>   And yes, *I could* (at least half-)automate it.
>   Impossible is nothing! :)
> 
> 
>   arch/arm/mach-stm32/Makefile.boot | 2 +-
>   crypto/testmgr.h                  | 6 +++---
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-stm32/Makefile.boot b/arch/arm/mach-stm32/Makefile.boot
> index cec195d4fcba..5dde7328a7a9 100644
> --- a/arch/arm/mach-stm32/Makefile.boot
> +++ b/arch/arm/mach-stm32/Makefile.boot
> @@ -1,4 +1,4 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   # Empty file waiting for deletion once Makefile.boot isn't needed any more.
>   # Patch waits for application at
> -# http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7889/1 .
> +# https://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7889/1 .
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index d29983908c38..cdcf0d2fe40d 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -16231,7 +16231,7 @@ static const struct cipher_testvec aes_lrw_tv_template[] = {
>   			  "\xe9\x5d\x48\x92\x54\x63\x4e\xb8",
>   		.len	= 48,
>   	}, {
> -/* http://www.mail-archive.com/stds-p1619@listserv.ieee.org/msg00173.html */
> +/* https://www.mail-archive.com/stds-p1619@listserv.ieee.org/msg00173.html */
>   		.key    = "\xf8\xd4\x76\xff\xd6\x46\xee\x6c"
>   			  "\x23\x84\xcb\x1c\x77\xd6\x19\x5d"
>   			  "\xfe\xf1\xa9\xf3\x7b\xbc\x8d\x21"
> @@ -21096,7 +21096,7 @@ static const struct aead_testvec aegis128_tv_template[] = {
>   
>   /*
>    * All key wrapping test vectors taken from
> - * http://csrc.nist.gov/groups/STM/cavp/documents/mac/kwtestvectors.zip
> + * https://csrc.nist.gov/groups/STM/cavp/documents/mac/kwtestvectors.zip
>    *
>    * Note: as documented in keywrap.c, the ivout for encryption is the first
>    * semiblock of the ciphertext from the test vector. For decryption, iv is
> @@ -22825,7 +22825,7 @@ static const struct cipher_testvec xeta_tv_template[] = {
>    * FCrypt test vectors
>    */
>   static const struct cipher_testvec fcrypt_pcbc_tv_template[] = {
> -	{ /* http://www.openafs.org/pipermail/openafs-devel/2000-December/005320.html */
> +	{ /* https://www.openafs.org/pipermail/openafs-devel/2000-December/005320.html */
>   		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00",
>   		.klen	= 8,
>   		.iv	= "\x00\x00\x00\x00\x00\x00\x00\x00",
> 
