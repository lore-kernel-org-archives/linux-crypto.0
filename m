From: Laura Abbott <labbott@redhat.com>
Subject: [REGRESSION] 493b2ed3f760 ("crypto: algif_hash - Handle NULL hashes
 correctly")
Date: Wed, 16 Nov 2016 16:21:11 -0800
Message-ID: <58ae2cae-4d60-01bd-97fd-68ad702503a5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:33240 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938752AbcKQAVQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2016 19:21:16 -0500
Received: by mail-qk0-f174.google.com with SMTP id x190so198051651qkb.0
        for <linux-crypto@vger.kernel.org>; Wed, 16 Nov 2016 16:21:15 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Fedora got a bugzilla https://bugzilla.redhat.com/show_bug.cgi?id=1395896
of an oops with this program:

#include <linux/if_alg.h>
#include <stddef.h>
#include <sys/socket.h>

int main(int argc, char *argv[]) {
        static const union {
                struct sockaddr sa;
                struct sockaddr_alg alg;
        } sa = {
                .alg.salg_family = AF_ALG,
                .alg.salg_type = "hash",
                .alg.salg_name = "sha256",
        };
        char c;
        int fd1, fd2;

        fd1 = socket(AF_ALG, SOCK_SEQPACKET, 0);
        bind(fd1, &sa.sa, sizeof(sa));
        fd2 = accept(fd1, NULL, 0);
        recv(fd2, &c, sizeof(c), 0);

        return 0;
}


[   10.802304] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[   10.803970] IP: [<ffffffff812f743e>] shash_ahash_digest+0x1e/0x100
[   10.805046] PGD eb37067 PUD 12425067 PMD 0 
[   10.806019] Oops: 0000 [#1] SMP
[   10.806702] Modules linked in:
[   10.807421] CPU: 0 PID: 1098 Comm: a.out Not tainted 4.8.0-rc1+ #29
[   10.808444] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
[   10.809839] task: ffff880010a92400 task.stack: ffff880012458000
[   10.810653] RIP: 0010:[<ffffffff812f743e>]  [<ffffffff812f743e>] shash_ahash_digest+0x1e/0x100
[   10.811979] RSP: 0018:ffff88001245bd48  EFLAGS: 00010246
[   10.812730] RAX: 0000000000001000 RBX: ffff88001249b390 RCX: 0000000000000000
[   10.814419] RDX: 0000000000000000 RSI: ffff88001249b390 RDI: ffff88001249b340
[   10.815303] RBP: ffff88001245bd68 R08: ffff88000eb54fa0 R09: 0000000000000000
[   10.816126] R10: ffff88000eb547d0 R11: 0000000000000001 R12: ffffffff812f7520
[   10.816946] R13: ffff88001249b340 R14: ffff88001245be38 R15: 0000000000000000
[   10.818098] FS:  00007f1849f3a700(0000) GS:ffff880011800000(0000) knlGS:0000000000000000
[   10.819644] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   10.820370] CR2: 0000000000000008 CR3: 000000000eb36000 CR4: 00000000000006f0
[   10.821198] Stack:
[   10.821641]  ffff88001249b340 ffffffff812f7520 ffff880012498c18 ffff88001245be38
[   10.822905]  ffff88001245bd78 ffffffff812f753f ffff88001245bda0 ffffffff812f6aa4
[   10.824168]  ffff88001249b060 ffff88001249b060 0000000000000001 ffff88001245bdb0
[   10.825434] Call Trace:
[   10.825910]  [<ffffffff812f7520>] ? shash_ahash_digest+0x100/0x100
[   10.826663]  [<ffffffff812f753f>] shash_async_digest+0x1f/0x30
[   10.827389]  [<ffffffff812f6aa4>] crypto_ahash_op+0x24/0x60
[   10.828097]  [<ffffffff812f6b31>] crypto_ahash_digest+0x11/0x20
[   10.828835]  [<ffffffff813087a4>] hash_recvmsg+0x1a4/0x1c0
[   10.829539]  [<ffffffff817253b8>] sock_recvmsg+0x38/0x40
[   10.830232]  [<ffffffff817255ab>] SYSC_recvfrom+0xcb/0x130
[   10.830937]  [<ffffffff81724ccf>] ? sock_map_fd+0x3f/0x60
[   10.831635]  [<ffffffff81726729>] SyS_recvfrom+0x9/0x10
[   10.832317]  [<ffffffff81922572>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[   10.833091] Code: 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 55 b8 00 10 00 00 48 89 e5 41 56 41 55 41 54 53 49 89 fd 48 8b 4f 38 41 8b 55 30 48 89 f3 <8b> 79 08 29 f8 39 41 0c 0f 46 41 0c 39 c2 73 74 48 8b 31 48 83 
[   10.838754] RIP  [<ffffffff812f743e>] shash_ahash_digest+0x1e/0x100
[   10.839560]  RSP <ffff88001245bd48>
[   10.840112] CR2: 0000000000000008
[   10.840674] ---[ end trace 4314dcc948f7acad ]---
[   10.841320] Kernel panic - not syncing: Fatal exception
[   10.842106] Kernel Offset: disabled

It looks like hash_recvmsg sets the sg to NULL with 

ahash_request_set_crypt(&ctx->req, NULL, ctx->result, 0);

which then blows up when crypto_ahash_digest -> hash_ahash_digest
tries to access it. 

Thanks,
Laura
