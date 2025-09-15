Received: from smtpcmd0642.aruba.it (smtpcmd0642.aruba.it [62.149.156.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4E32877DB
	for <linux-crypto@vger.kernel.org>; Mon, 15 Sep 2025 08:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757925833; cv=none; b=HIGJcABLHnhR4NMQh20f+p5s2jERHViOBGN74/DPKFFectrF1FjYXp3nI4CdfOAN7GmtZ99RuFtCPRQSBbupVbV3dLsrlWxqOKkqm6AYB3d/kXrGNpHKV3cEgJT/AO2vFYkVBdQXP/QbRbqFR9qA/WpYcvQDpOSDA2hQxucP7jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757925833; c=relaxed/simple;
	bh=HSFt/7G+mD/cFYl1kLp30arQRrmTOJeT+uRN0jlMojA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BXV6O9D7RIDD7My+7g8Syv51jJqAFYqq2GZJbMKibh5PIj/gLp7McYUqX3ucI4a93ILiugXvDM+ezVI6Ank+TqKOprGMhkGRspd5XUmi1KfCLZxqq/MwhLNK2QefAzb/HwoRghWkJYTrYbpyuMDSH1n1EkfeH7xA0OZypTLFT3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com; spf=pass smtp.mailfrom=enneenne.com; dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b=ARufPhXM; arc=none smtp.client-ip=62.149.156.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enneenne.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enneenne.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="ARufPhXM"
Received: from polimar.homenet.telecomitalia.it ([79.0.204.227])
	by Aruba SMTP with ESMTPSA
	id y4lLumNEnL0Iyy4lNuiWiA; Mon, 15 Sep 2025 10:40:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1757925641; bh=HSFt/7G+mD/cFYl1kLp30arQRrmTOJeT+uRN0jlMojA=;
	h=From:To:Subject:Date:MIME-Version;
	b=ARufPhXMqHVkWw7pM4jNmNIZ+Vfj21dhdMZNlenwYYJKQkSFx+JFA89AsvKcPLYEK
	 g0qDD2t0Le0JipC6HFy8KE2xaP6UOQEMd98K4hxnZHtBwOpqJo6d6geli+TZYPDTR5
	 s8OnXe2GT1nbQMIsiwxj5Pg7GJPm3fDgPIZqc7aXSejR5A8Th8OqPIBm2Rw4Zhm2I4
	 yd8Ro2/zG2voyXlTWIO9VKDUjeLo0O0xlgkvbLHPl2M+Ev7d5FIU2siw/D+z7JMa/U
	 gnn675sCpcSC7Vmy3fEfy8nNmlebvjlgpZ6X3XrJI2bk68dU+pOFGy+llr5yJn8XEA
	 UyMK6eai2LaaA==
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rodolfo Giometti <giometti@enneenne.com>
Subject: [V1 1/4] crypto ecdh.h: set key memory region as const
Date: Mon, 15 Sep 2025 10:40:36 +0200
Message-Id: <20250915084039.2848952-2-giometti@enneenne.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250915084039.2848952-1-giometti@enneenne.com>
References: <20250915084039.2848952-1-giometti@enneenne.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfOrdSnTy6aGUheSaeHuq2fLET0sbwdBPstiNi97WtbflMzFWGRuBdT77JZcQEoGauyrUj7eUDHNZZXAk1ahNMXcuhGL137S2IFace7Y7G0spwR5SK4xv
 5JUPc2TXHJ1gbDomOn1O2W7C8aUmMWM9n5WI9Nn4hTafF7goC+sKX/ou4viH6o2MI36FnLyBE00d7aJqZ0xmqSMgw3KmLmBYgxmBK+FIGfuXUmFhMlNJopn4
 IxXP5eZGOkZmYlkE4E4QwYnvuWlo/HDZ6WyDoTvyUTOjRIRoW6kahDW4jz5J0od0GNKKT+vRQlth4OLcFnToBWhhmnwnlivQrvxgMIYyHMU=

As in include/crypto/dh.h the memory region of a private key must be
set as constant.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
---
 include/crypto/ecdh.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
index 9784ecdd2fb4..2e0fb35b929b 100644
--- a/include/crypto/ecdh.h
+++ b/include/crypto/ecdh.h
@@ -35,7 +35,7 @@
  * @key_size:	Size of the private ECDH key
  */
 struct ecdh {
-	char *key;
+	const char *key;
 	unsigned short key_size;
 };
 
-- 
2.34.1

