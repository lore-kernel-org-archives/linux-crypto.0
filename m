Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA30A389453;
	Mon,  2 Mar 2026 08:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438481; cv=none; b=nzT85vlxDr7jtgWjKTRDkXtK9FmGgrsxqlRTwkkGgdy+SGriND3SNhPb4m7eX2rSkwTjEbViQJwvUvOsT46J4ciVR0TIq+PSIckPd9/Q8JfGnVJmQzcUGCjWK/r5pX1eW4Lznb3c8/BRJ/afqqE8ira2RIUuqI/krLQNJ1q1KHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438481; c=relaxed/simple;
	bh=tz1RfI1RIBkWoKN/08BYFSJL2jcKk0SDiHuNGe81jv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aw/E+m14xpSyyX2TrNqyssXO8D2wdLUtEEuNIhFK5dOcrm1+HV/k7xBmJBi6bsOhbLJuYDyDxkKGtWoot6nNBhHacK7NmY++rGxaTFDSJ1ftRySPSBljyC6Dakx6diT70L8lbQ0+/M66YXOuoVzD02qO+cLQjP08i71YSa1/lMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dtRdtLYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dtRdtLYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27978C19423;
	Mon,  2 Mar 2026 08:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438480;
	bh=tz1RfI1RIBkWoKN/08BYFSJL2jcKk0SDiHuNGe81jv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtRdtLYtR0wiZuhAQC7Gab7fZtK3xgEoZYQatoYwag+R4c58VGk0lr6s00F5FpHLG
	 Aa6VPlUYS3hIU9WR9RAsJjs4FK5rqeBqSusnY40QoWxqQqcVdd44eHMl2DllahNthS
	 RE13vqA7uYL+IGgeEUI6F4GLagSituI1HAjEeCwU3p5fuHhzhDvX0xAbkKF3DTtapW
	 w4ZQf0WQ2K4zXfAt+JN0gMnrjg01BNXOqpxp4CRofupiqYzkm7T6TZtWpTTp+BF6jm
	 Ux/RoWY0OJ6QH7JnOon8qmXpU1JqJI9LHXTDjmNU3HvBCqB9c3xzEF7rFqCCYKCJCm
	 4H4KCGZR1pBWg==
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
Subject: [PATCH 02/21] nvme-auth: common: constify static data
Date: Sun,  1 Mar 2026 23:59:40 -0800
Message-ID: <20260302075959.338638-3-ebiggers@kernel.org>
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

Fully constify the dhgroup_map and hash_map arrays.  Remove 'const' from
individual fields, as it is now redundant.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/nvme/common/auth.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 78d751481fe31..9e5cee217ff5c 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -34,13 +34,13 @@ u32 nvme_auth_get_seqnum(void)
 	mutex_unlock(&nvme_dhchap_mutex);
 	return seqnum;
 }
 EXPORT_SYMBOL_GPL(nvme_auth_get_seqnum);
 
-static struct nvme_auth_dhgroup_map {
-	const char name[16];
-	const char kpp[16];
+static const struct nvme_auth_dhgroup_map {
+	char name[16];
+	char kpp[16];
 } dhgroup_map[] = {
 	[NVME_AUTH_DHGROUP_NULL] = {
 		.name = "null", .kpp = "null" },
 	[NVME_AUTH_DHGROUP_2048] = {
 		.name = "ffdhe2048", .kpp = "ffdhe2048(dh)" },
@@ -85,14 +85,14 @@ u8 nvme_auth_dhgroup_id(const char *dhgroup_name)
 	}
 	return NVME_AUTH_DHGROUP_INVALID;
 }
 EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_id);
 
-static struct nvme_dhchap_hash_map {
+static const struct nvme_dhchap_hash_map {
 	int len;
-	const char hmac[15];
-	const char digest[8];
+	char hmac[15];
+	char digest[8];
 } hash_map[] = {
 	[NVME_AUTH_HASH_SHA256] = {
 		.len = 32,
 		.hmac = "hmac(sha256)",
 		.digest = "sha256",
-- 
2.53.0

