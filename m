Return-Path: <SRS0=wb3S=BO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E792C433DF
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 12:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 335AC21744
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 12:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596545757;
	bh=EF4RlOtgvcxjYIJRsn7Hy5UR9CqnOuZ56+H7OfqBQFs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=zQnhsY0wLcUWwzME+zF0svz8qDwZs/Y/bMrqmLqG9rGkZvG5FjTZepmUxlpMtDqGS
	 O8gU6uqeBgkdAqWOr3cxZmjItluvrCwBt9IrxrXv0sDkOn5jrEoCuyjgh7TYBClpev
	 g1kKYTC+5ei8KbS6L/RjoH2U3jpqTqkCNUB0Xr6E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgHDMz4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Aug 2020 08:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:32872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbgHDMz4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Aug 2020 08:55:56 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A00332075A
        for <linux-crypto@vger.kernel.org>; Tue,  4 Aug 2020 12:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596545755;
        bh=EF4RlOtgvcxjYIJRsn7Hy5UR9CqnOuZ56+H7OfqBQFs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=K1hrneUXyroXB9FT17cl4URSjZb0sNb1zfDwXjQcL61+oM5CkbA7GdvnsPZ9ZT7ic
         0CrD6LmQ4WKw4HWx3borhHgJC3hAnENqMgEtH0muik6QXF7Math6LGeqZsDtNCphgX
         nKBRVu8nmUEskKrGFI42SqXIz0iNdfhVkANuWTus=
Received: by mail-ot1-f43.google.com with SMTP id x24so6340922otp.3
        for <linux-crypto@vger.kernel.org>; Tue, 04 Aug 2020 05:55:55 -0700 (PDT)
X-Gm-Message-State: AOAM531ywHyQEM0MqCbc/j/o7KIbhQapQ0vr7Xv0k9kty1iFO8gxZy2u
        FUqmiHL7poBazeVMW8OLtVEAY3qxg8FBvlfTfsU=
X-Google-Smtp-Source: ABdhPJyY4Lqso/XcGqkBbwblVp9qK8ZIEtLsqtgwMaGetQajUCPc6xHVzmMRs8+gE925RmFkZE2bGk74s0bV7+bZ4pU=
X-Received: by 2002:a9d:6251:: with SMTP id i17mr7667844otk.90.1596545754967;
 Tue, 04 Aug 2020 05:55:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200802090616.1328-1-ardb@kernel.org> <25776a56-4c6a-3976-f4bc-fa53ba4a1550@candelatech.com>
In-Reply-To: <25776a56-4c6a-3976-f4bc-fa53ba4a1550@candelatech.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 4 Aug 2020 14:55:42 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFAbip567hFaFtoqdevrSEpqFOGQ1+ejL98XrDOaTeggA@mail.gmail.com>
Message-ID: <CAMj1kXFAbip567hFaFtoqdevrSEpqFOGQ1+ejL98XrDOaTeggA@mail.gmail.com>
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

On Mon, 3 Aug 2020 at 21:11, Ben Greear <greearb@candelatech.com> wrote:
>
> Hello,
>
> This helps a bit...now download sw-crypt performance is about 150Mbps,
> but still not as good as with my patch on 5.4 kernel, and fpu is still
> high in perf top:
>
>     13.89%  libc-2.29.so   [.] __memset_sse2_unaligned_erms
>       6.62%  [kernel]       [k] kernel_fpu_begin
>       4.14%  [kernel]       [k] _aesni_enc1
>       2.06%  [kernel]       [k] __crypto_xor
>       1.95%  [kernel]       [k] copy_user_generic_string
>       1.93%  libjvm.so      [.] SpinPause
>       1.01%  [kernel]       [k] aesni_encrypt
>       0.98%  [kernel]       [k] crypto_ctr_crypt
>       0.93%  [kernel]       [k] udp_sendmsg
>       0.78%  [kernel]       [k] crypto_inc
>       0.74%  [kernel]       [k] __ip_append_data.isra.53
>       0.65%  [kernel]       [k] aesni_cbc_enc
>       0.64%  [kernel]       [k] __dev_queue_xmit
>       0.62%  [kernel]       [k] ipt_do_table
>       0.62%  [kernel]       [k] igb_xmit_frame_ring
>       0.59%  [kernel]       [k] ip_route_output_key_hash_rcu
>       0.57%  [kernel]       [k] memcpy
>       0.57%  libjvm.so      [.] InstanceKlass::oop_follow_contents
>       0.56%  [kernel]       [k] irq_fpu_usable
>       0.56%  [kernel]       [k] mac_do_update
>
> If you'd like help setting up a test rig and have an ath10k pcie NIC or ath9k pcie NIC,
> then I can help.  Possibly hwsim would also be a good test case, but I have not tried
> that.
>

I don't think this is likely to be reproducible on other
micro-architectures, so setting up a test rig is unlikely to help.

I'll send out a v2 which implements a ahash instead of a shash (and
implements some other tweaks) so that kernel_fpu_begin() is only
called twice for each packet on the cbcmac path.

Do you have any numbers for the old kernel without your patch? This
pathological FPU preserve/restore behavior could be caused be the
optimizations, or by other changes that landed in the meantime, so I
would like to know if kernel_fpu_begin() is as prominent in those
traces as well.
