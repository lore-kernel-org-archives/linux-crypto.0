Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDE2184
	for <linux-crypto@vger.kernel.org>; Sat,  2 Aug 2025 00:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754093163; cv=none; b=T/oBd68SoBPdWcWk4S2l1AZzC7B9zmj3GZMYRmuHGdytFduf1RpBpt0Ujep1AWiRTl9DVqpDULpXiFs5kXEln+/3HBfd1if/wOoHVxAaXzauVkFTD/PIJFJ1w5LBIIli7sRNb4kv7bP04OCFxUbSvYIsUBXZuwZXUiAGOMtGbc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754093163; c=relaxed/simple;
	bh=WrRRgd3ANQMPj6gOvH+yhbUB2Vtmo+S3MMLxXb+5IOI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eicgSsMtiu51aSoaUldB0Rru5rH6dk76H/09BO7Fzxnsf7B8UTdQUOj4A4MvPAEa63IUdOsVXy2Rou411cE0yXqbfQt04n4rzH0APnu5oF27lCgmo2vu/uPPIZYU+S0i5iinejucePJ0gCYP81Sz/uWPF23hXDRJXlVmTbZEiS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBEEObCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBEEObCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D37C4CEE7;
	Sat,  2 Aug 2025 00:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754093162;
	bh=WrRRgd3ANQMPj6gOvH+yhbUB2Vtmo+S3MMLxXb+5IOI=;
	h=From:To:Cc:Subject:Date:From;
	b=EBEEObCETSv01KM4gzbDFw3ulUwyjXSCB0GNGIANCOaSlQ/XmdMmoGTKts9Jixgci
	 TSs1x3/bHXjUkjAjfK8HxZYycha+SyxCk6F/rPxO0sddCQ41vB+uVB0W70pzSt1sK3
	 n7U20CExWIJUl1TOZ0/4bJhUeqHeMjGUV1vLpHlAt/hqRMa59IhLUkKeiwXm2A1dH9
	 BhEywt/YW/ARU2Mv0qBCg05Khb+QsTon5Obwt1U51mKWJCoM3YEW6lrM6rh7lltBIP
	 ++WywcYs3quVvHGY+ymMOq6OTzMGj7XooqgysOrgLVla2StY4Py/P++blvuXrecR+T
	 ASARVaC6PrCqQ==
From: Eric Biggers <ebiggers@kernel.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-crypto@vger.kernel.org,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Robert Foss <rfoss@kernel.org>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Hermes Wu <Hermes.wu@ite.com.tw>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] drm/bridge: it6505: Use SHA-1 library instead of crypto_shash
Date: Fri,  1 Aug 2025 17:05:48 -0700
Message-ID: <20250802000548.19354-1-ebiggers@kernel.org>
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

Note: this patch depends on the SHA-1 library functions that were merged
in v6.17-rc1.

 drivers/gpu/drm/bridge/Kconfig      |  3 +--
 drivers/gpu/drm/bridge/ite-it6505.c | 33 ++---------------------------
 2 files changed, 3 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index b9e0ca85226a6..89ac820a13e1e 100644
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
 	help
 	  ITE IT6505 DisplayPort bridge chip driver.
 
 config DRM_LONTIUM_LT8912B
 	tristate "Lontium LT8912B DSI/HDMI bridge"
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
 

base-commit: 0905809b38bda1fa0b206986c44d846e46f13c1d
-- 
2.50.1

