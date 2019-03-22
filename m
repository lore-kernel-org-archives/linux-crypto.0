Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3B4C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 12:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DEDA21873
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 12:55:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="hIo3wzfE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732589AbfCVMyw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:54:52 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:7606 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733022AbfCVMyv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 08:54:51 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 44QkBv5BVpz9txf3;
        Fri, 22 Mar 2019 13:54:47 +0100 (CET)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=hIo3wzfE; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id lWKAbOdjKAKz; Fri, 22 Mar 2019 13:54:47 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 44QkBv3sgKz9txf2;
        Fri, 22 Mar 2019 13:54:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1553259287; bh=26ZK7/CAEBxnxUnQkCvPSL1aG1SlmXekNJcGWX1XQnU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=hIo3wzfE91ko+U3qR0ixhhHth22RQw+b7mbKkcrQ0ObXpo8kZCVf1UBqpplWr4VDY
         +bjgQIGXurFaK199LIC7MuXgF/4t2groe0tU9AiYnI5Cnp5e9it/3ClMFCXNdzV8V4
         VrEp0c+AASEMBBY5svqLDw4MYgVpccscduynR+1w=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D46098BB11;
        Fri, 22 Mar 2019 13:54:48 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id 0KrXzgU9phTN; Fri, 22 Mar 2019 13:54:48 +0100 (CET)
Received: from PO15451 (po15451.idsi0.si.c-s.fr [172.25.231.2])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id A8C428B848;
        Fri, 22 Mar 2019 13:54:48 +0100 (CET)
Subject: Re: [possible PATCH] crypto: sahara - Use #ifdef DEBUG not
 IS_ENABLED(DEBUG)
To:     Joe Perches <joe@perches.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <5ef0cab4dee128058a43f43c723c13924662e80d.camel@perches.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <4ea24643-5832-981f-3d39-9a84692be6e7@c-s.fr>
Date:   Fri, 22 Mar 2019 13:54:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <5ef0cab4dee128058a43f43c723c13924662e80d.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 08/03/2019 à 01:15, Joe Perches a écrit :
> Normal use of IS_ENABLED is with a CONFIG_<SYMBOL> and
> there is no -DDEBUG in the Makefile here.
> 
> Replace the IS_ENABLED(DEBUG) with #ifdef DEBUG/#endif
> blocks.

By doing this you hide a big part of the code which cannot be verified 
unless DEBUG is defined.

I suggest to add the following helper:

static bool is_debug_enabled(void)
{
#ifdef DEBUG
	return true;
#else
	return false;
#endif
}

then replace

if (IS_ENABLED(DEBUG))

by

if (is_debug_enabled())

Christophe

> 
> Miscellanea:
> 
> o Move the sahara_state array into the function that uses it.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>   drivers/crypto/sahara.c | 20 +++++++++-----------
>   1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
> index 8c32a3059b4a..d2b4bd483507 100644
> --- a/drivers/crypto/sahara.c
> +++ b/drivers/crypto/sahara.c
> @@ -348,14 +348,13 @@ static void sahara_decode_error(struct sahara_dev *dev, unsigned int error)
>   	dev_err(dev->device, "\n");
>   }
>   
> -static const char *sahara_state[4] = { "Idle", "Busy", "Error", "HW Fault" };
> -
>   static void sahara_decode_status(struct sahara_dev *dev, unsigned int status)
>   {
> +#ifdef DEBUG
>   	u8 state;
> -
> -	if (!IS_ENABLED(DEBUG))
> -		return;
> +	static const char *sahara_state[4] = {
> +		"Idle", "Busy", "Error", "HW Fault"
> +	};
>   
>   	state = SAHARA_STATUS_GET_STATE(status);
>   
> @@ -400,15 +399,14 @@ static void sahara_decode_status(struct sahara_dev *dev, unsigned int status)
>   		sahara_read(dev, SAHARA_REG_CDAR));
>   	dev_dbg(dev->device, "Initial DAR: 0x%08x\n\n",
>   		sahara_read(dev, SAHARA_REG_IDAR));
> +#endif
>   }
>   
>   static void sahara_dump_descriptors(struct sahara_dev *dev)
>   {
> +#ifdef DEBUG
>   	int i;
>   
> -	if (!IS_ENABLED(DEBUG))
> -		return;
> -
>   	for (i = 0; i < SAHARA_MAX_HW_DESC; i++) {
>   		dev_dbg(dev->device, "Descriptor (%d) (%pad):\n",
>   			i, &dev->hw_phys_desc[i]);
> @@ -421,15 +419,14 @@ static void sahara_dump_descriptors(struct sahara_dev *dev)
>   			dev->hw_desc[i]->next);
>   	}
>   	dev_dbg(dev->device, "\n");
> +#endif
>   }
>   
>   static void sahara_dump_links(struct sahara_dev *dev)
>   {
> +#ifdef DEBUG
>   	int i;
>   
> -	if (!IS_ENABLED(DEBUG))
> -		return;
> -
>   	for (i = 0; i < SAHARA_MAX_HW_LINK; i++) {
>   		dev_dbg(dev->device, "Link (%d) (%pad):\n",
>   			i, &dev->hw_phys_link[i]);
> @@ -439,6 +436,7 @@ static void sahara_dump_links(struct sahara_dev *dev)
>   			dev->hw_link[i]->next);
>   	}
>   	dev_dbg(dev->device, "\n");
> +#endif
>   }
>   
>   static int sahara_hw_descriptor_create(struct sahara_dev *dev)
> 
