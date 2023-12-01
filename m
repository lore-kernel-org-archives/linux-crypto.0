Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BF410FF
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 00:16:49 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ShQrX3Cz0z4f3jqX
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 16:16:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 6438B1A01D7
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 16:16:45 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.103.91])
	by APP1 (Coremail) with SMTP id cCh0CgCn9gxplmllkWe4CQ--.30052S4;
	Fri, 01 Dec 2023 16:16:45 +0800 (CST)
From: Yang Yingliang <yangyingliang@huaweicloud.com>
To: linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com
Cc: herbert@gondor.apana.org.au,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	gatien.chevallier@foss.st.com,
	yangyingliang@huawei.com
Subject: [PATCH] hwrng: stm32 - add missing clk_disable_unprepare() in stm32_rng_init()
Date: Fri,  1 Dec 2023 16:20:48 +0800
Message-Id: <20231201082048.1975940-1-yangyingliang@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCn9gxplmllkWe4CQ--.30052S4
X-Coremail-Antispam: 1UD129KBjvdXoWrKrW8trW8Aw4ktrW8uF1kGrg_yoWfJrg_CF
	1xZ3yIgFyIgFy7Aw1qv3WUX34F9rZ8urWvgws2vw45GFy7Zw4Yqr10qwsayry7CrWDKF95
	AF97tw1SvrnFyjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUboAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s
	0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
	daVFxhVjvjDU0xZFpf9x07UGYL9UUUUU=
X-CM-SenderInfo: 51dqw5xlqjzxhdqjqx5xdzvxpfor3voofrz/

From: Yang Yingliang <yangyingliang@huawei.com>

Add clk_disable_unprepare() in the error path in stm32_rng_init().

Fixes: 6b85a7e141cb ("hwrng: stm32 - implement STM32MP13x support")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/char/hw_random/stm32-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 41e1dbea5d2e..efd6edcd7066 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -325,6 +325,7 @@ static int stm32_rng_init(struct hwrng *rng)
 							(!(reg & RNG_CR_CONDRST)),
 							10, 50000);
 		if (err) {
+			clk_disable_unprepare(priv->clk);
 			dev_err((struct device *)priv->rng.priv,
 				"%s: timeout %x!\n", __func__, reg);
 			return -EINVAL;
-- 
2.25.1

