Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE4B1E7C34;
	Tue, 21 Oct 2025 03:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761016152; cv=none; b=esUBjmaGK+QYEvRn3mLYgpDxn679EPnHCFiGo8atsT2aS3gW+OaNhqU4NVmJ9V3wCQTtIeUlATB0exoBZ4opm3He+7eU8jLdAv2/elZ4nuAZen7f8IfnGufztV0Z/MV2IQFIAmZMRaP/FtwHkjQ3vxE26sc+TgyRtMqPDDMybrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761016152; c=relaxed/simple;
	bh=djVPFvfWqo4rWCc4DVTpQfT8xMj2u6w414b8uLhufag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A7ESjltryaEijHS9Xix117s1lmMa2uNblQt5Hr/ibYzt2pr4WMQsyYD1dFleeBvpcuG9hWx/KgiG/BDzt2yDbh+ShJymi9Pa7cUSPMj0gBZc4QJeOJHA+8RCoTQJmSZqHBbQ3bTAc2cbPn+hjrQjmptnEECZgEIOEN/hD/G/eDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 49372e80ae2b11f0a38c85956e01ac42-20251021
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:788fd3db-c14d-4fe7-995c-c2913d0f0e61,IP:0,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:25
X-CID-META: VersionHash:a9d874c,CLOUDID:f16170899d71a0dfe833349abb57db1b,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850,TC:nil,Content:0|50,EDM:5,
	IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:
	0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 49372e80ae2b11f0a38c85956e01ac42-20251021
X-User: xiaopei01@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 348631382; Tue, 21 Oct 2025 11:08:58 +0800
From: Pei Xiao <xiaopei01@kylinos.cn>
To: syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
Cc: davem@davemloft.net,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	xiaopei01@kylinos.cn
Subject: [PATCH] [patch] syz test
Date: Tue, 21 Oct 2025 11:08:54 +0800
Message-Id: <6556ef55c42ea17d82561b8182d9453b19d66a62.1761016077.git.xiaopei01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <68f6f516.050a0220.346f24.0002.GAE@google.com>
References: <68f6f516.050a0220.346f24.0002.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test
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

