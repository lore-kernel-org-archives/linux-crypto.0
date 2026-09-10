Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F86D48F84F
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045306; cv=none; b=RpShZj9/m/rpbUGo71jDOORYFblY9BVE/opeQ1ncADs949DV4Y6oCwpjV49kn8MGhovmbA4y/h2b6YX4oCLAXho67r2ZSSlB9PM8b0ZNbisLIAaTZkcfydok5M/n33+dTxQz/M2xv/l4LuVpcsVk7K92gT3ZtzpPN+tQFKa/Z4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045306; c=relaxed/simple;
	bh=tX3TRtZACxaWj28Vd3tV97Cdc6/vFpH99oExqmgwzeU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BOumdkyz0oqBWH547PPIlQKb2kscUlgriPB3b68kBHTz68af+9qfIo2BfAEz2QYJBsydw97mo9U3+PhLbCsC4qnBmtYHZ2e0QZIJlZzXSSfqsRQ/0wpxuOP6dVOXx7h5jgdBJjNrZ9h+HldetgQkdMm/AfpL8PHEFoa7Qrnm/sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=izw17Hbe; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EXDwaqTh; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="izw17Hbe";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EXDwaqTh"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AC7ab12029176
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XpAwiJrGurnLU7swiLYwHwGFQJ26CvgKoaprZ+5NHTo=; b=izw17HbeX/LIWuew
	ez8d3p5bVpW5JjGeoho24IeygCL+WiVIb24PY244bZ3XluycwT9gvuCbxMro6Ftb
	cOCAQjkSuN1TNnnN06BfdKyOoCTZk2HhwuDGQFoc4yxwxe4qUWVmW2q0qwA6eR59
	u9R1UpN8jSYmqro9ZR/KUxMGJu1PLGt9F7Zxo0nO4lIE5kWH89aPSuYgesTuNMuP
	Q+XlONIW0ljrLQoej4/seVMYcwOW4KqE1d23jzScl+Iy+KojTQ2i2iRTE3BjM43R
	V8Gjm2Y+gnUNGQ0I8AttEKSuwtmTm6ky4z1yURTCmSllTYL2zM98J9pK65mBkdic
	yAFfSw==
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkcyhbvde-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:43 +0000 (GMT)
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-46f178d813bso7106359fac.3
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 06:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789045303; x=1789650103; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XpAwiJrGurnLU7swiLYwHwGFQJ26CvgKoaprZ+5NHTo=;
        b=EXDwaqThMcCG0NDYH1Gq/aMQOECUsd1q8QENLfhVvnrTVPl6/uupTGrlQiVRZctHCO
         /7KQxt6gX7Mg60QfkQxxu9IQ2tnvysc73KYM0v4/pYkNDGXLn3btqDaD0xoknIuy60r8
         nSOXIU2+FE+Ydi10z1K8JHArCwhE65BDgGuuuQ6eHD933LCcdofyxHGk1PHO+pppZwdZ
         JkWuSJJ2WeQGR+SVc8mpobxhUAY39EbDzSIb5807FH54PDwUl2UbqCw1U1Fgk/p9rw35
         mrtNRhWOhxOBfBZH4iU9YWbFv5klg6TpnWxO5oNbd0SuYtUMIDUowcWVDk6pkmd6DNsO
         f1pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789045303; x=1789650103;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XpAwiJrGurnLU7swiLYwHwGFQJ26CvgKoaprZ+5NHTo=;
        b=lhySMfoS9eib7clHJGXK5sYhoYKccVD68c4GTZ/13/juoQSnRfwWyqb7wHnbw7MCoF
         aeN6GNZdGLf/ohZSyAAYu967e9XOP2IKPSUl6C5svWZag7jFapoDk03HfxJFFwMZ9x9q
         87vnDf8Eap34PSVJIpcAA6rscYoijfESOjHKUXRJCdBzJz5mD3G5Z7fVZJL6ovVLEvws
         tU31aRyPVBbPPJ04wjp6jBd0xXIoIZtZNas0bbU0hCfrTiorD/0AeQAR5cA4WSM+suIo
         ivUuRLWhlmuFDmxAcdUw8cmeE25+Z0dUqPfIM5JU+/e+ofsVKu80nUQLtxcDCGhqcYeH
         f6WA==
X-Gm-Message-State: AFuF++krkkAcYMA0uJYwBifYSsHzy2EfyO39z4lNwO6LPBKy/plC4Tu4
	MgQnFG9vY1GjSROwvcmUb8jF6AqkJ/Z/8Hq05XXSWlNjjLtanN5fdOkt8JfThS9Ain1iW3ZUzsd
	73vbLo+XRUXzWNYHxfAjhHmBpSufk6MVN8XbDYy5EMglWmOjfk6om74KnVdcX/ddXVHI=
X-Gm-Gg: AYBFou0J/OnLbxfh9M72rXUwNa6VBlG/PZ/vc8L2Xj4/FA5EtellhgAdUfjpIoyA0Gc
	yY+8G/DNVOq7I4yc2+jtOW1YyRUylVSeC1bOS5XKydCM7gOoz3A1mPB0P9GMwP+D7HJld0zdgyx
	6kuSLOgmg2YE7Eiu2qSPIY0gD5YTgsJdxUYo6WD6aGhEECuxhbitv7cnzxbVsoId/s5CSD4p1lU
	8mw7rb0jLhgVQt4sLnp+g7xfusN2jEvVX/1BvUlcKosD046GctPMOtcrA6wEJt3/tU+xQ9WdnTs
	uYv9jyW5AhiHcdcvqjr6sJvAT1sx+EygwSd+O/NXWuxiJc3e/JNL7Loyncqft9uuDKBLfEwSSwk
	EcBUzUz49giDjI3kjSgFBDQgYbljz
X-Received: by 2002:a05:6122:490e:b0:5c2:c0b2:9880 with SMTP id 71dfb90a1353d-5c7ed478a49mr26857260e0c.1.1789045290908;
        Thu, 10 Sep 2026 06:01:30 -0700 (PDT)
X-Received: by 2002:a05:6122:490e:b0:5c2:c0b2:9880 with SMTP id 71dfb90a1353d-5c7ed478a49mr26853962e0c.1.1789045282599;
        Thu, 10 Sep 2026 06:01:22 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c9b1:abfb:f300:5e98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c26204ecdbcsm831849866b.25.2026.09.10.06.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:01:21 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 15:00:45 +0200
Subject: [PATCH v7 04/12] crypto: qce - Use a fallback for AES-CTR with a
 partial final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-qce-fix-self-tests-v7-4-cdbd2718af14@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1764;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=tX3TRtZACxaWj28Vd3tV97Cdc6/vFpH99oExqmgwzeU=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqoqoNxRtwkAolAz49O7BFo35y6dlM5H7PtpM0H
 UCYJgUd+ZiJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaqKqDQAKCRAFnS7L/zaE
 w7OEEACx2OmTFHwHBMdYiM46jjJfnDB8QinT0zeL5ug9AvvELNZNFb/PQiO/QznG/MI5WQVfmx5
 zDIqeM3GUL9j3yheB5Y42QGiG+U4+iYtcYOOiVblTvr36W24isO37L48/BdIW7w9nO+0APskpyC
 ziXVRFyihsQ6hXWsZjYaKd+y24MY4jJmYxUfqHlOfwBHOG7JVChF1jm5J1arqDZMDyC4kv4JrT9
 QpZ7y/tO8DUEwXhcbui02S1CtUlJx2St9ZQnTI0ljA4FVni47ykIzjqdj98mrcjYGVfO2az8xTS
 E+Ji/vBh9QpsD+p2UMxydfyzJeAso1S3pP4w8lW9tX+TrGEuD6yBetNzhtSkOf6Uvngezk8mvbX
 mnMO7k1TeLqWid1/jhPTIRS9TOmeByIF0QSKljIPVYeVnatomIXiaWpLmZKV3hNuOWqzooJdfM1
 9sTMlClLUH3D1sLAQmiQ1ttcejB9Ej6E9IuIzTerajRRBLeMemstXeY/iwryG1mae51GVWpK2zX
 jLWmuoCMnzgqQYd8e2NoaWMy9Tzg/Fnkw10uk4TwSxFPJqA31pc691ERTxSRHQ02bZUelr8aSiR
 7SASGDgPrdIxZTyF/CxH6ddAWvE2SPHAph1h1JNad2ibDsVWWAaNUud2fs+XqaqFCMkBrUOpngY
 iRdWRP9aAcmF+Sg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX68ftFct/gwl9
 /eNKDEdt/al3cBV3JHI3OznAbQ1nx2XXw6d3ZazdmzATVpr5nIlyP6fTnaNB76L2zXmykUdCTYP
 RVQf3ESDLSyLUz6tgte//4nUlCw3y4jSKTb/UbxCVnxq7cUfuaAlo/1UVx1Gd1ayxk1wrzKJlUq
 vxATYUEe6FC7rYwEpaaSVN6uT/QE6lGYlg0XH9I4mr0s+URi1lt1+odUHqq+fpO178FQeMgvZTk
 kjGPX0GopaFuPwvJh60bU9LCntWBZaKjn3AoZdrBJbDX/Yje3n+dC2nU/5jNLcaqxvXlQZ5mIM/
 VHvrg7kUDnCFjHIjqUdmNVfnOWqUjdYQ/rdapsvTBcMt8lg5eN0nDzRsJncLYoxAq9TpulBMBTw
 I13kcg1rDBm8LROJATFE9MQg28yhAvyMk7OdLsop01xckT8MaVY/9lHR3wk/0RbqkjPtqDFJmrm
 gPdzM/u+lZa1Z9XJgEQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX8xpr8iEhWp6R
 YbZVVaftnW7FOTRvlY0+NvlgZYtnh2tO1vsGjD6ayovdyRg6JlBOYXYcQmhAxHQxqiINUedPmwV
 rtQSAelewrtXOEZfDsSS75F9f5ZsrWs=
X-Authority-Analysis: v=2.4 cv=YKgKWhGx c=1 sm=1 tr=0 ts=6aa2aa37 cx=c_pps
 a=nSjmGuzVYOmhOUYzIAhsAg==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=vUpbTSJP45I4i0_vGVUA:9 a=QEXdDO2ut3YA:10
 a=1zu1i0D7hVQfj8NKfPKu:22
X-Proofpoint-ORIG-GUID: db2oQADUwuUBTmLIXBhUj48i7EXxhiDm
X-Proofpoint-GUID: db2oQADUwuUBTmLIXBhUj48i7EXxhiDm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_04,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 impostorscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100156

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

