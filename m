From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: BUG: drbg: Added nodes from Stack Memory in link list
Date: Mon, 8 May 2017 12:00:13 +0530
Message-ID: <CAFXBA=k4MWJYi5Aiw83pFVLykFBQ6RXKerC8Er-MQ3KE2Xi_oA@mail.gmail.com>
References: <CAFXBA=kDqH_32bX8XpUes9bdPP-3Gq5KRGBxu_FXKD3jwgzVdQ@mail.gmail.com>
 <11088841.2SosuHvOD7@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38610 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbdEHGaP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 May 2017 02:30:15 -0400
Received: by mail-wm0-f46.google.com with SMTP id 142so53160977wma.1
        for <linux-crypto@vger.kernel.org>; Sun, 07 May 2017 23:30:14 -0700 (PDT)
In-Reply-To: <11088841.2SosuHvOD7@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 3, 2017 at 6:41 PM, Stephan M=C3=BCller <smueller@chronox.de> w=
rote:
> Am Mittwoch, 3. Mai 2017, 14:47:24 CEST schrieb Harsh Jain:
>
> Hi Harsh,
>
>> Hi Stephen,
>>
>> In drbg driver local variable of function are added as list nodes. one
>> instance is given below.
>>
>>
>> static inline int __init drbg_healthcheck_sanity(void)
>>
>>
>>
>> ---
>> ---
>>
>> max_addtllen =3D drbg_max_addtl(drbg);
>> max_request_bytes =3D drbg_max_request_bytes(drbg);
>> drbg_string_fill(&addtl, buf, max_addtllen + 1);
>> /* overflow addtllen with additonal info string */
>> len =3D drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
>>
>> =3D=3D=3D> Added "addtllist"  to the tail. which local variable.
>>
>>
>> BUG_ON(0 < len);
>> /* overflow max_bits */
>> len =3D drbg_generate(drbg, buf, (max_request_bytes + 1), NULL);
>> BUG_ON(0 < len);
>>
>> /* overflow max addtllen with personalization string */
>> ret =3D drbg_seed(drbg, &addtl, false);
>>
>> =3D=3D=3D=3D> Added "seedlist" to the tail of same list. Previous
>> node(addtllist) already invalid(Out of scope when function returns)
>>
>>
>> BUG_ON(0 =3D=3D ret);
>> /* all tests passed */
>> rc =3D 0;
>>
>>
>>
>> Is't a BUG? or I missed something.
>
> :-) You are right that in normal processing this is a bug. But this is a
> special function which shall perform a sanity checks for the maximum leng=
th
> enforcement. Thus, addtllist or seedlist should never be filled.
>
> To be precise: The called code is expected to return an error before the
> variables are used due to the length checks. If these errors do not appea=
r,
> something is wrong with the DRBG which causes the BUG_ON.

Confusing, I have to dig more for DRBG. Actually we observed following
panic in Chcr (Chelsio) when drgb is enabled and Panic trace points
some thing wrong
with drgb modules. Any idea what are possible reason for this.

alg: No test for authenc(digest_null,rfc3686(ctr(aes)))
(authenc(digest_null-generic,rfc3686-ctr-aes-chcr))
alg: No test for seqiv(authenc(digest_null,rfc3686(ctr(aes))))
(seqiv(authenc(digest_null-generic,rfc3686-ctr-aes-chcr)))
alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff81317c66>] __list_add+0x26/0xd0
PGD 0
Oops: 0000 [#1] SMP
Modules linked in: drbg(+) ansi_cprng seqiv xfrm6_mode_tunnel
xfrm4_mode_tunnel xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4
af_key cbc ccm ctr ghash_generic gf128mul ghash_clmulni_intel cryptd
gcm sha512_ssse3 sha512_generic chcr(OE) cxgb4(OE) authenc netconsole
configfs xt_nat iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat_ipv4 nf_nat nf_conntrack ip_tables nfsd lockd grace nfs_acl
auth_rpcgss sunrpc ipv6 crc_ccitt vfat fat joydev iTCO_wdt
iTCO_vendor_support mxm_wmi pcspkr sg i2c_i801 i2c_smbus lpc_ich
mfd_core shpchp xhci_pci xhci_hcd igb i2c_algo_bit i2c_core ptp
pps_core ioatdma dca ipmi_si ipmi_msghandler wmi acpi_cpufreq acpi_pad
dm_mod(E) ext4(E) mbcache(E) jbd2(E) sd_mod(E) ahci(E) libahci(E)
[last unloaded: scsi_transport_fc]
CPU: 9 PID: 3672 Comm: cryptomgr_test Tainted: G           OE   4.9.13 #2
Hardware name: Supermicro X10DRi/X10DRi, BIOS 2.0 12/28/2015
task: ffff88103b418a00 task.stack: ffffc90008a7c000
RIP: 0010:[<ffffffff81317c66>]  [<ffffffff81317c66>] __list_add+0x26/0xd0
RSP: 0018:ffffc90008a7f8c8  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffc90008a7f920 RCX: 0000000000000001
RDX: ffff88103c8b5ef0 RSI: 0000000000000000 RDI: ffffc90008a7f920
RBP: ffffc90008a7f8f8 R08: 0000000000000000 R09: ffff8810053200b0
R10: ffff88103caf3100 R11: 0000000000000020 R12: ffff88103c8b5ef0
R13: 0000000000000000 R14: ffff88103b418a00 R15: 7fffffffffffffff
FS:  0000000000000000(0000) GS:ffff88107f440000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000001c07000 CR4: 00000000001406e0
Stack:
 ffffc90008a7f8e8 0000000000000246 ffff88103caf3040 ffff88103c8b5ee0
 ffff88103c8b5ee8 ffffc90008a7f908 ffffc90008a7f968 ffffffff81654c02
 0000000000000001 ffff88103b418a00 ffffffff81097370 0000000000000000
Call Trace:
 [<ffffffff81654c02>] wait_for_completion_interruptible+0xc2/0x130
 [<ffffffff81097370>] ? try_to_wake_up+0x240/0x240
 [<ffffffffa02582fb>] drbg_kcapi_sym_ctr+0xeb/0x150 [drbg]
 [<ffffffffa0259560>] drbg_ctr_update+0x1b0/0x2a0 [drbg]
 [<ffffffffa0259bd2>] drbg_seed+0x1a2/0x2e0 [drbg]
 [<ffffffffa025a6ef>] ? drbg_init_sym_kernel+0x13f/0x200 [drbg]
 [<ffffffffa025aa62>] drbg_instantiate+0x52/0x1e0 [drbg]
 [<ffffffff811ca2ee>] ? __kmalloc+0xee/0x1d0
 [<ffffffff812a873d>] ? crypto_create_tfm+0x3d/0xd0
 [<ffffffffa025acbc>] drbg_kcapi_seed+0xcc/0x118 [drbg]
 [<ffffffff812a87a1>] ? crypto_create_tfm+0xa1/0xd0
 [<ffffffff812bb48d>] crypto_rng_reset+0x5d/0x80
 [<ffffffff812b5197>] drbg_cavs_test+0xf7/0x370
 [<ffffffff810a3018>] ? dequeue_task_fair+0x68/0x420
 [<ffffffff8109ccd5>] ? pick_next_task_idle+0x45/0x50
 [<ffffffff812b547b>] alg_test_drbg+0x6b/0xa0
 [<ffffffff812b18d5>] alg_test+0x145/0x350
 [<ffffffff812b0ad0>] ? cryptomgr_probe+0xd0/0xd0
 [<ffffffff812b0ad0>] ? cryptomgr_probe+0xd0/0xd0
 [<ffffffff812b0b15>] cryptomgr_test+0x45/0x50
 [<ffffffff8108a5ed>] kthread+0xcd/0xf0
 [<ffffffff8109503e>] ? schedule_tail+0x1e/0xc0
 [<ffffffff8108a520>] ? __kthread_init_worker+0x40/0x40
 [<ffffffff81657bd2>] ret_from_fork+0x22/0x30
Code: 00 00 00 00 00 55 48 89 e5 48 83 ec 30 48 89 5d e8 4c 89 65 f0
48 89 fb 4c 89 6d f8 4c 8b 42 08 49 89 f5 49 89 d4 49 39 f0 75 31 <4d>
8b 45 00 4d 39 c4 75 6f 4c 39 e3 74 45 4c 39 eb 74 40 49 89
RIP  [<ffffffff81317c66>] __list_add+0x26/0xd0
 RSP <ffffc90008a7f8c8>
CR2: 0000000000000000
---[ end trace fbf11c880e8c4c52 ]---




>
> The following error conditions are triggered:
>
>         /* 9.3.1 step 2 */
>         len =3D -EINVAL;
>         if (buflen > (drbg_max_request_bytes(drbg))) {
>                 pr_devel("DRBG: requested random numbers too large %u\n",
>                          buflen);
>                 goto err;
>         }
>
>         /* 9.3.1 step 4 */
>         if (addtl && addtl->len > (drbg_max_addtl(drbg))) {
>                 pr_devel("DRBG: additional information string too long %z=
u\n",
>                          addtl->len);
>                 goto err;
>         }
>
>
> Ciao
> Stephan
