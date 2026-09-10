Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1409248EC64
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045291; cv=none; b=JghD6zWJND9DPwdg/n2ltIBiittO5sFIs3+ziauvEv9w5bCZK1C/M8FdRqqFPaRaVNTwopVLe3YbDhmoQTNpoClvEaOJmi3+hp8CE+8bfpHHOZh5hgBBWpVt7g4rsm1+/2pcbcXJF8B17TZzRo1M9ahJU2A2LzLgeKuLQ5uoWvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045291; c=relaxed/simple;
	bh=fiubGOpznSBlWjS81EhUbY8+Jvg8mdIEbz8sZifJeJk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W95Pdu2bbFlDr1PrTNdhHHTxVMcyWtbTgN+lRisvBwz1kgRN1OIncTjZ1ErsWxPJaOdPzdQ+sN/znKdQ0ZhIb/ZXYA+qcc45ZTCt0/M3R98qTvJaTxAsjik8GXsBnwOmKhYc0XGer49d4M1Z7XDm8Y7y00HllWfNN5bfpncotAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HjDllPDm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EidaUVSH; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HjDllPDm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EidaUVSH"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AC7juZ1241998
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	skjmTwe/2/9vsGC6HLJTSQTIY2ObikwZKwuHsPTlEzE=; b=HjDllPDmBNjrJIYe
	PCoW0BPGw4s5pa5PUZRjEHfunhly70NromYsN6NVcF50TxSaDUgnVbBFVC/FlkDz
	RAD0qXM2FEKgshz+fwo9kd+z1aiI5TLWdYJoed7fth2bJRpUi1LNFYXs4TC+JIci
	TIXU7YVXvQqUeXULKbvcXCqkikS5tz5feAt9hfcpQu5P3lodTWYg+QYlDSJO3a3T
	REq073oR8EpdP5+4fK+gwFgpQoPF4Vczvsm3YWC96UburMReAVCDEa2fppED0IZ/
	EjaaThXAvDAtJ/r6C4wqGRlpEIyb/a6idBxqdv8E10LXkkadeWYJhobMAx/9zDAe
	BCQqQw==
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com [209.85.221.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkrcjs7db-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:28 +0000 (GMT)
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-5c7ab4af214so1930125e0c.1
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 06:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789045288; x=1789650088; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=skjmTwe/2/9vsGC6HLJTSQTIY2ObikwZKwuHsPTlEzE=;
        b=EidaUVSHS9y1f2+E50X29oqAJJF893ggvGWIe0fg8HFjwq/Q2EuC0JFVDekQvHva0+
         maqiIIYNbWB9GMIF/dg3jE8njMgdEUWzSGywde+0kF0jxO+Rjuhf5KLi9n329NQmTv6m
         jelsAUYXEgL55MpDKadLE/CzPXeGLQGZXfUpxwRRHsqMTzE3nR2WAg0YQ9sMcGHCyGJ4
         xrG4HNDRwf50TKC8A1d2p8tAGVGOkM+YHV9gkh3WYCCAsRfipD8iaFcvehBwETMcXWM8
         FvQbm6PoslXNdZ9J+WczWq8sydVlkNs4F6/B145D9D8q8b80qawu/1sKvt37iTPWqbv0
         lp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789045288; x=1789650088;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=skjmTwe/2/9vsGC6HLJTSQTIY2ObikwZKwuHsPTlEzE=;
        b=grlpT58yvDHIMvMwfVUvNG0aGXaT7/YDCG9Ik8UUECzGPEacdkuJyeQj2plSyzqa2n
         rdrjxwWkwS6chXrRhWjag7DoeTsLCtrJVjP5bozgvDfgHW8yGVnEjrehqBClcgc3SCEA
         Z59o8kNtBATK6bWX2OfsWKNKrjHHlBDUv3+FQNRjZdtparzj2TOASArb7Lzu6iCoHeUf
         yep21QE+jjWuJU2lOytEx6cK35/ZS9RM8qYnWZdJJ00N8DAfSpGDIa+eeOJPVT+N7SpX
         h0IhUTksTwCotP2/GSEKyaL96m3dkFsSAoeXVpcfydrtZdGdK8IKwjfGz8+aFgtuUt9O
         cB/g==
X-Gm-Message-State: AFuF++kasotRxqDSntp+plK956eluGAuZcXzTJsJfa5koSfEFZCFnaXj
	H6apJsxMsZXNpKccLTR3SL2o35tFhMVwSDxtxeE0cgJQgJySH/2tLyLsvTYMknapkrD+tdUkr1y
	HnvkAm7x35+KBvKl3sqR5PYrhen+dF4vQvxi72Gp3Zn6Q4zjwzixfnpe7T6FgVbhPv3k=
X-Gm-Gg: AYBFou3fhow7SIT2MQ6qKx0GNvf+5hHyr9+p7nvLQsUjdVDE4vfp/gn/XlJV8TTvHjy
	B1cf3xuIxwG4RKjfLp093aOgMpXRRI/VA76BCFAUcUsMtunzQjZzv1km9R5nuY7ECZdGC/zav9Q
	pLkgeBgYJMyyEr8kWgeL+zDM9YAyXyeHaYqyBF4wg16Sl/myM1EAGG/tg1lrHFuMdIrFDvfYIpn
	21ghIGYvD10UDolOB6gg5G8oOGZ8I+fLyOa/pbBq3PXH1bB1uG5bQyQCd9izLK8Dt/Onu3U/Swq
	NTAGhAYGAR/zqf+bEHgaEyo+p/+nedwRIyn6rNMuXz4pqVAg9kJ/X0k2j6yWpOLKhmF72IumvUE
	5OXujHO5Pj/VeJFmGbmXLtSMRhM2/
X-Received: by 2002:a05:6122:f18:b0:5c7:a814:b987 with SMTP id 71dfb90a1353d-5c7ed298f6cmr2449943e0c.2.1789045283324;
        Thu, 10 Sep 2026 06:01:23 -0700 (PDT)
X-Received: by 2002:a05:6122:f18:b0:5c7:a814:b987 with SMTP id 71dfb90a1353d-5c7ed298f6cmr2447218e0c.2.1789045275485;
        Thu, 10 Sep 2026 06:01:15 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c9b1:abfb:f300:5e98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c26204ecdbcsm831849866b.25.2026.09.10.06.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:01:14 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 15:00:43 +0200
Subject: [PATCH v7 02/12] crypto: qce - Reject empty messages for AES-XTS
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-qce-fix-self-tests-v7-2-cdbd2718af14@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1491;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=fiubGOpznSBlWjS81EhUbY8+Jvg8mdIEbz8sZifJeJk=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqoqoKcY6VeoV7uAaQfnvTc+CvguzwaEw7NG/Cu
 8SLkUH96GuJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaqKqCgAKCRAFnS7L/zaE
 w9+tD/4qzI8NshC9kwQ3NuRh/YcmU37MwUDDOclQjTz38ZU+o2+KCUP9p/TGSWazcK3zGYqD1+e
 +XnoG5b7OAvUhlgWmxZpCJHdm4rcxsX8BNpFbaF7Dw7VE2rgIoT3lF8FpwGv+XilOEb/doc4N+V
 VlwYDiwqFgsO/fW0Xu+Zve/BbPDA3amixlqiD1386ijpScbGs+mmJ9gsyeprV1RBS6XuGfzhLHP
 +EOLCUgRBgjW59Wr5A8hvNSN288iz2Xf/VRWvbI8tzqweRefG+qxbHA+bUjg+5atscpqQRf85d3
 jzAr8mIQ/6YZHglJJg1CmhYDZXHLQWYDmpFORVPdUyReWKLa+IoSEV7GmH5VWFOMasDzKdwzX9k
 ZLW7afyjyAMgtwGrHKoMR01nuC80rYzRmRyc/fivWDbiR0R5urhxfsBLoai/tluyhRp7vXAP7kZ
 7jnRr6Swty2XIkRdvQlBtWLKRW4QJ23ygkSPn+hzMFBD4r+Nm6DfFXzcz6CFwa0rRL/Z/BtLzrm
 PDxT1u6tq32+OiianYYqDeanLAu5qAsv0vCmHdiGvzAbHGF2CV2tAYCvE5Fdk7gUuvewEKu9J0e
 5nlWL7/Z7Av76DKee/jCxCEC7vqJasO6C9e5LQI/hHqPwQ+pKdXbAN3X0+7YcuBDXiVUlWci/Sk
 Rk00/MmhPKktKTQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX35ndKpB+rRyM
 TDawbqsZsTUveyNam2Vq08cSXRR7h47f+X/8eGmSoUrpC5SeNw7+sx5py/Rmhrrfdi4iK5hr8Cd
 jAC0leMg/JFKqaSI2vTBhVx8UPFyd9w=
X-Proofpoint-GUID: fmkRoUdWXQcway2QXgL0nwiNx6CS5NXb
X-Authority-Analysis: v=2.4 cv=aef0Dhot c=1 sm=1 tr=0 ts=6aa2aa28 cx=c_pps
 a=wuOIiItHwq1biOnFUQQHKA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=kiYxeA6Iecqc4QeK3QQA:9 a=QEXdDO2ut3YA:10
 a=XD7yVLdPMpWraOa8Un9W:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX0WN416AxNlKl
 gc29b21cey5W3ke6KrFbxi2Xs6kn1rcvlISjTktJxSK0eIlu5hhzCeMKKvVUrsIHUWhXVA2Yd6z
 Lr+E1J+vmMMrdQeCBd1Fk/sjypL6H0If/N4T2bV2x1VuBaskmlmN3LngRoWZhA8NdG8NU6BJGy9
 xDzxQLs4R0uiIBNHkpBZw1yMAuXGUXv7OlmqBZGxGjmkD0E6Om4K83mczQNCMLMcEv0ZkCuBDHp
 2lVzDuurEOSnh+5WUNWBS16M6xa9LHAKOREGavKB6bJtLdQyQB0lJABHlgVBtTHEjLgnqFxzZuA
 vTP2AdA+rFG8imtvLgwrc0XcvRAK1v7QfBEDMmnxTsusa9AaS/O7vow/MzyccCoHrFGJk6G1zV2
 NUgsLSHGqIcx+1svp6N+q8h9r8+8Cob35xiXW2k286ghVfRO5TwBhmGSjCVzjEJeyqMdiqDAldB
 fhyII3eBya6PafzZN5w==
X-Proofpoint-ORIG-GUID: fmkRoUdWXQcway2QXgL0nwiNx6CS5NXb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_04,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100156

XTS is not defined for an empty plaintext: it requires at least one full
block of data. The driver treated a zero-length request as a successful
no-op, so the crypto self-tests "unexpectedly succeeded" when -EINVAL
was expected.

Return -EINVAL for empty XTS requests while keeping the no-op behavior
for the other ciphers, which the crypto engine simply cannot process due
to its DMA not supporting zero-length transfers.

Cc: stable@vger.kernel.org
Fixes: f08789462255 ("crypto: qce - Return error for zero length messages")
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 84263ddbd62733f4d1ed42a2b94ae9f4d0d5c6df..b49c1aeb0d27d4798e3e3d0b30299f48ef8ae453 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -222,8 +222,12 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
 
 	/* CE does not handle 0 length messages */
-	if (!req->cryptlen)
+	if (!req->cryptlen) {
+		/* XTS requires at least one full block of data */
+		if (IS_XTS(rctx->flags))
+			return -EINVAL;
 		return 0;
+	}
 
 	/*
 	 * ECB and CBC algorithms require message lengths to be

-- 
2.47.3

