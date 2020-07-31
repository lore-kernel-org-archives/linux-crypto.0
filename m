Return-Path: <SRS0=j/eP=BK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C240C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 10:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5384720829
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 10:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596189619;
	bh=hXzNczAjyFP1CEgqIPzen4cq0bDAX1ZSen4yedbghFk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Xhl3FeEx+y+aLHlVmN9BgqVcHfhprmHc3NGUGZTFq1WIBteU2+pm44ytNg5i14BZU
	 NmsUF5Ke1+frrxzR2BgsSYHqZZOQ3aVrgIzSn2JoL23vcYZgFRcUJNo8GajAmIGWwT
	 gugxjkl7nqCmrA+sJze8LR6h2IlmlKnrgqZJDKlw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732249AbgGaKAS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Jul 2020 06:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732227AbgGaKAS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Jul 2020 06:00:18 -0400
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C6BC20656
        for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2020 10:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596189617;
        bh=hXzNczAjyFP1CEgqIPzen4cq0bDAX1ZSen4yedbghFk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=a9kHepHY5/MxY4ULlJoR5rltjwguGy+wgIjOip6kjnABStjA9X46TcvQ3GIESdj19
         AS+zHi70tM4BMgNak0qrId4DSt1nhhej/IhxVUZ9VKgI4ve85qCY3cKJS+ny2IlUQa
         2jiYPelvrk5YP97d26WLbXq6cfQUSI2d+x2wfglQ=
Received: by mail-ot1-f53.google.com with SMTP id z18so1755689otk.6
        for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2020 03:00:17 -0700 (PDT)
X-Gm-Message-State: AOAM5321neaLN+inZf//ISj3M0OXS3zOXHOehAoUTsBLVPrjsAMP3Uaj
        T/Fj3PS/1W4lmuw3SUihaGIKuqbGPi8QImh6pwk=
X-Google-Smtp-Source: ABdhPJwwzm7X5WXAkNMtYKdc+ER04X0GOqQZeT9GjoZ2WCEYx2aX7+GpwxaARevbZYkq9NYwA+N1+d9ukGtMxEmt664=
X-Received: by 2002:a9d:3b23:: with SMTP id z32mr2409025otb.77.1596189616570;
 Fri, 31 Jul 2020 03:00:16 -0700 (PDT)
MIME-Version: 1.0
References: <2a55b661-512b-9479-9fff-0f2e2a581765@candelatech.com>
 <CAMj1kXFwPPDfm1hvW+LgnfuPO-wfguTZ0NcLyeyesGeBcuDKGQ@mail.gmail.com>
 <04d8e7e3-700b-44b2-e8f2-5126abf21a62@candelatech.com> <CAMj1kXFK4xkieEpjW+ekYf9am6Ob15aGsnmWJMfn=LD_4oCuXg@mail.gmail.com>
 <9e6927a6-8f70-009a-ad76-4f11a396e43a@candelatech.com> <CAMj1kXEDBSfuTxi6CCPGdpdC6h+F18gutz3h2xJaGtdN8kS40Q@mail.gmail.com>
 <d71f2800-baef-b97f-62cb-0fbe798c35ed@candelatech.com>
In-Reply-To: <d71f2800-baef-b97f-62cb-0fbe798c35ed@candelatech.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 31 Jul 2020 13:00:04 +0300
X-Gmail-Original-Message-ID: <CAMj1kXFt5XCzJ7xGz2=pg-2dA0-zs94XTFsWoTNpSENuhdC51w@mail.gmail.com>
Message-ID: <CAMj1kXFt5XCzJ7xGz2=pg-2dA0-zs94XTFsWoTNpSENuhdC51w@mail.gmail.com>
Subject: Re: Help getting aesni crypto patch upstream
To:     Ben Greear <greearb@candelatech.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 31 Jul 2020 at 01:57, Ben Greear <greearb@candelatech.com> wrote:
>
> On 7/29/20 1:06 PM, Ard Biesheuvel wrote:
> > On Wed, 29 Jul 2020 at 22:29, Ben Greear <greearb@candelatech.com> wrote:
> >>
> >> On 7/29/20 12:09 PM, Ard Biesheuvel wrote:
> >>> On Wed, 29 Jul 2020 at 15:27, Ben Greear <greearb@candelatech.com> wrote:
> >>>>
> >>>> On 7/28/20 11:06 PM, Ard Biesheuvel wrote:
> >>>>> On Wed, 29 Jul 2020 at 01:03, Ben Greear <greearb@candelatech.com> wrote:
> >>>>>>
> >>>>>> Hello,
> >>>>>>
> >>>>>> As part of my wifi test tool, I need to do decrypt AES on the CPU, and the only way this
> >>>>>> performs well is to use aesni.  I've been using a patch for years that does this, but
> >>>>>> recently somewhere between 5.4 and 5.7, the API I've been using has been removed.
> >>>>>>
> >>>>>> Would anyone be interested in getting this support upstream?  I'd be happy to pay for
> >>>>>> the effort.
> >>>>>>
> >>>>>> Here is the patch in question:
> >>>>>>
> >>>>>> https://github.com/greearb/linux-ct-5.7/blob/master/wip/0001-crypto-aesni-add-ccm-aes-algorithm-implementation.patch
> >>>>>>
> >>>>>> Please keep me in CC, I'm not subscribed to this list.
> >>>>>>
> >>>>>
> >>>>> Hi Ben,
> >>>>>
> >>>>> Recently, the x86 FPU handling was improved to remove the overhead of
> >>>>> preserving/restoring of the register state, so the issue that this
> >>>>> patch fixes may no longer exist. Did you try?
> >>>>>
> >>>>> In any case, according to the commit log on that patch, the problem is
> >>>>> in the MAC generation, so it might be better to add a cbcmac(aes)
> >>>>> implementation only, and not duplicate all the CCM boilerplate.
> >>>>>
> >>>>
> >>>> Hello,
> >>>>
> >>>> I don't know all of the details, and do not understand the crypto subsystem,
> >>>> but I am pretty sure that I need at least some of this patch.
> >>>>
> >>>
> >>> Whether this is true is what I am trying to get clarified.
> >>>
> >>> Your patch works around a performance bottleneck related to the use of
> >>> AES-NI instructions in the kernel, which has been addressed recently.
> >>> If the issue still exists, we can attempt to devise a fix for it,
> >>> which may or may not be based on this patch.
> >>
> >> Ok, I can do the testing.  Do you expect 5.7-stable has all the needed
> >> performance improvements?
> >>
> >
> > Yes.
>
> It does not, as far as we can tell.
>
> We did a download test on an apu2 (small embedded AMD CPU, but with
> aesni support).  A WiFi station is in software-decrypt mode (ath10k-ct driver/firmware,
> but ath9k would be valid to reproduce the issue as well.)
>
> On our 5.4 kernel with the aesni patch applied, we get
> about 220Mbps wpa2 download throughput.  With open, we get about 260Mbps
> download throughput.
>
> On 5.7, without any aesni patch, we see about 116Mbps download wpa2 throughput,
> and about 265Mbps open download throughput.
>

Thanks for the excellent data. Apparently, FPU preserve/restore is
still prohibitively expensive on these cores.

I'll have a stab at implementing cbcmac(aesni) early next week: as i
pointed out before, we don't need all the ccm boilerplate if the ctr
and mac processing are still done in separate passes anyway.


>
> perf-top on 5.4 during download test with our aesni patch looks like this:
>
>     11.73%  libc-2.29.so   [.] __memset_sse2_unaligned_erms
>       4.79%  [kernel]       [k] _aesni_enc1
>       1.71%  [kernel]       [k] ___bpf_prog_run
>       1.66%  [kernel]       [k] memcpy
>       1.25%  [kernel]       [k] copy_user_generic_string
>       1.18%  libjvm.so      [.] InstanceKlass::oop_follow_contents
>       1.07%  [kernel]       [k] _aesni_enc4
>       0.98%  [kernel]       [k] csum_partial_copy_generic
>       0.96%  libjvm.so      [.] SpinPause
>       0.84%  [kernel]       [k] get_data_to_compute
>       0.81%  libjvm.so      [.] ParMarkBitMap::mark_obj
>       0.64%  [kernel]       [k] udp_sendmsg
>       0.62%  [kernel]       [k] __ip_append_data.isra.53
>       0.58%  [kernel]       [k] ipt_do_table
>       0.56%  [kernel]       [k] _aesni_inc
>       0.56%  [kernel]       [k] fib_table_lookup
>       0.55%  [kernel]       [k] __rcu_read_unlock
>       0.52%  libc-2.29.so   [.] __GI___strcmp_ssse3
>       0.50%  [kernel]       [k] igb_xmit_frame_ring
>
>
> on 5.7, we see this:
>
>     11.36%  libc-2.29.so   [.] __memset_sse2_unaligned_erms
>       9.03%  [kernel]       [k] kernel_fpu_begin
>       4.75%  libjvm.so      [.] SpinPause
>       2.89%  [kernel]       [k] __crypto_xor
>       2.35%  [kernel]       [k] _aesni_enc1
>       1.94%  [kernel]       [k] copy_user_generic_string
>       1.29%  [kernel]       [k] aesni_encrypt
>       0.85%  [kernel]       [k] udp_sendmsg
>       0.85%  [kernel]       [k] crypto_cipher_encrypt_one
>       0.71%  [kernel]       [k] crypto_cbcmac_digest_update
>       0.69%  [kernel]       [k] __ip_append_data.isra.53
>       0.69%  [kernel]       [k] memcpy
>       0.68%  [kernel]       [k] crypto_ctr_crypt
>       0.61%  [kernel]       [k] irq_fpu_usable
>       0.58%  [kernel]       [k] ipt_do_table
>       0.55%  [kernel]       [k] __dev_queue_xmit
>       0.54%  [kernel]       [k] crypto_inc
>       0.49%  libc-2.29.so   [.] __GI___strcmp_ssse3
>       0.45%  libjvm.so      [.] InstanceKlass::oop_follow_contents
>       0.45%  [kernel]       [k] ip_route_output_key_hash_rcu
>
>
>
> So, I think there is still some good improvement possible, likely with something like
> the aesni patch I showed, but re-worked to function in 5.7+ kernels.
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
