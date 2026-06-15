Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B148460
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 02:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781489433; cv=none; b=hcSzTexZhV6vF9CpmyGbi2Xk/z1leLxtnU7HGYmY4x2qjTioJuOX7KmvQc9Qmm+xuphsSANxPKnaD/grCcG/n9pqZElYzG7SO2y83TWzrekgIXb/d5V557eMk/RTJBL97cesTAUm+cobJc/Py7k+AIq9NZRyTA4Os9UpVC3kp9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781489433; c=relaxed/simple;
	bh=wfQQuamQ5LqpPBGZUbx0Zh4WzYd/fyfJ5hCTDDZj+8w=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Xe+mjfY2IyrOLiashPc+bwyuj0yWAbaDZlgOfpp6wPZsBo3S/+cK3D3S/oNyhizgYrsvBTjxOPY/7Q/IEm6VCJU2JpKfNBQ8EseY5fkHu5n05AgLYxIjinSyiYEc2qwLjhg5Xu/y11UJKYBFXleA+Izl77rck5pc/KA64IkC7B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kiiN7C7o; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kiiN7C7o"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5177ad0cc67so24584921cf.0
        for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2026 19:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781489427; x=1782094227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=F/ahHpowE1Z+LswDSAVcgfWNjxOTYv6m+ZocBZFFd5w=;
        b=kiiN7C7o1o6JS7mAROtkttS+huSmlhxKylw7Mle62y+7zeqomFBRKHgiAHE3Jj5C6O
         SoqJZQXYOWqHYssp3xCxEuqb1FfANZfouhMpPzHyPt4UyGvHDL49O1yBpHHTOqO3sO8C
         SnpaLXfObPnRnPY1N8wQEKqZ7hDu7TyicaDIyodZFHqfrGVmScJwPH00OWX6iXA7/EFX
         5Fc6oHctIlZVU5K91gzfLSkTIMbjELwTH27dmF52Fn5iuiqjwt0IEgcuiUMBFqZKLBI3
         LPPc3wOAf9CG0gXxgtckWOoif5QBNFZOes0hEDCoigyu1s9lTo3Dan+6vsItJViDdh0r
         ZkJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781489427; x=1782094227;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F/ahHpowE1Z+LswDSAVcgfWNjxOTYv6m+ZocBZFFd5w=;
        b=GwFpZgu8wO6MY5W17xJQxCQ2fkBMgWRaP/CfsAvR0vDwKr2j4IfqB0s2u72ft2dgLi
         4OZV8PXpXrFEY6DQY/czd831LCkKnNouqh91vvN+RMaosrWNTZTtpGWJE+e6JviDe3lf
         84TL3vSoYsUZAneAqtGu1pCNMLpb5syRKPmCoWvNctGW0VSEkU4gksKaotUF4g+Ft5Wb
         k+OUISeJYvLLf2++U43o01kuj4o1vpuVBslJjL4fXGYlArwQdONKKXeeRUPnHACnLfPi
         nQrk0VCn0BN2W/zp80ToIBYuOLqcoUFLGnvq2PMA7rA9U5CwIVPxA+CVMPpaTobatnmF
         0rzA==
X-Forwarded-Encrypted: i=1; AFNElJ8byOXuJOmuR1Q1Mkb5SsGk0kcN4ULM51NtV7pIU/fi/QKUvXqaaMRdj0cSyjWEiDO2HaBxZusibz14A04=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzlWepvpnXQeDWbnRkJ2AAJcUPZDLvzcY7xap+JJI6tSytTloQ
	+YSNaNJ04Y2gWO3niaIzVVxUF9pq/4XrfcxSuSfp+xb9PAU1LQmkGVp5
X-Gm-Gg: Acq92OESyuyvqGeuO00KGKxOKmjeIE25bcc/0suD6Mid6eEvQqNbf9WE35Gusdhri3E
	YGrAPGgAMuFSHU6eXCsZKFqbmK0N9KsWNWzFX9CoaqBJGoVcwJTfqBaKoW9rt2XTIB6TRxLZRVh
	foV5z44n9nIq+zz5TmmnDr8vSp9dX8h7yibWmWVqrpgZ8gDrl+JgIRK5BsSaA5qv29kUMR5e5Rf
	WRkXtD8CnbdZKb8NOLHMrpGdtJWIBcSfTaJATk8vhCrKNFibxgWIC/kdDnr3bUf7d4oZjBQPRaA
	6I6T5lCTcyeklC/Dnv/fqo1gCsucUZzSGH9kP7As+DGH1mR++YhLY+gnro3o2mS8hA6M9OlgoFK
	37cBkOGTCQGBMIjPyFTJ+48jedmw2GSyTSP1BOEEhhetm0AzU6Chajwm9vZOfPDEFt8OyROPMPG
	XrUbgisu2tJn7Umal+D6WcEZ6RJcEpx6U11nzlI71cjbdByVaQisdgJSDszo04R05rtvTICA==
X-Received: by 2002:a05:622a:1343:b0:517:21ad:faa8 with SMTP id d75a77b69052e-517fe516c82mr196177861cf.41.1781489427080;
        Sun, 14 Jun 2026 19:10:27 -0700 (PDT)
Received: from localhost.localdomain ([2601:985:4601:5df0:2106:6ce9:6b1:8f70])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb61d948sm89064731cf.1.2026.06.14.19.10.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 14 Jun 2026 19:10:26 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: arei.gonglei@huawei.com,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] crypto: virtio - KASAN slab-use-after-free in virtio_crypto_skcipher_encrypt
Date: Sun, 14 Jun 2026 22:10:25 -0400
Message-ID: <178144969601.60470.4893281262514662497@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

I hit the following KASAN report while testing current upstream kernel.

The issue was reproduced by queuing an AF_ALG skcipher request backed by
virtio-crypto, unbinding virtio0 from the virtio_crypto driver, and then
receiving from the old AF_ALG op fd.

KASAN: slab-use-after-free in virtio_crypto_skcipher_encrypt

I reproduced this on commit: e8c2f9fdadee7cbc75134dc463c1e0d856d6e5c7 (May 25 2026)

The reproducer and .config files are here.
https://gist.github.com/shuangpengbai/f6117a0883dd574f02288ca812bb7d65

I'm happy to test debug patches or provide additional information.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[   54.367992][ T8332] BUG: KASAN: slab-use-after-free in virtio_crypto_skcipher_encrypt (drivers/crypto/virtio/virtio_crypto_skcipher_algs.c:473)
[   54.369596][ T8332] Read of size 8 at addr ffff888124a47010 by task virtio_crypto_a/8332
[   54.370922][ T8332]
[   54.371171][ T8332] Tainted: [W]=WARN
[   54.371172][ T8332] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   54.371175][ T8332] Call Trace:
[   54.371179][ T8332]  <TASK>
[   54.371181][ T8332]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
[   54.371188][ T8332]  print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
[   54.371202][ T8332]  kasan_report (mm/kasan/report.c:595)
[   54.371213][ T8332]  virtio_crypto_skcipher_encrypt (drivers/crypto/virtio/virtio_crypto_skcipher_algs.c:473)
[   54.371216][ T8332]  skcipher_recvmsg (crypto/algif_skcipher.c:203 crypto/algif_skcipher.c:226)
[   54.371249][ T8332]  sock_recvmsg (net/socket.c:1137 net/socket.c:1159)
[   54.371253][ T8332]  __sys_recvfrom (net/socket.c:2315)
[   54.371273][ T8332]  __x64_sys_recvfrom (net/socket.c:2330 net/socket.c:2326 net/socket.c:2326)
[   54.371277][ T8332]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
[   54.371281][ T8332]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[   54.371285][ T8332] RIP: 0033:0x7f3c6caaac2c
[   54.371289][ T8332] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 19 45 31 c9 45 31 c0 b8 2d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 64 c3 0f 1f 00 55 48 83 ec 20 48 89 54 24 10
[   54.371292][ T8332] RSP: 002b:00007ffed3785308 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
[   54.371297][ T8332] RAX: ffffffffffffffda RBX: 0000000000000064 RCX: 00007f3c6caaac2c
[   54.371299][ T8332] RDX: 0000000000000040 RSI: 00007ffed37853a0 RDI: 0000000000000004
[   54.371301][ T8332] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
[   54.371303][ T8332] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
[   54.371305][ T8332] R13: 00007ffed37853a0 R14: 0000558cc9904118 R15: 0000000000000000
[   54.371309][ T8332]  </TASK>
[   54.371311][ T8332]
[   54.394932][ T8332] Freed by task 8332 on cpu 0 at 54.364772s:
[   54.395528][ T8332]  kasan_save_track (mm/kasan/common.c:57 mm/kasan/common.c:78)
[   54.395997][ T8332]  kasan_save_free_info (mm/kasan/generic.c:584)
[   54.396501][ T8332]  __kasan_slab_free (mm/kasan/common.c:253 mm/kasan/common.c:285)
[   54.396983][ T8332]  kfree (include/linux/kasan.h:235 mm/slub.c:2689 mm/slub.c:6251 mm/slub.c:6566)
[   54.397378][ T8332]  virtio_dev_remove (drivers/virtio/virtio.c:375)
[   54.397869][ T8332]  device_release_driver_internal (drivers/base/dd.c:619 drivers/base/dd.c:1352 drivers/base/dd.c:1375)
[   54.398475][ T8332]  unbind_store (drivers/base/bus.c:244)
[   54.398944][ T8332]  kernfs_fop_write_iter (fs/kernfs/file.c:352)
[   54.399476][ T8332]  vfs_write (fs/read_write.c:595 fs/read_write.c:688)
[   54.399915][ T8332]  ksys_write (fs/read_write.c:740)
[   54.400349][ T8332]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
[   54.400818][ T8332]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[   54.401406][ T8332]
[   54.401650][ T8332] The buggy address belongs to the object at ffff888124a47000
[   54.401650][ T8332]  which belongs to the cache kmalloc-192 of size 192
[   54.403038][ T8332] The buggy address is located 16 bytes inside of
[   54.403038][ T8332]  freed 192-byte region [ffff888124a47000, ffff888124a470c0)
[   54.404385][ T8332]


Best,
Shuangpeng
