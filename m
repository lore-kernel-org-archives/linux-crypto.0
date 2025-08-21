Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D2F275B06
	for <linux-crypto@vger.kernel.org>; Thu, 21 Aug 2025 17:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755799017; cv=none; b=uiqBaRgypdg5sd4j2Lc8BssCrNGWn72ZQxQOUHvN/nrkjcaOEBmEmSFcg9zW2VW9vBiEja52gsSLO5NlUswvvA07wzI5HMQeKF6ErsCRv7uU3epSzrjyXlyHsX39AWcpI2kaCl+SG97o0C+KadkYYDZ5RnnVEjbduziTecJUKT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755799017; c=relaxed/simple;
	bh=EHhqZaGmBIk8T1QKYgSmI0yThNrkSktwkJwZ+KdpEac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=axDd2E/dCNVDrMGJViBJk5LhqxXJHfO0uOX2XFLPKt9S+pgN5SYXZ/oU+RHxKL1JLYe6zwL10LzyKYTL4Z4O0v+TpdF+X700C44gAZysPYDOEg06PvOY7LG4GcEXq2RFrhJHcEA2W5GxXIz1ADCcSx4T+rRMGNImK+vaaWt2h1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qfBfj9/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qfBfj9/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD8AC4CEEB;
	Thu, 21 Aug 2025 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755799016;
	bh=EHhqZaGmBIk8T1QKYgSmI0yThNrkSktwkJwZ+KdpEac=;
	h=From:To:Cc:Subject:Date:From;
	b=qfBfj9/W6gg0glCpOThRbIMj6pG6Nh+pqoaKAiBP5f2Iy3/eUkSAnmG09o4e4Byje
	 eoLD6vlxUWBBEVrwiWJH/9ebUbypAfe+gVP3d2r1g8PMm8lypQp6AM7aEwDrGjaIPs
	 4oCxF2nXY3YZop95lBvwz8lM/jGaYAMJZ/J9+5EKk+cKuFxqeQCQHGVuWJuR6IeU8J
	 3j9S6Wo9NoF438Lohc6X7IsAYvaruRRtp3MoizvvWREymrNTEeGx+pq/qgr5zT7Cli
	 zwN05loHDUG21jD/cCk+r6VpEuK3Ki8oDPv3rvwwpGV/kfu1GaT8squVe/OeHFGlY3
	 SOE1aKhF+1osw==
From: Eric Biggers <ebiggers@kernel.org>
To: dri-devel@lists.freedesktop.org,
	Chen-Yu Tsai <wenst@chromium.org>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Robert Foss <rfoss@kernel.org>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH drm-next v2] drm/bridge: it6505: Use SHA-1 library instead of crypto_shash
Date: Thu, 21 Aug 2025 13:56:13 -0400
Message-ID: <20250821175613.14717-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of using the "sha1" crypto_shash, simply call the sha1() library
function.  This is simpler and faster.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

v2: rebased onto drm-next to resolve conflict in the Kconfig file

 drivers/gpu/drm/bridge/Kconfig      |  3 +--
 drivers/gpu/drm/bridge/ite-it6505.c | 33 ++---------------------------
 2 files changed, 3 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 6945029b35929..a250afd8d6622 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -118,12 +118,11 @@ config DRM_ITE_IT6505
 	select DRM_DISPLAY_HDCP_HELPER
 	select DRM_DISPLAY_HELPER
 	select DRM_DISPLAY_DP_AUX_BUS
 	select DRM_KMS_HELPER
 	select EXTCON
-	select CRYPTO
-	select CRYPTO_HASH
+	select CRYPTO_LIB_SHA1
 	select REGMAP_I2C
 	help
 	  ITE IT6505 DisplayPort bridge chip driver.
 
 config DRM_LONTIUM_LT8912B
diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 89649c17ffad9..a094803ba7aa4 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -19,11 +19,11 @@
 #include <linux/regulator/consumer.h>
 #include <linux/types.h>
 #include <linux/wait.h>
 #include <linux/bitfield.h>
 
-#include <crypto/hash.h>
+#include <crypto/sha1.h>
 
 #include <drm/display/drm_dp_helper.h>
 #include <drm/display/drm_hdcp_helper.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_bridge.h>
@@ -2105,39 +2105,10 @@ static void it6505_hdcp_part1_auth(struct it6505 *it6505)
 			HDCP_TRIGGER_START);
 
 	it6505->hdcp_status = HDCP_AUTH_GOING;
 }
 
-static int it6505_sha1_digest(struct it6505 *it6505, u8 *sha1_input,
-			      unsigned int size, u8 *output_av)
-{
-	struct shash_desc *desc;
-	struct crypto_shash *tfm;
-	int err;
-	struct device *dev = it6505->dev;
-
-	tfm = crypto_alloc_shash("sha1", 0, 0);
-	if (IS_ERR(tfm)) {
-		dev_err(dev, "crypto_alloc_shash sha1 failed");
-		return PTR_ERR(tfm);
-	}
-	desc = kzalloc(sizeof(*desc) + crypto_shash_descsize(tfm), GFP_KERNEL);
-	if (!desc) {
-		crypto_free_shash(tfm);
-		return -ENOMEM;
-	}
-
-	desc->tfm = tfm;
-	err = crypto_shash_digest(desc, sha1_input, size, output_av);
-	if (err)
-		dev_err(dev, "crypto_shash_digest sha1 failed");
-
-	crypto_free_shash(tfm);
-	kfree(desc);
-	return err;
-}
-
 static int it6505_setup_sha1_input(struct it6505 *it6505, u8 *sha1_input)
 {
 	struct device *dev = it6505->dev;
 	u8 binfo[2];
 	int down_stream_count, err, msg_count = 0;
@@ -2203,11 +2174,11 @@ static bool it6505_hdcp_part2_ksvlist_check(struct it6505 *it6505)
 	if (i <= 0) {
 		dev_err(dev, "SHA-1 Input length error %d", i);
 		return false;
 	}
 
-	it6505_sha1_digest(it6505, it6505->sha1_input, i, (u8 *)av);
+	sha1(it6505->sha1_input, i, (u8 *)av);
 	/*1B-05 V' must retry 3 times */
 	for (retry = 0; retry < 3; retry++) {
 		err = it6505_get_dpcd(it6505, DP_AUX_HDCP_V_PRIME(0), (u8 *)bv,
 				      sizeof(bv));
 

base-commit: dd489c01c3971778c417630f328460021fc8fc61
-- 
2.50.1

