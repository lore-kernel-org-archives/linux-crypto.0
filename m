Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D331C7EE26
	for <linux-crypto@archiver.kernel.org>; Tue,  9 May 2023 10:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbjEIKK2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 May 2023 06:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234498AbjEIKK1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 May 2023 06:10:27 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF3644AC
        for <linux-crypto@vger.kernel.org>; Tue,  9 May 2023 03:10:24 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-55c939fb24dso51644987b3.2
        for <linux-crypto@vger.kernel.org>; Tue, 09 May 2023 03:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683627024; x=1686219024;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rQkbfRIbUJCVqw4JhZ/x8mgAn7rLfZy1brM0sCnVSgw=;
        b=U1CNfIFlZ/a1WePhr2f4aPDZkCagS2Q5q5SRO7RjjDU2jDZUwcoVsBFqx9cloGIY/v
         kfVsJo63yMDr2c/jAyx3dvDZI3A5/535YyoDqLTJBa0R9n55KGrxAVK05n56G5erKouc
         8/5szb42oNcPenusnzqM4m49wyN8bOkTvy+39kUXY2R/9iSUOmQVL7GhtXYVEf+VLFTC
         rzhHhTaFeS81uybq1ZDPuzz4/7tKc4CWdtVOwsiCgKh5cs2bBfcM5mTEp4lXF677J+tH
         SjvRpzkqrsC1jHTznwynV7b5svGS85/ACYbXI4PlHzXDvSe+Z1anVO8M1/Sf+GrCztxR
         QI0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683627024; x=1686219024;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rQkbfRIbUJCVqw4JhZ/x8mgAn7rLfZy1brM0sCnVSgw=;
        b=KY8lnl5J+ELHxc41NpN/HZTPp2CyW72IUlIAoTZpDlAu/p5lgCWU9ZDIjTlcyZrxzV
         lPNNClYgoszhd1xcCIzwIHziD64YSLY6l1ERk7J/tKwcJV0WNmGFIVHH2SIsp0u94/m1
         A2kUz4e8VBfPbxEI0hycMXMKRX83C83tPNdA0PPZ3/QJEsM/VLco9Z38TCcLZ1RKa9Xj
         5AJ1Vy7sDac8dG8KjzCq5Lpw6/QEub3ITfZulc9XkfmLQOxwIU9UWL9Q/62464a84rcy
         Y0hmPO4PHoNiwScPX/ZlDy9tq4MFwe4i8p6YKWbN4KNxpOFObSYZOCtYFwO/6Mx37Sbm
         nYLA==
X-Gm-Message-State: AC+VfDydYm9PsYLEPj97p/cvpNzuuDBqW+f9eOUYIeyY1agIf7xNIe7d
        F5FBmcsqorb/86zrASmdoNgjQtexTiBSklYUPIqLZA==
X-Google-Smtp-Source: ACHHUZ7en5HQ9tk8fC7W17P/UB40PYuc/5jwewMS+g/NJbXve0voOVRVYuXomwyHeYVPu4jgr23oEop/AXyacJy+J6o=
X-Received: by 2002:a81:5404:0:b0:55d:c333:26c4 with SMTP id
 i4-20020a815404000000b0055dc33326c4mr9833694ywb.0.1683627023804; Tue, 09 May
 2023 03:10:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230408214041.533749-1-abel.vesa@linaro.org> <20230408214041.533749-4-abel.vesa@linaro.org>
 <CAPDyKFqMAeKrw1KqhHhdd6U4LUogd6UiiMwe1C2fReSen11A6g@mail.gmail.com>
In-Reply-To: <CAPDyKFqMAeKrw1KqhHhdd6U4LUogd6UiiMwe1C2fReSen11A6g@mail.gmail.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 9 May 2023 12:09:48 +0200
Message-ID: <CAPDyKFpwzunLC447WWqPqrMpJRbCFqUoADERU7KG4iorOgADzA@mail.gmail.com>
Subject: Re: [PATCH v7 3/3] mmc: sdhci-msm: Switch to the new ICE API
To:     Bjorn Andersson <andersson@kernel.org>,
        Abel Vesa <abel.vesa@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 17 Apr 2023 at 10:47, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> On Sat, 8 Apr 2023 at 23:40, Abel Vesa <abel.vesa@linaro.org> wrote:
> >
> > Now that there is a new dedicated ICE driver, drop the sdhci-msm ICE
> > implementation and use the new ICE api provided by the Qualcomm soc
> > driver ice. The platforms that already have ICE support will use the
> > API as library since there will not be a devicetree node, but instead
> > they have reg range. In this case, the of_qcom_ice_get will return an
> > ICE instance created for the consumer's device. But if there are
> > platforms that do not have ice reg in the consumer devicetree node
> > and instead provide a dedicated ICE devicetree node, theof_qcom_ice_get
> > will look up the device based on qcom,ice property and will get the ICE
> > instance registered by the probe function of the ice driver.
> >
> > The ICE clock is now handle by the new driver. This is done by enabling
> > it on the creation of the ICE instance and then enabling/disabling it on
> > SDCC runtime resume/suspend.
> >
> > Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
>
> Bjorn, I think it should be easier if you pick this together with qcom
> soc driver changes. I don't think there is any conflict with changes
> in my mmc tree.
>
> Otherwise, I will just wait for the next release cycle.

Okay, it looks like all dependent pieces made it into v6.4-rc1. So,
applied for next, thanks!

[...]

Kind regards
Uffe
