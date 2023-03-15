Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9F6C6FD1F
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Mar 2023 01:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjCOBpX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Mar 2023 21:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCOBpW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Mar 2023 21:45:22 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED2B46148
        for <linux-crypto@vger.kernel.org>; Tue, 14 Mar 2023 18:45:20 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id a2so18505631plm.4
        for <linux-crypto@vger.kernel.org>; Tue, 14 Mar 2023 18:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112; t=1678844719;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bQqeZSUpX2ANWQCyU7UoxGLqZhx6/F6T9Own5KUL63M=;
        b=V6Jj+wxcvH2Hyng5utJCOGWXhtyo8pCMQcYf3gwHXi0X5PWp5DqfwEpDZr9gzUdHMm
         IGffHnQPlori1oAiy2u0bwMjDBifsCFd1lnt4vZY/+nV0NHckA8xawzZ/OmjGfHRMnBc
         BCZyiO4F/qXF1OhgQAJLxy2nNQvhl5mOkXFzGJv/psOStrVr/1rn29w7a4CEf8i/DqZ9
         u1dPA3YDx0A76x0VGSgFBCV/MtfY3wYziCb97H2ZArBzOciPKMH1ntGflYlMWQ+lWc+J
         pp+3kpBMAMixq32LAFrEAoiSJxZPZPoIR0cidRVEEkh1fMurCHyiZ25hKt/0eBeAZxGn
         Pp6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678844719;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQqeZSUpX2ANWQCyU7UoxGLqZhx6/F6T9Own5KUL63M=;
        b=htuH7zEpUE+4c9R4ZWWjYq78QKvQ6FV0+eDxd8ApTevfsnE1NnxQhcbeBP6dkkP6Zn
         7WBMUjtWMfJbOmYGwBf/ibLlhLvHykz3uP5LCrUROkOXM3PSKMQEyihpBTYHr96s8ijT
         iPYplKi9bqSTLY5a1byig9k9t9lKxIxPy9WNq0WcYIWrFR9IbU/YU+ISZMRgDtBp8QTL
         8rdj2NenWAiaqJf6uxYs6FXJhgfbNORfuoFK6u5By0+7u5oidOPK5cqmoViGf7cMI2Ji
         s0mM+3UvYPryZPUufYifDnrlxm4GLXd7znKKxOSlXfda2TdMwPIaYDXD8TsYaj7g+QWn
         7bpw==
X-Gm-Message-State: AO0yUKUS9ezizDzBiaPa2OWLCK+8bfAsKlOuvb2c0Pl6pXU6B7L5n/rT
        NNMxA0RCUbrE2LO18EZF5ZMFKw==
X-Google-Smtp-Source: AK7set/zbsmcLhFJY+8MsiN5QjmiTaTrNiZtMAVnOhYkCrKl13ehjJZ6SZ5K8PZTFRYIFNTj/tDqYA==
X-Received: by 2002:a05:6a20:548a:b0:cc:d891:b2b1 with SMTP id i10-20020a056a20548a00b000ccd891b2b1mr52532757pzk.35.1678844719415;
        Tue, 14 Mar 2023 18:45:19 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id j6-20020a62e906000000b005a8f1d76d46sm2191064pfh.13.2023.03.14.18.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 18:45:18 -0700 (PDT)
Date:   Tue, 14 Mar 2023 18:45:18 -0700 (PDT)
X-Google-Original-Date: Tue, 14 Mar 2023 18:44:27 PDT (-0700)
Subject:     Re: [PATCH v5 3/3] riscv: dts: starfive: Add TRNG node for VisionFive 2
In-Reply-To: <20230117015445.32500-4-jiajie.ho@starfivetech.com>
CC:     olivia@selenic.com, herbert@gondor.apana.org.au,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        kernel@esmil.dk, Conor Dooley <conor.dooley@microchip.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     jiajie.ho@starfivetech.com
Message-ID: <mhng-348475f1-5880-4951-9692-78210a17acd3@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 16 Jan 2023 17:54:45 PST (-0800), jiajie.ho@starfivetech.com wrote:
> Adding StarFive TRNG controller node to VisionFive 2 SoC.
>
> Co-developed-by: Jenny Zhang <jenny.zhang@starfivetech.com>
> Signed-off-by: Jenny Zhang <jenny.zhang@starfivetech.com>
> Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
> ---
>  arch/riscv/boot/dts/starfive/jh7110.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/arch/riscv/boot/dts/starfive/jh7110.dtsi b/arch/riscv/boot/dts/starfive/jh7110.dtsi
> index 4ac159d79d66..3c29e0bc6246 100644
> --- a/arch/riscv/boot/dts/starfive/jh7110.dtsi
> +++ b/arch/riscv/boot/dts/starfive/jh7110.dtsi
> @@ -455,5 +455,15 @@ uart5: serial@12020000 {
>  			reg-shift = <2>;
>  			status = "disabled";
>  		};
> +
> +		rng: rng@1600c000 {
> +			compatible = "starfive,jh7110-trng";
> +			reg = <0x0 0x1600C000 0x0 0x4000>;
> +			clocks = <&stgcrg JH7110_STGCLK_SEC_HCLK>,
> +				 <&stgcrg JH7110_STGCLK_SEC_MISCAHB>;
> +			clock-names = "hclk", "ahb";
> +			resets = <&stgcrg JH7110_STGRST_SEC_TOP_HRESETN>;
> +			interrupts = <30>;
> +		};
>  	};
>  };

Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
