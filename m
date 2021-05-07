Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4989EC433ED
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 05:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2385F613E8
	for <linux-crypto@archiver.kernel.org>; Fri,  7 May 2021 05:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbhEGF6e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 May 2021 01:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234382AbhEGF6a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 May 2021 01:58:30 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1830C061574
        for <linux-crypto@vger.kernel.org>; Thu,  6 May 2021 22:57:12 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id i67so7422719qkc.4
        for <linux-crypto@vger.kernel.org>; Thu, 06 May 2021 22:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=u9p/hcj120BpkW4kUwOeQkNGvLx4nAXkS2ikZg09zjg=;
        b=sTaHQ1B7k1EgneBBm6KSnNkhpxsgRTLJ3lBWP6r+zHo/uQIF9HytOIS0yAiuDsGkui
         XNz1TmErmNWYuLQxW1vc5G7inQMDv6jdDyOtdzNzS/InBsCjfKm9EoIvufpbo1SOM6/U
         vdA2FmEwOPZQ/fPVpyI9VeL2xh+oHewRO9hHJCMb53XgpvdaSD8kYKckxZygoXXDFPQd
         aFoovB/k3qcyS9Fgix7SKSJhYj4Ifl6NRPgcoOEMduJmljf662L9i+oAsAk0S+CYlrVD
         dNOu2t58eL5/4Ci1BstUcG2PfXBJ4ioq7Vq1DtSjyqdDk0dBX8gRskSUxc0T2FDxmwf3
         OW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=u9p/hcj120BpkW4kUwOeQkNGvLx4nAXkS2ikZg09zjg=;
        b=i0/pR/QdVu5eNypP6ipGZytUcvI8ttYq2u/Vu5W8rl7exfCnMJmzqlKBkPB4Ls4oGp
         AR9UeqGgH0b2GD20SF360r9RkTFzjEQfZQYD7/Tw0X3MRRNuH/jz5CTxAgiehkatkWWz
         cM4dWqyE9x8nLc2zeSGwpAfkl5TT6OT8iIR0zpusIKAAu3d+lhljX33QJ0VHKYOmQ6Wn
         sWTbEck316BiNS7WpajQ4efTvJ0p3EyLfWt6ITtx6YyM53MRIIhVYh0oPGzCfC6NMCzO
         y8V202NJNmxt3symTm0tOgfpQvHukfwnWP6Z5BK47tW0GpsHyAlMxuRxuKcaxJ3KX+2D
         gnQw==
X-Gm-Message-State: AOAM530lXtlvsNYOqoE2TnDMVEBNuu7MS8wX9D1VX6sUrBYERpsNCJRT
        8rqWKB0H8oc+ohzMZT5J2UUiQtivFKwddUAEsl0v9S4QKVOONw==
X-Google-Smtp-Source: ABdhPJwFpH3/BliswBv2ABr2E/3PRA1DzDsEMvuG0EjxJ+GLl0kjnk4QVQ9OIQJGLj4fqxRuh5BGN/FtJ6PVI22cMmY=
X-Received: by 2002:a37:62cf:: with SMTP id w198mr7783930qkb.126.1620367032109;
 Thu, 06 May 2021 22:57:12 -0700 (PDT)
MIME-Version: 1.0
From:   Kestrel seventyfour <kestrelseventyfour@gmail.com>
Date:   Fri, 7 May 2021 07:57:01 +0200
Message-ID: <CAE9cyGRzwN8AMzdf=E+rBgrhkDxyV52h8t_cBWgiXscvX_2UtQ@mail.gmail.com>
Subject: xts.c and block size inkonsistency? cannot pass generic driver
 comparision tests
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I have also added xts aes on combining the old hardware cbc algorithm
with an additional xor and the gfmul tweak handling. However, I
struggle to pass the comparision tests to the generic xts
implementation.

In detail, xts.c exposes the block size of the underlying algo, which
is AES_BLOCK_SIZE. But it does not use the walk functions, because
they do not work if the input is not dividable by blocksize. Now the
xts.c has its own implementation, but I wonder, if that implementation
should accept input sizes other than dividable by block size?

Actually if xts would only accept multiples of block size, the cipher
text stealing would be obsolete. If I use walksize=1, I get the issues
with the unaligned or splitted scatterlists.

I really would prefer using walk just returning the remaining bytes
instead of moving out with -EINVAL:
https://elixir.bootlin.com/linux/latest/source/crypto/skcipher.c#L360
Is that intentional? For me its not logical to allow any input size to
xts, but the walk functions return errors if there are inputs not a
multiple of block size. Furthermore, its a waste of resources to
process all previous walks and then return an error on the last walk?!

I would expect xts to work in a similar way as ecb and ignore extra bytes?
https://elixir.bootlin.com/linux/latest/source/crypto/ecb.c#L36

Or is the advice simply, implement xts to work as in xts.c without
using walks and not worry about the inkonsistencies?

Thanks,
D. Kestrel
