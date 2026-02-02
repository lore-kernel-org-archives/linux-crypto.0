Received: from mail-qt1-f196.google.com (mail-qt1-f196.google.com [209.85.160.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE1A2FD69F
	for <linux-crypto@vger.kernel.org>; Mon,  2 Feb 2026 06:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.196
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770014341; cv=pass; b=HMpOZ2GiuQxQBTh97SaIlv8aj6rUfWOLUb6kNt1l7ieyozeyBk44nyPLZO8DKWjFtKmHmJSykneHa6t9YOe8EvJjxxfk9HNiTENlZMCZK5y7qH4i16FcPHBXJMMQs+kLajrl4PxJTFNA2Mu1Hp9EfwWult2RzuIDMvwWvoekcy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770014341; c=relaxed/simple;
	bh=89PMEYsoP/o9Z/JUHE5huK6c88sWQLoNN7ufqfPa59I=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=uLunxaW5mnpyflaIPi0nXccJNAv3t1ct2rCxGYSJhTmnHDZ2/RSOUuze/NPWeXW23Z6IegHaHMBB4I+tNFGcWhO7r0uuwTtb8Sv3gpDs934wR/pcbzNL3nQ+ytaO23ydN+s/0NGSOV9UlXcESWYb8XOmVCWQZKkJ+6Ou+4SoaFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KCLHYey+; arc=pass smtp.client-ip=209.85.160.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KCLHYey+"
Received: by mail-qt1-f196.google.com with SMTP id d75a77b69052e-5032e15525aso43847541cf.3
        for <linux-crypto@vger.kernel.org>; Sun, 01 Feb 2026 22:38:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770014339; cv=none;
        d=google.com; s=arc-20240605;
        b=LCKVEQdu3Gs19R4CoN7U8YZtTWe/iReF/omiXzy12DkIH2zoAiW5XN/s67Ay+aw5zk
         9GzUCE4jTpBZqQvpHrXL7QAw9mPt1dF1plUhfjMGDAC52f5/EGl71H+rRf3/fcOzSx+f
         BQdIDi+iBXTvvzVn7e/C/fmNU9D3Ecu3BfH1shBdgR2n8XN7322W93anJZtTgQEipeOo
         3R5CERpqiTwxglLgOUzXZjkUCq0j9/OjS+L9RBcD+RitPc2DDmt8osxYghO4IH2bfG4J
         LIdWCaW/Icdc3MMDqk3ZpMvtuuzMD68GgFRNPoBQcDSLx+dm6WoFysNE+qesv8o96x3X
         +9tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Z00yLx9UllMOuYR4Xm+1YdFnh9GSLQi823d7hx3zd5k=;
        fh=gC6cjKMbTwpmrf3XRHXPDbC673kVkwQ6aB7I/1cBerk=;
        b=Gy27ekEExw6NaWerQ6qzgscVLMIbWtpX2ENKf1nwmswbXERmRsP/b1f6afPcooXafl
         gy56WOr0FOchfmgJ9jEDpA2EHRre0HFv1/F2amClAONZWQq1w9rBmLHmGpnSPigiMK7o
         /ptbNbDOUgg2LLtKdS6mcd1gpaMRBq2BA0tVpjHUwF7i7ZE6VEoxcaXoGr8bgmxBmajG
         ipniCWGlbVahBzHVCsOelbPJ8ZVSKep0QZwQP3lAeA48hQ2zW7sPPxi5/3eKm1yzl6D9
         v6/KhyrXjWGfBeqv7aA86g3lDvLgWe+LlrQKEtBDu/KiacJQ8rYMK3XeRiVPXXagkCKQ
         Ck/A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770014339; x=1770619139; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z00yLx9UllMOuYR4Xm+1YdFnh9GSLQi823d7hx3zd5k=;
        b=KCLHYey+/quCoPFaoOR78JOuVTrUIt7YMDcO5WtkQb85pRJqrAUfn/XjwjvIe4/qyS
         lg8ureeAB6VXS8EFVp6UtY3JtNS6PRslZ5j9GnBq8hOFyrYhzdiGV+hu2qrOktMJRo+o
         SOXdhNph7KfUFwqYmJEiDJq/FklnuAj3KVxmpknF9S6G/sBFNZaU5a51SFGFrTkZUjpO
         oBTg7Nsfa2lJi0swqwu8KcLjP8I5VVChXWwLyCYuIuBoD4WI8APxz4BKUFXaRFocbxsJ
         JUpnrjAs/TkTkouNe7gb/RvNZYuArBntgAC4b3pLsMetEV4LpiQYyDh8bnYwLeN527wP
         1GfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770014339; x=1770619139;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z00yLx9UllMOuYR4Xm+1YdFnh9GSLQi823d7hx3zd5k=;
        b=vIleQSml7sU/o6CFLL7JM8t0uKvm8JL6jNpvnBkPuady1Zcp9ZKAKoAI8lypnobP90
         ggVAK0rFiu6T5QY0XLbw0w2/0C71tgalvAMNu6sC3ETG7P/1aj+et8WtJfmRNzrwGUxk
         cAuUcRf2coPgpjIHsLt+AiAubdE50A8xXNcS2IWsQ3mjR8eWZVR3mfHhYHI77drhyOK6
         CiIMQdFMVodxkM09IZ59SqBqtRMVlBzOOOhpaMHBCCIFDfd3bph84rFzBxvqk8fPLGZN
         p6f3FPJvyl0wrcs+oe+tPzjl9SkvZEabP72EtxrVlhW2cp4Z18Hqx6MNzvQqFWM7j39N
         W5Cw==
X-Forwarded-Encrypted: i=1; AJvYcCV6UwysMOEMmWGU4d8dK7jhhvohrIr3ZlYyyvxJiyTa5TA7PjgTMgGjTfuPbjcnXnOPIHDF9kSE0n/wwFI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzB4gDDD7QRubC6EVp/05doVoGTZF+EQDS3RelTrFEOQmkTNpMT
	IuJsUV4l7O2LTaHXhEhQjvfdfmkeC82kUzMMQuJoXitMxq5vhm/pUKH/KLkq7IPwsnOrL1oLbOY
	gr7mQrpJ3DWhEcneEG+8ROk+EWkpkoDg=
X-Gm-Gg: AZuq6aI0QUg3TOvbdZC7QhnY75Wqh1NXmGL9LPip9dd/5aMbseUp3NWkIHWFJSxbVkN
	4OIviJdJ/8uV4YhCcEbaVQSpRumI3hHvuurVMsUHiziGVdaDKZP1QGxasMkBuVlahr1VWutnxid
	E4W+QbJytpcXOmPqDtrarACDtRkhaOjEduCRvPCaFBMThMhZVMqFdV4qdkavi9DfnNRn6zMB9Nr
	muBt7PFG8Vj9/uSynaMkBN4yUrn+h6Y7rLsBOleGFgpLnpgecjS2u1yqKtWZD3yPBmj/lEBh88j
	HQE3RS+alpJXRlwKPNfdbthM2w==
X-Received: by 2002:a05:622a:101:b0:4ff:9737:dd15 with SMTP id
 d75a77b69052e-505d22aba61mr147093941cf.60.1770014338901; Sun, 01 Feb 2026
 22:38:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>
Date: Mon, 2 Feb 2026 14:38:47 +0800
X-Gm-Features: AZwV_Qj7usFUyg2sC_GJ7HedL9uzNuiTELMwkpLQMaKOPxlHDqnqX-9SOgF8bn0
Message-ID: <CAHPqNmyNGAJr1wfcjYN7FXn1wV6Xzqp5oXoH7XNbTcn6cOkSvw@mail.gmail.com>
Subject: [Kernel Bug] possible deadlock in crypto_alg_lookup
To: syzkaller@googlegroups.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear Linux kernel developers and maintainers,

We would like to report a new kernel bug found by our tool. possible
deadlock in crypto_alg_lookup. Details are as follows.

Kernel commit: v6.18.2
Kernel config: see attachment
report: see attachment

We are currently analyzing the root cause and  working on a
reproducible PoC. We will provide further updates in this thread as
soon as we have more information.

Best regards,
Longxing Li

======================================================
WARNING: possible circular locking dependency detected
6.18.2 #1 Not tainted
------------------------------------------------------
syz.2.389/14495 is trying to acquire lock:
ffffffff8ebbd970 (crypto_alg_sem){++++}-{4:4}, at:
crypto_alg_lookup+0x44/0x1e0 crypto/api.c:262

but task is already holding lock:
ffff888037928fd8 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock
include/net/sock.h:1679 [inline]
ffff888037928fd8 (sk_lock-AF_INET6){+.+.}-{0:0}, at: do_tls_setsockopt
net/tls/tls_main.c:820 [inline]
ffff888037928fd8 (sk_lock-AF_INET6){+.+.}-{0:0}, at:
tls_setsockopt+0x1d7/0x1970 net/tls/tls_main.c:849

which lock already depends on the new lock.

...

other info that might help us debug this:

Chain exists of:
  crypto_alg_sem --> &nsock->tx_lock --> sk_lock-AF_INET6

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(sk_lock-AF_INET6);
                               lock(&nsock->tx_lock);
                               lock(sk_lock-AF_INET6);
  rlock(crypto_alg_sem);

 *** DEADLOCK ***

1 lock held by syz.2.389/14495:
 #0: ffff888037928fd8 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock
include/net/sock.h:1679 [inline]
 #0: ffff888037928fd8 (sk_lock-AF_INET6){+.+.}-{0:0}, at:
do_tls_setsockopt net/tls/tls_main.c:820 [inline]
 #0: ffff888037928fd8 (sk_lock-AF_INET6){+.+.}-{0:0}, at:
tls_setsockopt+0x1d7/0x1970 net/tls/tls_main.c:849

stack backtrace:
CPU: 0 UID: 0 PID: 14495 Comm: syz.2.389 Not tainted 6.18.2 #1 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x275/0x350 kernel/locking/lockdep.c:2043
 check_noncircular+0x14c/0x170 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x126f/0x1c90 kernel/locking/lockdep.c:5237
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x179/0x350 kernel/locking/lockdep.c:5825
 down_read+0x9b/0x480 kernel/locking/rwsem.c:1537
 crypto_alg_lookup+0x44/0x1e0 crypto/api.c:262
 crypto_larval_lookup crypto/api.c:300 [inline]
 crypto_alg_mod_lookup+0x71/0x520 crypto/api.c:353
 crypto_find_alg crypto/api.c:599 [inline]
 crypto_alloc_tfm_node+0xd3/0x260 crypto/api.c:636
 tls_set_sw_offload+0xd73/0x16e0 net/tls/tls_sw.c:2839
 do_tls_setsockopt_conf net/tls/tls_main.c:695 [inline]
 do_tls_setsockopt net/tls/tls_main.c:821 [inline]
 tls_setsockopt+0x11ea/0x1970 net/tls/tls_main.c:849
 do_sock_setsockopt+0xf3/0x1d0 net/socket.c:2360
 __sys_setsockopt+0x1a0/0x230 net/socket.c:2385
 __do_sys_setsockopt net/socket.c:2391 [inline]
 __se_sys_setsockopt net/socket.c:2388 [inline]
 __x64_sys_setsockopt+0xbd/0x160 net/socket.c:2388
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x5656ed
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6ce7edafc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000715f80 RCX: 00000000005656ed
RDX: 0000000000000001 RSI: 000000000000011a RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000038 R09: 0000000000000000
R10: 0000000020000200 R11: 0000000000000246 R12: 0000000000715f8c
R13: 0000000000000000 R14: 0000000000715f80 R15: 00007f6ce7ebb000
 </TASK>

https://drive.google.com/file/d/17HbDTI_iPjA72SkV5MnO-_w7IQZ9HIHW/view?usp=drive_link

https://drive.google.com/file/d/1egT1-2GQukoY_pwOr66U1XvvpKJLChpp/view?usp=drive_link
