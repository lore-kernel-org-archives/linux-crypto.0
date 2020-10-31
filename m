Return-Path: <SRS0=m/1o=EG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A67AC388F9
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 19:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 055922065C
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 19:19:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BNPxEwa+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgJaTTu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Oct 2020 15:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgJaTTt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Oct 2020 15:19:49 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1613C0617A6
        for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2020 12:19:49 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id t15so2764390ual.6
        for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2020 12:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wwf1XRuzqH8iDHRAKdxul3V5TY+R1Lm9WGQNmM2sOaM=;
        b=BNPxEwa+WTE2Lxke8s7Ayr8UVA9ODk8sISCXedOqCyXoDTasLUrAOudyVTHHHIUBm8
         MTO7HWokQ5KJ3cPE3S8gG9RNkwWrVvvb4WRKRMwYiQgvZYWtLdM6TFzfHFnnnb93DH9o
         R0CU4iS/o9jwIW7OEreGqoYwTdThGw6ffU7NNxmsywaDEtsEgNda1iBKSp8Gu8Ak6ko4
         Jx9btHFG04Ubami2QJwSqP8joV7aEgZfvnrMRECLssImVvzFA+9jTBwIA2/yh9P4YNY5
         1S8MkdYjDZFmVDjqXCGqYj/y52VxUB2Bef8YL9geYZ0GxsHYDPBSi+skjpP0HsoHSe2w
         28gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wwf1XRuzqH8iDHRAKdxul3V5TY+R1Lm9WGQNmM2sOaM=;
        b=WSl7p08+UmCLvQ87Nz04t+rgbrlXMLg0OOk6PIQX7gawyaPmt9g44cmGnHnPshqk7X
         WJ2r79bop/esIVbfX9of5SO4a50SDoBejb2Bq4vyxims4E9HbHJVayLSATqRB3z4ohcO
         lQpqkUn/jNsR0Sb00C9l5887lL48m6e0zQlSE6ZTqEcmCx7pHQVAwytObBuQY3x4pEC5
         j8W9V4aZ3JwdkjbZhfepPH//nT+oS4S0yv12kLAonpiwxEworQf2rjz/fgrAADQm4bpr
         XYD5oA3eFk8lvDci7VE92NpSZEv6dFXbf6B80QWkBDRylBuDK144CkQ7JXWYf+om3brn
         KkNg==
X-Gm-Message-State: AOAM530EB3jcWPDt1OEjOLV3KTd5JY3etpElCRlVLiiWrr/jS9b14LL6
        8h3TWCPeKXLHmDoxQCdzjKA22TbdI6g=
X-Google-Smtp-Source: ABdhPJz24Zh/yutgE0mcrhQ2GsSv8B0oxk6MQeSmZHXBSfuBWn6UF6ICsovraZyi8KejoLw4bwbDig==
X-Received: by 2002:ab0:244f:: with SMTP id g15mr4938937uan.78.1604171987394;
        Sat, 31 Oct 2020 12:19:47 -0700 (PDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id x4sm293209vkg.24.2020.10.31.12.19.46
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 12:19:46 -0700 (PDT)
Received: by mail-vs1-f54.google.com with SMTP id b3so5280026vsc.5
        for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2020 12:19:46 -0700 (PDT)
X-Received: by 2002:a05:6102:52b:: with SMTP id m11mr1067435vsa.28.1604171985842;
 Sat, 31 Oct 2020 12:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <20201028145015.19212-1-schalla@marvell.com> <20201028145015.19212-12-schalla@marvell.com>
In-Reply-To: <20201028145015.19212-12-schalla@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 31 Oct 2020 15:19:09 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdVszdtPvpasE2FpZ97WRP1uV5UJMC5KjrnziTUY8UQOw@mail.gmail.com>
Message-ID: <CA+FuTSdVszdtPvpasE2FpZ97WRP1uV5UJMC5KjrnziTUY8UQOw@mail.gmail.com>
Subject: Re: [PATCH v8,net-next,11/12] crypto: octeontx2: add support to
 process the crypto request
To:     Srujana Challa <schalla@marvell.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        schandran@marvell.com, pathreya@marvell.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 28, 2020 at 5:52 PM Srujana Challa <schalla@marvell.com> wrote:
>
> Attach LFs to CPT VF to process the crypto requests and register
> LF interrupts.
>
> Signed-off-by: Suheil Chandran <schandran@marvell.com>
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> ---
>  drivers/crypto/marvell/octeontx2/Makefile     |   2 +-
>  .../marvell/octeontx2/otx2_cpt_common.h       |   3 +
>  .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 145 +++++
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.h |   7 +
>  .../marvell/octeontx2/otx2_cptvf_main.c       | 196 +++++++
>  .../marvell/octeontx2/otx2_cptvf_mbox.c       |  26 +
>  .../marvell/octeontx2/otx2_cptvf_reqmgr.c     | 532 ++++++++++++++++++
>  7 files changed, 910 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c


> +static int init_tasklet_work(struct otx2_cptlfs_info *lfs)
> +{
> +       struct otx2_cptlf_wqe *wqe;
> +       int i, ret = 0;
> +
> +       for (i = 0; i < lfs->lfs_num; i++) {
> +               wqe = kzalloc(sizeof(struct otx2_cptlf_wqe), GFP_KERNEL);
> +               if (!wqe) {
> +                       ret = -ENOMEM;
> +                       goto cleanup_tasklet;
> +               }
> +
> +               tasklet_init(&wqe->work, cptlf_work_handler, (u64) wqe);
> +               wqe->lfs = lfs;
> +               wqe->lf_num = i;
> +               lfs->lf[i].wqe = wqe;
> +       }
> +       return 0;
> +cleanup_tasklet:

nit: here and elsewhere, please leave an empty line between the return
statement and subsequent label.
