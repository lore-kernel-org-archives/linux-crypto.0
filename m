Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49C7489FB6
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045298; cv=none; b=R5vMDlc6bhtEVkSFh8IzP9GnzViM1qxjF1Al1IXB+rNxAdUMvumeSLLD8/nPt8UaFAJaHxjYezdq64rH8bkdGWr1bMdCXmwjKLpv7adzDW0SvQfDCTn9kXuT6WX8LSd60KdRGj0Su2+LonxzfNqxK0WjiiC4zhIT92+uv6t9Cw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045298; c=relaxed/simple;
	bh=eJoYIGrknQwfb1zrIzM2gHnxaMtp5z2Pvd8SEbnN70U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZJGmr7CXwuWPZqtkv+Smr2ksnJ8QXZdJ4U+0hMBwZFB21m0msuoCJC1NcyaATXzeueWdnfeBJwKc/doZlmmqcEIHkK99+LY6K2KOSGtY2PtM68jGwSmjxx6kUnuPOAZeQJf54FfO7XItRgtl7uC1se548kIjUce7/Lcj39Excxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FOr3Iuv9; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Mhe7x85J; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FOr3Iuv9";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Mhe7x85J"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AC7iBn780796
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	04OudQ7RvWkd5HBxT2dEnlvpOGA7uiwqEFqHf0RkyOQ=; b=FOr3Iuv93pP2rlA9
	WFjcmgajEDkSzsOHkPMLUj65QWvXII/2NglCyCKuti664aXwFRLGqMuqGpaGuVXu
	MeSIBwN2si2QqiRat4oTTTQNOjc6h5a9qW94nLbwPQid7nCCmosjNS9ZnCGkDLp0
	Dt7RMCCwlSsCL5DIQqmAMu6QasaFfP0gKM8IXcFDo+nymmFU2dGp1XXZem8Sh/DY
	EP6znhbMk4NcucSDuk3bV4A7ZNVTm1DuKUXDFpW7bvVDe59CMAj1MZqwcoqG8ZFJ
	MSBgrBrtbYG/HuaLA4piw05g8u8rBHt1BM+BPG+cVu+on54SWfXGjO2lRoOshC05
	YEVdOg==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkrak972w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:33 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5c7a31f3af5so1654233e0c.2
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 06:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789045293; x=1789650093; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=04OudQ7RvWkd5HBxT2dEnlvpOGA7uiwqEFqHf0RkyOQ=;
        b=Mhe7x85JNHrpvdZEc6rR7XDEziCnQk789A0cQyZPN27WTf9XwGLJEDh9j1aUTWKQeS
         4eu3J98hKSLZIg4crY5y8WD3vCDvb3YxnNlkac9L+e/Nr365MxhO2CCuxitUI74TAfG1
         HUbX9vrm/Uh48ng2OFRkP3YG519rYF4ZigI6L7Sc8d7OED8ZEteJmc43fXQiFFN2s35y
         Im+K9fjf+xaQdXigKbcMvETOe/4kuo4UfLAUgiSStr9A9h0FKFcNvzIxv/BmUpuodP4r
         jO3P6sn/RdorrvdAU2pAisl3dhxApFXjx1IvkXmHbyXfk3sJTn0wb9mVYyTgYiTjTaZW
         WoWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789045293; x=1789650093;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=04OudQ7RvWkd5HBxT2dEnlvpOGA7uiwqEFqHf0RkyOQ=;
        b=clndPN9/Luixbcn7arwbuB3V82zSACNah1Tl8tqMOphN6+aCZyBuTVRgbv7KoeuHEN
         2csrzMkIgvckFcpS3tUap8b8d1zNWidgv8u5n+HPqX/S76Pm2ngRV/9Oq7fI8s3HFZSo
         kUbiG7eg3hJLu7PCx1cKe+kfOEtlN+p9fdDTDfH3FS7ZSpyxM4k3YNEX7yGBa/GqKLWw
         55e26EHgK2w2oBVrAd+Or/MJ6MAR2mUuyJec5XVGqBNJJPd9YlJXZaPitxBKLJSmTyWI
         661B5N9w49HT0s/3oB12mx+axzNn9fcmlyymRQG96dNeHq7d/wexXM880RiY3LG2PNGK
         fpuQ==
X-Gm-Message-State: AFuF++kGxxI3JD4Y0BdkqAdliMxmSKDzmz0tcWV902J34PmKFDlDAdl/
	gXYc7LA/uWu24jI4OU4TJlCGwT02ZIcTEH+VP+K+5EkYt8ei415SCiz7gSAWA4JkxvZI7xx5rFZ
	WaRmXL3S3yRc15H2M4V3BCUG35vlsrIeDtk73OGP170lkb4yc+CXXTvnLkrPHKBGaFd4=
X-Gm-Gg: AYBFou08QsJvKYmFrCr+KDjPiUNyHPYtj9iJySXe1OH0+rasmWeKNOicFNEk+NjhOy+
	yCKv8QjdDbbvhxzuaEU/mzB+poHEaC3TFg1/0zDfsIHsuNQL96ZmBGJWsH/AvOuzJ4duh6pc8dd
	gfVCvldBx95tuS47L4Ew/7IPJELZkxi0r1L9mxHP7bGzj0ABQTt7o1J9LjtYjZwlxDTrWMe0AxQ
	GPtM/2IVDxiItze71HZjDirZ43ZRgbl8uO3MvGZ2tXN/Gi2uxL5HrzNR2OcdWSnVPkH4pTwfqef
	rvJUdnEgQjDoTCbPVuxz9U9NBTjZGq+twWQlLIuKIO4CMQfHh8vwNIfJcb+B5epMVTWnzGEQIMo
	YoeKTgxAYgj2nk8RPocSiRi+YXVBL
X-Received: by 2002:a05:6122:1d46:b0:5bf:7f98:9657 with SMTP id 71dfb90a1353d-5c7ed479b6bmr22348668e0c.6.1789045286941;
        Thu, 10 Sep 2026 06:01:26 -0700 (PDT)
X-Received: by 2002:a05:6122:1d46:b0:5bf:7f98:9657 with SMTP id 71dfb90a1353d-5c7ed479b6bmr22346732e0c.6.1789045280252;
        Thu, 10 Sep 2026 06:01:20 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c9b1:abfb:f300:5e98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c26204ecdbcsm831849866b.25.2026.09.10.06.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:01:19 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 15:00:44 +0200
Subject: [PATCH v7 03/12] crypto: qce - Fix CTR-AES for partial block
 requests
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-qce-fix-self-tests-v7-3-cdbd2718af14@oss.qualcomm.com>
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
In-Reply-To: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3299;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=d7WlPHrXeW7G7LyENFi8sr5ULS/pgYG0asWNnZwa7dg=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqoqoLpLD2EF/ksiKP9l0t3wjTUdPHHRLF3zWsN
 DjQ0+7zQ7eJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaqKqCwAKCRAFnS7L/zaE
 w0bgD/90Nn3TDTUxe0jHt+bG1PXGCwc6ZEqxqciJ86kJozQxzzsEEvSetqsuFjXpNJsbiNk1VW7
 VaXFsqFNuG/ZKgbOpxklfUjXjohQD5gViTof1aCkQYoh16l/hD02i3X8xF28+So3nX1+yznf0P+
 +oS9EGNeprgaJ9/IMv+Wed/z99lITe/uYqBk71zqfRAel3yCOwmN9OjvhIrVOXsq9efo/zGCRJ6
 zSyOB9WEIHfLCjZseP0AHwmRxaqjdfpuEYX5D9msHlT1jwdgmwLYZek/F8P4g/GYADmu4KSIyLh
 yDEQdvZZYlQ6KM/NM0OzkhLvGaAnO0aPH0Ws7jmW+m6GYyQDlruEOzpDYg5NMWveAruNlN45Wrm
 JkKDkLhCLQKLvURnc109Xw8lcBv8tTrEsazybUvTQm+T4am/9Azu7zzxBSndm+G8N+Ic59LXhvd
 d+UnAc1fvd+bd1s3cxlUd9zBpYJQDB1omwMTOZ9XfRW08NN+PhQyyUB8m5Cnc1iOchrIAXRBZrv
 TuHs0fSUsoresRICz5ZY8mJGW0H45sLVjMBAaUjeKAXiM4t4CLhZjNflZd2vU7HxoksO2ZTXoi/
 eBfXbTjVRURbGaZKifPs5HwCYXsS7jtv7Xu/uXGx5assapGkhkiWeZ5ZCiyHZ9/IsdEjmlvr6qY
 xM3Pmrqq1K7yy6w==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX3vFu5UF2ifhW
 664eo6f1BbOlH350TmauD8aBkbaWGxoAFu2lijZ7lraB3KuuDbOT+OLBQ9VfdDSSkjr8bvJK3sW
 EuVtYjpbWf0Zk/aJETvpYXPOj4oJXRg=
X-Proofpoint-GUID: mMTKq6xS9zlNHpEr7tAZB4ylQovThvOS
X-Proofpoint-ORIG-GUID: mMTKq6xS9zlNHpEr7tAZB4ylQovThvOS
X-Authority-Analysis: v=2.4 cv=EspHPicA c=1 sm=1 tr=0 ts=6aa2aa2d cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=Y2NcAOke46LZopEJyX0A:9 a=QEXdDO2ut3YA:10
 a=hhpmQAJR8DioWGSBphRh:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX9FF8ecjGNjEz
 nvgew7vcBfCjh3UCyz5LpJqRJxqq9IF177TgEErvRo/cBPng7f8VnocI7xMfRbd4AjGUsiAZnp9
 V6izgnamKt8PcFF94CIazafWxz1lhqJsU7SgdseEY7Swm1iKmzIqvZu9Gk1uuDhoAfiu4XX1bvX
 z5Wr1ocxXz1lDbHsFph24P3jtO86iMaxlyDpoHaQBtiOj1+x6x3FnROJjov5e+accD1rJeXc+84
 FUsTwB44f4uUOmP6msSr7vhja8ucX7RfUVPzIAGOlfGdmUW/Q6q0Kj4/0pIFFPnfoC7XAUqBQTH
 uMhc+bSeSD2+epfeQo2P9fPA8m5Iav9cqa7XEDNbMLSAWzF6zMnnKtQ+ga1FYSU/Qt5s0dSxJOW
 HSqqEkyHP73/3R0ePi89I185pExJfg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_04,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100156

From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

In CTR mode, the IV acts as the initial counter block.
APer NIST SP 800-38A, after a CTR mode operation the next unused counter
value is:

IV_next = IV_in + ceil(cryptlen / AES_BLOCK_SIZE)

The skcipher requires req->iv to hold this updated counter on
completion, ensuring chained requests produce correct results.

Referring to Crypto6.0 documentation, Section 2.2.5 says:
"The count value increments automatically once per block of data (in
AES, a block is 16 bytes) based on the value in the
CRYPTO_ENCR_CNTR_MASK registers."

QCE increments internal counter register once per full 16-byte block(for
ctr-aes) is processed. In case of partial request length, the hardware
uses the current counter to generate keystreams but does not increment
the counter register afterwards. So the counter value written in
CRYPTO_ENCR_CNTRn_IVn later once read by software is one less than the
expected value.

Crypto selftest framework capture this scenario with test vector
4 comprising of a 499-byte payload (31 full blocks + 3 partial bytes).
Error:
[    5.606169] alg: skcipher: ctr-aes-qce encryption test failed (wrong output IV) on test vector 4, cfg="in-place (one sglist)"
[    5.606176] 00000000: e7 82 1d b8 53 11 ac 47 e2 7d 18 d6 71 0c a7 61
[    5.606192] alg: self-tests for ctr(aes) using ctr-aes-qce failed (rc=-22)
Expected iv_out: 0x62 (iv_in + 32)
Obtained iv_out: 0x61 (iv_in + 31, partial block not counted)

To fix this, just increase the counter value for partial block requests
by 1 and for the full block size requests, don't take any action as
expected value is already returned by the hardware.

Cc: stable@vger.kernel.org
Fixes: 3e806a12d10a ("crypto: qce - update the skcipher IV")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index b49c1aeb0d27d4798e3e3d0b30299f48ef8ae453..0a872beff4807e6e5af612e336630ea7a36e203e 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -33,6 +33,7 @@ static void qce_skcipher_done(void *data)
 	struct qce_device *qce = tmpl->qce;
 	struct qce_result_dump *result_buf = qce->dma.result_buf;
 	enum dma_data_direction dir_src, dir_dst;
+	unsigned int blocks;
 	u32 status;
 	int error;
 	bool diff_dst;
@@ -56,7 +57,21 @@ static void qce_skcipher_done(void *data)
 	if (error < 0)
 		dev_dbg(qce->dev, "skcipher operation error (%x)\n", status);
 
-	memcpy(rctx->iv, result_buf->encr_cntr_iv, rctx->ivsize);
+	if (IS_CTR(rctx->flags)) {
+		/*
+		 * QCE hardware does not increment the counter for a partial
+		 * final block. Increment it in software so that iv_out
+		 * reflects the correct next counter value expected by the CTR
+		 * mode.
+		 */
+		blocks = DIV_ROUND_UP(rctx->cryptlen, AES_BLOCK_SIZE);
+
+		while (blocks--)
+			crypto_inc(rctx->iv, rctx->ivsize);
+	} else {
+		memcpy(rctx->iv, result_buf->encr_cntr_iv, rctx->ivsize);
+	}
+
 	qce->async_req_done(tmpl->qce, error);
 }
 

-- 
2.47.3

