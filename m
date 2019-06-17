Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE48C31E57
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 13:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E43220657
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 13:35:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SjGYC/+Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfFQNfg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 09:35:36 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55092 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfFQNfg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 09:35:36 -0400
Received: by mail-wm1-f66.google.com with SMTP id g135so9286501wme.4
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2019 06:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc;
        bh=YHOKN/Zex43LqsWAn+nvtdwesx9lRT9rJQZg0D1/GH8=;
        b=SjGYC/+QU63hmlP/S9v5/ZOTTGsW4dWJbEqd3hpxifPH61Y5LrF7hNt8CZtF1kb019
         iIAB/0EhbzqKQTZc0qZ3WjzXFoTEj1gXqnoCwUSwzryJiWBQDI70pGNttK+x47Ck5L8y
         ntv46YONcpU/jHGYLiAFmoDIDDJs4ATS3CG289A7FxlWdNqKimXYHJM/kOUiNQb9CYTA
         RpFoxP52ptM1jRyq+gLVgKly4eoQjSam2KFVWvMRf/hryj/u7Y6kPl6HVvd3sYfTp0US
         RmSHsDmuj0kS8fvMLsyvEbpM0Lr3XYpRTlLAKcWYgS+tj/z1WTw8jMbSPIUaDvUn5R3R
         Hb1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:cc;
        bh=YHOKN/Zex43LqsWAn+nvtdwesx9lRT9rJQZg0D1/GH8=;
        b=fibANu/8++kwzHjJcZYPNwd7UVTUzI5sBhmCf/3zFWezAdCcXgscr3neyBTqBfKgMQ
         aaUwT+QJM7MwIJEbxwOSpRvo74KSSB2w8r5XvpeRpI/BYHFYFPtL/+0qGW0M7KWCBMPY
         z//IfL9d87MBoPo2uf7RcLPU9tuZSzDmElrKrdC5DF4c7TvmRkjzCzmoY3A/mU9Cud0I
         2buLQ5INpayN6SNPeHUrML/99O70i0bROjMXhFqIrgxD19mxPegLN3p8wVlVSa1bw/0l
         q6+0xQ75uiDXG+nNmJ4xFudsjUgeB16YQokOfDv+RFMmIsoEwrogfjkacRETRSX2ad1n
         awEA==
X-Gm-Message-State: APjAAAXCQs2Id3+aA7d3DyH67MyFpM2ioOonNIAbUDLD0gSLE1dfG/M7
        3D7QGC+kRxO72oGTxoZzQ09IodbCGO1IgRYaePQ=
X-Google-Smtp-Source: APXvYqzbpPDmg5HnlfCiY1QWZjDkhjUKVlYf57sWQNEsT2W5kzCrOnUyqsDPvwcN9tgxyc3dN67qcnijEgz4pyQF6dQ=
X-Received: by 2002:a7b:c215:: with SMTP id x21mr18980449wmi.38.1560778534290;
 Mon, 17 Jun 2019 06:35:34 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 17 Jun 2019 15:35:23 +0200
Message-ID: <CA+icZUX3EOhrUp0Afbo_fK9rb5AbXjbaBFwhj1qmBaHom1b3MA@mail.gmail.com>
Subject: Re: crypto: x86/crct10dif-pcl - cleanup and optimizations
To:     Eric Biggers <ebiggers@google.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

while digging through a ClangBuiltLinux issue when linking with LLD
linker on x86-64 I checked the settings for...

.rodata.cst16 and .rodata.cst32

...in crypto tree and fell over this change in...

commit "crypto: x86/crct10dif-pcl - cleanup and optimizations":

-.section .rodata.cst16.SHUF_MASK, "aM", @progbits, 16
+.section .rodata.cst32.byteshift_table, "aM", @progbits, 32
.align 16

Is that a typo?
I would have expected...
.rodata.cst32.XXX -> .align 32
or
rodata.cst16.XXX -> .align 16

But I might be wrong as I am no expert for crypto and x86/asm.

Thanks in advance.

Regards,
- Sedat -

[1] https://github.com/ClangBuiltLinux/linux/issues/431
[2] https://bugs.llvm.org/show_bug.cgi?id=42289
[3] https://git.kernel.org/linus/0974037fc55c
