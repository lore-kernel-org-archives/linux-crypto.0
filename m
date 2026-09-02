Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC0C394780
	for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2026 21:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788382919; cv=none; b=NBk1cZqTwmw0kv3ujPyjcqd7a0ddRMu7DnUkmGPSs7O/baemE4UzHK5ptjJZ2kdo4mknDdQ/TTrIdxvnyK6EALg+bg6bs2Azk0t56Q6DzlDxB4fcVcDI8nPMSLnFjg2A7iEg0pA7a3bEtIcGOnE6u2NyUWUk24flaDlaEiR69us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788382919; c=relaxed/simple;
	bh=BpqPKUhSE1WKOFXP2SHgk6cDXOVHrVbPgvH4lLphOP4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UjAInYjrKUM3rkEIZYQsEAfTsfZlRllXcfUArc4hpO2XnKhfVrLEROMXoRsyaeglk9iW17i8xLd58jxB7bjneQbsJJGiKsDfTSVpCo/DwRsdF7tjYD+6aVljnN5u0ANYa0XzqtjTFpK6Y1yvN1gtGM0U7TTJ1XOmcC3NUqhqDxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=OsHkNsg5; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="OsHkNsg5"
Received: (wp-smtpd smtp.wp.pl 5974 invoked from network); 2 Sep 2026 22:55:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1788382511; bh=PCKb4U0bctkL3frsFsYpcJYe2me73Tjlalj8huLwC7w=;
          h=From:To:Cc:Subject;
          b=OsHkNsg5flz3vKBBUzDMTJz5OIb+fYV08QBubEfHwjHj9tcs3k8jf9nv1fU7BUN7l
           LOy8vSib33i0tg6XUsv2O21ol9NOkJX2p6IEyMefJm9QWEV6+5GwuHcttmL9DNE2M/
           /Jrp+PFF0uzWf2quGJudtnKpGQ/2MGbYRovdAuAn0XpQ+6RvICCEdWvzraqc8Pqnbq
           eyEp7aTzjSSdKO+EcKP23LihlKeCcfvG5znOYoP95L2EQMaO40Jv99eQiLy0rYGF2y
           W+Vl8lHc8XdUaZe6c7TBp6/vrX7CRab161JqqacmYWRu2XV0gh1tJAJnA5pn24L84M
           gPIbpJf2z337w==
Received: from abajkowski.enigma.com.pl (83.5.244.153.ipv4.supernova.orange.pl [83.5.244.153])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <ansuelsmth@gmail.com>; 2 Sep 2026 22:55:11 +0200
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: ansuelsmth@gmail.com,
	atenart@kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vschagen@icloud.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH] crypto: eip93 - fix ssl mac bit field definition
Date: Wed,  2 Sep 2026 22:54:28 +0200
Message-ID: <20260902205509.84019-1-olek2@wp.pl>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: d22fa32db910380bd08dcc35a2712f73
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000008 [wetz]                               

Checked the register definitions with the documentation[1]. Turns out
that the EIP93_SA_CMD_SSL_MAC bit field has a bad value. It's used in
SSL offload mode. This driver doesn't support SSL offload yet, so this
causes no problems.

1. MT7621 ProgrammingGuide DMA
Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/crypto/inside-secure/eip93/eip93-regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-regs.h b/drivers/crypto/inside-secure/eip93/eip93-regs.h
index 96d28c6651bd..1d726bcdd77f 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-regs.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-regs.h
@@ -281,7 +281,7 @@
 #define   EIP93_SA_CMD_HASH_CRYPT_OFFSET	GENMASK(23, 16)
 #define   EIP93_SA_CMD_BYTE_OFFSET		BIT(13) /* 0: CRYPT_OFFSET in 32bit word 1: CRYPT_OFFSET in 8bit bytes */
 #define   EIP93_SA_CMD_HMAC			BIT(12)
-#define   EIP93_SA_CMD_SSL_MAC			BIT(12)
+#define   EIP93_SA_CMD_SSL_MAC			BIT(11)
 /* This mask can be either used for ARC4 or AES */
 #define   EIP93_SA_CMD_CHIPER_MODE		GENMASK(9, 8)
 /* AES or DES operations */
-- 
2.53.0

