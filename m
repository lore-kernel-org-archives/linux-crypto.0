Return-Path: <SRS0=pM9r=EC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA123C388F9
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Oct 2020 06:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8177E2225C
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Oct 2020 06:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="YGak6vUj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395402AbgJ0GxL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Oct 2020 02:53:11 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:35815 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgJ0GxL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Oct 2020 02:53:11 -0400
Received: by mail-yb1-f196.google.com with SMTP id m188so359314ybf.2
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2020 23:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jjdl2dhuJDpqYsWLtlxuvUmg+zpTbJsyzx07rWA+3Bc=;
        b=YGak6vUjSqyon7HWw3AXm4yi4I+zfP8DvCyJBwe75PHcDCOAkJCopDi7Qkzicv3++3
         bhZeOruwmqj633uMGT9Fkoz80nrswtvPrNDAvux0JVFO2jnRcAuj5Z7XNbilg3XujWIo
         batKSd11/ypHVD8GWSGZhQYHR7Wavf75sVSpYOXYnwSdf1vhDR7oFfPjt+P9E3PM+FAx
         u9Kd4PZgrYM3ahytNjIF1wKkzRKyIGhaFDPGvE3/Wo1ESATJy/GjEyP5wC+HfAF5LgnT
         ZpNyFFQWCOLyU5NeAZEtULbZ6CPUPhjCp/d8UZc4tQ4YZnfyqgzf10vsX7X8E7qcLFWL
         CO4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jjdl2dhuJDpqYsWLtlxuvUmg+zpTbJsyzx07rWA+3Bc=;
        b=ap8oWqtfmP9fIh4OJTXl7Pm8hpx9Trbi1kEMDLCqZ7Dz1O8Uay1S82nrkdRmPbTXZH
         ET3jHj8uOj4oJQKOLmTUX7RE/pEpBRmIPw2vG1k9CKcXRi09EhBIjCm0Hlm0Eea5yrNj
         234vYeQ8uuwca/k6woH2jQa+Y1Gn1Ro5rHfjx6PqjYjpwImN5mZyO9BDcddl6uHXoQjx
         gESwQIuUN0pAfQ7y9io7sU72ujb6pBBXhOG91kHwVMmepbeCHkm0QWXFUE9CwxEcXjBD
         h+KMDW+hlDwGzyfnMxiefPts9GtW/WmBXIlgpH/r4ecWZroQT5m8CFYGaNrP2AK96fJA
         Mdtg==
X-Gm-Message-State: AOAM5317NorBuRgHXpsiBNd/HR2sqDg3X3tdgnLWdIMuTzf2O9p9GJcD
        RsqpNim3kERFBlTTy778ZX8+/Yx0xyIVWmf/a7OXPA==
X-Google-Smtp-Source: ABdhPJxG5Y81UbMg7yEAt0cjolVbinIPl2JL51jHpZOjbo4cTYsOAAhcLTlsA0vigb1dxR69f3JTQzU4O+5S2/bIvPE=
X-Received: by 2002:a25:774f:: with SMTP id s76mr1026683ybc.235.1603781589825;
 Mon, 26 Oct 2020 23:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <20201026130450.6947-1-gilad@benyossef.com> <20201026130450.6947-2-gilad@benyossef.com>
 <20201026182448.GH858@sol.localdomain> <20201026182628.GI858@sol.localdomain>
In-Reply-To: <20201026182628.GI858@sol.localdomain>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Tue, 27 Oct 2020 08:53:04 +0200
Message-ID: <CAOtvUMe=KnRahskJtEh1pgyBfGoeZw0Vsq00Hvh+A_enVFVwZQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] crypto: add eboiv as a crypto API template
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 26, 2020 at 8:26 PM Eric Biggers <ebiggers@kernel.org> wrote:

>
> Here's the version of eboiv_create() I recommend (untested):
>
> static int eboiv_create(struct crypto_template *tmpl, struct rtattr **tb)
> {
>         struct skcipher_instance *inst;
>         struct eboiv_instance_ctx *ictx;
>         struct skcipher_alg *alg;
>         u32 mask;
>         int err;
...

Thank you very much for the review and assistance. I will send out a
revised version.

Thanks,
Gilad
--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
