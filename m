Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F6DC433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 10:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56612611AD
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 10:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhKJK60 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 05:58:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231390AbhKJK6Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 05:58:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3992F6112D;
        Wed, 10 Nov 2021 10:55:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DBIbSZOf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1636541736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WmueZ09jFCxU1lP4zqKat6z12TNGWULMkXTBHp2p50w=;
        b=DBIbSZOfqkI0Rv3suc5FLD88W6rGftimEgDiRguuzEcRxdcpF4VRC7qbX+RkSdPQxtxOP1
        vzdQwotq/QcMuq0huh2bQonhzcvbdL/tDXb8zfCybMGSdlRCEEupPkeL3UCLQ4+E5DKFEU
        aQ0YP2FSoUaDxChjbKR55GDnTwtbqwQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 92469a34 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 10 Nov 2021 10:55:36 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id d10so5396514ybe.3;
        Wed, 10 Nov 2021 02:55:36 -0800 (PST)
X-Gm-Message-State: AOAM533aKpvD1GDYjAO6YbWa9NkbeFpJC/ri80VDkRnks3xdRyaW9vcN
        2m2xCXJD2RWok6NckKoeu5PUuYNp6Uhdz0uzz6U=
X-Google-Smtp-Source: ABdhPJw8vzD1g9ykNeIGT6Q2UWX6Wuicn6mSgS2/8uLIzCkjX8vDxopcKE6ElK67IfQMEzLpb87z/5xJaG/Pg5VDtU8=
X-Received: by 2002:a05:6902:568:: with SMTP id a8mr15951335ybt.472.1636541735672;
 Wed, 10 Nov 2021 02:55:35 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:2047:b0:fa:da35:6920 with HTTP; Wed, 10 Nov 2021
 02:55:35 -0800 (PST)
In-Reply-To: <CACXcFmnKhYyjHNzu_MxZ2qup1jxp4CWT09HzBu=h5D2Ur9LjWQ@mail.gmail.com>
References: <CACXcFmnKhYyjHNzu_MxZ2qup1jxp4CWT09HzBu=h5D2Ur9LjWQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 10 Nov 2021 11:55:35 +0100
X-Gmail-Original-Message-ID: <CAHmME9qtTHn2-kRc-OZFk9i2qvcE6d1fTz9342wdxw2XHt3r5w@mail.gmail.com>
Message-ID: <CAHmME9qtTHn2-kRc-OZFk9i2qvcE6d1fTz9342wdxw2XHt3r5w@mail.gmail.com>
Subject: Re: [PATCH] random: Use 64 bits from get_random_long() in extract_crng()
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Any rationale? Commit message is a bit short.
