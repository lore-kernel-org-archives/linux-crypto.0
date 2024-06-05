Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A8F79DE;
	Wed,  5 Jun 2024 03:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717557937; cv=none; b=jERCPHxKChtxbjd6Ydfm/NF5z8mNcwTvGp7RL53VKtSxnjUKO/0EA2Vw3CPPMIEpG2YA97eamWhO84U8Zi8lgK4lZ7KXYulHYcutjyBAe5hmTb3ajk7KYZg7AV9BAIuDUHrOPWtRFB8fsFQzU/ytS2EBTeBNRif4rsGh1LAlKUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717557937; c=relaxed/simple;
	bh=iar+ScYHyGbSpwqZk7GsbhYJzP4tfyU039xANgAKi8E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NMOJ9LsrOQDMrN/BZVdd4ui+d8ssYXgzeQhFeSqso1kjHZCts38lzJPbWI8ZC9RuT7qF3tfhrtOqPi978YYW1I2Aem3LrIWbTU44f3o/aQoH36/+Lm23QtRt8fo484EhPjN0s3dyOTv+xhBD6AErctwrq/nvZXM6T991l+uQ9yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-03 (Coremail) with SMTP id rQCowADHzJA52V9mURJCDw--.61166S2;
	Wed, 05 Jun 2024 11:19:21 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: giovanni.cabiddu@intel.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	markas.rapoportas@intel.com,
	ahsan.atta@intel.com,
	mun.chun.yep@intel.com,
	xin.zeng@intel.com
Cc: qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] crypto: qat - add check for adf_cfg_add_key_value_param
Date: Wed,  5 Jun 2024 11:18:35 +0800
Message-Id: <20240605031835.2916052-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADHzJA52V9mURJCDw--.61166S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZrW3Jr15CFy7WrW5tw17Awb_yoWDWwb_Cr
	Z09ayaqryDCFn5Wrn8trWavrWj93s09ryruF1vvF4akasrGrsrKFykZr1DZF1Sqr1kWrn8
	u3Zayr1kAw47XjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkIecxEwVAFwVW8GwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUk3ktUUUUU=
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Add check for the return value of adf_cfg_add_key_value_param() and
return the error if it fails in order to catch the error.

Fixes: 4469f9b23468 ("crypto: qat - re-enable sriov after pf reset")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 drivers/crypto/intel/qat/qat_common/adf_sriov.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sriov.c b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
index 8d645e7e04aa..30ff9097f527 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
@@ -228,8 +228,10 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 		return ret;
 
 	val = 1;
-	adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC, ADF_SRIOV_ENABLED,
+	ret = adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC, ADF_SRIOV_ENABLED,
 				    &val, ADF_DEC);
+	if (ret)
+		return ret;
 
 	return numvfs;
 }
-- 
2.25.1

