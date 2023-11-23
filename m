Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Greylist: delayed 896 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Nov 2023 23:27:24 PST
Received: from aliyun-sdnproxy-2.icoremail.net (aliyun-cloud.icoremail.net [47.90.88.91])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id CCAE3F9;
	Wed, 22 Nov 2023 23:27:24 -0800 (PST)
Received: from localhost.localdomain (unknown [10.190.64.46])
	by mail-app4 (Coremail) with SMTP id cS_KCgBHLrFu+V5lewebAQ--.3032S4;
	Thu, 23 Nov 2023 15:04:22 +0800 (CST)
From: Dinghao Liu <dinghao.liu@zju.edu.cn>
To: dinghao.liu@zju.edu.cn
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccp - fix memleak in ccp_init_dm_workarea
Date: Thu, 23 Nov 2023 15:03:37 +0800
Message-Id: <20231123070337.11600-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:cS_KCgBHLrFu+V5lewebAQ--.3032S4
X-Coremail-Antispam: 1UD129KBjvdXoWruw4DGF15ZF1fAw15Gr45Jrb_yoWfWrbE9r
	WUu3W7Wrs5Gw1293W2gr4rZr1Sv3ySqFs7CF18tFnxtry5CFs7ua4I9FnrAr1IvFW7WFWD
	Ca17XFyfZrn3ZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb28Fc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
	wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
	vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2
	jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
	x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
	GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
	8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv
	6cx26r4fKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGw
	C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48J
	MIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMI
	IF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
	87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgkMBmVKSCoDUABbsE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

When dma_map_single() fails, we should free wa->address to
prevent potential memleak.

Fixes: 63b945091a07 ("crypto: ccp - CCP device driver and interface support")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/crypto/ccp/ccp-ops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index aa4e1a500691..45552ae6347e 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -179,8 +179,10 @@ static int ccp_init_dm_workarea(struct ccp_dm_workarea *wa,
 
 		wa->dma.address = dma_map_single(wa->dev, wa->address, len,
 						 dir);
-		if (dma_mapping_error(wa->dev, wa->dma.address))
+		if (dma_mapping_error(wa->dev, wa->dma.address)) {
+			kfree(wa->address);
 			return -ENOMEM;
+		}
 
 		wa->dma.length = len;
 	}
-- 
2.17.1

