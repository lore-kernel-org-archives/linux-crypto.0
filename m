Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89F01E868
	for <linux-crypto@vger.kernel.org>; Tue, 21 Oct 2025 02:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761015064; cv=none; b=ckOU30pcZnUF9nNlTPpE7ztzm8DgE44ZWNpNsG0nV2K6maeH2jkh8GURXKgNV0iCcptCv8k44W1tAydQ+UfPP7lfUcMbQKQZBXg4UnIJg9pm188ajJFGtLIenxcNHGZBjWEeAzV8PuofLppUA4CUXN72jw10LRJPu+0oEG4ZQjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761015064; c=relaxed/simple;
	bh=IIYe2dPIZrycyaPLEXaR+fRISOJY/jOMEOoUOUmCn+k=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=kjSss6Hhd2sSi4+DtJ7ez65wz0Gb8rb0SStxRLSBR2v7h40UQtiKQHGmds9ob4pMoG1deJZdhWwHfob7IOfVj1CmX4pRrNcTCqrbvIIjUDgXdtRenQCIr+psCZoP+wf90QrtQ92s735/vj5iklxPaxs1JLspWUIg+AfqmtkY5Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-430d83d262fso87040285ab.2
        for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 19:51:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761015062; x=1761619862;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wXSZh+LhsJ2L/ekgxcnIbfTrKmZcZiu6txpf6OpGVxQ=;
        b=MkzMSONnbg60VAOeh7j2Ct1qGJIOfCK6oYggrPpIRhz/6ZsY/+QeHwMxG11BMRoMQO
         BTi1dIsoWBgw/u9s3/sqR7+c/FLh216bS2nsNae9cZDKXvZFjOG5zpEWUjNyd9EAuArZ
         btGp1XCnQ2HH0mjL0rU/zHmljE+Kt7/q1Ul2tGFwxDG6L0Zfl70jQzQUAjOuT5EN1I98
         SrceH+UeodMBwGaIk7E8CwyjPyKo6JWWcubyHw7MmEb9w9oymTrSA41bq+44gnHEQgz2
         Is7Bv+KAWia++pJOcO6fTlJJYYcYKNNNgmg337M9wZFYbpT0aVfJ4jZsToDPIA6K/l8z
         rzXw==
X-Forwarded-Encrypted: i=1; AJvYcCWXzs60oEU/3m57TQc2cv3C8Wv1noXFZq21NEGYn4/rBhYsEDENxztYGmHsIyQVbrGrwEB5RKt4HDUbO4E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTHW3ABuCchT4y5EQXpt8auvRRyQlnTLkKIQDrJ371kHYY9spo
	WxVNFW+I17OdP9i2OABdeTAEKMCJV7PWBRlqQZXa0v139o729TInT4RMgw/I+k7+rCaWGLAUShO
	ZA27N7bGQ/xT9m0QAUzE7QyblyQUapsxvzogTlDHMvZUhtBLDz/F2OD8+Abc=
X-Google-Smtp-Source: AGHT+IHvZHgVqZ2gLYBy1BwzdWwdDpnEx8KDqOxqqZr4ueOTARER0kfWHjvw+Xsp5JCASB+duBwHVP9LeadQPpVkIg3BxVX5HqNM
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a2b:b0:430:ab98:7b27 with SMTP id
 e9e14a558f8ab-430c527d375mr222509045ab.20.1761015062186; Mon, 20 Oct 2025
 19:51:02 -0700 (PDT)
Date: Mon, 20 Oct 2025 19:51:02 -0700
In-Reply-To: <287c3a106ca4565311685d637af0884c5a6bdea2.1761011646.git.xiaopei01@kylinos.cn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f6f516.050a0220.346f24.0002.GAE@google.com>
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in poly1305_blocks
From: syzbot <syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, xiaopei01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KMSAN: uninit-value in poly1305_blocks

=====================================================
BUG: KMSAN: uninit-value in poly1305_blocks+0x1a9/0x5f0 lib/crypto/x86/poly1305.h:110
 poly1305_blocks+0x1a9/0x5f0 lib/crypto/x86/poly1305.h:110
 poly1305_update+0x169/0x400 lib/crypto/poly1305.c:50
 poly_hash+0x9f3/0x1a00 crypto/chacha20poly1305.c:168
 poly_genkey+0x3b6/0x450 crypto/chacha20poly1305.c:233
 chacha_encrypt crypto/chacha20poly1305.c:269 [inline]
 chachapoly_encrypt+0x48a/0x5c0 crypto/chacha20poly1305.c:284
 crypto_aead_encrypt+0xe2/0x160 crypto/aead.c:91
 tls_do_encryption net/tls/tls_sw.c:582 [inline]
 tls_push_record+0x38c7/0x5810 net/tls/tls_sw.c:819
 bpf_exec_tx_verdict+0x1a0c/0x26a0 net/tls/tls_sw.c:859
 tls_sw_sendmsg_locked net/tls/tls_sw.c:1138 [inline]
 tls_sw_sendmsg+0x3401/0x4560 net/tls/tls_sw.c:1281
 inet6_sendmsg+0x26c/0x2a0 net/ipv6/af_inet6.c:659
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x145/0x3d0 net/socket.c:742
 sock_write_iter+0x3a6/0x420 net/socket.c:1195
 do_iter_readv_writev+0x9e1/0xc20 fs/read_write.c:-1
 vfs_writev+0x52a/0x1500 fs/read_write.c:1057
 do_writev+0x1b5/0x580 fs/read_write.c:1103
 __do_sys_writev fs/read_write.c:1171 [inline]
 __se_sys_writev fs/read_write.c:1168 [inline]
 __x64_sys_writev+0x99/0xf0 fs/read_write.c:1168
 x64_sys_call+0x24b1/0x3e30 arch/x86/include/generated/asm/syscalls_64.h:21
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Local variable desc created at:
 poly_hash+0x11d/0x1a00 crypto/chacha20poly1305.c:135
 poly_genkey+0x3b6/0x450 crypto/chacha20poly1305.c:233

CPU: 1 UID: 0 PID: 6603 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(none) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
=====================================================


Tested on:

commit:         6548d364 Merge tag 'cgroup-for-6.18-rc2-fixes' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11d40d2f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bbd3e7f3c2e28265
dashboard link: https://syzkaller.appspot.com/bug?extid=01fcd39a0d90cdb0e3df
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14c58e7c580000

