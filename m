Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CD32750FE
	for <linux-crypto@vger.kernel.org>; Wed, 26 Nov 2025 20:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764188729; cv=none; b=FvtCpbjapA/7xvHXVDwzKj1MwZQd4JHdQSS9ohfajx5a2p98rEH3Hc83al+zwRRP9rWOBF8i+nRDR8IsgoBME/XePRTBRkfG/d2vUuN9vgFN+XG0t277wkhS43uKrbLlzKHqAdBViqLbZDAZkhZ6etkvoqTLY5bR+dHZ9y+LPbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764188729; c=relaxed/simple;
	bh=mtWEXDWucNaPysXWk1tblDYeoKFX8jKtx2sa0dBEXTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGx5eXvLECmXB/HCOV2jMNmbEViG+M8Dvj9gC7i6Uwc0oND1NxbXVSbhLBT37cn8DehrXZQs56cjKLNu0lkFx05GcyWdnDNB9qSPn/M9x6GQdgIDo8aPDLK4MY89srgcgrz8+HR6BL2LriVeLkfhqxpVWakWmbSr8fwzKVsyWx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=ZZmGPRwg; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ZZmGPRwg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1764188726;
	bh=mtWEXDWucNaPysXWk1tblDYeoKFX8jKtx2sa0dBEXTM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:From;
	b=ZZmGPRwgNB8eEbBa/vq/IzquvLMYVIfk/GkazKxCf37ZaBIA2CKcz+cd/CeRmJ4IT
	 dyU48CLeuqRWJquf/IZENHWsy3xT5sxKvbiVjhX67NQbAszA7m05U3sk9dAIYPwdF+
	 Aaua1BmGG3wriZd2w8sBCAMKRz+l9QjzLPPz2IA4=
Received: from lingrow.int.hansenpartnership.com (unknown [153.66.160.227])
	by lamorak.hansenpartnership.com (Postfix) with ESMTP id 76B791C01BC;
	Wed, 26 Nov 2025 15:25:26 -0500 (EST)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: [PATCH v2 2/5] crypto: pkcs7: add flag for validated trust on a signed info block
Date: Wed, 26 Nov 2025 15:24:02 -0500
Message-ID: <20251126202405.23596-3-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126202405.23596-1-James.Bottomley@HansenPartnership.com>
References: <20251126202405.23596-1-James.Bottomley@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow consumers of struct pkcs7_message to tell if any of the sinfo
fields has passed a trust validation.  Note that this does not happen
in parsing, pkcs7_validate_trust() must be explicitly called or called
via validate_pkcs7_trust().

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 crypto/asymmetric_keys/pkcs7_parser.h | 1 +
 crypto/asymmetric_keys/pkcs7_trust.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.h b/crypto/asymmetric_keys/pkcs7_parser.h
index e17f7ce4fb43..344340cfa6c1 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.h
+++ b/crypto/asymmetric_keys/pkcs7_parser.h
@@ -20,6 +20,7 @@ struct pkcs7_signed_info {
 	unsigned	index;
 	bool		unsupported_crypto;	/* T if not usable due to missing crypto */
 	bool		blacklisted;
+	bool		verified; /* T if this signer has validated trust */
 
 	/* Message digest - the digest of the Content Data (or NULL) */
 	const void	*msgdigest;
diff --git a/crypto/asymmetric_keys/pkcs7_trust.c b/crypto/asymmetric_keys/pkcs7_trust.c
index 9a87c34ed173..78ebfb6373b6 100644
--- a/crypto/asymmetric_keys/pkcs7_trust.c
+++ b/crypto/asymmetric_keys/pkcs7_trust.c
@@ -127,6 +127,7 @@ static int pkcs7_validate_trust_one(struct pkcs7_message *pkcs7,
 		for (p = sinfo->signer; p != x509; p = p->signer)
 			p->verified = true;
 	}
+	sinfo->verified = true;
 	kleave(" = 0");
 	return 0;
 }
-- 
2.51.0

