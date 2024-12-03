Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com [209.85.208.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429EF154430
	for <linux-crypto@vger.kernel.org>; Tue,  3 Dec 2024 06:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733206685; cv=none; b=Git/3r6zX/yoDQW4o+yu1iHSRWAwgL2DR32rlupu9snJzCMqLb+Ezq0w3TQb584GtJIPoT0+dnYktKa6LH+/veUlAke1d23q4H1yal8xlNYmYY989GJYb08M0dZvFQobDrNuxx8+m/jr8V6gYkkVLkHjMKUAYTHmXA814iVf4KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733206685; c=relaxed/simple;
	bh=GNHAzOqZt+XgCZwJvuHft74As1kozhXImhZp8fAvplw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Xfv8E5Y6RGEX2IH40aq87Ejzv7V0PcQ1ScZdw80nm9SNFjFsKELeu58gRldIrt3stnzILMFNqLGYm5jkLnD8mrWQU7AE9iH9M6Oibcjd4ykaBOYNiBjuLKWHJ+kjBLLz07XHe6nZsTxTMpw++G0EdzlY8bkPZ8xBuOPzzN28RgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fLTtA9J4; arc=none smtp.client-ip=209.85.208.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLTtA9J4"
Received: by mail-lj1-f193.google.com with SMTP id 38308e7fff4ca-2ffc3f2b3a9so66333541fa.1
        for <linux-crypto@vger.kernel.org>; Mon, 02 Dec 2024 22:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733206681; x=1733811481; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f/fAD11EqOY3uxSQWBLMJaMdbxzX6wXESqEAlvtc/a8=;
        b=fLTtA9J4Sxru1eIHSJ/LKQCd0MoqcpvcZLnRSsvGOwg8i1qIpt3N/BZfZ7XoFAJk1R
         zQhvdMi1RY0FkdQdZllF54BklnDnZCtIGdm+NXLoXJmGQXJvbOX5IEZIeMS1p/Quz2zf
         0DrARpddGuQEr2WuV8GEGLDD5XAEBcDecba6aebcXOVPFCUnwQOEzNqC9SvOy8Mjgwio
         wjH+/C7cykiaJ5saklpbJFUOo6vbsw72kXSnAFkYxCzHLAMJYOCnVP2vmR2U2tCiubw1
         gWTguLGJXz78ly2Ub9JJ4MfXY4mSZ8JN98sXr/m0tR4Uql5g8J98/+OFd6NAUTaCXnT/
         3s/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733206681; x=1733811481;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f/fAD11EqOY3uxSQWBLMJaMdbxzX6wXESqEAlvtc/a8=;
        b=m30AO/wro5/c9QIKmPfsFPh14EhxEKFjOMwFA1yHKl6W+uUdYkxFct/stRy5PIrRL6
         Qu++J74KPen+aT1yw7Kl6GRs5aKIetUnWdo/UJkWL7/7Buq/zJ3Bw34V5GtCQb7S1SUX
         E0jXVv/WqotW3PhepKRpry5OUw1NuNl5QRLtens8UNQ9P5KxIHM5aexNuNNRzvAB+fnR
         prEm2ImpVtmJPvH/XFVfiy/KrNHnevAab/s3CUxKhJaNmb8RuhtC3aYSITbWBVahzpJd
         e4+SFAJ2YX/Ao0xpiQjRTsodkbTUBW4JKEkvxCSzWDKqVdYDDCfdP+0R+0tkUPnDnP78
         g8+Q==
X-Gm-Message-State: AOJu0Yxj44Wp4kq20BAH03GwaRHFPgWVMEbqCvIlY0rCnzea11JUaKup
	dfy0A80977A44cvTbZrLCvCCVkh2XnJkgKZyEPU4B3uSu5Emka9JEumEGuOiAdghUve0fTUWmJC
	pyb8tl98hsoGVQn8ynY159Gz0Fl22Z/NKTCpn0Q==
X-Gm-Gg: ASbGncuxO2LBhaF6AOeY8D4szfx6JMqfWC7RaNWtG5p2Ce3hrqzl8nu5xtiMeeKOrPE
	15RymtfftB1MbqDDz+TyS2BpdKRug1VO/
X-Google-Smtp-Source: AGHT+IH/XZyWbiOi/jbw/D2iWzCyy+GSSCChhECIO2HMqKPNcmYQFd04jB+ggmJLZuUhl8EwKSYciYcDph9UmyLBXTY=
X-Received: by 2002:a05:651c:502:b0:2fb:3960:9671 with SMTP id
 38308e7fff4ca-30009c923a9mr9239571fa.15.1733206680757; Mon, 02 Dec 2024
 22:18:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+7SXZhXqLzNPzb7cs+6sqVBcjNmSbrEi3PU-gLGpHgMt-xFzw@mail.gmail.com>
In-Reply-To: <CA+7SXZhXqLzNPzb7cs+6sqVBcjNmSbrEi3PU-gLGpHgMt-xFzw@mail.gmail.com>
From: ZachWade <zachwade.k@gmail.com>
Date: Tue, 3 Dec 2024 14:17:49 +0800
Message-ID: <CA+7SXZj+kgs=OvCyN7EPTazrDPVN05Hc-SpXGJ1krV3a58nwbg@mail.gmail.com>
Subject: Re: Bug report (maybe fixed, but I'm not sure)
To: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Oh, I also reproduced it in 6.13-rc1, but it is more difficult to have
this problem than in 6.12.

ZachWade <zachwade.k@gmail.com> =E4=BA=8E2024=E5=B9=B412=E6=9C=883=E6=97=A5=
=E5=91=A8=E4=BA=8C 12:03=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi=EF=BC=8Clinux kernel crypto maintainers
> I encountered a report from UAF kasan on the 6.12 kernel,
> It happened when executing the ltp example (./testcases/bin/pcrypt_aead01=
)
> https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/cr=
ypto/pcrypt_aead01.c
> This problem is very easy to reproduce in v6.12
>
> While I was trying to solve it, I pulled the latest code, and now I am
> on 6.13-rc1.
>
> This problem no longer occurs, I don't know what happened, and I didn't s=
ee any
> commits that solved my problem when I looked at the commits. I am
> curious whether
> this problem has been solved.
>
> Attached is the kasan report:
> [   50.449417] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   50.449427] BUG: KASAN: slab-use-after-free in padata_find_next+0x2d6/=
0x3f0
> [   50.449443] Read of size 4 at addr ffff88881b726424 by task
> kworker/u157:1/775
> [   50.449451]
> [   50.449457] CPU: 28 UID: 0 PID: 775 Comm: kworker/u157:1 Kdump:
> loaded Tainted: G            E      6.12.0+ #35
> [   50.449470] Tainted: [E]=3DUNSIGNED_MODULE
> [   50.449474] Hardware name: VMware, Inc. VMware20,1/440BX Desktop
> Reference Platform, BIOS VMW201.00V.20192059.B64.2207280713 07/28/2022
> [   50.449481] Workqueue: pdecrypt_parallel padata_parallel_worker
> [   50.449492] Call Trace:
> [   50.449496]  <TASK>
> [   50.449501]  dump_stack_lvl+0x5d/0x80
> [   50.449513]  ? padata_find_next+0x2d6/0x3f0
> [   50.449520]  print_report+0x174/0x505
> [   50.449532]  ? __pfx_rt_spin_lock+0x10/0x10
> [   50.449542]  ? padata_find_next+0x2d6/0x3f0
> [   50.449548]  kasan_report+0xe0/0x160
> [   50.449559]  ? padata_find_next+0x2d6/0x3f0
> [   50.449566]  padata_find_next+0x2d6/0x3f0
> [   50.449572]  ? queue_work_on+0x4c/0x80
> [   50.449585]  padata_reorder+0x1cc/0x400
> [   50.449593]  padata_parallel_worker+0x70/0x160
> [   50.449600]  process_one_work+0x646/0xeb0
> [   50.449609]  worker_thread+0x619/0x10e0
> [   50.449617]  ? __kthread_parkme+0x86/0x140
> [   50.449626]  ? __pfx_worker_thread+0x10/0x10
> [   50.449633]  kthread+0x28d/0x350
> [   50.449640]  ? recalc_sigpending+0x12e/0x1b0
> [   50.449651]  ? __pfx_kthread+0x10/0x10
> [   50.449658]  ret_from_fork+0x31/0x70
> [   50.449668]  ? __pfx_kthread+0x10/0x10
> [   50.449675]  ret_from_fork_asm+0x1a/0x30
> [   50.449686]  </TASK>
> [   50.449690]
> [   50.449692] Allocated by task 12827:
> [   50.449698]  kasan_save_stack+0x30/0x50
> [   50.449705]  kasan_save_track+0x14/0x30
> [   50.449711]  __kasan_kmalloc+0xaa/0xb0
> [   50.449717]  padata_alloc_pd+0x69/0x9f0
> [   50.449722]  padata_alloc_shell+0x82/0x210
> [   50.449728]  pcrypt_create+0x13b/0x7a0 [pcrypt]
> [   50.449738]  cryptomgr_probe+0x8d/0x230
> [   50.449747]  kthread+0x28d/0x350
> [   50.449753]  ret_from_fork+0x31/0x70
> [   50.449760]  ret_from_fork_asm+0x1a/0x30
> [   50.449766]
> [   50.449768] Freed by task 154:
> [   50.449772]  kasan_save_stack+0x30/0x50
> [   50.449778]  kasan_save_track+0x14/0x30
> [   50.449784]  kasan_save_free_info+0x3b/0x70
> [   50.449793]  __kasan_slab_free+0x4f/0x70
> [   50.449800]  kfree+0x119/0x440
> [   50.449808]  padata_free_shell+0x262/0x320
> [   50.449814]  pcrypt_free+0x43/0x90 [pcrypt]
> [   50.449821]  crypto_destroy_instance_workfn+0x79/0xc0
> [   50.449832]  process_one_work+0x646/0xeb0
> [   50.449837]  worker_thread+0x619/0x10e0
> [   50.449842]  kthread+0x28d/0x350
> [   50.449848]  ret_from_fork+0x31/0x70
> [   50.449855]  ret_from_fork_asm+0x1a/0x30
> [   50.449862]
> [   50.449863] The buggy address belongs to the object at ffff88881b72640=
0
>                 which belongs to the cache kmalloc-192 of size 192
> [   50.449870] The buggy address is located 36 bytes inside of
>                 freed 192-byte region [ffff88881b726400, ffff88881b7264c0=
)
> [   50.449878]
> [   50.449880] The buggy address belongs to the physical page:
> [   50.449884] page: refcount:1 mapcount:0 mapping:0000000000000000
> index:0x0 pfn:0x81b726
> [   50.449892] head: order:1 mapcount:0 entire_mapcount:0
> nr_pages_mapped:0 pincount:0
> [   50.449898] flags: 0x50000000000040(head|node=3D1|zone=3D2)
> [   50.449906] page_type: f5(slab)
> [   50.449914] raw: 0050000000000040 ffff88810004c3c0 dead000000000122
> 0000000000000000
> [   50.449922] raw: 0000000000000000 0000000080200020 00000001f5000000
> 0000000000000000
> [   50.449928] head: 0050000000000040 ffff88810004c3c0
> dead000000000122 0000000000000000
> [   50.449934] head: 0000000000000000 0000000080200020
> 00000001f5000000 0000000000000000
> [   50.449939] head: 0050000000000001 ffffea00206dc981
> ffffffffffffffff 0000000000000000
> [   50.449945] head: 0000000000000002 0000000000000000
> 00000000ffffffff 0000000000000000
> [   50.449948] page dumped because: kasan: bad access detected
> [   50.449951]
> [   50.449953] Memory state around the buggy address:
> [   50.449957]  ffff88881b726300: fa fb fb fb fb fb fb fb fb fb fb fb
> fb fb fb fb
> [   50.449963]  ffff88881b726380: fb fb fb fb fb fb fb fb fc fc fc fc
> fc fc fc fc
> [   50.449967] >ffff88881b726400: fa fb fb fb fb fb fb fb fb fb fb fb
> fb fb fb fb
> [   50.449971]                                ^
> [   50.449975]  ffff88881b726480: fb fb fb fb fb fb fb fb fc fc fc fc
> fc fc fc fc
> [   50.449979]  ffff88881b726500: fa fb fb fb fb fb fb fb fb fb fb fb
> fb fb fb fb
> [   50.449982] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
