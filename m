Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CFBC04AAF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 17:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 356E7217D7
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 17:56:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="A6sdd7VZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbfEUR4B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 13:56:01 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:9450 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbfEUR4B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 13:56:01 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 457k2l0XyYz9txsZ;
        Tue, 21 May 2019 19:55:59 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=A6sdd7VZ; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id D8j8zh3LvLfO; Tue, 21 May 2019 19:55:59 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 457k2k6Vgjz9txsY;
        Tue, 21 May 2019 19:55:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1558461358; bh=rPRJB17D3wA1CcMFmT+QLbr4H/GkCMjO8jlqLd5EAXY=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=A6sdd7VZ6YXmMK8C3m5hleP1Rq4YYgrehXYedp67BnOsg2KWTDgHOEu8VyTYHVy8e
         884T8xkn7OA7BJCb1lGJRF2SI62gVukwuxL6qtjPyp9lSzHMwMY9q1ZeBjwhQC0h+A
         CJmpESWlTLRV/P5uIMgVe8NocOPt96iwG/20Z/Vg=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id DBD878B815;
        Tue, 21 May 2019 19:55:58 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id JJXzrbF143zy; Tue, 21 May 2019 19:55:58 +0200 (CEST)
Received: from po16846vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 795D58B811;
        Tue, 21 May 2019 19:55:58 +0200 (CEST)
Subject: Re: [PATCH v1 02/15] crypto: talitos - rename alternative AEAD algos.
From:   Christophe Leroy <christophe.leroy@c-s.fr>
To:     Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1558445259.git.christophe.leroy@c-s.fr>
 <1449c1a24e2e06ac6c8c2e1b7f73feedfd51894c.1558445259.git.christophe.leroy@c-s.fr>
Message-ID: <3ac55e59-a75c-0b9a-be24-148007bb522e@c-s.fr>
Date:   Tue, 21 May 2019 17:54:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <1449c1a24e2e06ac6c8c2e1b7f73feedfd51894c.1558445259.git.christophe.leroy@c-s.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Joe & Andy

On 05/21/2019 01:34 PM, Christophe Leroy wrote:
> The talitos driver has two ways to perform AEAD depending on the
> HW capability. Some HW support both. It is needed to give them
> different names to distingish which one it is for instance when
> a test fails.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> Fixes: 7405c8d7ff97 ("crypto: talitos - templates for AEAD using HMAC_SNOOP_NO_AFEU")
> Cc: stable@vger.kernel.org
> ---
>   drivers/crypto/talitos.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index f443cbe7da80..6f8bc6467706 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -2356,7 +2356,7 @@ static struct talitos_alg_template driver_algs[] = {
>   			.base = {
>   				.cra_name = "authenc(hmac(sha1),cbc(aes))",
>   				.cra_driver_name = "authenc-hmac-sha1-"
> -						   "cbc-aes-talitos",
> +						   "cbc-aes-talitos-hsna",

checkpatch reports the following warning on the above:

WARNING: quoted string split across lines
#27: FILE: drivers/crypto/talitos.c:2359:
  				.cra_driver_name = "authenc-hmac-sha1-"
+						   "cbc-aes-talitos-hsna",


But when I fixes the patch as follows, I get another warning:

@@ -2355,8 +2355,7 @@ static struct talitos_alg_template driver_algs[] = {
  		.alg.aead = {
  			.base = {
  				.cra_name = "authenc(hmac(sha1),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-aes-talitos",
+				.cra_driver_name = "authenc-hmac-sha1-cbc-aes-talitos-hsna",
  				.cra_blocksize = AES_BLOCK_SIZE,
  				.cra_flags = CRYPTO_ALG_ASYNC,
  			},



WARNING: line over 80 characters
#28: FILE: drivers/crypto/talitos.c:2358:
+				.cra_driver_name = "authenc-hmac-sha1-cbc-aes-talitos-hsna",


So, how should this be fixed ?

Thanks
Christophe

>   				.cra_blocksize = AES_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC,
>   			},
> @@ -2401,7 +2401,7 @@ static struct talitos_alg_template driver_algs[] = {
>   				.cra_name = "authenc(hmac(sha1),"
>   					    "cbc(des3_ede))",
>   				.cra_driver_name = "authenc-hmac-sha1-"
> -						   "cbc-3des-talitos",
> +						   "cbc-3des-talitos-hsna",
>   				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC,
>   			},
> @@ -2444,7 +2444,7 @@ static struct talitos_alg_template driver_algs[] = {
>   			.base = {
>   				.cra_name = "authenc(hmac(sha224),cbc(aes))",
>   				.cra_driver_name = "authenc-hmac-sha224-"
> -						   "cbc-aes-talitos",
> +						   "cbc-aes-talitos-hsna",
>   				.cra_blocksize = AES_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC,
>   			},
> @@ -2489,7 +2489,7 @@ static struct talitos_alg_template driver_algs[] = {
>   				.cra_name = "authenc(hmac(sha224),"
>   					    "cbc(des3_ede))",
>   				.cra_driver_name = "authenc-hmac-sha224-"
> -						   "cbc-3des-talitos",
> +						   "cbc-3des-talitos-hsna",
>   				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC,
>   			},
> @@ -2532,7 +2532,7 @@ static struct talitos_alg_template driver_algs[] = {
>   			.base = {
>   				.cra_name = "authenc(hmac(sha256),cbc(aes))",
>   				.cra_driver_name = "authenc-hmac-sha256-"
> -						   "cbc-aes-talitos",
> +						   "cbc-aes-talitos-hsna",
>   				.cra_blocksize = AES_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC,
>   			},
> @@ -2577,7 +2577,7 @@ static struct talitos_alg_template driver_algs[] = {
>   				.cra_name = "authenc(hmac(sha256),"
>   					    "cbc(des3_ede))",
>   				.cra_driver_name = "authenc-hmac-sha256-"
> -						   "cbc-3des-talitos",
> +						   "cbc-3des-talitos-hsna",
>   				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC,
>   			},
> @@ -2706,7 +2706,7 @@ static struct talitos_alg_template driver_algs[] = {
>   			.base = {
>   				.cra_name = "authenc(hmac(md5),cbc(aes))",
>   				.cra_driver_name = "authenc-hmac-md5-"
> -						   "cbc-aes-talitos",
> +						   "cbc-aes-talitos-hsna",
>   				.cra_blocksize = AES_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC,
>   			},
> @@ -2749,7 +2749,7 @@ static struct talitos_alg_template driver_algs[] = {
>   			.base = {
>   				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
>   				.cra_driver_name = "authenc-hmac-md5-"
> -						   "cbc-3des-talitos",
> +						   "cbc-3des-talitos-hsna",
>   				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
>   				.cra_flags = CRYPTO_ALG_ASYNC,
>   			},
> 
