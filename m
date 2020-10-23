Return-Path: <SRS0=juaY=D6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB4D5C388F9
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 11:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 626F520857
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 11:55:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m3Ge7Mkc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463240AbgJWLzv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Oct 2020 07:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S463239AbgJWLzu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Oct 2020 07:55:50 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDA7C0613CE
        for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2020 04:55:50 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id o18so1267260edq.4
        for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2020 04:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=elcLLYqqu2IDsbH9Xvfy2C5oZvPvsX16Bv8lDm86QBI=;
        b=m3Ge7MkcnIv+efFydBz0DditBVVQnRnTeDE0mfCXQ3qDufBizQYXNUTjWEiJ1xGxAT
         YCHCD/qe/qmn4N6vXd04L68bcX1sImRDUKPiyRofk4WUJPnSHha3pIDKvqYx/URS7W7t
         MMn2gOkTh8av0oNfW6rP8wNdPah5pxlUz+2G/k2AfzlZh0XaO2nkWPl8uBgNEoTyMx/c
         tMGHNdt+o3iHX5P3lT4YSaAYcbiZe6VbrfaUWn2FyHnImWE25GE7gZiShMkWoQ68EcEc
         WkFNbcYm4KifUwSrSDxm8ZCZiYNrPczgXJE4IpTdTNriwj1byQD8ReZb9924d44ii9eo
         al+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=elcLLYqqu2IDsbH9Xvfy2C5oZvPvsX16Bv8lDm86QBI=;
        b=l9xz3IzPLdoUS9U//IzTA/N402qpU3ucGZZ7hX/77XIX020QNvIPsFrUTl9tKtZ+Ij
         PlPdUIat/ezXoBQ1LVfYYMEIHnDLVllMqQKT2W7B1NZuXDkCEo2AyIb01PjHjnHk2Ukh
         bpYDZCwf4y/4f1aWMPuZSLyM4n8qDWY28y5iRdaq1/eiK4lLZhCrQmhd2UZiDs2A5s7n
         AjEulBGU0Xaf7ybps8ya21XFe5z5iKHdomNaW4fPKHpU9vdEfqDp+h9ctPX/C6uz8XMM
         PVwHbeWxPhgZeh0EfuMC+uOtOvxtMpnMsqpChrifCYlsQADkA8w1aOKGnxiifFLB8EdP
         oXgg==
X-Gm-Message-State: AOAM532GIPDj64lNlRcVEI0vjqqSOa8kqGLzjEw1hNbq9zVQT+ywkR1w
        7TwTCbD6coLhp8VJqC5oVKmq7C6XNdJWLdwtkUE0NM6gPmE=
X-Google-Smtp-Source: ABdhPJyP8XBLw2VCavoHGLVeTy9e8IuHm3rzPrXy2uyuPCyMTSrML6O1hyRNYB8D1BDbRBZwb56ZH9vTAgcWINULN5o=
X-Received: by 2002:a05:6402:4cb:: with SMTP id n11mr1755351edw.296.1603454148759;
 Fri, 23 Oct 2020 04:55:48 -0700 (PDT)
MIME-Version: 1.0
From:   Konrad Dybcio <konradybcio@gmail.com>
Date:   Fri, 23 Oct 2020 13:55:13 +0200
Message-ID: <CAMS8qEVZFBFv4VpFtijxnR8Z5-wWFkpZx8nKOmbm6U-vah7eLg@mail.gmail.com>
Subject: Qualcomm Crypto Engine driver
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I was investigating Qualcomm Crypto Engine support on my sdm630
smartphone and found out that the already-present driver is
compatible. In meantime I found two issues:

1. The driver doesn't seem to have a maintainer? drivers/crypto/qce
doesn't seem to exist in the MAINTAINERS file..

2. The person who first submitted it likely faced an issue with memory
allocation. On downstream (taking sdm630 as example) Qualcomm decided
to allocate 0x20000@1de0000 for the device and 0x24000@1dc4000 for
BAM, which isn't something upstream driver agrees with (these memory
regions overlap and the driver straight up doesn't probe..).
I "fixed" it by giving (QCE register) - (DMA register) memory size to
the DMA (which doesn't seem to cause any issues) and changing all the
registers in the header file by 0x1A000 (just like it is downstream
[1]), but the former person "fixed" it by offsetting the QCE node in
qcom-ipq4019.dtsi by 0x1A000.

Which fix is more correct? I'd advocate for my one as the more
accurate, but I can adapt to what's already been invented.. Test
results ("cryptsetup benchmark")  don't differ between these two
(though they are worse than without the QCE, which is most likely
related to unimplemented bus bandwidth scaling).


[1] https://github.com/sonyxperiadev/kernel/blob/aosp/LA.UM.7.1.r1/drivers/crypto/msm/qcryptohw_50.h

Konrad Dybcio
