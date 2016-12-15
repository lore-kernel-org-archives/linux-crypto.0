From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] crypto: skcipher - fix crash in virtual walk
Date: Thu, 15 Dec 2016 14:27:49 +0100
Message-ID: <88f1e201-ab8e-d2b3-fde1-8c5dcb6bbb83@gmail.com>
References: <1481636042-27347-1-git-send-email-ard.biesheuvel@linaro.org>
 <20161214103905.GB11960@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33645 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757997AbcLON1w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Dec 2016 08:27:52 -0500
Received: by mail-wm0-f67.google.com with SMTP id u144so6461333wmu.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Dec 2016 05:27:51 -0800 (PST)
In-Reply-To: <20161214103905.GB11960@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/14/2016 11:39 AM, Herbert Xu wrote:
> On Tue, Dec 13, 2016 at 01:34:02PM +0000, Ard Biesheuvel wrote:
>> The new skcipher walk API may crash in the following way. (Interestingly,
>> the tcrypt boot time tests seem unaffected, while an explicit test using
>> the module triggers it)
>>
>>   Unable to handle kernel NULL pointer dereference at virtual address 00000000
>>   ...
>>   [<ffff000008431d84>] __memcpy+0x84/0x180
>>   [<ffff0000083ec0d0>] skcipher_walk_done+0x328/0x340
>>   [<ffff0000080c5c04>] ctr_encrypt+0x84/0x100
>>   [<ffff000008406d60>] simd_skcipher_encrypt+0x88/0x98
>>   [<ffff0000083fa05c>] crypto_rfc3686_crypt+0x8c/0x98
>>   [<ffff0000009b0900>] test_skcipher_speed+0x518/0x820 [tcrypt]
>>   [<ffff0000009b31c0>] do_test+0x1408/0x3b70 [tcrypt]
>>   [<ffff0000009bd050>] tcrypt_mod_init+0x50/0x1000 [tcrypt]
>>   [<ffff0000080838f4>] do_one_initcall+0x44/0x138
>>   [<ffff0000081aee60>] do_init_module+0x68/0x1e0
>>   [<ffff0000081524d0>] load_module+0x1fd0/0x2458
>>   [<ffff000008152c38>] SyS_finit_module+0xe0/0xf0
>>   [<ffff0000080836f0>] el0_svc_naked+0x24/0x28
>>
>> This is due to the fact that skcipher_done_slow() may be entered with
>> walk->buffer unset. Since skcipher_walk_done() already deals with the
>> case where walk->buffer == walk->page, it appears to be the intention
>> that walk->buffer point to walk->page after skcipher_next_slow(), so
>> ensure that is the case.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Patch applied.  Thanks.

Fixed problem here as well...
Tested-by: Milan Broz <gmazyland@gmail.com>

Without patch, just running cryptsetup tests (make check) on 32bit machine
I get kernel crash in LRW mode.

For me, the problem can be triggered from the userspace crypto API (no root needed!)
  dd if=/dev/zero of=test bs=1M count=32
  echo blah | /sbin/cryptsetup luksFormat test -c aes-lrw-null -q --use-urandom

and I get

Dec 15 13:00:50 kernel: NET: Registered protocol family 38
Dec 15 13:00:50 kernel: BUG: unable to handle kernel NULL pointer dereference at   (null)
Dec 15 13:00:50 kernel: IP: memcpy+0xf/0x20
Dec 15 13:00:50 kernel: *pde = 00000000 
Dec 15 13:00:50 kernel: 
Dec 15 13:00:50 kernel: Oops: 0000 [#1] PREEMPT SMP
Dec 15 13:00:50 kernel: Modules linked in: lrw algif_skcipher af_alg loop rpcsec_gss_krb5 dm_mod crc32_pclmul crc32c_intel pcbc aesni_intel aes_i586 crypto_simd cryptd ata_piix
Dec 15 13:00:50 kernel: CPU: 0 PID: 1667 Comm: cryptsetup Tainted: G        W       4.9.0+ #122
Dec 15 13:00:50 kernel: Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/02/2015
Dec 15 13:00:50 kernel: task: f5cc66c0 task.stack: f45e6000
Dec 15 13:00:50 kernel: EIP: memcpy+0xf/0x20
Dec 15 13:00:50 kernel: EFLAGS: 00010202 CPU: 0
Dec 15 13:00:50 kernel: EAX: fffbaffc EBX: 00000004 ECX: 00000001 EDX: 00000000
Dec 15 13:00:50 kernel: ESI: 00000000 EDI: fffbaffc EBP: f45e7d48 ESP: f45e7d3c
Dec 15 13:00:50 kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Dec 15 13:00:50 kernel: CR0: 80050033 CR2: 00000000 CR3: 35eba000 CR4: 001406d0
Dec 15 13:00:50 kernel: Call Trace:
Dec 15 13:00:50 kernel:  scatterwalk_copychunks+0x75/0xd0
Dec 15 13:00:50 kernel:  skcipher_walk_done+0x2b1/0x300
Dec 15 13:00:50 kernel:  pre_crypt+0x230/0x350 [lrw]
Dec 15 13:00:50 kernel:  ? __kmalloc+0x222/0x270
Dec 15 13:00:50 kernel:  do_decrypt+0x27/0xb0 [lrw]
Dec 15 13:00:50 kernel:  decrypt+0x19/0x20 [lrw]
Dec 15 13:00:50 kernel:  skcipher_recvmsg+0x2d3/0x6c0 [algif_skcipher]
Dec 15 13:00:50 kernel:  ? trace_hardirqs_on_caller+0xd6/0x200
Dec 15 13:00:50 kernel:  ? release_sock+0x63/0x90
Dec 15 13:00:50 kernel:  ? trace_hardirqs_on+0xb/0x10
Dec 15 13:00:50 kernel:  ? __local_bh_enable_ip+0x5c/0xd0
Dec 15 13:00:50 kernel:  ? _raw_spin_unlock_bh+0x2a/0x30
Dec 15 13:00:50 kernel:  skcipher_recvmsg_nokey+0x26/0x38 [algif_skcipher]
Dec 15 13:00:50 kernel:  sock_read_iter+0x77/0xb0
Dec 15 13:00:50 kernel:  __vfs_read+0xaa/0x120
Dec 15 13:00:50 kernel:  vfs_read+0x72/0x100
Dec 15 13:00:50 kernel:  SyS_read+0x3d/0xa0
Dec 15 13:00:50 kernel:  do_int80_syscall_32+0x40/0x110
Dec 15 13:00:50 kernel:  entry_INT80_32+0x2f/0x2f
Dec 15 13:00:50 kernel: EIP: 0xb77cc9f2
Dec 15 13:00:50 kernel: EFLAGS: 00000246 CPU: 0
Dec 15 13:00:50 kernel: EAX: ffffffda EBX: 00000006 ECX: bff01f4c EDX: 00000200
Dec 15 13:00:50 kernel: ESI: 00000030 EDI: fffffffb EBP: bff01e78 ESP: bff01dd4
Dec 15 13:00:50 kernel:  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
Dec 15 13:00:50 kernel: Code: fc ff ff 8b 43 58 2b 43 50 88 43 4e 5b 5d c3 90 90 90 90 90 90 90 90 90 90 90 90 90 55 89 e5 57 89 c7 56 89 d6 53 89 cb c1 e9 02 <f3> a5 89 d9 83 e1 03 74 02 f3 a4 5b 5e 5f 5d c3 90 55 89 e5 57
Dec 15 13:00:50 kernel: EIP: memcpy+0xf/0x20 SS:ESP: 0068:f45e7d3c
Dec 15 13:00:50 kernel: CR2: 0000000000000000
Dec 15 13:00:50 kernel: ---[ end trace 6d5fbbd95de42602 ]---
Dec 15 13:00:50 kernel: note: cryptsetup[1667] exited with preempt_count 1
