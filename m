Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CC13B27F6
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782134325; cv=none; b=NDsKXyU++HRrT2vgjXvR+xjhJEl78AHy/Hd5nI7dIIhAONnP2URzAL+74tRpDbcmvrKJRc+hyrrUS2GwcaVgjXkQE9u3pjfjfzl6uzFF88l/6oMqjLljkp97KMNw4tZHTknGEuo6+XEk0mRn8uF9+lVkgenpOb8cX/TK7LcHMrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782134325; c=relaxed/simple;
	bh=CYY45MSM4ZMotmXQHnMyBcMwgxFxp0g8DkA1Qgi2eCQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LpTt0WCcz4JDlKD1iqM2QGRMGkDuhCVK8cX1VFf/MWLl1C7t6hFx/w4tpMDz3tWgianRqTEeTJiDip/PRx4BhmRHTqqddvqKwY/IdIUSfrRzarLWP3hyeGYMZzLREOb6i1oygpL4MbG/l+gVs4FJDa63SFxdwNkamN/XpqZ9Pc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BeO0oHtM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OS4qUkRf; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BeO0oHtM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OS4qUkRf"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MDGCwL1261022
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:18:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	dh/jB5jnhJ+W/sIx1gynQvHO09FmmOdVkDRtzuKngL4=; b=BeO0oHtM9HzWUcv2
	fJV/C+vBkIfAEhSk9UHDYtRSXDgbvmX6JlDF7cRp8sBV+zRLyJXNmue1fKsCA1+A
	6vD/WdivrB9/56B8QgZ3xtqQq8u1EQy6l6vEkX9HklLK+0Pc2SXtf/5Fp3EQLJFe
	dNUl3vnplDo9NWEqoUwdwYVchSa+H3Rlh0/nbZrc3Aw7ijMxCvyE60eQTdmPZcjW
	ML9t4W7m240HTGkCqf9YxRvI4tj6FaqCb3GIdvSIz+F4nP9bkg6IAp2y2IQ5xWmw
	vLMcIl+lR4e5BL/HW4WDwjVuqhbqOlnSkA/n+DC9qw23hHlkgQqkrZgn39HuAEfp
	aa4ReA==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ey3eb8gut-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:18:42 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-726d05f883cso3056476137.1
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 06:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782134322; x=1782739122; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dh/jB5jnhJ+W/sIx1gynQvHO09FmmOdVkDRtzuKngL4=;
        b=OS4qUkRfEjDXtgNWrjDRBqyoama+hij8sk9xIDJBx9g3tHI1+f9POSddMWRl3aq1Ep
         R7GATF7loRO7XSEibkKbdvCP+XN2QKCsu7KHkNOlYAw4zT6Z3IpudUsUgz1gDIil6JLr
         7UyteJAnmUJ9iUI9A2JOPJOkDcQV1Sip/7XOIQ1KU4JzkQtxg1xAEfY1Ve5dDurrZhWW
         bPmGnT32wlc6/gevid4SJQGmPr3a1ovtJZQKTz8AUQC8QaSbF1xyx2bApQWny+Rht1Av
         y008dRXPD+4dsaJWuinmPfJcWTGPaN5ySPcdxOX70PIaLBneaTZVYrj/3LDkZLvm6UGe
         nmWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782134322; x=1782739122;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dh/jB5jnhJ+W/sIx1gynQvHO09FmmOdVkDRtzuKngL4=;
        b=qbtyXW5YK0O0vwNTuBJFwp2rwXvURl98xQDYQR5k1Jqf8CHdXP1h+kfzXGTUL6rWNh
         8Iq/dHt9z3AsaWvGaPRmWyR3wGj5hrLsqd2W8HSow9Yt1ZeydY42AuiE7L0leIL5HoGc
         zdZUa6dgjOuIfVW4oNRuWO3WEoDAXfKDrbHs4wqlIRXDe+e6cS7afLCzIQ876Zfhs2pA
         xjKQBTSi/76gQI5Y/5dVa1gF8BGcfKN62Beeb7epmrRzaaadNWxFNIzY7cI5z/VkAlq3
         hH5HF8zdctutkMQL8FivB6LQ55ufl2ZD4MxTULKXfl6Kan0nHE8v9NKzORUFkrFNCeTf
         jucQ==
X-Gm-Message-State: AOJu0YxuN8l3qBWwcYhlfMHPVnX8mGoXX8z6qnNKsbcV39fWOC/ul88b
	HTyWXzoWXEoqBAsLIaKFNf/XCcc/8/oBbZbHpQMtpgoOsPM3l129D/yxKKP0QSavtk5Pn/dea74
	89AITgkkfDWHKW/aiAiV5qmbwGkruh/HOCj5mchiNBc8Itvv86qkPjOdN9tZoaVmXlv4=
X-Gm-Gg: AfdE7ckaOJ8PPOGiszrJaoQ9UDor6lO54ly2fcd4n6krGCR/GG0pvLYNHOf3lQsu7mm
	YuZ+k8wvH8rlTLgKPXeBzQic4w6y7TfjXTTvfiBe02bAy3ayxPsa+24cOSessbiqat6AfoVScxO
	6kekJY8PavZ1pYeGpi7ghHIPuLFJuZ8MSGcsOwq1D6TK4dPJz9L/ubveCVsKjvUBsCgLJptXqcj
	WOV1kMIdEaEBM6ZqcfvO5CbWLVeSATsviHQDivMfUcFci5hrHTGmh6UjzSF2fHKipiH56pIIxB2
	wJSPVr45O8z5o8U2PmpFR8qgI/MfJfMzdspUm7shP9mijCd3SqaOYRQYIB0yJvfIkB6Mosx03Ap
	SzUtMPxt/PZwDuwZqZboOi/Bl4v1wuVbTYGUT02vY
X-Received: by 2002:a05:6102:3909:b0:639:3b08:d64c with SMTP id ada2fe7eead31-72b669d678amr5888850137.13.1782134322102;
        Mon, 22 Jun 2026 06:18:42 -0700 (PDT)
X-Received: by 2002:a05:6102:3909:b0:639:3b08:d64c with SMTP id ada2fe7eead31-72b669d678amr5888806137.13.1782134321657;
        Mon, 22 Jun 2026 06:18:41 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dea2:c31b:2872:1bd1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd30078sm294083835e9.7.2026.06.22.06.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 06:18:40 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 22 Jun 2026 15:18:13 +0200
Subject: [PATCH v4 5/8] crypto: qce - Use a fallback for AES-CTR with a
 partial final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260622-qce-fix-self-tests-v4-5-4f82ffa716c6@oss.qualcomm.com>
References: <20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com>
In-Reply-To: <20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1764;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=CYY45MSM4ZMotmXQHnMyBcMwgxFxp0g8DkA1Qgi2eCQ=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqOTYgjP53jjO6eSKEjKu2GG4WuSt/zm2Ko3Wvw
 z/1Zrys49+JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajk2IAAKCRAFnS7L/zaE
 w5g8D/43O9RZpr1iYy9qGRZeUp9oyuL2cZfMyc6EXCeBqaOzHxO80iCo9JZEOpCdhx+cYoH5cex
 YcmTjfbwunIUxyz9B6oFM9QxPtQyPqFBOisbaDNbbKWg6BlEP19m5LC7jDSu+tMTAi1bKm9vLyk
 NxAYxOBk4Vut/kZsJLVLuqsbSlnv5sRjk2Dx+l5Dbv7bd5IefDMYAOhsjLOCQaUHvKJ6wZn0HZc
 luc5RK85+W66F5pKTDq9P3LF4dud7zKBThFnJypACM+xlMSaoFMDduOM1WaxCW119mGQjEnWHS6
 nyLZ4Mi3yfLyL/57sxerC5yA8FWifxnayChw+Yz9Cz39rtILc2s0ZljMADtBgJfw0ksTFZh/QLP
 G2VULSK0SY6B/nUYAwKwVzSGLdqbt0I+To1ZDNjQH+LAAkBw2nMCHXbocPK+07tAaFfKcvmAa7i
 J23cJxMExAKpDzRWaZXu9Jqd/kVwLSxNRU4VmLeCRob5/e6l1836o/Yc7WQKbF+K7GbZtWr0AUb
 wO/HEfr5G01jAOCBs8hAdRydRokNpRcDOQ9bT5nPpwJF8WYlblSI3dnn+H4a0gwSuX/sQtM1P0w
 gjkC/Xk0pIip+/MzJ3+PdCwcpvmhEd7KcVYU5VnIdhz7wKpRNfU5eWbNCPm3hzasl4IlY4+mdIU
 BOIiZYYEqj+qT6A==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDEzMSBTYWx0ZWRfX6yb5MHZpkrYH
 gva/axV/Fy6ME0eTpDuaQYm5AQFq/zn2Ci0aXEPvUt+eGueTNAAfkVLKPM91HaCSeboqhYymugb
 iguQ/AbwdV0CFmcRoZc06N9r5fQjjpQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDEzMSBTYWx0ZWRfXzWJTVocUScly
 J1mXye3qkQIC0OKR9z6e+tC0GEXBnVFnrg6L6+0fMFjjv+e/B37xfX6dl9Tyoho6aHpIQlfjwzF
 SRdHRw5Q7nHGSqLx0mKXoHpPgrmKAjcpIB8DL2YaFRWQ2QuPnBn6QiF/yWRW0HudHN6r3eY3HEj
 jtxOdp3FawOTZhO0D1vYEjk7qBGeoD03q1B2vLkrgUpqWyM+2s3yu56wUgslJwrBPPNQPljXNH0
 UjzN/voFXu8H4hNtM7QKJ76t2mDk5XKdebm8uiHZdE0YXcpVFAdTXCmbIbOqDIGIurnc8GrnYK5
 O7Frkp4dge5cxiUtwrmm2zlL1SWyukCc5/CEXm6ckRffAe+pKw38kn0eYLF4eyDVkhl/8sgEJrG
 Tad4y4umxqqz6b0980gfFFXIkKeZkL5Gzzhzbawh4DX3ir+z/KlnFbmvDSN+0VqxL21MFkcFuaV
 eb/rmHNSLRnsjMUQbbA==
X-Authority-Analysis: v=2.4 cv=ILIyzAvG c=1 sm=1 tr=0 ts=6a393632 cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=vUpbTSJP45I4i0_vGVUA:9 a=QEXdDO2ut3YA:10
 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-GUID: DZpH8gcQ45sWcYrlvKspfB0kAts9Af0s
X-Proofpoint-ORIG-GUID: DZpH8gcQ45sWcYrlvKspfB0kAts9Af0s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_02,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606220131

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
index 35ddbe03cfcd75db7599a5754e4ff978f3528105..54ff013e24317cd4d7a0dcde88cef8268db784c9 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -260,9 +260,12 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
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

