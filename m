Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F8B146591;
	Mon, 13 May 2024 06:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.51.61.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715580611; cv=none; b=pUdQhAChr9sUTZaQDpqtETKvh062y7IyrDMLx4QsH2OXhf8CDYNWB9pNnPRpiDGVCE/1crQBPURV0QYnsU29RRlpii8pfCa7GoUAhydJ+9DhmHNAazOqZJa68HjJOo008tNVlc9zQk1ckegOjiNnuiT5ko7nwntQQv16g7v0wVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715580611; c=relaxed/simple;
	bh=dLmoVM5LjIUtOCQVrtPlJV6tpskv+4G4hNA3njRksCc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=B7wDs6foPQw4L+Wh75TVHetaEpOm2ABV3PyK8rFUrHuDGW4+OGcGJHg1dE3PXKYjHMGVIgWstRuWGkRSM5B2rnxBWxvp3xmXdxwo/dIOQlEZ5vyZzf4QHd1tlcVXOH9MVlONIvhhgSMZ6BimVztWFtF6HGhldCwOSOk8fHhm2Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com; spf=pass smtp.mailfrom=inspur.com; arc=none smtp.client-ip=210.51.61.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inspur.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inspur.com
Received: from ssh248.corpemail.net
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id JBV00044;
        Mon, 13 May 2024 14:08:44 +0800
Received: from localhost.localdomain (10.94.2.243) by
 jtjnmail201606.home.langchao.com (10.100.2.6) with Microsoft SMTP Server id
 15.1.2507.35; Mon, 13 May 2024 14:08:48 +0800
From: Deming Wang <wangdeming@inspur.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Deming
 Wang <wangdeming@inspur.com>
Subject: [PATCH] crypto: qat - Fix typo
Date: Mon, 13 May 2024 02:07:42 -0400
Message-ID: <20240513060742.2134-1-wangdeming@inspur.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
tUid: 2024513140844b7d92f4404dae2ddb7e9bbe2417031f4
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

The mapings should be replaced by mappings.

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
index f07b748795f7..96ddd1c419c4 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
@@ -59,7 +59,7 @@ static int adf_get_vf_real_id(u32 fake)
 }
 
 /**
- * adf_clean_vf_map() - Cleans VF id mapings
+ * adf_clean_vf_map() - Cleans VF id mappings
  * @vf: flag indicating whether mappings is cleaned
  *	for vfs only or for vfs and pfs
  *
-- 
2.31.1

