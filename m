Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75810C64E7B
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 11:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A6CA2080A
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 11:43:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="e2B47Mha"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgLALnd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 06:43:33 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:50697 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730363AbgLALnd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 06:43:33 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 9dc57d16;
        Tue, 1 Dec 2020 11:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=jbEvcnVie3+BiOHDlwb8pV05AQc=; b=e2B47M
        haBLMImb04QPd7EBiC9Mb9aUnvN4fhDybiScvo+f9ZFzJ57Dhp6ExrIL5Yn5tpbj
        W8aeD4WNIlv/CgGygp049t7STELeQDLkVeqZid/1DZsZabJNV0Qh3LUkN9YIGKHf
        LJQ4T37QTZlDUAMO4ct/we9BTb56CIsN6U9iDzxFqOe7Sp3gMuD2DzT7orCe8Dtk
        akz0H6JU96kovR8CYgyI+cwo1WaH4z3tmMdC0D49Ncf+8R4Quk1OX+5uOvh7sL4y
        2ciIDJ1gyhM1dCBqEdP33MrvhxqaOjjlp0fhbEfSqdHz7HUnWJt/bHvLRkJ+aKdF
        oPB2n07wF3CdK21Q==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 53c2051f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 1 Dec 2020 11:37:09 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id x2so1509008ybt.11;
        Tue, 01 Dec 2020 03:42:49 -0800 (PST)
X-Gm-Message-State: AOAM5312v8ydbNPwQV4HUaL3AVw54+FvQqd1YAqMFCmKXcaaTs0T+wV2
        DngWfMD2dJDiVcmM1CpsdDHIFtvV+rngdMN2xUY=
X-Google-Smtp-Source: ABdhPJyr+E+bKuyTFZDfe3PGxpw6xMPOHc4Tc723dfsW1RLX19X2fkfRJVJaSe0NxLaZlZ7vwWKbLLKy8Qe1h0mUjkg=
X-Received: by 2002:a25:bb81:: with SMTP id y1mr2761021ybg.456.1606822967704;
 Tue, 01 Dec 2020 03:42:47 -0800 (PST)
MIME-Version: 1.0
References: <20201130151231.GA24862@lst.de> <CAHmME9p4vFGWh7+CKF4f3dw5r+ru5PVG0-vP77JowX8sPhin1g@mail.gmail.com>
 <20201130165339.GE5364@mit.edu>
In-Reply-To: <20201130165339.GE5364@mit.edu>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 1 Dec 2020 12:42:36 +0100
X-Gmail-Original-Message-ID: <CAHmME9pksS8ec17RAwCNJimt4B0xZgd3qYHUPnaT4Bj4CF7n0A@mail.gmail.com>
Message-ID: <CAHmME9pksS8ec17RAwCNJimt4B0xZgd3qYHUPnaT4Bj4CF7n0A@mail.gmail.com>
Subject: Re: drivers/char/random.c needs a (new) maintainer
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     duwe@lst.de, Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        Willy Tarreau <w@1wt.eu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        And y Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Petr Tesarik <ptesarik@suse.cz>, simo@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 30, 2020 at 5:56 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
> patches this cycle.  One thing that would help me is if folks
> (especially Jason, if you would) could start with a detailed review of
> Nicolai's patches.

Sure, I'll take a look.
