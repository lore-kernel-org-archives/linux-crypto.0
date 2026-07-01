Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20B349250D;
	Wed,  1 Jul 2026 16:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.230.196.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782921738; cv=none; b=Ut5weX5/qL2H/LmoOuCkF08nQQqIA2ezB/WmbDmLRjjHmSo+AopsPNRES6zgbZ9xUrZfeb6SHJj5/vPFyDc5saUzgblfHVMG08Rcvwp49l8EN4xUZrXs1j15FT8E7P371vWxmUf8oPP/2WJWmjgR8qTMmkAXCHeP0GHm+dL8GRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782921738; c=relaxed/simple;
	bh=foGMAhe24/ngZ9jCKyUi2BVGyfeZCUk0zatmn0Z7nTk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oNpMaIe/8Z14Speq86XdjnFlc2qpPlKWVlaMsftql3iLUYNYKLT1u1AjrZ1//9/rhH+8XoJl0GriQcMrENkMhvBqK8RPUWUxzSwpfFjUBiFjIcSAy8CeU4GeWhjJwfO3WD4JfUmz0KSCJdd/2fhKL009C09FdQA0Q2rp+xUN+CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b=yGhpt8Im; arc=none smtp.client-ip=37.230.196.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b="yGhpt8Im"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1782921728;
	bh=foGMAhe24/ngZ9jCKyUi2BVGyfeZCUk0zatmn0Z7nTk=;
	h=From:To:Cc:Subject:Date:From;
	b=yGhpt8ImZapzx2xrxA6Mr/KF/qSE4qwB7DV0cRaihNkora0NaHtPpcO0jAUsoEhpY
	 FtuOIoXtouK1e6ZPQlCHsHU0TaqGKgIXr9LJJVT6Rn8p40w6+r1RF3flT2KWZHjiLS
	 kbzptsj8YU+wJX0Qg9taj/WZ0oWYO2JEKJHCJ91jJXDY8zj866WdB8w2hVtZb7Ut3n
	 /4nvYPlKvtjUV9D09/5aO9deCF2ROGTO1RpjQQZrWOndY77G87OX+ogioawvx2qnpk
	 1snjb/b+Q3+7qMiCL7yxQuFccmUH4tDrOYuaUrvHFNc6JUzJa97Uz7pTvdJeGVMUdZ
	 o5v8iujdXUlwg==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id 5B597252F1;
	Wed,  1 Jul 2026 19:02:08 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Wed,  1 Jul 2026 19:02:02 +0300 (MSK)
Received: from rbta-msk-lt-169874.astralinux.ru (unknown [10.198.21.28])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4gr4XB08DKzL5Z;
	Wed, 01 Jul 2026 19:02:01 +0300 (MSK)
From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>
Subject: [PATCH 5.10/5.15] crypto: af_alg - Set merge to zero early in af_alg_sendmsg
Date: Wed,  1 Jul 2026 19:01:21 +0300
Message-Id: <20260701160121.100720-1-mdmitrichenko@astralinux.ru>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: mdmitrichenko@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 111 0.3.111 1434338e80da3ad6056aa2b487308911a6b137ca, {date_rfc_vio_soft_silent}, {Tracking_internal2}, {Tracking_from_domain_doesnt_match_to}, astralinux.ru:7.1.1;127.0.0.199:7.1.2;new-mail.astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 204190 [Jul 01 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.22
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/07/01 13:53:00 #28347790
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 9574b2330dbd2b5459b74d3b5e9619d39299fc6f upstream.

If an error causes af_alg_sendmsg to abort, ctx->merge may contain
a garbage value from the previous loop.  This may then trigger a
crash on the next entry into af_alg_sendmsg when it attempts to do
a merge that can't be done.

Fix this by setting ctx->merge to zero near the start of the loop.

Fixes: 8ff590903d5 ("crypto: algif_skcipher - User-space interface for skcipher operations")
Reported-by: Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
Backport fix for CVE-2025-39931
 crypto/af_alg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index b66a1681692d6..bbd47d04f89dc 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -892,6 +892,8 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			continue;
 		}
 
+		ctx->merge = 0;
+
 		if (!af_alg_writable(sk)) {
 			err = af_alg_wait_for_wmem(sk, msg->msg_flags);
 			if (err)
-- 
2.47.3
