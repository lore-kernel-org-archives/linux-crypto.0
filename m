Return-Path: <SRS0=oCQ2=QT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13BD1C4151A
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Feb 2019 09:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D64D12184A
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Feb 2019 09:13:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nwMwJznL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfBLJNq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Feb 2019 04:13:46 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:55864 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfBLJNp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Feb 2019 04:13:45 -0500
Received: by mail-it1-f194.google.com with SMTP id o131so2158212itc.5
        for <linux-crypto@vger.kernel.org>; Tue, 12 Feb 2019 01:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j3xNCkHI5YfV+JFfNXKhsUZCK/m+EZ030Hw3v1FVvpg=;
        b=nwMwJznLija7v6oxLebJP9Emc2mi+U/Wb4NSJWbVl1I6ihgnGBpr8KGK9jyZgnivtJ
         3wReg/e2+RnTGNlH1Gmm34k5U1+rTLIPqvr24Lu/d767colLXY6NjmZzNdtBtFTZbv0x
         englC6i/rXX5HTTQzdKFLZydusABfxFu1Xid+QbyTm1aMG/LyIbIIxPqkd7aKSNLM+yT
         81gSs8KS6HbOXA0oL8uZ9q6NGeXJGjZxDG16GcMmvXyBPR7XEGtVNLJObBSzkJ2KptXk
         SpNURNVAzsmHQfdD04DjhNldEtCS0NhLHPW+7kKpIO/sdkyvrO2rSeF7pxLAyUcs1F+1
         H6HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j3xNCkHI5YfV+JFfNXKhsUZCK/m+EZ030Hw3v1FVvpg=;
        b=IHwffI39lVdUkxNWgEtCFL2yCQGc5yIYOCXgHsHqR33OdjrrOqSb4gCGNi04uaWyHW
         deXRJGLfxK9Pr38pnleiVx4rG8TpoWpm+XdcbOmAseOje91w/7EvDT1jLuoauaOq0L3a
         jx+2IB5S6ZST62wsTcb8n15cIIceoNt5+XxgYsHB5gH5mRnPuegbTEjCPvsQs6mYaoEk
         rHDtwBK2x6+zKjxZfQdZye6lPgnKZzXowyXArTMFBVHKfl78wsgRde+apRuetcVAQkFz
         2h2KB9K0YIgGljfA9iu8hdn8DTjJm942p9aI08K6RKHvboJh/OASZbtwf9L4hBRlGBZI
         IDEQ==
X-Gm-Message-State: AHQUAubjlDnGq6qsZdbBiOGkbeMX+Sfs43jUy7RqhRNdfyQ1tmKUDQsw
        S3IsU0LL84CjU830+dr+csPrlF06ziU/PCuchUqMYw==
X-Google-Smtp-Source: AHgI3IbKpotgp6hTXup7QsCCqUAhFF1USWa8At2T/dg76mln24cBZRvnevgAtZZToVaVAK0sVDD2ApL+8GHlFecDO3w=
X-Received: by 2002:a5e:9704:: with SMTP id w4mr1636201ioj.60.1549962824771;
 Tue, 12 Feb 2019 01:13:44 -0800 (PST)
MIME-Version: 1.0
References: <20190131061225.15541-1-s.hauer@pengutronix.de>
 <VI1PR0402MB3485ED41FE4B512C83271E0B986D0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190208071635.5dkhabduambzzsu3@gondor.apana.org.au> <VI1PR0402MB3485ABA90793B50E7744A0A198690@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <CAKv+Gu9F3Uof+RfWsaB8qk_WuWxnopd_nA1kEXhbYP5ZCejvWQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu9F3Uof+RfWsaB8qk_WuWxnopd_nA1kEXhbYP5ZCejvWQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 12 Feb 2019 10:13:33 +0100
Message-ID: <CAKv+Gu-bA-bZLGe+SFzkBXOL1xNa9SBFLGQBKrPAmM+aHuw8LA@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - Do not overwrite IV
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 8 Feb 2019 at 09:55, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Fri, 8 Feb 2019 at 09:41, Horia Geanta <horia.geanta@nxp.com> wrote:
> >
> > On 2/8/2019 9:16 AM, Herbert Xu wrote:
> > > On Mon, Feb 04, 2019 at 12:26:26PM +0000, Horia Geanta wrote:
> > >>
> > >> The root cause of the issue is cache line sharing.
> > >>
> > >> struct crypto_gcm_req_priv_ctx {
> > >>         u8 iv[16];
> > >>         u8 auth_tag[16];
> > >>      [...]
> > >> };
> > >>
> > >> Since caam does not support ghash on i.MX6, only ctr skcipher part of the gcm is
> > >> offloaded.
> > >> The skcipher request received by caam has req->src pointing to auth_tag[16] (1st
> > >> S/G entry) and req->iv pointing to iv[16].
> > >> caam driver:
> > >> 1-DMA maps req->src
> > >> 2-copies original req->iv to internal buffer
> > >> 3-updates req->iv (scatterwalk_map_and_copy from last block in req->src)
>
> This violates the DMA api, since you are touching memory that is owned
> by the device at this point (even though the addresses do not actually
> overlap). Note that on architectures that support non-cache coherent
> DMA, the kmalloc alignment is at least the cacheline size, for this
> exact reason.
>

Actually, the driver does violate the DMA api in another way:
scatterwalk_map_and_copy() is accessing req->src after DMA mapping it.
Does the issue still exist if scatterwalk_map_and_copy() is done
before the DMA map?

(On a non-cache coherent system, the DMA map will typically perform a
clean+invalidate, which means that the invalidate that occurs at unmap
time cannot corrupt adjacent data, but this only works if the CPU does
not write to the same cacheline while it is mapped for the device)
