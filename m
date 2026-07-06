Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1167641F7CA
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 11:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783337554; cv=none; b=a1CWCwbsdZUJbAAXm3mzqzgf7DQzw03yWafCvtXb9orevvUPPx9svGUIao4G2LVokLPMbNiRQZCH9MC0rdEJer6LDTaBV2qWhojcJlt1kBnJv4B3uWz1+e1a+jjM7q9QcNIFMPI6AouTRkjpx/US0saI7bmzMF7nzVTQnbZSi48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783337554; c=relaxed/simple;
	bh=zjzyQGqtQEvToFUvVoo7pZ24KQzxayJOTmTLKhS4AOU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pvmCjdGvb5lOZP9L6pu0IgkvrBndWUtQBpRuHvdzkCG/wlaNk2M94hW8Yk7f98vFKO4DEqDO4SAoH/HVViwW7nPt4kFQJGRVkqm5XK/XZWf9FXmUg76irrbo2zC1BFqFY5DS/h0Te6x9Eqv97zW+jcdUlu5CacPT7e5x9ajuAF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bNRM9b93; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BgsHo8vU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bNRM9b93";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BgsHo8vU"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666AxLic218457
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2026 11:32:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7SkMYn1pW8LZr6abBIJ2z33PKYxNNOhX0ZIHoUiS7dk=; b=bNRM9b93C2KoANL5
	Fk6+1X7sDHXqIMPZliAznbS4iL327Fmj4JPnVK1roSk874A8RUVwRab+OugbudZJ
	dHZzZUEPKGlfSrT8+RPR4FaRF/+DNoShXcYrekfr73fqrAAwdwv4oymsMU5wUa6N
	iKNnDbofO1GGfC5EVRDrsYBELG7UmIcxgspDndwkgVJcM1w8ELleBZm965P6DpMk
	ViBEGiUV3Ho11W3dAi1WLENHYrzd9pcpvPptYFaHmSnImTygKH6F4oa4F1M6jNyT
	HKejU7bWF3H58ajYFJ+EL9xS2RNcAIbF1RwG8DqgzukjM9NybTFiLf6jBwzgTi24
	PSq2KA==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f88hs8ts3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 11:32:31 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-847c3a12ce8so3052113b3a.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 04:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783337551; x=1783942351; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7SkMYn1pW8LZr6abBIJ2z33PKYxNNOhX0ZIHoUiS7dk=;
        b=BgsHo8vUJTjtwlowhC2zqO10pAmxq0btNYDrRwdJ+/hK93kTZ+hoNczaXm4+FF3QAv
         I0iUOVKe3k+GhSB2hrJvDnhdCXyRcxfpKKhUbGXDdh1En9kuqUgHL0AJoEJYTz4Qjc8Z
         YgfuMaqxy53SyCVGP2wTkbMV0M4nQ9qy+VtcTfJH/ugrm7isQiziEI61Saci4kUxD++Y
         yw0q4Dely9vNGXL7E2OFeRveCmCtHH4oqwgE9nj5eDRcCbGfwVyz//NOlBBNDkNjIPCg
         EhEE1HuBYB0sHu069ZoiQSgXOkzQcuupyLs6r5osk9NLICSiw5H7/F4XoKvK4AYg6swj
         HOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783337551; x=1783942351;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7SkMYn1pW8LZr6abBIJ2z33PKYxNNOhX0ZIHoUiS7dk=;
        b=Mnm38Wrmzng7w6baRmi5mOxHgHtWqhiyWVndhlChSCvjl7j9k4AiJMANb9iDF9FvJ8
         u4BjghOCiEOvZ7BMzhZBkAhW/1C0iB9RFyEEC5Yxf26gzD7xTJ5gJ8YjtPqQwlI2l4KL
         yJ7qPTFI1XRfqtYhS64KGc6q5zhNJX66MFL4CGimx2QrrNQbCDuLqBhGAXASAe3/g2aT
         0xjWdHN61lJEyQ9kVMLKpMfdaLq+96WM+1WfG3N6q4hAEn5/z99MqVaBkYUOpkJRHfgZ
         WvKYyTRBUMZ2cwB2oW4F62zzOc98pwt9BqBxBXoyRJumY6mvEc6nW7war/BpybmEh3hn
         DV3w==
X-Forwarded-Encrypted: i=1; AHgh+RrQW98tUPaCtLvoPe/NtI4JNsQXl8Gc/7ixMGqlV3i7zxyjDOennTmp8M+Is9Y4YRh6Rk3qUwA0ofbRKFc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZcRM6Fa1cmIK6gS4oSSEu3OPPBHhaI8kYbm0cYqnXgykFtaAK
	bywzoLiIevGteZfrH2EIQbKsd8HspQWAVM9+LAQhpvHudscCnHmItXMM9vJn85uSX4DmDSDto0p
	jlAdb/dFqsXjU0uUzanvk2GWsGND4/9LKKWO/NZXCEbci38+DfVklP4N3/y92dBFuYOg=
X-Gm-Gg: AfdE7cl2cdjKeSmskV0QFSH2Wwrsnziyeq08KKNb9UjjDFk3+4G2r6hAVMjFxthRcnH
	ERyD9G3l4zeASztp9mLgmW08f/i/KnUAg6uoedA9mYyT30eru1NOpR38SrsnpoH/UxevC4tEACE
	NtTCUJeP32B3Z1PewjkBoYNgW3Vg+k42pC2xVueU7YxBimrTrNCR0Y86048OomivOb7vxlMIkET
	kSRpi124DO4L6sEFepgMpaBqAUeSP2ttfnwi7STK5itOXd0TKOW7h9SMlMGWakKSVa+y8IV2Byi
	qiq3Tc8+t/fPHQ0VRFBReB2YyLXYIXS+jcE5dUJjc0+MrJPOby+XwCAt0hX+Z5SNdr1MzKpME+a
	noQmnbExMfgCThn+1J3DBOThT4CAjeoiqsVB2c25VtgbP
X-Received: by 2002:a05:6a00:e8a:b0:846:bc81:3e29 with SMTP id d2e1a72fcca58-84826c1eaf5mr136612b3a.2.1783337550706;
        Mon, 06 Jul 2026 04:32:30 -0700 (PDT)
X-Received: by 2002:a05:6a00:e8a:b0:846:bc81:3e29 with SMTP id d2e1a72fcca58-84826c1eaf5mr136575b3a.2.1783337550254;
        Mon, 06 Jul 2026 04:32:30 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6dbdc8dsm3576621b3a.55.2026.07.06.04.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 04:32:29 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Mon, 06 Jul 2026 17:01:32 +0530
Subject: [PATCH v3 4/6] dt-bindings: crypto: qcom-qce: Document the Shikra
 crypto engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-b4-shikra_crypto_changse-v3-4-23b4c2054227@oss.qualcomm.com>
References: <20260706-b4-shikra_crypto_changse-v3-0-23b4c2054227@oss.qualcomm.com>
In-Reply-To: <20260706-b4-shikra_crypto_changse-v3-0-23b4c2054227@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@kernel.org>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-ORIG-GUID: dCHzqIk6bhG8QkPSFQmmUkMFGEiTBf0M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDExNiBTYWx0ZWRfX3lb5fU1AvtC/
 PhZdPtxRM4am7K1ffUvzc1YzoDh5npVINQQQ4xbr6waehwOLj05jP7leF6sRncLznm92mMpHsTf
 M+tqFOmlG8gK3KFQu3xyNMABvC4g1ZU9gZHwrJU3zfH/73JXMVCQd/oZFI+NxzM2YEyKo/5Wpxd
 H4ZKju9TGDYqU4H9Sj5pIS8XACIU77UMWJUwKzizxPFGktqhi6rxoLV37Rk30AKVvafQ9Ui4D55
 8hycRiXFa0xoxOpkQSoNcy/aZfD1n3C6GfwLBj2KY1PXAbH8qjyQ+SnJd5OWbtmEDVMywD2e1+S
 O6NpZVn3QDSB/CisgEn76QEABvGsGfcYZ+5i3UQoUNAyZ92rN8fKZ40vkaKMYYq4GoYX5Rqo0qX
 jDpmA0wBZcaAK9as57AGIho1/VyGJmif3svsUm4YNYIKuO2dv8lSTaS0t3IBpRlra9i5ZLezVBt
 kudBe0cAFySYBVOjz7Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDExNiBTYWx0ZWRfXzFYV2UmLa7aq
 kNy+dD5r9pDZk6kQ9MFyaqKFNSyXMvX2Uj25pvfSEEE9YZh2sWUFDM/GMq+y0veKQhR3cqlrMz/
 H2CtVUEPbmXaH/7wLZL1i2h4zTn/020=
X-Authority-Analysis: v=2.4 cv=XIwAjwhE c=1 sm=1 tr=0 ts=6a4b924f cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=mnL63iHeaYg7R5sIRJMA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: dCHzqIk6bhG8QkPSFQmmUkMFGEiTBf0M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607060116

Document the crypto engine on the Qualcomm Shikra platform.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 08febd66c22b..5a653757ee75 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -54,6 +54,7 @@ properties:
               - qcom,qcs8300-qce
               - qcom,sa8775p-qce
               - qcom,sc7280-qce
+              - qcom,shikra-qce
               - qcom,sm6350-qce
               - qcom,sm8250-qce
               - qcom,sm8350-qce

-- 
2.34.1

