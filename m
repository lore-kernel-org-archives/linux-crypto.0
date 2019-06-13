Return-Path: <SRS0=nMY8=UM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721CBC31E4A
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 15:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B8B32175B
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jun 2019 15:21:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="NyjBpczB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732071AbfFMPUz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:20:55 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:58650 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732005AbfFMMuo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jun 2019 08:50:44 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45Pk9r1GVwz9v00L;
        Thu, 13 Jun 2019 14:50:40 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=NyjBpczB; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id SVtYa9beBncy; Thu, 13 Jun 2019 14:50:40 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45Pk9q752Dz9v00J;
        Thu, 13 Jun 2019 14:50:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1560430240; bh=pTwwRiZdJKJ6tY+T10JSotQr5almlLpVgBNMt/5ukTg=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=NyjBpczBJ59J8xTZ+BnVahuln2IIek0w4aqoEqv560r/EO4MxtGOWUsT9o+Upsl27
         S3/kNEon/ZpKRC46mLcrQkDYcIvTU/J+KPfcZ2hGGZ9EwkDbzeM4USNrgYZ2ERNqjB
         ae8pW/yDaqCZ8T19xIwbZ7ztlX0jd8tF5GzYN7zA=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id EF4688B8B9;
        Thu, 13 Jun 2019 14:50:40 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id z2IbEDTJueAY; Thu, 13 Jun 2019 14:50:40 +0200 (CEST)
Received: from PO15451 (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id C94EA8B8E4;
        Thu, 13 Jun 2019 14:50:39 +0200 (CEST)
Subject: Re: [PATCH v3 1/4] crypto: talitos - move struct talitos_edesc into
 talitos.h
From:   Christophe Leroy <christophe.leroy@c-s.fr>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <cover.1560429844.git.christophe.leroy@c-s.fr>
 <0ada8523d5765391ddc6899815e0e1eb511bcb7d.1560429844.git.christophe.leroy@c-s.fr>
Message-ID: <eb4463ff-04aa-fc47-e126-c15f39062686@c-s.fr>
Date:   Thu, 13 Jun 2019 14:50:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <0ada8523d5765391ddc6899815e0e1eb511bcb7d.1560429844.git.christophe.leroy@c-s.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 13/06/2019 à 14:48, Christophe Leroy a écrit :
> Moves it into talitos.h so that it can be used
> from any place in talitos.c
> 
> This will be required for next
> patch ("crypto: talitos - fix hash on SEC1")
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Cc: stable@vger.kernel.org

> ---
>   drivers/crypto/talitos.c | 30 ------------------------------
>   drivers/crypto/talitos.h | 30 ++++++++++++++++++++++++++++++
>   2 files changed, 30 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 3b3e99f1cddb..5b401aec6c84 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -951,36 +951,6 @@ static int aead_des3_setkey(struct crypto_aead *authenc,
>   	goto out;
>   }
>   
> -/*
> - * talitos_edesc - s/w-extended descriptor
> - * @src_nents: number of segments in input scatterlist
> - * @dst_nents: number of segments in output scatterlist
> - * @icv_ool: whether ICV is out-of-line
> - * @iv_dma: dma address of iv for checking continuity and link table
> - * @dma_len: length of dma mapped link_tbl space
> - * @dma_link_tbl: bus physical address of link_tbl/buf
> - * @desc: h/w descriptor
> - * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1) (SEC2)
> - * @buf: input and output buffeur (if {src,dst}_nents > 1) (SEC1)
> - *
> - * if decrypting (with authcheck), or either one of src_nents or dst_nents
> - * is greater than 1, an integrity check value is concatenated to the end
> - * of link_tbl data
> - */
> -struct talitos_edesc {
> -	int src_nents;
> -	int dst_nents;
> -	bool icv_ool;
> -	dma_addr_t iv_dma;
> -	int dma_len;
> -	dma_addr_t dma_link_tbl;
> -	struct talitos_desc desc;
> -	union {
> -		struct talitos_ptr link_tbl[0];
> -		u8 buf[0];
> -	};
> -};
> -
>   static void talitos_sg_unmap(struct device *dev,
>   			     struct talitos_edesc *edesc,
>   			     struct scatterlist *src,
> diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
> index 32ad4fc679ed..95f78c6d9206 100644
> --- a/drivers/crypto/talitos.h
> +++ b/drivers/crypto/talitos.h
> @@ -42,6 +42,36 @@ struct talitos_desc {
>   
>   #define TALITOS_DESC_SIZE	(sizeof(struct talitos_desc) - sizeof(__be32))
>   
> +/*
> + * talitos_edesc - s/w-extended descriptor
> + * @src_nents: number of segments in input scatterlist
> + * @dst_nents: number of segments in output scatterlist
> + * @icv_ool: whether ICV is out-of-line
> + * @iv_dma: dma address of iv for checking continuity and link table
> + * @dma_len: length of dma mapped link_tbl space
> + * @dma_link_tbl: bus physical address of link_tbl/buf
> + * @desc: h/w descriptor
> + * @link_tbl: input and output h/w link tables (if {src,dst}_nents > 1) (SEC2)
> + * @buf: input and output buffeur (if {src,dst}_nents > 1) (SEC1)
> + *
> + * if decrypting (with authcheck), or either one of src_nents or dst_nents
> + * is greater than 1, an integrity check value is concatenated to the end
> + * of link_tbl data
> + */
> +struct talitos_edesc {
> +	int src_nents;
> +	int dst_nents;
> +	bool icv_ool;
> +	dma_addr_t iv_dma;
> +	int dma_len;
> +	dma_addr_t dma_link_tbl;
> +	struct talitos_desc desc;
> +	union {
> +		struct talitos_ptr link_tbl[0];
> +		u8 buf[0];
> +	};
> +};
> +
>   /**
>    * talitos_request - descriptor submission request
>    * @desc: descriptor pointer (kernel virtual)
> 
