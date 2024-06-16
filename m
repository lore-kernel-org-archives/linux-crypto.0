Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B201843;
	Sun, 16 Jun 2024 06:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718517822; cv=none; b=msVu/ozLAmNx4NnYV7wHgJL/WUuUd1+hYURoru285/Z8R88GbzPQzOj+wyU1oUUg0mMVpmRxFxdCnyWW7AchPgfjEVzodf32yfDmEAw7mpnG7CjwdT1UoVZJHxsutycLUrsnNw5RC95ubvH6T7/j64NvKbHNGKu4x1UMnzounJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718517822; c=relaxed/simple;
	bh=/2YJgEY6S7F3s4XlmpXP0VvwXWYDZ9MlbrwhcewjlzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kFTS6OOix11epk2E0BhZ/vy4mcIbFWbOOprIUPoPQ3gA/MJzzel4f5OxKcYyrvL6HGQgdlTevBaVwvhRf2A/QlZL1RQRFGYFsCOOD2vIE1WZZTKwzcXDfPi2EccOlR8FSh+hhkQSc287ZQw3d/RJ26c49hSdWbW8MkL+Hb2+SmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sIis7-000aMl-0x;
	Sun, 16 Jun 2024 13:56:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Jun 2024 13:56:11 +0800
Date: Sun, 16 Jun 2024 13:56:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kim Phillips <kim.phillips@amd.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Liam Merwick <liam.merwick@oracle.com>
Subject: Re: [PATCH v2] crypto: ccp - Fix null pointer dereference in
 __sev_snp_shutdown_locked
Message-ID: <Zm5-e123tiK_jytS@gondor.apana.org.au>
References: <20240604174739.175288-1-kim.phillips@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240604174739.175288-1-kim.phillips@amd.com>

On Tue, Jun 04, 2024 at 12:47:39PM -0500, Kim Phillips wrote:
> Fix a null pointer dereference induced by DEBUG_TEST_DRIVER_REMOVE.
> Return from __sev_snp_shutdown_locked() if the psp_device or the
> sev_device structs are not initialized. Without the fix, the driver will
> produce the following splat:
> 
>    ccp 0000:55:00.5: enabling device (0000 -> 0002)
>    ccp 0000:55:00.5: sev enabled
>    ccp 0000:55:00.5: psp enabled
>    BUG: kernel NULL pointer dereference, address: 00000000000000f0
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    PGD 0 P4D 0
>    Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
>    CPU: 262 PID: 1 Comm: swapper/0 Not tainted 6.9.0-rc1+ #29
>    RIP: 0010:__sev_snp_shutdown_locked+0x2e/0x150
>    Code: 00 55 48 89 e5 41 57 41 56 41 54 53 48 83 ec 10 41 89 f7 49 89 fe 65 48 8b 04 25 28 00 00 00 48 89 45 d8 48 8b 05 6a 5a 7f 06 <4c> 8b a0 f0 00 00 00 41 0f b6 9c 24 a2 00 00 00 48 83 fb 02 0f 83
>    RSP: 0018:ffffb2ea4014b7b8 EFLAGS: 00010286
>    RAX: 0000000000000000 RBX: ffff9e4acd2e0a28 RCX: 0000000000000000
>    RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb2ea4014b808
>    RBP: ffffb2ea4014b7e8 R08: 0000000000000106 R09: 000000000003d9c0
>    R10: 0000000000000001 R11: ffffffffa39ff070 R12: ffff9e49d40590c8
>    R13: 0000000000000000 R14: ffffb2ea4014b808 R15: 0000000000000000
>    FS:  0000000000000000(0000) GS:ffff9e58b1e00000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: 00000000000000f0 CR3: 0000000418a3e001 CR4: 0000000000770ef0
>    PKRU: 55555554
>    Call Trace:
>     <TASK>
>     ? __die_body+0x6f/0xb0
>     ? __die+0xcc/0xf0
>     ? page_fault_oops+0x330/0x3a0
>     ? save_trace+0x2a5/0x360
>     ? do_user_addr_fault+0x583/0x630
>     ? exc_page_fault+0x81/0x120
>     ? asm_exc_page_fault+0x2b/0x30
>     ? __sev_snp_shutdown_locked+0x2e/0x150
>     __sev_firmware_shutdown+0x349/0x5b0
>     ? pm_runtime_barrier+0x66/0xe0
>     sev_dev_destroy+0x34/0xb0
>     psp_dev_destroy+0x27/0x60
>     sp_destroy+0x39/0x90
>     sp_pci_remove+0x22/0x60
>     pci_device_remove+0x4e/0x110
>     really_probe+0x271/0x4e0
>     __driver_probe_device+0x8f/0x160
>     driver_probe_device+0x24/0x120
>     __driver_attach+0xc7/0x280
>     ? driver_attach+0x30/0x30
>     bus_for_each_dev+0x10d/0x130
>     driver_attach+0x22/0x30
>     bus_add_driver+0x171/0x2b0
>     ? unaccepted_memory_init_kdump+0x20/0x20
>     driver_register+0x67/0x100
>     __pci_register_driver+0x83/0x90
>     sp_pci_init+0x22/0x30
>     sp_mod_init+0x13/0x30
>     do_one_initcall+0xb8/0x290
>     ? sched_clock_noinstr+0xd/0x10
>     ? local_clock_noinstr+0x3e/0x100
>     ? stack_depot_save_flags+0x21e/0x6a0
>     ? local_clock+0x1c/0x60
>     ? stack_depot_save_flags+0x21e/0x6a0
>     ? sched_clock_noinstr+0xd/0x10
>     ? local_clock_noinstr+0x3e/0x100
>     ? __lock_acquire+0xd90/0xe30
>     ? sched_clock_noinstr+0xd/0x10
>     ? local_clock_noinstr+0x3e/0x100
>     ? __create_object+0x66/0x100
>     ? local_clock+0x1c/0x60
>     ? __create_object+0x66/0x100
>     ? parameq+0x1b/0x90
>     ? parse_one+0x6d/0x1d0
>     ? parse_args+0xd7/0x1f0
>     ? do_initcall_level+0x180/0x180
>     do_initcall_level+0xb0/0x180
>     do_initcalls+0x60/0xa0
>     ? kernel_init+0x1f/0x1d0
>     do_basic_setup+0x41/0x50
>     kernel_init_freeable+0x1ac/0x230
>     ? rest_init+0x1f0/0x1f0
>     kernel_init+0x1f/0x1d0
>     ? rest_init+0x1f0/0x1f0
>     ret_from_fork+0x3d/0x50
>     ? rest_init+0x1f0/0x1f0
>     ret_from_fork_asm+0x11/0x20
>     </TASK>
>    Modules linked in:
>    CR2: 00000000000000f0
>    ---[ end trace 0000000000000000 ]---
>    RIP: 0010:__sev_snp_shutdown_locked+0x2e/0x150
>    Code: 00 55 48 89 e5 41 57 41 56 41 54 53 48 83 ec 10 41 89 f7 49 89 fe 65 48 8b 04 25 28 00 00 00 48 89 45 d8 48 8b 05 6a 5a 7f 06 <4c> 8b a0 f0 00 00 00 41 0f b6 9c 24 a2 00 00 00 48 83 fb 02 0f 83
>    RSP: 0018:ffffb2ea4014b7b8 EFLAGS: 00010286
>    RAX: 0000000000000000 RBX: ffff9e4acd2e0a28 RCX: 0000000000000000
>    RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb2ea4014b808
>    RBP: ffffb2ea4014b7e8 R08: 0000000000000106 R09: 000000000003d9c0
>    R10: 0000000000000001 R11: ffffffffa39ff070 R12: ffff9e49d40590c8
>    R13: 0000000000000000 R14: ffffb2ea4014b808 R15: 0000000000000000
>    FS:  0000000000000000(0000) GS:ffff9e58b1e00000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: 00000000000000f0 CR3: 0000000418a3e001 CR4: 0000000000770ef0
>    PKRU: 55555554
>    Kernel panic - not syncing: Fatal exception
>    Kernel Offset: 0x1fc00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> 
> Fixes: 1ca5614b84ee ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
> Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
> Reviewed-by: John Allen <john.allen@amd.com>
> ---
> v2:
>  - Correct the Fixes tag (Tom L.)
>  - Remove log timestamps, elaborate commit text (John Allen)
>  - Add Reviews-by.
> 
> v1:
>  - https://lore.kernel.org/linux-crypto/20240603151212.18342-1-kim.phillips@amd.com/
> 
>  drivers/crypto/ccp/sev-dev.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
