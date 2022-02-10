Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2673AC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 15:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243475AbiBJPKX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 10:10:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbiBJPKW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 10:10:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AE4B88
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 07:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F78E61B8A
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 15:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F144C340EF
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 15:10:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="esdrUKFM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1644505819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BhfYAth/N3VJ7ZKxCD48ZFPKIXVeO5sfWYQ/g1BvmIQ=;
        b=esdrUKFM/ybeWOo7dvexbdSs03tbl16HV7F1m4nLk5rSDUXp9bd5MSK+0AIdszoz9mr2kb
        YwXGJ/XdnjFbXsZ+Y8C2U4hDJ7sVW4MDvw/s5LMJEH4DEIsvuJWP3EYZgUOPHsSn3kNW1M
        OV+IvEBAyUe+IYwQR6h1+TtO1olPcys=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 43e29685 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 10 Feb 2022 15:10:19 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id p19so16311729ybc.6
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 07:10:19 -0800 (PST)
X-Gm-Message-State: AOAM531bCxEXxMFs3wCUYTqd4bpPS+ludQYPDDBVXV+lN4mQdrlp1Er9
        okYgXGH/WafAc2UdU6w2jQAOWiIs2LvxSvXeyG4=
X-Google-Smtp-Source: ABdhPJzHSy14m/4tVxHoPFFHKdiyj0NEWc9rsufVVIi/kP6aqHOQnlWP1N9DE6Y8IvhTs51XiVaDzbIoWvgEnI/kMtk=
X-Received: by 2002:a81:c646:: with SMTP id q6mr7528514ywj.485.1644505817866;
 Thu, 10 Feb 2022 07:10:17 -0800 (PST)
MIME-Version: 1.0
References: <CACXcFmkC=6DsDiTbtnu=LMSsg00Lxz7jvcWNV=yDibz8suoVgw@mail.gmail.com>
In-Reply-To: <CACXcFmkC=6DsDiTbtnu=LMSsg00Lxz7jvcWNV=yDibz8suoVgw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 10 Feb 2022 16:10:06 +0100
X-Gmail-Original-Message-ID: <CAHmME9qUidkmQBfKD7gnd4m8pVJvB3RysdvZ4e9j=QJ28ZOnzQ@mail.gmail.com>
Message-ID: <CAHmME9qUidkmQBfKD7gnd4m8pVJvB3RysdvZ4e9j=QJ28ZOnzQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] random: change usage of arch_get_random_long()
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hard NACK on this patchset.

Issues:
- The superficial ones that Greg's mailbot is now emailing you about:
improper threading, missing sign off, bad whitespace, poor coding
style, etc
- We don't need XTEA for this; there are probably better choices these days.
- Distinction between "get_hw_long()" and arch_get_random_long()
doesn't exist, since get_random_bytes_arch() just calls
arch_get_random_long().
- Even if we did want this, replacing arch_get_random_seed_long(), a
function meant to supply a *fresh* value from a hardware source, with
something more deterministic changes the intention.
- Likewise the cycle counter is supposed to be at least a little bit
entropic, some of the time, maybe, in the best of circumstances,
perhaps... whereas expanding an XTEA key that's seeded from that same
cycle counter (in the absence of other things) at one point in time
seems clearly worse.
- Probably others, but after 10 minutes of reading this it seemed like
it wasn't worth it to go further.
