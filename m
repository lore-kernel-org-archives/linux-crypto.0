Return-Path: <SRS0=ep2G=7K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DFF8C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 15:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 157552089D
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 15:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590679427;
	bh=ssEOS8OsNB7w2lPUqC7Kt6GrGMtAxooOHWUGtkeD0ZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=vYlJjGWKADNtgm1vLPCDcg+AfdegmPnHLbfRSoKP8esfwSBFWzLNMIdXT5yAKoDO0
	 syxfdMZRDow/4RfymmTVmtRCqXN0N23P7AjGz+6IsWXtLNh4apWiT+PSMZHEJrqG9u
	 ubSUYyrNOjIEcb0VP/tsAePPcQNQXIFPnG8Vwoas=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404236AbgE1PXq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 May 2020 11:23:46 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:34287 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404237AbgE1PXo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 May 2020 11:23:44 -0400
Received: by mail-il1-f194.google.com with SMTP id v11so538632ilh.1;
        Thu, 28 May 2020 08:23:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3MZqovCTFsHtuU3AlxuPii9iox97+M6kfxtFcPtKXC8=;
        b=MGwh1fdE/9wvYD2bwZoqkOQnSQmueujMZLvPf0MknyeBmUT+44xalPnoI4afGZd894
         164g9rcAYDyqlX9lX2uS62njS3RGD9H/igJvjHljRxpq17buMFAx6cElziLIQvyC3BpG
         I6TVY1Ypv4SDOncAlQMVu1cCRsc9ke3AVtMlh6fEedP+E0CW6K5IqHuTlu50ejwDFqHk
         Fpc2MtQDb8cHKBrY+N90kT5rUhRx0QQqnIGN7yX66nLCcZzJ5yaAm2pdeoRRJZEEPDlE
         CpZNPs6a53q1va+ZpiKGmcOIFXxwyFd2A2uRr6Q/u06J2qJavVL+SpCtRvt6hkXT/9/Q
         wrEg==
X-Gm-Message-State: AOAM533HzJ/txJBlWUN+5G0glaW1ERWK51z3d4lEz2ICcp702OT2UaO1
        iD45gK0+sVCsCvqSyU89rwlFsv8=
X-Google-Smtp-Source: ABdhPJxUkSWOlu7vQ4GNTLfLxYpE7N0s58QWRuBC0kan2EkWTVkhw18G1Yfx4yPiN7Bd1vlORdMOGA==
X-Received: by 2002:a92:8b13:: with SMTP id i19mr3469931ild.46.1590679423093;
        Thu, 28 May 2020 08:23:43 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id 199sm3495162ilb.11.2020.05.28.08.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 08:23:42 -0700 (PDT)
Received: (nullmailer pid 103803 invoked by uid 1000);
        Thu, 28 May 2020 15:23:41 -0000
Date:   Thu, 28 May 2020 09:23:41 -0600
From:   Rob Herring <robh@kernel.org>
To:     Tero Kristo <t-kristo@ti.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        Keerthy <j-keerthy@ti.com>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCHv3 1/7] dt-bindings: crypto: Add TI SA2UL crypto
 accelerator documentation
Message-ID: <20200528152341.GA103581@bogus>
References: <20200511215343.GA10123@bogus>
 <20200514125005.23641-1-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514125005.23641-1-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 14 May 2020 15:50:05 +0300, Tero Kristo wrote:
> From: Keerthy <j-keerthy@ti.com>
> 
> The Security Accelerator Ultra Lite (SA2UL) subsystem provides hardware
> cryptographic acceleration for the following use cases:
> 
> * Encryption and authentication for secure boot
> * Encryption and authentication of content in applications
>   requiring DRM (digital rights management) and
>   content/asset protection
> 
> SA2UL provides support for number of different cryptographic algorithms
> including SHA1, SHA256, SHA512, AES, 3DES, and various combinations of
> the previous for AEAD use.
> 
> Cc: Rob Herring <robh@kernel.org>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> [t-kristo@ti.com: converted documentation to yaml]
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> ---
> v3:
>   - fixed a typo in rng child node regex
> 
>  .../devicetree/bindings/crypto/ti,sa2ul.yaml  | 76 +++++++++++++++++++
>  1 file changed, 76 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
