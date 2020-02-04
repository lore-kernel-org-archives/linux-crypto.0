Return-Path: <SRS0=JC+L=3Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66633C3524A
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Feb 2020 08:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1514D2087E
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Feb 2020 08:18:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SsRJvjUB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgBDIS4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Feb 2020 03:18:56 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:54491 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbgBDIS4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Feb 2020 03:18:56 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id dc6c90b9
        for <linux-crypto@vger.kernel.org>;
        Tue, 4 Feb 2020 08:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=gSD11iKUZjoJrM7u1+4z8eOkYbE=; b=SsRJvj
        UBZcQDjkBIAtS0eEEOh3DnbxMB4QBuzOM3YOegIfbGmFb5XqqbiBIOrt+IkcG4NV
        PeOP5a7bT99oLzAtKiMJxtY0M82Pno9Li5dAx6K3OutiUzR/KPNhSV4z4dsTbRUC
        y+IlotcnuBXxGHTDepOYW9XwiKlWnyTiHzJZgkExkXIav0PQ0varziJ6g0ODOi7o
        NPMlngGb8xpUNROqMr2XITxK/8ahOyaFByaf3Ml/XNsdZ+BNfupNyrtRJVSvUJx8
        DPvkqCI/2n0rvoYHpPE3RfyA1jgoOPrNgYlplbhxSPxvNcO2CVQD7GMbnvMTnj2u
        zOQnlQaXsOKn8cSg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0aec9515 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Tue, 4 Feb 2020 08:18:08 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id j132so17563506oih.9
        for <linux-crypto@vger.kernel.org>; Tue, 04 Feb 2020 00:18:54 -0800 (PST)
X-Gm-Message-State: APjAAAXtFKhwhishuPtW3cFWTK/8LV88Eolr1hK3Z33T4LkEyGgEKyMo
        dq3J6KTYxocOjecIj1+zkARSntbylSjHGTyUuWE=
X-Google-Smtp-Source: APXvYqxMfM4YcdZVklfrvEryvXwZ62FlFzl+dPPSfXcVRnCKQmvAIduw9jVjv9EjkuDmdNFFXtkIoAw9oyvp79HzeGs=
X-Received: by 2002:aca:2109:: with SMTP id 9mr2537897oiz.119.1580804334170;
 Tue, 04 Feb 2020 00:18:54 -0800 (PST)
MIME-Version: 1.0
References: <20200117110136.305162-1-Jason@zx2c4.com> <20200122064821.dbjwljxoxo245vnp@gondor.apana.org.au>
 <CAHmME9p8T_1V+3FfUeAMjBLShQk08xR7RQqijov8zWS286hTNg@mail.gmail.com>
In-Reply-To: <CAHmME9p8T_1V+3FfUeAMjBLShQk08xR7RQqijov8zWS286hTNg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 4 Feb 2020 09:18:43 +0100
X-Gmail-Original-Message-ID: <CAHmME9pxAV=w9wV7Mp12HphaiyQP1VRvWEuoTdNNi7onN178Kw@mail.gmail.com>
Message-ID: <CAHmME9pxAV=w9wV7Mp12HphaiyQP1VRvWEuoTdNNi7onN178Kw@mail.gmail.com>
Subject: Re: [PATCH] crypto: allow tests to be disabled when manager is disabled
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

Can we get this in as a fix for 5.6 please? This is definitely a small
and trivial bug that's easily fixed here.

Jason

On Wed, Jan 22, 2020 at 11:18 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Wed, Jan 22, 2020 at 7:48 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > The library code uses CRYPTO_MANAGER_DISABLE_TESTS to conditionalize its
> > > tests, but the library code can also exist without CRYPTO_MANAGER. That
> > > means on minimal configs, the test code winds up being built with no way
> > > to disable it.
> > >
> > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> >
> > I think we still want to keep the extra tests option within the
> > if block unless you have plans on using that option in the lib
> > code as well?
>
> I think this would be useful for the library code as well.
