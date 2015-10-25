From: Harsh Jain <harshjain.prof@gmail.com>
Subject: kernel tainted while exporting shash context using af_alg interface
Date: Sun, 25 Oct 2015 11:56:27 +0530
Message-ID: <CAFXBA=mVmRsAk3fuyjf3WA-P+0dHKu0upUdb5Qxr0kwn1rKiDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:34932 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbbJYG03 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Oct 2015 02:26:29 -0400
Received: by lfbn126 with SMTP id n126so83926866lfb.2
        for <linux-crypto@vger.kernel.org>; Sat, 24 Oct 2015 23:26:28 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,


When trying to calculate HMAC(SHA1) with openssl using af-alg engine
kernel crashes.Find below the command used and kernel. I have added
some debug print in logs.

Command used : ./openssl dgst -engine af_alg -sha1 -hmac "key" r.txt
kernel version : 3.17.8

Initial Investigation : In shash_desc structure tfm pointer contains
5a5a5a5a5a5a5a5a(invalid pointer), when it triess to reference export
function pointer it crashes. As per my understanding tfm object should
have pointer of memory bloack allocated in
"crypto_init_shash_ops_async" function

Please give some pointers to debug the issue.Any documentation to
understand the crypto-api code.

Kernel logs:


[ 3190.053499] Harsh : crypto_ahash_export
[ 3190.053499]  crypto_ahash_reqtfm
[ 3190.053500] req->base.tfm  ffff880193478ec8
[ 3190.053500] __crypto_ahash_cast=req->base.tfm  ffff880193478e80
[ 3190.053501] ahash_request_ctx{req} ffff8800362ebb98
[ 3190.053501] crypto_shash_alg entered
[ 3190.053502] crypto_shash_alg TFM  5a5a5a5a5a5a5a5a
[ 3190.053502] crypto_shash_alg TFM Base 5a5a5a5a5a5a5a62
[ 3190.053507] general protection fault: 0000 [#1] SMP
[ 3190.053509] Modules linked in: coretemp kvm_intel kvm crc32c_intel
iTCO_wdt iTCO_vendor_support ppdev parport_pc parport i2c_i801 lpc_ich
microcode i2c_core serio_raw mfd_core tpm_infineon pcspkr shpchp
ioatdma i7core_edac edac_core dca acpi_cpufreq uinput xfs libcrc32c
exportfs sd_mod sr_mod crc_t10dif crct10dif_common cdrom ata_generic
pata_acpi e1000e ptp ata_piix mptsas scsi_transport_sas mptscsih
mptbase dm_mirror dm_region_hash dm_log dm_mod ipv6 autofs4
[ 3190.053527] CPU: 1 PID: 3043 Comm: openssl Not tainted 3.17.8_harsh #39
[ 3190.053528] Hardware name: Supermicro X8ST3/X8ST3, BIOS 2.0a       11/28/2012
[ 3190.053529] task: ffff88019866e2d0 ti: ffff8800d71e4000 task.ti:
ffff8800d71e4000
[ 3190.053530] RIP: 0010:[<ffffffff81273bce>]  [<ffffffff81273bce>]
shash_async_export+0x5e/0x90
[ 3190.053533] RSP: 0018:ffff8800d71e7de8  EFLAGS: 00010282
[ 3190.053533] RAX: 000000000000002a RBX: 5a5a5a5a5a5a5a5a RCX: 0000000000000006
[ 3190.053534] RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffff88019fc2c130
[ 3190.053535] RBP: ffff8800d71e7e00 R08: 0000000000000400 R09: ffffffff81db9f64
[ 3190.053536] R10: 0000000000000ced R11: 0000000000000cec R12: ffff8800362ebb98
[ 3190.053536] R13: ffff8800d71e7e10 R14: ffff8800d74bfcc0 R15: ffff8800362ebb48
[ 3190.053537] FS:  00007ffff7fe1740(0000) GS:ffff88019fc20000(0000)
knlGS:0000000000000000
[ 3190.053538] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3190.053539] CR2: 0000000001c3baf8 CR3: 00000000daa8b000 CR4: 00000000000007e0
[ 3190.053540] Stack:
[ 3190.053540]  ffff8800362eb800 ffff880193478ec8 ffff8800d61b7800
ffff8800d71e7e98
[ 3190.053542]  ffffffff81295adc ffffffff815c3d53 0000000000000020
ffff8800d71e7e70
[ 3190.053543]  ffff8800d71e7e30 ffffffff811b5fab ffff880193478ec8
ffffffff81ad4cd0
[ 3190.053545] Call Trace:
[ 3190.053547]  [<ffffffff81295adc>] hash_accept+0x13c/0x250
[ 3190.053548]  [<ffffffff815c3d53>] ? printk+0x54/0x56
[ 3190.053549]  [<ffffffff811b5fab>] ? alloc_file+0x1b/0xc0
[ 3190.053550]  [<ffffffff81295a25>] ? hash_accept+0x85/0x250
[ 3190.053552]  [<ffffffff814e2a94>] SYSC_accept4+0xf4/0x200
[ 3190.053553]  [<ffffffff811b414c>] ? vfs_write+0x15c/0x1f0
[ 3190.053555]  [<ffffffff814e4010>] SyS_accept+0x10/0x20
[ 3190.053556]  [<ffffffff815cfe52>] system_call_fastpath+0x16/0x1b
[ 3190.053557] Code: 81 31 c0 e8 54 01 35 00 48 c7 c7 6e 61 82 81 31
c0 48 89 de e8 43 01 35 00 48 8d 73 08 48 c7 c7 e8 bd 82 81 31 c0 e8
31 01 35 00 <48> 8b 73 58 48 c7 c7 08 be 82 81 31 c0 e8 1f 01 35 00 48
8b 43
[ 3190.053575] RIP  [<ffffffff81273bce>] shash_async_export+0x5e/0x90
[ 3190.053577]  RSP <ffff8800d71e7de8>
[ 3190.053578] ---[ end trace d9701f2848d12eb5 ]---
