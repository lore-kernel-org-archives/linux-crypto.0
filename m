Return-Path: <SRS0=06DT=XF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF883C3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 06:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C31502089F
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Sep 2019 06:06:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="X7YdkP0i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390857AbfIJGGt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Sep 2019 02:06:49 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:25840 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390828AbfIJGGt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Sep 2019 02:06:49 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 46SF0k1Pwqz9twm3;
        Tue, 10 Sep 2019 08:06:46 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=X7YdkP0i; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id z8Z7mvRwgSoq; Tue, 10 Sep 2019 08:06:46 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 46SF0j6wp9z9twm2;
        Tue, 10 Sep 2019 08:06:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1568095606; bh=2LE1jQAHGICVNBPwsOGB6KPlSmxFI7HuAFqLdw7uWcI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=X7YdkP0i4c954oLLUr0NVRBWOgm99veZMYtWyC4yto/Mbp05F+D4IP95DPsz8TvkM
         H78IbBXV4T4HUP4Th+LM8MyvxysaoetMcofNAAYRNC/HG0WEKy8PemVPLly2hpDwDG
         FLAuBk2Ouyp0fjA6Tb4C9sgg/cdZ7E5JNuWMSVe4=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id AF7548B78E;
        Tue, 10 Sep 2019 08:06:46 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Y62PyhrlvnZF; Tue, 10 Sep 2019 08:06:46 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 558418B754;
        Tue, 10 Sep 2019 08:06:46 +0200 (CEST)
Subject: Re: [PATCH] crypto: talitos - fix missing break in switch statement
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190909052952.GA32131@embeddedor>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <b2c4faf9-9b10-882d-57db-bcbc3ed2a025@c-s.fr>
Date:   Tue, 10 Sep 2019 08:06:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190909052952.GA32131@embeddedor>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 09/09/2019 à 07:29, Gustavo A. R. Silva a écrit :
> Add missing break statement in order to prevent the code from falling
> through to case CRYPTO_ALG_TYPE_AHASH.
> 
> Fixes: aeb4c132f33d ("crypto: talitos - Convert to new AEAD interface")
> Cc: stable@vger.kernel.org
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>

> ---
>   drivers/crypto/talitos.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index c9d686a0e805..4818ae427098 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -3140,6 +3140,7 @@ static int talitos_remove(struct platform_device *ofdev)
>   			break;
>   		case CRYPTO_ALG_TYPE_AEAD:
>   			crypto_unregister_aead(&t_alg->algt.alg.aead);
> +			break;
>   		case CRYPTO_ALG_TYPE_AHASH:
>   			crypto_unregister_ahash(&t_alg->algt.alg.hash);
>   			break;
> 
