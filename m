Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71EC4C31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 23:36:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43CDB20665
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 23:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565652987;
	bh=BM4sVVQhsgV0eA0tvBOKqoxFmCiLYfxMnLfacEen5tc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=YVeSRFx5gDXMN/sRNK4nls8JGbx42DbF4SrTbg55uC8j2vLPDn9wNcpsd9F3Ppd0H
	 9iRAfyUqd/6dPvcHBIQ9Bi9+7kUk5Pb2K0Db2KejgiLYg+HCfgg8JSeJ99WWsAEXRq
	 clmNPehHSYVws++LNnAdZkQHj1LgzIlNsbeRP+iQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfHLXg0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 19:36:26 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45901 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfHLXg0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 19:36:26 -0400
Received: by mail-ot1-f67.google.com with SMTP id m24so12665375otp.12;
        Mon, 12 Aug 2019 16:36:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JUhoBbFfJyoEZHhxE0yhHd01Inh7+bhFFQBfYp/6IHI=;
        b=C0wtaisBxNDTA6BgfyRVYslK5Mgpvp8Twaar+oyBoQ34Ki+jw7ss98bZDh0R+Azdf5
         mjLxbOQR0WD65SsY/fv/7nJFyxUgo7OIRx9kwnnXRF4LHvWvEoQhkY14bA2CJqby5yVt
         FyFBJ62lQhqIIULcn5eEfN/Cyvy+J2Fj4qazcuU/Cn1mlceF4CAw0jAO6sFj6pGN8AJv
         Nc4MCl6B6/QTlPlGgFsR1BohWGNOaZl881LMuAXHZxV7jMyrtWBAwx8Fq5rGx6sqVTHH
         GPgkiBNTtT1WAjRaIGwPF1pmBDh6mikJdcQoiQHMx4/OnVM7eMVzSMCsaReu3YlzcpQy
         lAUA==
X-Gm-Message-State: APjAAAV9QRXUUPTCVwvRVJTTDz9Kwz/qSp0f+7+nAReaGPimqs/37kqu
        fHDH5fcjczCKBw96QnqTE3/PxQw=
X-Google-Smtp-Source: APXvYqz7S8FkR6SwClag3erlK+yDMUQoYwEC/imJe9WJrw+kMtxqR06+H2rRmQKOwlNcvAwWgGSluQ==
X-Received: by 2002:a5e:8c11:: with SMTP id n17mr313906ioj.64.1565652984885;
        Mon, 12 Aug 2019 16:36:24 -0700 (PDT)
Received: from localhost ([64.188.179.254])
        by smtp.gmail.com with ESMTPSA id i4sm131555614iog.31.2019.08.12.16.36.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 16:36:24 -0700 (PDT)
Date:   Mon, 12 Aug 2019 17:36:23 -0600
From:   Rob Herring <robh@kernel.org>
To:     Tomer Maimon <tmaimon77@gmail.com>
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, mark.rutland@arm.com,
        avifishman70@gmail.com, tali.perry1@gmail.com, venture@google.com,
        yuenn@google.com, benjaminfair@google.com, sumit.garg@linaro.org,
        jens.wiklander@linaro.org, vkoul@kernel.org, tglx@linutronix.de,
        joel@jms.id.au, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        openbmc@lists.ozlabs.org
Subject: Re: [PATCH v1 1/2] dt-binding: hwrng: add NPCM RNG documentation
Message-ID: <20190812233623.GA24924@bogus>
References: <20190722150241.345609-1-tmaimon77@gmail.com>
 <20190722150241.345609-2-tmaimon77@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722150241.345609-2-tmaimon77@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 22, 2019 at 06:02:40PM +0300, Tomer Maimon wrote:
> Added device tree binding documentation for Nuvoton BMC
> NPCM Random Number Generator (RNG).
> 
> Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
> ---
>  .../bindings/rng/nuvoton,npcm-rng.txt           | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt
> 
> diff --git a/Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt b/Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt
> new file mode 100644
> index 000000000000..a697b4425fb3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/nuvoton,npcm-rng.txt
> @@ -0,0 +1,17 @@
> +NPCM SoC Random Number Generator
> +
> +Required properties:
> +- compatible  : "nuvoton,npcm750-rng" for the NPCM7XX BMC.
> +- reg         : Specifies physical base address and size of the registers.
> +
> +Optional property:
> +- quality : estimated number of bits of true entropy per 1024 bits
> +			read from the rng.
> +			If this property is not defined, it defaults to 1000.

This would need a vendor prefix, however, I think it should be implied 
by the compatible string. It is fixed per SoC, right?
