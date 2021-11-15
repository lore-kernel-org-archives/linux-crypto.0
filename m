Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858C0C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 05:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54BE661BFA
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 05:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhKOFbF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 00:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhKOFaz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 00:30:55 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FDFC061746
        for <linux-crypto@vger.kernel.org>; Sun, 14 Nov 2021 21:27:59 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso25461113otj.11
        for <linux-crypto@vger.kernel.org>; Sun, 14 Nov 2021 21:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0KUIHUy0806Q9hFGnixEypWdxlkA7g/t33VhtSh3NxY=;
        b=T5BF7cluYfzR+FFJGYkCES/IViLHVwEcH12gc/Za84BlP91pqYX4Uyg/ataE1B88WP
         GwhdmkP7kyU4tAYs2S66rPjjyDhxDh/cpnOPFGXbZw/4CyAYRVmiNIryNGO1LFSAo/7V
         8WKf+rVNX0E1MrJg7Hr7P5pqa8xpO1lV35O5IaGFEEYgIQO1hTgKPUpQJcciT7WdYVnZ
         v2k9e4gZOGHcPwHqduVGTL9oHESirlSsVSx+kOvkFuqyKdz37tzZ3wLKDdiVJK3m5yOQ
         DZ/cnJfI4fP/PDmSojwUMRjnkaBQApl/LjWPNpLs9dwDPe+cF2RMi3eV0Es2VdtLpZPe
         Ewxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0KUIHUy0806Q9hFGnixEypWdxlkA7g/t33VhtSh3NxY=;
        b=PMkKpNDzu1wQqt1+4HROK0rblEIGSYnAY9sKCKjQwmMMtf4o5UvlUm8guzZk1TP8vE
         LzbkAOErwL2tWkit2XJZOy1CkL/dyrSl23l44GYbxo0Kh2zfu+HIT2xPcnPqRlpdCgh+
         zwiEH928sDBXwBCekk3zX+B6qY2DLb0RpTNSvzb3drfiEkxNOw6J/El/b6Ddo5NJXMEM
         zU7Xr7/U9h7JHLaWYCHM+KSB3PYdeD2uNgwCYsHj/JvuigBoSAHvl3mDbZLkooCKXYmw
         UPB2uixYd4+FnfrI8Vr7rxfDR5O4oyYKvjzI7pxb2KxEQI8UmeZfXcUB16n6SNW3nt1O
         In8Q==
X-Gm-Message-State: AOAM5316+rlfpfuRSJh9YiLrPrfFM3jGC5JXd5HZHbWOF8Yond2RzEXi
        EVLwHoK1VLHBHkoO9nyybZwI0uuB/2tS3v+JmGAidA==
X-Google-Smtp-Source: ABdhPJz+8GraqEO2LELBEFZ6CWfkCmRPhByZYhHbjvLczVCjTtq+ZNfhCFgUS7jPO9KW3Qk64kAKMKVqV5+XfgFbSDY=
X-Received: by 2002:a05:6830:34a0:: with SMTP id c32mr30343456otu.379.1636954078482;
 Sun, 14 Nov 2021 21:27:58 -0800 (PST)
MIME-Version: 1.0
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
 <20211110105922.217895-14-bhupesh.sharma@linaro.org> <5fe9bb9f-ded6-1aa4-347f-ef5cd0b21358@linaro.org>
In-Reply-To: <5fe9bb9f-ded6-1aa4-347f-ef5cd0b21358@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date:   Mon, 15 Nov 2021 10:57:47 +0530
Message-ID: <CAH=2Ntzd9SvepuFU6LGsrnZJ=Ef1WDMsgASESqRcCsAkaCmGjw@mail.gmail.com>
Subject: Re: [PATCH v5 13/22] dma: qcom: bam_dma: Add support to initialize
 interconnect path
To:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, agross@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        stephan@gerhold.net, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Vladimir,

On Fri, 12 Nov 2021 at 16:02, Vladimir Zapolskiy
<vladimir.zapolskiy@linaro.org> wrote:
>
> Hi Bhupesh,
>
> On 11/10/21 12:59 PM, Bhupesh Sharma wrote:
> > From: Thara Gopinath <thara.gopinath@linaro.org>
> >
> > BAM dma engine associated with certain hardware blocks could require
> > relevant interconnect pieces be initialized prior to the dma engine
> > initialization. For e.g. crypto bam dma engine on sm8250. Such requirement
> > is passed on to the bam dma driver from dt via the "interconnects"
> > property.  Add support in bam_dma driver to check whether the interconnect
> > path is accessible/enabled prior to attempting driver intializations.
> >
> > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> > [Make header file inclusion alphabetical and use 'devm_of_icc_get()']
> > Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
>
> please let me ask you to swap your and Thara's sob tags above, there is
> a rule applicable to all cases dealing with someone's else changes:
>
>  From Documentation/process/submitting-patches.rst:
>
>    Any further SoBs (Signed-off-by:'s) following the author's SoB are from
>    people handling and transporting the patch, but were not involved in its
>    development. SoB chains should reflect the **real** route a patch took
>    as it was propagated to the maintainers and ultimately to Linus, with
>    the first SoB entry signalling primary authorship of a single author.

Sure, I will fix it in v6.

Regards,
Bhupesh
