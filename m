Return-Path: <SRS0=AJZI=ZP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393F6C432C3
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 00:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E71120706
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 00:06:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="tpnX4/RL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfKWAGl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 19:06:41 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35983 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKWAGl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 19:06:41 -0500
Received: by mail-lj1-f193.google.com with SMTP id k15so9289777lja.3
        for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2019 16:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=6hoEjv4GknJUsmfdRkobSNofLY3cRG/hpdfy08jf1HU=;
        b=tpnX4/RLnpYJYu8YH9VDntEatdYoVhfPSGUkNFajOx0QQ+dDDlgtQOzzzeabuXbjUg
         rQhWV4mKV1gRt1wpQyZwiiDDY4au7RSGxwRMy9Rg5xTBqSv78dwcl8sARPAGBEjPUY3T
         HrbXaND7KJxEKl7R4EH/ngLZYM4PtatHtPh3AEmoSKdeiz0n8wCx38l4yPfRIOctKdd+
         vYCv2k2XzdgGxDAQqhaJn4zQaZBelfPQprkI1TduY2noOFX0jKuy5ovd3urNFZW3Ti6x
         84+GoYP8IEmOAyNVnFkm7MNE/Adfqp0np3bPJmN7SPqoqUCpUpT5t2svjeCjVJoRq+xs
         CtJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6hoEjv4GknJUsmfdRkobSNofLY3cRG/hpdfy08jf1HU=;
        b=G7McbJtkEFSAA5mU4WgpLACHBdlZNrNwRi+GDwx2/BKUATgz7F5ddQpufRcpTFjWQE
         BBxQpXA8k2D78QAtm0xU22nvy2HCupqYDtqnx9xrrFU+nqlZW2t/f1zFsirvz7AyM1RO
         lrFoK39Hcxh2jJf+eMbu+eIW4EUIv53Zubc5pWRGiOens7HNjZQip7TXMWg5SK/tPDhb
         eSgF7yDnnEAoPUMyR/lev2u3rZ4mYdXOU6t+oZv1FqL9KsqPgInBy0mqQbn7lUg7ATyr
         xIuV7+lqr9+aqALLCV7apPLzOBRkfnJ9WLWDek7GZ1WWxuTSJ1tN8SWgAIHZ4CPS1ykf
         IDIQ==
X-Gm-Message-State: APjAAAUOoBejrtOZ2g/RQDF5kPxLZeis88h3/scX6N7lBorKwM1DD3tQ
        Y3dSZ0owoZbHFQU9Is6/0r08tw==
X-Google-Smtp-Source: APXvYqyoBZC+ZZk15cm8tra2bjACzr6lq2864hEkgra03uU9yFvR1FOXZh6bT1JRp263KcVzVGqHRA==
X-Received: by 2002:a2e:9886:: with SMTP id b6mr879314ljj.47.1574467597306;
        Fri, 22 Nov 2019 16:06:37 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z23sm585596ljh.35.2019.11.22.16.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 16:06:37 -0800 (PST)
Date:   Fri, 22 Nov 2019 16:06:29 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        nirranjan@chelsio.com, atul.gupta@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next v2 1/3] cxgb4/chcr: update SGL DMA unmap for
 USO
Message-ID: <20191122160629.3800b5cc@cakuba.netronome.com>
In-Reply-To: <6cf3a3928ff2ee84cca34bfcb61d3f7fcb4c4cac.1574383652.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
        <6cf3a3928ff2ee84cca34bfcb61d3f7fcb4c4cac.1574383652.git.rahul.lakkireddy@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 22 Nov 2019 06:30:01 +0530, Rahul Lakkireddy wrote:
> The FW_ETH_TX_EO_WR used for sending UDP Segmentation Offload (USO)
> requests expects the headers to be part of the descriptor and the
> payload to be part of the SGL containing the DMA mapped addresses.
> Hence, the DMA address in the first entry of the SGL can start after
> the packet headers. Currently, unmap_sgl() tries to unmap from this
> wrong offset, instead of the originally mapped DMA address.
>=20
> So, use existing unmap_skb() instead, which takes originally saved DMA
> addresses as input. Update all necessary Tx paths to save the original
> DMA addresses, so that unmap_skb() can unmap them properly.
>=20
> v2:
> - No change.
>=20
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/eth=
ernet/chelsio/cxgb4/cxgb4.h
> index 3121ed83d8e2..61a2cf62f694 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
> @@ -735,7 +735,12 @@ struct tx_desc {
>  	__be64 flit[8];
>  };
> =20
> -struct tx_sw_desc;
> +struct ulptx_sgl;

=46rom this patch alone the forward declaration of struct ulptx_sgl;
appears unnecessary or a left over from some previous version of the
code?

> +struct tx_sw_desc {
> +	struct sk_buff *skb; /* SKB to free after getting completion */
> +	dma_addr_t addr[MAX_SKB_FRAGS + 1]; /* DMA mapped addresses */
> +};
> =20
>  struct sge_txq {
>  	unsigned int  in_use;       /* # of in-use Tx descriptors */
