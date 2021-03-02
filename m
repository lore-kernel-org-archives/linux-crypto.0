Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD98C28D13
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C84B764E09
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239845AbhCCBiV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835416AbhCBTGL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Mar 2021 14:06:11 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73FAC06178A
        for <linux-crypto@vger.kernel.org>; Tue,  2 Mar 2021 10:54:08 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id l7so10204811pfd.3
        for <linux-crypto@vger.kernel.org>; Tue, 02 Mar 2021 10:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Hx49CiFVsjWXhYMbQ1MybklMKVdncil6IRYeMIiiiqg=;
        b=IOq/9c9L0kzgvANyoP9GDYC6E3xdNFils1b7k1X3vXSsznefMdGMk77uKXcIkVbbI2
         QoZQF1b1/GJQKW4R6tq1MFo4aNmbBMbPvn3Hhy5DRrb977w6+3aM+ygpzrW9xyb2gYVl
         QDWNIp+yCFYLGXLqlpd47jfD4H2gKTnv6vQPbFzTYQOQ9G5PF1si8mBoNiIlA3Y1XeXV
         7VA3D6N3MfHXPMmzaG6LeTo+gK3W+T45RvygqSejIhaY3m+oUbZx2zYNmJZybMATZ63f
         6TYzXDD9aRsbYKACg2/TIywE2vgY0Dp1ga0k2CgyxAknSaNLqCOziIArkOpe2KXNGl/K
         mrCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Hx49CiFVsjWXhYMbQ1MybklMKVdncil6IRYeMIiiiqg=;
        b=RtkQ+cXvh2nru5PWGRVmaTx/wVwFpAzMYGW836iJMBy03cMeKVokdMqFGtS4pwm8t2
         OxmF7G3vNyiYIWZUu02JBPpUWwmDOT5595/w5EzzfZz9kZ83GM3+GGmb9RxJYsTVQys4
         8q4OwC/kBaINrdtaW+F8x3zAUTxstsroETnXa0SMAxlE91vdnXHsESrOctQnzsTBRKvE
         yI4qZ3ACKKchwa2Ihp92zfxDs9CVz8s/35OmBHLAdMcXjnCW6TVkpDynR7K0iQ63csrk
         g8Hi/kfk7rjMPqpncVqGmpSL9op0YuFYyyQ3iZwPXCOcgn8LCRv3RsStKUGRtotNXxDB
         ZeNw==
X-Gm-Message-State: AOAM531S7BHt/JBCsJb9y+8wOicTTLXbYz5M/mcEtHzPOL/wZ1TU1q3T
        D0EaFANFYxe6DQ2ktcfyqhJrb0lCNt12cieeSWYXzvrR
X-Google-Smtp-Source: ABdhPJwsqpHgfXIqGPh/eVJkp2YbDOmdSK3JIynDeFDBT5dgvAXheaZfPIEQtP2M5qs7cAS6ZbEj1elH4c6uQQp2T1s=
X-Received: by 2002:a62:c301:0:b029:1ed:c3d5:54d6 with SMTP id
 v1-20020a62c3010000b02901edc3d554d6mr4503449pfg.18.1614711248173; Tue, 02 Mar
 2021 10:54:08 -0800 (PST)
MIME-Version: 1.0
From:   Arthur Sakayan <asvdem@gmail.com>
Date:   Tue, 2 Mar 2021 18:53:57 +0000
Message-ID: <CADkYWuQhB_3CxYoyg-d0qNywGMU-TQwG0cobpJGKAxJv01Q45A@mail.gmail.com>
Subject: Beginner's questions
To:     linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello everyone!

I have a very great interest in improving the linux kernel, with
special regards to cryptography.
However, due to my lack of knowledge, I do not know exactly how can I do so.
Thus, I have a few questions regarding this:

How exactly do I start contributing to the linux-crypto subsystem?
Where can I find a list of bugs (or other issues, for that matter)
that need to be addressed?
What should I know in order to be able to contribute to the
linux-crypto subsystem?

Sincerely,

Arthur
