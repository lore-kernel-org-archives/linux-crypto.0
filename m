Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01D3C49EA7
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jun 2021 09:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A980F61433
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jun 2021 09:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhFYJIR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jun 2021 05:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhFYJIH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jun 2021 05:08:07 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1E9C0613A4
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jun 2021 02:05:47 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id p15so3573933ybe.6
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jun 2021 02:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9Ck+JECuHhF+XibLFt/1GgUC0k/E3vtnQI/RdAO/KzU=;
        b=0s46wxSkFGOIbh2ZSlXP4QzYuh3VOlHMQ0Zh5IQtJOp/+c7HSH4NK6s+r6q78liNfM
         TH98ALgxYuhrrGbkLr6Tb7QJD6Tu7WYrqBB3EnEHY2X5fJQ6UQ54Lk/AQiqNZvcFMpXv
         FZbLMkY33nfbSShMPFHwV1rWDAA3nFNBukwFvQTrvv89YkG2jD7gtBMu175tyJk0+i9s
         TX3SIZdD338CEP9wZ7GC+uuloeCZEANPN+E+AxVXj4Ne5qMsB+1XWvzNgKrQFGWfP6Nn
         H0XDFk+8B18ibahYyVFk8Yiyn0DYQplKBIzOIhgCfdEwimNy6Ao3jCBwhDRr3uF0gPeF
         GLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9Ck+JECuHhF+XibLFt/1GgUC0k/E3vtnQI/RdAO/KzU=;
        b=AD8/2xtTE/IpwBBv/GIQrtclGEB9KUL7vlSKm/KpvciE+NfIvjXGH7TyCV7v/cKHJq
         w9FsJuKz+B/Cj3E1c/39fj95OmXKQtv5c0By/Rhn0UQtlr5rN5nl+PZD6raTTM60wdSF
         NOw6sSPmY0Z/j1CQHQ0SWiIbzKjH4ryjDRdsMzLaxp6a37W2pD9G2fz5AO7O4iyFQitw
         oMwQv4IFXxtyPP8rMoOJk9/fm/1GSaf63LnThOobwsoJd6on2SAx4EAH7JHposI6BP9I
         dQobHHGoo9/QnjK9nVAFd7s7dxPq9oQ6OeTb/a/UpGbzka/pUu3E4yyqG8TiZ83lyQlV
         CERA==
X-Gm-Message-State: AOAM531BZqtwFN5HtSlRCA5Z4Vo4LRlyZceXGlRzUYG2UwzJaj0fVrY3
        1EtMPa7Y+ACJcfEGgOGt3rAhR4UB8viOwYnTcvawIg==
X-Google-Smtp-Source: ABdhPJwT7mBTxFB2KCvGaabPBBhyDKh95AwbFKMcPsKCU7iReq/PJgisg+Lo2VGqUXkL6+aa9/rh5cwJxozsPm/VlP8=
X-Received: by 2002:a25:618a:: with SMTP id v132mr11371392ybb.129.1624611946586;
 Fri, 25 Jun 2021 02:05:46 -0700 (PDT)
MIME-Version: 1.0
References: <ab361a862755e281f5fef67b3f678d66ae201781.1623413974.git.geert+renesas@glider.be>
 <20210624211348.GA1991366@robh.at.kernel.org>
In-Reply-To: <20210624211348.GA1991366@robh.at.kernel.org>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Fri, 25 Jun 2021 12:05:35 +0300
Message-ID: <CAOtvUMdhDhbvL8M8HkVi+4d1jXPpw4ORJTBooU0V8Q6JBqSO+g@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: crypto: ccree: Convert to json-schema
To:     Rob Herring <robh@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Fri, Jun 25, 2021 at 12:13 AM Rob Herring <robh@kernel.org> wrote:
>
> On Fri, 11 Jun 2021 14:20:17 +0200, Geert Uytterhoeven wrote:
> > Convert the Arm TrustZone CryptoCell cryptographic engine Device Tree
> > binding documentation to json-schema.
> >
> > Document missing properties.
> > Update the example to match reality.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> >  .../bindings/crypto/arm,cryptocell.yaml       | 53 +++++++++++++++++++
> >  .../bindings/crypto/arm-cryptocell.txt        | 25 ---------
> >  2 files changed, 53 insertions(+), 25 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/arm,crypto=
cell.yaml
> >  delete mode 100644 Documentation/devicetree/bindings/crypto/arm-crypto=
cell.txt
> >
>
> I'm applying this version which is dual licensed as that is the
> preference of my employeer, Arm, who is the copyright holder here. I'll
> sort this out internally with Gilad.

If it's fine with you, Rob, it's fine with me.

I'll sort out the procedure internally. Sorry for the previous noise.

For what it's worth:

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
