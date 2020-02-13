Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C2AC352A3
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 23:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 293162467D
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 23:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581637380;
	bh=QvXr0ccIUZIRsqUcy6mdX4RvItZ/HQGPAVqIR5RAVyo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=nc1/mWlVmU/h//wSQpM0PqNaVghqtjTnPLNNAfjxKkx4xQRCMaosKHoO75xxLxn10
	 k1+Jmg1IGXJfvQjG/VeRUBQeMglouECrd6pjOxmyxkR135SbFfIcTuL4ipJJXKBq0L
	 KG3YW9srt6Lzd8qws9Zf694+UhMG9KJsgb2SCNmI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbgBMXm7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 18:42:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727594AbgBMXm7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 18:42:59 -0500
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89F6D2467D;
        Thu, 13 Feb 2020 23:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581637378;
        bh=QvXr0ccIUZIRsqUcy6mdX4RvItZ/HQGPAVqIR5RAVyo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cPo6gRm2riJCg2de4KFKjGUPyih5I99+ID98XQlsTTxOWt9KQ5Pfqdzsd5F8lPb46
         PWQzSbOz7vIG+xvGz7PfCbmDfooxlwTbJpl1r0D3JFRAOkqSLvkxfK8/0KLnmSKU0Y
         1H66ieYG9DmRRXq2PvYmmF1St6fRqy/EY5GTTf3U=
Received: by mail-lj1-f182.google.com with SMTP id v17so8650836ljg.4;
        Thu, 13 Feb 2020 15:42:58 -0800 (PST)
X-Gm-Message-State: APjAAAUb1CfRx2QXhgS6f3LnmqO1jgROFnwsemZxbhjIQIyd3pwJn9VF
        m+rbhCifUv5Zkw30EnyNy1zzXRKHtCfuRH3rsRU=
X-Google-Smtp-Source: APXvYqyMTY5BiLP/4jYWIAjsVYrB8h/h7Ek++s0e6pxXO6PqFXN3+xu4BLWRYI1/YeOOm0rQ6bFf5+MVwGHlLSORLHc=
X-Received: by 2002:a2e:a553:: with SMTP id e19mr168246ljn.64.1581637376641;
 Thu, 13 Feb 2020 15:42:56 -0800 (PST)
MIME-Version: 1.0
References: <20200213141823.2174236-1-mplaneta@os.inf.tu-dresden.de>
 <20200213153645.GA11313@redhat.com> <82715589-8b59-5cfd-a32f-1e57871327fe@os.inf.tu-dresden.de>
In-Reply-To: <82715589-8b59-5cfd-a32f-1e57871327fe@os.inf.tu-dresden.de>
From:   Song Liu <song@kernel.org>
Date:   Thu, 13 Feb 2020 15:42:45 -0800
X-Gmail-Original-Message-ID: <CAPhsuW70_HtmxA0qmUVLk4L+Ls5t=0j0k5D4fbT4fNY59L2UpQ@mail.gmail.com>
Message-ID: <CAPhsuW70_HtmxA0qmUVLk4L+Ls5t=0j0k5D4fbT4fNY59L2UpQ@mail.gmail.com>
Subject: Re: Remove WQ_CPU_INTENSIVE flag from unbound wq's
To:     Maksym Planeta <mplaneta@os.inf.tu-dresden.de>
Cc:     Mike Snitzer <snitzer@redhat.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-crypto@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 13, 2020 at 8:19 AM Maksym Planeta
<mplaneta@os.inf.tu-dresden.de> wrote:
>
>
>
> On 13/02/2020 16:36, Mike Snitzer wrote:
> > On Thu, Feb 13 2020 at  9:18am -0500,
> > Maksym Planeta <mplaneta@os.inf.tu-dresden.de> wrote:
> >
> >> The documentation [1] says that WQ_CPU_INTENSIVE is "meaningless" for
> >> unbound wq. I remove this flag from places where unbound queue is
> >> allocated. This is supposed to improve code readability.
> >>
> >> 1. https://www.kernel.org/doc/html/latest/core-api/workqueue.html#flags
> >>
> >> Signed-off-by: Maksym Planeta <mplaneta@os.inf.tu-dresden.de>
> >
> > What the Documentation says aside, have you cross referenced with the
> > code?  And/or have you done benchmarks to verify no changes?
> >
>
> It seems so from the code. Although, I'm not 100% confident. I did not
> run benchmarks, instead I relied that on the assumption that
> documentation is correct.

From the code, WQ_CPU_INTENSIVE is only used to set
WORKER_CPU_INTENSIVE, and WORKER_CPU_INTENSIVE is only used
as part of WORKER_NOT_RUNNING, which includes WORKER_UNBOUND.
So, I agree that with current code, WQ_CPU_INTENSIVE with WQ_UNBOUND
is same as WQ_UNBOUND alone.

However, I don't think it is necessary to make the changes. They don't really
improve readability of the code.

Thanks,
Song
