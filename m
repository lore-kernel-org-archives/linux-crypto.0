Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EB239A05C
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 18:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785435669; cv=pass; b=oMxgyyOcW3ZdgvSx6fsX4HCjpPab9Frb8PW517kqZLNN9Xz1D0mE4XIrupfaY4VBnCxaW18IFu6SbozVyBTBLaHvABYeFO3HbTTOQD9bUy4M/dSqpVPZQ5npez87T5woMzvwRRNgHTLq6sNiNrVAdq74c6HiO2eDjNf0aq8Gi58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785435669; c=relaxed/simple;
	bh=Z79FUWV5sacGMIJcAHljIdwuRIPiSgzpuBxYRrbP8hQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=DJOgnlUssjKTwo+vq5wETAdfV+oKcyyR7f1mew2RqdR7g4h0qIuvGsUv6sgq5UcRl3RoSe/PUjpCneya5wFcYs2IN/vJySbSPizl7XggnSUh4C0R4GxrJ+KJXnv0+cg7P1YHvc3SVG/xIiHdWiuE9aGWXkrCS/DeZRhPRGPpz2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QJQAA3h1; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QJQAA3h1"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-69ff40d9cbcso234818a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 11:21:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785435665; cv=none;
        d=google.com; s=arc-20260327;
        b=s3Xl7euBY0yIdsjz8xI0lVpqkQit5rW/hcS6PeXev2tFX975HqcoAp27clwwOS9xxK
         iNlx9NPdnrjhdqZ7wlLhUtJmVR66V2zshKUnOR5eGXidMylSHMddon2woqSMm8/T1rfB
         QTpCKmgt+wBPq+PwSdXAKxLJp19fG1Kb9gA87O5q+y32roOb0jXdm1fwYlDby6qqm5Og
         YkqLrPIkBkq9ksTtT1q5FaG2GNFJlAE3uQtgM4DRIARlnA6G7fGreEJksz5n524lXZCA
         A85JWa7mFCUx4VwVkTdfIn/OUeoGIwWNp0zNBHwL0s3lgXvcAQTx820mD5/N5s2ZtV0x
         PCtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=OYKbwERx20dbeiIyUIlnTCgasqUg2SfAVLY7xvX8KUM=;
        fh=ezSDtiv8FhUvl4wYp1/Z7UIu84M2vMz4H5v+iF0WkfU=;
        b=ZYx9jLkuyTYTqvplpBDWH78rOYcPS26DPGpxR6j3//tTTvPjB545ipwt18Go0BCKqG
         6H3jnYjM+dBhOqCr2z+HOR1GPds8eo+JiTlxiloShGfeH7IjVhTQcDS5lt11tfr/UXHI
         pnXZP1qLPFRAt8qDEwtXe3ehw1gOi6NpaH5cx2rFskQxrl3DnsFTPYm0QsapyKqFjXX/
         7umX97L++c5opE89AL93+LcmuXl61jG3j1NTYVh5vs7QLn670t0BVMBh0Ke+HT+bWxgR
         YjTl4ZFPFw5NezNBApmsYWzc0vCl7kKpiGyzlZEFyb3rZ7HyT55kF4G9R9q62IvJpor2
         rLkw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785435665; x=1786040465; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OYKbwERx20dbeiIyUIlnTCgasqUg2SfAVLY7xvX8KUM=;
        b=QJQAA3h1XpLXlRh4JX87n50mUDMjhXO2ETbMm+11uhAtoycyWGlZOnPVWHBX+SRD7W
         6LR5RAWHl0u49AJvmVLHOH9OKfLffGyooWmpnuqkyR7VDXBjTxM84cCXj+Y5fhWXihIb
         M/a71qNd9ayiSCcS0UFMTSY90htrPDYVxsvu0FyK58mV/q/IFEjSuVd8B3vwONa8PSUf
         UBAyC4iwXLvsibNUOFSbfvEDwp4JJVE9sN5tlCAp2flEVtXJ0RuSNa/spRnEFtizNdaC
         piicQQDaTF0d8zrN33sGuKxrjjBAUAlWAtr2J2RvSf6qvKq93g6IvL+1TpJl/mQUyXig
         iz+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785435665; x=1786040465;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OYKbwERx20dbeiIyUIlnTCgasqUg2SfAVLY7xvX8KUM=;
        b=rgqN+a51QuHp8iidvYILKOssmQ3U47qmnndEpFXthcrp3GkDeokGkxoSzEK7kHMtMG
         w7P9y9Xx/j/5o50zfyZkGVnLat09y5mxfB4JO3wU2UeSnfPLkQ3FDDh7aGaTkHGdAKVA
         EQyMwA5/OJbbniljad0/0vuDz8v+Sk1RN+o+2cviXXd++FdJ27hcqoJI9LHoUg031A63
         XKwiDXYDv5l/KBqgmxpH7ns+9gQ22AK+act9Ex3h43H1jBVGlUVDgfhwNn4NnwQdnr2h
         psIexjCPj8YSp3M4jPQY1JlAfA81Jz+fc5Un48GtEOgo+I6xal/MmuxYrrs/Ai9220M9
         jX3Q==
X-Gm-Message-State: AOJu0YxYY/QNU/IlW+3xH08ie17mp2NWA6DY94DiIKiigGLebVEfMORU
	LiKoMK5hqDWeRwMQ4Fv56JUKjokgupjn0IBTT5K4EiYJoO9x3CxWrCGfirfVB2MeNdPCr/ZCPkf
	t2wRvAl0z1hzKrX2tEaTfwfqiWigF6c0=
X-Gm-Gg: AR+sD11f4N6/QLGNLyBvoc8Zsu+knEzDr4MXXZc57zsrZ6gDvN8LyZ/OnMgHoGPVrvx
	TeHLiomjgZGuZrzN/+fngXniTFBZ9IIrh9SS7OZ02wMpuXtXOYeb6UVkV1V5OsbOi1eR7N2AiLO
	aTpSsi9bj8Prt5WjKUJ4VR/cFa4hupUcbOfkXt46014czYWk6d5w/Smq1g7FI97juSH2v2r12HO
	WHO9SD+qiNAZT4u/DsnUuX/OgBw2O07FKJqNDhLkaJQZiA03yKDYBtKABbzghSIxBkUeAe9AGk2
	bZ90mMkvfkcT97Ll8hLmMTNbcFRPXwLKDOz1vLJDD7GY8VMe2IvqWHeq8fIX6My48g7DchUUmex
	9q71y4iwbc7oDePQO4Q+ZiQEXbqO3gbWDZ8UkS+45LASy
X-Received: by 2002:a05:6402:4314:b0:69e:98a8:4f05 with SMTP id
 4fb4d7f45d1cf-6a07b843800mr1910619a12.34.1785435665064; Thu, 30 Jul 2026
 11:21:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: dane phillips <greatdanerrrr@gmail.com>
Date: Thu, 30 Jul 2026 11:20:53 -0700
X-Gm-Features: AUfX_mxjp7OusIdtZwC51kJm4H-r48e75MMq_eLAX4lRvFFoqtXoaP0UKEaCq6g
Message-ID: <CAAzp_c6=Ka7q4pZtp_mWB2m_8MK9=z6OZgLiFoXJNTey0soGfw@mail.gmail.com>
Subject: KMSAN: use-after-free in sw842_decompress (zswap writeback)
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"

Hi,

I am running syzkaller on commit 3dab139d4795 and it
reported the use-after-free below. The issue occurs when zswap
writeback decompresses a page that has already been freed by
process exit.

Kernel version: 7.2.0-rc4-00503-g3dab139d4795
Config: CONFIG_KMSAN=y, CONFIG_ZSWAP=y, CONFIG_CRYPTO_842=y

The bug manifests in sw842_decompress accessing memory that was
freed in exit_mmap, while the shrinker is still walking the zswap
pool.

BUG: KMSAN: use-after-free in sw842_decompress+0x11c8/0x1750
lib/842/842_decompress.c:303
 sw842_decompress+0x11c8/0x1750 lib/842/842_decompress.c:303
 crypto842_sdecompress+0x46/0x60 crypto/842.c:53
 scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress.h:-1
 scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
 crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
 zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
 zswap_writeback_entry mm/zswap.c:1032 [inline]
 shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
 __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
 list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
 list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
 zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
 do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
 shrink_slab_memcg mm/shrinker.c:560 [inline]
 shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
 shrink_one+0x560/0xc10 mm/vmscan.c:5026
 shrink_many mm/vmscan.c:5087 [inline]
 lru_gen_shrink_node mm/vmscan.c:5165 [inline]
 shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
 kswapd_shrink_node mm/vmscan.c:7008 [inline]
 balance_pgdat mm/vmscan.c:7186 [inline]
 kswapd+0x3029/0x5a50 mm/vmscan.c:7462
 kthread+0x53f/0x600 kernel/kthread.c:436
 ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was stored to memory at:
 sw842_decompress+0x11c1/0x1750 lib/842/842_decompress.c:303
 crypto842_sdecompress+0x46/0x60 crypto/842.c:53
 scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress.h:-1
 scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
 crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
 zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
 zswap_writeback_entry mm/zswap.c:1032 [inline]
 shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
 __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
 list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
 list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
 zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
 do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
 shrink_slab_memcg mm/shrinker.c:560 [inline]
 shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
 shrink_one+0x560/0xc10 mm/vmscan.c:5026
 shrink_many mm/vmscan.c:5087 [inline]
 lru_gen_shrink_node mm/vmscan.c:5165 [inline]
 shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
 kswapd_shrink_node mm/vmscan.c:7008 [inline]
 balance_pgdat mm/vmscan.c:7186 [inline]
 kswapd+0x3029/0x5a50 mm/vmscan.c:7462
 kthread+0x53f/0x600 kernel/kthread.c:436
 ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was stored to memory at:
 next_bits+0xac2/0xda0 lib/842/842_decompress.c:118
 sw842_decompress+0x1a6/0x1750 lib/842/842_decompress.c:297
 crypto842_sdecompress+0x46/0x60 crypto/842.c:53
 scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress.h:-1
 scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
 crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
 zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
 zswap_writeback_entry mm/zswap.c:1032 [inline]
 shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
 __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
 list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
 list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
 zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
 do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
 shrink_slab_memcg mm/shrinker.c:560 [inline]
 shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
 shrink_one+0x560/0xc10 mm/vmscan.c:5026
 shrink_many mm/vmscan.c:5087 [inline]
 lru_gen_shrink_node mm/vmscan.c:5165 [inline]
 shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
 kswapd_shrink_node mm/vmscan.c:7008 [inline]
 balance_pgdat mm/vmscan.c:7186 [inline]
 kswapd+0x3029/0x5a50 mm/vmscan.c:7462
 kthread+0x53f/0x600 kernel/kthread.c:436
 ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was created at:
 __free_pages_prepare mm/page_alloc.c:1327 [inline]
 free_unref_folios+0x280/0x2880 mm/page_alloc.c:3011
 folios_put_refs+0xb2e/0xba0 mm/swap.c:1057
 free_pages_and_swap_cache+0x804/0x840 mm/swap_state.c:589
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
 tlb_flush_mmu+0x92b/0xe90 mm/mmu_gather.c:424
 zap_pte_range mm/memory.c:1973 [inline]
 zap_pmd_range mm/memory.c:2020 [inline]
 zap_pud_range mm/memory.c:2048 [inline]
 zap_p4d_range mm/memory.c:2069 [inline]
 __zap_vma_range+0x763f/0x9340 mm/memory.c:2109
 unmap_vmas+0x440/0x800 mm/memory.c:2178
 exit_mmap+0x27c/0xac0 mm/mmap.c:1300
 __mmput+0x134/0x650 kernel/fork.c:1187
 mmput+0x74/0x90 kernel/fork.c:1210
 exit_mm+0x2b1/0x4b0 kernel/exit.c:615
 do_exit+0x9a9/0x3c30 kernel/exit.c:997
 do_group_exit+0x258/0x390 kernel/exit.c:1152
 __do_sys_exit_group kernel/exit.c:1163 [inline]
 __se_sys_exit_group kernel/exit.c:1161 [inline]
 __x64_sys_exit_group+0x35/0x40 kernel/exit.c:1161
 x64_sys_call+0x3e6d/0x3ea0 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15d/0x3c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 81 Comm: kswapd0 Tainted: G        W
7.2.0-rc4-00503-g3dab139d4795 #9 PREEMPT(lazy)
Tainted: [W]=WARN
Hardware name: QEMU Ubuntu 26.04 PC (i440FX + PIIX, 1996), BIOS
1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
=====================================================



The full syzkaller log is available if needed.  I do not yet have a
reliable reproducer.

Thanks,

Dane Phillips
