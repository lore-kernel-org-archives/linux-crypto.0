Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCA03DEFE3
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 17:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777915978; cv=none; b=nIoPhg5iqdBiu44hQp2goJoWvjPBw/FCta8UodRT0Mudd6WjZmVnIedq1UJM5n2PyaxFCzYhr4JaZxPXpYZZyvD5l5UfAfLAm/MDjIGhDAWZuvd4pMF7mTWlQ+wtsU89oRX+kSPONUnCyPcgsANH2UdXscBCEjqoaOp1BONobj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777915978; c=relaxed/simple;
	bh=3Jok8q8QyN+e9TXy87Zy1aWVCgljgmuc8JMyRL0KtHI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p05hP58iKEa3yJgYeioBJ5VKDFAXgIs7CHhyJztA82bWzOug0TA5IcznmDBQoceizNt+IfqR+xNrqRHufjIPj9kcSeibIVien3FnxV683fBO9hdNLl8CuaRKXp0pQnfESgTaauI6TQvbn/z+clHcvxQ+ONHDvI4I/JemmSs0uO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=nlrWq3IH; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="nlrWq3IH"
Received: (wp-smtpd smtp.wp.pl 41022 invoked from network); 4 May 2026 19:32:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1777915972; bh=KUEXNJLvIJk8jijKoABN1Dz9wy2jS8qSqqvI/9Uuvd0=;
          h=From:To:Cc:Subject;
          b=nlrWq3IHiGngMmlPN0nWusqfBCvYnyHl3yS/7r1jvynevHDHjHLVwP7t+M4t26Ufc
           mbZneGbJIMLyzGKsU/+SmkFSYwmwfTjVeh4gZfLE2PYmoYp1LLAYe+E8Zq/O7B1XKh
           8ChJXGyXmm44x8onKtbYmSBJXYyc+c8MLA5qKlMCvSieuVAdvEdTU4ATYoDX0cKI7j
           QcZkISp0Fqadk2YJKrpA5pQ76MRb+R+zgOrTW4TLt24t8CQ3bEWEWUv+tdX57eCnNO
           OrSEYfy8e7O93FF9L+/ej273NMjM9el06UZnH/o/a2Go7JC881MCMZ2mRJGIuFrvAk
           JJIyTB6QnXYNg==
Received: from 83.24.138.167.ipv4.supernova.orange.pl (HELO abajkowski.lan) (olek2@wp.pl@[83.24.138.167])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <atenart@kernel.org>; 4 May 2026 19:32:52 +0200
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: atenart@kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH] crypto: safexcel - Remove repeated plus
Date: Mon,  4 May 2026 19:32:47 +0200
Message-ID: <20260504173250.751589-1-olek2@wp.pl>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: 73df963624777a41d6e116521ddcc879
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000008 [8Uv2]                               

Remove repeated "+".

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/crypto/inside-secure/safexcel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index fb4936e7afa2..812ebabd1309 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1475,7 +1475,7 @@ static int safexcel_probe_generic(void *pdev,
 	peid = version & 255;
 
 	/* Detect EIP206 processing pipe */
-	version = readl(EIP197_PE(priv) + + EIP197_PE_VERSION(0));
+	version = readl(EIP197_PE(priv) + EIP197_PE_VERSION(0));
 	if (EIP197_REG_LO16(version) != EIP206_VERSION_LE) {
 		dev_err(priv->dev, "EIP%d: EIP206 not detected\n", peid);
 		return -ENODEV;
-- 
2.53.0

