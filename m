Return-Path: <SRS0=1oRy=R4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F0FC43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 10:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F2F42085A
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 10:45:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="yQknR11j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbfCYKph (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Mar 2019 06:45:37 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:36699 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729727AbfCYKph (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Mar 2019 06:45:37 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 533e5f4b;
        Mon, 25 Mar 2019 10:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=zr5SXN1vgPvcVfg0Sv4PAysjlus=; b=yQknR1
        1jGitrUPBpOZ0onBZtH0/huvRc4MN8570XlaQ6J0vmoAkM3jQ4SJ++rwelilAyl4
        mx4BqXqwIdmlp+tMDkQRbOgIRbQeckd8qybAkI9LFTvq2DLqgKYWXOlgbkoNiS/n
        gnGMoa+DUSjHg1SGr0Ft4myIDNcuZiQfHTOhYaO1rZRVgR4WjmvtnO4hzvVSWSKC
        /JQ65DEXKiwgfKFvNbex1Ga8rGpcSpr0ut0NYSvWAOCDdleA8++hu2ungk0bYDrn
        DdOeNUZKfcRq/ZBpiA5llpdFsHikqHBUzmYXkqX/oUKnO2hrVj3/63l1byGuKLkO
        U7lMLXiMcrG2dTkA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a8d1579f (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 25 Mar 2019 10:23:26 +0000 (UTC)
Received: by mail-oi1-f182.google.com with SMTP id j132so6554997oib.2;
        Mon, 25 Mar 2019 03:45:33 -0700 (PDT)
X-Gm-Message-State: APjAAAWjbrjj0FlGLLrS8cTOp9WL5t5i3xE/VYRy4OG6J5Of+8eoPn9G
        DA2Lp4XrMAsxXJRAb/DyuSqahQNerFh2ANTgJJ4=
X-Google-Smtp-Source: APXvYqzybk8gfhGJXzdEdK/OXcfofAdzeEBN7pws0QRiT3VVmXpcYqBOYH7vxHkZZktMrHxdpMHb26p4rRIA0uN4tDE=
X-Received: by 2002:aca:480e:: with SMTP id v14mr10600420oia.66.1553510732646;
 Mon, 25 Mar 2019 03:45:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190322062740.nrwfx2rvmt7lzotj@gondor.apana.org.au>
 <CAKv+Gu_mgyzqUCeb+wke--8Gn8YbjOb8jyrSgFr3-tcNP8ccEQ@mail.gmail.com>
 <CAHk-=wg2LJ5qQ0B2y+_6Ue62SBP4h9MLxLvn89bfcP7Cp2ac6A@mail.gmail.com> <CAKv+Gu_NoKi3hhxw+S59Yu_c0R6fZh8+KW1XnyFWg74MxEixGA@mail.gmail.com>
In-Reply-To: <CAKv+Gu_NoKi3hhxw+S59Yu_c0R6fZh8+KW1XnyFWg74MxEixGA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 25 Mar 2019 11:45:21 +0100
X-Gmail-Original-Message-ID: <CAHmME9o4YsfLcQnChSSn7p-dr9Y9q6Ky84rVdKdPD_1=4Qtx_A@mail.gmail.com>
Message-ID: <CAHmME9o4YsfLcQnChSSn7p-dr9Y9q6Ky84rVdKdPD_1=4Qtx_A@mail.gmail.com>
Subject: Re: [PATCH 0/17] Add zinc using existing algorithm implementations
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>,
        Martin Willi <martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 25, 2019 at 11:43 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> onto a synchronous interface. My concern is that we will end up with
> Zinc patches 12 months from now that implement async interfaces to
> support some particular piece of hardware, while other hardware is
> only supported by the crypto/ API, even though the algorithm they
> implement is the same.

Allow me to allay that concern: Zinc is for simple synchronous
software functions.
