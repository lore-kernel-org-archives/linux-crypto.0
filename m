Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3C735C1BF
	for <linux-crypto@vger.kernel.org>; Thu, 19 Mar 2026 19:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773947593; cv=none; b=cB0rwTpY9A7sYzu3oqn+BkNELA2ptuyyE3wDOivORGyjfl6jYLfw20sSQsFgvnMDQlr0Ws9+192XX07fV+NdMX6PkW9yBVgP+f1RPCGlRUwlMu8UmVUQkAhYKzRHBjz6VYGYvvCOnv5zXjgxZB8VFriunpDGSnjBT/Kz3S6ZYSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773947593; c=relaxed/simple;
	bh=ao/Nb0xWw8qp5XTzYlgOXNIQcjs9ei7dKDHmRQ3A7Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1g4oJNAgC1n5MNIDST7/KoogXxQZ6yfQPOFRxM7QzuECTeOlMBBTMiUyv7k25GT35bvnWOwAcFrICg2t4hYAfnfxJY9pcFvAWFrkmhPa2oIXGBRvGQncJ9P4PiZ0dtSsQuyVZ2MDua+d5AOMK30d7MAaVm3nH0fj6zMZbskVpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=jugC8VfN; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="jugC8VfN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1773947591;
	bh=ao/Nb0xWw8qp5XTzYlgOXNIQcjs9ei7dKDHmRQ3A7Eo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:From;
	b=jugC8VfN1H8DiJRFRea3PCzLPq9KQ/xzNTBgFv5RwOjCRcLjS/uER2xwHnmLp9r9a
	 +iPHTi9D4MJ+ThrY/fTJy/TwPXTOCVcNvLHIVvpRqZJQAXBqd28e0y0JHfvdBkLJIp
	 24xjjgM6vqk84uZvBcB6y8F7IskYptF5LfmjCxIg=
Received: from lingrow.int.hansenpartnership.com (unknown [153.66.160.227])
	by lamorak.hansenpartnership.com (Postfix) with ESMTP id 266911C02E8;
	Thu, 19 Mar 2026 15:13:11 -0400 (EDT)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Blaise Boscaccy <bboscaccy@linux.microsoft.com>
Subject: [PATCH v4 1/3] crypto: pkcs7: add flag for validated trust on a signed info block
Date: Thu, 19 Mar 2026 15:12:06 -0400
Message-ID: <20260319191208.831-2-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260319191208.831-1-James.Bottomley@HansenPartnership.com>
References: <20260319191208.831-1-James.Bottomley@HansenPartnership.com>
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
via validate_pkcs7_trust().  Since the way to get this trusted pkcs7
object is via verify_pkcs7_message_sig, export that so modules can use
it.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 certs/system_keyring.c                | 1 +
 crypto/asymmetric_keys/pkcs7_parser.h | 1 +
 crypto/asymmetric_keys/pkcs7_trust.c  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/certs/system_keyring.c b/certs/system_keyring.c
index e0761436ec7f..9bda49295bd0 100644
--- a/certs/system_keyring.c
+++ b/certs/system_keyring.c
@@ -380,6 +380,7 @@ int verify_pkcs7_message_sig(const void *data, size_t len,
 	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;
 }
+EXPORT_SYMBOL(verify_pkcs7_message_sig);
 
 /**
  * verify_pkcs7_signature - Verify a PKCS#7-based signature on system data.
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

