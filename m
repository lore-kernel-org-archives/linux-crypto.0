Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058772517AF
	for <linux-crypto@vger.kernel.org>; Sun,  2 Aug 2026 06:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785651781; cv=pass; b=uf32dYFwcQRCb++T7RZip0YGT0quM08p1f6kPPKmMxFDFboO+GX2WJ0zEf4rv7BiDXHb4A6urlEczlg/a3FQbkiPBGwHYT1lcpBoQm3fIxgG/HL/9g+S6Qe0aBl4Tcnj4IsIoimNxxmflTc64SlFjDm45AwKwSLaabOj/IUdoes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785651781; c=relaxed/simple;
	bh=jPvVmJh8UgmPbn909Thb03H/a1RqCcM5wKmiVnhEVE0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MfxQT4RSfgcg/1I1Vx1JHaKiThXkKy3ZjJanx67uVc+h0Yp9gKWaQpUxuB60ykLfoxfC9G6r/vIDcuhWs4KXJ3wJVADqMqPMKCWf8QfWARu3slW/2JeQGqVoD0xB5TfAH7ekZ2PJvVeSIOeM490tZjU7cdxO9KspxWBiXCToWUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sZ15pTPF; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sZ15pTPF"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso284706566b.1
        for <linux-crypto@vger.kernel.org>; Sat, 01 Aug 2026 23:22:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785651778; cv=none;
        d=google.com; s=arc-20260327;
        b=KIXY0yUWypYvg3rDnmMb+2yyjuD510Yb4XVxyK9/t9tsYbP5dkhmUnAQE9KuD28Cry
         0Tbv0UGCYQpf0oy12UiD8xxJkwaz8JyZ7ijlxt2kJMB3evGzx0pQpkIKhY5kfWyDcy9E
         tPuZp3vWEuhL0SXbx6KlBKS0eFwOnlfHbA7asUmDo+39nivZSwuamgiHQvmLPOPkplR1
         ep/ls9gYuWl28jawdc1WNFf18QQLLLwdDI6c8/AqZUviPnhKptAbA+fJ9hQNtGkxHw4c
         OCExqhkqF+mR1WK6KMibkj+m+CZJN3xSeuefOnWS0buqkq1WZmMWOyJnkWqFe+pfjU5x
         Ot0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=omCTIM7JwQ+xpF/19ksMUGGtqddvj62Yg4nt02jHUKQ=;
        fh=zRky0CVGDrvURZP3CXQVSlX9cS/C1NMCLDoOL54VLzo=;
        b=lzyB5ufKOdikCXfb2wyYc24/t4yjTi6qY7kcNzYwfr3shSEgdMvqOiegGMvdsyOiRL
         j3WVg1/aDxW4J7/cDxwpLVTcm40dKOaLkDfqYYChlpT/9Fin4ikUr99G+J0lbv2cY5HL
         NkvMxZocrgSmozzsa4qeJpoPpZSVCqf4GQMS89NSj/FtrwyZ47V4nRDaGup7ChIXWMmg
         FJWGHT6V7Mw0Tj51j5ONwkQzwEQ+10/kPIEXvStub6++QTRYTFFhKwQ/flAuUIYeLL22
         WiO2u8ROHGOGEvYfRNDVmxAO/jMMpWi70Pvcc3xDZ9SuAtpDlf/+6l3lhDumxs2+BApV
         2Igw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785651778; x=1786256578; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=omCTIM7JwQ+xpF/19ksMUGGtqddvj62Yg4nt02jHUKQ=;
        b=sZ15pTPFEMTkwLRhirbDEg1zhcuQKOQP5MtdZXrYr7WqIaMS3VMjM77UiqsATtoNa2
         n93ywq48/t4qMRbog0bU0JJ6yPMCt8uN1Ri5S9AGy69p266tYIpFu5F4LRsWSsjzjtVP
         yat/Sgs0m0rMrzu43g7RuQ8zNcLiVwWBlFBKgQjMoF+6W6n8E8OJrq5P/6ZGlmomg6Gh
         g9zJb/VqKXv287B4vzps17T3zwpSALNdWTFeeFnCHzghe8Pp6/rItjkbMZTnTCTshvfs
         PQieMEX8u73HuWjRO8tmxf6icbCDIPCHbKsnMK+L56ztBzAjmljFVsam5QzSuoPhZiOy
         rFaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785651778; x=1786256578;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=omCTIM7JwQ+xpF/19ksMUGGtqddvj62Yg4nt02jHUKQ=;
        b=iWxGvR+Nm+27aIAvwfm+9OFx7IzBLs9KfVBnirb/DE1DgsBVKAtPP9jgM8GusGCeqP
         Lv/VVeh9I9sa9dk0KOOczdUvQChM3BFje3HR1WM+36FTaIMD8ldQKv4/82B14Ke0idKe
         Ff2sLWR7pQm8em5iqVTUFoXM4UoPD9uCJkEovdRxjS+xnQIS7OqZxXrSVPQS9BZjhlHk
         8CiWrPOWZ22ve3mH4o8mouftuVcGzi6Pm5DCVxKn4xzjKHK8tlJncUl0WIp9yAl2ONvz
         ljvEXmlWtvG+e4Q0VTEXWSDQJEoUe1/ZyOFRi0hskWYUsF1soOX/GpO0JqJmuOq6ruW1
         JetQ==
X-Gm-Message-State: AOJu0Yx8A0fGGzyTtLBubwsBwt6NkTsyChBHgXCRQ/n3TG0OIGTxCzvp
	KLefA6DjxCcXxnyuPuTcGh6FPYKl4+EXaSsCxWY+1q6wMn6i/cFyjB+hnSjGbYNp6jarPbDYpN8
	SpdgWkNNch57x8m+0D6g1+PaKcJSs2z57PSk9
X-Gm-Gg: AR+sD13fEcxh7WNaxsD7lYIlDCSn2aOnkTTLI2zGjnaCCRcsfRu6ZMfV4IqZKOoccNb
	M9BSoUURqKek4ShJhlaT8dRBYnaHDOpHzHzEHEYBlJ0aJi79VsyQEdeotzfCYklvVNZdEXO9Kqa
	t3Q6hmDSOLXKn/lq7r4iN/BoG7LjKk1Od2L185Ev8WhXJlPEYyv+bK0HIi8XIO1O3ThEG6kkemK
	jO/M1fZOYJsi07EHsbOarZMCzSkgD00hj2pnZf57q2aLFMO+r7Cyyg6bDrlrrhRuRByfk946exp
	hisj+zdV7odVJa1DgM2+9Y3cPuMM6H8VjSMV1XGiA1kJgUH6ZcXOdaoIjD3u2uY89u4iR14XPid
	5gEZxjgiWmvURccmI+DjuNa9L6KGmfXnGsg==
X-Received: by 2002:a17:906:aed1:b0:c16:5f28:4575 with SMTP id
 a640c23a62f3a-c1fe816f6ccmr372902566b.31.1785651777970; Sat, 01 Aug 2026
 23:22:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAzp_c6=Ka7q4pZtp_mWB2m_8MK9=z6OZgLiFoXJNTey0soGfw@mail.gmail.com>
 <CAAzp_c7vP1om1eHrwhXLZdqURo6vhu9S0J0b3HM8z7hFzmaRpQ@mail.gmail.com>
In-Reply-To: <CAAzp_c7vP1om1eHrwhXLZdqURo6vhu9S0J0b3HM8z7hFzmaRpQ@mail.gmail.com>
From: dane phillips <greatdanerrrr@gmail.com>
Date: Sat, 1 Aug 2026 23:22:46 -0700
X-Gm-Features: AUfX_mxM6Wb7qcetiLeINzpP6NZsY50K1cIPOOjcgKPFG_xSf0ijrNSb4Qvk8cI
Message-ID: <CAAzp_c4_4tVB68P_2EoXP4nLVa7npiHobmTHnjP-aCh0RRKHRA@mail.gmail.com>
Subject: Re: KMSAN: use-after-free in sw842_decompress (zswap writeback)
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

 Retracting both of my earlier mails in this thread. There is no bug
here,
 in zswap or in lib/842's input handling, and nobody should spend time
on it.

I could not reproduce the report; that trace should not have gone out
and
I'm sorry for the noise.

On Fri, Jul 31, 2026 at 8:50=E2=80=AFAM dane phillips <greatdanerrrr@gmail.=
com> wrote:
>
> I got the mechanism wrong in my first mail, correcting before anyone
> wastes time on it.
>
> I read the "Uninit was created at" chain as causal. It isn't. That
> chain just says where the page had been before the allocator handed
> it back out. exit_mmap has nothing to do with it and there's no race
> with process exit.
>
> The poison is in the compressed input, not in a swapped-out page:
>
>   next_bits+0xac2         lib/842/842_decompress.c:118
>   sw842_decompress+0x1a6  lib/842/842_decompress.c:297
>   sw842_decompress+0x11c8 lib/842/842_decompress.c:303
>
> 297 is the opcode fetch, 303 uses it.
>
> What I think is happening: zpool_obj_read_begin() copies exactly
> entry->length bytes into acomp_ctx->buffer, which is kmalloc'd and
> never zeroed, and sw842_decompress reads past entry->length into
> whatever was there before. next_bits() does full 8-byte loads while
> p->ilen >=3D 8, so entry->length not being a multiple of 8 looks like
> the trigger.
>
> So the subject should be something like "KMSAN: uninit-value in
> sw842_decompress, over-read of compressed input past entry->length"
> rather than use-after-free.
>
> Testing that now with kzalloc_node() for the buffer, plus a sweep of
> compressed lengths across residues mod 8. Also rerunning with lzo,
> zstd and deflate to see whether this is lib/842 or zswap's bounce
> buffer.
>
> Two things I should have mentioned the first time: the kernel was
> already tainted W from an unrelated get_xsave_addr warning earlier in
> that boot, and the tree was 503 commits past 7.2.0-rc4. I'll redo it
> clean on mainline.
>
> More once I have something.
>
> Dane
>
> On Thu, Jul 30, 2026 at 11:20=E2=80=AFAM dane phillips <greatdanerrrr@gma=
il.com> wrote:
> >
> > Hi,
> >
> > I am running syzkaller on commit 3dab139d4795 and it
> > reported the use-after-free below. The issue occurs when zswap
> > writeback decompresses a page that has already been freed by
> > process exit.
> >
> > Kernel version: 7.2.0-rc4-00503-g3dab139d4795
> > Config: CONFIG_KMSAN=3Dy, CONFIG_ZSWAP=3Dy, CONFIG_CRYPTO_842=3Dy
> >
> > The bug manifests in sw842_decompress accessing memory that was
> > freed in exit_mmap, while the shrinker is still walking the zswap
> > pool.
> >
> > BUG: KMSAN: use-after-free in sw842_decompress+0x11c8/0x1750
> > lib/842/842_decompress.c:303
> >  sw842_decompress+0x11c8/0x1750 lib/842/842_decompress.c:303
> >  crypto842_sdecompress+0x46/0x60 crypto/842.c:53
> >  scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress=
.h:-1
> >  scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
> >  crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
> >  zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
> >  zswap_writeback_entry mm/zswap.c:1032 [inline]
> >  shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
> >  __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
> >  list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
> >  list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
> >  zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
> >  do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
> >  shrink_slab_memcg mm/shrinker.c:560 [inline]
> >  shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
> >  shrink_one+0x560/0xc10 mm/vmscan.c:5026
> >  shrink_many mm/vmscan.c:5087 [inline]
> >  lru_gen_shrink_node mm/vmscan.c:5165 [inline]
> >  shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
> >  kswapd_shrink_node mm/vmscan.c:7008 [inline]
> >  balance_pgdat mm/vmscan.c:7186 [inline]
> >  kswapd+0x3029/0x5a50 mm/vmscan.c:7462
> >  kthread+0x53f/0x600 kernel/kthread.c:436
> >  ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >
> > Uninit was stored to memory at:
> >  sw842_decompress+0x11c1/0x1750 lib/842/842_decompress.c:303
> >  crypto842_sdecompress+0x46/0x60 crypto/842.c:53
> >  scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress=
.h:-1
> >  scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
> >  crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
> >  zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
> >  zswap_writeback_entry mm/zswap.c:1032 [inline]
> >  shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
> >  __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
> >  list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
> >  list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
> >  zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
> >  do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
> >  shrink_slab_memcg mm/shrinker.c:560 [inline]
> >  shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
> >  shrink_one+0x560/0xc10 mm/vmscan.c:5026
> >  shrink_many mm/vmscan.c:5087 [inline]
> >  lru_gen_shrink_node mm/vmscan.c:5165 [inline]
> >  shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
> >  kswapd_shrink_node mm/vmscan.c:7008 [inline]
> >  balance_pgdat mm/vmscan.c:7186 [inline]
> >  kswapd+0x3029/0x5a50 mm/vmscan.c:7462
> >  kthread+0x53f/0x600 kernel/kthread.c:436
> >  ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >
> > Uninit was stored to memory at:
> >  next_bits+0xac2/0xda0 lib/842/842_decompress.c:118
> >  sw842_decompress+0x1a6/0x1750 lib/842/842_decompress.c:297
> >  crypto842_sdecompress+0x46/0x60 crypto/842.c:53
> >  scomp_acomp_comp_decomp+0xa49/0x1120 include/crypto/internal/scompress=
.h:-1
> >  scomp_acomp_decompress+0x30/0x40 crypto/scompress.c:283
> >  crypto_acomp_decompress+0x5c4/0xe50 crypto/acompress.c:297
> >  zswap_decompress+0x4ba/0xcc0 mm/zswap.c:952
> >  zswap_writeback_entry mm/zswap.c:1032 [inline]
> >  shrink_memcg_cb+0x78f/0xda0 mm/zswap.c:1147
> >  __list_lru_walk_one+0x49a/0xde0 mm/list_lru.c:362
> >  list_lru_walk_one+0x5c/0x70 mm/list_lru.c:399
> >  list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
> >  zswap_shrinker_scan+0x11f/0x290 mm/zswap.c:1181
> >  do_shrink_slab+0x736/0x1460 mm/shrinker.c:443
> >  shrink_slab_memcg mm/shrinker.c:560 [inline]
> >  shrink_slab+0xb70/0x14c0 mm/shrinker.c:638
> >  shrink_one+0x560/0xc10 mm/vmscan.c:5026
> >  shrink_many mm/vmscan.c:5087 [inline]
> >  lru_gen_shrink_node mm/vmscan.c:5165 [inline]
> >  shrink_node+0x47a5/0x5b70 mm/vmscan.c:6154
> >  kswapd_shrink_node mm/vmscan.c:7008 [inline]
> >  balance_pgdat mm/vmscan.c:7186 [inline]
> >  kswapd+0x3029/0x5a50 mm/vmscan.c:7462
> >  kthread+0x53f/0x600 kernel/kthread.c:436
> >  ret_from_fork+0x20f/0x8d0 arch/x86/kernel/process.c:158
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >
> > Uninit was created at:
> >  __free_pages_prepare mm/page_alloc.c:1327 [inline]
> >  free_unref_folios+0x280/0x2880 mm/page_alloc.c:3011
> >  folios_put_refs+0xb2e/0xba0 mm/swap.c:1057
> >  free_pages_and_swap_cache+0x804/0x840 mm/swap_state.c:589
> >  __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
> >  tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
> >  tlb_flush_mmu_free mm/mmu_gather.c:417 [inline]
> >  tlb_flush_mmu+0x92b/0xe90 mm/mmu_gather.c:424
> >  zap_pte_range mm/memory.c:1973 [inline]
> >  zap_pmd_range mm/memory.c:2020 [inline]
> >  zap_pud_range mm/memory.c:2048 [inline]
> >  zap_p4d_range mm/memory.c:2069 [inline]
> >  __zap_vma_range+0x763f/0x9340 mm/memory.c:2109
> >  unmap_vmas+0x440/0x800 mm/memory.c:2178
> >  exit_mmap+0x27c/0xac0 mm/mmap.c:1300
> >  __mmput+0x134/0x650 kernel/fork.c:1187
> >  mmput+0x74/0x90 kernel/fork.c:1210
> >  exit_mm+0x2b1/0x4b0 kernel/exit.c:615
> >  do_exit+0x9a9/0x3c30 kernel/exit.c:997
> >  do_group_exit+0x258/0x390 kernel/exit.c:1152
> >  __do_sys_exit_group kernel/exit.c:1163 [inline]
> >  __se_sys_exit_group kernel/exit.c:1161 [inline]
> >  __x64_sys_exit_group+0x35/0x40 kernel/exit.c:1161
> >  x64_sys_call+0x3e6d/0x3ea0 arch/x86/include/generated/asm/syscalls_64.=
h:232
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0x15d/0x3c0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >
> > CPU: 0 UID: 0 PID: 81 Comm: kswapd0 Tainted: G        W
> > 7.2.0-rc4-00503-g3dab139d4795 #9 PREEMPT(lazy)
> > Tainted: [W]=3DWARN
> > Hardware name: QEMU Ubuntu 26.04 PC (i440FX + PIIX, 1996), BIOS
> > 1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> >
> >
> >
> > The full syzkaller log is available if needed.  I do not yet have a
> > reliable reproducer.
> >
> > Thanks,
> >
> > Dane Phillips
