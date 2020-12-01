Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A491DC64E7A
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 06:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47AE220857
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 06:33:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="KleEj1Fl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgLAGdj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 01:33:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgLAGdj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 01:33:39 -0500
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AA8820857
        for <linux-crypto@vger.kernel.org>; Tue,  1 Dec 2020 06:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606804378;
        bh=WdEJMU9jhUlyte7Ihqk7bKUBHAhWuc4AeFSkrg1ryQ0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KleEj1FlgLh5SUZ6zafBrFB/jc89eDhNjUyOCTyek/LI6TU+0aVgqwwOLrehK05eC
         wD3AIfIIeZr1F9mwdNW4EB0eTX9PhQokJNaDRu1jYw+lFMawoVrIE+lJmb4dIqTV8K
         IQstyjuny5g8j0uN6WLUDjdPzBbUXZ4fcoa/iW70=
Received: by mail-ot1-f50.google.com with SMTP id f16so650827otl.11
        for <linux-crypto@vger.kernel.org>; Mon, 30 Nov 2020 22:32:58 -0800 (PST)
X-Gm-Message-State: AOAM531SgMttjcl+GfGzufkTvgVHDuSN+2qbgYj9gL8H4JpitU/8lslw
        3dOOSnwxiCjq7Z6lCljZQYsR3DTkKUufogjNL5w=
X-Google-Smtp-Source: ABdhPJwVEq/ImuPOszqN/TgLxcOQ90C0SMwPtgXHot6ke0Z8PNqI/e7IgDp0fS3wVelTTdp1U9PmrB3P93rxz+FygRY=
X-Received: by 2002:a05:6830:3099:: with SMTP id f25mr876717ots.77.1606804377750;
 Mon, 30 Nov 2020 22:32:57 -0800 (PST)
MIME-Version: 1.0
References: <20201129182035.7015-1-ardb@kernel.org> <4e850713-af8b-f81f-bf3d-f4ee5185d99f@candelatech.com>
In-Reply-To: <4e850713-af8b-f81f-bf3d-f4ee5185d99f@candelatech.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 1 Dec 2020 07:32:46 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGt_sjyBH1veEEEizHjUMWEkuTUicxmhbLjQXnJ9LXGpw@mail.gmail.com>
Message-ID: <CAMj1kXGt_sjyBH1veEEEizHjUMWEkuTUicxmhbLjQXnJ9LXGpw@mail.gmail.com>
Subject: Re: [PATCH] crypto: aesni - add ccm(aes) algorithm implementation
To:     Ben Greear <greearb@candelatech.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve deRosier <derosier@cal-sierra.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 30 Nov 2020 at 23:48, Ben Greear <greearb@candelatech.com> wrote:
>
> On 11/29/20 10:20 AM, Ard Biesheuvel wrote:
> > From: Steve deRosier <ardb@kernel.org>
> >
> > Add ccm(aes) implementation from linux-wireless mailing list (see
> > http://permalink.gmane.org/gmane.linux.kernel.wireless.general/126679).
> >
> > This eliminates FPU context store/restore overhead existing in more
> > general ccm_base(ctr(aes-aesni),aes-aesni) case in MAC calculation.
> >
> > Suggested-by: Ben Greear <greearb@candelatech.com>
> > Co-developed-by: Steve deRosier <derosier@cal-sierra.com>
> > Signed-off-by: Steve deRosier <derosier@cal-sierra.com>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> > Ben,
> >
> > This is almost a rewrite of the original patch, switching to the new
> > skcipher API, using the existing SIMD helper, and drop numerous unrelated
> > changes. The basic approach is almost identical, though, so I expect this
> > to perform on par or perhaps slightly faster than the original.
> >
> > Could you please confirm with some numbers?
>
> I tried this on my apu2 platform, here is perf top during a TCP download using
> rx-sw-crypt (ie, the aesni cpu decrypt path):
>
>    18.77%  [kernel]                            [k] acpi_idle_enter
>    14.68%  [kernel]                            [k] kernel_fpu_begin
>     4.45%  [kernel]                            [k] __crypto_xor
>     3.46%  [kernel]                            [k] _aesni_enc1
>
> Total throughput is 127Mbps or so.  This is with your patch applied to 5.8.0+
> kernel (it applied clean with 'git am')
>
> Is there a good way to verify at runtime that I've properly applied your patch?
>
> On my 5.4 kernel with the old version of the patch installed, I see 253Mbps throughput,
> and perf-top shows:
>
>    13.33%  [kernel]                            [k] acpi_idle_do_entry
>     9.21%  [kernel]                            [k] _aesni_enc1
>     4.49%  [unknown]                           [.] 0x00007fbc3f00adb6
>     4.34%  [unknown]                           [.] 0x00007fbc3f00adba
>     3.85%  [kernel]                            [k] memcpy
>
>
> So, new patch is not working that well for me...
>

That is odd. The net number of invocations of kernel_fpu_begin()
should be the same, so I cannot explain why they suddenly take more
time. I am starting to think that this is a different issue
altogether.

One thing that you could try is dropping the '.cra_alignmask' line as
we don't actually need it, but I am skeptical that this is the cause
of this.
