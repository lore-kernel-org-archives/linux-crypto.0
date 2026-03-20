Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C450236BCF5
	for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 21:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774041587; cv=none; b=GvbbO4ugY+QukCDNHJ9L5hltPEUVUJ+0dDHY5wyGDxV8V6y8PhISHuX9F2qGhY591aTYBt2urYvQavYDh1iUzEYZ5/3Rh0tUw4lReLTyboqBExq3NLES6WyuLgkEByk8+T5fm2px9t4iAEA+3KOPLmMwwvAA1bpopD8Mv7O5Pho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774041587; c=relaxed/simple;
	bh=XYBThBoauy/NtdHK1zVO+ITX9izUqgyDs5reaZISFBw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pgxXScJPigfi1XmTBiRP2W0nopWNf3kTzL5Ps3QrmDoPQkaoGL2BurngN+awfH1ELWg91eEqE69M4Z/xnhPQJKmhc+lEacWA9apUN8A5dTEIMwGRNZ1v540wEzLWorU48Di8NeBn7UCjOpxDhYqzYDJbsqeAOROJIDh0fsH1Iv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=V3vRIpT5; arc=none smtp.client-ip=212.77.101.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="V3vRIpT5"
Received: (wp-smtpd smtp.wp.pl 25362 invoked from network); 20 Mar 2026 22:19:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1774041573; bh=0yIX36ihlDafxSjdEwYcOydHMVBruTCrpNKm6mGyu4k=;
          h=From:To:Cc:Subject;
          b=V3vRIpT5xBns9RFBakofIqER75S4/BPeGpmernBEO5f7znaaaIl08VAfzwA8Hj6Ob
           C2QxHrjciKswtC0L7EhzztjpgEqE79AhBXpo88R4USSgGa8EcOnd9rwswlMh8bLNJY
           0lc+ALOSQh9xDRymM/tJt3e4loiqtyECjvPTl22T/ioDdylrPO88noP3xy1JL6eIkK
           1ncqq89IDSrRqhJmwT9YmHoMk4LrhE2kevwgSEtQ6D2lc0hYvgcKvJzCY9lAMbqD8T
           UwvLmTzOsTE2JFDdzQxopXmX4h0G85hIlq14ATcJ0FQlvtV5FhXqWrLQ7xbusQBr8g
           VFQ31gme35Rmw==
Received: from 83.5.169.164.ipv4.supernova.orange.pl (HELO abajkowski.lan) (olek2@wp.pl@[83.5.169.164])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <naseefkm@gmail.com>; 20 Mar 2026 22:19:33 +0100
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: naseefkm@gmail.com,
	cjd@cjdns.fr,
	ansuelsmth@gmail.com,
	atenart@kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH] crypto: inside-secure/eip93 - make it selectable for ECONET
Date: Fri, 20 Mar 2026 22:19:23 +0100
Message-ID: <20260320211931.829476-1-olek2@wp.pl>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: 9eb3f48a020e4f2c866c8e3882c8db2d
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [AZpR]                               

Econet SoCs feature an integrated EIP93 in revision 3.0p1. It is identical
to the one used by the Airoha AN7581 and the MediaTek MT7621. Ahmed reports
that the EN7528 passes testmgr's self-tests. This driver should also work
on other little endian Econet SoCs.

CC: Ahmed Naseef <naseefkm@gmail.com>
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/crypto/inside-secure/eip93/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/eip93/Kconfig b/drivers/crypto/inside-secure/eip93/Kconfig
index 8353d3d7ec9b..29523f6927dd 100644
--- a/drivers/crypto/inside-secure/eip93/Kconfig
+++ b/drivers/crypto/inside-secure/eip93/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config CRYPTO_DEV_EIP93
 	tristate "Support for EIP93 crypto HW accelerators"
-	depends on SOC_MT7621 || ARCH_AIROHA ||COMPILE_TEST
+	depends on SOC_MT7621 || ARCH_AIROHA || ECONET || COMPILE_TEST
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_DES
 	select CRYPTO_SKCIPHER
-- 
2.51.0

