Return-Path: <SRS0=wb3S=BO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D17C433DF
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 13:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0995208A9
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 13:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596546555;
	bh=QKbp7RH98E87h/4h1D0uSAouTXnrkFrUVUGdvNpFV3M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=O/NZmVAlj/HQVJiKQ08TuoNQOROUQmbV0u+QSEteT2uDxuJfO3jZewCZFYCLBrgAD
	 1qbQ97LLfSI1YufDgJgIirFZJlY0IBK2wwXkDwUBg3suG9R7erFXo3DUCyaSDH0lV3
	 eAFpophaFs2J3MT5yWCEnC0bxpIDXdNlT8JAwgZ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgHDNJO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Aug 2020 09:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgHDNJN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Aug 2020 09:09:13 -0400
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 560F0208A9
        for <linux-crypto@vger.kernel.org>; Tue,  4 Aug 2020 13:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596546553;
        bh=QKbp7RH98E87h/4h1D0uSAouTXnrkFrUVUGdvNpFV3M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VtAwJbDD5YXlsx/jtw28JFQoOUn6bUmXeGYL/MCNrTfNzC3Qit7SzPr4e7NO0KqWz
         1ZzhIdxcx7mUUvSB6zT15izTr784gq4PKOyvPVGV2ORxDn9lqEyg2ZLCpkKvHM0muk
         SNWbyao+h5BhaWWKX7aB3LWWXdSC4rCMUpHkQZY8=
Received: by mail-oi1-f172.google.com with SMTP id o21so15529626oie.12
        for <linux-crypto@vger.kernel.org>; Tue, 04 Aug 2020 06:09:13 -0700 (PDT)
X-Gm-Message-State: AOAM5320JZb8Abw8Z0outD/30MOebZxMo38kZPieIg7xejTm27MR9zWT
        +/IvySECJ3ptD+93+4kxH4clV6Md5+lvcKtHrNA=
X-Google-Smtp-Source: ABdhPJyO3J+M37QsAiAE+HKNKxZ56kzs4NglT6E/tZB8jQBKJ/KzP7RlvkNhwNIVozNTZ5fK5QqryPAOE3YNF8kaOPo=
X-Received: by 2002:aca:afd0:: with SMTP id y199mr3103556oie.47.1596546552663;
 Tue, 04 Aug 2020 06:09:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200802090616.1328-1-ardb@kernel.org> <25776a56-4c6a-3976-f4bc-fa53ba4a1550@candelatech.com>
 <CAMj1kXFAbip567hFaFtoqdevrSEpqFOGQ1+ejL98XrDOaTeggA@mail.gmail.com> <9c137bbf-2892-df7a-e6fa-8cce417ecd45@candelatech.com>
In-Reply-To: <9c137bbf-2892-df7a-e6fa-8cce417ecd45@candelatech.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 4 Aug 2020 15:08:59 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFnfYKj1JE4NLsxXtaeKuAOKyBYDbayLr-mHDUYqnV1bA@mail.gmail.com>
Message-ID: <CAMj1kXFnfYKj1JE4NLsxXtaeKuAOKyBYDbayLr-mHDUYqnV1bA@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86/aesni - implement accelerated CBCMAC, CMAC
 and XCBC shashes
To:     Ben Greear <greearb@candelatech.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 4 Aug 2020 at 15:01, Ben Greear <greearb@candelatech.com> wrote:
>
> On 8/4/20 5:55 AM, Ard Biesheuvel wrote:
> > On Mon, 3 Aug 2020 at 21:11, Ben Greear <greearb@candelatech.com> wrote:
> >>
> >> Hello,
> >>
> >> This helps a bit...now download sw-crypt performance is about 150Mbps,
> >> but still not as good as with my patch on 5.4 kernel, and fpu is still
> >> high in perf top:
> >>
> >>      13.89%  libc-2.29.so   [.] __memset_sse2_unaligned_erms
> >>        6.62%  [kernel]       [k] kernel_fpu_begin
> >>        4.14%  [kernel]       [k] _aesni_enc1
> >>        2.06%  [kernel]       [k] __crypto_xor
> >>        1.95%  [kernel]       [k] copy_user_generic_string
> >>        1.93%  libjvm.so      [.] SpinPause
> >>        1.01%  [kernel]       [k] aesni_encrypt
> >>        0.98%  [kernel]       [k] crypto_ctr_crypt
> >>        0.93%  [kernel]       [k] udp_sendmsg
> >>        0.78%  [kernel]       [k] crypto_inc
> >>        0.74%  [kernel]       [k] __ip_append_data.isra.53
> >>        0.65%  [kernel]       [k] aesni_cbc_enc
> >>        0.64%  [kernel]       [k] __dev_queue_xmit
> >>        0.62%  [kernel]       [k] ipt_do_table
> >>        0.62%  [kernel]       [k] igb_xmit_frame_ring
> >>        0.59%  [kernel]       [k] ip_route_output_key_hash_rcu
> >>        0.57%  [kernel]       [k] memcpy
> >>        0.57%  libjvm.so      [.] InstanceKlass::oop_follow_contents
> >>        0.56%  [kernel]       [k] irq_fpu_usable
> >>        0.56%  [kernel]       [k] mac_do_update
> >>
> >> If you'd like help setting up a test rig and have an ath10k pcie NIC or ath9k pcie NIC,
> >> then I can help.  Possibly hwsim would also be a good test case, but I have not tried
> >> that.
> >>
> >
> > I don't think this is likely to be reproducible on other
> > micro-architectures, so setting up a test rig is unlikely to help.
> >
> > I'll send out a v2 which implements a ahash instead of a shash (and
> > implements some other tweaks) so that kernel_fpu_begin() is only
> > called twice for each packet on the cbcmac path.
> >
> > Do you have any numbers for the old kernel without your patch? This
> > pathological FPU preserve/restore behavior could be caused be the
> > optimizations, or by other changes that landed in the meantime, so I
> > would like to know if kernel_fpu_begin() is as prominent in those
> > traces as well.
> >
>
> This same patch makes i7 mobile processors able to handle 1Gbps+ software
> decrypt rates, where without the patch, the rate was badly constrained and CPU
> load was much higher, so it is definitely noticeable on other processors too.

OK

> The weak processor on the current test rig is convenient because the problem
> is so noticeable even at slower wifi speeds.
>
> We can do some tests on 5.4 with our patch reverted.
>

The issue with your CCM patch is that it keeps the FPU enabled for the
entire input, which also means that preemption is disabled, which
makes the -rt people grumpy. (Of course, it also uses APIs that no
longer exists, but that should be easy to fix)

Do you happen to have any ballpark figures for the packet sizes and
the time spent doing encryption?
