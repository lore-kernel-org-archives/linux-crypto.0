Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6A03A759C;
	Thu,  4 Jun 2026 10:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780568852; cv=none; b=rlNOH3Yp3vrIHAmvG1h1+m/wO2zXn8N2HMKTkSf96ftKXt6hsdurswA4ChvGq6P0N3ZP7SYgduqJU/33GR2jS+SPUqBMwPij/vzE/vL3IYk1GLm7vn/bhYIuPhGlvzisz9Ppq8VwG5TqNb4RdaysDSMJfG2Ywco/75yMi0Pynq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780568852; c=relaxed/simple;
	bh=als/dxOGF3vxwARVfzOa2gkKyEh9l70RPOinUzZ6Wr4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BgLl7d+LNyXgh+SiWjqfBDoFK8o0wD7GvUE4ioL3aF1R8rG33AdtGZqFTMMQltyuvAxatuUxROaDO3mgiVUo9v2Q3h18oFcAF9DJklYGVaU1b464IpwXENFmA3ILMHKbqh7maFOl4oSEC8Lgjf165c1fUB8mAvzhSU2xMpbv8AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowADnh9AEUyFqknqXAA--.107S2;
	Thu, 04 Jun 2026 18:27:16 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: akhilrajeev@nvidia.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	thierry.reding@kernel.org,
	jonathanh@nvidia.com
Cc: linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: tegra: fix refcount leak in tegra_se_host1x_submit()
Date: Thu,  4 Jun 2026 10:27:06 +0000
Message-Id: <20260604102706.3787771-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADnh9AEUyFqknqXAA--.107S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uF4Utw17Ww47Cr4DJr4rAFb_yoW8Jw43pF
	Z0k3yqyr98Jr4rGFn7JF48CFy093y3ZryDGw4fAa42yrs8JFyUAF43CFWjvay8WrsYgr12
	qFZrA3y5ur18uaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUrrWFUUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCREIA2ohQhU22gAAsj

The timeout error path in tegra_se_host1x_submit() returns without
calling host1x_job_put(), while all other paths (success, submit
error, pin error) properly release the job reference through the
job_put label.  Since host1x_job_alloc() initializes the reference
count and host1x_job_put() is required to drop it, omitting it on
timeout causes a permanent refcount leak.

Fix this by redirecting the timeout return to the existing job_put
label, ensuring the job reference and any associated syncpt
references are consistently released.

Cc: stable@vger.kernel.org
Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/crypto/tegra/tegra-se-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/tegra/tegra-se-main.c b/drivers/crypto/tegra/tegra-se-main.c
index eb71113ed146..e8d8c3a23d7a 100644
--- a/drivers/crypto/tegra/tegra-se-main.c
+++ b/drivers/crypto/tegra/tegra-se-main.c
@@ -180,7 +180,7 @@ int tegra_se_host1x_submit(struct tegra_se *se, struct tegra_se_cmdbuf *cmdbuf,
 				 MAX_SCHEDULE_TIMEOUT, NULL);
 	if (ret) {
 		dev_err(se->dev, "host1x job timed out\n");
-		return ret;
+		goto job_put;
 	}
 
 	host1x_job_put(job);
-- 
2.34.1

