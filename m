Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD91BC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 18:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B69E860FD7
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Sep 2021 18:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhI0SCl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Sep 2021 14:02:41 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:46770 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235757AbhI0SCl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Sep 2021 14:02:41 -0400
Received: by mail-ot1-f42.google.com with SMTP id o59-20020a9d2241000000b0054745f28c69so23472781ota.13;
        Mon, 27 Sep 2021 11:01:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bk6IEL1uZf2s3dmk9m5afP7AhxL2b1kO1A39LyNaXkM=;
        b=fp+/51zeajmpv0BBka8cdE+n0Xgn5zR7QvehDlgPBEhL+/FSJkkaG5vWheNLVLxm8j
         m4SN081RkafWUMqyr3jbxbnS/L4bD/9bGdJjGyXkmg2LyV68ukezFMh5vhSPczrs31jr
         kWKQZG/1Bqf15V+8EvxAzjH06wKTxOViA/p1/MHfV+AsXPtHki+Q537JatHF6sWEbLuK
         flbMAo5A7jMVXIY8E/hjLxUCvUjyOf03OgHHuCr/nRFxaWbJ5hglp/yGE//UqDAFyZ3e
         4Kv01SD1TnfUsb8Ss6qOJgKv+OnYG0EWjQOdOfN5WXsuFzIW4yFxb/z5iriwOMPnjuXV
         qf4w==
X-Gm-Message-State: AOAM530iqDbUGZfBPbW26Y/Gcslt/Fc+N/MJRMZRmYDRJ662Z/m7ZLCL
        4cRIMkv4dlRjRntrO+aNeA==
X-Google-Smtp-Source: ABdhPJy1u1047PO9kAE4IDPov+AHa+ZWbRS+2hfY06WstvUKSl+QP0r+E7Y8mYsUq1/d7F3I8OpOWw==
X-Received: by 2002:a05:6830:2f2:: with SMTP id r18mr1223863ote.228.1632765662725;
        Mon, 27 Sep 2021 11:01:02 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id g23sm4108432otl.23.2021.09.27.11.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 11:01:02 -0700 (PDT)
Received: (nullmailer pid 3555843 invoked by uid 1000);
        Mon, 27 Sep 2021 18:01:01 -0000
Date:   Mon, 27 Sep 2021 13:01:01 -0500
From:   Rob Herring <robh@kernel.org>
To:     Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
Cc:     devicetree@vger.kernel.org, Ash Logan <ash@heyquark.com>,
        Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.ne@posteo.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/4] dt-bindings: nintendo-aes: Document the Wii and Wii
 U AES support
Message-ID: <YVIG3aOWt7jqtZIl@robh.at.kernel.org>
References: <20210921213930.10366-1-linkmauve@linkmauve.fr>
 <20210921213930.10366-3-linkmauve@linkmauve.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921213930.10366-3-linkmauve@linkmauve.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 21, 2021 at 11:39:28PM +0200, Emmanuel Gil Peyrot wrote:
> Both of these consoles use the exact same AES engine, which only
> supports CBC mode with 128-bit keys.
> 
> Signed-off-by: Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
> ---
>  .../bindings/crypto/nintendo-aes.yaml         | 34 +++++++++++++++++++
>  1 file changed, 34 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/nintendo-aes.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/nintendo-aes.yaml b/Documentation/devicetree/bindings/crypto/nintendo-aes.yaml
> new file mode 100644
> index 000000000000..e62a2bfc571c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/nintendo-aes.yaml
> @@ -0,0 +1,34 @@
> +# SPDX-License-Identifier: GPL-2.0

Dual license new bindings. checkpatch.pl will tell you this.

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/nintendo-aes.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Nintendo Wii and Wii U AES engine
> +
> +maintainers:
> +  - Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
> +
> +description: |+
> +  The AES engine in the Nintendo Wii and Wii U supports the following:
> +  -- Advanced Encryption Standard (AES) in CBC mode, with 128-bit keys
> +
> +properties:
> +  compatible:
> +    items:
> +      - const: nintendo,hollywood-aes
> +      - const: nintendo,latte-aes
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    description: Not supported yet.
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +additionalProperties: false
> -- 
> 2.33.0
> 
> 
