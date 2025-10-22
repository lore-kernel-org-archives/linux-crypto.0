Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F262344024
	for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 12:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761136612; cv=none; b=aTAuE3vKC0l7Q6jSQfw+SwY81874ujYM/nXTbrWEy1OJRruzU0mOKaZbfsFLdjMgHWGd5EG3rZ2u1kF3s3FQGeE2TRXfoUDdzg/xvcYCrEVEaSem4qIfgtNFhU6mlmeLdyVDCzLsS9VwWggjRnIY4ozFqW7KdUocteHWCeSyqgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761136612; c=relaxed/simple;
	bh=G6/4RV+/hyEImD5Tjx7E3DcexAe5ffRKGf9PUm2hzkc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TwloUjIHnmZYOVXW9OtaKu6/is8Ix0pBMxsZoyvCdanTfoboE8DUjySTbDQDJtQBgiKNioSuRQe03HWX9lpMQrgomPCD1X+3ceSdrhAno3TE/aeo8kdspGqv5ePBk3RYQUM++jVviCungpN2oR1poMrKpjG3K0xGKYbiLhe5meI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wghXhO4Y; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wghXhO4Y"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761136598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tpFUwbpm7eC7NH+fV3rtn/zOowNizHjNm0vznqUq8k4=;
	b=wghXhO4YXwSNLlDCbffYanV3ZiR+drLtyTrMd/PkNWWvsZUF6RYtRqISyK29M5P3s5tLJY
	Ur854kMJ9PkWCQkZ+j/LELgfaGM573/TfssaLaIGFFKLOwVgsvbOLYV46zHZQTyvbfAx8W
	g8mlpp384LfIkJNlrIkUkkUx9WRXhus=
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
Subject: [PATCH] crypto: qat - use strscpy_pad to simplify buffer initialization
Date: Wed, 22 Oct 2025 14:36:19 +0200
Message-ID: <20251022123622.349544-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use strscpy_pad() to copy the string and zero-pad the destination buffer
in a single step instead of zero-initializing the buffer first and then
immediately overwriting it using strscpy().

Replace the magic number 16 with sizeof(buf) and remove the redundant
parentheses around kstrtoul() while we're at it.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/intel/qat/qat_common/qat_uclo.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index 18c3e4416dc5..41a7bd434e97 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -200,18 +200,18 @@ qat_uclo_cleanup_batch_init_list(struct icp_qat_fw_loader_handle *handle,
 
 static int qat_uclo_parse_num(char *str, unsigned int *num)
 {
-	char buf[16] = {0};
+	char buf[16] = {};
 	unsigned long ae = 0;
 	int i;
 
-	strscpy(buf, str, sizeof(buf));
-	for (i = 0; i < 16; i++) {
+	strscpy_pad(buf, str);
+	for (i = 0; i < sizeof(buf); i++) {
 		if (!isdigit(buf[i])) {
 			buf[i] = '\0';
 			break;
 		}
 	}
-	if ((kstrtoul(buf, 10, &ae)))
+	if (kstrtoul(buf, 10, &ae))
 		return -EFAULT;
 
 	*num = (unsigned int)ae;
-- 
2.51.0

