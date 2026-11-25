Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.204.27.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795592803;
	b=T7ARjNhalCFREUKrL5xa+gMILaAtrf1H9OxLe8tr1rMaqkDXKxCima4M4ZA44akS8knt
	 BPnA8Lz2CwwyzL9qn1UVPFCOWxTV3VrZhb0msrXI4FTL6MCR56urevqXdAY/kemVpRGDx
	 6pChHoLmCzKeQK1npsNs/KJedX1OxrA9z+fzPfYjfR79jNSjdg32YwQ/EGkqqlVOR2uPn
	 HY1BbmBrrQ9BXKlNFxgyFYx8R+MeRsgu5PU0pmxOTe28xNetsPOgS3ygClt10H4QENy7Z
	 H1/TG8DsJ+wXh5STvh7ndhacqHUa2lQJfI7tc9rB82TKCN6VbSU5sQYDHOU/uJnLGbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795592803;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=4EXkb1I+m0OAPH0zATFI2mzny5zMuT5ewvKE6y7UY8U=;
	b=JLF0X+UwzJ/csU6LRrjprmlTrV8CzPpk4Hi6jVT7Rt9uGSUJwfjYaTlBud19l9E1VIb4
	 T4qylEFkCj3KBWbMXK+k8dbTnHmshjGZ+vfh+fp95cBAwMg48iJcO4dM3zeN2V4Q3fbch
	 OV4BQlK6glbecYVGbqFIowV8Y/aO+wBXbU5vqVM4faY5rn4SEHNcBW71+voAdJUSeImoy
	 TIhInAhCC/9ar70VXAL9kx1r6lOd/PWQ7uc6qAODrxd1R9PnpW1OpgKKHrVJJ8lEMAn7Q
	 ypsG8IXbSufLTvF4K1tLErNeWk8DnJ4XHiO359eIVhgb+12mfCrNFcD1v5pRT19PF9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hygon.cn;
	spf=pass smtp.mailfrom=hygon.cn;
	arc=none smtp.remote-ip=101.204.27.37
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E96E60A2616;
	Wed, 25 Nov 2026 07:46:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E96E60A2616
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZn6FHwzVcB9;
	Wed, 25 Nov 2026 15:46:41 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZl1HYXzVcBL;
	Wed, 25 Nov 2026 15:46:39 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 975A1300B6F1;
	Wed, 25 Nov 2026 15:45:26 +0800 (CST)
Received: from hygon.hygon.cn (172.25.24.133) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Nov
 2026 15:46:38 +0800
From: Depei Yang <yangdepei@hygon.cn>
To: <linux-crypto@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Gary
 R Hook <gary.hook@amd.com>, <linux-kernel@vger.kernel.org>, Depei Yang
	<yangdepei@hygon.cn>, Shan Chen <chenshan@hygon.cn>, Yongwei Xu
	<xuyongwei@hygon.cn>, Xiaochen Shen <shenxiaochen@hygon.cn>,
	<stable@vger.kernel.org>
Subject: [PATCH 08/11] crypto: ccp - handle only supported interrupts in v5 irq bh
Date: Wed, 25 Nov 2026 15:46:06 +0800
Message-ID: <4b3f4601c9fa26cd527e47f55375fef6a19dc841.1795588986.git.yangdepei@hygon.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1795588986.git.yangdepei@hygon.cn>
References: <cover.1795588986.git.yangdepei@hygon.cn>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)

The Hygon CCP reports INT_EMPTY_QUEUE in the interrupt status register,
which SUPPORTED_INTERRUPTS does not include.  Treating it as a
completion makes the command queue thread observe a spurious
completion.  Only process the bits that the driver enables.

AMD hardware has not been observed to report this bit; for the status
values it produces the new check is a no-op.

Fixes: 6263b51eb319 ("crypto: ccp - Change ISR handler method for a v5 CCP")
Cc: stable@vger.kernel.org
Reviewed-by: Shan Chen <chenshan@hygon.cn>
Tested-by: Yongwei Xu <xuyongwei@hygon.cn>
Signed-off-by: Depei Yang <yangdepei@hygon.cn>
---
 drivers/crypto/ccp/ccp-dev-v5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 34832b830785..d2586625700b 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -792,7 +792,7 @@ static void ccp5_irq_bh(unsigned long data)
 
 		status = ioread32(cmd_q->reg_interrupt_status);
 
-		if (status) {
+		if (status & SUPPORTED_INTERRUPTS) {
 			cmd_q->int_status = status;
 			cmd_q->q_status = ioread32(cmd_q->reg_status);
 			cmd_q->q_int_status = ioread32(cmd_q->reg_int_status);
-- 
2.34.1


