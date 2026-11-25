Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.204.27.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795592797;
	b=ecZytww3J7RNwRgz2P129bH15w7QqQSNpLS4ot6YjhexR5k2+l7S/WYLOjuaAxhRc0tk
	 yEl1w4gDw1Krup3X7R5XhEuTq8OM0/jvcfBsvZYMf3MaCr6paunDetWUg/xHTV+C7QyVD
	 5nwKqs7OqSceK/4PKCwC1LkDb5QYGadOG//zlDzEIvnHfUNXTh/B3l0dxQCGUhA9RgK26
	 U3B0q3+fRFlr3awl6Am3zRB51yo/wRSxZRVmOdhVlDnADlxbEuBayWggyzuq1AsuE/yTN
	 CPaavHmup7Rcrrj5JF+m2rdFCUpfUdSI+tqWh2yK9AiCihzr1VvFSg8beNpyShCwmPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795592797;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=Wx0h1nBOXx4sW1r+X0XANCpCblYPA2/J5R5tWzDhX30=;
	b=Qj80ldQpac+FQ9zbl6goGXhRkIQhEtHk1RH+BidHM4UkSuNUhP+QRYg/YrgXsv9Ubume
	 LA1+2rHmQDxO8b6ULSndRDnVU0DCgGNM+o66D4Vfmf9+Ojf6QNkQQDs3ITITXsxtmmAWE
	 z4OJFCM0f9JjxRCRvkwJy1MCfpSAsX4LDjqUIqfCrBhUwcCnO4a+gagFhLPGwi/KGlGNh
	 tPBpb7pwokdf6wPkapY6blFHOhiZ3W+UYhPPrWsuPLIADdE4M8+IgqWfcMjMIp1PMiTIW
	 0R1bfbTSsBB308J5sopMxWChr3QocDnKdPnbSUlgNgX3Xc2WtUERQEywLOr/V8WsyvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hygon.cn;
	spf=pass smtp.mailfrom=hygon.cn;
	arc=none smtp.remote-ip=101.204.27.37
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289D860A2601;
	Wed, 25 Nov 2026 07:46:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 289D860A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZg6F6ZzVcBC;
	Wed, 25 Nov 2026 15:46:35 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZd0FQ5zVcB9;
	Wed, 25 Nov 2026 15:46:33 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id 73750300B6F1;
	Wed, 25 Nov 2026 15:45:20 +0800 (CST)
Received: from hygon.hygon.cn (172.25.24.133) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Nov
 2026 15:46:32 +0800
From: Depei Yang <yangdepei@hygon.cn>
To: <linux-crypto@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Gary
 R Hook <gary.hook@amd.com>, <linux-kernel@vger.kernel.org>, Depei Yang
	<yangdepei@hygon.cn>, Shan Chen <chenshan@hygon.cn>, Yongwei Xu
	<xuyongwei@hygon.cn>, Xiaochen Shen <shenxiaochen@hygon.cn>
Subject: [PATCH 04/11] crypto: ccp - register algorithms only for supported engines
Date: Wed, 25 Nov 2026 15:46:02 +0800
Message-ID: <a028ea9846832629bcf3d1ed79605cdfc8106dd1.1795588986.git.yangdepei@hygon.cn>
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

ccp_register_algs() registers every algorithm family the driver knows
about.  A device that does not implement the matching engine still gets
the algorithms advertised, and requests for them end up on a queue that
cannot execute them.

Gate each family on the engine it is built on, using the capability
information from probe time.  The AMD v5 variants advertise all of their
engines and keep the current set of algorithms; the v3 CCP does not
implement DES3 and no longer advertises des3.

Reviewed-by: Shan Chen <chenshan@hygon.cn>
Tested-by: Yongwei Xu <xuyongwei@hygon.cn>
Signed-off-by: Depei Yang <yangdepei@hygon.cn>
---
 drivers/crypto/ccp/ccp-crypto-main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 698e39ab107f..388ecb1694e5 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -325,7 +325,7 @@ static int ccp_register_algs(void)
 {
 	int ret;
 
-	if (!aes_disable) {
+	if (!aes_disable && ccp_has_cap(CCP_CAPS_AES)) {
 		ret = ccp_register_aes_algs(&skcipher_algs);
 		if (ret)
 			return ret;
@@ -334,28 +334,30 @@ static int ccp_register_algs(void)
 		if (ret)
 			return ret;
 
-		ret = ccp_register_aes_xts_algs(&skcipher_algs);
+		ret = ccp_register_aes_aeads(&aead_algs);
 		if (ret)
 			return ret;
+	}
 
-		ret = ccp_register_aes_aeads(&aead_algs);
+	if (!aes_disable && ccp_has_cap(CCP_CAPS_AES_XTS)) {
+		ret = ccp_register_aes_xts_algs(&skcipher_algs);
 		if (ret)
 			return ret;
 	}
 
-	if (!des3_disable) {
+	if (!des3_disable && ccp_has_cap(CCP_CAPS_DES3)) {
 		ret = ccp_register_des3_algs(&skcipher_algs);
 		if (ret)
 			return ret;
 	}
 
-	if (!sha_disable) {
+	if (!sha_disable && ccp_has_cap(CCP_CAPS_SHA)) {
 		ret = ccp_register_sha_algs(&hash_algs);
 		if (ret)
 			return ret;
 	}
 
-	if (!rsa_disable) {
+	if (!rsa_disable && ccp_has_cap(CCP_CAPS_RSA)) {
 		ret = ccp_register_rsa_algs(&akcipher_algs);
 		if (ret)
 			return ret;
-- 
2.34.1


