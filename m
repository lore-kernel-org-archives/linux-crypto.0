Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DB6524D
	for <linux-crypto@vger.kernel.org>; Thu,  9 Nov 2023 02:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9789E26A2;
	Wed,  8 Nov 2023 18:13:57 -0800 (PST)
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowAA3GA1cQExlCNVSAQ--.21340S2;
	Thu, 09 Nov 2023 10:13:48 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: qianweili@huawei.com,
	wangzhou1@hisilicon.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	xuzaibo@huawei.com,
	tanshukun1@huawei.com
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] crypto: hisilicon - Add check for pci_find_ext_capability
Date: Thu,  9 Nov 2023 02:13:08 +0000
Message-Id: <20231109021308.1859881-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAA3GA1cQExlCNVSAQ--.21340S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtw1fuF4UCrWUXryrGF4xXrb_yoW3Krg_Cw
	1UuFyxWryjkF1kZ3ZY939rZrWav3W3Z3WkXF40q3sIyasrZ3y3WFWxXF4DZw17Xa17Aas8
	uws7Gr93A3ZrZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb2AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_Gr1l
	42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
	WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAK
	I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r
	4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
	6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUyxRDUUUUU=
X-Originating-IP: [124.16.138.129]
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Add check for pci_find_ext_capability() and return the error if it
fails in order to transfer the error.

Fixes: 6c6dd5802c2d ("crypto: hisilicon/qm - add controller reset interface")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 drivers/crypto/hisilicon/qm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 18599f3634c3..adbab1286d4a 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3967,6 +3967,9 @@ static int qm_set_vf_mse(struct hisi_qm *qm, bool set)
 	int i;
 
 	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_SRIOV);
+	if (!pos)
+		return -ENODEV;
+
 	pci_read_config_word(pdev, pos + PCI_SRIOV_CTRL, &sriov_ctrl);
 	if (set)
 		sriov_ctrl |= PCI_SRIOV_CTRL_MSE;
-- 
2.25.1

