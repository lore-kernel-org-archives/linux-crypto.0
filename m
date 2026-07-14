Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9A33630B0
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 10:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023561; cv=none; b=RiNH/ZQJ1aKrPCMGXzm7IQa4Nsw9ITyxn84bMCTv/x/rjKrlEBaiYstu4oSmWIrMzDd29Mt1eOGJFSYY77vC9ffDStnfmmAQAVUxKNNxthxq9wKdoVTIqjsjGPm4yboXNQRJa5Yg21AX3IFDoC9EauAPt0aP9wQVN7QNlPWQFco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023561; c=relaxed/simple;
	bh=k831T68Gle0Et/tegpSdv3VH8qV/0hMaO9J0ZRRoz4o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AmEiee2Jv/Mh1X0jcR2rcnNmAIF7CqncicVYszQRHfj6BVBizI5MgIR9+4C4Fo+QKyKKZyM+dVBIOA5bBcL1+tvChPhjZ4ByLxWJ6sNVbywtilK27xnnjMBC/QQ1PhQIvmSixnE+xXVsVTFVmUnYoKtJsDKjUT//pC6Pp9BkLzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dWofjQZP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EQLxPmsx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dWofjQZP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EQLxPmsx"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6SKov3912619
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 10:05:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IFFnCORgu0ZMvRsu496LBJcnkWBVb3pQrobG7T1jp38=; b=dWofjQZP7fGALbna
	i7PSVxCv+C6ATCHe9RqkWugyUg2MU5Sbyn9Q0T9urtRVsvPxjx2s+RX2MzPBBwkG
	F1TtNVaFDYdV/Zw9/cEj8IWiNdR7nosJvuR/fefh4Zm6/Sci2SjVaQCMjwPTkvf9
	X+mvwcFUeyWTjRUS0VVWUZIUl+om8LMJMlJUBeWzslZB9dzy0cR3FtDdCYbpBxRE
	mEFTckURpvRb/RFXzvyHgheIY5kwQxAPliZrFKb6ka3RQgCmer40wgWmaDDlz0Ik
	UXgOW6NZlp1zyJCgPqrf58HDAWP5TQn5aiivkZgVTiuMOCoZKw2NXbwROEXfIxnA
	IlNXhg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fdeu4h4km-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 10:05:58 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ce8a76df2dso73888055ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 03:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784023558; x=1784628358; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IFFnCORgu0ZMvRsu496LBJcnkWBVb3pQrobG7T1jp38=;
        b=EQLxPmsxwofMSi/i2lE2ueqKJUFTLlFcZkOZLjGgEMXn/2DMrlfE1QWFRShoiSpniU
         vmBYEbBk+oNIj94mJC8Hfd4JrjGHHJXuDnOVUCGrjOHHAboZ2VwMbsChqy+0gDBt5oHC
         cyW9je+3dnBhslO+USM4mZKseBPXWA/ALm/lbipC1gvu/P3wi5B6E4jRTTcBlLccfMFI
         6aWz6Bk/4zsUbF59i1NuALcuasMPggCDsU7LiFjvdh19mGiJf+Iy37AqaQv1OE6oM7fh
         ZC1MEnve8T8+7GMnrMFoUu59d/6LSF9EtzhjKGu+XgqbZCi8Vrp6E3mSZE8DFmF8ZKSx
         hRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784023558; x=1784628358;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IFFnCORgu0ZMvRsu496LBJcnkWBVb3pQrobG7T1jp38=;
        b=apEr1dY55adzhMJFOS8bmMj45BqnfgYRbJ736p++OpmabrY0C4yS4NDjzy6dZMIMC0
         3EH4kQeccRVJJ2IJvSTNlrGcE8mRCKYEEVHaWntnnI6a5vaCABCdTRdbsxGpn/E50Kvn
         RqPx/l8By7ibuKazN+X80tECtRLGEQAmZ14+Yj/NHCIbqAJbDtQgPVVNBB4exQFLHrCn
         HaKZ7nYKzD/xxwo25N4iuTW9bB/Saq1kdJ4kNbSAKK2WL5WHK40W8tbZPw00QmvDG8Re
         UfxBnreoWrobmq4aeOo7nZU5K14Tdg6GvEi/KgOzGzy3tPBhPYFikslqrMzPOPseCALT
         fcww==
X-Forwarded-Encrypted: i=1; AHgh+RrvGl5ybF0NNcS5FJ4ZTlzf2zUmeMj7mLxSI/GQ5L5P53okyGeuMFCpdYyEoaA8boZKOmZOe7hT/VHI4Xk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVOg4ItMZT+jGw9gKXT/etZlGojZptWBkHJebEnq9P+36xzxBb
	mg6goDM10xCQdODfRc6spM0jYCIAwxU5xl8j7SCOtOyo6xbluUrKIpb5VwSN42qZcEAzr6GWcpx
	wH0wf69mRuH7C09DSh81X/+GBeCmzKSz+BCfk09/I7gaj+CLnc5nFXyRt9KY89tsjR/0=
X-Gm-Gg: AfdE7cktZkHTSiw+F0g83ej3NEwh0rMpA7WxhjaIqN2ZD3HsAt71LqcKW3+/jWfdKwv
	sgqRJQsGuEbb0kuZYlelf9L4hSfyXtGp+tJRzdxqLMuLW4ElVZm/KTzBx/jAFvcauVmglqEpN0p
	lHdPbzWkYf4NuqByfmsa6oIlZhrZxEjVF+ZGz/zTV3xscjphJ+UrNEbRZU1zY3NpvLg3S4NmDWV
	dUd2ijyjoHUuy+oR49Uc7At+aI9BxNB6W5yzQ1u1FLxLlkQVCM482SgH/Yv1/+ywGvoqtW/2Xkl
	3E1GPCdarKKBXbrJouoGi150IwXDxra/UhlieJcbDmVC81lmjInyXWTaFR+3o3+wdVvWOlz/MZM
	35aCKSwrQPKKff8JtSMdDGLF+MN5dxyMWOrnJMUlwmpbv
X-Received: by 2002:a17:902:fda8:b0:2ca:4b7a:4a02 with SMTP id d9443c01a7336-2cef1370d34mr17545955ad.43.1784023558315;
        Tue, 14 Jul 2026 03:05:58 -0700 (PDT)
X-Received: by 2002:a17:902:fda8:b0:2ca:4b7a:4a02 with SMTP id d9443c01a7336-2cef1370d34mr17545685ad.43.1784023557915;
        Tue, 14 Jul 2026 03:05:57 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bf737bsm112653485ad.19.2026.07.14.03.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 03:05:57 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Tue, 14 Jul 2026 15:35:14 +0530
Subject: [PATCH v4 3/6] dt-bindings: crypto: qcom,prng: Document Shikra
 TRNG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-b4-shikra_crypto_changse-v4-3-06a4ea97c209@oss.qualcomm.com>
References: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>
In-Reply-To: <20260714-b4-shikra_crypto_changse-v4-0-06a4ea97c209@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: NOyEcWlJe9dTkR-eBNLrP6y3Y_m0HDOF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwNSBTYWx0ZWRfX9Hz1VuS2HzoT
 boVMRBSS3QcaK1Eih/Agx2vV7zOZswemk+TAUBQo/d+5JBuyUdaZnmc+FatEbvNVej0usXaiPz+
 eOg7O0uffXR1aJZivV1RBbtQmHLAKca4it8+Ca0xz+4PXjAGBvCHYWdshAMSj9HNLF4xA787X37
 fqIWqwqCTuSSAZ0sqggNL8Vpe3IGTq7WTreBkdOExjGDZU89WhoLTodHhc1j0/I9uyOM6S7EdA7
 51y3S5xELFHabU44sE18XnpbvWXzr4SrHp9ItA6+0C74RcrLlNwiiaV5e46I7UY8g5SXTISJfeX
 rhgwaFm7GFcqBDYkH8pgYtPeslwwdImK9/1LiJWUE4QCTu6Fi/E4hxWwn+9irTIaOHJn/9Ri29W
 MzaGZSS2G9bxoE9Uf+J4sRbyLEZQVFR8/uivfSVOpz9+75aNcEseK4mOnquZ/JSgxdqwVzesV5O
 etr2AGdl+jf8qUgY8FQ==
X-Proofpoint-GUID: NOyEcWlJe9dTkR-eBNLrP6y3Y_m0HDOF
X-Authority-Analysis: v=2.4 cv=cN3QdFeN c=1 sm=1 tr=0 ts=6a560a06 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=mVMjwrqIa5QPTF8STQQA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwNSBTYWx0ZWRfX+sODyoiwkUgH
 6Hz99kqjTOacrhmA2u7wuh1mstWRRhAcYRhNgzPSYzE+ptWZZ9NTKlgYJYFM93LV575Q6gr00DG
 iL2PSQBup4MWEHbt+QupKLESYsM8BOE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607140105

Document shikra compatible for the True Random Number Generator.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index 6116289ec413..de323969fe64 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -31,6 +31,7 @@ properties:
               - qcom,sa8255p-trng
               - qcom,sa8775p-trng
               - qcom,sc7280-trng
+              - qcom,shikra-trng
               - qcom,sm8450-trng
               - qcom,sm8550-trng
               - qcom,sm8650-trng

-- 
2.34.1

