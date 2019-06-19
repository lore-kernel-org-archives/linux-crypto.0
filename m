Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C94C31E49
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 07:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C59F720B1F
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 07:12:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xp7egYyp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbfFSHMC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 03:12:02 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42301 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbfFSHMC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 03:12:02 -0400
Received: by mail-io1-f66.google.com with SMTP id u19so35754406ior.9
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jun 2019 00:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=khnbFY+vxU45Z/bVGnwlJLSWDQ4jzZbITR9wBBaC8uk=;
        b=Xp7egYypJ1kbQ0AAgct+yvD6EOg/K/SONXCkZdeT0qL1eWbBsNAofOl/7i0DCGviof
         2NJqUzzGD2xPK0qhm8I2OXc8O6iDLaYvCwE+FiDxy+xzw/0xTWO7/qGHNKmXkta3pw/l
         7me/CE1mqqsHXZzAOQFybNVrM6skXz+lsfaSNx/S43pkpUgrOD60HpEs2p86n5n/RmVk
         KYej0t8PQOpqyA26wqHzPMu9RHLHrz5pMj6Qx8e7wmasYPMA3ZygIDc/z68aXblHver6
         vZ7vsVa6yoduq/lyDOd3Pv5eQaahdU4pN9IG/LznbOgE+rcD/MW/jF9GxRq5LyQ0mN2c
         SlCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=khnbFY+vxU45Z/bVGnwlJLSWDQ4jzZbITR9wBBaC8uk=;
        b=TiG2wwMOSxJofa/xd9JQwjbOK86CpMh1IKV3CNM5Gz0GHzsEYpnhvsjbvlRIJ5E6Mg
         vNm5rNCFts1FqmQy63DJUjLhYt/q3Sl//sVKJSg10ksGp96cNkUSYUZtgOyyPs/nRV2G
         zRDS32+/6tTemo47W+lTw/GFklOauiAQpzd50AAaW/UpUaacmDEwnIvBqOwBNJ9/x7o8
         T9g5vERvHR8pWWg+cErr2ok1uZaU5yrVCgsuvaIKd4jFGnfb2o9Gm/lo7TXI8xZlqKWl
         qxCNykPpdtDq7hBLq0KPnxkayb0dWigRWHDDOZxO1Z8BtBeYjvGYlhRBe1LTahJFOD3e
         OFCA==
X-Gm-Message-State: APjAAAXpjjDLdtBj63CSRpUVcWoRdXQix06DsNuA/ROOf2sS54XTt7Jm
        Y4QNR1gOTUJAOd6KoN3D376VlNtEdjQ838iI7ryS1Q==
X-Google-Smtp-Source: APXvYqxZzF1yYZ3cuIGoQ4Pm325A2HZQlSEb+LTS4vpHA+DWAPGcc5lg3zik3JwMTlCrnHtxiAOTkIBn6EJAOw1sAXk=
X-Received: by 2002:a5d:8794:: with SMTP id f20mr22173241ion.128.1560928321432;
 Wed, 19 Jun 2019 00:12:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190618212749.8995-1-ard.biesheuvel@linaro.org> <099346ee-af6e-a560-079d-3fb68fb4eeba@gmail.com>
In-Reply-To: <099346ee-af6e-a560-079d-3fb68fb4eeba@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 19 Jun 2019 09:11:50 +0200
Message-ID: <CAKv+Gu9MTGSwZgaHyxJKwfiBQzqgNhTs5ue+TC1Ehte-+VBXqg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] crypto: switch to crypto API for ESSIV generation
To:     Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 19 Jun 2019 at 08:56, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 18/06/2019 23:27, Ard Biesheuvel wrote:
> > This series creates an ESSIV template that produces a skcipher or AEAD
> > transform based on a tuple of the form '<skcipher>,<cipher>,<shash>'
> > (or '<aead>,<cipher>,<shash>' for the AEAD case). It exposes the
> > encapsulated sync or async skcipher/aead by passing through all operations,
> > while using the cipher/shash pair to transform the input IV into an ESSIV
> > output IV.
> >
> > This matches what both users of ESSIV in the kernel do, and so it is proposed
> > as a replacement for those, in patches #2 and #4.
> >
> > This code has been tested using the fscrypt test suggested by Eric
> > (generic/549), as well as the mode-test script suggested by Milan for
> > the dm-crypt case. I also tested the aead case in a virtual machine,
> > but it definitely needs some wider testing from the dm-crypt experts.
>
> Well, I just run "make check" on cyptsetup upstream (32bit VM, Linus' tree
> with this patcheset applied), and get this on the first api test...
>

Ugh. Thanks for trying. I will have a look today.


> Just try
> cryptsetup open --type plain -c aes-cbc-essiv:sha256 /dev/sdd test
>
> kernel: alg: No test for essiv(cbc(aes),aes,sha256) (essiv(cbc-aes-aesni,aes-aesni,sha256-generic))
> kernel: BUG: unable to handle page fault for address: 00c14578
> kernel: #PF: supervisor read access in kernel mode
> kernel: #PF: error_code(0x0000) - not-present page
> kernel: *pde = 00000000
> kernel: Oops: 0000 [#1] PREEMPT SMP
> kernel: CPU: 2 PID: 15611 Comm: kworker/u17:2 Not tainted 5.2.0-rc5+ #519
> kernel: Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
> kernel: Workqueue: kcryptd/253:2 kcryptd_crypt [dm_crypt]
> kernel: EIP: essiv_skcipher_decrypt+0x3/0x20
> kernel: Code: 5f 5d c3 90 90 90 90 55 8b 48 0c 89 e5 8d 41 10 ff 51 18 5d c3 66 90 55 8b 40 0c 89 e5 ff 50 08 5d c3 8d 74 26 00 90 8b 50 58 <f6> 02 01 75 10 55 83 c0 38 89 e5 ff 52 f0 5d c3 8d 74 26 00 90 b8
> kernel: EAX: ee87fc08 EBX: ee87fd40 ECX: ee87fdc4 EDX: 00c14578
> kernel: ESI: ee87fb78 EDI: f0a70800 EBP: ef7a9ed8 ESP: ef7a9e3c
> kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010246
> kernel: CR0: 80050033 CR2: 00c14578 CR3: 01b87000 CR4: 00140690
> kernel: Call Trace:
> kernel:  ? crypt_convert+0x864/0xe50 [dm_crypt]
> kernel:  ? static_obj+0x32/0x50
> kernel:  ? lockdep_init_map+0x34/0x1b0
> kernel:  ? __init_waitqueue_head+0x29/0x40
> kernel:  kcryptd_crypt+0xca/0x3b0 [dm_crypt]
> kernel:  ? process_one_work+0x1a6/0x5a0
> kernel:  process_one_work+0x214/0x5a0
> kernel:  worker_thread+0x134/0x3e0
> kernel:  ? process_one_work+0x5a0/0x5a0
> kernel:  kthread+0xd4/0x100
> kernel:  ? process_one_work+0x5a0/0x5a0
> kernel:  ? kthread_park+0x90/0x90
> kernel:  ret_from_fork+0x19/0x24
> kernel: Modules linked in: dm_zero dm_integrity async_xor xor async_tx dm_verity reed_solomon dm_bufio dm_crypt loop dm_mod pktcdvd crc32_pclmul crc32c_intel aesni_intel aes_i586 crypto_simd cryptd ata_piix
> kernel: CR2: 0000000000c14578
> kernel: ---[ end trace 8a651b067b7b6a10 ]---
> kernel: EIP: essiv_skcipher_decrypt+0x3/0x20
> kernel: Code: 5f 5d c3 90 90 90 90 55 8b 48 0c 89 e5 8d 41 10 ff 51 18 5d c3 66 90 55 8b 40 0c 89 e5 ff 50 08 5d c3 8d 74 26 00 90 8b 50 58 <f6> 02 01 75 10 55 83 c0 38 89 e5 ff 52 f0 5d c3 8d 74 26 00 90 b8
> kernel: EAX: ee87fc08 EBX: ee87fd40 ECX: ee87fdc4 EDX: 00c14578
> kernel: ESI: ee87fb78 EDI: f0a70800 EBP: ef7a9ed8 ESP: c1b8b45c
> kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010246
> kernel: CR0: 80050033 CR2: 00c14578 CR3: 01b87000 CR4: 00140690
>
> Milan
