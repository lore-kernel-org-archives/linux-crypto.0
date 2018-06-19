From: syzbot <syzbot+db0b320fadd1b9853ebb@syzkaller.appspotmail.com>
Subject: general protection fault in scatterwalk_copychunks (3)
Date: Mon, 18 Jun 2018 21:19:01 -0700
Message-ID: <0000000000005e4690056ef6fb66@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9ffc59d57228 Merge tag '4.18-rc1-more-smb3-fixes' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=113b25bf800000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f390986c4f7cd566
dashboard link: https://syzkaller.appspot.com/bug?extid=db0b320fadd1b9853ebb
compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=16daf58f800000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1376023f800000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+db0b320fadd1b9853ebb@syzkaller.appspotmail.com

RBP: 00007fff94c3a530 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000005 R11: 0000000000000246 R12: ffffffffffffffff
R13: 0000000000000006 R14: 0000000000000000 R15: 0000000000000000
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] SMP KASAN
CPU: 0 PID: 4538 Comm: syz-executor098 Not tainted 4.18.0-rc1+ #108
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:scatterwalk_start include/crypto/scatterwalk.h:86 [inline]
RIP: 0010:scatterwalk_pagedone include/crypto/scatterwalk.h:111 [inline]
RIP: 0010:scatterwalk_copychunks+0x3ae/0x500 crypto/scatterwalk.c:55
Code: 4c 89 f8 48 c1 e8 03 80 3c 08 00 0f 85 2b 01 00 00 49 8d 7c 24 08 4d  
89 27 48 ba 00 00 00 00 00 fc ff df 48 89 f8 48 c1 e8 03 <0f> b6 04 10 84  
c0 74 08 3c 03 0f 8e 34 01 00 00 48 8b 45 c8 0f b6
RSP: 0018:ffff8801d920eb10 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000022 RCX: dffffc0000000000
RDX: dffffc0000000000 RSI: ffffffff835bb712 RDI: 0000000000000008
RBP: ffff8801d920eb60 R08: ffff8801d8d86400 R09: ffffed0038774002
R10: ffffed0038774004 R11: ffff8801c3ba0021 R12: 0000000000000000
R13: 0000000000000022 R14: 0000000000000005 R15: ffff8801d920eba8
FS:  00000000010b6880(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004b63d8 CR3: 00000001acd52000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  scatterwalk_map_and_copy+0x1f0/0x260 crypto/scatterwalk.c:72
  gcmaes_crypt_by_sg+0xcee/0x1ee0 arch/x86/crypto/aesni-intel_glue.c:908
  gcmaes_encrypt.constprop.16+0x716/0xf10  
arch/x86/crypto/aesni-intel_glue.c:929
  generic_gcmaes_encrypt+0x12d/0x186 arch/x86/crypto/aesni-intel_glue.c:1294
  crypto_aead_encrypt include/crypto/aead.h:335 [inline]
  gcmaes_wrapper_encrypt+0x162/0x200 arch/x86/crypto/aesni-intel_glue.c:1127
  crypto_aead_encrypt include/crypto/aead.h:335 [inline]
  tls_do_encryption net/tls/tls_sw.c:211 [inline]
  tls_push_record+0x966/0x1400 net/tls/tls_sw.c:247
  tls_sw_sendpage+0x5ff/0xf60 net/tls/tls_sw.c:601
  inet_sendpage+0x1de/0x750 net/ipv4/af_inet.c:815
  kernel_sendpage+0x93/0xf0 net/socket.c:3367
  sock_sendpage+0x8c/0xc0 net/socket.c:870
  pipe_to_sendpage+0x2d0/0x400 fs/splice.c:452
  splice_from_pipe_feed fs/splice.c:503 [inline]
  __splice_from_pipe+0x38e/0x7c0 fs/splice.c:627
  splice_from_pipe+0x1ea/0x340 fs/splice.c:662
  generic_splice_sendpage+0x3c/0x50 fs/splice.c:833
  do_splice_from fs/splice.c:852 [inline]
  direct_splice_actor+0x128/0x190 fs/splice.c:1019
  splice_direct_to_actor+0x318/0x8f0 fs/splice.c:974
  do_splice_direct+0x2d4/0x420 fs/splice.c:1062
  do_sendfile+0x623/0xe20 fs/read_write.c:1440
  __do_sys_sendfile64 fs/read_write.c:1495 [inline]
  __se_sys_sendfile64 fs/read_write.c:1487 [inline]
  __x64_sys_sendfile64+0x15d/0x250 fs/read_write.c:1487
  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440cc9
Code: e8 0c b6 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 9b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff94c3a518 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000440cc9
RDX: 00000000200000c0 RSI: 0000000000000005 RDI: 0000000000000004
RBP: 00007fff94c3a530 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000005 R11: 0000000000000246 R12: ffffffffffffffff
R13: 0000000000000006 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
Dumping ftrace buffer:
    (ftrace buffer empty)
---[ end trace 687f8ba94a271f8a ]---
RIP: 0010:scatterwalk_start include/crypto/scatterwalk.h:86 [inline]
RIP: 0010:scatterwalk_pagedone include/crypto/scatterwalk.h:111 [inline]
RIP: 0010:scatterwalk_copychunks+0x3ae/0x500 crypto/scatterwalk.c:55
Code: 4c 89 f8 48 c1 e8 03 80 3c 08 00 0f 85 2b 01 00 00 49 8d 7c 24 08 4d  
89 27 48 ba 00 00 00 00 00 fc ff df 48 89 f8 48 c1 e8 03 <0f> b6 04 10 84  
c0 74 08 3c 03 0f 8e 34 01 00 00 48 8b 45 c8 0f b6
RSP: 0018:ffff8801d920eb10 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000022 RCX: dffffc0000000000
RDX: dffffc0000000000 RSI: ffffffff835bb712 RDI: 0000000000000008
RBP: ffff8801d920eb60 R08: ffff8801d8d86400 R09: ffffed0038774002
R10: ffffed0038774004 R11: ffff8801c3ba0021 R12: 0000000000000000
R13: 0000000000000022 R14: 0000000000000005 R15: ffff8801d920eba8
FS:  00000000010b6880(0000) GS:ffff8801dae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004b63d8 CR3: 00000001acd52000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
