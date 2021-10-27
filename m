Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF12DC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 13:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDEA660EC0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 13:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242301AbhJ0OAw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 10:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237334AbhJ0OAv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 10:00:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3157E60F92
        for <linux-crypto@vger.kernel.org>; Wed, 27 Oct 2021 13:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635343106;
        bh=BBhwd/vezctBQooL/UqogS1ED+sRTCohZTgEAKzRk5c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qOpz2yT0W3wG/mmGShNCGpxFunKVud3bqeuQYwnkm32xYGAJYs/8C9lB3yF+SD/Fu
         N493Sgy3+BXbq3pdTWh2H/UOS6oG/zNtVSBY8WBzrhDkb5jn9MdvTEY+g8iz4ifBmP
         5rmlch/btNZdQnBmlz6ihGXCtFc4gXjafPzg5OIUbD1qPvq6zE7kl+1t19eW6qQoUm
         2SaP/dD0nZS8Mqund4L+lzx+Psu49KHxeuM3hsnqvrg2qQ3BGe0U7rXB8mFGa+eLbO
         PPvdULCxa1QzpyfBS1CNDmEGJxgKYeI088RjN/xsnhIy2qzPRrHWr7tRcEjfNgn75i
         socCmPv4Uiw6g==
Received: by mail-ed1-f52.google.com with SMTP id w15so10943594edc.9
        for <linux-crypto@vger.kernel.org>; Wed, 27 Oct 2021 06:58:26 -0700 (PDT)
X-Gm-Message-State: AOAM530X3aZ5yfgNaHisomEeskNYntocAFMXFlAYmPpOxzbT/JNe2swS
        7W8/SyGFcbQoPFM6wj5yPpSRvAVIfCBmw2db1Q==
X-Google-Smtp-Source: ABdhPJxo6Nm2/Rtxy0DIEwCe1A0tsdRb3RVyOLXqu8Iums+cOV8r112a+6sPwae9KUtUxSICh/YUErYeesJSndyfGIY=
X-Received: by 2002:a05:6402:643:: with SMTP id u3mr45372529edx.164.1635343097987;
 Wed, 27 Oct 2021 06:58:17 -0700 (PDT)
MIME-Version: 1.0
References: <20211027091329.3093641-1-vschagen@icloud.com> <20211027091329.3093641-2-vschagen@icloud.com>
In-Reply-To: <20211027091329.3093641-2-vschagen@icloud.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 27 Oct 2021 08:58:06 -0500
X-Gmail-Original-Message-ID: <CAL_JsqLrLt_XWP+wc7YaWyWj1ndvvATfoJf98Sf94SohcvF_nQ@mail.gmail.com>
Message-ID: <CAL_JsqLrLt_XWP+wc7YaWyWj1ndvvATfoJf98Sf94SohcvF_nQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: crypto: Add Mediatek EIP-93 crypto engine
To:     Richard van Schagen <vschagen@icloud.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 27, 2021 at 4:13 AM Richard van Schagen <vschagen@icloud.com> wrote:
>
> Add bindings for the Mediatek EIP-93 crypto engine.

Please resend to DT list so automated checks run and it is in my review queue.

> Signed-off-by: Richard van Schagen <vschagen@icloud.com>
> ---
> Changes since V2:
>  - Adding 2 missing "static" which got lost in my editing (sorry)
>
> Changes since V1
>  - Add missing #include to examples
>
>  .../bindings/crypto/mediatek,mtk-eip93.yaml   | 43 +++++++++++++++++++
>  1 file changed, 43 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
>
> diff --git a/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml b/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
> new file mode 100644
> index 000000000..422870afb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
> @@ -0,0 +1,43 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/mediatek,mtk-eip93.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Mediatek EIP93 crypto engine
> +
> +maintainers:
> +  - Richard van Schagen <vschagen@icloud.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - mediatek, mtk-eip93

Looks like a typo. 'make dt_binding_check' would have pointed this out.

> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts-parent:
> +    maxItems: 1

Drop this. First, it's 'interrupt-parent'. Second, it is valid for
interrupt-parent to be in any parent node as well. So you don't need
to define it here.

> +
> +  interrupts:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupt-parent
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/mips-gic.h>
> +
> +    crypto: crypto@1e004000 {
> +         compatible = "mediatek,mtk-eip93";
> +         reg = <0x1e004000 0x1000>;
> +         interrupt-parent = <&gic>;
> +         interrupts = <GIC_SHARED 19 IRQ_TYPE_LEVEL_HIGH>;
> +    };
> --
> 2.30.2
>
