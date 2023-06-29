Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E69CEB64D9
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Jun 2023 04:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjF2EgM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Jun 2023 00:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjF2EgK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jun 2023 00:36:10 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9361FE8
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jun 2023 21:36:09 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-51d88f1c476so264791a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jun 2023 21:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1688013368; x=1690605368;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ikys1zr7cMawvGGeYC9ud7X4b6QEolSbsQLEDLa8S8I=;
        b=H/Ioj9zyb7N6M+bHh1K4prVO+Uw/XsagqtsSeU0cg3/a6/Trk+iGHIt6DvHsAYjynF
         312OYjsMirspcGPcAvO9ZNxZPqs2m8oUb8I/m7Uk/dy+1utqI+O6N0RXkzq7qr9kPmoo
         zewxoY3xaAEokQ02S4VrYKD6bey2z+qGQEdYA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688013368; x=1690605368;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ikys1zr7cMawvGGeYC9ud7X4b6QEolSbsQLEDLa8S8I=;
        b=RWv3Z+Ri0bQLQNfwVt05chXD+hXvZlUAZrhAByL9m+jZiC7MEZAdSilVPbsH4EnbjX
         Tw1EkyOfUsrWYSVOWwPH+9fd2v1jCCDAV5ulNW3V0x8cOpHV+cYDI+aXR4IgTx/8dQq/
         RPfQGshYKtuTS5G1BQlz5D7+EehOzAf45oqA5Kwy98WsM/e6W1kANlolUcuLcUegkXW7
         A6CTZQGS12GUaUGBLM9zZ3nUzrLU7Rd53P5VzR/xZfO2TGntE01hoTOjDyZpSjQe+8II
         q5FkGri+SuGBjX8YINwOScUhnWW4kGUZ6O6QC3NjKRlwK2iuMLZ14YeSgP82CdEq7hnt
         pMnQ==
X-Gm-Message-State: AC+VfDxZEDmYd99ndow/sBXhOEx603gpQxkAxQMPqqyLypRdN+8ly7rV
        yRHlyLjM59Hp8oP2o9xSRkpSH/fEZ75M2CxuNZQDHHhY
X-Google-Smtp-Source: ACHHUZ43PPnQJNQ3g2XQW9rGpaQYuDiW+kVfPlPrERaOysKGb8nM+yNy1Edskq1jeDo5ESaLY2xohQ==
X-Received: by 2002:a17:907:783:b0:988:dced:f339 with SMTP id xd3-20020a170907078300b00988dcedf339mr23662395ejb.31.1688013368028;
        Wed, 28 Jun 2023 21:36:08 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id ec10-20020a170906b6ca00b009893650453fsm6488369ejb.173.2023.06.28.21.36.06
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 21:36:07 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-51d88f1c476so264769a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jun 2023 21:36:06 -0700 (PDT)
X-Received: by 2002:aa7:d48f:0:b0:51d:a02d:f8fe with SMTP id
 b15-20020aa7d48f000000b0051da02df8femr6243450edr.29.1688013366534; Wed, 28
 Jun 2023 21:36:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=whXn0YTojV=+J8B-r8KLvNtqc2JtCa4a_bdhf+=GN5OOw@mail.gmail.com>
 <202306282038.C3A12326A@keescook>
In-Reply-To: <202306282038.C3A12326A@keescook>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 28 Jun 2023 21:35:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=whbbFHUF44At4YYOB9ZWg00rhFmyArD+KocXDX-+-8a1Q@mail.gmail.com>
Message-ID: <CAHk-=whbbFHUF44At4YYOB9ZWg00rhFmyArD+KocXDX-+-8a1Q@mail.gmail.com>
Subject: Re: Build error in crypto/marvell/cesa/cipher.c
To:     Kees Cook <keescook@chromium.org>
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 28 Jun 2023 at 20:48, Kees Cook <keescook@chromium.org> wrote:
>
> The unexpected bit is that without -fstrict-flex-arrays=3 (i.e. the
> default since the dawn of time), the compiler treats any array that
> happens to be the last struct member as a flexible array.

Oh. Ok, that explains why it's showing up for me now, at least. It's
an odd rule, but I can see why people would have done that.

I've only seen the zero- and one-sized arrays commonly used for the
traditional "fake flex array", but I guess other sizes can easily
happen.

                 Linus
