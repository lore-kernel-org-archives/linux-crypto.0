Return-Path: <SRS0=nLyl=CJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD33AC433E6
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 13:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89B802071B
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 13:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598880815;
	bh=u2a7baBYxCtS6DOTTeQGZqtz7VOaC/H7QNvgVVWX2Jo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=FAZDdNZ60KNZ7SXZvXnaY/0yk4jRhHeBuArXSJPxHFVlbTrl+0fA9iqeuPgT2BDkc
	 +5qdGK6zfBkMrMGoB8ZcZ1ehZ8hQVKc4DNGe4P3D1cRaRETbttYW16BzIZXjky/5Rt
	 PVa+vhrLkcaLOYbXOiSi/PqVstctrCjv+AIDzC7w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgHaNde (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:33:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbgHaN1J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Aug 2020 09:27:09 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC5DF208CA
        for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2020 13:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598880429;
        bh=u2a7baBYxCtS6DOTTeQGZqtz7VOaC/H7QNvgVVWX2Jo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qPrKoaFGCLtht+2qrHlKUsOpZ8WYGO56M1NWa4G3HG1rYXZlfWKEjR2kMYZI91Rbu
         a+C1VGhlux33vWwhKQU1FnRvgBiSayPb2Qbl98+hq46kaZOF2ne2l74kqMcP1Oc+Ba
         3OSsVG7LECM5wHPgvjb/CMG2OK/IANu1MwA/zNCc=
Received: by mail-ot1-f43.google.com with SMTP id e23so5285074otk.7
        for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2020 06:27:08 -0700 (PDT)
X-Gm-Message-State: AOAM533bRqvVCpjRxCkFr8z1rulpTGHCSAsVQuZels5IwTOdiRg2pbJH
        EuZXU7JbOopUSxKtBalXfOE07km12FifSSrO1T8=
X-Google-Smtp-Source: ABdhPJxsK29SqP9rV5DA3yIfmfZKK05fiNTgyW3WS047E6mWzFGFD2hrSUT/7FZcFmsLlu3kyi1w21zrYRaedRJS20k=
X-Received: by 2002:a9d:5189:: with SMTP id y9mr1035591otg.77.1598880428253;
 Mon, 31 Aug 2020 06:27:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200822072934.4394-1-giovanni.cabiddu@intel.com>
 <1cffce42de2f4e7b84514a27bd9a889d@irsmsx602.ger.corp.intel.com> <20200828092359.GA62902@silpixa00400314>
In-Reply-To: <20200828092359.GA62902@silpixa00400314>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 31 Aug 2020 16:26:57 +0300
X-Gmail-Original-Message-ID: <CAMj1kXHGLY5CjUBqHoV+9JpNt33j7aDivUrgb08E866X05_sFA@mail.gmail.com>
Message-ID: <CAMj1kXHGLY5CjUBqHoV+9JpNt33j7aDivUrgb08E866X05_sFA@mail.gmail.com>
Subject: Re: [PATCH] crypto: qat - aead cipher length should be block multiple
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        qat-linux <qat-linux@intel.com>,
        "Przychodni, Dominik" <dominik.przychodni@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 28 Aug 2020 at 12:24, Giovanni Cabiddu
<giovanni.cabiddu@intel.com> wrote:
>
> On Sat, Aug 22, 2020 at 02:04:10PM +0100, Ard Biesheuvel wrote:
> > On Sat, 22 Aug 2020 at 09:29, Giovanni Cabiddu
> > <giovanni.cabiddu@intel.com> wrote:
> > >
> > > From: Dominik Przychodni <dominik.przychodni@intel.com>
> > >
> > > Include an additional check on the cipher length to prevent undefined
> > > behaviour from occurring upon submitting requests which are not a
> > > multiple of AES_BLOCK_SIZE.
> > >
> > > Fixes: d370cec32194 ("crypto: qat - Intel(R) QAT crypto interface")
> > > Signed-off-by: Dominik Przychodni <dominik.przychodni@intel.com>
> > > Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> >
> > I only looked at the patch, and not at the entire file, but could you
> > explain which AES based AEAD implementations require the input length
> > to be a multiple of the block size? CCM and GCM are both CTR based,
> > and so any input length should be supported for at least those modes.
> This is only for AES CBC as the qat driver supports only
> authenc(hmac(sha1),cbc(aes)), authenc(hmac(sha256),cbc(aes)) and
> authenc(hmac(sha512),cbc(aes)).
>

Ah right, yes that makes sense.
