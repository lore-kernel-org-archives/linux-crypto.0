Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5CE1A23AC;
	Tue, 21 Oct 2025 06:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761026497; cv=none; b=L14oZUeArHKeAct1hYY5QIqvbKBi9vGhd0a83shs0jGcYYpwjPMvKZAuwT7nxjQHFAR48vjbnmJou0t0iyZsjwqGOG0x8KwzgnIwbg2fJwgP+2ehtJJzobS5+7RJaQbbvTptgkJ8A2rKMyMEDAd8zRXAAOO6nQpspqP2Ey0rW9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761026497; c=relaxed/simple;
	bh=Y352Bel61Zm8i1QWPYkSlbQPAribwoB36DafzkL3EiE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=i4pqiOsnu7G/PPKIyy5GALrTzH08ymNNXCLrNdc63mE88s7aDyk24UA3nq7CWfLdHQaDQwC9sgXb5lOgvCPBznLl4ivw9KIJ9v891pgYIxeNkwHgQxlbhGRKS4dK2rB7dsyADjcqZ4hqkE/jYR7Ry6CI8CMFpmCf06CKgN4stX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 60d40906ae4311f0a38c85956e01ac42-20251021
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:2c54c30f-57e7-44a5-a4b0-d2e66808cd77,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:f5c685ca54730ba201b475cdf8606913,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850,TC:nil,Content:0|50,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 60d40906ae4311f0a38c85956e01ac42-20251021
X-User: xiaopei01@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1039226372; Tue, 21 Oct 2025 14:01:25 +0800
From: Pei Xiao <xiaopei01@kylinos.cn>
To: ebiggers@kernel.org,
	Jason@zx2c4.com,
	ardb@kernel.org,
	ubizjak@gmail.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Pei Xiao <xiaopei01@kylinos.cn>,
	syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
Subject: [PATCH] lib/crypto: poly1305: fix uninit-value in poly1305_blocks
Date: Tue, 21 Oct 2025 14:01:20 +0800
Message-Id: <751b3d80293a6f599bb07770afcef24f623c7da0.1761026343.git.xiaopei01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

syzbot reports uninit-value in poly1305_blocks:

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

in poly1305_blocks, ctx->is_base2_26 is uninit-value, ctx init in：
poly1305_init ->
     poly1305_block_init

so add memset in poly1305_block_init, then use poly1305_init_x86_64 to init
by asm.

Reported-by: syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
Tested-by: syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
---
 lib/crypto/x86/poly1305.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/crypto/x86/poly1305.h b/lib/crypto/x86/poly1305.h
index ee92e3740a78..3b9f1024a18d 100644
--- a/lib/crypto/x86/poly1305.h
+++ b/lib/crypto/x86/poly1305.h
@@ -8,6 +8,7 @@
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/sizes.h>
+#include <linux/string.h>
 
 struct poly1305_arch_internal {
 	union {
@@ -86,6 +87,7 @@ static __ro_after_init DEFINE_STATIC_KEY_FALSE(poly1305_use_avx512);
 static void poly1305_block_init(struct poly1305_block_state *state,
 				const u8 raw_key[POLY1305_BLOCK_SIZE])
 {
+	memset(state, 0, sizeof(struct poly1305_block_state));
 	poly1305_init_x86_64(state, raw_key);
 }
 
-- 
2.25.1

