Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CEAC76190
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 18:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E79F72190D
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 18:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563820189;
	bh=AannP34ISTyfCZ+bmQenOeogA+nA+MdR+5/JoZnEqyc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=jN4Aa42PT9wXc++Ujnr4zDDPPQujcMp90a9tSsbvwxLSOXeqRXjCBFn+rdjXNXb6u
	 eMTWOWaaD76Jdl3Ndhu75zUFmcFBRGwBXYSjxyEdKmpke52147tlQjz5uRy5PcYgVw
	 J7tmYkZiix9KSe0MdyzqPX0zAr4KTg46VEq9DXBE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfGVS3s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 14:29:48 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46928 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfGVS3s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 14:29:48 -0400
Received: by mail-io1-f67.google.com with SMTP id i10so76047317iol.13;
        Mon, 22 Jul 2019 11:29:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=45VBkdwbSdeHAF4CxCfsEpgQ0Hv/6sDXiE8u86RMzcI=;
        b=IZIt2+RVNjyF2ssqvoKGkE6xxKzL5ipnDwP7ThDkQP07rUwEG5iUpyzH9iu8u6GTFU
         uwyKZqDScUe68uRYqDrSrO91HrXRT1/W08BNhFnmGvT+n8U0AgC1AegeAp7POcp2K0j1
         fOy5K37tatq3VxEu3ZxMtbG1lHC0YwfXEsvO/CS8tIsggk5cnWGfBV7QGodrRwh1recH
         pjtJIffPGCvfi7U8d1xFDkmbA1o/7IaI6UFyOb5+bdYsvcqRcOmFwlueF9zZyd1Nzoke
         /3swTKv+SeurkpGUXaPfV9jkOOrGAcRBelCSpua0ZPB6g/ahwHJOpgthhqnxtixEzSjw
         qp4A==
X-Gm-Message-State: APjAAAUBp6cV5ssiobizmzI64Q7GPxVcsx7NVuqQscrTMSuvKz2+MLIu
        FTQXvoD8JExn9xgldXtAlg==
X-Google-Smtp-Source: APXvYqy0/9HHdGzLDl2P0Oto77pOLJAS7xoNpItq0R4cBSAOfioLfzVoEKB8XKnU2bhgimfk2b6elw==
X-Received: by 2002:a02:c6b8:: with SMTP id o24mr2514691jan.80.1563820186890;
        Mon, 22 Jul 2019 11:29:46 -0700 (PDT)
Received: from localhost ([64.188.179.254])
        by smtp.gmail.com with ESMTPSA id d25sm33325592iom.52.2019.07.22.11.29.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 11:29:46 -0700 (PDT)
Date:   Mon, 22 Jul 2019 12:29:45 -0600
From:   Rob Herring <robh@kernel.org>
To:     Keerthy <j-keerthy@ti.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, t-kristo@ti.com,
        linux-crypto@vger.kernel.org, nm@ti.com
Subject: Re: [RESEND PATCH 01/10] dt-bindings: crypto: k3: Add sa2ul bindings
 documentation
Message-ID: <20190722182945.GA24685@bogus>
References: <20190628042745.28455-1-j-keerthy@ti.com>
 <20190628042745.28455-2-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190628042745.28455-2-j-keerthy@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 28, 2019 at 09:57:36AM +0530, Keerthy wrote:
> The series adds Crypto hardware accelerator support for SA2UL.
> SA2UL stands for security accelerator ultra lite.
> 
> The Security Accelerator (SA2_UL) subsystem provides hardware
> cryptographic acceleration for the following use cases:
> • Encryption and authentication for secure boot
> • Encryption and authentication of content in applications
>   requiring DRM (digital rights management) and
>   content/asset protection
> The device includes one instantiation of SA2_UL named SA2_UL0
> 
> SA2UL needs on tx channel and a pair of rx dma channels.
> 
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  .../devicetree/bindings/crypto/sa2ul.txt      | 47 +++++++++++++++++++
>  1 file changed, 47 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/sa2ul.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/sa2ul.txt b/Documentation/devicetree/bindings/crypto/sa2ul.txt
> new file mode 100644
> index 000000000000..81cc039673b4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/sa2ul.txt
> @@ -0,0 +1,47 @@
> +K3 SoC SA2UL crypto module
> +
> +Required properties:
> +
> +- compatible : Should be:
> +  - "ti,sa2ul-crypto"

Needs to be SoC specific.

> +- reg : Offset and length of the register set for the module
> +
> +- dmas: DMA specifiers for tx and rx dma. sa2ul needs one tx channel
> +	and 2 rx channels. First rx channel for < 256 bytes and
> +	the other one for >=256 bytes. See the DMA client binding,
> +        Documentation/devicetree/bindings/dma/dma.txt
> +- dma-names: DMA request names has to have one tx and 2 rx names
> +	corresponding to dmas abive.
> +- ti,psil-config* - UDMA PSIL native Peripheral using packet mode.
> +	SA2UL must have EPIB(Extended protocal information block)
> +	and PSDATA(protocol specific data) properties.

If ti,needs-epib is required, then why do you need to specify it in DT? 
In any case, this all seems like channel config info that should be part 
of the #dma-cells.

Also, don't use vendor prefixes on node names.

> +
> +Example AM654 SA2UL:
> +crypto: crypto@4E00000 {
> +	compatible = "ti,sa2ul-crypto";
> +	reg = <0x0 0x4E00000 0x0 0x1200>;
> +	ti,psil-base = <0x4000>;
> +
> +	dmas = <&main_udmap &crypto 0 UDMA_DIR_TX>,
> +		<&main_udmap &crypto 0 UDMA_DIR_RX>,
> +		<&main_udmap &crypto 1 UDMA_DIR_RX>;
> +	dma-names = "tx", "rx1", "rx2";
> +
> +	ti,psil-config0 {
> +		linux,udma-mode = <UDMA_PKT_MODE>;
> +		ti,needs-epib;
> +		ti,psd-size = <64>;
> +	};
> +
> +	ti,psil-config1 {
> +		linux,udma-mode = <UDMA_PKT_MODE>;
> +		ti,needs-epib;
> +		ti,psd-size = <64>;
> +	};
> +
> +	ti,psil-config2 {
> +		linux,udma-mode = <UDMA_PKT_MODE>;
> +		ti,needs-epib;
> +		ti,psd-size = <64>;
> +	};
> +};
> -- 
> 2.17.1
> 
