Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F154728F93B
	for <linux-crypto@vger.kernel.org>; Thu, 10 Apr 2025 18:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744310049; cv=none; b=kWfNvMOYp1+yYVkvYGnshWhLgu0S6d3SsCt2QYXivGsmwW5mECWCIxpVYWYtDu3vvvmG5SWUxcydWxEelcfGhzcCJlMUIg7lS4NyXYxsvu3uJyveMDormnwb55p1m5HSaA/lq4ps+NdJ2b6CjuSo+wCx9M5ZjWSJ/F8TkVcYq2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744310049; c=relaxed/simple;
	bh=qUQkVCaT5LwTAKPjNitSCqujLbD7jQ6Sq7zNCCAxGdI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UDTuEdL5mkjcXNle6cs6PpB8hquEAN1piknJHv0n8a08fdfqoNHSSKH49w5Rg7JSFwQ1uum0CivaGyyGTgohsH1AB5iELSk7jnaOxyFqwODODGkebImTE+UgRK0jbt4JHQr+OvGYMFjd7Bigcf5D3Xd44QpROY0ozlAgfdi57YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=T0nhs2IL; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="T0nhs2IL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1744310047; x=1775846047;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6r4Spd0PKn5b4K7o9QUgjSGdM4FPJXmF1LMDYSWZtvM=;
  b=T0nhs2ILKog1VtrzCsSvZbJYBumOFEBDQ06t99YhOfPTplV8QuCxFIhr
   Qsv0ZC5A7D3hdzqsietrDM+/RsI0Rt+L9dS+NuPRz28BzVZI+5whC7qxO
   LsNLE/Pl1U64COQ4Dj6PrYU5PS8/5AFuT57CWzFDLu1IvywFVagydPQy1
   4=;
X-IronPort-AV: E=Sophos;i="6.15,202,1739836800"; 
   d="scan'208";a="82651615"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 18:34:04 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.21.151:39722]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.120:2525] with esmtp (Farcaster)
 id dde2529f-fe83-4906-9817-da9e43601c90; Thu, 10 Apr 2025 18:34:03 +0000 (UTC)
X-Farcaster-Flow-ID: dde2529f-fe83-4906-9817-da9e43601c90
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 10 Apr 2025 18:34:01 +0000
Received: from 6c7e67bfbae3.amazon.com (10.106.100.21) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Thu, 10 Apr 2025 18:33:59 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <linux-crypto@vger.kernel.org>, syzkaller
	<syzkaller@googlegroups.com>
Subject: [PATCH] crypto: scomp - Fix wild memory accesses in scomp_free_streams().
Date: Thu, 10 Apr 2025 11:33:45 -0700
Message-ID: <20250410183347.87669-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D045UWC003.ant.amazon.com (10.13.139.198) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

syzkaller reported the splat below [0].

When alg->alloc_ctx() fails, alg is passed to scomp_free_streams(),
but alg->stream is still NULL there.

Also, ps->ctx has ERR_PTR(), which would bypass the NULL check and
could be passed to alg->free_ctx(ps->ctx).

Let's fix the two wild memory accesses.

[0]:
BUG: unable to handle page fault for address: ffe21c0032422608
 PF: supervisor read access in kernel mode
 PF: error_code(0x0000) - not-present page
PGD 13fef4067 P4D 13fef3067 PUD 13fef2067 PMD 0
Oops: Oops: 0000 [#1] SMP KASAN
CPU: 0 UID: 0 PID: 316 Comm: syz-executor483 Not tainted 6.14.0-13344-ga9843689e2de #28 PREEMPT(voluntary)  167b7ecb8f281ed56016416cdf1d8bb342db88fc
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
RIP: 0010:scomp_free_streams crypto/scompress.c:117 [inline]
RIP: 0010:scomp_alloc_streams crypto/scompress.c:140 [inline]
RIP: 0010:crypto_scomp_init_tfm+0x5b0/0x7e0 crypto/scompress.c:158
Code: 74 08 48 89 df e8 90 74 8a ff 48 8b 03 48 8b 0c 24 48 8d 1c 08 48 83 c3 40 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 62 74 8a ff 48 8b 1b 48 85 db 0f 84
RSP: 0018:ffa000000154f028 EFLAGS: 00010a02
RAX: 1fe2200032422608 RBX: ff11000192113040 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 1ffffffff0c0463f R08: ffffffff872f7bb7 R09: 1ffffffff0e5ef76
R10: dffffc0000000000 R11: fffffbfff0e5ef77 R12: 0000000000000000
R13: ffffffff86c93028 R14: ffd1ffffffc0ebf8 R15: 1ffa3ffffff81d7f
FS:  00007f35c192a740(0000) GS:ff11000192113000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffe21c0032422608 CR3: 00000001062f0003 CR4: 0000000000771ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 crypto_create_tfm_node+0x163/0x3b0 crypto/api.c:532
 crypto_create_tfm crypto/internal.h:136 [inline]
 crypto_init_scomp_ops_async+0x59/0x120 crypto/scompress.c:338
 crypto_create_tfm_node+0x163/0x3b0 crypto/api.c:532
 crypto_alloc_tfm_node+0x172/0x3e0 crypto/api.c:633
 ipcomp_init_state+0x14d/0x2a0 net/xfrm/xfrm_ipcomp.c:345
 ipcomp4_init_state+0xcc/0x9f0 net/ipv4/ipcomp.c:137
 __xfrm_init_state+0xa74/0x13d0 net/xfrm/xfrm_state.c:3178
 xfrm_state_construct net/xfrm/xfrm_user.c:922 [inline]
 xfrm_add_sa+0x2f11/0x4000 net/xfrm/xfrm_user.c:986
 xfrm_user_rcv_msg+0x61d/0x890 net/xfrm/xfrm_user.c:3459
 netlink_rcv_skb+0x204/0x470 net/netlink/af_netlink.c:2534
 xfrm_netlink_rcv+0x79/0x90 net/xfrm/xfrm_user.c:3481
 netlink_unicast_kernel net/netlink/af_netlink.c:1313 [inline]
 netlink_unicast+0x754/0x8c0 net/netlink/af_netlink.c:1339
 netlink_sendmsg+0x800/0xb20 net/netlink/af_netlink.c:1883
 sock_sendmsg_nosec net/socket.c:712 [inline]
 __sock_sendmsg net/socket.c:727 [inline]
 ____sys_sendmsg+0x5ee/0x960 net/socket.c:2566
 ___sys_sendmsg+0x1e6/0x260 net/socket.c:2620
 __sys_sendmsg net/socket.c:2652 [inline]
 __do_sys_sendmsg net/socket.c:2657 [inline]
 __se_sys_sendmsg net/socket.c:2655 [inline]
 __x64_sys_sendmsg+0x18a/0x250 net/socket.c:2655
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe4/0x1c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7f35c196be5d
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 73 9f 1b 00 f7 d8 64 89 01 48
RSP: 002b:00007fffd68e23a8 EFLAGS: 00000206 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f35c196be5d
RDX: 0000000000000800 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 0000000000000004 R08: 00007fffd68e2146 R09: 0000004000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 431bde82d7b634db
R13: 00007fffd68e23d0 R14: 0000000000403df0 R15: 00007f35c1b76000
 </TASK>
Modules linked in:
CR2: ffe21c0032422608

Fixes: 3d72ad46a23a ("crypto: acomp - Move stream management into scomp layer")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 crypto/scompress.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index f67ce38d203d..f00ab9720454 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -106,14 +106,11 @@ static int crypto_scomp_alloc_scratches(void)
 	return -ENOMEM;
 }
 
-static void scomp_free_streams(struct scomp_alg *alg)
+static void __scomp_free_streams(struct scomp_alg *alg,
+				 struct crypto_acomp_stream __percpu *stream)
 {
-	struct crypto_acomp_stream __percpu *stream = alg->stream;
 	int i;
 
-	if (!stream)
-		return;
-
 	for_each_possible_cpu(i) {
 		struct crypto_acomp_stream *ps = per_cpu_ptr(stream, i);
 
@@ -126,6 +123,16 @@ static void scomp_free_streams(struct scomp_alg *alg)
 	free_percpu(stream);
 }
 
+static void scomp_free_streams(struct scomp_alg *alg)
+{
+	struct crypto_acomp_stream __percpu *stream = alg->stream;
+
+	if (!stream)
+		return;
+
+	__scomp_free_streams(alg, stream);
+}
+
 static int scomp_alloc_streams(struct scomp_alg *alg)
 {
 	struct crypto_acomp_stream __percpu *stream;
@@ -140,8 +147,11 @@ static int scomp_alloc_streams(struct scomp_alg *alg)
 
 		ps->ctx = alg->alloc_ctx();
 		if (IS_ERR(ps->ctx)) {
-			scomp_free_streams(alg);
-			return PTR_ERR(ps->ctx);
+			int err = PTR_ERR(ps->ctx);
+
+			ps->ctx = NULL;
+			__scomp_free_streams(alg, stream);
+			return err;
 		}
 
 		spin_lock_init(&ps->lock);
-- 
2.49.0

