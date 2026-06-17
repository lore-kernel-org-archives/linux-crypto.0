Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E0C480960
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781711421; cv=none; b=LL/kPg8TDJQJ0zLiquNm1nGr2j32POUcQkiUEcxOwfdbeJbO6y/lgCrxylIXo/hPyrEEtGQ2KOFK0x+mzyn5Ci7fIrKSlgH6XxrCMeIWol3TTrzzLpQZXlfULLd4D+rjFbZZuk1O0srvXigrv9yFprg6v5mVIeN7FTcdT6t27os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781711421; c=relaxed/simple;
	bh=RtzndF624GK+B1S5N/LG4zxmfgm+M6mFqK4xoHMGFj0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cUjiMgm9w+g1kSG29XAdundM/gBKSRto5F5QMESnABLStHLn0lMUW4t26eQ+nx48E/dpwoTntq9RZnyqMix8X/bZJZN8+UKQcETlGUaKMbe8CMK64SCUq+DaWzjDcbpQsYyW9tKLID4Xys4yWjcfiu0uWfEhJ5QtMjU6uZZGt/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=i+xhhRdA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=d65cGpZB; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="i+xhhRdA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="d65cGpZB"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HFOxGm025147
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:50:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	w2vCsXE7toL/jfvcCxsJrt+2J0x/Uao7L2OQT7fWmzQ=; b=i+xhhRdAYPkkQAU9
	WG2eCb5VOGbuYaY8USadBosJi2ajcilPeWARonxUWPCJyDmOqt+ktVp/Oz1SmtyK
	I5j0xwzLA/ZEcp56u0agydX5sD8KAAO1kzo2mojzER/jQ9HsErvCS9EXQCchARVq
	fZfW7C915E734aD8MplB5bth9BMfHhy9YxhLWNgA1XKQs7LP8poM4ywl3xORYTpr
	0FxDEDICkNQPdhdEJjMmi9oud+iCmcHxAqt25+ViggF16AnGtOhkRXZVxaBevzDj
	vO0zh+QHXLyarTo85HwEHU+ngJmo8xbusnD1nLBMBF5kGLCYy5HlvTGQ4bDcLOeI
	gdsS7g==
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com [209.85.222.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4euw9vggbx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:50:04 +0000 (GMT)
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-96388871d70so5450776241.2
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 08:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781711403; x=1782316203; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w2vCsXE7toL/jfvcCxsJrt+2J0x/Uao7L2OQT7fWmzQ=;
        b=d65cGpZBzo5HV2AV8VcOdXhgaog2Ijimh58Kh/8dTBE3fLWO48QSxnya8ve2qGKCQ0
         eo4hpEpGxv6eRP9Kr336oHz73burZbL55nOs3At7YiVz9wzNZG3mHk79KEXhnGV3UH1o
         P2EUnVogMqcU5pBccdSynUEolj4OofuLcOrrGdBUiAaEXM0mrAPkI9C3eLX+wWLF99dD
         AslJ8kQlmL4qH5hZbz2ta5Z+K5eJeItAJknwB8ppOhHEePDp48sdtDl0PRJxbLG+BEOj
         7IGFEdfOwGXMDIyIzGdbxsyK0Q3hPNqHAxt2pbQZFa0yswt3mWMW3Q1TwcpXHnVzZZtP
         5bbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781711403; x=1782316203;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w2vCsXE7toL/jfvcCxsJrt+2J0x/Uao7L2OQT7fWmzQ=;
        b=A0SHRJr+O05o3WeDOGGreGMgaqrda1J4TTQ0TRHXk+zNDNmG8zy2X6jdMZgyUKAYNO
         QZWaGekbQefLided13k71U/eBV9nRuB+a5GTxCu8H68JJqtcoQExgqDSHbGzm73S6Mp8
         DRQNXXmjVFZaNMZi2c88lWBanKFFf/oO6hMHW/DtLjTyUeLFYPi214ozSOtSa2KN4fem
         cveLv1V4k4zbUzc+WoT7izZMwAJMEwQsN765Wkkn/Ju4Pg2auHjC09ZLSQpViU0o7Nl6
         er7xm3MxDdK26SKLGEGElByydUkH/H7OOpTzIMN3GU9rj8hIsOH8yMxuYOWhJVpTN5QV
         pJ4w==
X-Gm-Message-State: AOJu0YzF3BJt3LIf22oIvK9N909W2uAvfyLluZBsPPzlFrTFqlUU4R0X
	wsir7Ji2a3Fqh5T/1tr+4XDsYx2l7f+IwSiDdg2DKGEpVir180mkx2ANytj3b2I6wQLYAr87Rev
	ZjiSv7I3NMnGPmKwbKaIw+7r83VkIP+cxgrNHbIIDyG1DIuvJlaLk6YnAngpTnAi4/Ao=
X-Gm-Gg: AfdE7cnrdxJ0/jMxxPCIflAaEYT/igK+3F/uO2YaBsoJHfkpRjCmjdLjiXiEGVcoibM
	UNx1PSmMwBWHyzPBuqhiqoTOOpiHkAT9Ib/RPZQZWCqszXfBtZJAbf+ieCDnRKEyeKYM5F3KHs5
	tPTYd4llvwlBQ1LLJF5+GVOJIYkYVNRHnDg49/m/61Z8OhCBM+iv34QkL8xDNppsHlQ0PgT9sJ0
	N1rBx9VFZhWfIxUyJhH+pQ/5S2kIEELvMccpvDJPhW5j45TtEiQcTM72jxGUqQDnVmFeU28B/O+
	wHqJdo86hAkEF2cK2jkg/FB8thitgiL1CEUE52iZovnRAEr7XlZ0meRIyecM44QLJhlCX/dWDZ+
	ruDs3rbUf5lvWuRkgi939PX+u/2VTLRp8IbmP7HpZ
X-Received: by 2002:a05:6102:5107:b0:6da:1341:1147 with SMTP id ada2fe7eead31-7245d3134cdmr2866761137.1.1781711403454;
        Wed, 17 Jun 2026 08:50:03 -0700 (PDT)
X-Received: by 2002:a05:6102:5107:b0:6da:1341:1147 with SMTP id ada2fe7eead31-7245d3134cdmr2866724137.1.1781711403050;
        Wed, 17 Jun 2026 08:50:03 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c856:25e5:e249:5e0f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa8b423sm168913195e9.11.2026.06.17.08.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 08:50:02 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Wed, 17 Jun 2026 17:49:34 +0200
Subject: [PATCH v3 5/8] crypto: qce - Use a fallback for AES-CTR with a
 partial final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260617-qce-fix-self-tests-v3-5-ecc2b4dedcfd@oss.qualcomm.com>
References: <20260617-qce-fix-self-tests-v3-0-ecc2b4dedcfd@oss.qualcomm.com>
In-Reply-To: <20260617-qce-fix-self-tests-v3-0-ecc2b4dedcfd@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1705;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=RtzndF624GK+B1S5N/LG4zxmfgm+M6mFqK4xoHMGFj0=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqMsIaPVBmp005T8Z6Gxz9EUFgfWYYjDjjnKYdd
 QEoLL7hEcmJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajLCGgAKCRAFnS7L/zaE
 w+dHD/4iKa04kAs924QQRpb1Ju6pOTQcRxikg3+yXMkHl/VlM4I+k0OJiAc5LHjHkXKPFLR1fDA
 K8rBBZGXX9ygIFAdXpT5gZgAtlGKF6xOpL1+VuGX1bSluY9Oyr99LaWemhQR18Wrtv5weV4jkzH
 ikogG021RyFeVR0ddfvZq7haTKiRVn1gmXizUK1cznSA9qC+CRt2gjn0hNILgiOnsSLFNX0y3a4
 1lEzeaZGrlxnQ7KY9XgFG1tMqBbYQqPew+CWvN47XRS9oNh688IqwmVkRTUnYzatxUaRYTBrFSE
 9Mt3ankwBv9VvE7ucR3oVMBUaYxmTixRSnglvONpfMThBCDPOlVI0irM0nwrQllrJbJwUJlEx+c
 pXJDum6E5SB+KCYF1TxHqo4cU+tSG7y2uFgJGHgCY9y2ZcfoYgzuZtdbTxtmmktqEDxZ1YRfuIE
 lxCZiIWdMph9R0B0RpYxnRyW0+8kC6g/NExx7X8qyhQIgt8RbuAX6T40siHbrEy524M2f7mvKnT
 wYyxoyaB71HpybLvV28W/IPA/b0UZ+HlthEN/UNr6PafkJb3fqGuy94t4LgVXcy1xQrx9O7D3GY
 uPfDEbfoEz0eYMzI6KAO288JefLr9K2qcSMgivegaRu/51rrT8jjbBY/rH+gFiho7NM+EUlSB5I
 hAJw/DpBDbQbsug==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: cAxJajxocNJfeQibGGuvqAtHX_oCPJwO
X-Proofpoint-GUID: cAxJajxocNJfeQibGGuvqAtHX_oCPJwO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE1MSBTYWx0ZWRfX/1pG4lkTKid+
 L+U/cpKVQJE1/bfL8pq+WK0sNCEvSmM2ISPiPL5zkejDdG+CR9Vy3jpjGJuLmHyTDw0LJFCqgt9
 GXFvryTpAzj4DhOAh43rpjzryP5PuYTPlJNDFWQTddlDTQY/xRzD5PqW38wfvUVvtdu2mLA9xaf
 7Hq3r5eRv9ZsVG2nnvwddw9huMVna/4ZyFSwjVTBFZdQQSKdzIcaMk7MiVNSz4sbGEDSlww0qrO
 gouh1eGipyyINIPTeqIPOMCx+cHa6wMMJuFuPeZT5iqnSSXa7YbbLa1cuyCoK4Ve0k0Hu0pi5Xl
 VIdQWPH6Vv6Mip2X9GIWdhpNc6dntjvf42eSiKAz/iRD9dLf/z8cK4xPUiL6WzMM2PPr64mMMBr
 JGDie2PGXMfFTbJtN7oYRgAhKSY3WBsiSQe/9Uqn/yMYGiiyD3YI6XdBvw03Uv/jogS96JR5BI2
 KvJG+N91ZkfsByr+uWw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE1MSBTYWx0ZWRfX5YWyJQSF0k40
 ydd5Tb1cB4HstBP9rSBSAojXKC1ujFfGwmmwW5FjPnPy6XnlEqTwaQNV/TdrWfsxPzbb97Xezgb
 QsALn4t28NI+tnWs7sbAGAsTgYOb8ko=
X-Authority-Analysis: v=2.4 cv=YJKvDxGx c=1 sm=1 tr=0 ts=6a32c22c cx=c_pps
 a=UbhLPJ621ZpgOD2l3yZY1w==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=vUpbTSJP45I4i0_vGVUA:9 a=QEXdDO2ut3YA:10
 a=TOPH6uDL9cOC6tEoww4z:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606170151

ctr(aes) is registered with a block size of 1, so the crypto API hands
the driver requests whose length is not a multiple of the AES block
size. The crypto engine, however, stalls waiting for a full block of
input in that case, leaving the operation incomplete and failing the
request (and the crypto self-tests) with a hardware operation error.

Route AES-CTR requests with a partial final block to the software
fallback, which already handles the other cases the engine cannot.

Cc: stable@vger.kernel.org
Fixes: bb5c863b3d3c ("crypto: qce - fix ctr-aes-qce block, chunk sizes")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index ace64a651f56ff478bb4966d74c9e762ade37ba3..118a6878a76b1e86534f60e5d2058b99a689302e 100644
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

