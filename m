Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52841C76190
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 22:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20E71229F9
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 22:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564095345;
	bh=g812QekVhk9YTdEBM9x7cM1JCaC9kZOURpxH8pDFoBY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=hucypHTIZBjEtWSG+GL6j2CfZN/LVEsJdtAzHeFK7ymQXGtuAjKRRpA0VMb+Erd2V
	 D02FvEN8RSIYLshDJw4een4zoWSoQy4NM70wyP/tXHZ3OBBU2pU1t6jvfM1Et42B2l
	 l4yNEKqgSbFvY4BI8OShLyg8MZYkYhl/v0MzidKg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfGYWzo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 18:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbfGYWzo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 18:55:44 -0400
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D58222C7C;
        Thu, 25 Jul 2019 22:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564095342;
        bh=g812QekVhk9YTdEBM9x7cM1JCaC9kZOURpxH8pDFoBY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Dz09u9S+Y3r70TocpuCA7IhoTLlYKdq7e+lwmbq167Zr4gqovWvCkIFvioJzQc30E
         UExAFN0EUnJRkGN7juvvECfcyT/2dxBkDeevZjvKHHIjF+P3AGjXUkTgj812rRiWOK
         Eqxe4SYbimo13thxamdtxgOCzguesjyhhx+fJq8w=
Received: by mail-qt1-f172.google.com with SMTP id h18so50763315qtm.9;
        Thu, 25 Jul 2019 15:55:42 -0700 (PDT)
X-Gm-Message-State: APjAAAULM5dbKVfmFz8HHWJU32uUu7JoGoERmWGE3E4mjiQffKlxmz1X
        5akBSq8CsoxPFEkfIJGKaZiV0Kl2rKw+f0Dt9w==
X-Google-Smtp-Source: APXvYqz9DMpk570nuBSorqgYVEjSnP43DJEbGzpTBLg6Vx9QqBo6uQGIKBtq4PAJy2WytaI2Mv9aGYuTo7fmld4NaC4=
X-Received: by 2002:a0c:b786:: with SMTP id l6mr65611308qve.148.1564095341588;
 Thu, 25 Jul 2019 15:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <1564083776-20540-1-git-send-email-clabbe@baylibre.com> <1564083776-20540-2-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1564083776-20540-2-git-send-email-clabbe@baylibre.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 25 Jul 2019 16:55:30 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLbYwRpNWHGkYbomWLMpum_DXW4OjNNRrwTRM=w86dONw@mail.gmail.com>
Message-ID: <CAL_JsqLbYwRpNWHGkYbomWLMpum_DXW4OjNNRrwTRM=w86dONw@mail.gmail.com>
Subject: Re: [PATCH 1/4] dt-bindings: crypto: Add DT bindings documentation
 for amlogic-crypto
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kevin Hilman <khilman@baylibre.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        baylibre-upstreaming@groups.io
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 25, 2019 at 1:43 PM Corentin Labbe <clabbe@baylibre.com> wrote:
>
> This patch adds documentation for Device-Tree bindings for the
> Amlogic GXL cryptographic offloader driver.
>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  .../bindings/crypto/amlogic-gxl-crypto.yaml   | 45 +++++++++++++++++++

Follow the compatible string for the filename: amlogic,gxl-crypto.yaml

>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/amlogic-gxl-crypto.yaml
>
> diff --git a/Documentation/devicetree/bindings/crypto/amlogic-gxl-crypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic-gxl-crypto.yaml
> new file mode 100644
> index 000000000000..41265e57c00b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/amlogic-gxl-crypto.yaml
> @@ -0,0 +1,45 @@
> +# SPDX-License-Identifier: GPL-2.0

Dual (GPL-2.0 OR BSD-2-Clause) is preferred for new bindings. Not a
requirement though.

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/amlogic-gxl-crypto.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Amlogic GXL Cryptographic Offloader
> +
> +maintainers:
> +  - Corentin Labbe <clabbe@baylibre.com>
> +
> +properties:
> +  compatible:
> +    oneOf:

Don't need 'oneOf' when there is only 1.

> +      - const: amlogic,gxl-crypto
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    const: blkmv
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - clock-names
> +
> +examples:
> +  - |
> +    crypto: crypto@c883e000 {
> +        compatible = "amlogic,gxl-crypto";
> +        reg = <0x0 0xc883e000 0x0 0x36>;

This should throw errors because the default size on examples are 1
cell. But validating the examples with the schema only just landed in
5.3-rc1.

> +        interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>,
> +            <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;

This doesn't match the schema.

> +        clocks = <&clkc CLKID_BLKMV>;
> +        clock-names = "blkmv";
> +    };
> --
> 2.21.0
>
