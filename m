Return-Path: <SRS0=YoIG=C6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C16C43463
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96B9D20EDD
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Sep 2020 08:16:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ufGZFwY9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgIUIQw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:16:52 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:49385 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbgIUIQv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Sep 2020 04:16:51 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 04:16:51 EDT
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 3ab608da;
        Mon, 21 Sep 2020 07:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=M7qUyrgto49SY5FdKJ+FDGlmwMY=; b=ufGZFw
        Y9h76vON2NtnQlIOKplEgvQfnUr9rJkcF2cOScNPehh3HKdGFCyLXwnnTRujWuO5
        APYi5z27C+c6uV7JyTXrRqxhvHhgK5EKaYLtRbp0BfFvjO+fY4XvBTMkMSiyH7CE
        mLvYNK4kpD+vnXjaOQPi9slXgC8lDpgFzcK5Acf16TGyjl+2ouvLdOJpf5edHDM9
        nn8vHKOfN8G0hYts7jUibLa3jAO8CttY3oJNj1Vj/QldtJ5bQjMjuYrY/53fL5aY
        dVGk0rw2j/HJXBA9IZDX9YCdRmwrnIqBuYUZAm82eehICqLS53ByZQufgoMepsku
        8J9XnFZpAegCdmyA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 785c4337 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 21 Sep 2020 07:39:33 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id r25so14488405ioj.0;
        Mon, 21 Sep 2020 01:10:05 -0700 (PDT)
X-Gm-Message-State: AOAM530zNZFBzMNG5chKTwV3S13VnFBIOVfQZDvJ3QViAKPEDVhgdOaR
        /x8zMZzTeE+9ehnGk7MsS5Cju1ZPVjf4gh6jEyw=
X-Google-Smtp-Source: ABdhPJxUz1yQhdUMAHosbhusKxPuUp9PmiphmCjGgJCMjgU8V6igiRwtQlw90xW0OpLKINg1nsrXK2RNYo9iBZzR/Zk=
X-Received: by 2002:a5e:d606:: with SMTP id w6mr7439030iom.67.1600675804390;
 Mon, 21 Sep 2020 01:10:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200921075857.4424-1-nstange@suse.de>
In-Reply-To: <20200921075857.4424-1-nstange@suse.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 21 Sep 2020 10:09:53 +0200
X-Gmail-Original-Message-ID: <CAHmME9rMXORFXtwDAc8yxj+h9gytJj6DpvCxA-JMAAgyOP+5Yw@mail.gmail.com>
Message-ID: <CAHmME9rMXORFXtwDAc8yxj+h9gytJj6DpvCxA-JMAAgyOP+5Yw@mail.gmail.com>
Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST
 SP800-90B compliance
To:     Nicolai Stange <nstange@suse.de>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
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
        Roman Drahtmueller <draht@schaltsekun.de>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>, Petr Tesarik <ptesarik@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I haven't looked into the details of this patchset yet, but your
description here indicates to me that this is motivated by FIPS
certification desires, which...worries me. I would like to rewrite the
RNG at some point, and I've started to work on a bunch of designs for
this (and proving them correct, too), but going about this via FIPS
certification or trying to implement some NIST specs is most certainly
the wrong way to go about this, will lock us into subpar crypto for
years, and is basically a waste of time.
