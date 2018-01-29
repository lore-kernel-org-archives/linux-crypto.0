From: Lionel Debieve <lionel.Debieve@st.com>
Subject: [PATCH 3/3] crypto: stm32/hash: rework padding length
Date: Mon, 29 Jan 2018 15:28:11 +0100
Message-ID: <20180129142811.13273-4-lionel.Debieve@st.com>
References: <20180129142811.13273-1-lionel.Debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        Lionel Debieve <lionel.debieve@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:46517 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751926AbeA2OaF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jan 2018 09:30:05 -0500
In-Reply-To: <20180129142811.13273-1-lionel.Debieve@st.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lionel Debieve <lionel.debieve@st.com>

Due to another patch, the dma fails when padding is
needed as the given length is not correct.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/crypto/stm32/stm32-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index d8444aeb6609..80b9ec76bbb5 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -626,7 +626,7 @@ static int stm32_hash_dma_send(struct stm32_hash_dev *hdev)
 			writesl(hdev->io_base + HASH_DIN, buffer,
 				DIV_ROUND_UP(ncp, sizeof(u32)));
 		}
-		stm32_hash_set_nblw(hdev, DIV_ROUND_UP(ncp, sizeof(u32)));
+		stm32_hash_set_nblw(hdev, ncp);
 		reg = stm32_hash_read(hdev, HASH_STR);
 		reg |= HASH_STR_DCAL;
 		stm32_hash_write(hdev, HASH_STR, reg);
-- 
2.15.1
