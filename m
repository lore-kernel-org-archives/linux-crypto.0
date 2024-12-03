Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com [209.85.208.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57A11422D4
	for <linux-crypto@vger.kernel.org>; Tue,  3 Dec 2024 04:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733198650; cv=none; b=K3Q9tQwJQ5c9/9GvrvmvsKkGLcg8H/Sqc2vaiA8fAoqkAI0xDyN8l4bCH+E0nj3eolWVAz/AkPgMwBRhJZz3uhi7Iurj2hmGfQrVfP6Z/f9IYJkfRe3DWr5v1fFUfUasZMQ0c9ASTayEkGAZLM7Z35mcxzoz/i4wIup4qoDj3Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733198650; c=relaxed/simple;
	bh=a2QPnlOq0UHJkVOJrCJORZbvcjZoIuUdWl3lwRYtmjY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Jqp2CPkjTAw5FRX8JG8UFszpqnIlliinqKIa6m2zUtT2x7n/OAN+FWcdpB44z/KUFOFjr3klZCg3vAOr3BEq4BCaF0qPejEra8k2POF+OMBEgPc/OD3y19G8iIeHBH+7103RuRJa3qaZ2fP7GD5dOBpHHXmOSOioICyugyIZnxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=apNNONkZ; arc=none smtp.client-ip=209.85.208.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="apNNONkZ"
Received: by mail-lj1-f193.google.com with SMTP id 38308e7fff4ca-2fff2ca7425so21911151fa.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 Dec 2024 20:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733198647; x=1733803447; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sl/nbPLTCWdXKHm5tiAvPO2EvWWMCqp/2+s5XKD3m2Q=;
        b=apNNONkZhVxqDBKylbRqezuHRYhWhQP89HdiIxnssld3EWGxUp2ZFKyD38FK28UsRh
         OCuhiVr/Y7168BNtYVCcWIMpf3J+EGW2c22f+GutgYRIIkuR5O6RnldCxp35R5Wv7KSu
         +QDAOl8RlL4NtVH7vFYNZ+huGfZFj5d++USgA4eMeUtG+jkPCPiN9Y5ulNx4RDlIQUG3
         lUKNKO0DLLQ40U2ej3+z092UR6b/VvMNcAk6PzSAKdj40a7r3nZpwPg/sLTN63kZfn2j
         D8i6y1YMxNskEWeHSXPRKLg+SQ6Pn5yQR2LwCLtpNBzCjgEhbgHCRi1BtgwAJAAk6yeO
         fMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733198647; x=1733803447;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sl/nbPLTCWdXKHm5tiAvPO2EvWWMCqp/2+s5XKD3m2Q=;
        b=rUxMF4ECDt7Cn5Mzi+VrCD2sToy1kBkiBclVg+sJ/aCGDZJcH/UOlk/W7ZAOa2GYJM
         VsKn8zJsy3elhTrB+XxhnAPYfMla4mfHm4XqjShKC/7afgbVruP3JHHncRFq60Jsl8uY
         JFWR7ZywMwc8xcJfaXDDd9q+PAXfMrFwcYZuSYPDCLuZPWU85T43L31QO4z41ghbLxAx
         277Zq/SF50WVuhAFJA7omog/NmgcWmnuMFNTzJPCVy1RCync4S92Bmer7M41Esm7ZXhH
         zjFIZU3LqMn8al+V6uw6Z3Q3rYMZFlN4U1Lnzl5pt3ep+Mg6V+eObZ81uYDUbHYCDHOp
         iYyg==
X-Gm-Message-State: AOJu0Yz5lGJKwdrt+Dt/2vfyL7PxZ17qTPKeCngKv8qqjUo3OBL6yfbP
	umtQxVrWqTGoGvugEv3y1SIZ8vHru2/huEX2jlqFGcHam4QDQSJTvuVh2oJVlouWOzqFx6fUu66
	Wp5qT/NP8YGnbp5K+ieaj6NZ7PKpUwmPt0zkHrg==
X-Gm-Gg: ASbGnctukDSehA/5DIWwTCgqVrS02vIJBe7CXpziUcu7XB0pRZV+16UBQku7CObkTtX
	BzXQAJ+8LHGJzSCoRzpnRZxaLLuGij/Jt
X-Google-Smtp-Source: AGHT+IFxHu/Pfs8yk1dAOaA65oAuwmwE7ua9OA9v/KB59hfGJMAH/6ZZZXc/XiktSAa8wqh5rbSQVc2zQ3Q63YeGCMU=
X-Received: by 2002:a2e:a984:0:b0:2ff:c3d2:b09f with SMTP id
 38308e7fff4ca-30009c72c70mr5172811fa.2.1733198646388; Mon, 02 Dec 2024
 20:04:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: ZachWade <zachwade.k@gmail.com>
Date: Tue, 3 Dec 2024 12:03:55 +0800
Message-ID: <CA+7SXZhXqLzNPzb7cs+6sqVBcjNmSbrEi3PU-gLGpHgMt-xFzw@mail.gmail.com>
Subject: Bug report (maybe fixed, but I'm not sure)
To: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi=EF=BC=8Clinux kernel crypto maintainers
I encountered a report from UAF kasan on the 6.12 kernel,
It happened when executing the ltp example (./testcases/bin/pcrypt_aead01)
https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/cryp=
to/pcrypt_aead01.c
This problem is very easy to reproduce in v6.12

While I was trying to solve it, I pulled the latest code, and now I am
on 6.13-rc1.

This problem no longer occurs, I don't know what happened, and I didn't see=
 any
commits that solved my problem when I looked at the commits. I am
curious whether
this problem has been solved.

Attached is the kasan report:
[   50.449417] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   50.449427] BUG: KASAN: slab-use-after-free in padata_find_next+0x2d6/0x=
3f0
[   50.449443] Read of size 4 at addr ffff88881b726424 by task
kworker/u157:1/775
[   50.449451]
[   50.449457] CPU: 28 UID: 0 PID: 775 Comm: kworker/u157:1 Kdump:
loaded Tainted: G            E      6.12.0+ #35
[   50.449470] Tainted: [E]=3DUNSIGNED_MODULE
[   50.449474] Hardware name: VMware, Inc. VMware20,1/440BX Desktop
Reference Platform, BIOS VMW201.00V.20192059.B64.2207280713 07/28/2022
[   50.449481] Workqueue: pdecrypt_parallel padata_parallel_worker
[   50.449492] Call Trace:
[   50.449496]  <TASK>
[   50.449501]  dump_stack_lvl+0x5d/0x80
[   50.449513]  ? padata_find_next+0x2d6/0x3f0
[   50.449520]  print_report+0x174/0x505
[   50.449532]  ? __pfx_rt_spin_lock+0x10/0x10
[   50.449542]  ? padata_find_next+0x2d6/0x3f0
[   50.449548]  kasan_report+0xe0/0x160
[   50.449559]  ? padata_find_next+0x2d6/0x3f0
[   50.449566]  padata_find_next+0x2d6/0x3f0
[   50.449572]  ? queue_work_on+0x4c/0x80
[   50.449585]  padata_reorder+0x1cc/0x400
[   50.449593]  padata_parallel_worker+0x70/0x160
[   50.449600]  process_one_work+0x646/0xeb0
[   50.449609]  worker_thread+0x619/0x10e0
[   50.449617]  ? __kthread_parkme+0x86/0x140
[   50.449626]  ? __pfx_worker_thread+0x10/0x10
[   50.449633]  kthread+0x28d/0x350
[   50.449640]  ? recalc_sigpending+0x12e/0x1b0
[   50.449651]  ? __pfx_kthread+0x10/0x10
[   50.449658]  ret_from_fork+0x31/0x70
[   50.449668]  ? __pfx_kthread+0x10/0x10
[   50.449675]  ret_from_fork_asm+0x1a/0x30
[   50.449686]  </TASK>
[   50.449690]
[   50.449692] Allocated by task 12827:
[   50.449698]  kasan_save_stack+0x30/0x50
[   50.449705]  kasan_save_track+0x14/0x30
[   50.449711]  __kasan_kmalloc+0xaa/0xb0
[   50.449717]  padata_alloc_pd+0x69/0x9f0
[   50.449722]  padata_alloc_shell+0x82/0x210
[   50.449728]  pcrypt_create+0x13b/0x7a0 [pcrypt]
[   50.449738]  cryptomgr_probe+0x8d/0x230
[   50.449747]  kthread+0x28d/0x350
[   50.449753]  ret_from_fork+0x31/0x70
[   50.449760]  ret_from_fork_asm+0x1a/0x30
[   50.449766]
[   50.449768] Freed by task 154:
[   50.449772]  kasan_save_stack+0x30/0x50
[   50.449778]  kasan_save_track+0x14/0x30
[   50.449784]  kasan_save_free_info+0x3b/0x70
[   50.449793]  __kasan_slab_free+0x4f/0x70
[   50.449800]  kfree+0x119/0x440
[   50.449808]  padata_free_shell+0x262/0x320
[   50.449814]  pcrypt_free+0x43/0x90 [pcrypt]
[   50.449821]  crypto_destroy_instance_workfn+0x79/0xc0
[   50.449832]  process_one_work+0x646/0xeb0
[   50.449837]  worker_thread+0x619/0x10e0
[   50.449842]  kthread+0x28d/0x350
[   50.449848]  ret_from_fork+0x31/0x70
[   50.449855]  ret_from_fork_asm+0x1a/0x30
[   50.449862]
[   50.449863] The buggy address belongs to the object at ffff88881b726400
                which belongs to the cache kmalloc-192 of size 192
[   50.449870] The buggy address is located 36 bytes inside of
                freed 192-byte region [ffff88881b726400, ffff88881b7264c0)
[   50.449878]
[   50.449880] The buggy address belongs to the physical page:
[   50.449884] page: refcount:1 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x81b726
[   50.449892] head: order:1 mapcount:0 entire_mapcount:0
nr_pages_mapped:0 pincount:0
[   50.449898] flags: 0x50000000000040(head|node=3D1|zone=3D2)
[   50.449906] page_type: f5(slab)
[   50.449914] raw: 0050000000000040 ffff88810004c3c0 dead000000000122
0000000000000000
[   50.449922] raw: 0000000000000000 0000000080200020 00000001f5000000
0000000000000000
[   50.449928] head: 0050000000000040 ffff88810004c3c0
dead000000000122 0000000000000000
[   50.449934] head: 0000000000000000 0000000080200020
00000001f5000000 0000000000000000
[   50.449939] head: 0050000000000001 ffffea00206dc981
ffffffffffffffff 0000000000000000
[   50.449945] head: 0000000000000002 0000000000000000
00000000ffffffff 0000000000000000
[   50.449948] page dumped because: kasan: bad access detected
[   50.449951]
[   50.449953] Memory state around the buggy address:
[   50.449957]  ffff88881b726300: fa fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[   50.449963]  ffff88881b726380: fb fb fb fb fb fb fb fb fc fc fc fc
fc fc fc fc
[   50.449967] >ffff88881b726400: fa fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[   50.449971]                                ^
[   50.449975]  ffff88881b726480: fb fb fb fb fb fb fb fb fc fc fc fc
fc fc fc fc
[   50.449979]  ffff88881b726500: fa fb fb fb fb fb fb fb fb fb fb fb
fb fb fb fb
[   50.449982] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
