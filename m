Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.206.34.216
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794552940;
	b=3XbI+/jbCX6iV3qZn0YtbkbhdRj6TjyACOrWvw8i88ZWJPCgEpv2+vcCAIVggDDbSTFz
	 JuWr4AWvI+KTbiTI219H54viYcHp6c2mT/Qrg5qeSYYiLQuBiIOOJAy8txVV+okY2Y45c
	 EY6DW9KvhZdzPev5PwPVgaIX+TvVlBB1PVSjcB9mz+1rr9geE1jQPjtN7uSovt7EGY6/l
	 F8i0J2JdTHYNOzA+ax3f0ddZrpw4HtjQhkripB7tXweoeyMEO0a3hY1+P+04PJIjh8fnk
	 8s/iZDz8rftKPxa3vRH54KYBoR6oTFHCyAR4taB3/D2vNMai/aS5jNbPLk1lHFauVwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794552940;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-QQ-SENDSIZE:
	 Feedback-ID:X-QQ-XMAILINFO:X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=tXg/NYzA6wpGGy3A4NvhniXPLbxTVNdswysAvZzo5Z4=;
	b=yuHtEU6f+qloaL6Op/qk9SxyA7kx5H5YFAqe4Tm5OENIcFvGYGLVwYwdgtLKohcgQNzi
	 5XcRMI6+tsqvopOt/qDBp4e6ksjvx/DjAXViIKsen6EFONk6od7cud6oNfVggXEAz/XXm
	 GDy/8C5jXGDakNha6Lg5J/liw0pRRRjobMWayN6K3Y2Mz9fllncaO86a98kUEjajdgX/q
	 qIF7mMXUu4pIFn/hH9EmtPeLAem32HY7cBylJChTAPHJGk/nrctohr2YoyQohkG5ZUYQD
	 IKBDwiDmzcMfXJlh05KXYXNCF4BcjnqP9UNP7mhAXWHtZYbe/0XSZJ6Z+Ivf/ONQK/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b="Hpf/KKZP";
	arc=none smtp.remote-ip=54.206.34.216
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962EA60A261D;
	Fri, 13 Nov 2026 06:55:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 962EA60A261D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=Hpf/KKZP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1794552905;
	bh=tXg/NYzA6wpGGy3A4NvhniXPLbxTVNdswysAvZzo5Z4=;
	h=From:Date:Subject:MIME-Version:Message-Id:To;
	b=Hpf/KKZPZdyvDtjGh+PAO2hFksJEImUe+PLYtPc9+0NltJDhfgFPWMX8+U4G8g/VU
	 0hNqbiHgiA4XUZzaxYy5zQOHLxxFjPlV09w3sg/jeVMQpzGIthKJh345YjLgf7G+Pl
	 jNpTUcYDmjgpNM7xyVsXSLvkx7tHrn87m/3Gg6kA=
X-QQ-mid: zesmtpsz3t1794552889t8ee05ab2
X-QQ-Originating-IP: RZC34Zcv7fRyga4j1zSSOk9kC5A1eIj3+LONdI49HLA=
Received: from [10.10.7.69] ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 13 Nov 2026 14:54:47 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3908979481755977916
EX-QQ-RecipientCnt: 11
From: ZhaoJinming <zhaojinming@uniontech.com>
Date: Fri, 13 Nov 2026 14:54:21 +0800
Subject: [PATCH v2 3/7] crypto: qce - check dma_map_sg() result for the
 source scatterlist
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-fix-qce-ccm-adata-leak-v2-3-914501377a62@uniontech.com>
References: <20261113-fix-qce-ccm-adata-leak-v2-0-914501377a62@uniontech.com>
In-Reply-To: <20261113-fix-qce-ccm-adata-leak-v2-0-914501377a62@uniontech.com>
To: Bartosz Golaszewski <brgl@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Thara Gopinath <thara.gopinath@linaro.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, ZhaoJinming <zhaojinming@uniontech.com>, 
 Eric Biggers <ebiggers@kernel.org>, 
 Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: M6Wwv1ws7JqNTf77OgD240kaV1xDtSXZqSs+9xt/l0KCX4Uln+cLm+JO
	IIjs1vX3Wb1/3yt967ToWH4zKqFTe6p/cBBRUEw3dp3efhmzuP3lmOFcbEdFJRrJVxIFUMG
	Tjy39scPI1ioevekIjemCMfREl/QHVfvf4gZEbSqRbrzpTXmQTas++YadvxzEr1ut5JBBmH
	4EeE+yl6bLz09dD/fOAwAOJPxqbjyEfNrOXpo2++9dmi8NF0M/EgZ4X+FAxFDNDO5f/fq7D
	Qsmrmd1Av8j2c+ZD8SZ4nBvCR3ak5n/kEH5rsuiS/y27rsAzzRfe0s+CunqUBxflosilhCk
	Cihfj+j/EGKOap8ryDV3164qvIaWN7mVrsfLxB+Gpqo8Tgu+XnHgc2jyNxZ9VT1mR2IqPfs
	VCfoSwFTNsfVNuXB3+KtFFsVn/A7vzp+vsVTuWAGk6x1Yza2YituyU+jk4azZVGbLcNBphB
	u5UtBO7nX4WA6w2WSQdeWk5Ey2sx+fI+4PHzx3b57qBTnlVrM3giAPoUhqj8DL61iXh+RTf
	0xKPyxRwAjMTeTF4hDCk2gkluU7EjeXCT6LFu396dWVvWwnyCygqu8hHxZuZxAJJFohe02F
	hVRKdZEcRwgX1ell/+ChZjcXZCj1MM2GjYG8DG+Jhub5QKJ/31lDwqgr6MGbEumw4BHtpPV
	HUMA76Aq+3Os6qRTA+uxbcH8QlZw4w/SM13JPOXCTSS/WKBgzXYB6luLNN9b9OdlVWpIBik
	EvFbQ/RZDGN6XhftKuPBXzKROYVr+hjzsa1RJfHW3MfVxxNlcxEz5ICIplssHFJKibsuzC6
	N9XyVK6lyfDVOPUE1g5Jk0Koc7OFadFdEhM6CtsjEvunUjGwNp5m1MX9oX5gJ83y5H5IPEj
	hdmBVus/OdYTGH8OlwfySy2cR1Hj11m+TQkTGO9mPeOV5zGfg5hOUYH27N7q96J3Nv0150d
	OTUnw3ivrLO0ErqPzAwYzKFtdbaNqfCfXxbdwjbFD51kAzAv8MZtqwZiCz19Wn7k51fKj36
	40B/JF24mth6yKjOfXYgBZvWSiSnQPduTccpnwiNO/EUsEGbD16OVOxvu+tlIfkfXoRzSXv
	t221EJ2GeIMqfVp0CMHZJuJSTx874MmDQ==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

qce_aead_async_req_handle() maps the source scatterlist with
dma_map_sg(), which returns 0 on failure, but the result is checked
with:

	if (src_nents < 0) {
		ret = src_nents;
		goto error_unmap_dst;
	}

so a mapping failure is not detected.  The code then calls
qce_dma_prep_sgs() with zero source entries, which fails, and the error
path calls dma_unmap_sg() on a scatterlist that was never mapped.

Check for !src_nents instead and return -EIO, matching the check that is
already used for the destination scatterlist.  The error_unmap_dst path
skips the source unmap and only releases the destination mapping, which
is the one that was successfully created.

Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Reported-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/linux-crypto/20260723183438.GB93534@quark/
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---
 drivers/crypto/qce/aead.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 5bf59cb9ae9a..15ce778f019a 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -456,8 +456,8 @@ qce_aead_async_req_handle(struct crypto_async_request *async_req)
 
 	if (diff_dst) {
 		src_nents = dma_map_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src);
-		if (src_nents < 0) {
-			ret = src_nents;
+		if (!src_nents) {
+			ret = -EIO;
 			goto error_unmap_dst;
 		}
 	} else {

-- 
2.50.1

