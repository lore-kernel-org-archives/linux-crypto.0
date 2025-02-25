Received: from smtp134-31.sina.com.cn (smtp134-31.sina.com.cn [180.149.134.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED27B26159A
	for <linux-crypto@vger.kernel.org>; Tue, 25 Feb 2025 10:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.149.134.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740480734; cv=none; b=OYnpTDxeIJxSADi/8B7rbKC3z2v+2LBZRE+CT3xKDdZ838bvichRRNpnVM6FE25WlxFLbJaSeHnCtjEk+Vg4wvCDCbXQ7ISsjku/89175lUzZ3zIRGJqRVEqR6QzJlvn7lop5zgEu2OUyhei6O9ygmlzxAQ3BEi9IdNkPflssas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740480734; c=relaxed/simple;
	bh=e3ce2FE+5zRO0YASC3OqgwYUtm1OZQaI/olENRYBWUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9CrOKaLqSCqxnV11oW+yACJJOR6Otr2L2+psZ5GPaykTpN5uh0kNN9/IQOXM3qCRt30C45dxb3SrT2aZ+tNSJODkh/4rUVdeSMwQu1Kbnvt1N+A2du2DB5bKoWdc7tqcHhwXgPAXRW5zm27Du/R1PQbtSLpvscweOyO6Ruk2nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; arc=none smtp.client-ip=180.149.134.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([113.88.51.170])
	by sina.com (10.185.250.21) with ESMTP
	id 67BDA03B0000446A; Tue, 25 Feb 2025 18:49:34 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 8156143408387
X-SMAIL-UIID: F087765FD2C14F0E8FE4D64FE22F852C-20250225-184934-1
From: Hillf Danton <hdanton@sina.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: syzbot <syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	linux-mm@kvack.org
Subject: Re: mm: zswap: fix crypto_free_acomp deadlock in zswap_cpu_comp_dead
Date: Tue, 25 Feb 2025 18:49:22 +0800
Message-ID: <20250225104923.2802-1-hdanton@sina.com>
In-Reply-To: <Z72FJnbA39zWh4zS@gondor.apana.org.au>
References: <67bcea51.050a0220.bbfd1.0096.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 25 Feb 2025 16:53:58 +0800 Herbert Xu wrote:
> On Mon, Feb 24, 2025 at 01:53:21PM -0800, syzbot wrote:
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    e9a8cac0bf89 Merge tag 'v6.14-rc3-smb3-client-fixes' of gi..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17b667f8580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=61cbf5ac8a063ad4
> > dashboard link: https://syzkaller.appspot.com/bug?extid=1a517ccfcbc6a7ab0f82
> > compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/8441f1b50402/disk-e9a8cac0.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/65b1f8d2f790/vmlinux-e9a8cac0.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/1d6f6d8c3d6b/bzImage-e9a8cac0.xz
> 
> ---8<---
> Call crypto_free_acomp outside of the mutex in zswap_cpu_comp_dead
> as otherwise this could dead-lock as the allocation path may lead
> back into zswap while holding the same lock.  Zap the pointers to
> acomp and buffer after freeing.
> 
> Also move the NULL check on acomp_ctx so that it takes place before
> the mutex dereference.
> 
> Fixes: 12dcb0ef5406 ("mm: zswap: properly synchronize freeing resources during CPU hotunplug")
> Reported-by: syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 6504174fbc6a..24d36266a791 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -881,18 +881,23 @@ static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
>  {
>  	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
>  	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> +	struct crypto_acomp *acomp = NULL;
> +
> +	if (IS_ERR_OR_NULL(acomp_ctx))
> +		return 0;
>  
>  	mutex_lock(&acomp_ctx->mutex);
> -	if (!IS_ERR_OR_NULL(acomp_ctx)) {
> -		if (!IS_ERR_OR_NULL(acomp_ctx->req))
> -			acomp_request_free(acomp_ctx->req);
> -		acomp_ctx->req = NULL;
> -		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> -			crypto_free_acomp(acomp_ctx->acomp);
> -		kfree(acomp_ctx->buffer);
> -	}
> +	if (!IS_ERR_OR_NULL(acomp_ctx->req))
> +		acomp_request_free(acomp_ctx->req);
> +	acomp_ctx->req = NULL;
> +	acomp = acomp_ctx->acomp;
> +	acomp_ctx->acomp = NULL;
> +	kfree(acomp_ctx->buffer);
> +	acomp_ctx->buffer = NULL;
>  	mutex_unlock(&acomp_ctx->mutex);
>  
> +	crypto_free_acomp(acomp);
> +
>  	return 0;
>  }
>  
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
[snippet of the syz report]

>>-> #1 (fs_reclaim){+.+.}-{0:0}:
>>       __fs_reclaim_acquire mm/page_alloc.c:3853 [inline]
>>       fs_reclaim_acquire+0x102/0x150 mm/page_alloc.c:3867
>>       might_alloc include/linux/sched/mm.h:318 [inline]
>>       slab_pre_alloc_hook mm/slub.c:4066 [inline]
>>       slab_alloc_node mm/slub.c:4144 [inline]
>>       __kmalloc_cache_node_noprof+0x54/0x420 mm/slub.c:4333
>>       kmalloc_node_noprof include/linux/slab.h:924 [inline]
>>       __get_vm_area_node+0x101/0x2f0 mm/vmalloc.c:3127
>>       __vmalloc_node_range_noprof+0x26a/0x1530 mm/vmalloc.c:3806
>>       __vmalloc_node_noprof mm/vmalloc.c:3911 [inline]
>>       vmalloc_node_noprof+0x6f/0x90 mm/vmalloc.c:4022
>>       crypto_scomp_alloc_scratches crypto/scompress.c:86 [inline]
>>       crypto_scomp_init_tfm+0x122/0x270 crypto/scompress.c:107
>>       crypto_create_tfm_node+0x100/0x320 crypto/api.c:539
>>       crypto_create_tfm crypto/internal.h:120 [inline]
>>       crypto_init_scomp_ops_async+0x5d/0x1d0 crypto/scompress.c:217
>>       crypto_acomp_init_tfm+0x240/0x2e0 crypto/acompress.c:70
>>       crypto_create_tfm_node+0x100/0x320 crypto/api.c:539
>>       crypto_alloc_tfm_node+0x102/0x260 crypto/api.c:640
>>       zswap_cpu_comp_prepare+0xe2/0x420 mm/zswap.c:834
>>       cpuhp_invoke_callback+0x20c/0xa10 kernel/cpu.c:204
>>       cpuhp_issue_call+0x1c0/0x980 kernel/cpu.c:2376
>>       __cpuhp_state_add_instance_cpuslocked+0x1a4/0x3c0 kernel/cpu.c:2438
>>       __cpuhp_state_add_instance+0xd7/0x2e0 kernel/cpu.c:2459
>>       cpuhp_state_add_instance include/linux/cpuhotplug.h:387 [inline]
>>       zswap_pool_create+0x59a/0x7b0 mm/zswap.c:291

Given mutex_init() [1], nobody should take the lock, so the report
sounds false positive.

[1] https://elixir.bootlin.com/linux/v6.14-rc3/source/mm/zswap.c#L289

>>       __zswap_pool_create_fallback mm/zswap.c:359 [inline]
>>       zswap_setup+0x402/0x810 mm/zswap.c:1814
>>       zswap_init+0x2c/0x40 mm/zswap.c:1850
>>       do_one_initcall+0x128/0x700 init/main.c:1257
>>       do_initcall_level init/main.c:1319 [inline]
>>       do_initcalls init/main.c:1335 [inline]
>>       do_basic_setup init/main.c:1354 [inline]
>>       kernel_init_freeable+0x5c7/0x900 init/main.c:1568
>>       kernel_init+0x1c/0x2b0 init/main.c:1457
>>       ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:148
>>       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>>
>>-> #0 (scomp_lock){+.+.}-{4:4}:
