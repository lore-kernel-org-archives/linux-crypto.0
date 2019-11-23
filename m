Return-Path: <SRS0=AJZI=ZP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D16C432C0
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 00:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F45C20714
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 00:13:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="gnatq38e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKWANq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 19:13:46 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46194 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfKWANq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 19:13:46 -0500
Received: by mail-lj1-f194.google.com with SMTP id e9so9240228ljp.13
        for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2019 16:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=oAs+JmaUc1Xh8VoI1jiWKg76cgJyN1N3rWvMjoZ0nq8=;
        b=gnatq38egwfsVsw2BzsFmBCBQcs8n9IkycpMvXuq2eLUlvy2PwloYud/QHy6EGlYTr
         k+HMaiL8bN6v5a8ibCUmUmn8bV8thSFTzwDNLFPV1mC1JXRCnZ2pGAYea8MpYipWv0O4
         8p2MvvQ7WBITx02PZqfUN3XBixyzQc/nZUBfzQFOmcUg7Mr5XFR6okvxGCnW8ubOh1Jl
         Oh4DN+oZ4BoJU6N0xAlzA7vA901Dg7F5ceAqceITJfvUq6QEaYKWuPnDSsd0f0hdyozY
         PlrhuAIno/bYK/1hr/FOS6bcAlKTExb1dYlqSOEW1TI61EzVwUVeKfvE/zhIxEND953e
         aP2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=oAs+JmaUc1Xh8VoI1jiWKg76cgJyN1N3rWvMjoZ0nq8=;
        b=Xhqj4v1TrEutdzQURGMViN0hZLbvSUhZX6sh+hWDCXHm2GtU1d/fyHJn4VskCgmgJU
         xXEW1CVTaTbYtK/oDviUrXEZuUzJ80fxxFa+vRJONSBy9ZtIUO2Y6odgZG+82a7Pz2X1
         WulXzc5IQ7Qkepfj5Kjkm/LH9FAy28qVjrpaHGE7U+v7t8WopTO1BvagdvUD1zeuLgXc
         5FqB9DO8zgm0lu1KzsiI/fFzXCNdoQbmSrxZmmQ2tPvUEJpFrgf/RSImZ810Ddt694Hg
         sXMNsupEtJDeY9I22xkaBqC8xyf9CQxfznNl1jz62PzjMeN9B9/zJ9pnGS+fJWEMc5nf
         0m3g==
X-Gm-Message-State: APjAAAUeWiUYdwzHI7Ls5GGu2+Pq0scZ6XbQizx9DxAjKvZkzU/dpTCD
        2WYP95M+/NETbeETSc8f3frP8g==
X-Google-Smtp-Source: APXvYqzeVIH51PikCC6VhqxCzxBFnRWouvto6+gBS/fJ5YpWjBpJ2e+rCz3sOv6+yMo0plhRphEx7g==
X-Received: by 2002:a2e:8518:: with SMTP id j24mr13089598lji.13.1574468024093;
        Fri, 22 Nov 2019 16:13:44 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z12sm3789202lfi.84.2019.11.22.16.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 16:13:43 -0800 (PST)
Date:   Fri, 22 Nov 2019 16:13:34 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        nirranjan@chelsio.com, atul.gupta@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next v2 2/3] cxgb4: add UDP segmentation offload
 support
Message-ID: <20191122161334.44de6174@cakuba.netronome.com>
In-Reply-To: <1638e6bdd3aa9a4536aaeb644418d2a0ff5e5368.1574383652.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
        <1638e6bdd3aa9a4536aaeb644418d2a0ff5e5368.1574383652.git.rahul.lakkireddy@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 22 Nov 2019 06:30:02 +0530, Rahul Lakkireddy wrote:
> Implement and export UDP segmentation offload (USO) support for both
> NIC and MQPRIO QoS offload Tx path. Update appropriate logic in Tx to
> parse GSO info in skb and configure FW_ETH_TX_EO_WR request needed to
> perform USO.
> 
> v2:
> - Remove inline keyword from write_eo_udp_wr() in sge.c. Let the
>   compiler decide.
> 
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> index 76538f4cd595..f57457453561 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
> @@ -91,6 +91,7 @@ static const char stats_strings[][ETH_GSTRING_LEN] = {
>  	"rx_bg3_frames_trunc    ",
>  
>  	"tso                    ",
> +	"uso                    ",

Oh wow, the spaces, people's inventiveness when it comes to ethtool free
form strings knows no bounds..

That's not a review comment, I just wanted to say that :)

>  	"tx_csum_offload        ",
>  	"rx_csum_good           ",
>  	"vlan_extractions       ",

> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> index e8a1826a1e90..12ff69b3ba91 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> @@ -1136,11 +1136,17 @@ static u16 cxgb_select_queue(struct net_device *dev, struct sk_buff *skb,
>  
>  	if (dev->num_tc) {
>  		struct port_info *pi = netdev2pinfo(dev);
> +		u8 ver, proto;
> +
> +		ver = ip_hdr(skb)->version;
> +		proto = (ver == 6) ? ipv6_hdr(skb)->nexthdr :
> +				     ip_hdr(skb)->protocol;

Checking ip version now looks potentially like a fix?

>  		/* Send unsupported traffic pattern to normal NIC queues. */
>  		txq = netdev_pick_tx(dev, skb, sb_dev);
>  		if (xfrm_offload(skb) || is_ptp_enabled(skb, dev) ||
> -		    ip_hdr(skb)->protocol != IPPROTO_TCP)
> +		    skb->encapsulation ||

The addition of encapsulation check also looks unrelated? 

> +		    (proto != IPPROTO_TCP && proto != IPPROTO_UDP))
>  			txq = txq % pi->nqsets;
>  
>  		return txq;
> @@ -5838,7 +5844,8 @@ static void free_some_resources(struct adapter *adapter)
>  		t4_fw_bye(adapter, adapter->pf);
>  }
>  
> -#define TSO_FLAGS (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN)
> +#define TSO_FLAGS (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN | \
> +		   NETIF_F_GSO_UDP_L4)
>  #define VLAN_FEAT (NETIF_F_SG | NETIF_F_IP_CSUM | TSO_FLAGS | \
>  		   NETIF_F_GRO | NETIF_F_IPV6_CSUM | NETIF_F_HIGHDMA)
>  #define SEGMENT_SIZE 128
