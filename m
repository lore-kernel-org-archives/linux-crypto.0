Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74F4430309;
	Tue, 15 Sep 2026 04:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789445714; cv=none; b=S6z3sCNsVsESpmR22UWhyQVq0OjFwsV6DAKDp9uPBil24mKFFObMyyGhl+SGzpi8ytARv7bOf0H4ObvtQlnQXCfh3hRUwG2UhOZBkbEKJnKTkcUuv/ELUIJ5dk6jICMfYDtLjW2CIfkKFHtboRRNXUwnLqpqbLOBw2PgQ+piYjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789445714; c=relaxed/simple;
	bh=/t6AG4zjpTCw0xw+mjvMqH7YR0FhCsUyB0xJEx6rsDg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OdYJuZ0vy27Gh4QpbSvggLWEhVAKWYX6yL6cyGkGerhgjkMelnqVBH5K8fh7I3TQXrPk5VPHI3JqyWCP3MbD7hFieGgzH5D6UbgNgQJDQGeAenxLEWnQFtp2bjaCMoG0lYbwK/Cm4hfMjf5Kp6yNNF/ecmgHvrh6E15tzvxf9TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowABXLvI_xqhqgEwICA--.5597S2;
	Tue, 15 Sep 2026 12:14:55 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: akhilrajeev@nvidia.com
Cc: davem@davemloft.net,
	herbert@gondor.apana.org.au,
	jonathanh@nvidia.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	thierry.reding@kernel.org,
	lkml@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH 4/4] crypto: tegra - fix host1x job leak in tegra_se_host1x_submit()
Date: Tue, 15 Sep 2026 04:14:26 +0000
Message-Id: <20260915041426.1725149-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABXLvI_xqhqgEwICA--.5597S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JFWkWFy3Aw4UZryxCF1Dtrb_yoWkGwb_uw
	1vqr9rX3yUGr4Iy3WUAr47ZrZYg343Xw1kKFWIv3W3Ga4UZr1UWFy7uFnIvr17Wa1kAFnr
	Za12qryrJr4a9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUw5l8UUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgkLA2qowR0VpQAAsp

If host1x_syncpt_wait() fails, e.g. when the job times out,
tegra_se_host1x_submit() returns without calling host1x_job_put(),
leaking the reference taken by host1x_job_alloc() together with the
syncpt reference held by the job.

Jump to the existing job_unpin label so the job is unpinned and put on
the wait failure path as well.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/crypto/tegra/tegra-se-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/tegra/tegra-se-main.c b/drivers/crypto/tegra/tegra-se-main.c
index eb71113ed146..1afbe5eb90af 100644
--- a/drivers/crypto/tegra/tegra-se-main.c
+++ b/drivers/crypto/tegra/tegra-se-main.c
@@ -180,7 +180,7 @@ int tegra_se_host1x_submit(struct tegra_se *se, struct tegra_se_cmdbuf *cmdbuf,
 				 MAX_SCHEDULE_TIMEOUT, NULL);
 	if (ret) {
 		dev_err(se->dev, "host1x job timed out\n");
-		return ret;
+		goto job_unpin;
 	}
 
 	host1x_job_put(job);
-- 
2.34.1

