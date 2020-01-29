Return-Path: <SRS0=eQ+U=3S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B839C2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 15:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCEDF20716
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 15:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgA2PR0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jan 2020 10:17:26 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38804 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgA2PR0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jan 2020 10:17:26 -0500
Received: by mail-ot1-f68.google.com with SMTP id z9so15839648oth.5;
        Wed, 29 Jan 2020 07:17:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qr5rcclDXek9xalM67OQ7srzBCrWHdD63OQGXZ5BcrY=;
        b=o4UgN0G4W4dc1DdK2yQ9dT554SqiFFVd/fytSoSIn5kTXmEGw05N3GvsB7cp7lNXI0
         wynZ834cWK2ZnqYq5OZfO9H4YlFwgFurLKJ13NDevTEKXU01idDOzPs6OxW4yvJczgdl
         NsZvxd9SRajgi6t9YdPSA8Xy8TRACTqZ3VUGp+Y9EP5qonCWxTKPKQLlQ2Qq4B6HBqh9
         ByNDEQdHYB+KGUHQigXQ4T5Ju5+7ScPBWeFsexyXA2KAAHYoPcWbearv302AJ0GXvcur
         yVzo1uagFyFX1+M1HUZha43yHmSUs4jYyYzCLS6dtU5v5TO99uPuTnS8oK1q9zdoLVnS
         YEmw==
X-Gm-Message-State: APjAAAXJ31MCvfhoN9L+tdTk/r8IDPTk2kEVwr6UoyYLcy54XQ28fepy
        V29sI9Au748wUDADmZfl6M1LDgStVEyG+6UGzIQ=
X-Google-Smtp-Source: APXvYqzm0sKN9DWqMLy+3f/Lwgz6cQ0TJe/wpu+/NBaXdpgHp4RGzgfYQzMfphPtX8TSUpHasP5yEarmUFW3n2yBao0=
X-Received: by 2002:a9d:8f1:: with SMTP id 104mr19648679otf.107.1580311045293;
 Wed, 29 Jan 2020 07:17:25 -0800 (PST)
MIME-Version: 1.0
References: <20200129143757.680-1-gilad@benyossef.com> <20200129143757.680-5-gilad@benyossef.com>
In-Reply-To: <20200129143757.680-5-gilad@benyossef.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 29 Jan 2020 16:17:14 +0100
Message-ID: <CAMuHMdVb_AGa7980fRXaxon=uDojZ1x5d6z-FCJAt5aMEGMcbw@mail.gmail.com>
Subject: Re: [PATCH 4/4] crypto: ccree - fix AEAD blocksize registration
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Gilad,

On Wed, Jan 29, 2020 at 3:39 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Fix an error causing no block sizes to be reported during
> all AEAD registrations.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks, this fixes:

    alg: aead: blocksize for authenc-hmac-sha1-cbc-aes-ccree (0)
doesn't match generic impl (16)
    alg: aead: blocksize for authenc-hmac-sha256-cbc-aes-ccree (0)
doesn't match generic impl (16)

which you may want to mention in the commit description, so
people who search for the error message will find the fix.

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Note that even after applying this series, the kernel still crashes with

kernel BUG at kernel/dma/swiotlb.c:497!
....
Call trace:
 swiotlb_tbl_map_single+0x30c/0x380
 swiotlb_map+0xb0/0x300
 dma_direct_map_page+0xb8/0x140
 dma_direct_map_sg+0x78/0xe0
 cc_map_sg+0xa0/0xd0
 cc_aead_chain_data.constprop.25+0x17c/0x6a0
 cc_map_aead_request+0x61c/0x990
 cc_proc_aead+0x140/0xeb0
 cc_aead_decrypt+0x48/0x68
 crypto_aead_decrypt+0x30/0x48
 test_aead_vec_cfg+0x5a0/0x8d0

but you may be aware of that.

CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
