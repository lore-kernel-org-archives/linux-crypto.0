Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C36DC433E6
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 21:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6E0222D01
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Jan 2021 21:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbhAKVCL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 16:02:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730366AbhAKVCF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 16:02:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12C4822D03
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 21:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610398884;
        bh=fVCIvTEQ29wolBbr5oAdaU2ZoymhJ6ncNJDq2iQmPmM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fHNP8niQUyAyWBFD5uoFeun3aoB3QDjv3t7n9+TzetzWTqZcToA/FWX5gPSnzLxIt
         oADBHguQhFGrJzvgzcWIDzERrIVwPSX2LxlpeDsB4HC7hmKf4IcHgEJOeBipybrPgf
         8VZxyJE2t7H9BTpzny18c7OoUfLrrcu3OaWH15ESd/3vNW9LyoQIgACqkzjn0rJ+bC
         1M+HBL56YvZoeoaXh+YOXTNsNzdMeRpdUaE+PwwKg73bc/2qZh5aHVHNpEWNJLdVij
         PEitj4uMo2HhEzUe1/DxTSXeFYo1OoxtAX0dREyaF8QXLYhZYvPUFDDX4Cu4nCtTfM
         Q9Bo6pZI4kD5Q==
Received: by mail-oo1-f41.google.com with SMTP id o5so69764oop.12
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 13:01:24 -0800 (PST)
X-Gm-Message-State: AOAM530YqqWe64ZvQUgh4vmzYlSBWeNMXGyYuzgpACKuAC+x8auPFNsg
        CRJhSL6z2B4PtpLn9+VT+GqvVBEsbJq/K0EjVzs=
X-Google-Smtp-Source: ABdhPJyzzJDBQb5inQT0gqdbudcA08X1BK2RgIlr6jfrR/F4xvAQAYJ8A8Q6EH9qMWwy/pURzSxENcBAFoODQoWcAr0=
X-Received: by 2002:a05:6820:41:: with SMTP id v1mr724606oob.41.1610398883230;
 Mon, 11 Jan 2021 13:01:23 -0800 (PST)
MIME-Version: 1.0
References: <20210111165237.18178-1-ardb@kernel.org> <CAMj1kXEBPjmCGPPme=rXqadLQeNdqzeyr7uw1WsUoHUqQv1_LQ@mail.gmail.com>
 <CAMj1kXHLBDUGZbc7dw0bd5K4ecPLmnDYMwrPA7yGzA0VNaJWgw@mail.gmail.com> <X/y7kOIJSKQs1FCv@hirez.programming.kicks-ass.net>
In-Reply-To: <X/y7kOIJSKQs1FCv@hirez.programming.kicks-ass.net>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 11 Jan 2021 22:01:12 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE3z1xw8VnS8WgQ-Du8QLC1t9fbT1h0D9X6+9FtM9Y_dQ@mail.gmail.com>
Message-ID: <CAMj1kXE3z1xw8VnS8WgQ-Du8QLC1t9fbT1h0D9X6+9FtM9Y_dQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] crypto: switch to static calls for CRC-T10DIF
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 11 Jan 2021 at 21:56, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Mon, Jan 11, 2021 at 07:36:20PM +0100, Ard Biesheuvel wrote:
> > On Mon, 11 Jan 2021 at 18:27, Ard Biesheuvel <ardb@kernel.org> wrote:
> > > On Mon, 11 Jan 2021 at 17:52, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> > > > Special request to Peter to take a look at patch #2, and in particular,
> > > > whether synchronize_rcu_tasks() is sufficient to ensure that a module
> > > > providing the target of a static call can be unloaded safely.
> > >
> > > It seems I may have managed to confuse myself slightly here: without
> > > an upper bound on the size of the input of the crc_t10dif() routine, I
> > > suppose we can never assume that all its callers have finished.
> > >
> >
> > Replying to self again - apologies.
> >
> > I think this is actually correct after all: synchronize_rcu_tasks()
> > guarantees that all tasks have passed through a 'safe state', i.e.,
> > voluntary schedule(), return to userland, etc, which guarantees that
> > no task could be executing the old static call target after
> > synchronize_rcu_tasks() returns.
>
> Right, I think it should work.
>
> My initial question was why you'd want to support the unreg at all.
> AFAICT these implementations are tiny, why bother having them as a
> module, or if you insist having them as a module, why allowing removal?

Yeah, good question.

Having the accelerated version as a module makes sense imo: it will
only be loaded if it is supported on the system, and it can be
blacklisted by the user if it does not want it for any reason. Unload
is just for completeness/symmetry, but it is unlikely to be crucial to
anyone in practice.

In any case, thanks for confirming - if this looks sane to you then we
may be able to use this pattern in other places as well.
