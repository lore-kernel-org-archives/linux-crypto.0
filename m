Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F38EC4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Oct 2021 07:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 667D8611AD
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Oct 2021 07:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhJNHFh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Oct 2021 03:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhJNHFg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Oct 2021 03:05:36 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4DFC061570
        for <linux-crypto@vger.kernel.org>; Thu, 14 Oct 2021 00:03:31 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id u69so7256954oie.3
        for <linux-crypto@vger.kernel.org>; Thu, 14 Oct 2021 00:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1l0+SaZHpyG7rrhn4tPV2e7F4MAU+GQ6aooBFBCxnl4=;
        b=cEUkgYyL0FXKDT85YJ+oxstqdONyVg9jw8g378Z46fnAaYeeB+BBY3TjJISacUN4LE
         diZ80WE5xxPsIu5R3Vu8U0t3AkumVNF81ddQK09pXcUyvj+LxXH9m0GH4hb0sgP0WsEM
         LdFMWGdWcwNjUMYn0KwwSZCHYGOCWSQL3v+dBfT+jnhrT6dNj86QZsdYuYXzPQjFD6D1
         opNAtHBC5ihyj9CnMbcNYgi2Q5NmR3niXCK22KXTC2l/gijkp9ggoGBI2uesTyfaCSFv
         DrRGytu1mqlaHK65DUdcI4W/DqbSmgUgScd9JtsAwsQB5CqeNlgeqVVpacc1ZK3KcqDD
         8gPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1l0+SaZHpyG7rrhn4tPV2e7F4MAU+GQ6aooBFBCxnl4=;
        b=i6smh6xUSJcFcuPMJC7cKeeGH99wpeUDxUqT6bY+b/dP9+1RZBFSY1IEREy8DJ5Pnk
         NXO+hF3Hs3er1cKk8iVBB5Bl9gl9uXz4XlYgCiYRdUkp+AtBwhCCKGZKblC4dlhTwVVA
         dsL4dm3sIYKitgYurOKJtXNZL+I1IJ0yG+G/7QNotJ+aa435QMDLOduhECYnZMwk1g6l
         6yn1Jjle0omCZ3sJmgugReoTps0yZMyhX81X/thbCdxdHMNkTqJvBPi3Fg5F350WfdMS
         cHAzUc4aXDzZyiSz7kdoLg6+3W2KUMgACuugl9z9YiIbZE8H+dwB9o2fSv++gSDEdAg/
         8M+A==
X-Gm-Message-State: AOAM533BtHkJ4IA0bXHlSIGx5T6NjuibWW8T7VCD6KN0+8DbckveJ0RX
        IteKPnEQfBnc68ai1Cu3NwhSLd/QatymVssvxIGkvw==
X-Google-Smtp-Source: ABdhPJz5LcYedJgU2u36Px+sIb9WB9tzzl7Jwf165XrKxoLC6Q222kTM/7wvLgYXQ4hjrBDicAU4o0ISmEHO2X9caSA=
X-Received: by 2002:a05:6808:1525:: with SMTP id u37mr11690666oiw.12.1634195010727;
 Thu, 14 Oct 2021 00:03:30 -0700 (PDT)
MIME-Version: 1.0
References: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
 <20211013105541.68045-6-bhupesh.sharma@linaro.org> <1634150392.555106.1324767.nullmailer@robh.at.kernel.org>
In-Reply-To: <1634150392.555106.1324767.nullmailer@robh.at.kernel.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Thu, 14 Oct 2021 12:33:19 +0530
Message-ID: <CAH=2NtyJZoPMSDr4aYgX29BeSq3qXyJta3o7ZHPNrNOF+Ym-gA@mail.gmail.com>
Subject: Re: [PATCH v4 05/20] dt-bindings: qcom-bam: Add 'interconnects' &
 'interconnect-names' to optional properties
To:     Rob Herring <robh@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        devicetree <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        bhupesh.linux@gmail.com, Andy Gross <agross@kernel.org>,
        MSM <linux-arm-msm@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Rob,

Thanks for your review.
These issues are already fixed via patches within this series itself
(as some dts also need correction to pass the 'make dtbs_check'
check). I am not sure, but it seems the check was run without applying
other patches from this series.

See details below:

On Thu, 14 Oct 2021 at 00:09, Rob Herring <robh@kernel.org> wrote:
>
> On Wed, 13 Oct 2021 16:25:26 +0530, Bhupesh Sharma wrote:
> > Add new optional properties - 'interconnects' and
> > 'interconnect-names' to the device-tree binding documentation for
> > qcom-bam DMA IP.
> >
> > These properties describe the interconnect path between bam and main
> > memory and the interconnect type respectively.
> >
> > Cc: Thara Gopinath <thara.gopinath@linaro.org>
> > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
>
> Running 'make dtbs_check' with the schema in this patch gives the
> following warnings. Consider if they are expected or the schema is
> incorrect. These may not be new warnings.
>
> Note that it is not yet a requirement to have 0 warnings for dtbs_check.
> This will change in the future.
>
> Full log is available here: https://patchwork.ozlabs.org/patch/1540390
>
>
> dma@12142000: $nodename:0: 'dma@12142000' does not match '^dma-controller(@.*)?$'
>         arch/arm/boot/dts/qcom-mdm9615-wp8548-mangoh-green.dt.yaml
>
> dma@12182000: $nodename:0: 'dma@12182000' does not match '^dma-controller(@.*)?$'
>         arch/arm/boot/dts/qcom-apq8064-asus-nexus7-flo.dt.yaml
>         arch/arm/boot/dts/qcom-apq8064-cm-qs600.dt.yaml
>         arch/arm/boot/dts/qcom-apq8064-ifc6410.dt.yaml
>         arch/arm/boot/dts/qcom-apq8064-sony-xperia-yuga.dt.yaml
>         arch/arm/boot/dts/qcom-ipq8064-ap148.dt.yaml
>         arch/arm/boot/dts/qcom-ipq8064-rb3011.dt.yaml
>         arch/arm/boot/dts/qcom-mdm9615-wp8548-mangoh-green.dt.yaml
>
> dma@121c2000: $nodename:0: 'dma@121c2000' does not match '^dma-controller(@.*)?$'
>         arch/arm/boot/dts/qcom-apq8064-asus-nexus7-flo.dt.yaml
>         arch/arm/boot/dts/qcom-apq8064-cm-qs600.dt.yaml
>         arch/arm/boot/dts/qcom-apq8064-ifc6410.dt.yaml
>         arch/arm/boot/dts/qcom-apq8064-sony-xperia-yuga.dt.yaml
>
> dma@12402000: $nodename:0: 'dma@12402000' does not match '^dma-controller(@.*)?$'
>         arch/arm/boot/dts/qcom-apq8064-asus-nexus7-flo.dt.yaml
>         arch/arm/boot/dts/qcom-apq8064-cm-qs600.dt.yaml
>         arch/arm/boot/dts/qcom-apq8064-ifc6410.dt.yaml
>         arch/arm/boot/dts/qcom-apq8064-sony-xperia-yuga.dt.yaml
>         arch/arm/boot/dts/qcom-ipq8064-ap148.dt.yaml
>         arch/arm/boot/dts/qcom-ipq8064-rb3011.dt.yaml
>
> dma@1dc4000: $nodename:0: 'dma@1dc4000' does not match '^dma-controller(@.*)?$'
>         arch/arm64/boot/dts/qcom/sdm845-cheza-r1.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-cheza-r2.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-cheza-r3.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-db845c.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-mtp.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-oneplus-enchilada.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dt.yaml

All the above will be fixed by '[PATCH 01/20] arm64/dts: qcom: Fix 'dma' &
 'qcom,controlled-remotely' nodes in dts' in this series. See the git
log of the this patch for details:

'A few qcom device-tree files define dma-controller nodes
with non-standard 'node names' and also set
the bool property 'qcom,controlled-remotely' incorrectly, which
leads to following errors with 'make dtbs_check':

 $ arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dt.yaml:
     dma@1dc4000: $nodename:0: 'dma@1dc4000' does not match
     '^dma-controller(@.*)?$'

 $ arch/arm64/boot/dts/qcom/sm8250-mtp.dt.yaml:
     dma@1dc4000: qcom,controlled-remotely: 'oneOf' conditional
     failed, one must be fixed:
    [[1]] is not of type 'boolean'
    True was expected
    [[1]] is not of type 'null'

Fix the same.
'

> dma@1dc4000: 'iommus' does not match any of the regexes: 'pinctrl-[0-9]+'
>         arch/arm64/boot/dts/qcom/sdm845-cheza-r1.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-cheza-r2.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-cheza-r3.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-db845c.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-mtp.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-oneplus-enchilada.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dt.yaml

Fixed by ' [PATCH 06/20] dt-bindings: qcom-bam: Add 'iommus' to optional
 properties ' in this series.

> dma@1dc4000: qcom,controlled-remotely: 'oneOf' conditional failed, one must be fixed:
>         arch/arm64/boot/dts/qcom/sdm845-cheza-r1.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-cheza-r2.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-cheza-r3.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-db845c.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-mtp.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-oneplus-enchilada.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dt.yaml

Again this would be fixed by '[PATCH 01/20] arm64/dts: qcom: Fix 'dma' &
 'qcom,controlled-remotely' nodes in dts' in this series.

> dma@704000: $nodename:0: 'dma@704000' does not match '^dma-controller(@.*)?$'
>         arch/arm64/boot/dts/qcom/ipq8074-hk01.dt.yaml
>         arch/arm64/boot/dts/qcom/ipq8074-hk10-c1.dt.yaml
>         arch/arm64/boot/dts/qcom/ipq8074-hk10-c2.dt.yaml

Fixed by '[PATCH 01/20] arm64/dts: qcom: Fix 'dma' &
'qcom,controlled-remotely' nodes in dts' in this series

> dma@704000: qcom,controlled-remotely: 'oneOf' conditional failed, one must be fixed:
>         arch/arm64/boot/dts/qcom/ipq8074-hk01.dt.yaml
>         arch/arm64/boot/dts/qcom/ipq8074-hk10-c1.dt.yaml
>         arch/arm64/boot/dts/qcom/ipq8074-hk10-c2.dt.yaml

Fixed by '[PATCH 01/20] arm64/dts: qcom: Fix 'dma' &
'qcom,controlled-remotely' nodes in dts' in this series

> dma@7544000: $nodename:0: 'dma@7544000' does not match '^dma-controller(@.*)?$'
>         arch/arm64/boot/dts/qcom/apq8096-db820c.dt.yaml
>         arch/arm64/boot/dts/qcom/apq8096-ifc6640.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8996-mtp.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8996-pmi8996-sony-xperia-tone-dora.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8996-pmi8996-sony-xperia-tone-kagura.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8996-pmi8996-sony-xperia-tone-keyaki.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone-dora.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone-kagura.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone-keyaki.dt.yaml
>
> dma@7584000: $nodename:0: 'dma@7584000' does not match '^dma-controller(@.*)?$'
>         arch/arm64/boot/dts/qcom/apq8096-db820c.dt.yaml
>         arch/arm64/boot/dts/qcom/apq8096-ifc6640.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8996-mtp.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8996-pmi8996-sony-xperia-tone-dora.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8996-pmi8996-sony-xperia-tone-kagura.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8996-pmi8996-sony-xperia-tone-keyaki.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone-dora.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone-kagura.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone-keyaki.dt.yaml
>
> dma@7884000: $nodename:0: 'dma@7884000' does not match '^dma-controller(@.*)?$'
>         arch/arm/boot/dts/qcom-ipq4018-ap120c-ac-bit.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4018-ap120c-ac.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4018-jalapeno.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4019-ap.dk01.1-c1.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1-c1.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1-c3.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4019-ap.dk07.1-c1.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4019-ap.dk07.1-c2.dt.yaml
>
> dma@7984000: $nodename:0: 'dma@7984000' does not match '^dma-controller(@.*)?$'
>         arch/arm/boot/dts/qcom-ipq4018-ap120c-ac-bit.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4018-ap120c-ac.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4018-jalapeno.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4019-ap.dk01.1-c1.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1-c1.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1-c3.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4019-ap.dk07.1-c1.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4019-ap.dk07.1-c2.dt.yaml
>
> dma@8e04000: $nodename:0: 'dma@8e04000' does not match '^dma-controller(@.*)?$'
>         arch/arm/boot/dts/qcom-ipq4018-ap120c-ac-bit.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4018-ap120c-ac.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4018-jalapeno.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4019-ap.dk01.1-c1.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1-c1.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4019-ap.dk04.1-c3.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4019-ap.dk07.1-c1.dt.yaml
>         arch/arm/boot/dts/qcom-ipq4019-ap.dk07.1-c2.dt.yaml
>
> dma@c184000: $nodename:0: 'dma@c184000' does not match '^dma-controller(@.*)?$'
>         arch/arm64/boot/dts/qcom/msm8998-asus-novago-tp370ql.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8998-hp-envy-x2.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8998-lenovo-miix-630.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8998-mtp.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8998-oneplus-cheeseburger.dt.yaml
>         arch/arm64/boot/dts/qcom/msm8998-oneplus-dumpling.dt.yaml

All the above 6 issues are fixed by '[PATCH 01/20] arm64/dts: qcom: Fix 'dma' &
 'qcom,controlled-remotely' nodes in dts' in this series.

> dma-controller@17184000: 'iommus' does not match any of the regexes: 'pinctrl-[0-9]+'
>         arch/arm64/boot/dts/qcom/sdm845-cheza-r1.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-cheza-r2.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-cheza-r3.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-db845c.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-mtp.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-oneplus-enchilada.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dt.yaml
>         arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dt.yaml

Fixed by ' [PATCH 06/20] dt-bindings: qcom-bam: Add 'iommus' to optional
 properties ' in this series.

> dma-controller@704000: 'qcom,config-pipe-trust-reg' does not match any of the regexes: 'pinctrl-[0-9]+'
>         arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dt.yaml

Fixed by '[PATCH 02/20] arm64/dts: qcom: ipq6018: Remove unused
 'qcom,config-pipe-trust-reg' property' in this series.

> dma-controller@704000: qcom,controlled-remotely: 'oneOf' conditional failed, one must be fixed:
>         arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dt.yaml

Fixed by '[PATCH 01/20] arm64/dts: qcom: Fix 'dma' &
''qcom,controlled-remotely' nodes in dts' in this series.

> dma-controller@7984000: clock-names:0: 'bam_clk' was expected
>         arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dt.yaml
>
> dma-controller@7984000: clock-names: Additional items are not allowed ('bam_clk' was unexpected)
>         arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dt.yaml
>
> dma-controller@7984000: clock-names: ['iface_clk', 'bam_clk'] is too long
>         arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dt.yaml
>
> dma-controller@7984000: clocks: [[9, 138], [9, 137]] is too long
>         arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dt.yaml

Fixed by '[PATCH 03/20] arm64/dts: qcom: ipq6018: Remove unused 'iface_clk'
property from dma-controller node' in this series.

In summary, I ran 'make dtbs_check' after applying this series on
linus's tip and linux-next's tip as well and saw no errors being
reported for 'Documentation/devicetree/bindings/dma/qcom_bam_dma.yaml'.

Regards,
Bhupesh
