Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA79149CF5A
	for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 12:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789995529; cv=none; b=L/n7hXrGAP5xSqguzAZ/CK9Z/S2RoY5NaZukck3e6GXwOQLy38EnMy3UN8nuNjgZZjP84yZ4a3Vf6Om7y3/pIG7QLOR9wQm2ex6jfe9i2M+UAvvq1YboJLYgF6FxF6ldYsTNPB4K48zR3MG8EYX5PMZiBljpSGLbNx9WC7FiVnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789995529; c=relaxed/simple;
	bh=tX3TRtZACxaWj28Vd3tV97Cdc6/vFpH99oExqmgwzeU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qCAWb421hqQUu0U4Ylgr9IMSA6gcSWAD8eC3q42eRMu96f6uLma1DUpKL8tGbzHpRkSmvHNGPTvzvVFR86b44AnKrWUfq5rUtKv2tC2R7mMpJwo+tfMpsYtyql9JRU3mMAomnzMJvtif6XRbLA5gt4BodS14YrFA5gETUrnH2nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XVEXkp5D; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UGRgRUUB; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XVEXkp5D";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UGRgRUUB"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAdiUg227709
	for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 12:58:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XpAwiJrGurnLU7swiLYwHwGFQJ26CvgKoaprZ+5NHTo=; b=XVEXkp5DAQtxNROD
	8TUtU71YXwpf5AycTK20Vnin9/bmIE1pFVdqOj6JCgTTLfymuAhL5Pzw+gvXXPfa
	6qBZwmjjnMS2s6SCrmbzOTnrTxuiKZ2FdszGwgydzis+PRbZNe95gzgKPBSueEp1
	LQW3i/XG65L5U3adB7WGsd8r7FBsDx9fnvnYqojixuaj/LUDGxa/WNJmwB8wWnXT
	PWWlKrNGr8MoI3ba9qTOMfR/Lwg/T2IEgENWgbmbe6qhAugJQaj5XOKOCvMWi5Zt
	T8STT/fy0abCjMBkoFRQ7ae5YgkkSQ1oJ32R190Np8rIFLL41qHUuFLLJmyJeoUO
	xKtKrg==
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com [209.85.222.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu17gs0py-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 12:58:47 +0000 (GMT)
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-97cc09260a3so3271408241.0
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 05:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789995526; x=1790600326; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XpAwiJrGurnLU7swiLYwHwGFQJ26CvgKoaprZ+5NHTo=;
        b=UGRgRUUB9+jStogZu2EfFRe991iBMg1vmQf/dqki3HRku8pilfq/muKc9PqeEvJH6p
         rg1JyTnPxf6+TdFxzDsqdFeHGE47WXb2NggO0lmt7MmW78PgE7vqFrF6HN++sDOcUtTK
         VU1YlVj0QKf32eyCohXk0Ja+mMtvm5rU4swczNZaJcgdVPStrC3EXAcPj4l8ketmhpeF
         F+JDPzP8FBpRfocARdzlTTUMZ1PwdR4QOfLbAGoq+gCWJqj3VQ5iKICm5+JFBjV3m8TG
         8pekeHXQdIfOvhAKvHQ+xTJ+j5mh/Wqey3llSMf3VFyQ5hY8M/gI9PnidmZrXvI0IRSQ
         qQzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789995526; x=1790600326;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XpAwiJrGurnLU7swiLYwHwGFQJ26CvgKoaprZ+5NHTo=;
        b=XadNFRfPJdrxFLYsmIAUGszNrGHmXksjQUNQzYwKMoaBH8HXTHlK7CVTGKhQ5ctEeS
         6W8bAdRYzVJ+AiGcc/ASMcyx3NLZgZY9CNYJk4nTtgf6pY3opWEmOtZAH86iVn6fo+HT
         NhLZ51btlo6xdbuj9TO+B603MGzM5I3M4EMhdVv0VV3nShOPOGlSxcXZ1aQ/U67gb8t0
         ie3gzzJvobTQ3QsF+ib7u2fEGH1icMu+8Q7b1Hv6lHGvWedOsqIs//XCUq1jxZCB3VNq
         mh5BJdQSqf5KvThjaDwrM3rTId+uTneh1j/hSOacXMQHyR2mBzMPdyvB81GE3mhpa/Qg
         JEwg==
X-Gm-Message-State: AFuF++nuG25MlH+2WzQ3JGCQEhfer4pORWqSzSdId4FAa+W0ib376xJH
	QmtTmwjxD9nT/w0xF1nTJXLlbAagklmk32iii43c3TO3QJz1Nz3z8qTvIw+iZxrhAf8LsF6hqbp
	HbNEOElzz1n1OiR9Ucj5vj4PsFVey/6SmS1jbAmmp9PT4OgW7rj3B/GnY3TaA4Vaky2k=
X-Gm-Gg: AYBFou0RujQwkPUwjkiHpCVMD8fr1mtmoGtqJe5JPwR/whQUYHPgsMGo/cY4vSZN8Fd
	zCgGAynCg78qDEDek3IuOptop/Sa3FMgWI0DHnpmVgqUXIR7JvkZFoS3LvCznf/PyHPdrPtM9FX
	BgsmYPcJ8tGylzGlCKcxg5uCFsvkbtS2cfZABTwjtmA4ukJDAFVgwNmkHXLSDbVb2v9CK1jbDC+
	DLp3xr2XAhsmcQDwh2IyweVSU4neMEmuX/iBTPi+GDQctMyN4rYADWEan19QKcClWqgxJ8t3bWg
	TDJf9JBa6YBpLQ+7hxpmdcRHsOhuYzwd+rXYD78zSzLcTOK+ctZrv3kZXIJkFL86OXfRE9XtgYc
	5XehkKRKoXBOZqPuZa9N+nciOCUg=
X-Received: by 2002:a67:f7d7:0:b0:7a2:7d1d:5014 with SMTP id ada2fe7eead31-7a4e1abc3c2mr2942544137.16.1789995526279;
        Mon, 21 Sep 2026 05:58:46 -0700 (PDT)
X-Received: by 2002:a67:f7d7:0:b0:7a2:7d1d:5014 with SMTP id ada2fe7eead31-7a4e1abc3c2mr2942535137.16.1789995525893;
        Mon, 21 Sep 2026 05:58:45 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:d04:d483:faad:1e4e])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a359037aasm320278766b.63.2026.09.21.05.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 05:58:44 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 21 Sep 2026 14:58:13 +0200
Subject: [PATCH v8 04/14] crypto: qce - Use a fallback for AES-CTR with a
 partial final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-qce-fix-self-tests-v8-4-107537869a72@oss.qualcomm.com>
References: <20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com>
In-Reply-To: <20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1764;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=tX3TRtZACxaWj28Vd3tV97Cdc6/vFpH99oExqmgwzeU=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqsSns+PyCyJuRQgL1Pq4op/UdD2lRhm347xN8M
 V4UnHO2zsuJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCarEp7AAKCRAFnS7L/zaE
 w3FDD/wNFoyQNr83Tn26infnX20bDnq0HWlj0p9hHRyFBsmTz/Vvqh9gZQPoBEBJgM/gpxyuUto
 Zzc2LTGEeKRGbUHDqZ33V0j8ztXUomYGXIuMc3poo9qY719BaNA/cvaEbO5N4Tfaicjf5NoMFNg
 CvvSdWL3Z2qW9vBwmWkq8S3AdncjKl1yDtAkP1UQ55PQuWC8juErb6ITmTlZpg7GX4FghRV7+E0
 cxtAQyuPeIV53SRAEnxI+zL/uL1A9N+6V0iuFBg+J4cSzHMRRUAW/WhL/n7nXgp923MSdjwsqmO
 AAoYOTVzifI+PCEEmTrqcSzZ3pKpKS7WZun0Mcb366pE3AHdyTSVnK0kbLrTPlY4x9gqcCjTUG2
 kEbRUB7M+DQa8JNM/GD2YAg1HKG+3LmsywBDfsNmN15jIN9zqQc9EjsEfa4YdEBCqfr2DLHk3b+
 5QirXJjWmr91SHvrhXgnzEPh6FXyoUHFW1ncogy6t+KJFPLFf4d04PcXcz7Z5IdcD1mWm/BPNjB
 BF9rqSi8bwLSO0/QNm3QGEZmdOAM2C3W4ml8d0dE/RXdWqD4VSiqTHJMBfru2rOm42wihsRsaEY
 HnyqnDnZ65h+u0G6/8yN+sRXFqYNiNNZ4sQzkJ7VJlUSxV5PkLdZ0Vy9FCe55iG6UyLqXm9U4nL
 +OefrVqr8uTL35Q==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: YWJbZeNIbvp4219RGcOWI4P03K3DrX9F
X-Authority-Analysis: v=2.4 cv=IewSymqa c=1 sm=1 tr=0 ts=6ab12a07 cx=c_pps
 a=KB4UBwrhAZV1kjiGHFQexw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=vUpbTSJP45I4i0_vGVUA:9 a=QEXdDO2ut3YA:10
 a=o1xkdb1NAhiiM49bd1HK:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4NyBTYWx0ZWRfX2FG0EwBcOy3H
 JsMvyqPKAMJvaGL8cXAnJHBobMQvodngCvlHUJbVNEe9JKOUxmYpMXPvj/6JzquuOR8IwzzF0Gy
 z2WC5rEGOiOgWUT7SaLV2HmCALOW2y1eonO4q2NBb9F8L3Yq7y1oP9mFmmAZYwZ2taZpv284Lxb
 2g9jBZG1uPrR63/i6/gjoYKKtxvtGDAeK/PN22+1uFRl47G0oOstQUimXkhKLpIprSYYoSHWB07
 EKCohqYN4agkM4hSq/aHXhcWVDxJKZEyMB623heS1FZ/tsoGWaYu5o2T64OhpM3WOuJJjo5qEOh
 OY18b9ea44maFKA9FWj6tKDM6KiNfar5Zm+zakYe1w4ppH0LQmht9HGDo1+CZK4NdxIHJ/3AbFd
 Bve3vJvuqxYtFV82tyO30JNrH843P7JMt14T+oYSHCHk1jdCUQpH9ZcRKsrsHjT+R9vejyHLggS
 IfydBq6ADrhcou/p5pw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4NyBTYWx0ZWRfX9to/JVwA8J54
 PFftzOEZ4jkf1DepdrO+CpjefV2oTtsYUzJBDjR1eI//H+YYNXJm0iGwqXIu/8hLur1Y7qoK2yv
 qS1iyfQholHUwc9GMHO/apu3W3WpA9A=
X-Proofpoint-ORIG-GUID: YWJbZeNIbvp4219RGcOWI4P03K3DrX9F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 malwarescore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609210187

ctr(aes) is registered with a block size of 1, so the crypto API hands
the driver requests whose length is not a multiple of the AES block
size. The crypto engine, however, stalls waiting for a full block of
input in that case, leaving the operation incomplete and failing the
request (and the crypto self-tests) with a hardware operation error.

Route AES-CTR requests with a partial final block to the software
fallback, which already handles the other cases the engine cannot.

Cc: stable@vger.kernel.org
Fixes: bb5c863b3d3c ("crypto: qce - fix ctr-aes-qce block, chunk sizes")
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 0a872beff4807e6e5af612e336630ea7a36e203e..e2ca2f7a6eea1129edb724fe30659d55aaae8190 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -259,9 +259,12 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	 * AES-XTS request with len > QCE_SECTOR_SIZE and
 	 * is not a multiple of it.(Revisit this condition to check if it is
 	 * needed in all versions of CE)
+	 * AES-CTR with a partial final block (the CE stalls waiting for a full
+	 * block of input).
 	 */
 	if (IS_AES(rctx->flags) &&
 	    ((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256) ||
+	    (IS_CTR(rctx->flags) && !IS_ALIGNED(req->cryptlen, AES_BLOCK_SIZE)) ||
 	    (IS_XTS(rctx->flags) && ((req->cryptlen <= aes_sw_max_len) ||
 	    (req->cryptlen > QCE_SECTOR_SIZE &&
 	    req->cryptlen % QCE_SECTOR_SIZE))))) {

-- 
2.47.3

