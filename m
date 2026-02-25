Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552C1310620
	for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2026 21:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772054449; cv=none; b=FJkOrU45lI8CH9frgUJ4wtxZbBXgkwqDiH8pzKMEaQAixUjNk5g3Rf3SArfjLtoAyN/Ss9gNcHqYvoHRuDNc1sEypxW4L8yoCIdqjnikrzfAfcNqsblTnIwEV90GA9+TtD101yEoKO4fJD/AFNjKplXs5QInX7ySqfL0Z3fJIGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772054449; c=relaxed/simple;
	bh=XXzq6DeQXGa9+ohMsE0/gCIoQUDeXXt9J0/hhrubkCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/k1HiLxgon6F/PP5GRIS39DWhWuaoCLdsI+SO/Z1GCfqjlZB4JpFz7+WWOWyVXYmyTsGItkYalfg4nCKWuNVebReo62/oLJRURf0Y0gQvPljQBhHzixA72eyC4sm5QXDOJCAdWR1bODhcoDSVkj3iwTuVVXjXJ3f93yOGtKAyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=FXPyhc1v; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="FXPyhc1v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1772054446;
	bh=XXzq6DeQXGa9+ohMsE0/gCIoQUDeXXt9J0/hhrubkCw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:From;
	b=FXPyhc1vC3WaqSB+q0VJk90PigmPQpErSRVzaG+v7T9NFSqONUhynfIUyIqDHqcTC
	 e7UFSarkeHz3XJjc3xlAyKrfGvG+YSq8VJfFvK1nA13RDDU2NV5xpwHkO05WEX2TVL
	 QMSNc4l9hssGo/LrBquvM9qckDN6CdOCJPGJBJ+k=
Received: from lingrow.int.hansenpartnership.com (unknown [153.66.160.227])
	by lamorak.hansenpartnership.com (Postfix) with ESMTP id 246331C02E8;
	Wed, 25 Feb 2026 16:20:46 -0500 (EST)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: [PATCH v3 2/5] crypto: pkcs7: add flag for validated trust on a signed info block
Date: Wed, 25 Feb 2026 16:19:04 -0500
Message-ID: <20260225211907.7368-3-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260225211907.7368-1-James.Bottomley@HansenPartnership.com>
References: <20260225211907.7368-1-James.Bottomley@HansenPartnership.com>
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
index 6ef9f335bb17..203062a33def 100644
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

