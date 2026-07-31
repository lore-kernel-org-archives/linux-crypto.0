Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2DD445AD2
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2026 15:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785513024; cv=pass; b=M1O9GmNC3hVI+mtqL2hkJgWR7UJWp+hK7w7zm8V7dOprIe6nzBEgqtTnLRCsLr/ccTqFPrhyHETtII+rxrA7i48Jmyw6xZnZ5e6nPAIbLKonk4B8l+sGKV25KQJzxP7EHmuxwhFv5v6I7W8BtiXk0Mw+yvNzEYEWFARYdquyjNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785513024; c=relaxed/simple;
	bh=wDJ6i0l/rp8MHnLXj8ckxdzhlgxUuk0jkQaQCbpjJPQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XCA1zkfM2/lwvzA3bYrlG6n79kCrWYDDMGAAm57eHNlxgxpIUyKj1+Pn3FOY6xzJ9po/+nIVGraa1d5b/XBWYvw6BwbkV4w1S54lds6Q6kKWCkpsIWKTPXVu2NHq8VM9dRUFezhi5XYhhohyAayAtnIIZns00/aubE66eG5z74A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gevm+z5q; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gevm+z5q"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c16794450aeso166735166b.2
        for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2026 08:50:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785513020; cv=none;
        d=google.com; s=arc-20260327;
        b=rLASIOoby6ZAPZYQauc7NDjphlfNNl1BkCzpLmNzfy8NhBjc38Q83bcWWP5j2H4OsJ
         Gjc3sSdj12zelaydOHGNQMUhq/67VoKhYz5fO8pPjX0+SVBT8WipSpbSqOlTRgw0VY2l
         d1G+JslLRAJKaceN/6Tu27ZyvyvxxB8KMQoIGxrGiXONSef74bO7tN3PDG2PHFTz4yFa
         RNe0UuThA0Ny+Yp7HCOeN+25bibNYBIxhD7TAv6B4emV+tO6IYpCCBVUbmX6UcWqLAFI
         mqOWzgClyFSTNJ/YYXaIcymlZmNsMCyPWItXBQP8LYy8n2sloaLZeM/SSO9Knx8auSAY
         yKWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0ah8Z7zZb2aUzlRFQ3wZW7Sv1LOKIqAHqegwScZgE+k=;
        fh=ezSDtiv8FhUvl4wYp1/Z7UIu84M2vMz4H5v+iF0WkfU=;
        b=paelSxaF0MZaiXWtQg+GgyHMMSzTAMEmlN+QJgFKsERHc5aOPKYVz2c2JvGJoHCfq2
         7lfUeWxvXTsSmfg5v3EFfskC16Vmk4Hk7JVekfKiUvaHZhNNd8Nf+UWcv1ZlgQXz8/5r
         7L+srUq3kUtZxe1yPB7Fuip7YQuLwQ60DBhHFLTlWjsjv13MXeWWcafIzRP9sSwoI5Un
         +FMdGF028DoZeVZIQCu7bI1BFisdEs5Nf10nWash/zuZzyQAcg6a+Fc1iDJJnNyX81cr
         C1I0Yrq6linIwe1VuUYkCqRVIFAyUcj0UjFrUU4yH755wuaP0LLWgku5y9H45f0swIn9
         fPGQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785513020; x=1786117820; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0ah8Z7zZb2aUzlRFQ3wZW7Sv1LOKIqAHqegwScZgE+k=;
        b=Gevm+z5qgfXzgEKobpPKVzApy1VBDnHpFvSSMqHHVxMdGS4TJWTZikHzuOKWSEcE4o
         svvxppF6lP+WyEqMOAybOz5K1/FzNVvNNC+Vesr6KCx+BoRVEs6c1hf1d2lQkd976mij
         kY2Ni7f3B3mN8gbBMXiq6S+VxnhwDvOjNWWPHa5yLp9okg9jzoKjw6dmpXnea5UDOMM2
         jX9sFjkgtf+iYy8QXmonpsTDQjZRIfelkNTrOzf8vPnWbFvsrWoLEPg1WmW2h+oPfY6c
         7fM07edqoHij/PyrMjPzAPhxiGZRnahIyOVPCTJsY9MAzdslmEigNDRRIantDjuJlVJt
         ezBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785513020; x=1786117820;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0ah8Z7zZb2aUzlRFQ3wZW7Sv1LOKIqAHqegwScZgE+k=;
        b=S0hzEpdDpvFK6nU1Hwesi5kD++k34RMNV4pE3QKLA3E+oSo84c42XKuGD9efJJf+Ju
         5QFflB0ISzqF4A3JgSKv2QStwQ6aPqh6mvPTK5zffeznIQIEoVih3Wx6sjLmuEwK0RPy
         nU91TBsvmYyqIIqZdwdPEKiDrT+jZRvb+ERdd41pdV17r394VPoKouvfOCQCZ4gOv+cc
         eXZXuWkpdZlH3QYfnvABwrBqD2D6amYufd3ADIg/QqX/tO9PhZHv6yTWTKRDTsdyNeGR
         FS8lEF8NIfipy1h8lYvQVZJ9A+yltOJ0ywzk7nnIXD4MGXPblmsAiwoLHyj0xwTqA6we
         pvxg==
X-Gm-Message-State: AOJu0YwYs8s4K/SMCXY/NtRReR+mK5x+UTwvg7WUBYmiCYgei+0AaZ6q
	gR/cZE0WVgWzw5sHA0tTib4QriYWP0fDgMv1fWcTZ2T4NABWkl7SK8x4cUsSrActe3jTRqCFly2
	ey7A9e3giDFoHyx8EL0a8dnGmUOIxx7k=
X-Gm-Gg: AR+sD13+kVWmOO0t9SfU+Ka5oUoe6I2g1FjmNIROhWxQcMrOxWi0NQeCiaqjfT4C7bv
	MeH/eGaYzYEug3Bjo/mHRKT4bS/I+QSmI2I6opj3OYfK/fgOTVsAqlpDOsNtcJ/89u3JZRczinK
	6Qg/eMGpTi1ugw+Ap5uKk2tjfkaXV2sjvanDojZAXZXVw/FsUHNDOatCT+6Y7tIRwKgF3wV+z8l
	4c/nETp/iOpKFQqBoWHrRbyBUCzmcqy7Xe12qQUQBmGzkgwueQR4JxoCVuoQaM93ZfXpKlm8/ct
	/V4FRiB1kMpBGI9msHDA0xEGpdnB3kZVDBaFEObojOmLeLrsq/uk+nHh3GlUObIX0m5OIA+dMUM
	dU3MQnled+z6uTZHaowWNQAzDt/huPsp1OA==
X-Received: by 2002:a17:906:5ad7:b0:c1f:6f31:2880 with SMTP id
 a640c23a62f3a-c1fe82297c7mr6067766b.50.1785513019508; Fri, 31 Jul 2026
 08:50:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAzp_c6=Ka7q4pZtp_mWB2m_8MK9=z6OZgLiFoXJNTey0soGfw@mail.gmail.com>
In-Reply-To: <CAAzp_c6=Ka7q4pZtp_mWB2m_8MK9=z6OZgLiFoXJNTey0soGfw@mail.gmail.com>
From: dane phillips <greatdanerrrr@gmail.com>
Date: Fri, 31 Jul 2026 08:50:07 -0700
X-Gm-Features: AUfX_myX_1GrFlGQ7SpxB9_HmG2eaEqZo83Ex80VhXNy80yaz_cQ8LH1Pn-TQ8k
Message-ID: <CAAzp_c7vP1om1eHrwhXLZdqURo6vhu9S0J0b3HM8z7hFzmaRpQ@mail.gmail.com>
Subject: Re: KMSAN: use-after-free in sw842_decompress (zswap writeback)
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I got the mechanism wrong in my first mail, correcting before anyone
wastes time on it.

I read the "Uninit was created at" chain as causal. It isn't. That
chain just says where the page had been before the allocator handed
it back out. exit_mmap has nothing to do with it and there's no race
with process exit.

The poison is in the compressed input, not in a swapped-out page:

  next_bits+0xac2         lib/842/842_decompress.c:118
  sw842_decompress+0x1a6  lib/842/842_decompress.c:297
  sw842_decompress+0x11c8 lib/842/842_decompress.c:303

297 is the opcode fetch, 303 uses it.

What I think is happening: zpool_obj_read_begin() copies exactly
entry->length bytes into acomp_ctx->buffer, which is kmalloc'd and
never zeroed, and sw842_decompress reads past entry->length into
whatever was there before. next_bits() does full 8-byte loads while
p->ilen >=3D 8, so entry->length not being a multiple of 8 looks like
the trigger.

So the subject should be something like "KMSAN: uninit-value in
sw842_decompress, over-read of compressed input past entry->length"
rather than use-after-free.

Testing that now with kzalloc_node() for the buffer, plus a sweep of
compressed lengths across residues mod 8. Also rerunning with lzo,
zstd and deflate to see whether this is lib/842 or zswap's bounce
buffer.

Two things I should have mentioned the first time: the kernel was
already tainted W from an unrelated get_xsave_addr warning earlier in
that boot, and the tree was 503 commits past 7.2.0-rc4. I'll redo it
clean on mainline.

More once I have something.

Dane

On Thu, Jul 30, 2026 at 11:20=E2=80=AFAM dane phillips <greatdanerrrr@gmail=
.com> wrote:
>
> Hi,
>
> I am running syzkaller on commit 3dab139d4795 and it
> reported the use-after-free below. The issue occurs when zswap
> writeback decompresses a page that has already been freed by
> process exit.
>
> Kernel version: 7.2.0-rc4-00503-g3dab139d4795
> Config: CONFIG_KMSAN=3Dy, CONFIG_ZSWAP=3Dy, CONFIG_CRYPTO_842=3Dy
>
> The bug manifests in sw842_decompress accessing memory that was
> freed in exit_mmap, while the shrinker is still walking the zswap
> pool.
>
> BUG: KMSAN: use-after-free in sw842_decompress+0x11c8/0x1750
> lib/842/842_decompress.c:303
>  sw842_decompress+0x11c8/0x1750 lib/842/842_decompress.c:303
>  crypto842_sdecompress+0x46/0x60 crypto/842.c:53
>  scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress.h=
:-1
>  scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
>  crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
>  zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
>  zswap_writeback_entry mm/zswap.c:1032 [inline]
>  shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
>  __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
>  list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
>  list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
>  zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
>  do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
>  shrink_slab_memcg mm/shrinker.c:560 [inline]
>  shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
>  shrink_one+0x560/0xc10 mm/vmscan.c:5026
>  shrink_many mm/vmscan.c:5087 [inline]
>  lru_gen_shrink_node mm/vmscan.c:5165 [inline]
>  shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
>  kswapd_shrink_node mm/vmscan.c:7008 [inline]
>  balance_pgdat mm/vmscan.c:7186 [inline]
>  kswapd+0x3029/0x5a50 mm/vmscan.c:7462
>  kthread+0x53f/0x600 kernel/kthread.c:436
>  ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Uninit was stored to memory at:
>  sw842_decompress+0x11c1/0x1750 lib/842/842_decompress.c:303
>  crypto842_sdecompress+0x46/0x60 crypto/842.c:53
>  scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress.h=
:-1
>  scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
>  crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
>  zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
>  zswap_writeback_entry mm/zswap.c:1032 [inline]
>  shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
>  __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
>  list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
>  list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
>  zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
>  do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
>  shrink_slab_memcg mm/shrinker.c:560 [inline]
>  shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
>  shrink_one+0x560/0xc10 mm/vmscan.c:5026
>  shrink_many mm/vmscan.c:5087 [inline]
>  lru_gen_shrink_node mm/vmscan.c:5165 [inline]
>  shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
>  kswapd_shrink_node mm/vmscan.c:7008 [inline]
>  balance_pgdat mm/vmscan.c:7186 [inline]
>  kswapd+0x3029/0x5a50 mm/vmscan.c:7462
>  kthread+0x53f/0x600 kernel/kthread.c:436
>  ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Uninit was stored to memory at:
>  next_bits+0xac2/0xda0 lib/842/842_decompress.c:118
>  sw842_decompress+0x1a6/0x1750 lib/842/842_decompress.c:297
>  crypto842_sdecompress+0x46/0x60 crypto/842.c:53
>  scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress.h=
:-1
>  scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
>  crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
>  zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
>  zswap_writeback_entry mm/zswap.c:1032 [inline]
>  shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
>  __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
>  list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
>  list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
>  zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
>  do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
>  shrink_slab_memcg mm/shrinker.c:560 [inline]
>  shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
>  shrink_one+0x560/0xc10 mm/vmscan.c:5026
>  shrink_many mm/vmscan.c:5087 [inline]
>  lru_gen_shrink_node mm/vmscan.c:5165 [inline]
>  shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
>  kswapd_shrink_node mm/vmscan.c:7008 [inline]
>  balance_pgdat mm/vmscan.c:7186 [inline]
>  kswapd+0x3029/0x5a50 mm/vmscan.c:7462
>  kthread+0x53f/0x600 kernel/kthread.c:436
>  ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Uninit was created at:
>  __free_pages_prepare mm/page_alloc.c:1327 [inline]
>  free_unref_folios+0x280/0x2880 mm/page_alloc.c:3011
>  folios_put_refs+0xb2e/0xba0 mm/swap.c:1057
>  free_pages_and_swap_cache+0x804/0x840 mm/swap_state.c:589
>  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
>  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
>  tlb_flush_mmu+0x92b/0xe90 mm/mmu_gather.c:424
>  zap_pte_range mm/memory.c:1973 [inline]
>  zap_pmd_range mm/memory.c:2020 [inline]
>  zap_pud_range mm/memory.c:2048 [inline]
>  zap_p4d_range mm/memory.c:2069 [inline]
>  __zap_vma_range+0x763f/0x9340 mm/memory.c:2109
>  unmap_vmas+0x440/0x800 mm/memory.c:2178
>  exit_mmap+0x27c/0xac0 mm/mmap.c:1300
>  __mmput+0x134/0x650 kernel/fork.c:1187
>  mmput+0x74/0x90 kernel/fork.c:1210
>  exit_mm+0x2b1/0x4b0 kernel/exit.c:615
>  do_exit+0x9a9/0x3c30 kernel/exit.c:997
>  do_group_exit+0x258/0x390 kernel/exit.c:1152
>  __do_sys_exit_group kernel/exit.c:1163 [inline]
>  __se_sys_exit_group kernel/exit.c:1161 [inline]
>  __x64_sys_exit_group+0x35/0x40 kernel/exit.c:1161
>  x64_sys_call+0x3e6d/0x3ea0 arch/x86/include/generated/asm/syscalls_64.h:=
232
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15d/0x3c0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> CPU: 0 UID: 0 PID: 81 Comm: kswapd0 Tainted: G        W
> 7.2.0-rc4-00503-g3dab139d4795 #9 PREEMPT(lazy)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Ubuntu 26.04 PC (i440FX + PIIX, 1996), BIOS
> 1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>
>
>
> The full syzkaller log is available if needed.  I do not yet have a
> reliable reproducer.
>
> Thanks,
>
> Dane Phillips
