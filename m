Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717CC3AD537;
	Mon, 15 Jun 2026 22:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781563320; cv=none; b=LztcmlMW//gG2e/vOoMnE6sNErIHocoEecCnggc18FK0appUnMUjo6zpjsG50pyFLJ/cy3niMhyTFDyRv4keO6LqTOvh+MsOdQER3Nv3XyDkQMD9XY1uJe9D0kulTmYPxmZKxqKi1b3ZBLi76uQ7DQ0L3cPrgvmQl+kNeEbYt8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781563320; c=relaxed/simple;
	bh=nH817WlNH0mznPTPZ+C0X94CpEuC0st/aKbM/Bcl0IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaHoi96iq3SKdBo+YfAEaQyQOKVq0m67vt+DE4fFtiaKswp6tm0X3suI1ieoxfFxpcMAn6NXZ5QYFtm8YBMwEjtywva2JHRKPG9oEcvG4CFcSTs81O0S1i2h70+1CGjnIzz2tAUU/h2aGZ2I7nbNpn0FG3LcbpUcvEk8mrzBHLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gd84LM6x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gd84LM6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5291F00A3A;
	Mon, 15 Jun 2026 22:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781563319;
	bh=Zka1VrEutdqlVG4YdfZ4t9q/QPVwvFlN8ho8kFu3dFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gd84LM6xJOVkKwoHL1z6ivwGRZy3VTWWz7y501GFo35fcRgYKE99JByZ3rXPlizVr
	 ZjU1+2w0A2sWEtf3RnKS5lsxBY76DuSt5mCxf+BrTWuLAaeUG5eXF/BUQHdT+saCOz
	 GHSVDRJPczonBxzAVnIRx9hhNhrggOaMocr3OQKoHPzI3Ge/0r9orwVhdATTtmnhxB
	 ggeUHAxNaevmkH0+G4SNCUqx5iQZRg2GkDOLeJu/Xseh5GwJX8zyAzaWVBWjNfd+cO
	 ljGWjDS1S4xT4Cvr7dwrH/KoAXwLBaqYPGiAfZhdVBxwHmTxBsrLGCrr7BbYvBhvOZ
	 xBBNf8MOGL0QQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Gaurav Jain <gaurav.jain@nxp.com>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/7] crypto: qcom-rng - Enable clock in hwrng case
Date: Mon, 15 Jun 2026 15:41:25 -0700
Message-ID: <20260615224131.69370-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615224131.69370-1-ebiggers@kernel.org>
References: <20260615224131.69370-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix qcom-rng.c to enable the clock before accessing the hardware.

Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/qcom-rng.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index 150e5802e351..f31a7fe07ba7 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -111,17 +111,31 @@ static int qcom_rng_seed(struct crypto_rng *tfm, const u8 *seed,
 			 unsigned int slen)
 {
 	return 0;
 }
 
+static int qcom_hwrng_init(struct hwrng *hwrng)
+{
+	struct qcom_rng *qrng = container_of(hwrng, struct qcom_rng, hwrng);
+
+	return clk_prepare_enable(qrng->clk);
+}
+
 static int qcom_hwrng_read(struct hwrng *hwrng, void *data, size_t max, bool wait)
 {
 	struct qcom_rng *qrng = container_of(hwrng, struct qcom_rng, hwrng);
 
 	return qcom_rng_read(qrng, data, max);
 }
 
+static void qcom_hwrng_cleanup(struct hwrng *hwrng)
+{
+	struct qcom_rng *qrng = container_of(hwrng, struct qcom_rng, hwrng);
+
+	clk_disable_unprepare(qrng->clk);
+}
+
 static int qcom_rng_enable(struct qcom_rng *rng)
 {
 	u32 val;
 	int ret;
 
@@ -206,11 +220,13 @@ static int qcom_rng_probe(struct platform_device *pdev)
 		return ret;
 	}
 
 	if (rng->match_data->hwrng_support) {
 		rng->hwrng.name = "qcom_hwrng";
+		rng->hwrng.init = qcom_hwrng_init;
 		rng->hwrng.read = qcom_hwrng_read;
+		rng->hwrng.cleanup = qcom_hwrng_cleanup;
 		rng->hwrng.quality = QCOM_TRNG_QUALITY;
 		ret = devm_hwrng_register(&pdev->dev, &rng->hwrng);
 		if (ret) {
 			dev_err(&pdev->dev, "Register hwrng failed: %d\n", ret);
 			qcom_rng_dev = NULL;
-- 
2.54.0

