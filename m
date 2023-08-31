Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F70C83F2F
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Aug 2023 17:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237485AbjHaRKj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Aug 2023 13:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343861AbjHaRKi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2023 13:10:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51C78F
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2023 10:10:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BB0162D44
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2023 17:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D30C433CC
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2023 17:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693501834;
        bh=uiLO/nSsSs1flvZrz0Clz6ISPAZ5Lq0D/ODFOp9fdgQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rCgiIYm06eaOAocNQELX49Q8behSSuN+BfgZ8tfRRcQJ6pprAiVbiU29w3pyK5F1K
         H3Zk68nL8JE11nQpEdh2gbwoy8DtSgyOGUnMfgZwCCtuW3MoXscvHt4F+xcT0ie5Dd
         g9lPvvtaTQKAxQCQJZ/68a+tRRri4FAGanfXC9uWVwm9dJoN1DerP2zQ+HuR5X1ts4
         OkmATAirOgW47/gYcZppOoRTQRPsJxQKtzoSHmQZRrEpn6eAAPs2bUMC8EnWokw7Eg
         JqPD6fLLAnp9WIzBionw8w7KuzEVmBqM6H8gOg7i9uhrNNlLZ4tQBG+rUf+skQ4GF4
         sCnw8F9mSYYYg==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-500cfb168c6so1961413e87.2
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2023 10:10:34 -0700 (PDT)
X-Gm-Message-State: AOJu0YyPcZhuVCgzsRr7ZXUaa68fg2EZAppjTtkm3eiuD8WwXaHJUd8x
        nFJoNg+wPby6P7vDGFw2Uv6prwXIP4mxEhiLLmA=
X-Google-Smtp-Source: AGHT+IF8GFFoaBrYuN/cSSRBUoKAsriFhs5bDc+5Wc47CXydA/TFLIhQ4nA4ynwj24A7e02vE9Qk2y9Oa1etj/q0Vvw=
X-Received: by 2002:ac2:499e:0:b0:500:b7ed:1055 with SMTP id
 f30-20020ac2499e000000b00500b7ed1055mr4170875lfl.56.1693501832516; Thu, 31
 Aug 2023 10:10:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230726172958.1215472-1-ardb@kernel.org> <ZMy1DkYRBc1PxC8e@gondor.apana.org.au>
 <CAMj1kXHCt6DJEZKYVYBXN0QhZ0w2ByCPUK2S2y2T5U06Ztrx9A@mail.gmail.com>
In-Reply-To: <CAMj1kXHCt6DJEZKYVYBXN0QhZ0w2ByCPUK2S2y2T5U06Ztrx9A@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 31 Aug 2023 19:10:21 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF0e+MKyDJPS7r=LWusEBCaw=t03JC=+Dz0Qk+GmY+uXw@mail.gmail.com>
Message-ID: <CAMj1kXF0e+MKyDJPS7r=LWusEBCaw=t03JC=+Dz0Qk+GmY+uXw@mail.gmail.com>
Subject: Re: [PATCH] crypto: riscv/aes - Implement scalar Zkn version for RV32
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?Q?Christoph_M=C3=BCllner?= <christoph.muellner@vrull.eu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 4 Aug 2023 at 10:31, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Fri, 4 Aug 2023 at 10:21, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
...

> > Hi Ard:
> >
> > Any chance you could postpone this til after I've finished removing
> > crypto_cipher?
> >
>
> That's fine with me. Do you have an ETA on that? Need any help?
>
> I have implemented the scalar 64-bit counterpart as well in the mean time

Is this still happening?
