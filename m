Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DAE3C55ABD
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 20:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE0F32222F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 20:13:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="wzJisTMf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgKMUNk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Nov 2020 15:13:40 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:55435 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgKMUNk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Nov 2020 15:13:40 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id eec0682d
        for <linux-crypto@vger.kernel.org>;
        Fri, 13 Nov 2020 20:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=07x2DaQbB5pL0IK/RSOz9FZmYEA=; b=wzJisT
        Mf3HzK1K04ZGnV7SqXAFKfOKZm2jvBDCEgZjq41n4TG+qMgnMcAvSgW14pW299+r
        5lCTFyMwNAP2SI2fBxnm7Tk/hOps+f1BVo5bo8YpFYK5QDnXvFHb1yCEp2QyDgGi
        KDbZnoFm8CHkjqsx9Zn3DpiAYGoY3dGGyY41IEotv9ywzlT1S35c4l2vqnrTYOXo
        VK3v/6CRhIJpYKaCKbvPr5TkMYNlLJMfHt1IND7QLsP/IoR/ORRsT606ezXu83Df
        6klgGs3z0ih9tteARzjY1zl9NiLnW3V89EHmQTpf/N7y0m1sjZQnk5JcJ7pcViX+
        ZWANVZ4Pc7oD57mw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 72973926 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 13 Nov 2020 20:10:17 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id c18so9807230ybj.10
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2020 12:13:38 -0800 (PST)
X-Gm-Message-State: AOAM531voD5WxFppdOJDFUAXz+3ercsuYJHPttm7Ise/OfyBaX73lLmm
        Ypex+bC17xRAlTm66oyI2KBPrtVptC2LeudAzWI=
X-Google-Smtp-Source: ABdhPJwPB/OGr8ZTf9nx1ULdzvPvVLQwmFNuLAkPBkFyc1D4FvRVwVDnWPrDDjlKDf6mySPWuT4bpdPoOs0pb3GZ3bo=
X-Received: by 2002:a25:d215:: with SMTP id j21mr5209073ybg.279.1605298417907;
 Fri, 13 Nov 2020 12:13:37 -0800 (PST)
MIME-Version: 1.0
References: <20201102134815.512866-1-Jason@zx2c4.com> <20201113050949.GA8350@gondor.apana.org.au>
 <CAHmME9r=myLmSJMvjDff_VG4ya2_Q-22=F+=kOucnYwqzZTxWg@mail.gmail.com> <20201113195809.GA18628@gondor.apana.org.au>
In-Reply-To: <20201113195809.GA18628@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 13 Nov 2020 21:13:27 +0100
X-Gmail-Original-Message-ID: <CAHmME9pHuuo75aVEX=7=2ga=G8yD7aBjvxyEi8-WZpbtJhMHpg@mail.gmail.com>
Message-ID: <CAHmME9pHuuo75aVEX=7=2ga=G8yD7aBjvxyEi8-WZpbtJhMHpg@mail.gmail.com>
Subject: Re: [PATCH crypto] crypto: Kconfig - CRYPTO_MANAGER_EXTRA_TESTS
 requires the manager
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 13, 2020 at 8:58 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Nov 13, 2020 at 03:34:36PM +0100, Jason A. Donenfeld wrote:
> > Thanks. FYI, I intended this for crypto-2.6.git rather than
> > cryptodev-2.6.git, since it fixes a build failure and is a trivial
> > fix.
>
> Well this has been broken since January so I don't see the urgency
> in it going in right away.  It'll be backported eventually.

Okay, no problem.
