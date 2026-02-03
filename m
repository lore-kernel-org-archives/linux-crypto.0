Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A950D31B812
	for <linux-crypto@vger.kernel.org>; Tue,  3 Feb 2026 18:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770143179; cv=none; b=OyKdIFLhvPS9QM0uC88KAh55P3v5AHowL56Qm5XaFKq5Nd+uf9J7NYDwD26k1PT+P6hZYvvIeS6GwufgQ1pxpOIehdPS8gaaona4iKZlwd721jjxC86z+NVu4ADEljE808BxNCj8OyUV/ma23DDOOhyKbBaoG1fqlxeddgxr0oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770143179; c=relaxed/simple;
	bh=AGE1SFm5U8+YF1Sh+DGUnvFvTt3UFvlsCkqGRg5DoA0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ztwl4Dq08xtsSi8YIx6ZtCEWMYnfr5sag4vUL3usST8I51OWEp8Vm/MY+mvRvX8p1gTPyMeLToe7JzZVOgmg6xZ0xaIo8i9GANKG7ZI2TKqh/aprdqiqtC6zQ80P2hjDe5Jr5ruxHI864h/tbDeNDW22Oh+g06yS+5xEWK+ZV0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=OzUOrynk; arc=none smtp.client-ip=212.77.101.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="OzUOrynk"
Received: (wp-smtpd smtp.wp.pl 19721 invoked from network); 3 Feb 2026 19:26:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1770143174; bh=w3qWHsFfnAhkqgzJZ7TMtG9fRheK1p86ugckyDpISAk=;
          h=From:To:Cc:Subject;
          b=OzUOrynkVR1LFX6h6yioJX9s7QZZIQDOTjGP8ej1C8bBeDz3xOYj1a4dJW2rt5hfi
           /2JJrzf0NVjFAHFvTBopPs6HZ5LptbI6NWYbvxaliuS77ZlzGrhxbw2DJMbPE4jFa3
           vIM+0Vr+2/DKg5W4Ux5qJejyEYLNl9RE5CN/QNDIoRtx/JIxDqAqd+C8gjUmB14UsV
           3EoXWOi+DVSrtsvhmF032MK/SLNS199MdBONPCsCH7PEqHfj51sbVYcJpOhE7isrCc
           LyG4gH7iP3emTGrXQejnfNwtHLtzn57pJqMMFE2oekapJaDK78+HyCUF+elovpmreJ
           JQBp8oV2V3hig==
Received: from 83.5.238.100.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.5.238.100])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <atenart@kernel.org>; 3 Feb 2026 19:26:14 +0100
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: atenart@kernel.org,
	herbert@gondor.apana.org.a,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH v2 1/2] crypto: safexcel - Group authenc ciphersuites
Date: Tue,  3 Feb 2026 19:21:51 +0100
Message-ID: <20260203182610.8672-1-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: e02363632999eb92e4b39ee5a18aed50
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000008 [cRvU]                               

Move authenc(sha1,des) and authenc(sha1,3des) ciphersuites to appropriate
groups. No functional changes intended.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Acked-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/crypto/inside-secure/safexcel.c | 4 ++--
 drivers/crypto/inside-secure/safexcel.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index c3b2b22934b7..9c00573abd8c 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1209,7 +1209,6 @@ static struct safexcel_alg_template *safexcel_algs[] = {
 	&safexcel_alg_authenc_hmac_sha256_cbc_aes,
 	&safexcel_alg_authenc_hmac_sha384_cbc_aes,
 	&safexcel_alg_authenc_hmac_sha512_cbc_aes,
-	&safexcel_alg_authenc_hmac_sha1_cbc_des3_ede,
 	&safexcel_alg_authenc_hmac_sha1_ctr_aes,
 	&safexcel_alg_authenc_hmac_sha224_ctr_aes,
 	&safexcel_alg_authenc_hmac_sha256_ctr_aes,
@@ -1241,11 +1240,12 @@ static struct safexcel_alg_template *safexcel_algs[] = {
 	&safexcel_alg_hmac_sha3_256,
 	&safexcel_alg_hmac_sha3_384,
 	&safexcel_alg_hmac_sha3_512,
-	&safexcel_alg_authenc_hmac_sha1_cbc_des,
+	&safexcel_alg_authenc_hmac_sha1_cbc_des3_ede,
 	&safexcel_alg_authenc_hmac_sha256_cbc_des3_ede,
 	&safexcel_alg_authenc_hmac_sha224_cbc_des3_ede,
 	&safexcel_alg_authenc_hmac_sha512_cbc_des3_ede,
 	&safexcel_alg_authenc_hmac_sha384_cbc_des3_ede,
+	&safexcel_alg_authenc_hmac_sha1_cbc_des,
 	&safexcel_alg_authenc_hmac_sha256_cbc_des,
 	&safexcel_alg_authenc_hmac_sha224_cbc_des,
 	&safexcel_alg_authenc_hmac_sha512_cbc_des,
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 0f27367a85fa..ca012e2845f7 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -950,7 +950,6 @@ extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_aes;
-extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_ctr_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_ctr_aes;
@@ -982,11 +981,12 @@ extern struct safexcel_alg_template safexcel_alg_hmac_sha3_224;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_256;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_384;
 extern struct safexcel_alg_template safexcel_alg_hmac_sha3_512;
-extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des3_ede;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des3_ede;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_des;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_des;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_des;
-- 
2.47.3

