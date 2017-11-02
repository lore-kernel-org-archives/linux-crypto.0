From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: invalid opcode: 0000 [#1] SMP [aesni_intel]
Date: Wed, 1 Nov 2017 21:33:04 -0700
Message-ID: <20171102043304.GA560@zzz.localdomain>
References: <CA++DawbkD6nioFR70ph1J26erZAwt74egm-pPDXJEHNt-QDAGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: SviMik <svimik@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:51917 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750704AbdKBEdI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Nov 2017 00:33:08 -0400
Received: by mail-pg0-f42.google.com with SMTP id p9so4000375pgc.8
        for <linux-crypto@vger.kernel.org>; Wed, 01 Nov 2017 21:33:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CA++DawbkD6nioFR70ph1J26erZAwt74egm-pPDXJEHNt-QDAGw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 23, 2017 at 07:01:32PM +0300, SviMik wrote:
> Hi!
> 
> Got the following kernel panic:
> 
> invalid opcode: 0000 [#1] SMP
> CPU: 0 PID: 1449 Comm: openvpn Not tainted 4.8.13-1.el6.elrepo.x86_64 #1
> ----cut----
> Call Trace:
> <IRQ>
> [<ffffffff810be15e>] ? enqueue_entity+0x45e/0x6f0
> [<ffffffffa0104f25>] ? aesni_gcm_enc_avx+0x95/0xd0 [aesni_intel]
> [<ffffffffa0105417>] helper_rfc4106_encrypt+0x167/0x2f0 [aesni_intel]
> [<ffffffffa0104bfb>] rfc4106_encrypt+0x5b/0x90 [aesni_intel]
> ----cut----
> 
> The detailed bug report with full oops dump can be found here:
> https://bugzilla.kernel.org/show_bug.cgi?id=197363
> 
> Could not trigger this bug intentionally, but it happened three times
> already (all three dumps are available).

Well, the program counter was at the 'vmovdqu' instruction, which is the first
AVX instruction in the function.  Is it possible you're running the kernel on a
broken hypervisor that claims AVX instructions are supported but really they
aren't?  Note that AVX is different from AES-NI; the code being executed has
both types of instructions.

(And as a side note, 4.8 is not being maintained as a long term support kernel,
so you really should switch to a different version.)

Eric
