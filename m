Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B464D17AC
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792159929; cv=none; b=pDz8JQ8vm77Cb7iVTkmUfrHX0BEcwU95Hqbvpar6lLwZHlMIJEYML6BeAGhWPLinVvufCHqIn8MO2RufUxVG0vOmBgE3zzc4ilkrBSQX9GD+DYYQMdkhMa7gw4b8VdazbzhYW91IbbDwubNZrbeGccnztkwQCNfd5LqWpU6BaQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792159929; c=relaxed/simple;
	bh=10czG1yn2EOwOEpiuflfvi91l4e59NVnoKNaveNpS5Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JkkK76Y913dON2bzjRvn8++uaxK6MlCg//HdYfLhQswqFREZ98fxmjQKlf6+5VEEaR0OVohqTA+dPeAnV6kLOJzac8HPc/TMmkkiGTzyE1yeeB4J7zZaysi0mbSvdmJctYXjfbYsi3iFli0phfVzj9Mftz96zMStJDVbO4pkJS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=miUr+MOe; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=L0ZVejej; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="miUr+MOe";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="L0ZVejej"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GE6POF2494903
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	83Mt4HXkNxMhXoNbNZY+WQIFtNOuy89fZ73gqiGaArw=; b=miUr+MOeGDxLNRZo
	bSVEEIlH/j5o0h9OA//yltaV65RoGo0wgv00sUuJEyGXCEJ/zbtHTa8qf+K8nWxT
	oqNuOuAOBpFlsH6ZsFGeUU/M3/a3wNSLCxQT6jDRPB653OkBBr2kLB9leWFGLQah
	38hDVe+SHEB2PWuGSusBumTXxqr/1A2zu9mAL6nXhVCEWHZkpi3KH99X988ZY1mJ
	Z8txNjKmEzg3B5hGdUCZAROEuZjlXM1sEFlVDM87oWotornUpeP32eUAWeIH4RFx
	dCLh0j8DP5ugcl7VBeAGXhyoMGhyPg0Gbcx/hhiVQBGmz+DohvIZGrcBsuvNaX57
	btws1A==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb8a8ayrt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:12:03 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-53522c265f1so141744061cf.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 07:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792159923; x=1792764723; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=83Mt4HXkNxMhXoNbNZY+WQIFtNOuy89fZ73gqiGaArw=;
        b=L0ZVejejJtJ30eC/iNp7FsIzI067zu8nE76YQBzWVxbcUC1gASHiIgoHLt17FO7FjH
         mK829PfbCKmHtaJCQ9YQREWjYoHPaA2WJF9melwKVpUnfg7QtDoJ5ZpEsADHqpDGVxAn
         1VMQGkcmIMHcoYoDB0uo41Yaqq7nXwL3e96X+lljmYNnrc8mtkSRMd4y94k6xOTt203m
         QeAs8L5Pszb+RXd9/Bt5FMbNPimFs7T90U7Z9HyVRdiidhdtLTtffqysfhX9d9YS1yi6
         J3lVWc/bTguG6Zvh2kgO7o5io+AHPP2nGcq2le18cXFFI9kIIUKFl3mCmQQo8Nxf4mRT
         hJXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792159923; x=1792764723;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=83Mt4HXkNxMhXoNbNZY+WQIFtNOuy89fZ73gqiGaArw=;
        b=NqvrU6dsiT3Qj8OxwYBXwoke/KwS1djdAa4fJaQXw5jrZjdNKytgN9Onimrsbk9BQ+
         0qr81eSi4BYkw6jUuTzAVFB6NK9OOlkTjteyjwkKfrRAvN/RHjAiMJEuF0fwERHPrp3+
         spX6sjj/R03zgBRrj8cXXqs3MMcida162BcY7Kb2gBKNXpUg5VOgSeEONT3ll9wr+Lbz
         f/Jfld/mtsGuWSsF/zYiEDnBFwRnt0GNkudGVdIW34r1eH2eTkpu9eMr8mwwTXIJd7VK
         6sWzfQ7yG2lzgIVLJ1Gnbx8Y6j1eiSy+0WWtkydYBVQTHJ36OZ7VIofJzTF976WSAB1I
         qzgg==
X-Gm-Message-State: AFq9FYL89iMfazuWnKzuDlAjSqPXNVjVk4V2hhjvleAD0wmUoFg0Tn+a
	DkIg28UI6cz+lonpFT6/fHVcCdCem3KFJq1Mr1tCDodElqVXq9NFGs3Awr9WfwJ69lOFALX35GL
	YXk3Aekz2kc9RG37zCAmwGQJzwtSzsEpAwzfhcIQnLGdhUHEFpHS3X8/qtM3Epau1nsM=
X-Gm-Gg: AYBFou1RKlqENU0k9CF4sBTPg7UZ9j2EGG2jSz05DfhqfadqCRpczy/1R4sBgW/sLVX
	WVHXJV0UZSrM+BpIdwPsp6NPT5LEf+RwaE2elzw9KU4zkZHLqAMUcFySRkJ/4otIsxrkfNyEcE+
	PpZAR+b769hhlvqPz46JruPeQN4myKyW243LxKb+rUfX0uJfidY/5bqaYl3AWNtE+xPVnVmt9fx
	/66zSFzA+fhSXqXViP8EgHYdBXSMyDmvbV+Kq6GwdMbB9oDkwn3jV8XivyXT8CWg51d7pDZk4aS
	8RncoS0pIkI4P2oPXOWXbJ7cbaz/ROc494Idxe5hZLoYv3JPXzEc2W13m/6Y/PwsBjxHg5AcVLc
	h0a0jk0oRU8gVx0Sja07k9QbdADfE
X-Received: by 2002:a05:620a:4102:b0:93e:c12c:f117 with SMTP id af79cd13be357-93ec12d0548mr3510767485a.67.1792159917623;
        Fri, 16 Oct 2026 07:11:57 -0700 (PDT)
X-Received: by 2002:a05:620a:4102:b0:93e:c12c:f117 with SMTP id af79cd13be357-93ec12d0548mr3510761085a.67.1792159917013;
        Fri, 16 Oct 2026 07:11:57 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4f8babsm5760145f8f.33.2026.10.16.07.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 07:11:56 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 16:11:46 +0200
Subject: [PATCH v11 1/4] crypto: qce - Reject empty messages for AES-XTS
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-qce-fixes-skcipher-v11-1-d13ddfe609a4@oss.qualcomm.com>
References: <20261016-qce-fixes-skcipher-v11-0-d13ddfe609a4@oss.qualcomm.com>
In-Reply-To: <20261016-qce-fixes-skcipher-v11-0-d13ddfe609a4@oss.qualcomm.com>
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org, Pankaj Patil <pankaj.patil@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1548;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=10czG1yn2EOwOEpiuflfvi91l4e59NVnoKNaveNpS5Q=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq0jCntwqj4dA+B6RPFNzhijNp1ZzA3Fxh0I5iW
 8cO7uBd+AKJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCatIwpwAKCRAFnS7L/zaE
 w3G7D/wMlPfcou3916MiaG2xWtwt20v4UjUldw8n3h08pu4GmAbT5nJkM5tYcERtsxLnwFHOh5q
 /OJT4yjwWTVMIdTZB8yDI8V9lBMOVBaQ52A773sbLit4mwN1PGQ2/NDiqx+jgmnIrXfbMZmffoF
 5Nbqgu0vw5/2UMJ8Xj0DQEWKvkQggLqIxNvO3KtWSmjpI0kWs9X0Q6AMHpy1vAe0V4N5aNIP+5m
 75NM6Kd3uKBhKyocUejhfTBRM/ndIiuNXR4kQJunFU0+sSUQQg/ZnJwhiwVlEdmPh0jxJL3Ks0h
 J7B3NUdDB2IdZ9Buk+RnPqPKERJEyy34pkT8lKURQ3SDNpfWJj7JHfWWJIbSufoP8x75ix3w11j
 gpNjCtLba7kyrcjgPuklDP4HNa/w1SMRHG2M4Avy1WIVqkUY9Vk4qGV174yGar+YXHiQNc38/uS
 Bla9pkeUpJ7OwE15D+rD2KpPnIaDDQoM+REljUdg3YESydnttEVCv3rt4fnPa5v3dHb9QOjSVRJ
 TNbMhy6EmDl3lPkEzTQuDpbJ2bYcAnVDVKUzKhOHM6vedfzR0k1adRUGS9A7WbZMabji8/XaV2a
 JDDOdmvSeY6rgaDYvQ7FB4165bq7Z2nF/estEJDabpLDDRi9xmJ2Ha53NGsgmGJyU8LxfcqFzwg
 IiAEocAQkBBchDw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1NiBTYWx0ZWRfXyUMpVVnLwvNj
 J7GaxGzR1Qaq0n/37yyB7byGax+oV0dWAQzsaIsFb0zNRDswVYYi5A5cXjLzZ+evwtEChxkw82f
 74zA1Yl6EnNHGak+dZiM/Rnime2sutU=
X-Proofpoint-ORIG-GUID: SXK_yd7uSduTbJ-2BsncNNACTc8yUTII
X-Authority-Analysis: v=2.4 cv=GJadgeNK c=1 sm=1 tr=0 ts=6ad230b3 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=kiYxeA6Iecqc4QeK3QQA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1NiBTYWx0ZWRfX8ZCdMSfD5I5J
 Ki70CJ9ibMgxxMP1hjs8gsm2sdr5Th97tKtg2OTjwYGLsV/fwJgRfhbAIhzIHeVzepsMFrtO5R7
 nlf6uDQtEE8yQ0Z9Ws8DVHoRwzumAvmqkMyMIM+3yfO/xBDE0C0VgwaRbk73AhoPc4EZOFSyV8s
 FWlQa7H+VK5x+f4G7uqPxfatqjRvaUPmENelAKoUO0r0xRv1hLN3Rm0FAIAT5PxLxZvW6Rnirjp
 gU6iHWV7AkedVOWzzeKWfGPVK5lUefohhXsyg0blwQBgHSNW+acvMAOVlnZF3B0FVDLkvAcs/cG
 wM3f6CpMJ9yYMTDjS4b/p6sZs2uB2kNvocmENljsknWEGTpxDOxhfMWO3mmbljRWf+xP+TIHqO7
 QG8clbC4uzACvtyYNfAGMfOVZm5Q74hjYDev7PfwylbcXBiVK9pSpBfj65njoYoF3/YEyc+BKXr
 LwcEg6Qk1KX501nVIew==
X-Proofpoint-GUID: SXK_yd7uSduTbJ-2BsncNNACTc8yUTII
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160056

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
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 03a3cec2bb90e8d8c17e491ca40ec740a003d1b4..f177062eb735148561f798d0d3e65265f3235da8 100644
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

