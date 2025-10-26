Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C137120DD48
	for <linux-crypto@vger.kernel.org>; Sun, 26 Oct 2025 01:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761443876; cv=none; b=n3bNSJTbBEg97+hERROqlasIn4DL2eQaVUK28jL9Ecqc8pgR1G5YRgCeG1LZV2dw2ra2yAqY0fdEOO0poY8GV4A/jXrNWpazIsBM6g6Vr11RNcQSvNQiKn+KvBcpt5IZoUg69cIo5+4ZsXT6P1tGzGwhqVyvb9aLmatV/TXouqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761443876; c=relaxed/simple;
	bh=oPikvwt45BVYvYTWxBgaE9XM1ulsKhp78n5H8z0kqm8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CPKHk4dmkWCSdRrEDuP4Lxf138r3w+HQdcPRYH3tLAGv1fc7s4n5Y5dMg8EDI/TIHiI5Acw7v+PUb1u7rw0Ui5/Yri19l+r1VkgIrEeSBISYDYF3eI2u6bgzehY77bWYf22Nt4qaeJs6xeJu2xe3pnE40cXvEJEMVVpGv46Fm5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kG4OjdpU; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kG4OjdpU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761443861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NNgxyD0sVa6QuTrTPdQX4llkf4PVAjU/F33ptCCYNVk=;
	b=kG4OjdpU0+3I1DUsjRelaOu4+EkP8cPzC//YKkR9DZ2xL1QhSQLZymHhhacB7XaH8WWA/Q
	s1w7Jd6ad7jzZ8TQtHKaRCmKwl14M8WFzwuJFu8oH/MhAWgeLyzWtYxXqjMWhpSydOPEpY
	IiqZunVO0cpvDPfo+YgnBwmdbev//qw=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jack Xu <jack.xu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: qat - use simple_strtoull to improve qat_uclo_parse_num
Date: Sun, 26 Oct 2025 02:57:07 +0100
Message-ID: <20251026015710.1368-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace the manual string copying and parsing logic with a call to
simple_strtoull() to simplify and improve qat_uclo_parse_num().

Ensure that the parsed number does not exceed UINT_MAX, and add an
approximate upper-bound check (no more than 19 digits) to guard against
overflow.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Changes in v2:
- Use simple_strtoull(), return -EINVAL, and guard against overflow as
  suggested by Andy
- Link to v1: https://lore.kernel.org/lkml/20251022123622.349544-1-thorsten.blum@linux.dev/
---
 drivers/crypto/intel/qat/qat_common/qat_uclo.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index 18c3e4416dc5..06d49cb781ae 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -200,20 +200,12 @@ qat_uclo_cleanup_batch_init_list(struct icp_qat_fw_loader_handle *handle,
 
 static int qat_uclo_parse_num(char *str, unsigned int *num)
 {
-	char buf[16] = {0};
-	unsigned long ae = 0;
-	int i;
-
-	strscpy(buf, str, sizeof(buf));
-	for (i = 0; i < 16; i++) {
-		if (!isdigit(buf[i])) {
-			buf[i] = '\0';
-			break;
-		}
-	}
-	if ((kstrtoul(buf, 10, &ae)))
-		return -EFAULT;
+	unsigned long long ae;
+	char *end;
 
+	ae = simple_strtoull(str, &end, 10);
+	if (ae > UINT_MAX || str == end || (end - str) > 19)
+		return -EINVAL;
 	*num = (unsigned int)ae;
 	return 0;
 }
-- 
2.51.0

