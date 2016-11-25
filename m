From: Stephan Mueller <smueller@chronox.de>
Subject: Re: bug in blkcipher_walk code
Date: Fri, 25 Nov 2016 13:43:41 +0100
Message-ID: <3805767.QuT5G9UC4v@positron.chronox.de>
References: <1833318.YYJALW9cvC@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:50998 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753888AbcKYMn5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Nov 2016 07:43:57 -0500
In-Reply-To: <1833318.YYJALW9cvC@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 18. November 2016, 12:31:10 CET schrieb Stephan Mueller:

Hi Herbert,

> Hi Herbert,
> 
> Once in a while I seem to trigger a bug in the blkcipher_walk code which I
> cannot track down. This bug happens sporadically where I assume that it has
> something to do with the memory management in the slow path of
> blkcipher_walk.
> 
> I am using the CTR DRBG code that in turn uses the ctr-aes-aesni
> implementation. The bug only appears when I want to obtain a random number
> that is less than the CTR AES block size. In my particular case, I want 4
> bytes from the DRBG.
> 
> The bug happens in arch/x86/crypto/aesni-intel_glue.c:ctr_crypt_final() at
> the line:
> 
> 	memcpy(dst, keystream, nbytes);
> 
> The bug looks like the following:
> 
> [   12.328676] BUG: unable to handle kernel paging request at
> ffffa17ae418b988 [   12.328680] IP: [<ffffffff82060eea>]
> ctr_crypt+0x19a/0x1c0
> [   12.328681] PGD 66fed067
> [   12.328681] PUD 0
> [   12.328681]
> [   12.328683] Oops: 0002 [#1] SMP
> [   12.328692] Modules linked in: bridge(+) stp llc ebtable_nat ip6table_raw
> ip6table_security ip6table_mangle iptable_raw iptable_security
> iptable_mangle ebtable_filter ebtables ip6table_filter ip6_tables
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcspkr i2c_piix4
> virtio_net virtio_balloon acpi_cpufreq sch_fq_codel virtio_console
> virtio_blk virtio_pci virtio_ring serio_raw crc32c_intel virtio
> [   12.328693] CPU: 0 PID: 521 Comm: modprobe Not tainted 4.9.0-rc1+ #253
> [   12.328694] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.9.1-1.fc24 04/01/2014
> [   12.328694] task: ffffa17ab8453fc0 task.stack: ffffbdafc0744000
> [   12.328696] RIP: 0010:[<ffffffff82060eea>]  [<ffffffff82060eea>]
> ctr_crypt +0x19a/0x1c0
> [   12.328696] RSP: 0018:ffffbdafc0747a60  EFLAGS: 00010002
> [   12.328697] RAX: 0000000032e455a6 RBX: 0000000000000004 RCX:
> 0000000000000002
> [   12.328697] RDX: 0000000000000001 RSI: 0000000000000086 RDI:
> 0000000000000086
> [   12.328698] RBP: ffffbdafc0747b28 R08: ffffa17abc16e900 R09:
> 0000000000000019
> [   12.328698] R10: ffffa17a764f68b0 R11: 000000000002e918 R12:
> ffffbdafc0747b38
> [   12.328698] R13: ffffa17a764f6840 R14: ffffa17ae418b988 R15:
> ffffbdafc0747a70
> [   12.328699] FS:  00007f55f57a6700(0000) GS:ffffa17abfc00000(0000) knlGS:
> 0000000000000000
> [   12.328700] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   12.328700] CR2: ffffa17ae418b988 CR3: 0000000079b26000 CR4:
> 00000000003406f0
> [   12.328703] Stack:
> [   12.328705]  ffffa17abc16e900 ffffa17ab845fd80 2ae7e40732e455a6
> 3a224612a8f9841d
> [   12.328706]  fffffb4e81e117c0 ffffa17ab845fd80 fffffb4e829062c0
> ffffa17ae418b988
> [   12.328707]  ffffbdafc0747ba8 ffffffff00000d80 ffffffff00000004
> ffffbdafc0747bc8
> [   12.328708] Call Trace:
> [   12.328712]  [<ffffffff823e5fd3>] __ablk_encrypt+0x43/0x50
> [   12.328714]  [<ffffffff823e6012>] ablk_encrypt+0x32/0xc0
> [   12.328716]  [<ffffffff823c4f2e>] skcipher_encrypt_ablkcipher+0x5e/0x60
> [   12.328717]  [<ffffffff823dbb80>] drbg_kcapi_sym_ctr+0xb0/0x130
> [   12.328719]  [<ffffffff823de153>] drbg_ctr_generate+0x53/0x80
> 
> 
> Now, the interesting part is the following: the original memory pointer that
> shall be processed by the DRBG is in my example ffffffffc018b988 -- this
> pointer is used until the DRBG invokes crypto_skcipher_encrypt. However,
> when I print out the buffer pointer that is used as dst in the memcpy of
> ctr_crypt_final, I see ffffa17ae418b988 -- i.e. the buffer that causes
> paging failure.
> 
> During tracing the blkcipher_walk code I see that the slow code path is used
> when the request size is smaller than the block size. That slow code path
> allocates new memory that will be used for the dst pointer in
> ctr_crypt_final.
> 
> May I ask you for checking whether the allocation and the memory pointer
> logic has an issue that would cause a paging failure?

Following up this issue, I found the location where the wrong memory pointer 
is produced -- the following call tree is used:

1. set up of SGL with proper pointer

2. skcipher_encrypt_ablkcipher with SGL

3. invocation of ctr_crypt from arch/x86/crypto/aesni-intel_glue.c

4. blkcipher_walk_virt_block

5. blkcipher_walk_first

6. blkcipher_walk_next (this code does not use the code path to allocate a 
page)

7. blkcipher_next_fast

        walk->dst.virt.addr = walk->src.virt.addr;
			-> copy src virt address into dst address pointer

		Now, the diff path is used:
        if (diff) {
                walk->flags |= BLKCIPHER_WALK_DIFF;
                blkcipher_map_dst(walk);
        }

8. blkcipher_map_dst

        walk->dst.virt.addr = scatterwalk_map(&walk->out);

		==> this pointer is wrong

The interesting point is that step 8 gets the low and high bits right, but not 
the bits in the middle:

The real data pointer for the dst buffer is ffffffffc0332988. The data pointer 
used by the crypto API is ffff96a995332988 -- as often as I see the issue, 
this similarity in the pointer values is always there.


Please note that the caller uses a static variable that shall be used as dst 
buffer.

Thanks
Stephan
