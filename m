Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563224218A0
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 11:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783337547; cv=none; b=jwaPBKPXDFTDJfJ/hr8KolIluXX5HUB1jeBADi2S49EIEnLwOSf9jjJGjb9qy4HZdjHEIx1LIILWV4HGrzA6WA5mTYKywOrTw9X6B3HNiJZxWRV2c4q0+Si0VUWcmyNZURIi2AwdZ0QeQU814AFXRecFAjPIRK+kBp7hXQw6blY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783337547; c=relaxed/simple;
	bh=1pydzzpuEgb99srFhSDcm9R9pFLKSlB5QaWbAzMzsLU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KVwgWBDj/8S4QJQTYBTS/X/A3KubsGzAG4xZ+4xVB+gHOs+Qq19x6gvAS0G7IVHs/oC/8KqzT/mSqrF3BqoosBVs0gfB8D+PTuNd6FOJSX2yaUOXDG84WUjYJZf/ocVGtyaZ3CO6IE9NXOcdwp2tZ1Jf9vVfecy2u+yBJ80Z3Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=k/0wiCVA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GWASbcgT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="k/0wiCVA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GWASbcgT"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666AxP7t174990
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2026 11:32:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6TsjOFxinHMTdktlzXIAquk5+1TYhiyxBMyPgakzTtU=; b=k/0wiCVAxdc0lvmY
	AGxukyenVES+/EL/HdcZgGTRO1AxXjMyW1i6e72AJxhmGpx6vVwCMxyCBQD3tCSX
	MJP0/Z1xXwVUN0ddLQkuAJS7fqQS1r+aVrJ0tryEYgH0iCYNX6KnNdWht0CWdyu3
	JSL55dSaFtvBioX18YENlyF0MCR4G/kDj+hIrFJgUtPgTcJMLsH2+m1nIHOy+WHQ
	NeXrnnf00q32PMAIV7IFbmP0ALBSogjK6uMkL90MabD+/vG2JZV28IrPHmAmJuWe
	Q9M2aKcpHaFKus5eD8cocap0TgtWz0elN6nYIX1eAWgrKo5QER9vmzWre9cWnqPA
	ik4TLA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f87rxs149-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 11:32:25 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c890bac374eso4535087a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 04:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783337545; x=1783942345; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6TsjOFxinHMTdktlzXIAquk5+1TYhiyxBMyPgakzTtU=;
        b=GWASbcgTFl2E7Xx/6K9iH+taMmNk608gVb4dQRfM5cJQ3/j/8R8/TsKzxQs83JuUT8
         E27hlQcujVrBzl8llU4k82jivhLRil7Rx0kqtltsQQ+C+8y81FvzknOq74QLkekVONtO
         LF1IuMDsPQAf0svoYf+xiIpsaeZVJAdubzzXCZ8Nwo7JbvW+SWRiELMUHXNECvCEeRHI
         0KA9N3tbJpgnT55tC98vWkTy7/7bgz2nOemI4b0ne7430fgMPyo9B442iw38JQQu8sAl
         QtL1xKnuwArmh8lw54qiWkuA0z1yHZgH6ooCIf7hoSXZ77yoeb+8+B0O//AtEv3hZRt7
         n/tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783337545; x=1783942345;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6TsjOFxinHMTdktlzXIAquk5+1TYhiyxBMyPgakzTtU=;
        b=gSuT70NiAuOMq2jsyNyIiJvvP08RpL4OHwUbZBetmbM/6nYSwuOSbJZ36JDU04pAtK
         zF7A1xrJ0oBneBOs/KFf8iV6LWb6Bo/Igc8h21ZYqqL6gA0LQukCU/tsxlvMYfwqUyCg
         BIO08JtFlcPiI2yrioqt47AHN9QVM7qUnnqAqzC0OnE83QLYW5F5Gls2uMvbtH1VHiOw
         l5B4eTd62p7/JwYtThMqNVEqnXM2OS6lsXmqeKLVxhjjLd2AP6bs/ft6UvHXB69qALo6
         GrS+2o+csCCWIzAMfz2nSGT9kH8a0qhoS/2SYkuIBKi4Az9y55FWT3n+qR5vP5h8rNQV
         n4tA==
X-Forwarded-Encrypted: i=1; AHgh+Rpc6Rva8O3RMmt4Qc8J9Ujk9nAOSQAUhH0tUFn2FzRNfdYWHrjnvYff8fROXODo4zAYXk/rQoW63CJXIyk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJUZuewNjhJrnUEsZqkCPvpLRU2qOuMxT1/XW8F0l6I6chjxnE
	Oand7Mf3Wk4snr9yDKarl4taT90C7QAO4Pe7ixESxLFIx7qvkm08uHoYQxRcxvxedXg5u+rDM49
	PourAApo+l+oqhafqzPthe084Sms5WjsGIjkbsHeN5o9j+f9SMDBhy36R0tCviAcwJ34=
X-Gm-Gg: AfdE7clqVSirHWMS3cFSpXo1oAS5Wf2jE9DkkOS++GYTQjKosE16QjOdoLTgvAuzsbl
	EGsAr5/dc6nkRBAyC4h2n9SU4g/ltZ4xgEaDXh+7FISo7MMiWqFhEw2kih/O0KVXNRYfQ+iQqG3
	y0iku3tYWWKpfKHUvtEF4P57lBMsTVvZW4nPpHliZj5OeFTRrkLaeAe12pQLZMWwKqu6z7nsCey
	E/c1wTxLF+DNdUEnZzAacYCwYSXCay7QbbmAyfCwoFH98b8t7+UD6MQHt28qviZPaLlRng/f7VI
	fT3JDyJGtlY3uUz4oiZ2uUX4Wbk31fZFe3vX9+wOzs8Xrm+ycYekTxwKm5JktLagnO2g36N7Y6K
	TPlvJhWzY9H3QBQxItEaCjDkCktnV2q23TbBLzvXJY6nX
X-Received: by 2002:a05:6a00:4501:b0:847:84b9:f3e2 with SMTP id d2e1a72fcca58-84826f0df14mr86397b3a.50.1783337544442;
        Mon, 06 Jul 2026 04:32:24 -0700 (PDT)
X-Received: by 2002:a05:6a00:4501:b0:847:84b9:f3e2 with SMTP id d2e1a72fcca58-84826f0df14mr86360b3a.50.1783337543972;
        Mon, 06 Jul 2026 04:32:23 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6dbdc8dsm3576621b3a.55.2026.07.06.04.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 04:32:23 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Mon, 06 Jul 2026 17:01:31 +0530
Subject: [PATCH v3 3/6] dt-bindings: crypto: qcom,prng: Document Shikra
 TRNG
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-b4-shikra_crypto_changse-v3-3-23b4c2054227@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: fs2ZxYQrAaMrNPA9NaM4JUQlUhErU9-C
X-Authority-Analysis: v=2.4 cv=Hv1G3UTS c=1 sm=1 tr=0 ts=6a4b9249 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=mVMjwrqIa5QPTF8STQQA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDExNiBTYWx0ZWRfX+QeZ88CRDp/U
 WGNjQUcFH52OyPFdFq890KZvPxrSDqXv4qoXfhm7IUm2pvwq1O/OgvZKGZy0TLmtSxe8jvzCaSM
 MkfMTsYAr5PCKahTV0zOUpApzpDOwqo=
X-Proofpoint-GUID: fs2ZxYQrAaMrNPA9NaM4JUQlUhErU9-C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDExNiBTYWx0ZWRfXwm06uB5Mh2Rs
 EAyUOwOLyx4RurFrvJpzDv0l0+w6tjr0qF8Q6IXnQOTlBhCQ9rxwI07YdZXdAZoHOAMahZQur6U
 X3rJS9SOgQs0sAXi9NPKXm8ylVcZ3oP+PNYAjkfS4u6dzEMmva57Xpx1tV1z6Ae3z9SHtzx6oJQ
 Gk6Ep3J7jH/dRMDIvpCRST8ft3lBr+2y6xxdoPxeD+D2NYshVv/VZmeeTrJYBWOhK2vFUhBU2w2
 x6xeS7+Vv2z5mA1EFDKzUj5TbqbNIr7okU/NNvlCreZDEuU5LbDtxsRKebT0b6B1LBlOTDwhMvc
 GBttUnw4ffy3X2bywOOi/481ZZJYgdJPUaCjlJMKG3zSQVCvkAUoJi6pAka6TQFihZvmOsbPWko
 elORKsAB9dES9CY6mc9Z7uNkSkz9S3d7OgF6tJJg+GXhxLcfA0aRxGVQ5N8kwlMS+csGIwv1XQz
 hrXFbi2RSZQq643lXRg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 spamscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607060116

Document shikra compatible for the True Random Number Generator.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index dc270c8aedf3..5de52d7a745c 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -30,6 +30,7 @@ properties:
               - qcom,sa8255p-trng
               - qcom,sa8775p-trng
               - qcom,sc7280-trng
+              - qcom,shikra-trng
               - qcom,sm8450-trng
               - qcom,sm8550-trng
               - qcom,sm8650-trng

-- 
2.34.1

