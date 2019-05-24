Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2693BC072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 19:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAA8B21850
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 19:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558726995;
	bh=JoJ30cZZRw+96tUSEN2lLac7yZbukKSqlzqPvnxZo0E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=MyQruQc5D3MHI5Z3Jj9XwHmQNRxz/1IQ/PNx6M56IvaSM4bs+6WfUb1IVVfl9VOFc
	 L+EE9QL/5QWGqCZpeKS/1JZ41wQPFLv260butfT3OOQlovHR1syvwP7wDU3NU/XAm5
	 q/k2e+N5NHCGFglnt/0AbCzGxmXkYVUlPj1PQtTQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391771AbfEXTnO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 15:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391745AbfEXTnO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 15:43:14 -0400
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C12621851;
        Fri, 24 May 2019 19:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558726993;
        bh=JoJ30cZZRw+96tUSEN2lLac7yZbukKSqlzqPvnxZo0E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fovUaanVzvYvwZEA1pjRpYU1WpEc0jWDhBLr9b2svYpR0Riztfp2nATcfeW8Uqn+t
         usnY29eAv0rh0aA95b/kWrxvIGL4TTBlVIsklWbWkaeVA54n3aJbYCmpQKnQhf2bx1
         aVLnT2RCS9MUkIzG/jSCJXwaxzOdlKSX/FApIaUY=
Received: by mail-qk1-f178.google.com with SMTP id a132so9186520qkb.13;
        Fri, 24 May 2019 12:43:13 -0700 (PDT)
X-Gm-Message-State: APjAAAWCHJoAUFNhBxTmQ5BLDu0tdEFSgVtUvGNbv4FvNI4wMdfo5fg5
        2fGA5uLqA/kNZ4aqZYO964MoK+2JaKsH3pOQvQ==
X-Google-Smtp-Source: APXvYqzkUYKCKgnkwrNYbWnSQTsripKs5yX2p+epdNTxo2VL5V4U7Vanpt6QtJj+hEfCDR5o4QiRFJEscpPwAJKjIjA=
X-Received: by 2002:ac8:3884:: with SMTP id f4mr89506622qtc.300.1558726992675;
 Fri, 24 May 2019 12:43:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190524162651.28189-1-ard.biesheuvel@linaro.org> <20190524162651.28189-7-ard.biesheuvel@linaro.org>
In-Reply-To: <20190524162651.28189-7-ard.biesheuvel@linaro.org>
From:   Rob Herring <robh@kernel.org>
Date:   Fri, 24 May 2019 14:43:01 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+=p+YA9emmZMhbCA75NM1ZksAx6mZkP1Fsype3SpK=TA@mail.gmail.com>
Message-ID: <CAL_Jsq+=p+YA9emmZMhbCA75NM1ZksAx6mZkP1Fsype3SpK=TA@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] dt-bindings: move Atmel ECC508A I2C crypto
 processor to trivial-devices
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, devicetree@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 24, 2019 at 11:27 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> Move the binding for the discrete Atmel I2C Elliptic Curve h/w crypto
> module to trivial-devices.yaml, as it doesn't belong in atmel-crypto
> which describes unrelated on-SoC peripherals.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  Documentation/devicetree/bindings/crypto/atmel-crypto.txt | 13 -------------
>  Documentation/devicetree/bindings/trivial-devices.yaml    |  2 ++
>  2 files changed, 2 insertions(+), 13 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>
