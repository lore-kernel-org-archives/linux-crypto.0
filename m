Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A00CC2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 13:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3313520716
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 13:42:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oz58F4m2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgA0Nmm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 08:42:42 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44054 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgA0Nmm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 08:42:42 -0500
Received: by mail-wr1-f65.google.com with SMTP id q10so11340363wrm.11;
        Mon, 27 Jan 2020 05:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y6ki84dpG3p3ueoh8tAmX4ZWvgFXi6ehd6g1X98nIDY=;
        b=oz58F4m2sfW3y9sCPEbOpOZAefxEjNLwcykf10DEj3+dfzrRVX72hMDNRW1Ei/RE7C
         ZXA6GXb69ir2cLwgZlV2CL7yZM2Yvye242O1kiiPu2fZx6SZDwWcqA+/7VWBgq3OHS1l
         FAMOjWQBUwjtefp15OGbKMwhZb/boQ4+612L71nWs2IQyWOgb6dVHJOAuavfrFDzzxYM
         0VMvqCoOttl/W9Qp/O6KyWLHje9z+SLTm9L2TeKQ64Oy17fHZ+DiUt4Cz6V14vEHmSzL
         sXaoxloZEUbfXL6/vfCMjIviwSHEe1ndDe6C7ERfDk+qptzSt5MtVz/VO/ReEA2lms19
         mntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y6ki84dpG3p3ueoh8tAmX4ZWvgFXi6ehd6g1X98nIDY=;
        b=WmA25/LDPEdUu1uqyA+Dy6ucSTz3HMVOZrFcA6ebfs0MemPey3YDE/pu3EuUDrZ5xO
         g15K0wPsxCwWkoDn2vFcgAjdn6EA1LkOk0lbuEzCW3xiLxz3Fw3AtLJ7MY4XbyjoN9xK
         WMGKHLB4vzqSNQMnHtBJwHkj+jAs5o48MAIXUSZ8A07pvA+Boqir7UhUSIH6FguVINbx
         o57lvnKmZ35spHVCUgJ26ow2yMoudhDRKMnz55wfaP1ZnNxoYMCX86dkOcYsDhfnlY+f
         v1zyI8207WrKNDcPtnAHjz2P/kztjaW5XfOf1QRZQ2mwI1NqP1oUzb/FPINGisB55Euz
         BOig==
X-Gm-Message-State: APjAAAVEbybSS7v+ZYZvpQhCX5aRK55agO+bPtxs9FDaWsZ+tJmy3UGr
        jYRuBWe8lrWZ8OWfnCnqC5PafftudgNAfcaEqlE=
X-Google-Smtp-Source: APXvYqyFtGBbRA+cDOX0+IuYiCJ8AbkYd7rNtVArOO1PApnoVqO65/bL89MorhL629a4I9ncNiZFwEBTT3bDsDBk0CI=
X-Received: by 2002:a05:6000:11c5:: with SMTP id i5mr21942512wrx.102.1580132560146;
 Mon, 27 Jan 2020 05:42:40 -0800 (PST)
MIME-Version: 1.0
References: <20200108154047.12526-1-andrew.smirnov@gmail.com>
 <20200108154047.12526-8-andrew.smirnov@gmail.com> <VI1PR0402MB3485E327703191780AC68BFE98350@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485E327703191780AC68BFE98350@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 27 Jan 2020 05:42:28 -0800
Message-ID: <CAHQ1cqEohhpY62dqKpi=-hzWDKJMDB1jr1+wM+6KYDBQr8wV=w@mail.gmail.com>
Subject: Re: [PATCH v6 7/7] crypto: caam - limit single JD RNG output to
 maximum of 16 bytes
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 13, 2020 at 6:10 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 1/8/2020 5:42 PM, Andrey Smirnov wrote:
> > In order to follow recommendation in SP800-90C (section "9.4 The
> > Oversampling-NRBG Construction") limit the output of "generate" JD
> > submitted to CAAM. See
> > https://lore.kernel.org/linux-crypto/VI1PR0402MB3485EF10976A4A69F90E5B0F98580@VI1PR0402MB3485.eurprd04.prod.outlook.com/
> > for more details.
> >
> > This change should make CAAM's hwrng driver good enough to have 999
> > quality rating.
> >
> [...]
> > @@ -241,6 +241,7 @@ int caam_rng_init(struct device *ctrldev)
> >       ctx->rng.init    = caam_init;
> >       ctx->rng.cleanup = caam_cleanup;
> >       ctx->rng.read    = caam_read;
> > +     ctx->rng.quality = 999;
> >
> AFAICS the maximum value of hwrng.quality is 1024.
>
> Any reason why it's configured to be lower, now that CAAM RNG-based DRBG
> is configured to reseed as requested by FIPS spec to behave as a TRNG?
>

Only my reading of the old version of corresponding documentation
which listed this field as being per mil. Will fix in v7.

Thanks,
Andrey Smirnov
