Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2ADD2F417C;
	Tue,  6 May 2025 03:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746501589; cv=none; b=b4HuT9lSSX7uEyFWgxkQ5EeBIhYdLfsBfI8TgnoyHBOaC+w2yKrZN2D/Hgu/buU/0yYUK3ctDgLxX2YGfb1ZVXttACoL31Dfkx/ltg+5l/ZTYwZIy7UCrbuVq0aiizWv4vYqck5S4PJgR5Nt2TuGunODJMKN9NVqVzRQCDH7DF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746501589; c=relaxed/simple;
	bh=zqF6QTBzffxsZMW0fO1fWtYNslKqS3mmFRaKT3EOsI0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GZ1SG8jTVxK9zRfAEh+8nwhaI3kkn9VUQpcxoQbBTx5L+Rfr7pgqrAJvijAI2cp84XDYjEHdy9P1dl3UCEb2cLh0xxBp/jw4AG1hsDsF+1cQb5NbKylxbBfIMt15e7/8qeJU+leTPNndUhR5OUVi9mqKKKluds+XZhMWJcNpbs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.40.54.178])
	by gateway (Coremail) with SMTP id _____8CxeXHOfxloz0rWAA--.23435S3;
	Tue, 06 May 2025 11:19:42 +0800 (CST)
Received: from localhost.localdomain (unknown [10.40.54.178])
	by front1 (Coremail) with SMTP id qMiowMDxvhvLfxloNri1AA--.14266S2;
	Tue, 06 May 2025 11:19:39 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
To: lee@kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	peterhuewe@gmx.de,
	jarkko@kernel.org
Cc: linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	jgg@ziepe.ca,
	linux-integrity@vger.kernel.org,
	pmenzel@molgen.mpg.de,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH v9 5/5] MAINTAINERS: Add tpm_loongson.c to LOONGSON CRYPTO DRIVER entry
Date: Tue,  6 May 2025 11:20:53 +0800
Message-ID: <20250506032053.11147-1-zhaoqunqin@loongson.cn>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxvhvLfxloNri1AA--.14266S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj9xXoW7GFyftFyrAF48Jr1rCw1xJFc_yoW3Kwb_Ca
	y2q397Wr18GF1Ig34SvF97Za1YqrW3X3Wxu3WDt34fX34qyr9xtrnrAF4kK3W3urW8GFZx
	uayxG3Z3Ar1fZosvyTuYvTs0mTUanT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUbfAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26rWY6Fy7
	McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr4
	1lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_Ar0_tr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4
	v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AK
	xVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0_WrPUUUUU==

Changes to Loongson TPM driver would be best reviewed by the Loongson
crypto driver maintainers.

Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v8-v9: None 
v7: Added tag from Jarkko and Huacai
v6: "tpm_lsse.c" -> "tpm_loongson"
v4-v5: None

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2d696671e..acbb127f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13935,6 +13935,7 @@ LOONGSON CRYPTO DRIVER
 M:	Qunqin Zhao <zhaoqunqin@loongson.cn>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
+F:	drivers/char/tpm/tpm_loongson.c
 F:	drivers/crypto/loongson/
 F:	drivers/mfd/loongson-se.c
 F:	include/linux/mfd/loongson-se.h
-- 
2.45.2

