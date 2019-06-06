Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF8BC04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 17:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8683620868
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 17:45:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="AXrJEVoH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbfFFRpI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 13:45:08 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:38166 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728508AbfFFRpI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 13:45:08 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45KY2p4p4xz9v1J0;
        Thu,  6 Jun 2019 19:45:06 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=AXrJEVoH; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id TlQ8N-zESh-1; Thu,  6 Jun 2019 19:45:06 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45KY2p3jFfz9v1Hy;
        Thu,  6 Jun 2019 19:45:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1559843106; bh=Zsc6HBKFtppJHipH4cs1n9A7u1wjVkrXx+iPAMs24pw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=AXrJEVoHSnwosEjxWEyDxWEqqqcT/bp3bxVQ+NWs4hVixB1EAoNLNi9NUGdMFIeBV
         wkfFcqVSVb6yTgc+mNCrJHosXe6TLAKpqkrtm/4De28kM+hkajFWqef6N4pB/GDCev
         oTDVvNcDXWduyqkTEXz1O6BVDg7FQnCUekTKuJXE=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 829908B8B2;
        Thu,  6 Jun 2019 19:45:06 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Igcopf-_FiZl; Thu,  6 Jun 2019 19:45:06 +0200 (CEST)
Received: from PO15451 (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 37BD48B8A4;
        Thu,  6 Jun 2019 19:45:06 +0200 (CEST)
Subject: Re: [PATCH v2] crypto: talitos - Use devm_platform_ioremap_resource()
To:     Fabio Estevam <festevam@gmail.com>, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, horia.geanta@nxp.com
References: <20190606172845.16864-1-festevam@gmail.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <f166aeb5-bde2-1721-d7d8-bc19245a324a@c-s.fr>
Date:   Thu, 6 Jun 2019 19:45:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190606172845.16864-1-festevam@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 06/06/2019 à 19:28, Fabio Estevam a écrit :
> Use devm_platform_ioremap_resource() to simplify the code a bit.
> 
> While at it, remove unneeded error message in case of
> devm_platform_ioremap_resource() failure, as the core mm code
> will take care of it.

devm_platform_ioremap_resource() doesn't use devm_ioremap() but 
devm_ioremap_ressource() which does an devm_request_mem_region() in 
addition.

Have you checked that it has no impact ?

On SOCs, areas of memory are often shared between several drivers. 
devm_ioremap_ressource() can only be used if we are 100% sure that this 
area of memory is not shared with any other driver.

Christophe

> 
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> ---
> Changes since v1:
> - Adjust the error check for devm_platform_ioremap_resource()
> - Remove error message on devm_platform_ioremap_resource() failure
> 
>   drivers/crypto/talitos.c | 11 +++--------
>   1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 32a7e747dc5f..688affec36c9 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -3336,7 +3336,6 @@ static int talitos_probe(struct platform_device *ofdev)
>   	struct talitos_private *priv;
>   	int i, err;
>   	int stride;
> -	struct resource *res;
>   
>   	priv = devm_kzalloc(dev, sizeof(struct talitos_private), GFP_KERNEL);
>   	if (!priv)
> @@ -3350,13 +3349,9 @@ static int talitos_probe(struct platform_device *ofdev)
>   
>   	spin_lock_init(&priv->reg_lock);
>   
> -	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
> -	if (!res)
> -		return -ENXIO;
> -	priv->reg = devm_ioremap(dev, res->start, resource_size(res));
> -	if (!priv->reg) {
> -		dev_err(dev, "failed to of_iomap\n");
> -		err = -ENOMEM;
> +	priv->reg = devm_platform_ioremap_resource(ofdev, 0);
> +	if (IS_ERR(priv->reg)) {
> +		err = PTR_ERR(priv->reg);
>   		goto err_out;
>   	}
>   
> 
