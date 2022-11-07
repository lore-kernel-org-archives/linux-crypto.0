Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB7CC433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Nov 2022 12:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiKGM4M (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Nov 2022 07:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiKGM4L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Nov 2022 07:56:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5AF1BEAC
        for <linux-crypto@vger.kernel.org>; Mon,  7 Nov 2022 04:56:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15E2DB8113A
        for <linux-crypto@vger.kernel.org>; Mon,  7 Nov 2022 12:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B9DC433D7
        for <linux-crypto@vger.kernel.org>; Mon,  7 Nov 2022 12:56:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="AEg+GrQk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667825765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eVFHRqT6qK8YAmmgPDnPJH4AuXaijhL4G9cuTbiOLww=;
        b=AEg+GrQk1XIWkOYLSu9tayN0PWB2/fdKZpjoEzZVR+Vgz7NKSdxOnS87j1MJ6i1PzEhdsw
        FJF39SjdKzGav/8N1flzChnNmP5Gsm02jZvhUEQq0o4KzeEg9N4nrgrLFypTVnt9/OWbAT
        ji4pP8WNKa0cGSB6KJCqTU0GYOgcrwo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7c2f3ce9 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 7 Nov 2022 12:56:05 +0000 (UTC)
Received: by mail-vs1-f43.google.com with SMTP id n68so10293700vsc.3
        for <linux-crypto@vger.kernel.org>; Mon, 07 Nov 2022 04:56:05 -0800 (PST)
X-Gm-Message-State: ACrzQf17BgHtZqJOT2XgtZCMWU9AEUUMt+8g4kS2UU05wXgT15lWqV5e
        PfZL7/dGIZ6sZ5jmb3KZGNJqL4d4GjRljT96lus=
X-Google-Smtp-Source: AMsMyM6TGrtyarLGai328VIeK1dmOWh+znNxsPvqdj5/1IuZgfZWrpg4tB+7TYGtwM0c3sLoG2xVz5i09cPYye26Rek=
X-Received: by 2002:a67:c297:0:b0:3aa:3cac:97b6 with SMTP id
 k23-20020a67c297000000b003aa3cac97b6mr26933118vsj.76.1667825764706; Mon, 07
 Nov 2022 04:56:04 -0800 (PST)
MIME-Version: 1.0
References: <Y2fJy1akGIdQdH95@zx2c4.com> <20221106150243.150437-1-Jason@zx2c4.com>
 <Y2hqsz8kjJgwNm0E@gondor.apana.org.au>
In-Reply-To: <Y2hqsz8kjJgwNm0E@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 7 Nov 2022 13:55:53 +0100
X-Gmail-Original-Message-ID: <CAHmME9odRaJYThnkfoss7Zvy8EPahwkk5Ey9J6XiZMgGQevfaQ@mail.gmail.com>
Message-ID: <CAHmME9odRaJYThnkfoss7Zvy8EPahwkk5Ey9J6XiZMgGQevfaQ@mail.gmail.com>
Subject: Re: [PATCH v3] hw_random: use add_hwgenerator_randomness() for early entropy
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

On Mon, Nov 7, 2022 at 3:17 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sun, Nov 06, 2022 at 04:02:43PM +0100, Jason A. Donenfeld wrote:
> > Rather than calling add_device_randomness(), the add_early_randomness()
> > function should use add_hwgenerator_randomness(), so that the early
> > entropy can be potentially credited, which allows for the RNG to
> > initialize earlier without having to wait for the kthread to come up.
> >
> > This requires some minor API refactoring, by adding a `sleep_after`
> > parameter to add_hwgenerator_randomness(), so that we don't hit a
> > blocking sleep from add_early_randomness().
> >
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
> > Herbert - it might be easiest for me to take this patch if you want? Or
> > if this will interfere with what you have going on, you can take it. Let
> > me know what you feel like. -Jason
>
> I don't have anything that touches this file so feel free to push
> it through your tree:
>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Okay, will do. But by the way, feel free to change your mind about
this if need be. For example, I sent another patch that touches core.c
too (the entropy quality one). It touches different lines, so there
shouldn't be a conflict, but if it's still annoying for you and you
want to take them both, just pipe up and I'll drop this one from my
tree.

Jason
