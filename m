Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C826E352C3C;
	Mon,  8 Jun 2026 18:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780941688; cv=none; b=JKLpgZlYFkOmNsvWLym6q2Lt0Eh5t44O1KjQ6vfIsXXsctrogaPsfwJLFqwkf/rrqNx+b778ec40l8eITzjTxnA5+hvnzWPPclcwyu6diHnedGesOg+/13b+Ny1o24XE9FRiHDa7SAdfVMFRX/GPDeQ1SfEduooVe25+N5zlKcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780941688; c=relaxed/simple;
	bh=BRJ016VJdosMwgiSW0oF/2D/T+YA+b0VZUFUgC8m9zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxYI+PFdRToFCsi0UQKZ7NR3nJgCgemfb0r3iX2rjkFzKj2JqvAtpL+ar2aCgjfa36nQpL+75amzl46HbEwGmSEYxc0htoZxusuR6CB/M/ta/hwUaOZ8lkdOXeH8QAs/BEmZ84FCf5npWxbuBrVn1klFH37Tji7z3loUlyqsgMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oVUVsonG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oVUVsonG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFA41F00898;
	Mon,  8 Jun 2026 18:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780941687;
	bh=/whdzcnMjfpWJ73xv7F341p5nxH44rSw6IJA2MsAdDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVUVsonGwSyS5vJfC2A+ARcQ6zhE6kbabnJgpS5riReNi3+oH8TekYtWZ7tYdbGSj
	 QHy962/V+sImOSAkhUPBd7CAGsRzG6iLhEehh75MBYDNtHhUUa7YAFQmQi/qUmZNqE
	 L+jMaEOqtfOtOLQau87EDumSA3ZFQ9ta20J5eSeeQow5Rg+M1jI1ENR6OT6CkXl+/i
	 EMgXudYrvNSQWzS+Mu0ztqPSD0KiPbkfKWibHouckSQhf3uEF1lMLQx18HfFFU3HJx
	 +e4nBa505ukZpsgP5otZBPRAXV13Wq4w974NaB3LtxUmdgfMEwPBM8D5QuirsSbZWs
	 lcqpMKCG1t1tg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Om Prakash Singh <quic_omprsing@quicinc.com>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	linux-arm-msm@vger.kernel.org,
	Olivia Mackall <olivia@selenic.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/4] crypto: qcom-rng - Enable clock in hwrng case
Date: Mon,  8 Jun 2026 17:58:45 +0000
Message-ID: <20260608175848.2045229-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0.1064.gd145956f57-goog
In-Reply-To: <20260608175848.2045229-1-ebiggers@kernel.org>
References: <20260608175848.2045229-1-ebiggers@kernel.org>
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
2.54.0.1064.gd145956f57-goog

