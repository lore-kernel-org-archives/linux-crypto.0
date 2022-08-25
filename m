Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE2BC32774
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Aug 2022 15:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242695AbiHYPdC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Aug 2022 11:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242897AbiHYPcq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2022 11:32:46 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E516BB018
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 08:32:41 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id v125so23739401oie.0
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 08:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=BF1zNrYrm57PzI0kOZgixgNUjiOGt1ff9+aE0AWJYQI=;
        b=m/c5m0vZL75a8GxeNZKr5wrUmCNGKu3QQ5GbsAgpPhbnlEwfOI2ru540yng44ZVv4p
         KPep2s9ENlyNLFHqLmcUXI7DvzTuQaNrQYVS5rudbDBXjM8vPjiC1cs3tuCp6UtMRcpb
         KOKi3hR57OAefdXoqMBc6em4pbfHrdqdIzMzk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=BF1zNrYrm57PzI0kOZgixgNUjiOGt1ff9+aE0AWJYQI=;
        b=3SHtqqiyNLs6P6/U4PoLTpZ8CtDdkJUr4H8g6q78mJ7xcO/guD0Isbegrxlqxm1GXJ
         /IPOkExi/nwrd1Cb0S/Ix0YqpvDam5OqGWW5CdKzTmoCAFVJX2MXLBPZf7Y4pY3XXaA9
         h5Xj9LMadFd+e6vOu2oxWd7kTVpSMJvksfLoRFj3kQ3ckFoSdis6quEj93Y+yDLSclac
         zMKp1Knr1s3owFUkkEd7KNDsH3PQHejphOE+y2qCMvgMFlKq6l7/XvId2N2PhUAvCjYJ
         MLpH2pJ0I4grWE0aH37W/6SfHRBLk4xe8r9jGZV26qmAefOoZfBHnBLqOMKCHHFuV9+Z
         9ZWg==
X-Gm-Message-State: ACgBeo0z5PNqnZBAza1+FhlQqMAvIKNNjOt4SfAxK3y2QX2tupC8wFpc
        yJzIxtTwl93Z8y2Df7A0npN+CCVaJCndjg==
X-Google-Smtp-Source: AA6agR5jzJ+ldqWO8TqUPR7NpKqj92HFu6TiQzNoZCqpzd4gpCir4Wu5RvieSoWhelIRJpR2adnMvw==
X-Received: by 2002:a05:6808:23c2:b0:345:84e:1c08 with SMTP id bq2-20020a05680823c200b00345084e1c08mr5889510oib.270.1661441559784;
        Thu, 25 Aug 2022 08:32:39 -0700 (PDT)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com. [209.85.210.54])
        by smtp.gmail.com with ESMTPSA id l13-20020a056870204d00b000f342d078fasm5303845oad.52.2022.08.25.08.32.36
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 08:32:37 -0700 (PDT)
Received: by mail-ot1-f54.google.com with SMTP id br15-20020a056830390f00b0061c9d73b8bdso14136083otb.6
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 08:32:36 -0700 (PDT)
X-Received: by 2002:a05:6830:58:b0:637:1974:140a with SMTP id
 d24-20020a056830005800b006371974140amr1607371otp.362.1661441556115; Thu, 25
 Aug 2022 08:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20220112211258.21115-8-chang.seok.bae@intel.com> <CAE=gft4P2iGJDiYJccZFR1VnNomQB7Uo522r2gvrfNY9oKz5jg@mail.gmail.com>
 <763bddd2-2fc3-a857-0dff-a5ae4ae1f298@intel.com> <CAE=gft5VajfoAT6hVxiCzAMYiDV+pHRbC-F7s4+qK94qa0og5w@mail.gmail.com>
 <6f2dcc0c-99a2-8698-13ae-d5cbea9945b0@intel.com>
In-Reply-To: <6f2dcc0c-99a2-8698-13ae-d5cbea9945b0@intel.com>
From:   Evan Green <evgreen@chromium.org>
Date:   Thu, 25 Aug 2022 08:31:59 -0700
X-Gmail-Original-Message-ID: <CAE=gft6sO85RBpfdXnR=_r=KGmVrx0mnBOHK7XadNk00gDr-WA@mail.gmail.com>
Message-ID: <CAE=gft6sO85RBpfdXnR=_r=KGmVrx0mnBOHK7XadNk00gDr-WA@mail.gmail.com>
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

On Wed, Aug 24, 2022 at 6:06 PM Chang S. Bae <chang.seok.bae@intel.com> wrote:
>
> On 8/24/2022 3:52 PM, Evan Green wrote:
> >
> > Whatever we ended up landing in the ChromeOS tree (which I think was
> > v4 of this series) actively hit this bug in hibernation, which is how
> > I found it. I couldn't get a full backtrace because the backtracing
> > code tripped over itself as well for some reason. If the next patch in
> > this series is different from what we landed in ChromeOS, then maybe
> > your description is correct, but I haven't dug in to understand the
> > delta.
>
> So the change from v4 is simply dropping CBC mode. Marvin who reported
> another issue told me that he pushed the fix to some Chrome repository.
> But I don't know that's the same repo that you mentioned. Are you able
> to locate that tree if possible?

I see. The only ChromeOS tree I'm aware of where keylocker has landed
is our 5.10 tree. This is the change where it landed:
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/3373776/12

>
> Also, it would be nice to have more detail about that hibernation bug.

Here's the log I've got that pointed me down this path:
https://pastebin.com/VvR1EHvE

Relevant bit pasted below:

<6>[43486.263035] Enabling non-boot CPUs ...
<6>[43486.263081] x86: Booting SMP configuration:
<6>[43486.263082] smpboot: Booting Node 0 Processor 1 APIC 0x1
<2>[43486.264010] kernel tried to execute NX-protected page - exploit
attempt? (uid: 0)
<1>[43486.264019] BUG: unable to handle page fault for address: ffffffff94b483a6
<1>[43486.264021] #PF: supervisor instruction fetch in kernel mode
<1>[43486.264023] #PF: error_code(0x0011) - permissions violation
<6>[43486.264025] PGD 391c0e067 P4D 391c0e067 PUD 391c0f063 PMD
10006c063 PTE 8000000392148163
<4>[43486.264031] Oops: 0011 [#1] PREEMPT SMP NOPTI
<4>[43486.264035] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G U
5.10.136-19391-gadfe4d4b8c04 #1
b640352a7a0e5f1522aed724296ad63f90c007df
<4>[43486.264036] Hardware name: Google Primus/Primus, BIOS
Google_Primus.14505.145.0 06/23/2022
<4>[43486.264042] RIP: 0010:load_keylocker+0x0/0x7f
<4>[43486.264044] Code: 02 46 0a 0c 07 08 44 0b 24 00 00 00 10 26 00
00 44 d5 e9 ff dd 00 00 00 00 41 0e 10 86 02 43 0d 06 42 8d 03 49 8c
04 02 61 0a <0c> 07 08 48 0b 00 24 00 00 00 38 26 00 00 fc d5 e9 ff ba
00 00 00
<4>[43486.264046] RSP: 0000:ffffb1c7000afe50 EFLAGS: 00010046
<4>[43486.264048] RAX: ffffffff9483a898 RBX: ffff8d64ef855440 RCX:
0000000000310800
<4>[43486.264049] RDX: 0000000000310800 RSI: 0000000000000000 RDI:
00000000003f0ea0
<4>[43486.264051] RBP: ffffb1c7000afe88 R08: 0000000000000000 R09:
0000000000003000
<4>[43486.264052] R10: 0000000000000500 R11: ffffffff92c6c775 R12:
ffff8d64ef8554c0
<4>[43486.264053] R13: 0000000000000000 R14: 0000000000000082 R15:
ffff8d64ef855460
<4>[43486.264055] FS: 0000000000000000(0000) GS:ffff8d64ef840000(0000)
knlGS:0000000000000000
<4>[43486.264057] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[43486.264058] CR2: ffffffff94b483a6 CR3: 0000000391c0c001 CR4:
00000000003f0ea0
<4>[43486.264063] invalid opcode: 0000 [#2] PREEMPT SMP NOPTI
<4>[43486.264065] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G U
5.10.136-19391-gadfe4d4b8c04 #1
b640352a7a0e5f1522aed724296ad63f90c007df
<4>[43486.264066] Hardware name: Google Primus/Primus, BIOS
Google_Primus.14505.145.0 06/23/2022
<4>[43486.264069] RIP: 0010:__show_regs+0x2ed/0x338
<4>[43486.264071] Code: 81 fc 00 04 00 00 75 44 48 f7 05 ca 83 90 01
10 00 00 00 0f 84 fa fd ff ff 31 d2 48 f7 05 b7 83 90 01 10 00 00 00
74 07 31 c9 <0f> 01 ee 89 c2 48 c7 c7 90 38 29 94 4c 89 f6 48 83 c4 28
5b 41 5c
<4>[43486.264072] RSP: 0000:ffffb1c7000afc90 EFLAGS: 00010046
<4>[43486.264074] RAX: 00000000ffff0ff0 RBX: 0000000000000000 RCX:
0000000000000000
<4>[43486.264075] RDX: 0000000000000000 RSI: 0000000000000004 RDI:
ffffffff94cf27f4
<4>[43486.264076] RBP: ffffb1c7000afce0 R08: 0000000000000000 R09:
00000000ffffdfff
<4>[43486.264078] R10: ffffffff94658600 R11: 3fffffffffffffff R12:
0000000000000400
<4>[43486.264079] R13: ffff8d64ef840000 R14: ffffffff9435d0a9 R15:
00000000ffff0ff0
<4>[43486.264080] FS: 0000000000000000(0000) GS:ffff8d64ef840000(0000)
knlGS:0000000000000000
<4>[43486.264082] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[43486.264083] CR2: ffffffff94b483a6 CR3: 0000000391c0c001 CR4:
00000000003f0ea0
<4>[43486.264085] invalid opcode: 0000 [#3] PREEMPT SMP NOPTI
<4>[43486.264086] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G U
5.10.136-19391-gadfe4d4b8c04 #1
b640352a7a0e5f1522aed724296ad63f90c007df
<4>[43486.264088] Hardware name: Google Primus/Primus, BIOS
Google_Primus.14505.145.0 06/23/2022
<4>[43486.264089] RIP: 0010:__show_regs+0x2ed/0x338

I landed this change, though I'm still working on verifying the issue
goes away with this fix:
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/3851401

I don't have direct access to this machine, but I wonder if a simple
cpu hotplug might also exercise this path.
-Evan

>
> Thanks,
> Chang
>
