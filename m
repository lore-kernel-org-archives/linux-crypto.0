Return-Path: <SRS0=vKog=AZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF39C433E7
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 00:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A818B21883
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 00:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594685040;
	bh=xNYem6YA7j8MbtSO9ITmNVLbUgSZdNCAXdIewZIIF5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Rtct+51Pae/3EtsNjJ/FOaARQn2YtBLCbmNGq4IZ/Pd2Ed3RH64PCd8GDG5G2ldLf
	 VgtfE+ejldZDblscQN0jmA6vrdD9zSlYNXeTNQMXp4c3Bw4uVXkI6lQC/WHL+vKzAC
	 6xv8f6HKQmzC9z3QZJYngZYxTBVuw6quWgv7y1z8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgGNADz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 20:03:55 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38270 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgGNADz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 20:03:55 -0400
Received: by mail-io1-f68.google.com with SMTP id l1so15468236ioh.5;
        Mon, 13 Jul 2020 17:03:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=evai81ZnlRDbfusVNXIm1GHJcQ/JXmRNmH72lDjI1z0=;
        b=TlO/SMXf/4yISNUp8G2BSjL9ZP6T/lzVl3Y2V+DsfC2iou6GcaRFnaWPgo30db5xMt
         SpvZOhD+oEmKU7eiQ3cw2pH8ahmdA7gdfeoF5H1WP0W27KQDIB298bQ98s780PcnqkIB
         tDLgUx7fAON4ApLmf5Wd0EhZ4UFQPFslIBHxvwCQOi99XSql7gs/STzwf9Wj/9SS7RTn
         V5nF/nepEKsll14WM1amacVyJMbrTJd9WlRsyjK2AH+ZxNNVtLRnJYMCgYyqPkXa4B6R
         YS29O7H/PIelucIMTkufMEVENhi/L+QQe/FzE3s8IAtsaPZhre4aYDBxr4liblK+EVmE
         kpLQ==
X-Gm-Message-State: AOAM5314HLHyCLwEJSlJKpt8YPcohOIP0FgITyKGsXgTiBawM66ZSfGl
        4Jk5R/KRx3Eaakto3gBiNg==
X-Google-Smtp-Source: ABdhPJwmp0epEIu44qjO8H2aC4abKmodnsLUIgzBjPG6vi2TMwpK56lYVwvbS1d4waPrIsEMMIgHhA==
X-Received: by 2002:a02:ccb3:: with SMTP id t19mr2982333jap.122.1594685034204;
        Mon, 13 Jul 2020 17:03:54 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id f206sm8678056ilh.75.2020.07.13.17.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 17:03:53 -0700 (PDT)
Received: (nullmailer pid 968214 invoked by uid 1000);
        Tue, 14 Jul 2020 00:03:52 -0000
Date:   Mon, 13 Jul 2020 18:03:52 -0600
From:   Rob Herring <robh@kernel.org>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dt-bindings: rng: add RNGB compatibles for i.MX6
 SoCs
Message-ID: <20200714000352.GA966545@bogus>
References: <20200621145658.12528-1-horia.geanta@nxp.com>
 <20200621145658.12528-2-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200621145658.12528-2-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jun 21, 2020 at 05:56:54PM +0300, Horia Geantă wrote:
> RNGB block is found in some i.MX6 SoCs - 6SL, 6SLL, 6ULL, 6ULZ.
> Add corresponding compatible strings.
> 
> Note:
> 
> Several NXP SoC from QorIQ family (P1010, P1023, P4080, P3041, P5020)
> also have a RNGB, however it's part of the CAAM
> (Cryptograhic Accelerator and Assurance Module) crypto accelerator.
> In this case, RNGB is managed in the caam driver
> (drivers/crypto/caam/), since it's tightly related to
> the caam "job ring" interface, not to mention CAAM internally relying on
> RNGB as source of randomness.
> 
> On the other hand, the i.MX6 SoCs with RNGB have a DCP
> (Data Co-Processor) crypto accelerator and this block and RNGB
> are independent.
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>  Documentation/devicetree/bindings/rng/imx-rng.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/rng/imx-rng.txt b/Documentation/devicetree/bindings/rng/imx-rng.txt
> index 405c2b00ccb0..eb227db9e684 100644
> --- a/Documentation/devicetree/bindings/rng/imx-rng.txt
> +++ b/Documentation/devicetree/bindings/rng/imx-rng.txt
> @@ -5,6 +5,9 @@ Required properties:
>                 "fsl,imx21-rnga"
>                 "fsl,imx31-rnga" (backward compatible with "fsl,imx21-rnga")
>                 "fsl,imx25-rngb"
> +               "fsl,imx6sl-rngb"
> +               "fsl,imx6sll-rngb"
> +               "fsl,imx6ull-rngb"

These are all different? IOW, no fallback compatible?

>                 "fsl,imx35-rngc"
>  - reg : offset and length of the register set of this block
>  - interrupts : the interrupt number for the RNG block
> -- 
> 2.17.1
> 
