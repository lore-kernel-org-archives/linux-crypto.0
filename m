Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEBB2475CB
	for <linux-crypto@vger.kernel.org>; Sat, 16 May 2026 12:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778934432; cv=none; b=ViynFKCLqq6imXXgocD7ofEBGoZW0xfr8TY1sc0Rp59yJkeVKl8jpx6ZSp0qdTbl4fBy1YKrqwU4JO+YY5QxfvpKRbf/c2GcsJKr40ZJTN7bVF/O6gpa2P3Pjro0oswO1WuYlEFFhY+adTX/teCxmM0SkP7FBPO8BHzvBF8k2sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778934432; c=relaxed/simple;
	bh=EROlNPW4TJ5Ro4uAarPIIfVkTHEvgmL5GiNXmGR/w54=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BbiiO1IgwfNqRvt+ZjjdDJGx7MQDDX5H1efIZJVSCLjGH41S4OiGAbGKoW+KeHZp0KlMUdZmG8SL+Htn0T3JuTzYXIfSL71+90+txJ2FRbdxDH5IKYPpSJymu/ZqakLVg4TLfVn+4q4R9qZK9nF9L6nOm15CRPrdtPNKXFKEh+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=ir3nLYQX; arc=none smtp.client-ip=212.77.101.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="ir3nLYQX"
Received: (wp-smtpd smtp.wp.pl 13987 invoked from network); 16 May 2026 14:27:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1778934422; bh=XCP5Ql/DRlc6uFYGP2l0EZOc8xfr9JXFnO7G5uyhj9M=;
          h=From:To:Cc:Subject;
          b=ir3nLYQXGcje48FR1vJ+aFWk/o46KcSrAR+d+NXFCLQPHpcmJJTSQWLGzeDPdI7+z
           wN5u/PXaZFmaMKGkhwcxSI1+0Z5BrfoZ0gTHCSSfHvRSdCbnmM5rtBRvecNlDV9cQY
           3YD6REBxma5i/+QTrQKnxKdYOc3SheonQP6NgL6ztbEftckMS177a2Oi6CEpB8L2DP
           YI0jjOqIRj8kEW8aKT0Nco3YaEw5z3kUaaCD0IMeoSj+PcsWZqhHPtfwpKsBZmOQBf
           dPjkwZZnw62ACzDZ3OJBL+m5Q7qWZ6t6HMh8pCYUbw2ogk9J5Y35A6rMxKnr3LDRMs
           MPz8lBaTlcKQA==
Received: from 83.24.127.64.ipv4.supernova.orange.pl (HELO abajkowski.lan) (olek2@wp.pl@[83.24.127.64])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <ansuelsmth@gmail.com>; 16 May 2026 14:27:01 +0200
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: ansuelsmth@gmail.com,
	benjamin.larsson@genexis.eu,
	atenart@kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vschagen@icloud.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH] crypto: eip93: - fix reset ring register definition
Date: Sat, 16 May 2026 14:26:51 +0200
Message-ID: <20260516122657.2585876-1-olek2@wp.pl>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: 7a5125db3154ebb3f28e724471cde666
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000008 [gRsX]                               

This patch fixes a descriptor ring reset. This causes a hang in the
driver's unload/load sequence.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Suggested-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/crypto/inside-secure/eip93/eip93-regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-regs.h b/drivers/crypto/inside-secure/eip93/eip93-regs.h
index 96285ca6fbbe..96d28c6651bd 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-regs.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-regs.h
@@ -103,7 +103,7 @@
 #define   EIP93_PE_TARGET_COMMAND_NO_RDR_MODE	FIELD_PREP(EIP93_PE_CONFIG_PE_MODE, 0x2)
 #define   EIP93_PE_TARGET_COMMAND_WITH_RDR_MODE	FIELD_PREP(EIP93_PE_CONFIG_PE_MODE, 0x1)
 #define   EIP93_PE_DIRECT_HOST_MODE		FIELD_PREP(EIP93_PE_CONFIG_PE_MODE, 0x0)
-#define   EIP93_PE_CONFIG_RST_RING		BIT(2)
+#define   EIP93_PE_CONFIG_RST_RING		BIT(1)
 #define   EIP93_PE_CONFIG_RST_PE		BIT(0)
 #define EIP93_REG_PE_STATUS			0x104
 #define EIP93_REG_PE_BUF_THRESH			0x10c
-- 
2.53.0

