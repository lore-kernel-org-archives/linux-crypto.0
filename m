Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14F02ECE9B
	for <linux-crypto@vger.kernel.org>; Fri,  6 Feb 2026 19:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770406064; cv=none; b=JoXP8NGs8B4Yy9Bix/FAlrMuDTVfzVBNgtxkAeogzo4e756wGBqx752AdeazJnplV2WkwJaBXJc7W0o0yuBTA3xEkAV3SW/RlTD0ikTBqoyk5HpMUJ5I30+Vy0r8d/HlUSGX3RWWnqEGYYIwdR0vMJa8BkMBd6KeYgQx9fZ0L0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770406064; c=relaxed/simple;
	bh=gix5wOPSy4kd45KhmDIv2kgZeb5zleyp948d6Sbc4GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYJkMXUjWGzuV540Uc9VdfpQwQduAaG8TlY2tOyt9zzpfCEjdWQGbvQqjy57SMtu2930IycQ74BVXC5KGvOnrF4iC2xVV8DF2Iqy/fhaRSePqz67M6NhVgC4jtmW7wO+Rb9LH62nyy2fsoc9QaTsrgHID1q/PhJH1AgZZW8a6wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=dpUiM22R; arc=none smtp.client-ip=212.77.101.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="dpUiM22R"
Received: (wp-smtpd smtp.wp.pl 44129 invoked from network); 6 Feb 2026 20:27:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1770406056; bh=6gftHVR+vy3nM7U0t2O69oN1ej/ezopf8Hrbjo9I60w=;
          h=From:To:Cc:Subject;
          b=dpUiM22RLFPBbQAugmoBY09/ozjCxd36za8mP3jSPbA8DUE/5negt7hmbZvi5I3bK
           b75NKhr/uAsH7gei7BEsEf3MnKvLOAjjw9uODhnspzRomJ6wyQ0+3aAJVugAcHVVp4
           1+YyLcnL3s9VpzN2EqdCY2YDBDmjkqFBWLl223Syrgo91anxfMz8Vm8D/BZu2dAqgD
           3xvuu2TFrHJPHFDdNQK02dZ+p3rlroLV9KtNwS76XR+na0s9hpz9HLrzKhWoH/a1Hu
           QFEQgBXCPqEzW3ferqao6k+40MwE7iQLYOmxgsZL6uFXmtE1P1ootpgn7owbt0LCIj
           6Sf1yj2nDg2QQ==
Received: from 83.5.238.100.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.5.238.100])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <herbert@gondor.apana.org.au>; 6 Feb 2026 20:27:35 +0100
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH] crypto: tesmgr - allow authenc(hmac(sha224/sha384),cbc(aes)) in fips mode
Date: Fri,  6 Feb 2026 20:26:59 +0100
Message-ID: <20260206192732.478178-1-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <linux-kernel@vger.kernel.org>
References: <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: 51800c7626cbd9910c5677c24232fcb4
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [MEMU]                               

The remaining combinations of AES-CBC and SHA* have already been marked
as allowed. This commit does the same for SHA224 and SHA384.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 crypto/testmgr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index bf286a4f5351..b230d651f9f9 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4134,6 +4134,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "authenc(hmac(sha224),cbc(aes))",
 		.generic_driver = "authenc(hmac-sha224-lib,cbc(aes-generic))",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = __VECS(hmac_sha224_aes_cbc_tv_temp)
 		}
@@ -4196,6 +4197,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "authenc(hmac(sha384),cbc(aes))",
 		.generic_driver = "authenc(hmac-sha384-lib,cbc(aes-generic))",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = __VECS(hmac_sha384_aes_cbc_tv_temp)
 		}
-- 
2.47.3

