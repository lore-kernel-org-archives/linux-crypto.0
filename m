Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6249BC433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Jan 2022 10:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbiA3Kjw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 30 Jan 2022 05:39:52 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:54344 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiA3Kjt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Jan 2022 05:39:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 83EDDCE0E62
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jan 2022 10:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEBDC340E4
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jan 2022 10:39:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="T+AJSmvJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1643539184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IBBlmrtLujuxkBxLliAIOBo7+gFNh7QPxyD/toTeTD4=;
        b=T+AJSmvJmXnzw1cda2rV74QSwOXfwPhm7QltVBETvVjzb+a0WALh2D5sel4/vGho8hGYuT
        ZbiOkrxxWlr4vvxIX1lCtdKvg7XsWrQ7OIuueFq2vyzWUR770HHlQxNeD+ftB46415hYVJ
        Oop5xgqqtlrejjVWTkILKlyQsCc1d3A=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 269ae25d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Sun, 30 Jan 2022 10:39:43 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id i10so31745425ybt.10
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jan 2022 02:39:43 -0800 (PST)
X-Gm-Message-State: AOAM530Z462bO+zOZccFNXgu4OeGQsbNAGF5s28Rcp8wS2XHLkTKSPR1
        U9/V9d3rTbs030AXkO9W/64lzFZYPOtld/2Gn1c=
X-Google-Smtp-Source: ABdhPJydlue2nQJPR7fvFoHkCX3yXB9Y206Qcx988Jug3QVjvLMdKcCmrohZlYH/Ed+AwhReKaqu1cOr2GHrJ+5QB6c=
X-Received: by 2002:a25:c70f:: with SMTP id w15mr24346759ybe.32.1643539182721;
 Sun, 30 Jan 2022 02:39:42 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:6254:b0:129:4164:158b with HTTP; Sun, 30 Jan 2022
 02:39:42 -0800 (PST)
In-Reply-To: <CACXcFmnPumpkfLLzzjqkBmxwtpMa0izNj3LOtf2ycTugAKAUwQ@mail.gmail.com>
References: <CACXcFmnPumpkfLLzzjqkBmxwtpMa0izNj3LOtf2ycTugAKAUwQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 30 Jan 2022 11:39:42 +0100
X-Gmail-Original-Message-ID: <CAHmME9pUW1o_QPfs45Q0JWucA5Qu1jhgMV7x2PycxosYV2wV7A@mail.gmail.com>
Message-ID: <CAHmME9pUW1o_QPfs45Q0JWucA5Qu1jhgMV7x2PycxosYV2wV7A@mail.gmail.com>
Subject: Re: [PATCH] random.c Remove locking in extract_buf()
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, m@ib.tc,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch is missing a S-o-b line.

Either way, I don't think this is safe to do. We want the feed forward
there to totally separate generations of seeds.
