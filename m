Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2792DCF43
	for <linux-crypto@vger.kernel.org>; Thu,  1 Jan 2026 15:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767281137; cv=none; b=cjkGUSsgqTNjrEiZILljtg72LBmC8KG99RXCQDjffCvHWOvW1vFviCLNTjgrtVqWkTVax2N1ZLB/Ex36RsX/6OM+dL2U9qDBC8wx364C8oSJdg4gojwqH9TXAkAJ/AKHUkDE2EItrUvkvS2rW+FLRhFmOiTvM5VgvFqOQUs7ScY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767281137; c=relaxed/simple;
	bh=LMlq2a9gTuEw8Co5G0N97vzBPXZyqODH/bjDHkikJnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nNu6NXMGBMp0YhWr3j761yDmVNFTa7lUZt3wgGiHEBKBKLKFMNqfbxk0wCMZQ48jMVUcGi/pEgcllwQBNBNLWBvkGGTPGlH+FKceti+vHYsQxO85vaScSvZ1n5Wupz9Y6EiKc7Bu3bGUuKDtxVlzJ0tQeLpk5MUQS4A5hXQ3DsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=LvLFAdZp; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="LvLFAdZp"
Received: (wp-smtpd smtp.wp.pl 14939 invoked from network); 1 Jan 2026 16:25:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1767281125; bh=7cu7M1If+mjSSs4ioK+w09azy9ovawcK5+/YpibqgM8=;
          h=From:To:Cc:Subject;
          b=LvLFAdZpWUUMzDA1zgdW/FuMCUj5cWqFvhVhdkXXnRl/Br308jaaXsJYTQ7B5SkFV
           47tdbVTJ6JeVs0M/OadAyrbgRssQAlIqs9oOvQNDPCmVlBQdFhGxFD2inRall3ljLT
           8epU2JFardX/h21XNYysMIB2Rrp/mJueNWtw+ekaiZDtd5hC/sYIMglegFIbYpaMMK
           fGydhGRq04BAQc+GvDR5Oa7p7IHkPITJKXr7vsYevtLkctdzWEWXjMBWoHF0irUu4f
           9zFmf1+WLMbDDye/hs7abx7uG75iwzXyAccHUvmdgdnyUaldW54E+4+riQgnf4iuHS
           Fb5g7gHvWLzPg==
Received: from 83.5.157.18.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.5.157.18])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <herbert@gondor.apana.org.au>; 1 Jan 2026 16:25:25 +0100
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH] crypto: testmgr - allow authenc(sha224,rfc3686) variant in fips mode
Date: Thu,  1 Jan 2026 16:25:18 +0100
Message-ID: <20260101152522.1147262-1-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: 52d700e05a9885415d344fe1ce7cddfa
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000007 [YbRR]                               

The remaining combinations of AES-CTR-RFC3686 and SHA* have already been
marked as allowed in 8888690ef5f7. This commit does the same for SHA224.

rfc3686(ctr(aes)) is already marked fips compliant,
so these should be fine.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 crypto/testmgr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a302be53896d..5bae4871690f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4137,6 +4137,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.aead = __VECS(hmac_sha224_des3_ede_cbc_tv_temp)
 		}
+	}, {
+		.alg = "authenc(hmac(sha224),rfc3686(ctr(aes)))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
 	}, {
 		.alg = "authenc(hmac(sha256),cbc(aes))",
 		.generic_driver = "authenc(hmac-sha256-lib,cbc(aes-generic))",
-- 
2.47.3

