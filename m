Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12196EB64D7
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Jun 2023 06:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjFRGuE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Jun 2023 02:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjFRGuD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Jun 2023 02:50:03 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38186E60
        for <linux-crypto@vger.kernel.org>; Sat, 17 Jun 2023 23:50:01 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f8d258f203so16557675e9.1
        for <linux-crypto@vger.kernel.org>; Sat, 17 Jun 2023 23:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687070999; x=1689662999;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kTbsJHJAIh6L3OpmlKEMiLQ8FVA+BH6GdkanOhtFItg=;
        b=am0n7jcHfoIjQo2hsnQsbevfZPseixSmpo2SSFGzb5Hpphzcc0coNeq1wFtWFmCgPf
         Gs7slH4VN0Xs09KXbj2Wznu4ZP/OzkmWqn4jEM25d26yjSovzt/fHh8Towa7WRWvoixs
         WDKCkF2wsVgv13NcweE+ZHmnY3Id4s46yAdJM5yqccCVw9sjmeNfwBDvteOYlkP+dtxi
         JWSn+LUoN2FbR/Ffu6h6spvadXl7WFwIIHLCdbVDLHs5+iiaieUab6SSmjiFvcY/Dbgl
         ZQa018CeTpHP1ieINDU2k55V6OnfDwcBXuW42bbJSLDnR9X58XeHCN7wHrdEbM0j3vhe
         AyKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687070999; x=1689662999;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kTbsJHJAIh6L3OpmlKEMiLQ8FVA+BH6GdkanOhtFItg=;
        b=EKUjytKkv+N+kKQA5a6N99aGcoWNZogFZa1RLi7ZXNrs1Kb5o+SXYsICzVK7h3JMJ6
         3CDmhrpaoL9rXjYK3z/CFYo4M0KgsMAH9EbSYsvsGB5NFVAU6ARvfg1UYxyPjM+fJ9KQ
         NqKmtJqBYv5HLhsQwsibC5KEXVWLTvvVcYoYJyMyHOKAxS40QdLl3ddcpedL8eaBfdM/
         NJ/+uUeeQ9HV66djkSqhGBy98h7qQ9+sPY0pYrpXtj490IHHm2gt5VPUmiXLH1N4Uy4M
         34mUbujOCJcUOjz57rCE3nDOlfoj5dArQbp0rWOV7Rn7PegrJkb84PloGmXC3nxPr0MO
         AWcw==
X-Gm-Message-State: AC+VfDxL8TspjQxKImi2W7Apl3sK05kXb+x3plkkvVjc5XokyyJTtzmX
        kpy3LhDL/FXZ/axtERlNKhYGFhGi76zkwwRRMPxLJA==
X-Google-Smtp-Source: ACHHUZ7S6ECk8uaphJNxTelZTmW4DZh6bWCMyhptboMmhW4e7hixs2RagJ/j3zTRKjShC7214bpopIgYhKQR4gMWn0c=
X-Received: by 2002:a5d:6ad1:0:b0:311:18ce:152b with SMTP id
 u17-20020a5d6ad1000000b0031118ce152bmr3848340wrw.61.1687070999524; Sat, 17
 Jun 2023 23:49:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230526192210.3146896-1-bhupesh.sharma@linaro.org>
 <20230526192210.3146896-11-bhupesh.sharma@linaro.org> <d239ad07-fbdd-16fa-3555-5bcf33c67059@linaro.org>
 <11c3eb6c-823d-9688-ec53-e05c7bb557c5@linaro.org> <83807d70-c35c-6b66-e7f9-521bdfc6d1b4@linaro.org>
In-Reply-To: <83807d70-c35c-6b66-e7f9-521bdfc6d1b4@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Sun, 18 Jun 2023 12:19:48 +0530
Message-ID: <CAH=2NtyNqbhY6B0orqyGvhOWs7M5z9tBQ05E7e7Fb1toamN95Q@mail.gmail.com>
Subject: Re: [PATCH v8 10/11] arm64: dts: qcom: sm8350: Add Crypto Engine support
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.linux@gmail.com, robh+dt@kernel.org,
        vladimir.zapolskiy@linaro.org, rfoss@kernel.org,
        neil.armstrong@linaro.org, djakov@kernel.org, stephan@gerhold.net,
        Anders Roxell <anders.roxell@linaro.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 17 Jun 2023 at 12:58, Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 17/06/2023 01:33, Konrad Dybcio wrote:
> > On 16.06.2023 19:36, Krzysztof Kozlowski wrote:
> >> On 26/05/2023 21:22, Bhupesh Sharma wrote:
> >>> Add crypto engine (CE) and CE BAM related nodes and definitions to
> >>> 'sm8350.dtsi'.
> >>>
> >>> Tested-by: Anders Roxell <anders.roxell@linaro.org>
> >>> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >>> Co-developed-by and Signed-off-by: Robert Foss <rfoss@kernel.org>
> >>> [Bhupesh: Switch to '#interconnect-cells = <2>', available since commit 4f287e31ff5f]
> >>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> >>> ---
> >>
> >> #regzbot introduced: f1040a7fe8f069d2259ab3dab9190210005ceb33
> >> #regzbot title: HDK8350 silently crashes early on boot
> >>
> >> Hi, this landed in the next but unfortunately it causes silent crash
> >> (and reboot) of HDK8350. Reverting this commit helps.
> > Downstream also references the following SIDs:
> >
> > iommus = <&apps_smmu 0x592 0>,
> >        <&apps_smmu 0x598 0>,
> >        <&apps_smmu 0x599 0>,
> >        <&apps_smmu 0x59F 0>;
>
> I already tried iommus from downstream from:
> 1. qcrypto node (0x584, 0x594)
> 2. qcedev (0x586, 0x596)
> 3. qcom_cedev_ns_cb (0x592, 0x598, 0x599, 0x59F), although with 0x0011
> last argument.
>
> Same results, but indeed iommu would be nice reason here.
>
> I also double checked the version of block (BAM DMA is v1.7.4) and other
> properties. When I disabled crypto but left BAM DMA, the result was the
> same, thus it is maybe the BAM who causes abort.

I remember testing it on the sm8350-mtp and found no issues. Infact
Robert (the original author of the patch) had also done some testing
in the past.

I am sure - mtp v/s hdk board variation would not cause this, so let
me have a stab at it tomorrow.

Thanks,
Bhupesh
