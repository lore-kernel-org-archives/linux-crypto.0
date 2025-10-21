Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0080D7E105;
	Tue, 21 Oct 2025 01:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761011700; cv=none; b=ObuR32jyGtLKR0R/sBQOZh04nzAcFr6cUvZ0jUkXBD9xB8qS9ueLOynXFrPm+ZVosdMUtzdo5i+QHZ8UcOuNA96oUKMqfpIJg1+jWIizMZ/xCjMIDDtEKO6grq0wbMvb0gXuG846jl/VqZREkalMtds3D+s9rkz/qhJ5S5mXva0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761011700; c=relaxed/simple;
	bh=k67S5mOZusmV0HZQ3DexRmg2w3RlJTUA/f8y9L63NZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GJtSfqnQbgiqkswJ9Kr1rzYSai0ezEqT0On8b2BUlXwR8x222yb1E/ODb6FGVOk8kfRnVqAEvQkb3LHymvKG4+yoSS2Kz0ufDB2F0et71E3hWSZlp+eO+oHlUQbend4G1t5dqzSP86n6K8VLyVk0/0w8OTHiwfrzUp2hSO30sPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ed3b6aceae2011f0a38c85956e01ac42-20251021
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:793db734-4ff4-45e2-9e85-dabbbc081d5e,IP:0,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:25
X-CID-META: VersionHash:a9d874c,CLOUDID:a99d211a2bcf1e17a23bfdddff75a54d,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850,TC:nil,Content:0|50,EDM:5,
	IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:
	0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ed3b6aceae2011f0a38c85956e01ac42-20251021
X-User: xiaopei01@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 603910544; Tue, 21 Oct 2025 09:54:49 +0800
From: Pei Xiao <xiaopei01@kylinos.cn>
To: syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
Cc: davem@davemloft.net,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	Pei Xiao <xiaopei01@kylinos.cn>
Subject: [PATCH] [patch] syz test
Date: Tue, 21 Oct 2025 09:54:45 +0800
Message-Id: <287c3a106ca4565311685d637af0884c5a6bdea2.1761011646.git.xiaopei01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <68f6a48f.050a0220.91a22.0452.GAE@google.com>
References: <68f6a48f.050a0220.91a22.0452.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test
---
 include/crypto/internal/poly1305.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/crypto/internal/poly1305.h b/include/crypto/internal/poly1305.h
index a72fff409ab8..f6de53965319 100644
--- a/include/crypto/internal/poly1305.h
+++ b/include/crypto/internal/poly1305.h
@@ -8,6 +8,7 @@
 
 #include <crypto/poly1305.h>
 #include <linux/types.h>
+#include <linux/string.h>
 
 /*
  * Poly1305 core functions.  These only accept whole blocks; the caller must
@@ -21,7 +22,8 @@ void poly1305_core_setkey(struct poly1305_core_key *key,
 			  const u8 raw_key[POLY1305_BLOCK_SIZE]);
 static inline void poly1305_core_init(struct poly1305_state *state)
 {
-	*state = (struct poly1305_state){};
+	//*state = (struct poly1305_state){};
+	memset(state, 0, sizeof(struct poly1305_state));
 }
 
 void poly1305_core_blocks(struct poly1305_state *state,
-- 
2.25.1

