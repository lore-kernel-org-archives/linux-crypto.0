Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C840C3A0B2B;
	Mon,  2 Mar 2026 08:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438488; cv=none; b=IGLk4mEDelINWxPTkdPo+bCG9Tw0kKjh+T3KOEaklbcS1+LFyqWPfX+Sde4Gh+yF3GylPNcT4Xo9+d7PHGhMr+AHJCdloMPwkK9VKWSGKt/G6vaq8fZya0Depi/5jbgbtY87SnHEX29racusKEJ5owscINBdMEkpD2KC3QEXiyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438488; c=relaxed/simple;
	bh=Omn4aX96GTToOSEoh8ejKEWlhlIaPsxh0SUDDsoG/yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBmhM2xodonniLTow1hwrdYEkNoQIRpP6MFB2PbHATXsw9jAg7DWBFjVmpZTNRTvrisABYqT+5SatdscFbJTXSz2p/devP7PRRcp/KiXXowYPmf/sG4NLNoU4CKG7CycXlApXFOGPQlQlQlu0tqvwmWsvXIclhwVFS3XlSGpypo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qjSrsvUO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qjSrsvUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06729C2BCAF;
	Mon,  2 Mar 2026 08:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438488;
	bh=Omn4aX96GTToOSEoh8ejKEWlhlIaPsxh0SUDDsoG/yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjSrsvUOYvJaUvrNXFV40bkKpL0BPzLNIlJv0uVsi/n0f5MjlkUoV/MgbMdUrn5z/
	 ZWzhuVJOG/BcEL9GbUYKtVuzY89wCG7FHQN9D99lKxCvO85gK4uoQaZv6pBbHrS9dA
	 hva4WY2cB6FpPdZzDn4vkvjIbZocUpXQmyxheHbTRjs3QDQ9UiaDHWOdO15L7DJ5se
	 mpVdPlGd6Aji3v7NYe3rFZcx7ln48oPobvJOQm9UerIl2v0OhqgMjAWl3Ba6qfbrUh
	 Sa+nuks4h3CznBzHLB8u6wK0qTyyhMdPPu1idfa2tR5du69SkydNEMgb6MMCn7ybWQ
	 oau3iep3Jm3KA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-nvme@lists.infradead.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 19/21] nvme-auth: common: remove nvme_auth_digest_name()
Date: Sun,  1 Mar 2026 23:59:57 -0800
Message-ID: <20260302075959.338638-20-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302075959.338638-1-ebiggers@kernel.org>
References: <20260302075959.338638-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since nvme_auth_digest_name() is no longer used, remove it and the
associated data from the hash_map array.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/nvme/common/auth.c | 12 ------------
 include/linux/nvme-auth.h  |  1 -
 2 files changed, 13 deletions(-)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 5be86629c2d41..2d325fb930836 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -87,26 +87,22 @@ u8 nvme_auth_dhgroup_id(const char *dhgroup_name)
 EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_id);
 
 static const struct nvme_dhchap_hash_map {
 	int len;
 	char hmac[15];
-	char digest[8];
 } hash_map[] = {
 	[NVME_AUTH_HASH_SHA256] = {
 		.len = 32,
 		.hmac = "hmac(sha256)",
-		.digest = "sha256",
 	},
 	[NVME_AUTH_HASH_SHA384] = {
 		.len = 48,
 		.hmac = "hmac(sha384)",
-		.digest = "sha384",
 	},
 	[NVME_AUTH_HASH_SHA512] = {
 		.len = 64,
 		.hmac = "hmac(sha512)",
-		.digest = "sha512",
 	},
 };
 
 const char *nvme_auth_hmac_name(u8 hmac_id)
 {
@@ -114,18 +110,10 @@ const char *nvme_auth_hmac_name(u8 hmac_id)
 		return NULL;
 	return hash_map[hmac_id].hmac;
 }
 EXPORT_SYMBOL_GPL(nvme_auth_hmac_name);
 
-const char *nvme_auth_digest_name(u8 hmac_id)
-{
-	if (hmac_id >= ARRAY_SIZE(hash_map))
-		return NULL;
-	return hash_map[hmac_id].digest;
-}
-EXPORT_SYMBOL_GPL(nvme_auth_digest_name);
-
 u8 nvme_auth_hmac_id(const char *hmac_name)
 {
 	int i;
 
 	if (!hmac_name || !strlen(hmac_name))
diff --git a/include/linux/nvme-auth.h b/include/linux/nvme-auth.h
index 940d0703eb1df..184a1f9510fad 100644
--- a/include/linux/nvme-auth.h
+++ b/include/linux/nvme-auth.h
@@ -19,11 +19,10 @@ u32 nvme_auth_get_seqnum(void);
 const char *nvme_auth_dhgroup_name(u8 dhgroup_id);
 const char *nvme_auth_dhgroup_kpp(u8 dhgroup_id);
 u8 nvme_auth_dhgroup_id(const char *dhgroup_name);
 
 const char *nvme_auth_hmac_name(u8 hmac_id);
-const char *nvme_auth_digest_name(u8 hmac_id);
 size_t nvme_auth_hmac_hash_len(u8 hmac_id);
 u8 nvme_auth_hmac_id(const char *hmac_name);
 struct nvme_auth_hmac_ctx {
 	u8 hmac_id;
 	union {
-- 
2.53.0

