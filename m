Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E94C4742C
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 14:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 725CC22240
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 14:34:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PaVPavm/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgKMOeu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Nov 2020 09:34:50 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:36701 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgKMOeu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Nov 2020 09:34:50 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d62a9a21
        for <linux-crypto@vger.kernel.org>;
        Fri, 13 Nov 2020 14:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=D/5agUQ7oYBGjFkEleMmRtkIOn0=; b=PaVPav
        m/mKJtvLw8t2O3TDj3DwKzLLJdzbjjc9ya3Ez3cWbFvQ1gWvTmBonEKrbJlzJ2Y+
        6aB1TS2QTlyn395eF9npOpIdvVdsEO14GwnPVSIAmXzEkRe/UyFRnuwh7PceL/dh
        zjgiIWS/8WfJAZ5vzDzVFhAJJ3wpnhrzrlhZiAGHbViypjlHnkIm0dliPmo31PpM
        e8IqGorzZf0fk8uA+YGWRbyssrpD73Fc7MmuHiOlaV5sZZsjFnpYsDj5j6eR2mYC
        57lgaC+P+H2lMFmpxFOGhegqMqrCiaM1lvLVwi0w3jjn9hHZ8NyyNLzOEfp8KsXr
        qRnpLQGwyEZpgU5g==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id aab55d45 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 13 Nov 2020 14:31:28 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id o71so8573878ybc.2
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2020 06:34:48 -0800 (PST)
X-Gm-Message-State: AOAM533zeycPSnHm/EOcGVnPCbXsLHwk5M5QQOogB0AqPyqPUCiOhtAt
        Haxpw90rOBUIb3iPj11mh0V34QnxThWVNGaq47c=
X-Google-Smtp-Source: ABdhPJx5g6zfgJK4ZPuH9fmQIUrihO8/AuzOxsobiArxkbVOl9I/jEHFuglXBJMPisxVDuP5wNqiDClPCzUlgFZVohw=
X-Received: by 2002:a25:6f83:: with SMTP id k125mr3325444ybc.123.1605278087667;
 Fri, 13 Nov 2020 06:34:47 -0800 (PST)
MIME-Version: 1.0
References: <20201102134815.512866-1-Jason@zx2c4.com> <20201113050949.GA8350@gondor.apana.org.au>
In-Reply-To: <20201113050949.GA8350@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 13 Nov 2020 15:34:36 +0100
X-Gmail-Original-Message-ID: <CAHmME9r=myLmSJMvjDff_VG4ya2_Q-22=F+=kOucnYwqzZTxWg@mail.gmail.com>
Message-ID: <CAHmME9r=myLmSJMvjDff_VG4ya2_Q-22=F+=kOucnYwqzZTxWg@mail.gmail.com>
Subject: Re: [PATCH crypto] crypto: Kconfig - CRYPTO_MANAGER_EXTRA_TESTS
 requires the manager
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks. FYI, I intended this for crypto-2.6.git rather than
cryptodev-2.6.git, since it fixes a build failure and is a trivial
fix.
