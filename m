Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37C1214226;
	Thu, 24 Apr 2025 12:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745496580; cv=none; b=kjI6dSBB8L/g1oTZut3Qnqd317F59c5wFtFZzFoJ5SyMPmrypdEkMyeOsUn4FXW9Avt5+Fr6EoQbNfFI/B4E+bFlx4kVxVtp/w/2K4QdIATc0EcnP2vgBbIS1ycPqxsYZtSEvcE1QWygnmLMQiXY2d9+rxaEd2AaEbn8tIYxxWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745496580; c=relaxed/simple;
	bh=IOumbczHSOU8shFA9xhjl3Y6Jgz3e7dJu7qT1Z8tdcw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CWAVfDphZRZFjDkKGVyAQoJ4iB97EwPGTxTxMCrhCRQZC2og9xRCeOEtrCdxMW4e0DRlAtmbWNePXuiQNl/vXokQKuWXB6Gplvzr1uhHZV8paDI2DG24nfuah0cz5Ru0FOsTLU8QWwU4TYq6JOI4Njy+9CkMYYToGzro6m6wFAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aN11xwPy; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aN11xwPy"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-391342fc0b5so702661f8f.3;
        Thu, 24 Apr 2025 05:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745496577; x=1746101377; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1nz+uql6hTd/t+4gkWeKbIjPQ0uF/fdZdNIgPAqo7po=;
        b=aN11xwPyz2VCLWOG0n/N4w5N0Eoh+bhKWIctxaiX6i8AftUFuPSY+ArDcijZEAFigu
         GnaNeDQBPFK8pXxfTsXy+eRvlYSpNmo71Hp10dV8Jt7xEM8CdeeecLvhPhwid/PM+/hR
         5UcmZkxNcvITBNt3O0jmVIQ0PWHlbv8TWJVLfOKRk2Jq2ZzeV1sPiM3pFtuI/zoUkIvv
         xB9MRyyo7LkWNGv+pyZiMz5oYTu8ANz5KI77nTmFEL+7N4RNoyfgK+3hoBOSvrWY2Ofw
         rXgquvDbU4z1nlWyiG0beNAt+aDGTymoH5LP3sAgTsV6t6FwtPACHdwC7fxQDmU4B8C+
         Dcwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745496577; x=1746101377;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1nz+uql6hTd/t+4gkWeKbIjPQ0uF/fdZdNIgPAqo7po=;
        b=fyOv5+ogxO+Hyf7F6OWuJY4DWIQBz7MisiSZ0UG1L013Gzl8tCeUKz4nQtJ10dkcdh
         fYENfzx9172s5RTbZpu3uQJ3daGPK5g4GM+JlXxjw06a+gM3fTO8uVURM9DBm2LZCPo0
         CZDq+OiZmGCgUXLdLDvAmOybyVn4v6Swci7mOtnWKwfNyHdjA0wRx3xVy2t2nxTykxgF
         jAAcuTOMEQ2h6OxEPCGkcIC96siJFq+mkKLQE24zvbVFW51T+wl4/gWn8Ze7UF5WQmfY
         jEy9fEo7IwsqssrNj7WLHGafPw1uLv8L2XuzFkrd81Wsrh/Ir8qqWKU5p/T5BM8nnRds
         IWtw==
X-Forwarded-Encrypted: i=1; AJvYcCVyLyA5jBY5rCPUV+ueMSfmbhC7AU9x7nCdcTLQpVXMONyOvQ7oRB4pmslRoSPJXXiBL86Ji5FWzgAGBSU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLG4uJFABt+oGqGzdtSgxMF9CNFHpkuoMO4dhX0BaB5JeRh4lZ
	cV1cL2wO2UQLqOlWDZXt7aWSYGeTM/5jBjxPWfMuvwpla8rPWmEhBSbmqg==
X-Gm-Gg: ASbGncuzbsBImCH5+cFj6sFugNEXS9gOm1GBuUQgum/Gehk7MKJ8ExHw45woYOBZECn
	mmhfUltEITQ38tlkMEhyByi1nZP3Nn3UxTeeKCzKO5XPEQ2NP6f2t28z2Y2H1pOA0MCa3kc9777
	H66s+fgnh/PO6z9Ken4gV8hgcPVabz1Iazx8hot1v4KeN824fOMYOy3/PxGFnFQ0wQ+XoS7qEpp
	9gZga/460sjA3SiZnVDEqggw1ISykz28/uDFUc5cahjqFaRkUcJM1LTkIE2eKtNmDSISN3yOZNF
	IOXAv//goaW2UmmZ+KHFnR094tNqbs2aOeNp6PrE
X-Google-Smtp-Source: AGHT+IFyuJc5iMfORqLWaUkPx5BMXp0/hSTNVRPe2oz/ZmrD8Ypvnz+cc5jNpalZZkJwjJJ+NAeV3A==
X-Received: by 2002:a05:6000:2209:b0:39e:e588:6731 with SMTP id ffacd0b85a97d-3a06cf4b832mr1814144f8f.12.1745496576773;
        Thu, 24 Apr 2025 05:09:36 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4408d839711sm59142365e9.0.2025.04.24.05.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 05:09:36 -0700 (PDT)
Date: Thu, 24 Apr 2025 14:09:34 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: all crypto selftests failed on linux-next-20250424
Message-ID: <aAop_uMhxVh2l5Fy@Red>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello

All crypto selftests failed on top of linux-next-20250424

Example on x86_64:
[    4.637589] BUG: kernel NULL pointer dereference, address: 0000000000000000
[    4.637822] #PF: supervisor instruction fetch in kernel mode
[    4.637931] #PF: error_code(0x0010) - not-present page
[    4.638166] PGD 0 P4D 0 
[    4.638359] Oops: Oops: 0010 [#1] SMP NOPTI
[    4.638808] CPU: 0 UID: 0 PID: 64 Comm: virtio1-engine Not tainted 6.15.0-rc1-g63dc06cd12f9 #1 PREEMPT(voluntary) 
[    4.639068] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-20240910_120124-localhost 04/01/2014
[    4.639338] RIP: 0010:0x0
[    4.640112] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[    4.640253] RSP: 0018:ffffb2d8c025fe68 EFLAGS: 00010202
[    4.640451] RAX: 0000000000000000 RBX: ffffa1d009a937b0 RCX: ffffa1d009a93768
[    4.640579] RDX: ffffa1d009a93768 RSI: ffffa1d009b10920 RDI: ffffa1d009a93728
[    4.640706] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000055
[    4.640829] R10: 0000000000000000 R11: 000000000000004b R12: ffffa1d009a93760
[    4.640952] R13: ffffa1d009b10920 R14: ffffa1d009a93768 R15: 0000000000000282
[    4.641126] FS:  0000000000000000(0000) GS:ffffa1d0c0efe000(0000) knlGS:0000000000000000
[    4.641272] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.641379] CR2: ffffffffffffffd6 CR3: 0000000017e32000 CR4: 00000000000006f0
[    4.641592] Call Trace:
[    4.642112]  <TASK>
[    4.642234]  crypto_pump_work+0x151/0x290
[    4.642693]  ? __pfx_crypto_pump_work+0x10/0x10
[    4.642780]  kthread_worker_fn+0x94/0x250
[    4.642860]  ? __pfx_kthread_worker_fn+0x10/0x10
[    4.642942]  kthread+0xf6/0x1f0
[    4.643003]  ? __pfx_kthread+0x10/0x10
[    4.643086]  ret_from_fork+0x2f/0x50
[    4.643163]  ? __pfx_kthread+0x10/0x10
[    4.643234]  ret_from_fork_asm+0x1a/0x30
[    4.643345]  </TASK>
[    4.643434] Modules linked in:
[    4.643615] CR2: 0000000000000000
[    4.643899] ---[ end trace 0000000000000000 ]---
[    4.644059] RIP: 0010:0x0
[    4.644128] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[    4.644240] RSP: 0018:ffffb2d8c025fe68 EFLAGS: 00010202
[    4.644330] RAX: 0000000000000000 RBX: ffffa1d009a937b0 RCX: ffffa1d009a93768
[    4.644449] RDX: ffffa1d009a93768 RSI: ffffa1d009b10920 RDI: ffffa1d009a93728
[    4.644561] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000055
[    4.644672] R10: 0000000000000000 R11: 000000000000004b R12: ffffa1d009a93760
[    4.644783] R13: ffffa1d009b10920 R14: ffffa1d009a93768 R15: 0000000000000282
[    4.644894] FS:  0000000000000000(0000) GS:ffffa1d0c0efe000(0000) knlGS:0000000000000000
[    4.645019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.645142] CR2: ffffffffffffffd6 CR3: 0000000017e32000 CR4: 00000000000006f0
[    4.645326] note: virtio1-engine[64] exited with irqs disabled

Example for arm
[    0.293756] alg: self-tests for sha1 using sha1-ce failed (rc=-22)
[    0.293762] ------------[ cut here ]------------
[    0.293766] alg: self-tests for sha1 using sha1-ce failed (rc=-22)
[    0.293809] WARNING: CPU: 7 PID: 104 at crypto/testmgr.c:5871 alg_test+0x5e4/0x608
[    0.293833] Modules linked in:
[    0.293844] CPU: 7 UID: 0 PID: 104 Comm: cryptomgr_test Not tainted 6.15.0-rc3-next-20250424-00005-g954547706c5d #8 PREEMPT
[    0.293856] Hardware name: Radxa A5E (DT)
[    0.293861] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.293871] pc : alg_test+0x5e4/0x608
[    0.293882] lr : alg_test+0x5e4/0x608
[    0.293893] sp : ffff80008175bd40
[    0.293896] x29: ffff80008175bde0 x28: 00000000000000bc x27: 0000000000000000
[    0.293911] x26: 00000000ffffffff x25: ffff800080fe1f58 x24: 00000000ffffffea
[    0.293925] x23: 0000000000000177 x22: ffff0000c202de80 x21: 000000000500000e
[    0.293939] x20: ffff0000c202de00 x19: ffff800080a05710 x18: 00000000fffffffe
[    0.294032] Call trace:
[    0.294036]  alg_test+0x5e4/0x608 (P)
[    0.294051]  cryptomgr_test+0x24/0x44
[    0.294063]  kthread+0x12c/0x204                                  
Regards
