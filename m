Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0E3C04AA5
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Aug 2022 22:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiHXWxM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Aug 2022 18:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHXWxL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2022 18:53:11 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FD13E74B
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2022 15:53:10 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id r10so15331133oie.1
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2022 15:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=BYUw2X0viByhVZ/+dJN6TRVhaDQVcxTsg6s3mNZcPzI=;
        b=Lm01p74xrqBcxKJsjDjmcucfAHutDbuK+nPJXyCnINMFTyOQwJ8XySPJW8aGyWepjK
         ARHLH/cyCEvzbqYs0FjFYKy4ebX+ajtVXTKy2dbvSUe2W2rFvUMWwFUq9RCYcUHf8RP6
         AH+lrrUu7zDQ20WoBr5pKKStComzIX9PB5UPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=BYUw2X0viByhVZ/+dJN6TRVhaDQVcxTsg6s3mNZcPzI=;
        b=YhDszqXeYqTZQMox71QIpkTIMtZTQFdv8Boqcat6Df3A9AX9BA6nboy5jkKaC7mGgW
         diqNvD8yxy+8qWvndo6TE6zHI6muvxbtYHQaMhaFKqRfh1gG5VRHLCs30VRfB+qtOCGH
         8syaUo5xyV/4y6PR9Jm/kqJhJwovLu1bZ8Eq9SjdaEgbwR9Zn/oCAtN8hxPzWqWZwwt8
         QnheIHTL6OWrrnf5Fpu2w29RUkvFFezCnlY3IoQTi1UAlfTD3OW5qOLiGZjMbUUlcsOA
         s+VCGYT2FGc+NELhWvaMAuaOkG4PKB3AbuI2QeF+QIbrYINEPbmMjlSM3NgjXphnNcwU
         JQ8w==
X-Gm-Message-State: ACgBeo1JqfgDM1ppjOqUROzQCbmBAA64dIPEXFSDDPpHmkS2Lfk2mHuR
        KJT5jx2jRoPWK2drCN3DRAnlGNMs1xLDDA==
X-Google-Smtp-Source: AA6agR561um4Te0GbTPqpRvFFTO5mNMn4QRc1rhB2hhT8TOuolgkmK5vFXMhTuBEHAydQYmstXNRhQ==
X-Received: by 2002:aca:1c1a:0:b0:343:7dc2:7442 with SMTP id c26-20020aca1c1a000000b003437dc27442mr3959743oic.143.1661381590025;
        Wed, 24 Aug 2022 15:53:10 -0700 (PDT)
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com. [209.85.210.45])
        by smtp.gmail.com with ESMTPSA id a18-20020aca1a12000000b00342d2d79a98sm4333202oia.42.2022.08.24.15.53.08
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 15:53:08 -0700 (PDT)
Received: by mail-ot1-f45.google.com with SMTP id d18-20020a9d72d2000000b0063934f06268so6003759otk.0
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2022 15:53:08 -0700 (PDT)
X-Received: by 2002:a05:6830:58:b0:637:1974:140a with SMTP id
 d24-20020a056830005800b006371974140amr364549otp.362.1661381588181; Wed, 24
 Aug 2022 15:53:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20220112211258.21115-8-chang.seok.bae@intel.com> <CAE=gft4P2iGJDiYJccZFR1VnNomQB7Uo522r2gvrfNY9oKz5jg@mail.gmail.com>
 <763bddd2-2fc3-a857-0dff-a5ae4ae1f298@intel.com>
In-Reply-To: <763bddd2-2fc3-a857-0dff-a5ae4ae1f298@intel.com>
From:   Evan Green <evgreen@chromium.org>
Date:   Wed, 24 Aug 2022 15:52:32 -0700
X-Gmail-Original-Message-ID: <CAE=gft5VajfoAT6hVxiCzAMYiDV+pHRbC-F7s4+qK94qa0og5w@mail.gmail.com>
Message-ID: <CAE=gft5VajfoAT6hVxiCzAMYiDV+pHRbC-F7s4+qK94qa0og5w@mail.gmail.com>
Subject: Re: [PATCH v5 07/12] x86/cpu/keylocker: Load an internal wrapping key
 at boot-time
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        herbert@gondor.apana.org.au, Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, x86@kernel.org,
        luto@kernel.org, Thomas Gleixner <tglx@linutronix.de>, bp@suse.de,
        dave.hansen@linux.intel.com, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        charishma1.gairuboyina@intel.com, kumar.n.dwarakanath@intel.com,
        ravi.v.shankar@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 24, 2022 at 3:21 PM Chang S. Bae <chang.seok.bae@intel.com> wrote:
>
> On 8/23/2022 8:49 AM, Evan Green wrote:
> > On Wed, Jan 12, 2022 at 1:21 PM Chang S. Bae <chang.seok.bae@intel.com> wrote:
> >>
> <snip>
> >> +
> >> +static void __init load_keylocker(void)
> >
> > I am late to this party by 6 months, but:
> > load_keylocker() cannot be __init, as it gets called during SMP core onlining.
>
> Yeah, it looks like the case with this patch only.
>
> But the next patch [1] limits the call during boot time only:
>
>         if (c == &boot_cpu_data) {
>                 ...
>                 load_keylocker();
>                 ...
>         } else {
>                 ...
>                 if (!kl_setup.initialized) {
>                         load_keylocker();
>                 } else if (valid_kl) {
>                         rc = copy_keylocker();
>                         ...
>                 }
>         }
>
> kl_setup.initialized is set by native_smp_cpus_done() ->
> destroy_keylocker_data() when CPUs are booted. Then load_keylocker() is
> not called because the root key (aka IWKey) is no longer available in
> memory.
>
> Now this 'valid_kl' flag should be always on unless the root key backup
> is corrupted. Then copy_keylocker() loads the root key from the backup
> in the platform state.
>
> So I think the onlining CPU won't call it.
>
> Maybe this bit can be much clarified in a separate (new) patch, instead
> of being part of another like [1].

Whatever we ended up landing in the ChromeOS tree (which I think was
v4 of this series) actively hit this bug in hibernation, which is how
I found it. I couldn't get a full backtrace because the backtracing
code tripped over itself as well for some reason. If the next patch in
this series is different from what we landed in ChromeOS, then maybe
your description is correct, but I haven't dug in to understand the
delta.

-Evan
