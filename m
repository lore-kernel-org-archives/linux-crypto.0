Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AADC0044D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 13:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B869C20663
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 13:53:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OccARGXr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731368AbgCPNxX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 09:53:23 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46743 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731331AbgCPNxW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 09:53:22 -0400
Received: by mail-wr1-f65.google.com with SMTP id w16so4911165wrv.13;
        Mon, 16 Mar 2020 06:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zz+VUSWNCDs2sQPAELxMFVMHL5mAksbtoTViuL2HD+g=;
        b=OccARGXrypOX9pQ0w3HKRvuuWLqJ++L0Dv2Tvn9pEsWij0cX2i3W+HKTs/fF5OC/KW
         9sdXw+ZZqcTzq0eRCgb5RuIJjx6foLgVQTSarHfGTPawCDfVHCG3UPCELr8yrZXOF/Nt
         YzK30be1UuTwUggKivog1qW4bCcOOAr0zP6qjBmFrSmtJcdgvDAjRmdBJfXLmqsyJLZl
         fWFzH3Z6x+9/SwdzHV2aESQr2DUXNNyMEYqzVECq4OSS7BVgpbYt6y/QaVdHMgT55kKL
         4F1arAIUc/zqHPJ6JzrlMZ6XDfII8rMNwhzrhlaE3LdNDmicC7FrmuRTnHKKT4oOl0T2
         6tbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zz+VUSWNCDs2sQPAELxMFVMHL5mAksbtoTViuL2HD+g=;
        b=MoOEuXXw9m/8lJxyFGR5X+tCyR1J/YbBejfjD5uyG91O1WpK14FdoCcNOyfK8xxu9V
         La5/EEydrm8dtom4mHI1aFllCyZKAyAXp5CTF+3meRRzVr3bKGo2ZO4QCGiix0NsordL
         Ea2z5kAuJqUGJIP9e3MPan+CMF1yKj9QlbfbPmRIr+54KUU62YbXh0s5GiRvrKEkeV+7
         EfgsXeSBhtqncJjQX0hwrZalJt1z+DdgtPg92Ujlhta650ex2Fd5/FyFjfgZC49jgcfb
         aMLZJfkKE5NemFU1DC4TbLUxeNVmeHZ/oXABV3URvv6e3fJqFPny/O3KQewJbkCfEum2
         UIQg==
X-Gm-Message-State: ANhLgQ2e8NcOg7QK6cfMm2YWsWYSWAj4Vga5dOe+zz4FeiVc7dtAoDcC
        /fTIg4rGXPU4ASYYidlqp2q0402I
X-Google-Smtp-Source: ADFU+vvwLSvB6JlHnivEFRq8ttan08vIgV77aIBH8Bz7u8qpc5GznHQ1xr/G5WW8OuWzwVqD4NbxHQ==
X-Received: by 2002:adf:8023:: with SMTP id 32mr26014359wrk.189.1584366800438;
        Mon, 16 Mar 2020 06:53:20 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id z6sm24277216wrp.95.2020.03.16.06.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 06:53:19 -0700 (PDT)
Date:   Mon, 16 Mar 2020 14:53:18 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     peterz@infradead.org, herbert@gondor.apana.org.au,
        viro@zeniv.linux.org.uk, mingo@redhat.com, dvhart@infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: cryptsetup benchmark stuck
Message-ID: <20200316135318.GA29789@Red>
References: <20200315145214.GA9576@Red>
 <877dzkem9z.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dzkem9z.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 16, 2020 at 09:28:40AM +0100, Thomas Gleixner wrote:
> Corentin,
> 
> Corentin Labbe <clabbe.montjoie@gmail.com> writes:
> > On next-20200313, running cryptsetup benchmark is stuck.
> > I have bisected this problem twice and the result is the same:
> >
> > git bisect bad 8019ad13ef7f64be44d4f892af9c840179009254
> > # first bad commit: [8019ad13ef7f64be44d4f892af9c840179009254] futex: Fix inode life-time issue
> >
> > Since the two bisect lead to the same commit, I think it should be
> > right one even if I dont find anything related to my problem.
> 
> I'm as puzzled as you.
> 
> > But reverting this patch is impossible, so I cannot test to try
> > without it.
> 
> You need to revert two:
> 
> 8d67743653dc ("futex: Unbreak futex hashing")
> 8019ad13ef7f ("futex: Fix inode life-time issue")
> 

On next-20200313, there are no "futex: Unbreak futex hashing".
And it seems to fix my issue, I have updated to next-20200316 (which have it) and the issue is not present anymore.

Thanks
Regards
