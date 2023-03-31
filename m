Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98930C761A6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 19:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbjCaTb1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 15:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbjCaTb0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 15:31:26 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C471220C07
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 12:31:23 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id p2so16904107uap.1
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 12:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680291083; x=1682883083;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+3dxiSE1b5vMH8CGGajC9u8RQm7fB9GO6qLHC2uiED0=;
        b=mw2AmrfS0Nxie4InDrhi9cdWmJuP1bvHcGUpK8/JmOI0zD4F/vIQAp5F+K8NeQELCY
         YwIVNQSd7eB7LUrkWnRss0WXSKP+pTP4+gzLS0i+gcGaZcuxTvdsL/nlv3m6zcpRKwBu
         p1MgKqI9yT1w94qw/e8LEdTo9uybAhDY9V3hk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680291083; x=1682883083;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+3dxiSE1b5vMH8CGGajC9u8RQm7fB9GO6qLHC2uiED0=;
        b=v0ZrZRBg1JsRg478MRMyh/EzbPx/JCP9d2Mt27YJ0ChFAkvooPSG271NrCaVfDOGV1
         j0S7H52+bmdRh2bEjp0a0g3rspS1kiNPMTQ2xY/VLoQqfiGmLg7lL3ik5YrGDZprnN3U
         tewyzz+359r1fvawe1vVwUKFrHIiQrNgLXnAIVp4Ef2ocXX81lUsgpZi81fPsbVdI/1e
         cqQeFMy2lmyfLnRpyzR2SQz5gC5ZF8LY0Zbc2Q7qBW9RLDTy/U0yXzbCfQGKDYdwcesM
         2KKx8GW2UbB0W4oEdP9iAVT9PsjUWOwKQjLXayOcpxjZDtj2Qijj7KwgXrlu59+w9RAf
         ZxlQ==
X-Gm-Message-State: AAQBX9dju3yqFAW7Kv3L7X36yQ7fDo7Pco9ojRECXVF4IgnMrMYGybz5
        rvPogrf8hFUwS/WFcCCBTZf5tB2c/i1X9O423dkzXg==
X-Google-Smtp-Source: AKy350andnC9439itOhIGftw2sv9M2P+o8+hQiPu07abkIvKMy6vw0xdngqBOgatacpoGdgs6WFpAxtzkIkgPqImNYs=
X-Received: by 2002:a9f:354a:0:b0:764:64c1:9142 with SMTP id
 o68-20020a9f354a000000b0076464c19142mr6416703uao.0.1680291082859; Fri, 31 Mar
 2023 12:31:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230329220753.7741-1-mario.limonciello@amd.com> <20230329220753.7741-5-mario.limonciello@amd.com>
In-Reply-To: <20230329220753.7741-5-mario.limonciello@amd.com>
From:   Mark Hasemeyer <markhas@chromium.org>
Date:   Fri, 31 Mar 2023 13:31:12 -0600
Message-ID: <CANg-bXCN_86i41OZ1mAv5G9cOXm_0i+LApXEjtg96Rxx5BYiqA@mail.gmail.com>
Subject: Re: [PATCH v7 4/6] crypto: ccp: Use lower 8 bytes to communicate with
 doorbell command register
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     =?UTF-8?B?SmFuIETEhWJyb8Wb?= <jsd@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Felix Held <Felix.Held@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> Unlike other command registers used by the PSP, only the lower 8 bytes are
> used for communication for both command and status of the command.
nit; bytes -> bits

Reviewed-by: Mark Hasemeyer <markhas@chromium.org>
