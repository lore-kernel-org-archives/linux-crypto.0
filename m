Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3E9C64E7B
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 15:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EDC120725
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Nov 2020 15:16:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LWkyQL71"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgK3PQT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Nov 2020 10:16:19 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:44377 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbgK3PQS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Nov 2020 10:16:18 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b6b41515;
        Mon, 30 Nov 2020 15:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=12rqlfUcyjBIdcubsxjR5/8B2DM=; b=LWkyQL
        71ddl9uiltR3GyHix9UWTmVg3n4Z+00ld7+Tp7oP3lX5xbA42v3grgXp3faAjjRr
        8uXiHkVaEIJdKznZWWhbMZNP3ZkHh7Ogt0ZwmoXqQfUATlN/Plw+0gxggeOKvrRZ
        qspiaw+l9for/syhxo/AV1v8u5OtyD6T/ATaOvz2hqrE20g1uYI9Gkn08OxpGxEd
        GjL8WT4Zxn/JUUTpATuPW2S8yn8mvLhupmSKMmbDnAyUnWTUsFRD9l2PwVTr4A5G
        hznBVCrJbeu68pIHp3WKMnUWAAeJSg2bgeLC6Ico6u61DxKM14FRXJTRCG2jE++v
        s07V4wknlK5/NEGg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2cfb59f8 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 30 Nov 2020 15:10:02 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id x2so7721597ybt.11;
        Mon, 30 Nov 2020 07:15:35 -0800 (PST)
X-Gm-Message-State: AOAM532TZAisVnWqFjMfLOhY8MunyT9gBW/GtDHvhf27u9AAl5oU6nsL
        VpgfI/cl+EM431pjTXlsiiVDB/Zq/CS6e7egRkE=
X-Google-Smtp-Source: ABdhPJxUFrp6jsMaYkripYAMMseOy64kR9cSfDa+EijAqesWgnJClXB7aCy/cSIrZNUfbNxcaaoMyXPZZYN+5ULAKHU=
X-Received: by 2002:a25:bb81:: with SMTP id y1mr27562036ybg.456.1606749334107;
 Mon, 30 Nov 2020 07:15:34 -0800 (PST)
MIME-Version: 1.0
References: <20201130151231.GA24862@lst.de>
In-Reply-To: <20201130151231.GA24862@lst.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 30 Nov 2020 16:15:23 +0100
X-Gmail-Original-Message-ID: <CAHmME9p4vFGWh7+CKF4f3dw5r+ru5PVG0-vP77JowX8sPhin1g@mail.gmail.com>
Message-ID: <CAHmME9p4vFGWh7+CKF4f3dw5r+ru5PVG0-vP77JowX8sPhin1g@mail.gmail.com>
Subject: Re: drivers/char/random.c needs a (new) maintainer
To:     duwe@lst.de
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
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

I am willing to maintain random.c and have intentions to have a
formally verified RNG. I've mentioned this to Ted before.

But I think Ted's reluctance to not accept the recent patches sent to
this list is mostly justified, and I have no desire to see us rush
into replacing random.c with something suboptimal or FIPSy.
