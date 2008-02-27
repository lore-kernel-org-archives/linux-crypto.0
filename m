From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: Via Padlock Bug with LRW/XTS
Date: Wed, 27 Feb 2008 09:30:05 +0100
Message-ID: <20080227083005.GA13163@Chamillionaire.breakpoint.cc>
References: <1203850864-16681-1-git-send-email-sebastian@breakpoint.cc> <47C15AEC.5040705@the2masters.de> <20080224125117.GA17076@Chamillionaire.breakpoint.cc> <47C1CE67.70804@the2masters.de>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Stefan Hellermann <stefan@the2masters.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60074 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756254AbYB0IaK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Feb 2008 03:30:10 -0500
Content-Disposition: inline
In-Reply-To: <47C1CE67.70804@the2masters.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Stefan Hellermann | 2008-02-24 21:07:03 [+0100]:

>general protection fault: 0000 [#1]
>Modules linked in: padlock_aes xts gf128mul cifs [last unloaded: padlock_aes]
>
>Pid: 988, comm: kcryptd Not tainted (2.6.25-rc2-via #121)
>EIP: 0060:[<f881d801>] EFLAGS: 00010206 CPU: 0
>EIP is at aes_encrypt+0x31/0x60 [padlock_aes]
>EAX: f7468af0 EBX: f7616860 ECX: 00000001 EDX: f7616830
>ESI: f7468500 EDI: f762de88 EBP: f762de88 ESP: f762de64
> DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
>Process kcryptd (pid: 988, ti=f762c000 task=f746eff0 task.ti=f762c000)
>Stack: f75e3770 fffb6000 fffb7e00 00000200 f88280a3 f75e3770 f762debc f762df04
>       00000010 00000000 00000000 00000000 00000000 f7616400 f881d7d0 f75e3770
>       f75c0600 f7468500 c048ab44 f8828272 f881d7d0 f881d7d0 c2b4bf20 fffb7e00
>Call Trace:
> [<f88280a3>] crypt+0x83/0x110 [xts]
> [<f881d7d0>] aes_encrypt+0x0/0x60 [padlock_aes]
> [<f8828272>] encrypt+0x42/0x50 [xts]
> [<f881d7d0>] aes_encrypt+0x0/0x60 [padlock_aes]
> [<f881d7d0>] aes_encrypt+0x0/0x60 [padlock_aes]
> [<c021b05b>] async_encrypt+0x3b/0x50
> [<c02fcce9>] crypt_convert+0x1b9/0x270
> [<c02fcf4d>] kcryptd_crypt+0x1ad/0x220
> [<c02fcda0>] kcryptd_crypt+0x0/0x220
> [<c012ae6b>] run_workqueue+0xab/0x140
> [<c012b5e0>] worker_thread+0x0/0x90
> [<c012b639>] worker_thread+0x59/0x90
> [<c012e100>] autoremove_wake_function+0x0/0x40
> [<c012b5e0>] worker_thread+0x0/0x90
> [<c012dd22>] kthread+0x42/0x70
> [<c012dce0>] kthread+0x0/0x70
> [<c010437b>] kernel_thread_helper+0x7/0x1c
> =======================
>Code: 0c 89 d7 8d 50 3f 89 74 24 08 83 e2 f0 89 ce 89 5c 24 04 9c 9d 89 c8 35 f0 0f 00 00
>a9 ff 0f 00 00 8d 5a 30 74 19 b9 01 00 00 00 <f3> 0f a7 c8 8b 5c 24 04 8b 74 24 08 8b 7c
>24 0c 83 c4 10 c3 89
>EIP: [<f881d801>] aes_encrypt+0x31/0x60 [padlock_aes] SS:ESP 0068:f762de64
>---[ end trace 526de21aa54fb137 ]---

This is exactly the xcrypt instruction. I can reproduce what I thing is
the same bug on my geode board. For some reason the stack gets
overwritten. I will dig later a little more.

Sebastian
