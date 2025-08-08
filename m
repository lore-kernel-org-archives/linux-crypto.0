Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2B225A2A5
	for <linux-crypto@vger.kernel.org>; Fri,  8 Aug 2025 08:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754640452; cv=none; b=uygGCo0rGb7moLulegLZ5oRWtcPntXHhdyIqVtjHdjxA8d+FP6o7mGcCrXSZj/2nbTC08fm5jIHjFnNhDkC75FnNR2JnwlzLS1Cy/ssCzwNyVXcvgLHsSFyz73u1Vc3jRb2ZE+Qn87Y0VViAqePjFVv8GYAl6thGUWJrAM1XwQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754640452; c=relaxed/simple;
	bh=fbhjfatAP3UDLcg89AE5gW6OGazgFABaG9YaWCmdDwI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Bc4oEbptFM+UZbnNp6R/47/UpBxmXbdYakcB4CGPzK7A6hpBwLDn2nfxhsvoAOLO/jp5KDqqAfRqfiiUHbqIaMwmdTfOkIdOrbKtJ64g9G3x8gIRcVfLZnavrgNQ684k15kxO51s0OQBfz3ENwZbBCrFJ9OIhiC1FkV00DjOvU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-88177d99950so171963539f.1
        for <linux-crypto@vger.kernel.org>; Fri, 08 Aug 2025 01:07:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754640449; x=1755245249;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4o3EjIAGgZerIrIiZtS4b2/wTHTz4tnKJgIo3bTtmqw=;
        b=xEJ6TS5OYPgD5y0MRNFoSauil0fnjowroXATfWzVCGgLqo/CDh9nhufeErp119cIgK
         Q0z+Y4fQ7+dbKovYy1aV4NpiuOtfR71cqaAqqJOwbsMfBIOsSokfd+1I6U1TCQS30Ce4
         i0QRO6UAd/+AYPFNq2ERXQT1nReDjVl7HQzWTiJU25yghTgpenXgbL3D9xmD90TLn+RH
         nKxjccHUH9neCfBOTHtXsBXIWB5mQUQyuUJsdGDLZy6vThDRE7n/YHBqZVzLTAqVxwAI
         xj89fKm+AofdT4JWd47HNj89fyCPtJFl9qkxFv7B0CgTOY9dtX9IBdrRMuSgJvzHlRLX
         naNw==
X-Forwarded-Encrypted: i=1; AJvYcCXTTQzQIYLKKp/1OeJ8vQWvemoORN/5XMQ6ETsr3Wbvg6YbQs8yKVg0jw1ReK7PXHKQZC0FdJ0+HHsHGD4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9fWYUgTFZwebbFFhn8eAfnyLOMse2Ci6HcSYd/awPYXKuRgYn
	EAl48hE+t9CsJZbUxGLo/BpPveK/KVy/JYOzzhOiiQyAQmKvcvD/Q9UgFQD3B++pYBBi7VOg543
	BPB2uh+VuIZVOlXV59pfbl5pQ+pMdr+vGkIpVrqwhbceBYA+egBU76Zc+d2g=
X-Google-Smtp-Source: AGHT+IH0YDeLMTECHnwk9kv4pYhwXKCIGHWgYukumAYPidEEnCYvOLmfKds+k7C3Zma8Gm5sqk627a66+RtBwkkjADSlKIRdR1ou
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1584:b0:87c:30c6:a7cf with SMTP id
 ca18e2360f4ac-883f10de3e3mr400689239f.0.1754640449618; Fri, 08 Aug 2025
 01:07:29 -0700 (PDT)
Date: Fri, 08 Aug 2025 01:07:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6895b041.050a0220.7f033.0058.GAE@google.com>
Subject: [syzbot] [crypto?] KMSAN: kernel-infoleak in rng_recvmsg
From: syzbot <syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6e64f4580381 Merge tag 'input-for-v6.17-rc0' of git://git...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14a181a2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b6003cf8ecb92ff2
dashboard link: https://syzkaller.appspot.com/bug?extid=e8bcd7ee3db6cb5cb875
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117fa1a2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105e9058580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3d9a1192a7cc/disk-6e64f458.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8f363fe8f54a/vmlinux-6e64f458.xz
kernel image: https://storage.googleapis.com/syzbot-assets/10b73833a575/bzImage-6e64f458.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e8bcd7ee3db6cb5cb875@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:114 [inline]
BUG: KMSAN: kernel-infoleak in copy_to_user_iter lib/iov_iter.c:24 [inline]
BUG: KMSAN: kernel-infoleak in iterate_ubuf include/linux/iov_iter.h:30 [inline]
BUG: KMSAN: kernel-infoleak in iterate_and_advance2 include/linux/iov_iter.h:300 [inline]
BUG: KMSAN: kernel-infoleak in iterate_and_advance include/linux/iov_iter.h:328 [inline]
BUG: KMSAN: kernel-infoleak in _copy_to_iter+0xf0e/0x33f0 lib/iov_iter.c:185
 instrument_copy_to_user include/linux/instrumented.h:114 [inline]
 copy_to_user_iter lib/iov_iter.c:24 [inline]
 iterate_ubuf include/linux/iov_iter.h:30 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:300 [inline]
 iterate_and_advance include/linux/iov_iter.h:328 [inline]
 _copy_to_iter+0xf0e/0x33f0 lib/iov_iter.c:185
 copy_to_iter include/linux/uio.h:220 [inline]
 memcpy_to_msg include/linux/skbuff.h:4202 [inline]
 _rng_recvmsg crypto/algif_rng.c:101 [inline]
 rng_recvmsg+0x1af/0x2d0 crypto/algif_rng.c:114
 sock_recvmsg_nosec net/socket.c:1065 [inline]
 sock_recvmsg+0x2df/0x390 net/socket.c:1087
 sock_read_iter+0x2c8/0x360 net/socket.c:1157
 new_sync_read fs/read_write.c:491 [inline]
 vfs_read+0x857/0xf00 fs/read_write.c:572
 ksys_read fs/read_write.c:715 [inline]
 __do_sys_read fs/read_write.c:724 [inline]
 __se_sys_read fs/read_write.c:722 [inline]
 __x64_sys_read+0x1fb/0x4d0 fs/read_write.c:722
 x64_sys_call+0x2f9c/0x3e20 arch/x86/include/generated/asm/syscalls_64.h:1
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

<Zero or more stacks not recorded to save memory>

Uninit was stored to memory at:
 crypto_sha3_finup+0x136/0xe00 crypto/sha3_generic.c:202
 crypto_shash_op_and_zero crypto/shash.c:105 [inline]
 crypto_shash_finup+0x327/0xe80 crypto/shash.c:171
 jent_hash_time+0x247/0x590 crypto/jitterentropy-kcapi.c:138
 jent_condition_data+0x4f0/0x510 crypto/jitterentropy.c:438
 jent_measure_jitter+0x547/0x770 crypto/jitterentropy.c:541
 jent_gen_entropy+0x209/0x450 crypto/jitterentropy.c:569
 jent_read_entropy+0x353/0xeb0 crypto/jitterentropy.c:615
 jent_kcapi_random+0x6c/0x250 crypto/jitterentropy-kcapi.c:284
 crypto_rng_generate include/crypto/rng.h:144 [inline]
 _rng_recvmsg crypto/algif_rng.c:97 [inline]
 rng_recvmsg+0x149/0x2d0 crypto/algif_rng.c:114
 sock_recvmsg_nosec net/socket.c:1065 [inline]
 sock_recvmsg+0x2df/0x390 net/socket.c:1087
 sock_read_iter+0x2c8/0x360 net/socket.c:1157
 new_sync_read fs/read_write.c:491 [inline]
 vfs_read+0x857/0xf00 fs/read_write.c:572
 ksys_read fs/read_write.c:715 [inline]
 __do_sys_read fs/read_write.c:724 [inline]
 __se_sys_read fs/read_write.c:722 [inline]
 __x64_sys_read+0x1fb/0x4d0 fs/read_write.c:722
 x64_sys_call+0x2f9c/0x3e20 arch/x86/include/generated/asm/syscalls_64.h:1
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 crypto_shash_finup+0xc5a/0xe80 crypto/shash.c:162
 crypto_shash_update include/crypto/hash.h:994 [inline]
 jent_hash_time+0x1de/0x590 crypto/jitterentropy-kcapi.c:136
 jent_condition_data+0x4f0/0x510 crypto/jitterentropy.c:438
 jent_measure_jitter+0x547/0x770 crypto/jitterentropy.c:541
 jent_gen_entropy+0x209/0x450 crypto/jitterentropy.c:569
 jent_read_entropy+0x353/0xeb0 crypto/jitterentropy.c:615
 jent_kcapi_random+0x6c/0x250 crypto/jitterentropy-kcapi.c:284
 crypto_rng_generate include/crypto/rng.h:144 [inline]
 _rng_recvmsg crypto/algif_rng.c:97 [inline]
 rng_recvmsg+0x149/0x2d0 crypto/algif_rng.c:114
 sock_recvmsg_nosec net/socket.c:1065 [inline]
 sock_recvmsg+0x2df/0x390 net/socket.c:1087
 sock_read_iter+0x2c8/0x360 net/socket.c:1157
 new_sync_read fs/read_write.c:491 [inline]
 vfs_read+0x857/0xf00 fs/read_write.c:572
 ksys_read fs/read_write.c:715 [inline]
 __do_sys_read fs/read_write.c:724 [inline]
 __se_sys_read fs/read_write.c:722 [inline]
 __x64_sys_read+0x1fb/0x4d0 fs/read_write.c:722
 x64_sys_call+0x2f9c/0x3e20 arch/x86/include/generated/asm/syscalls_64.h:1
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 put_unaligned_le64 include/linux/unaligned.h:43 [inline]
 crypto_sha3_finup+0xc98/0xe00 crypto/sha3_generic.c:213
 crypto_shash_op_and_zero crypto/shash.c:105 [inline]
 crypto_shash_finup+0x327/0xe80 crypto/shash.c:171
 jent_hash_time+0x247/0x590 crypto/jitterentropy-kcapi.c:138
 jent_condition_data+0x4f0/0x510 crypto/jitterentropy.c:438
 jent_measure_jitter+0x547/0x770 crypto/jitterentropy.c:541
 jent_gen_entropy+0x209/0x450 crypto/jitterentropy.c:569
 jent_read_entropy+0x353/0xeb0 crypto/jitterentropy.c:615
 jent_kcapi_random+0x6c/0x250 crypto/jitterentropy-kcapi.c:284
 crypto_rng_generate include/crypto/rng.h:144 [inline]
 _rng_recvmsg crypto/algif_rng.c:97 [inline]
 rng_recvmsg+0x149/0x2d0 crypto/algif_rng.c:114
 sock_recvmsg_nosec net/socket.c:1065 [inline]
 sock_recvmsg+0x2df/0x390 net/socket.c:1087
 sock_read_iter+0x2c8/0x360 net/socket.c:1157
 new_sync_read fs/read_write.c:491 [inline]
 vfs_read+0x857/0xf00 fs/read_write.c:572
 ksys_read fs/read_write.c:715 [inline]
 __do_sys_read fs/read_write.c:724 [inline]
 __se_sys_read fs/read_write.c:722 [inline]
 __x64_sys_read+0x1fb/0x4d0 fs/read_write.c:722
 x64_sys_call+0x2f9c/0x3e20 arch/x86/include/generated/asm/syscalls_64.h:1
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 keccakf_round crypto/sha3_generic.c:-1 [inline]
 keccakf+0x1efb/0x2110 crypto/sha3_generic.c:155
 crypto_sha3_finup+0x772/0xe00 crypto/sha3_generic.c:210
 crypto_shash_op_and_zero crypto/shash.c:105 [inline]
 crypto_shash_finup+0x327/0xe80 crypto/shash.c:171
 jent_hash_time+0x247/0x590 crypto/jitterentropy-kcapi.c:138
 jent_condition_data+0x4f0/0x510 crypto/jitterentropy.c:438
 jent_measure_jitter+0x547/0x770 crypto/jitterentropy.c:541
 jent_gen_entropy+0x209/0x450 crypto/jitterentropy.c:569
 jent_read_entropy+0x353/0xeb0 crypto/jitterentropy.c:615
 jent_kcapi_random+0x6c/0x250 crypto/jitterentropy-kcapi.c:284
 crypto_rng_generate include/crypto/rng.h:144 [inline]
 _rng_recvmsg crypto/algif_rng.c:97 [inline]
 rng_recvmsg+0x149/0x2d0 crypto/algif_rng.c:114
 sock_recvmsg_nosec net/socket.c:1065 [inline]
 sock_recvmsg+0x2df/0x390 net/socket.c:1087
 sock_read_iter+0x2c8/0x360 net/socket.c:1157
 new_sync_read fs/read_write.c:491 [inline]
 vfs_read+0x857/0xf00 fs/read_write.c:572
 ksys_read fs/read_write.c:715 [inline]
 __do_sys_read fs/read_write.c:724 [inline]
 __se_sys_read fs/read_write.c:722 [inline]
 __x64_sys_read+0x1fb/0x4d0 fs/read_write.c:722
 x64_sys_call+0x2f9c/0x3e20 arch/x86/include/generated/asm/syscalls_64.h:1
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 crypto_sha3_finup+0x5be/0xe00 crypto/sha3_generic.c:207
 crypto_shash_op_and_zero crypto/shash.c:105 [inline]
 crypto_shash_finup+0x327/0xe80 crypto/shash.c:171
 jent_hash_time+0x247/0x590 crypto/jitterentropy-kcapi.c:138
 jent_condition_data+0x4f0/0x510 crypto/jitterentropy.c:438
 jent_measure_jitter+0x547/0x770 crypto/jitterentropy.c:541
 jent_gen_entropy+0x209/0x450 crypto/jitterentropy.c:569
 jent_read_entropy+0x353/0xeb0 crypto/jitterentropy.c:615
 jent_kcapi_random+0x6c/0x250 crypto/jitterentropy-kcapi.c:284
 crypto_rng_generate include/crypto/rng.h:144 [inline]
 _rng_recvmsg crypto/algif_rng.c:97 [inline]
 rng_recvmsg+0x149/0x2d0 crypto/algif_rng.c:114
 sock_recvmsg_nosec net/socket.c:1065 [inline]
 sock_recvmsg+0x2df/0x390 net/socket.c:1087
 sock_read_iter+0x2c8/0x360 net/socket.c:1157
 new_sync_read fs/read_write.c:491 [inline]
 vfs_read+0x857/0xf00 fs/read_write.c:572
 ksys_read fs/read_write.c:715 [inline]
 __do_sys_read fs/read_write.c:724 [inline]
 __se_sys_read fs/read_write.c:722 [inline]
 __x64_sys_read+0x1fb/0x4d0 fs/read_write.c:722
 x64_sys_call+0x2f9c/0x3e20 arch/x86/include/generated/asm/syscalls_64.h:1
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 crypto_sha3_finup+0x136/0xe00 crypto/sha3_generic.c:202
 crypto_shash_op_and_zero crypto/shash.c:105 [inline]
 crypto_shash_finup+0x327/0xe80 crypto/shash.c:171
 jent_hash_time+0x247/0x590 crypto/jitterentropy-kcapi.c:138
 jent_condition_data+0x4f0/0x510 crypto/jitterentropy.c:438
 jent_measure_jitter+0x547/0x770 crypto/jitterentropy.c:541
 jent_gen_entropy+0x209/0x450 crypto/jitterentropy.c:569
 jent_read_entropy+0x353/0xeb0 crypto/jitterentropy.c:615
 jent_kcapi_random+0x6c/0x250 crypto/jitterentropy-kcapi.c:284
 crypto_rng_generate include/crypto/rng.h:144 [inline]
 _rng_recvmsg crypto/algif_rng.c:97 [inline]
 rng_recvmsg+0x149/0x2d0 crypto/algif_rng.c:114
 sock_recvmsg_nosec net/socket.c:1065 [inline]
 sock_recvmsg+0x2df/0x390 net/socket.c:1087
 sock_read_iter+0x2c8/0x360 net/socket.c:1157
 new_sync_read fs/read_write.c:491 [inline]
 vfs_read+0x857/0xf00 fs/read_write.c:572
 ksys_read fs/read_write.c:715 [inline]
 __do_sys_read fs/read_write.c:724 [inline]
 __se_sys_read fs/read_write.c:722 [inline]
 __x64_sys_read+0x1fb/0x4d0 fs/read_write.c:722
 x64_sys_call+0x2f9c/0x3e20 arch/x86/include/generated/asm/syscalls_64.h:1
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 crypto_shash_finup+0xc5a/0xe80 crypto/shash.c:162
 crypto_shash_update include/crypto/hash.h:994 [inline]
 jent_hash_time+0x1de/0x590 crypto/jitterentropy-kcapi.c:136
 jent_condition_data+0x4f0/0x510 crypto/jitterentropy.c:438
 jent_measure_jitter+0x547/0x770 crypto/jitterentropy.c:541
 jent_gen_entropy+0x209/0x450 crypto/jitterentropy.c:569
 jent_read_entropy+0x353/0xeb0 crypto/jitterentropy.c:615
 jent_kcapi_random+0x6c/0x250 crypto/jitterentropy-kcapi.c:284
 crypto_rng_generate include/crypto/rng.h:144 [inline]
 _rng_recvmsg crypto/algif_rng.c:97 [inline]
 rng_recvmsg+0x149/0x2d0 crypto/algif_rng.c:114
 sock_recvmsg_nosec net/socket.c:1065 [inline]
 sock_recvmsg+0x2df/0x390 net/socket.c:1087
 sock_read_iter+0x2c8/0x360 net/socket.c:1157
 new_sync_read fs/read_write.c:491 [inline]
 vfs_read+0x857/0xf00 fs/read_write.c:572
 ksys_read fs/read_write.c:715 [inline]
 __do_sys_read fs/read_write.c:724 [inline]
 __se_sys_read fs/read_write.c:722 [inline]
 __x64_sys_read+0x1fb/0x4d0 fs/read_write.c:722
 x64_sys_call+0x2f9c/0x3e20 arch/x86/include/generated/asm/syscalls_64.h:1
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Local variable intermediary created at:
 jent_hash_time+0x9b/0x590 crypto/jitterentropy-kcapi.c:110
 jent_condition_data+0x4f0/0x510 crypto/jitterentropy.c:438

Bytes 0-23 of 24 are uninitialized
Memory access of size 24 starts at ffff88811855fb70
Data copied to user address 00002000000001c0

CPU: 1 UID: 0 PID: 5820 Comm: syz-executor170 Not tainted 6.16.0-syzkaller-11952-g6e64f4580381 #0 PREEMPT(none) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
