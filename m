Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D342DC340
	for <linux-crypto@vger.kernel.org>; Wed, 20 Aug 2025 09:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755681148; cv=none; b=W1W1o3IWAexBE1H1skw8+Ublff+q6S24pEr8b5EdrUnX35lQL8uPsnldoYa8rLJwZdH+fltHy85Ssizjj/xnmDJcZcOXkgHJ3216/l7VgNr5ERn1yaOgTu2h4g8llFvRnfgPIp5I+x8Vrjs+kOGvX82OvjdbcQ2Le6ZFw2qw8ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755681148; c=relaxed/simple;
	bh=pMfSvaExQHHkwM3rVWhpbkvPdA+fq4O1VYkNwpioE2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWzDsHNtb60kCP7sd7cEIfcSSBcDFvugFpw5LkKMpwS4g5VnAMauI7LvyNWFsKdm3nW5F0uTffc97ObjuU5zpnHWpNTe2bvcvVMOhJCalw3IJRH49v0g07cROc9iBmjpZ2EDUWX4KYN38SZkR3Z4qPqNjhmJnw/pYKlJfJ6Xmsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QXL05qEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QXL05qEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D96DC116B1;
	Wed, 20 Aug 2025 09:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755681146;
	bh=pMfSvaExQHHkwM3rVWhpbkvPdA+fq4O1VYkNwpioE2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXL05qEgwqPke6/6Dq1D9ySgcSua1cKaQFZ91coRY5q//tD+4DF1MPtANddJIiYB9
	 QLaLKTusLyvkaLpfIJkwPf2U0Ohy7zYF3djHa+QNA/0lv1VWkram24gm++Uy4R4E4A
	 PVy7lBl8v//iekOMaYSVHOCMrdA68Ibe8nXB2mNy6ZT2O90wBYwk43XI14HuVXVHXf
	 x/R0jFEjsfTB3cPD/oTPGErhwVrowHNjZqDZuULYX5qaqP/QKhlfaPnW8tzcFXiZdy
	 2jCYoN27CkWIEP2ZaQnu2zw1qIcHRejm96faKXmfSFb8IH0AOyB9M+VCATtStwxRGA
	 YwzCxyNDXkAwQ==
From: hare@kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chris Leech <cleech@redhat.com>,
	linux-nvme@lists.infradead.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 2/2] nvme-auth: use hkdf_expand_label()
Date: Wed, 20 Aug 2025 11:12:11 +0200
Message-ID: <20250820091211.25368-3-hare@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820091211.25368-1-hare@kernel.org>
References: <20250820091211.25368-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hannes Reinecke <hare@kernel.org>

When generating keying material during an authentication transaction
(secure channel concatenation), the HKDF-Expand-Label function is part
of the specified key derivation process.

The current open-coded implementation misses the length prefix
requirements on the HkdfLabel label and context variable-length vectors
(RFC 8446 Section 3.4).

Instead, use the hkdf_expand_label() function.

Signed-off-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/nvme/common/auth.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 91e273b89fea..5ea4d6d9a394 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -715,10 +715,10 @@ int nvme_auth_derive_tls_psk(int hmac_id, u8 *psk, size_t psk_len,
 {
 	struct crypto_shash *hmac_tfm;
 	const char *hmac_name;
-	const char *psk_prefix = "tls13 nvme-tls-psk";
+	const char *label = "nvme-tls-psk";
 	static const char default_salt[HKDF_MAX_HASHLEN];
-	size_t info_len, prk_len;
-	char *info;
+	size_t prk_len;
+	const char *ctx;
 	unsigned char *prk, *tls_key;
 	int ret;
 
@@ -758,36 +758,29 @@ int nvme_auth_derive_tls_psk(int hmac_id, u8 *psk, size_t psk_len,
 	if (ret)
 		goto out_free_prk;
 
-	/*
-	 * 2 additional bytes for the length field from HDKF-Expand-Label,
-	 * 2 additional bytes for the HMAC ID, and one byte for the space
-	 * separator.
-	 */
-	info_len = strlen(psk_digest) + strlen(psk_prefix) + 5;
-	info = kzalloc(info_len + 1, GFP_KERNEL);
-	if (!info) {
+	ctx = kasprintf(GFP_KERNEL, "%02d %s", hmac_id, psk_digest);
+	if (!ctx) {
 		ret = -ENOMEM;
 		goto out_free_prk;
 	}
 
-	put_unaligned_be16(psk_len, info);
-	memcpy(info + 2, psk_prefix, strlen(psk_prefix));
-	sprintf(info + 2 + strlen(psk_prefix), "%02d %s", hmac_id, psk_digest);
-
 	tls_key = kzalloc(psk_len, GFP_KERNEL);
 	if (!tls_key) {
 		ret = -ENOMEM;
-		goto out_free_info;
+		goto out_free_ctx;
 	}
-	ret = hkdf_expand(hmac_tfm, info, info_len, tls_key, psk_len);
+	ret = hkdf_expand_label(hmac_tfm,
+				label, strlen(label),
+				ctx, strlen(ctx),
+				tls_key, psk_len);
 	if (ret) {
 		kfree(tls_key);
-		goto out_free_info;
+		goto out_free_ctx;
 	}
 	*ret_psk = tls_key;
 
-out_free_info:
-	kfree(info);
+out_free_ctx:
+	kfree(ctx);
 out_free_prk:
 	kfree(prk);
 out_free_shash:
-- 
2.43.0

