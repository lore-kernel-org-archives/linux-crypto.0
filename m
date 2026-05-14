Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606B42E173D;
	Thu, 14 May 2026 06:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778741756; cv=none; b=MkiocI5f2TtE7AGc5BUB54V9sRxiHakPETa8jSWYgMkzhYlnUc//0GZ88KgJ7uIna9PrlxYZgZK6dxf2gJS2V0GLCO+8dbq0iFoB5ChptX9w0TIAiQaAQSw9zh4JugfLF2d2j1qo2auSNkeglmF1cT6ewgNtgjr3e3ULsu7piWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778741756; c=relaxed/simple;
	bh=WRKGGG1IukHpGp2EPP6UzQrMrG/RZ6y7mA8nQ5JMWuc=;
	h=Message-Id:From:Date:Subject:To:Cc; b=lBcWeZwEktLeL98msrnJBMHfOhZZwx3LYOb85Af8e/BYo20IL2LkGDMhLVvq2Ifu4JMcE7IBN1u/pjz250Pwo+jMVImemPnKVR3qNxdrp0WSb0QYtK6onZLHMDBJDhdVl2IGe08pLbkcieqni6sdfjyjdUujTJ9445YEosrCYX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.95.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout1.hostsharing.net (Postfix) with ESMTPS id 7A234366;
	Thu, 14 May 2026 08:55:50 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 634D7601804E; Thu, 14 May 2026 08:55:50 +0200 (CEST)
Message-Id: <782bc59d5939aa69b58cad42f71946f1c0a6dccb.1778741457.git.lukas@wunner.de>
From: Lukas Wunner <lukas@wunner.de>
Date: Thu, 14 May 2026 08:55:58 +0200
Subject: [PATCH] X.509: Fix validation of ASN.1 certificate header
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, David Howells <dhowells@redhat.com>, Ignat Korchagin <ignat@linux.win>
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

x509_load_certificate_list() seeks to enforce that a certificate starts
with 0x30 0x82 (ASN.1 SEQUENCE tag followed by a length of more than 256
and less than 65535 bytes).

But it only enforces that *either* of those two byte values are present,
instead of checking for the *conjunction* of the two values.  Fix it.

Fixes: 631cc66eb9ea ("MODSIGN: Provide module signing public keys to the kernel")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260508033917.B5873C2BCB0@smtp.kernel.org/
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v3.7+
---
 crypto/asymmetric_keys/x509_loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/x509_loader.c b/crypto/asymmetric_keys/x509_loader.c
index a417413..0d516c7 100644
--- a/crypto/asymmetric_keys/x509_loader.c
+++ b/crypto/asymmetric_keys/x509_loader.c
@@ -20,7 +20,7 @@ int x509_load_certificate_list(const u8 cert_list[],
 		 */
 		if (end - p < 4)
 			goto dodgy_cert;
-		if (p[0] != 0x30 &&
+		if (p[0] != 0x30 ||
 		    p[1] != 0x82)
 			goto dodgy_cert;
 		plen = (p[2] << 8) | p[3];
-- 
2.51.0

