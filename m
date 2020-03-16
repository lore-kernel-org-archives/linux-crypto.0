Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1B7C0044D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 08:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BDA720719
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 08:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgCPI2y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 04:28:54 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51187 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728302AbgCPI2y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 04:28:54 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jDl72-0002gq-LP; Mon, 16 Mar 2020 09:28:40 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 1A0BE100F5A; Mon, 16 Mar 2020 09:28:40 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>, peterz@infradead.org,
        herbert@gondor.apana.org.au, viro@zeniv.linux.org.uk,
        mingo@redhat.com, dvhart@infradead.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: cryptsetup benchmark stuck
In-Reply-To: <20200315145214.GA9576@Red>
References: <20200315145214.GA9576@Red>
Date:   Mon, 16 Mar 2020 09:28:40 +0100
Message-ID: <877dzkem9z.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Corentin,

Corentin Labbe <clabbe.montjoie@gmail.com> writes:
> On next-20200313, running cryptsetup benchmark is stuck.
> I have bisected this problem twice and the result is the same:
>
> git bisect bad 8019ad13ef7f64be44d4f892af9c840179009254
> # first bad commit: [8019ad13ef7f64be44d4f892af9c840179009254] futex: Fix inode life-time issue
>
> Since the two bisect lead to the same commit, I think it should be
> right one even if I dont find anything related to my problem.

I'm as puzzled as you.

> But reverting this patch is impossible, so I cannot test to try
> without it.

You need to revert two:

8d67743653dc ("futex: Unbreak futex hashing")
8019ad13ef7f ("futex: Fix inode life-time issue")

Thanks,

        tglx
