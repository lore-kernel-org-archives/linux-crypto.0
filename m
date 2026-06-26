Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D80B3F39CF;
	Fri, 26 Jun 2026 12:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782476105; cv=none; b=hbHYJjhPAogYb3aOu2PgCdgcHoEqB0nGN4RIvSD4a4wVwMHeKWJnEfuiXJf3ND6cDIxnVj8phq0bHNa/hRe8IEORIqaPCBSMgp8IP9CbK4iW6Zp+K9tV0GWyFX7b8WmCcSqC2wbFh7zimW21p5ObYvyKTTWh1xwzw+5EyeP7DH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782476105; c=relaxed/simple;
	bh=BwvsnC4UhZyqxd7c8+4jOgiwbvv8x7zN1b6evwCzP+4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hf+Dpx6AlBSHHkTiX/khL0mC4L7g9Y/QuYLMSnDhXBXcQKU4VRag6o9RyEyTJdzsXTwn/79U+U1QX66vT6+jOsnjBVXcbSLGed6daTj6CIVdJHPvOwLQojy4RRw5K6fu52C/2DPZ54ljrs3U7qOPuv9l3+CnqHZn1aRSPA8cCAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [117.182.75.66])
	by APP-05 (Coremail) with SMTP id zQCowABXo8Y_bT5qWZJnFQ--.31905S2;
	Fri, 26 Jun 2026 20:14:56 +0800 (CST)
From: WenTao Liang <vulab@iscas.ac.cn>
To: akhilrajeev@nvidia.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	thierry.reding@kernel.org,
	jonathanh@nvidia.com
Cc: linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WenTao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] fix: crypto/tegra: tegra_se_host1x_submit: timeout path leaks host1x_job   reference
Date: Fri, 26 Jun 2026 20:14:53 +0800
Message-Id: <20260626121453.35043-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABXo8Y_bT5qWZJnFQ--.31905S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKry5Kw43Xr1rAFW7uFWfZrb_yoWDCrX_ur
	9Fgr1xX3yUJr4xZw47Cr4xZFZY9343Xw18KayjvasxG34UZw47WFyxurnI9r48G3ykJF1D
	u3W2qryrtr4Y9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
	C2KfnxnUUI43ZEXa7VUbzpBDUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCREKA2o+TZNhhAAAs+

When host1x_syncpt_wait returns a timeout error, the function returns ret
  directly without calling host1x_job_put(job). The job reference acquired
  by host1x_job_alloc is properly released on all other error paths via the
  job_put label but is missing on the timeout path.

Cc: stable@vger.kernel.org
Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
---
 drivers/crypto/tegra/tegra-se-main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/tegra/tegra-se-main.c b/drivers/crypto/tegra/tegra-se-main.c
index eb71113ed146..7fbf69236ff2 100644
--- a/drivers/crypto/tegra/tegra-se-main.c
+++ b/drivers/crypto/tegra/tegra-se-main.c
@@ -180,6 +180,7 @@ int tegra_se_host1x_submit(struct tegra_se *se, struct tegra_se_cmdbuf *cmdbuf,
 				 MAX_SCHEDULE_TIMEOUT, NULL);
 	if (ret) {
 		dev_err(se->dev, "host1x job timed out\n");
+		host1x_job_put(job);
 		return ret;
 	}
 
-- 
2.39.5 (Apple Git-154)

