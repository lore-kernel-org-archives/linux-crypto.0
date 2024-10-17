Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506631D2F50;
	Thu, 17 Oct 2024 08:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729153818; cv=none; b=bhXexonB0bwlqU+GdN7FiVecL9Ugo9Y9V6fCwgmU4YW7npwP7Q3NN6zF+x0fis71nAAiDEY2SUDZhxavrDXi351LFoLwU7LWcBgu0c0VeonX1j0fKYo2ok04iioOco/ma4+PIAh5VY3/W1lkMpqZdv73dIILDPskITeMqrCR0vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729153818; c=relaxed/simple;
	bh=yJg2JVNB33Os0yyJl8xO8PgMosQlBHi77oLNAq6b4vo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SVYo+OXT+JwndMziBDRhqliKUwfzleGBLx6JZnwoCN585crKgaw5DQDXjDR67vapeTjnRPRGEgk7Dv5toKrSd+snZe3jcD+7iOLJ/stetcgdnIYdA1DYhzLXTrqvF9/XEH3d7hQiIpEYvaf88lqRgGeoq7zgNEd5kSrD41+w06w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=R5Q+V2+0; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="R5Q+V2+0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1729153811;
	bh=cSOXVSyYH+jeolxzM5y7BNDn9k3suxdDUAyCyBx02c0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=R5Q+V2+0rmlt3tXPa9Snpx5dPwxQUcV7W2ThOqtoZAzZmHXO7Lxo3aGrW/KbjiDYw
	 FFJJTM/Wr8wkTiJSo14lP41s4vHdAtY574+63h4HnQyUL6qcgi+jrTHurXzKQtLI/f
	 +ihnM1+9MamQ2dM3BB+Fs/krv1/H9lV3Bo43SLTs=
X-QQ-mid: bizesmtpsz12t1729153794tlvgso
X-QQ-Originating-IP: FSvmCbS+hbcFjhZ6H3PKpX84FlEWti0QDze5a2poY8U=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 17 Oct 2024 16:29:52 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10686107487593216358
From: WangYuli <wangyuli@uniontech.com>
To: giovanni.cabiddu@intel.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	jie.wang@intel.com,
	wangyuli@uniontech.com,
	dong.xie@intel.com
Cc: qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bo.cui@intel.com,
	bruce.w.allan@intel.com,
	karen.xiang@intel.com,
	pingchaox.yang@intel.com
Subject: [PATCH] crypto: qat - Fix typo "accelaration"
Date: Thu, 17 Oct 2024 16:29:46 +0800
Message-ID: <1D2B5A3330DAD82E+20241017082946.314361-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: NN74kCj3sZL0E+EZ0M2PIlLtWb1I+9zUHnmeieC+VIYbR5SQFpB1IJin
	dFercEK9OmKxIk+oDdNQ5vaI229hKvvEv+MokX9K8ZvH+Qpua2tQQHaekm4E7bGQ+PgcZM3
	vV8E6Arl0cVhhqATPA9p2yW6a3jM3l7XeJHBLXxSgWFiyNwfiENWSA8Ojkq/LcTkmQxMFWE
	ZwfcVW8MfGghCrK+8aB8c8vG4J2Bo4hqN8YCCNaycOAUPn0PLxPJdN2zJ9VFtLcy65E8CYa
	QKN6dxfFsXheSnY08Soy3x5i/4wK3jW1kRWN/mSbUFwqLhlufNXzhM0RLk5XFr4WAttISz1
	WNRan8IQg31m+SHx3otUL98xbu2n4M47lLtyhLKVxdFdFVEDyeuV62SpT59mAn/UublG+VK
	Ykb3iTW6FH00+idNWzP0+AgpETsbSOlPmj/TIaBOQUrr55JX6d988NIocX6gxSLP6xd+SYd
	OUfeaKaerQc9a9/o9/sP6TLk48K54lWBJEiDBJ4dRERr/v/sP7K/k7aVb11rZCdcNiuVnv0
	Y/F9jsHnBoC+FehUUtI3RtNYTJENriJMO8/WuIj1ErcrXNL2MW8O0S+Qz01IwPbYi4mcDfi
	iTzy8tSrQ5UyjsaD6aq3b8iTu4FDGusb+nEIwTHXr0qitiBeQaI3mo3pPj6eG6Gl7HRe4z7
	4rjzVQf42IoLPWdhX2Xirc1/BRRMUxegmiRnFoGT38JIEY13QSP0qL6FCBFS07WfiSOZXR/
	MJHixtDs7pFyeDeQmWFAkc4fMIeV5WI2xcOUWj5FxDXcMqHwksjJ/TfgJP3SA9w5wiEoHxV
	V1HHPS6ikshl/n0AC/znZ9GgUPjas3O+R6+lhxv3WYizCFdi6EmMFzfkppTxkg1aJlfq1jj
	LUZHTNLndLN6X5NxoysgYH3DiJfkrZ7RmLgViYqbDM/P6smr9MU6aGb6wRZ0IEaqZSK8y15
	9+cVZbUM55EWanovESNNg9wzSW8PVqYZlFsNThXmCDZeNXinRybaWGsa8m+sZSGGNE5U=
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

There is a spelling mistake of 'accelaration' in comments which
should be 'acceleration'.

Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 drivers/crypto/intel/qat/qat_common/qat_hal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_hal.c b/drivers/crypto/intel/qat/qat_common/qat_hal.c
index 317cafa9d11f..ef8a9cf74f0c 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_hal.c
@@ -163,7 +163,7 @@ int qat_hal_set_ae_ctx_mode(struct icp_qat_fw_loader_handle *handle,
 		return -EINVAL;
 	}
 
-	/* Sets the accelaration engine context mode to either four or eight */
+	/* Sets the acceleration engine context mode to either four or eight */
 	csr = qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES);
 	csr = IGNORE_W1C_MASK & csr;
 	new_csr = (mode == 4) ?
-- 
2.45.2

