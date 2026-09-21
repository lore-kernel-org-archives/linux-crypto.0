Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E70B49BD76
	for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 12:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789995523; cv=none; b=t9PsZwn+08/M9c4q6Or9ofscPd+/vdsncaUOd8ZyczMW8DsnbVM8aO1ozrBge15nuhjydq3XVU/6iuVF5FC4vJEiSeySYJp2PnBI2JlCVb+YsM20bwSqEs3UHovLJgt8b2b8/7wevVAH9y8aC23VN0stSg7d9x0HlMXJlW4vfjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789995523; c=relaxed/simple;
	bh=fiubGOpznSBlWjS81EhUbY8+Jvg8mdIEbz8sZifJeJk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Sz9R7FPWFuCIoWSGv2V9NaS5Pe0Cx2g7QHZEksXNNzssL4xag9Fta8weaD8RX+cZEeLyOO0l5nEdhQmEOOoOAQNs1LQ9hlw7hQ1HNNv1mb/gzZe65d8PsAT4G1FkC1o5XwtQ1nkPtcBqoRzHFN3dJSaOCMSfY5eQ6GseX67u3rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VlRpau30; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=X7MUfdID; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VlRpau30";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="X7MUfdID"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LB4nPL1129800
	for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 12:58:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	skjmTwe/2/9vsGC6HLJTSQTIY2ObikwZKwuHsPTlEzE=; b=VlRpau30bHj0O0af
	bMiAMhzBP3oJ3f+PCA+Omm47zjxSPgeHoVPCynbxfHgavLE3pwCdR3fDszGGfCmB
	dMJevFWloWqUGqD6PSvaDak2BQdUAYY304Y+tZv33JcoF1iZMVAgDTx+sRv4eM+N
	QQ0+oKKdBl7Hq754yQno04gyFP3Ok9io4LuKBmvTO9knR0b8T44gIiI6yVtW0LnI
	DhUpmAkLhqEBESm4DnmaKPuu8saAm/qECqoV+VWoJaR7XPgrxUIKQHX2bugZUqxS
	D/wfgf2hti5DWeOcczvMHLc3uItPCTlyxNgXcL5SiWF1IAPBpun/CCG6J8YJfDQY
	tpWdqA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu3csgdj8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 12:58:41 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93a3f673221so494424785a.0
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 05:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789995520; x=1790600320; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=skjmTwe/2/9vsGC6HLJTSQTIY2ObikwZKwuHsPTlEzE=;
        b=X7MUfdIDd9eg7Ap8LIb/9gI1kJSIFcMSP3sNFXPMa73kWNubSr29qtqtNXhLlPKzIc
         7SCv6EqSqtV4CS3IR3qlfU5g35S2hSz7Nvi4WqAl3MS4GL9rarip1I2IE/rhddMkPY0H
         FUnB/V54kF3j9nPkEZB478+pR49A8z0WYKIzOS/TVotYgCOIPLefOAsueuzmQ+SJu2CJ
         85UTQxu8OHP3nI04KV1dUtuBwyBnsWrlZttIODMqAu5Y1jzcEO59EznQ2QYC6gmF0xkK
         91cEmgGDqBf+CDEB+mZROz8IJGvDSeboHWrfpqqpPUZQzOeJoRFq6JFQVIHS2unvL64c
         asuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789995520; x=1790600320;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=skjmTwe/2/9vsGC6HLJTSQTIY2ObikwZKwuHsPTlEzE=;
        b=SkLWKaAquoLSYFWxxWx0fzZMdKM41wPmvx8Yww/de62Lg8+KGW9wy2GIPluQG20bqF
         wSPg7OoaRVyAfRFp9wN4+etDeC2LdRO3iaTgFLoh48yq23ufQJhSzBkU3ekgo5x0fTtF
         i9kXTPdAjw2slrWr8PIYf/5+zr+u7VRsZUuEXhDsg24rF/GQPkvTl5ekkB3fjrw/yJNW
         zAQTq8gzebxSNDez9PgMtJdf1mIol243CZs2QeT7ChLL/hQPZQpEDkelwAuTbenT7GFE
         jh8N54+rfi0dsXCtF8G22LnAeSe5TOnCyy6ooCE6iL9aXzYM/6GsgK6EP91IchdyjUVu
         B9hg==
X-Gm-Message-State: AFuF++lizRwf2L0aJqTuXR0/UYbVAt74BlVFqQcWxRm0KiAXUOZdX17U
	tWzRsy5w/tBob2zVRRodGUgrLab2siL37AwaPnZtWqs7W9UWZE7BS2+46B4Ud9LeRtf26UA9gtK
	XnEoTzvuMwOwRGUZPw5gmX21KpWNzdI/RJzvBV+IIN4dW3QVF5W0U1ZuGHZdlXW72/Fc=
X-Gm-Gg: AYBFou1Tmuzg9B2t3foHbLQ/t1hMqGdHsWh2+r1yYoE4XiHZTGSc90dZvWJpaacEMyv
	eOU/er4KOub003ApwfsD54mVkSAJPegbiMrKeGMmn3zSo4WAR4nkw8eXe6mF7hheALwDU2sRVcS
	xGntzDQ3dGvNY2h23wK4CihEv4EITZBVhEcFASDa60U8P5CB6Z4pFjPNsdJAsOqEddbvqobdKSY
	KagdNCSS+e78CtdAuXXHc6C2tI/Zj7BSGD0K92w5PJJ2mWLro4KBciqaihTbcs28SN66SDkT5gV
	W9GqPbLhTtOpQpGMuYESvrMAsM3bRUAjcvHH9mirRZG7a+NnQqjviyGtv7HNUvD/Cm7U214SnSm
	8t4Hzn1d0/2ulUSVO3aTnew8jnJE=
X-Received: by 2002:a05:620a:711a:b0:939:6de8:43dd with SMTP id af79cd13be357-93c15e99f46mr46325785a.49.1789995520082;
        Mon, 21 Sep 2026 05:58:40 -0700 (PDT)
X-Received: by 2002:a05:620a:711a:b0:939:6de8:43dd with SMTP id af79cd13be357-93c15e99f46mr46321585a.49.1789995519625;
        Mon, 21 Sep 2026 05:58:39 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:d04:d483:faad:1e4e])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a359037aasm320278766b.63.2026.09.21.05.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 05:58:38 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 21 Sep 2026 14:58:11 +0200
Subject: [PATCH v8 02/14] crypto: qce - Reject empty messages for AES-XTS
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-qce-fix-self-tests-v8-2-107537869a72@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1491;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=fiubGOpznSBlWjS81EhUbY8+Jvg8mdIEbz8sZifJeJk=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqsSnq7SZtnuJ3gKn76T2Cx+kF+kAxPiEDzJeO3
 touwhyuOyiJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCarEp6gAKCRAFnS7L/zaE
 w+B1D/9BQnIoyDi5SScYSIHdGc7bLgsPn4vN+50qIfkwN8ShCn7wuBF/r10UFpbpv79rp1kKs+y
 mL4qBlu4S4FUE9viYPuBAaIqmKY+N3+AjtL9a8mhQYlynycI0UxiGH+b7cgKPes6M9sSJkhr+9Y
 BMekYaS9+278rJDDmGEpkoQSVSOIH9lm1DR/McGD2YR2zhCBmPaT4vVA9mNevX6B/yEMSoan6he
 A/ZwZPtGlhimDROaIY0tz7eUJ4HWnK83FrE9JRu7N7N/di8gRBwaZ4xe+63DUGU05Qc9WNmD9p7
 7BEetO5JtnDxQ+WqEdyfxls8v5oGiRZ8F9ZxAGAF+tiwYvY5+/YhihcOml14oj3cEHQlkzdj62a
 /QIOVdtmXDiFpJP6/3y5qsCwLRagVaYE8NXTfZtDCaoZeiEtdDNYAJpxPA0dKlP3fu48BXl4JYJ
 M+kdYY9KeavSzzclGlOfhbDo/SEDRXunAslSwus271IMIgFIQ+L2fcd6zB3hmREtIyAxAgLf16t
 ULmY9J64DZiAU3FisagvSDLX5Ne0cGPUn7t2RpQTee1P6gL9FN3VAJRUvXs6b/+b15uyiy93H+v
 F9hhxFFojcpp286Gbi6Anb/sD8NxVQwM8CNCbUAKap1yPw77Ina52qCAeZilBlDccYCdA8Qem25
 cwPGQGTqnUzVFhA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4NyBTYWx0ZWRfX/UFEeKZjtpv0
 4tstihYjt4LIBceCUpBkKVyKP3n1+7eJcRj7tM/gA2lRPQ0xELuMCOCPldO01zocVky9ezlgHd8
 vpuSeT4qyjt5laHf7RZW1JgNYkGDm0Y=
X-Proofpoint-GUID: nxL_bwPOrH0hSy39HoRdl6-pCk7Q_UeA
X-Authority-Analysis: v=2.4 cv=QovLTlyd c=1 sm=1 tr=0 ts=6ab12a01 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=kiYxeA6Iecqc4QeK3QQA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4NyBTYWx0ZWRfXzL8cQp0jus/u
 1wE4s7Hd3AdTaWAh5O9RLq1uN6ZNuSnQdXi5D+G2stZea9jaxQkdZ68SGuKiP7OlDmC9+h2ZrTU
 gf7vom01c24JsKvhy6WDzjRDYoTxjZdwNzAt+wsZA9O956hG5SPHJkB5vdN67jBHItVLpu0iTSs
 LrZCvQEx9gbKiJ9JyyGQy8fQ+5lGThURr+TL5tlDLaxEqF5AVshAB27Bfk2ZyGNs/NMpsmz7oW3
 VsjPPbbKBQrOys4EapCsZSOHfrua5Zg+3jQi6LdZIDvjClQMsxVHUXcOKdoG48nRqd9coibI8pn
 Uux2+dzM5sGdeUwa+9GevVLKTMJ8N4uyB3pa5ayBZ1aUmC+1AflqO2etzFB9d+QnHmi1ed4+xyJ
 20Q5/AI5j0FLDXjfISaoCRSEjxdLfxhVCJX/0X4waNLxx7x1j4wnskYGDd2D+pQhmLQeY23rgmE
 PZoWY5ZXiTVfWzynSPA==
X-Proofpoint-ORIG-GUID: nxL_bwPOrH0hSy39HoRdl6-pCk7Q_UeA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210187

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

