Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFA2C04AB6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 16:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E45721530
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 16:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bbW3y4za"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfE1QA4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 12:00:56 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:38913 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfE1QA4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 12:00:56 -0400
Received: by mail-wm1-f52.google.com with SMTP id z23so3473692wma.4
        for <linux-crypto@vger.kernel.org>; Tue, 28 May 2019 09:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=Uzl0kjZXshtDOVeA7ZqM/RMMcACIIG6IqAe8cpmBqjU=;
        b=bbW3y4zaSMbMu9eToZ6aQTm/GR+RjcqLob7WwMwCjPU0p1OsdtHKttUCo8y3HOnM+W
         cPi2c8ke+q5so6CoCdiysi978BS19s1WbJTpp5Qp+eosiC76acLRba1G2Z+v5tjuBLmF
         0YVH287jQ7Sy0R7dQNgRMQPj+tyK1wGxDerUDAtdJz8nDmUhcjcF0rOps1pCsM2NUcJ2
         GYQBGggu2O4obg77Ch6Auyokt+84dwAMoqte46lOM+Q15RRSpFeCL46wBqdIwr5qZJi0
         V1Zl5TuMGT6mC2jokwQC+JKzjZRJceo9Ebf/J15E8htxFAXq1BkqDJdlamWXIjGg7doP
         Byvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Uzl0kjZXshtDOVeA7ZqM/RMMcACIIG6IqAe8cpmBqjU=;
        b=IbdSfZUU1Hz2RSnAx52+e/kcSVV68tf8DGjYv9kTMl17UwUxMNbt28bVva5ZXxH+M2
         /HxDPrPiADqOSHSP2XgTaQv+mQEeDDwNE0oXaxvZALYVAJnW5dj+QjNCLxzyUbinTsAl
         nhd407yDDjzDSx/zfK3Y+TuJYzKwd0oUmL9b2I3yWrAnf+t7SqODZ+SFRSVkyN27SM+e
         ZUUo5B6bakIFGA86fJY5D+qJAItbF4KESUmfivaMMfFU7WZmb2AhdQ8UiDR5p3aJTRdt
         U2zHf2o+jUC3+SkFqPom4YJWEHe1vojxawAccBpQMwXcnTXIWGA8ZULT4ElhgJLrJqoJ
         d5Tg==
X-Gm-Message-State: APjAAAVVcnFA36XbibfAYKk24mIGsghCZGEHzKTPpf/j04WprXBoUcCb
        g29NCW5xN9S5K3vwDqPPxy+25OTk8azLv1Rv8ZY155mL
X-Google-Smtp-Source: APXvYqzC8Qu9jsJhj73WMKv0Z839C+KLFYHLSx77Vb4Lh07Y2bXj5+pxDc4xK8fFOVjn2m0gN1SyumsujSTeOE4GRok=
X-Received: by 2002:a1c:6545:: with SMTP id z66mr3665448wmb.77.1559059254568;
 Tue, 28 May 2019 09:00:54 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB3523ADF4617CB97D59904616D21E0@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB3523ADF4617CB97D59904616D21E0@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Tue, 28 May 2019 12:00:41 -0400
Message-ID: <CACXcFmkNQ7-YBxrEYoBzfvite_jS2X0a3w7rvksG+YFB4ipD1A@mail.gmail.com>
Subject: Re: Conding style question regarding configuration
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Pascal Van Leeuwen <pvanleeuwen@insidesecure.com> wrote:

> ... the proper way to do this is not by
> doing an #ifdef but by using a regular if with IS_ENABLED like so:
>
> if (IS_ENABLED(CONFIG_PCI)) {}

See also:
http://doc.cat-v.org/henry_spencer/ifdef_considered_harmful
