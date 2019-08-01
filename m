Return-Path: <SRS0=q4N3=V5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1C0C19759
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 07:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B2B3206B8
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 07:14:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kGxY5Un9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbfHAHOO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Aug 2019 03:14:14 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42094 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729116AbfHAHOO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Aug 2019 03:14:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id x1so22454741wrr.9
        for <linux-crypto@vger.kernel.org>; Thu, 01 Aug 2019 00:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZtpEMYtf9IHdV3/wzdyegV2uPdXRwuCeceSmuY7Qe2Q=;
        b=kGxY5Un9HMbrQVikYl7BdRGEJNk5seUr9xeLQkOJDxIPzBL8ZCOo5hZEehQdRAPkM2
         OYSdq91UyJHcAXWkOS3fXNHZxPyQnrxo+Ulaf61evzNTscYjfi+7Cbehk+1E8m71/6mC
         U13xfhTyg6+jd90DZaFh0A0KMY2LjWgUkLkn+OkzulwZD2J+oyygxJdv3WJPQVymFs3U
         sYVSGFPXXiMGIgm0d6zF2kJtYo8sbLMA2okHxV9UWYZgZwDcwaR4342v7sjwNc+enXO9
         chXU8y7gejR3HdyXdtx+tSVGh00n063k6lp/OlfmcsCP+Uo4pszNnccKOwxJod40odcD
         BYng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZtpEMYtf9IHdV3/wzdyegV2uPdXRwuCeceSmuY7Qe2Q=;
        b=UtoPcPUxS5z4JheOapN/5xiYcpmkSDO7cY9Pqi0sgfKZGYeOuLBvUYrhuwDcJimT8S
         eOVEjf+mJgQrxG/DtglZUSoG4VNaklHvEWjJPg5gMP0gZZiOh/HwMYJqP4/7zY7J+uTA
         9LukKklBWpY55T6L5SNuOjnR+BcHK7/xyrs6qyxBcu0jDwS3io1d0MaK5NwN/ZCeBJrI
         GHxuLtyozYv1awVXkIr9qid0jVv5O82jfPQWOnonssR2kle+ahGBUu5IQkYSkFz6zI0X
         OGyaGkqqfu0uhSJHzg73pRP7G38idzJ/z5bKwZ1h0M0qC2t2XwKgS/GMj8ECOqdXPSrh
         ZO6g==
X-Gm-Message-State: APjAAAXeQkoOCceqj8N9QmMgGx/Xm+C7UHuvyeXQcZW0XG45nclIyJgK
        7pJiOkLf2yRlRMrSfvJ10nQssG5KFnqqPpgcIaDRhMJNvRQ=
X-Google-Smtp-Source: APXvYqz2wqSKzTJIvgWm78hO385N0YvtpdJKQHPyq2WJg3IG6jUfYtbKcjYdcOtacK8hJh3nvmsajE/Vpys+rxreSuE=
X-Received: by 2002:a5d:46cf:: with SMTP id g15mr1158635wrs.93.1564643652032;
 Thu, 01 Aug 2019 00:14:12 -0700 (PDT)
MIME-Version: 1.0
References: <1564578355-9639-1-git-send-email-iuliana.prodan@nxp.com> <VI1PR0402MB348576458A879D8F162D01C098DF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB348576458A879D8F162D01C098DF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 1 Aug 2019 10:14:00 +0300
Message-ID: <CAKv+Gu9LTy4Qpo8hDdjuv62NiecMHDuUu5H19WoCqY+UupeBRw@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] crypto: validate inputs for gcm and aes
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 31 Jul 2019 at 16:35, Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 7/31/2019 4:06 PM, Iuliana Prodan wrote:
> > Added inline helper functions to check authsize and assoclen for
> > gcm, rfc4106 and rfc4543.
> > Added, also, inline helper function to check key length for AES algorit=
hms.
> > These are used in the generic implementation of gcm/rfc4106/rfc4543
> > and aes.
> >
> For the series:
> Reviewed-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
>

Likewise,

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
