Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B686F28CF52;
	Thu,  2 Oct 2025 08:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759392645; cv=none; b=bir8MY1/MAxvEmXbdX17R/92jWVIpiyMxHP5khG2nfPoURZ04hQTgYaLFssJMeQKw7fH0Q1edP44z1KtZ9dx+MDePAx+DMvca1vTf9SelZa2v/jrg0IkR2llClZ14BDIaHikuYL9QiDJbC1j35XjOZ2ttJCMAifDbT8UMQymF7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759392645; c=relaxed/simple;
	bh=+sOoGBJhQxY4YX6a9+4TOzchiFsRWAb250NSCUDSCPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JxLY5DSbulfErvr1ZZCEYb2qZcaBKCKfpBwVl+EUkq3+Qc0ZUn8oMh5BPgnF5LgDGbcBGhzy78PRRX7VmxozptcP0ZXncKV+Ngf10q/neEQwBdxmDm+4uMvB33h45w6b2bf9GLmsyt9ef1WxkkByATy71IDlBAykcVI+iCXU2Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kq3PE81f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kq3PE81f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3392C4CEF4;
	Thu,  2 Oct 2025 08:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759392645;
	bh=+sOoGBJhQxY4YX6a9+4TOzchiFsRWAb250NSCUDSCPQ=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=kq3PE81fcc4P9IGWMWGJAw6x/5NgaTzA04AvXlXtjWkhkf1jLwr2gjTLksFpfl+wg
	 xP2CRJgym0weYMEXvg7XGgBVycBq9aC0NPhOhLw5bbz1AA8OmTp431w6R51OmmTvmO
	 pbUgeQ1LvTqhqTipGpdadQdhgjVHNQBS8Lud66+JUD2XmALf7RP9INxkK9o0EkeS2a
	 G7hlyQmbTlgcAgy6gTT7vPFP576ztOmCgGHnHrrsOSVB4oFQiQot/YQaffoKs2k3Je
	 YuNnTo3s8p2R+MKShBAk3nOEw4ngMK1aIgg8bPd6hrko2FsX7smuJRcQPF89hJye2k
	 5Li+RIcY1cAfA==
Message-ID: <05b7ef65-37bb-4391-9ec9-c382d51bae4d@kernel.org>
Date: Thu, 2 Oct 2025 10:10:41 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] Crypto Update for 6.17
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Vegard Nossum <vegard.nossum@oracle.com>
References: <aIirh_7k4SWzE-bF@gondor.apana.org.au>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <aIirh_7k4SWzE-bF@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29. 07. 25, 13:07, Herbert Xu wrote:
> Vegard Nossum (1):
>        crypto: testmgr - desupport SHA-1 for FIPS 140

Booting 6.17 with fips=1 crashes with this commit -- see below.

The crash is different being on 6.17 (below) and on the commit -- 
9d50a25eeb05c45fef46120f4527885a14c84fb2.

6.17 minus that one makes it work again.

Any ideas?

> [    1.186784][    T1] IPv6: Attempt to unregister permanent protocol 6
> [    1.188236][    T1] IPv6: Attempt to unregister permanent protocol 136
> [    1.189648][    T1] IPv6: Attempt to unregister permanent protocol 17
> [    2.351181][    T1] ------------[ cut here ]------------
> [    2.352257][    T1] WARNING: CPU: 10 PID: 1 at net/ipv6/ip6mr.c:409 ip6mr_free_table+0x28/0x60
> [    2.353536][    T1] Modules linked in:
> [    2.354113][    T1] CPU: 10 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.17.0-46-default #1 PREEMPT(voluntary) openSUSE Tumbleweed (unreleased)  b731e69de5611aa08621e4f613e2c88e3aba29e6
> [    2.356567][    T1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
> [    2.357843][    T1] RIP: 0010:ip6mr_free_table+0x28/0x60
> [    2.358654][    T1] Code: 90 90 0f 1f 44 00 00 53 48 89 fb e8 a2 11 0d 00 48 8b 43 10 8b 90 6c 01 00 00 85 d2 74 0e 48 8b 80 98 00 00 00 48 85 c0 74 02 <0f> 0b 48 8d 7b 38 e8 4d 65 33 ff 48 89 df be 0f 00 00 00 e8 80 fc
> [    2.361528][    T1] RSP: 0018:ffffcd1bc001fce8 EFLAGS: 00010286
> [    2.362458][    T1] RAX: ffffffff93f32e00 RBX: ffff8b6b05c9b000 RCX: ffff8b6b00898000
> [    2.363625][    T1] RDX: 0000000000000002 RSI: 00000000e843c2fc RDI: ffff8b6b05c9b000
> [    2.364785][    T1] RBP: ffffffff9566c2f0 R08: 0000000037609dba R09: 0000000000000075
> [    2.365982][    T1] R10: ffffcd1bc001fd30 R11: ffff8b6b00898fd8 R12: dead000000000122
> [    2.367157][    T1] R13: dead000000000100 R14: ffffffff9566b4c0 R15: ffffcd1bc001fdb8
> [    2.368332][    T1] FS:  0000000000000000(0000) GS:ffff8b6daf9a8000(0000) knlGS:0000000000000000
> [    2.369690][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.371077][    T1] CR2: 0000000000000000 CR3: 0000000047c54000 CR4: 0000000000750ef0
> [    2.372611][    T1] PKRU: 55555554
> [    2.373452][    T1] Call Trace:
> [    2.374252][    T1]  <TASK>
> [    2.375019][    T1]  ip6mr_rules_exit+0x80/0xe0
> [    2.376021][    T1]  ip6mr_net_exit_batch+0x2b/0x50
> [    2.377077][    T1]  ops_undo_list+0x10a/0x3b0
> [    2.378090][    T1]  ? __pfx_inet6_init+0x10/0x10
> [    2.379102][    T1]  unregister_pernet_operations+0xdd/0x170
> [    2.380279][    T1]  unregister_pernet_subsys+0x21/0x30
> [    2.381371][    T1]  ip6_mr_cleanup+0x43/0x50
> [    2.382321][    T1]  inet6_init+0x365/0x3d0
> [    2.383263][    T1]  do_one_initcall+0x58/0x390
> [    2.384256][    T1]  kernel_init_freeable+0x2a7/0x320
> [    2.385316][    T1]  ? __pfx_kernel_init+0x10/0x10
> [    2.386343][    T1]  kernel_init+0x1a/0x140
> [    2.387275][    T1]  ret_from_fork+0x28b/0x2c0
> [    2.388242][    T1]  ? __pfx_kernel_init+0x10/0x10
> [    2.389236][    T1]  ret_from_fork_asm+0x1a/0x30
> [    2.390213][    T1]  </TASK>
> [    2.390963][    T1] irq event stamp: 137165
> [    2.392123][    T1] hardirqs last  enabled at (137177): [<ffffffff91c079ee>] __up_console_sem+0x5e/0x70
> [    2.394179][    T1] hardirqs last disabled at (137188): [<ffffffff91c079d3>] __up_console_sem+0x43/0x70
> [    2.395868][    T1] softirqs last  enabled at (137088): [<ffffffff91b442e8>] __irq_exit_rcu+0xd8/0x100
> [    2.397531][    T1] softirqs last disabled at (137071): [<ffffffff91b442e8>] __irq_exit_rcu+0xd8/0x100
> [    2.399171][    T1] ---[ end trace 0000000000000000 ]---
> [    2.407972][    T1] NET: Unregistered PF_INET6 protocol family
> [    2.419868][    T1] =============================================================================
> [    2.420857][    T1] BUG RAWv6 (Tainted: G        W          ): Objects remaining on __kmem_cache_shutdown()
> [    2.420857][    T1] -----------------------------------------------------------------------------
> [    2.420857][    T1] 
> [    2.420857][    T1] Object 0x00000000394ddb07 @offset=0
> [    2.420857][    T1] Object 0x000000005b94be2d @offset=1856
> [    2.420857][    T1] Object 0x0000000067ad0f1b @offset=3712
> [    2.420857][    T1] Object 0x00000000c82c6c1d @offset=7424
> [    2.420857][    T1] Object 0x000000009feb574d @offset=9280
> [    2.420857][    T1] Object 0x00000000876e99c8 @offset=11136
> [    2.420857][    T1] Object 0x000000000aae5823 @offset=12992
> [    2.420857][    T1] Object 0x000000009a4d1547 @offset=14848
> [    2.420857][    T1] Object 0x000000003343b806 @offset=16704
> [    2.420857][    T1] Object 0x000000004cc8a8a9 @offset=18560
> [    2.420857][    T1] Object 0x00000000125f35fd @offset=20416
> [    2.420857][    T1] Object 0x000000007903e512 @offset=22272
> [    2.420857][    T1] Object 0x00000000705f6e50 @offset=24128
> [    2.420857][    T1] Object 0x00000000c222f065 @offset=25984
> [    2.420857][    T1] Object 0x0000000020b63684 @offset=27840
> [    2.420857][    T1] Object 0x00000000a2f1493f @offset=29696
> [    2.420857][    T1] Slab 0x0000000070ef76ad objects=17 used=16 fp=0x000000005ed43c1e flags=0x17ffffc0000240(workingset|head|node=0|zone=2|lastcpupid=0x1fffff)
> [    2.420857][    T1] Disabling lock debugging due to kernel taint
> [    2.420857][    T1] ------------[ cut here ]------------
> [    2.420857][    T1] WARNING: CPU: 2 PID: 1 at mm/slub.c:1176 __slab_err+0x19/0x20
> [    2.420857][    T1] Modules linked in:
> [    2.420857][    T1] CPU: 2 UID: 0 PID: 1 Comm: swapper/0 Tainted: G    B   W           6.17.0-46-default #1 PREEMPT(voluntary) openSUSE Tumbleweed (unreleased)  b731e69de5611aa08621e4f613e2c88e3aba29e6
> [    2.420857][    T1] Tainted: [B]=BAD_PAGE, [W]=WARN
> [    2.420857][    T1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
> [    2.420857][    T1] RIP: 0010:__slab_err+0x19/0x20
> [    2.420857][    T1] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 e8 76 ff ff ff be 01 00 00 00 bf 05 00 00 00 e8 87 6e 11 00 <0f> 0b e9 eb 0a ee ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
> [    2.420857][    T1] RSP: 0018:ffffcd1bc001fd40 EFLAGS: 00010082
> [    2.420857][    T1] RAX: 0000000000000000 RBX: ffff8b6b08968380 RCX: 0000000000000243
> [    2.420857][    T1] RDX: 0000000000000005 RSI: ffffcd1bc001fbe8 RDI: 0000000000000003
> [    2.420857][    T1] RBP: fffffb7904234e00 R08: 0000000000000000 R09: 00000000ffff7fff
> [    2.420857][    T1] R10: ffffffff95472540 R11: ffffcd1bc001fbe0 R12: dead000000000100
> [    2.420857][    T1] R13: ffffcd1bc001fd78 R14: fffffb7904234800 R15: ffff8b6b08d20000
> [    2.420857][    T1] FS:  0000000000000000(0000) GS:ffff8b6daf5a8000(0000) knlGS:0000000000000000
> [    2.420857][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.420857][    T1] CR2: 0000000000000000 CR3: 0000000047c54000 CR4: 0000000000750ef0
> [    2.420857][    T1] PKRU: 55555554
> [    2.420857][    T1] Call Trace:
> [    2.420857][    T1]  <TASK>
> [    2.420857][    T1]  __kmem_cache_shutdown.cold+0x13c/0x146
> [    2.420857][    T1]  ? __pfx_inet6_init+0x10/0x10
> [    2.420857][    T1]  kmem_cache_destroy+0x41/0x150
> [    2.420857][    T1]  proto_unregister+0x93/0x100
> [    2.420857][    T1]  inet6_init+0x3a2/0x3d0
> [    2.420857][    T1]  do_one_initcall+0x58/0x390
> [    2.420857][    T1]  kernel_init_freeable+0x2a7/0x320
> [    2.420857][    T1]  ? __pfx_kernel_init+0x10/0x10
> [    2.420857][    T1]  kernel_init+0x1a/0x140
> [    2.420857][    T1]  ret_from_fork+0x28b/0x2c0
> [    2.420857][    T1]  ? __pfx_kernel_init+0x10/0x10
> [    2.420857][    T1]  ret_from_fork_asm+0x1a/0x30
> [    2.420857][    T1]  </TASK>
> [    2.420857][    T1] irq event stamp: 137776
> [    2.420857][    T1] hardirqs last  enabled at (137775): [<ffffffff92a10b78>] _raw_spin_unlock_irq+0x28/0x50
> [    2.420857][    T1] hardirqs last disabled at (137776): [<ffffffff92a10893>] _raw_spin_lock_irq+0x53/0x60
> [    2.420857][    T1] softirqs last  enabled at (137566): [<ffffffff928b455e>] inet6_unregister_protosw+0x5e/0x70
> [    2.420857][    T1] softirqs last disabled at (137564): [<ffffffff928b4523>] inet6_unregister_protosw+0x23/0x70
> [    2.420857][    T1] ---[ end trace 0000000000000000 ]---
> [    2.507939][    T1] ------------[ cut here ]------------
> [    2.508959][    T1] kmem_cache_destroy RAWv6: Slab cache still has objects when called from proto_unregister+0x93/0x100
> [    2.508977][    T1] WARNING: CPU: 2 PID: 1 at mm/slab_common.c:525 kmem_cache_destroy+0x140/0x150
> [    2.512301][    T1] Modules linked in:
> [    2.513125][    T1] CPU: 2 UID: 0 PID: 1 Comm: swapper/0 Tainted: G    B   W           6.17.0-46-default #1 PREEMPT(voluntary) openSUSE Tumbleweed (unreleased)  b731e69de5611aa08621e4f613e2c88e3aba29e6
> [    2.516258][    T1] Tainted: [B]=BAD_PAGE, [W]=WARN
> [    2.517234][    T1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
> [    2.518767][    T1] RIP: 0010:kmem_cache_destroy+0x140/0x150
> [    2.519829][    T1] Code: 00 85 ed 74 92 eb b1 e8 7e 04 db ff eb 8f 48 8b 53 60 48 8b 4c 24 10 48 c7 c6 f0 af c9 92 48 c7 c7 08 ad 2c 93 e8 e0 62 cb ff <0f> 0b e9 04 ff ff ff e9 2f 03 a8 ff 0f 1f 40 00 90 90 90 90 90 90
> [    2.523085][    T1] RSP: 0018:ffffcd1bc001fdc8 EFLAGS: 00010246
> [    2.524197][    T1] RAX: 0000000000000000 RBX: ffff8b6b01e7f000 RCX: 000000000000026b
> [    2.525560][    T1] RDX: 0000000000000000 RSI: ffffcd1bc001fc78 RDI: 0000000000000003
> [    2.526955][    T1] RBP: 0000000000000001 R08: 0000000000000000 R09: 00000000ffff7fff
> [    2.528313][    T1] R10: ffffffff95472540 R11: ffffcd1bc001fc70 R12: ffffffff9456bac0
> [    2.529683][    T1] R13: ffffffff9478ace8 R14: 0000000000000000 R15: 0000000000000000
> [    2.531041][    T1] FS:  0000000000000000(0000) GS:ffff8b6daf5a8000(0000) knlGS:0000000000000000
> [    2.532563][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.535367][    T1] CR2: 0000000000000000 CR3: 0000000047c54000 CR4: 0000000000750ef0
> [    2.538374][    T1] PKRU: 55555554
> [    2.539338][    T1] Call Trace:
> [    2.540142][    T1]  <TASK>
> [    2.540897][    T1]  proto_unregister+0x93/0x100
> [    2.541851][    T1]  inet6_init+0x3a2/0x3d0
> [    2.542726][    T1]  do_one_initcall+0x58/0x390
> [    2.543618][    T1]  kernel_init_freeable+0x2a7/0x320
> [    2.544589][    T1]  ? __pfx_kernel_init+0x10/0x10
> [    2.545598][    T1]  kernel_init+0x1a/0x140
> [    2.546414][    T1]  ret_from_fork+0x28b/0x2c0
> [    2.547277][    T1]  ? __pfx_kernel_init+0x10/0x10
> [    2.548230][    T1]  ret_from_fork_asm+0x1a/0x30
> [    2.549174][    T1]  </TASK>
> [    2.549849][    T1] irq event stamp: 137776
> [    2.550694][    T1] hardirqs last  enabled at (137775): [<ffffffff92a10b78>] _raw_spin_unlock_irq+0x28/0x50
> [    2.552309][    T1] hardirqs last disabled at (137776): [<ffffffff92a10893>] _raw_spin_lock_irq+0x53/0x60
> [    2.553923][    T1] softirqs last  enabled at (137566): [<ffffffff928b455e>] inet6_unregister_protosw+0x5e/0x70
> [    2.555624][    T1] softirqs last disabled at (137564): [<ffffffff928b4523>] inet6_unregister_protosw+0x23/0x70
> [    2.557300][    T1] ---[ end trace 0000000000000000 ]---
> [    2.591591][    T1] IPI shorthand broadcast: enabled
thanks,
-- 
js
suse labs
