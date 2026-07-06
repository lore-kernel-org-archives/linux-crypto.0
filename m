Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C913534404A
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 13:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783346063; cv=none; b=AVN68JhCJythQ2lkaIu2P8jhrUk5qjRpiYxr10LA+rtIvX1UrnylLAC92dpp5ek458qprIW+W8K5SPr4gaaXBxS0JOO6PjxeCh3nx/iqlPCWSmuqB90w/onvboOKwvpmsXpBwrfcKty8ztzZXCwo7xcEp28hxT/VtW0C3ADbOFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783346063; c=relaxed/simple;
	bh=c+mrubN7rsfOnXUrhAmKfIPiEiFtp1qvBtE3BukFaZ8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eITXlyD8YZPd9I4Yg8EZ8AUxaRetydlPIwrqLlxFdJ5buPlvkhHzIEyRuBfVYlJ7Jjoq5KtM0H5VI+Q1E03auwe27NG4vlf3LwLIt1DhoYQ79Sk/B+lcCOhiQrC7iUzNI52eyS2MGA8mFH+T2aujEkaETjOSsWgDD7T6G3f4lBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OYA7Wmlb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Q+uDSmAm; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OYA7Wmlb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Q+uDSmAm"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666AxJc4316461
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2026 13:54:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	su379PS4fCpra/SUatLozY865KIfA6SXq4/i5am3Thg=; b=OYA7WmlbDBNbwl3C
	XaEFJmocHQ694G7n72aUBL4qIup/xgGy8y5Fr5Wa0fWtcXs/1fQtt14MY6NW4lMn
	B48zwHXLfI8bjk5h71/VCksFp8iQ7dlAS6oWTTaY9siPNPQNb2I+JvOvXDscjaMA
	s+7o3DaY0Oy91IcLXvlVvDM4yyPrGf98IjQHQRJjY4KAtAPrMoO2iTd2pq7465ax
	W2KQnIP0oOsGOG7hGy5E20hb7i6kZbx82RcpwihfybZfO8V/UX2nyuUtLsWMVuXr
	GSEIot5eaos+Z2WREZMBj99xqdsYcrejxdnDsJeTaPEDH4UZib7uncNRGW0PQVed
	TwLrtw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f87q7hjug-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 13:54:16 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e5e38fbc5so271759885a.2
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 06:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783346056; x=1783950856; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=su379PS4fCpra/SUatLozY865KIfA6SXq4/i5am3Thg=;
        b=Q+uDSmAm0WwRtcinG/Y+3oz3fuzs68fSXefDUMQyHPmDjCYhmmTIZfjHSElGfy1oLR
         YYHvvAK2+VF6mNYM9sbkMYh4ZINWUehOVKEoeymjtlriMoOxLJspgYEX4XMJJCrCRc8n
         cUlg9Bdu4RzQo+p1U4IkrQgWi/gkiu8eCzOfOLjshgXOfK6TczRc8C4cY7bhIfpTKe7I
         B5k5afF3erQZf1FcjjovJISmp2Cag2TeCbPQ5uFyj+HL9cBrAe5lHA9oZIziGQCGDwrj
         l2/qHzhvXrmhDc+MjjlfG1ziIIWKBGoPI1HVDLPMw0CiSpAv748F4KmEaq052kVUBAps
         NIjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783346056; x=1783950856;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=su379PS4fCpra/SUatLozY865KIfA6SXq4/i5am3Thg=;
        b=IlBMpLSHE+LbjDP+Qzbb1kzdUD0o2wZrAzjA2LeSmfGnOCuq9ug063+fWccaQBnfLM
         5KbVlclv3uMVNqM1kfWN55CKgZsVjMXEMn9eDreomA7Lgkq5uhox5Wof9+VlwajURFtj
         hPqQMtCHiu+NO2NeKNsMewlgl6B4yZtQfyS2REC7uUwaO3tJieb6DFCOLnS4vwq3STwk
         ysAkB/ZGb4qcCstZ+6QOFGEuFr1NviyBUx/5TaDi5SWM35SBgqIKdgvqdkwg8MQk2/dA
         3+5CJgy5MqXlkxW6BAIAIkCZS1z4gjLdQq8M6KiUR8icYPIfYu5Hz/PQ3Hwd76YnIBKh
         20nQ==
X-Gm-Message-State: AOJu0YwT0irSuyflcQWav7JGajR4HIYG3sBu/SxQV1GjdO9J8Z50QFGM
	I614QmVJwLs6lwmOw3HaQEZRVLcwARjuCRM8+N19qlBO0R8onBLqJppj3kKGt0kREWMwRSDODtp
	JukDXVaDYIGzpn4vYf2UGgOYfPnjgwd4SKPENSebcLanTX48O0pV06M8xFimmt9otudqc3R3SH+
	E=
X-Gm-Gg: AfdE7cmdpcLhgCdadpnLd0ZNfFYU2BSZUkg8+DWPsPqaZg4jGlNuTMBXjOlSbxfSUqr
	o5LUM2kvGARRsLhGCyE0qDZvMXdZl8w9gOSrE8z+pYrBT0buM63uIgJvEGFwUEb8GcHwYzhpZqC
	AL4nlficD9sXyNvLbabOiH/c11W/FFztGGcRiI3yw57fotpAiDtrAhScX8FeQ/8Ttmqw/ZYcQhQ
	qtEl9Fx7cTA/S4k+YwrCSgdI58nFSJQ06ji0lpVzrP5mnH9rFLWLG6QXnLm+dc1oWgWaRgz+pBo
	VWqJwUoP8/C6QDXyZw03vHid8s2qevNxPez7LO9VcVqrLizEAWqET9D0RW1YleWaNs2YQT/AeHs
	1drfLztlT7ICJ2NVgaGYnmya4AasgwiGnc6QF1/Qc
X-Received: by 2002:a05:620a:4455:b0:92d:e54e:72db with SMTP id af79cd13be357-92ebb4d19eemr95770785a.22.1783346055635;
        Mon, 06 Jul 2026 06:54:15 -0700 (PDT)
X-Received: by 2002:a05:620a:4455:b0:92d:e54e:72db with SMTP id af79cd13be357-92ebb4d19eemr95764685a.22.1783346054935;
        Mon, 06 Jul 2026 06:54:14 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:86f0:c42b:ef4c:d3bb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493c63ba971sm619805145e9.13.2026.07.06.06.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 06:54:14 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 06 Jul 2026 15:53:53 +0200
Subject: [PATCH v5 2/7] crypto: qce - Reject empty messages for AES-XTS
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-qce-fix-self-tests-v5-2-86f461ff1829@oss.qualcomm.com>
References: <20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com>
In-Reply-To: <20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1491;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=c+mrubN7rsfOnXUrhAmKfIPiEiFtp1qvBtE3BukFaZ8=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqS7N6rHrTH0qoOx88lr0IHWNw5QQwPYw0c0yqC
 7X1Mb+vX/SJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCakuzegAKCRAFnS7L/zaE
 w3wpD/0fg654bzdRNlPNalglNBxVXstbqQhps8NgcBVp11RCUk57hZp/GWG+Ka21RYhGTyHne01
 1lJvKEyBkiEbyvBCmpWC63KKSHrvkzroi/vFRg3s6Za8tO3TD7evfWPzgQbrR3UQuxMzF7KaF/g
 eLVS+drzJGtz9Y3lPRmgahTuBMHD3rz6VfUx5+FOUby6sWqIjAW0nx7oT3iirhgr/aTcRo+zWcF
 B4q4GcrmisGcXvnXA6O/Y9T4PEOnvk8h0aF15UmSIznKjaVHsDgQ0H5FXHkXxb6EmiM5yOy/1Fl
 XjPTQB/jzCR0fHt2/i+gB9pz1Ztz6ezBJGyh+Wlcc5qqFlNEPbpbgftaRCOyESmGCgPh6UEAwrI
 PICO3G4d6BfXm2ZPOQOaC5N4CtAB+hRv4eLXZ7kIdylC4SO9Ma5et/RnTysBZAZjwlSf4z/Qhyp
 NiGQff6c1ddLLtf2a9nWQ/yUNLvaHQdrZNur2RqntgOmL2QVJlvmCiiQph6WptpMeTzztL+dIbA
 985f9pdFTpb/O+AevGAoIm+jsmyK3Jwr/Xu6CTE7Gm+Q3XWu//sFs15Hcr4lEQC6pfbP35EHHZC
 CYc+oq8Y9eui8L38nDdJ+JgFFFaEihLSdTO+80PE77cDPXRHF7YSWGX7pl4cyqgfw/7nLkfoolm
 c8IRLwx2rkOcqMQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE0MSBTYWx0ZWRfX4zER4x0hbwWD
 oTjUKPJVunjWELrVU+lEPSjFvHNKeOYXkXiT29uTBVuF0EyYk4E9mu3I5hWPKO/7SCeSsiGQtw9
 6aqaK51IhhcDwLwe0kBvPmR5YhgT1WcmyStdqDKG3k6CiQX+wHS0Gv3BidupmJ/RR140O5qAPF8
 zL3AQDJECsp/irREEiWKrtsr2qux56K0GZvm/z8/mrk1enrzaXm4l/ZP/XLJLIbZpEbESUjoIRr
 8YjqJFFKSYXrNXDGUofe4INzNt92qctwkbbGDBzf7N7tYJsjghrw7+wIfY4yUrEAGGNWmeE86Pf
 0qwweWMx0FXqQlG3xAsmpK9seAQINLKe1U6QSZe15fcoFmuo4g6e7HHcCnQPQKaHayAb29VDiyz
 GsILYZLAUr8aqujLYd+ssq7JEswIQL5Ng7XOx0OtjBcbtrotMyGXGLZAKmiegze8XW/Q4/b3bDG
 JLyqggmeRAiBmc1rgRA==
X-Proofpoint-ORIG-GUID: 8hQzpE7LbFSoSER0SHK0xMldlpk9X8D1
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE0MSBTYWx0ZWRfX35bhBak9307F
 mnf25fIXy7aI4bOxf0B/lXiPrTReI63Rt1UNSEz6wOaPA8NKSySiqYgH3/w+Db15HJx//EJSLG6
 qiGDUIrRfcwrwIwIHObacLEXeCuA0sY=
X-Proofpoint-GUID: 8hQzpE7LbFSoSER0SHK0xMldlpk9X8D1
X-Authority-Analysis: v=2.4 cv=f9N4wuyM c=1 sm=1 tr=0 ts=6a4bb388 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=kiYxeA6Iecqc4QeK3QQA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607060141

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
index b27008ace93a8a40c291d564c3fb9d73df5447ec..e1f69057607fac36e8b4bdb5dd9e62a2aabe5f50 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -223,8 +223,12 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
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

