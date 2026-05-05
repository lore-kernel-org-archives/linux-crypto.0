Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE083AC0CB
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 07:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777966825; cv=none; b=tGIuVbI+TEY6EFPptJ/eRoL3VTqf65cYbntrNhepK/1oGLXB9BSgkIDlmsanpuOvPQxGByFfJGAAl72HDKGXr4UmTaayq0RzXwUm2YJqoXqSXvHmqM/wrcxL4cL0JzQ/kMxxl5C5OWXMY2vUwlyCxYuk2zoYR5PEp/u56F4gZpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777966825; c=relaxed/simple;
	bh=i7K9Z6L1blSo4FLwUqtu/dPp8zle1D63zPXhfonV+ss=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nJ1wPJt0Sezd175tkeUhzPYHPlf6CEU9F1pAAmYJxIncai4UW0XNYtC7YiuUZXyBoqZBJEOF/J4FFtLQiJTTMqJSBfFrnIppOTn+ux0cEv+F///vYx/Uwo2V5R3teC8cqnP0QXNEQIoc1Rhxm++EARI9cbpyNZEah9uCM9rMep8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FDJaX11b; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ScpmJ4JX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FDJaX11b";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ScpmJ4JX"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64500HqN1346341
	for <linux-crypto@vger.kernel.org>; Tue, 5 May 2026 07:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TqPIJBKBW8nnQg6FOvU6D7ze4pCjVpw35+JGo/GcuTA=; b=FDJaX11bsQfPpGuM
	v7L8BpGBbCIHCUO0CxU4LGJ9zinwE1+NLShOL0S96CXgFVmGHgSDqeYQUVhM5hwx
	9ycM0mRpGKCZ049daJMPDAOWQittDI414JlS8EoDYAwYNQ8fADI4dOaONPqN5vPQ
	QI+wEhBNw7eaHD+c/hk6U5Sbq4XnWkQhPwUc+jOZj9gOfdQAwqGHmwSNKE3u5Q2h
	uO+kW7dxM1US3EY6MA/9JkcIXXf6mLw/a7vB9itwZUSrCO5mdmeteAN3bJYqw9zz
	lMnCpS9+PtGDzt1qjWK+PXXnnLgTjUuWjJfbeyG+vyDISRBkm3WgcKPAg6MkJIGn
	0UVCHQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dxx2xaybq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 05 May 2026 07:40:23 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b4654f9bb6so53012765ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 05 May 2026 00:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777966823; x=1778571623; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TqPIJBKBW8nnQg6FOvU6D7ze4pCjVpw35+JGo/GcuTA=;
        b=ScpmJ4JXG+e9VHS79Dr/MLBCHx9VewNVuVqN7Nh5bByPbofc07IyiheSrYuL0/xA/h
         cS7Ns7VkZ86P8H7BjYUzS+8jrIrqi1kQ1k5Jk+8yBjfoTo9GeL2TTaWejNH5F0oima2v
         V2bdSRJQoORR4XQPIfJZgcTvj9+Rkfjq1Irahg9AWdwEwsnl9NoUtWNIOZPeDBVUhQZP
         HwEvLt0cC1CMkFINUZRZD1FT6OW3fLrAOdWGeYWSftAquyu5HPXhmEeReUR2VNM/hAlq
         N0MvtL862AxHmqPaxDvNdQue8h73mZh49hWI4zPgikofL7rWQATxt7UNzrG0F43r+gsf
         9LtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777966823; x=1778571623;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TqPIJBKBW8nnQg6FOvU6D7ze4pCjVpw35+JGo/GcuTA=;
        b=NxEXzf+HDzLf2KNig0vaUSnU4em+txnf0U+CeCMjYtTbybBZwXOw7BZ08xJyzLlFRD
         HT0sQFYf90v9MoIPq491xkJH72nE2x+UOsHuXgSaDnQ7DFQQdfx903y9cXEuZPmxJFt3
         us9N+DIlnt/L/9WW1vBeBoc45BsUf9cp8X3a3ABtOzc7jGuLuRkNQ/W4o43lqEVIlUrs
         b4yRdbEg60QqFwQzyjAZ3MFgNO9+2h53ziVTDwJI2de6N7Z6h8zmSk/os7z/J7hwPQDj
         ETnmV7ifNx5GDnzo2btYFWXL2VO39pYRcqH01XrSCxaQscK3kVzBd6qQlhqDnVcYRQ2Q
         jShw==
X-Forwarded-Encrypted: i=1; AFNElJ8zwkWIk2yEfrncQ61XE8Zc3KKmRvIPUgAHTHxkxcPlD6s8Y+wA7Hm/ahbr7fv9c6Dtmi3RMbR8KEy6Gwo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvM6kp7HH1Fn++bLW74l97eZktXuXrnDAhwxg49aXdNM2a3t8j
	7WZHrXpLo6L+GqlZGLz37kfxCedBI0YWZoRf3MxlGA95U0kv/T+UQrtya9mR7kjXpoMYBLW4YU6
	a/Y0CSdI/5fSUs3DSOh63/hzTKFftsy8U0KQezdS2trUn0SH0h1qpJI7RaFIERK5dOAc=
X-Gm-Gg: AeBDieufYd0xNfy5a9BZxLa8URXIFReS/7N83/Rqx0G4t7EuIU9abfX8XInP0R4ujit
	SgfOAVnMqczQdBO9z3BNeGCTtQWbNYcp8VOHI/DFvYd+4EuY60zex98wBxbjB5avpgruozCEm1j
	RQInyFRjAjcg+y1+YX6ILEt6kNxa9sH+3DGhlrBeJ38284BjuMILoM1WFSDl26nm2v7vvgADSsk
	25HIxaG4x50EGNh/mtFL7T48q9p++Mis5dHfs5uWSSOJNOHRTuh/TpcxjXmJO029mYtQJpnxJkX
	J3yDLhK5BqYLjxCO5ybemBjDnAyeMiWaGK0mM/Uvi5F0TrqG2XFV8tZmG3Z5AdBWAy0BmpDwRj9
	P7un/fMhQnkXMe6FavIye/+P4EOSIWja6qwEqMlxAdb6Fm9eD1EmmS3PUTQ==
X-Received: by 2002:a17:902:9897:b0:2b2:b117:1e1b with SMTP id d9443c01a7336-2b9f25bd9a9mr90911175ad.17.1777966822859;
        Tue, 05 May 2026 00:40:22 -0700 (PDT)
X-Received: by 2002:a17:902:9897:b0:2b2:b117:1e1b with SMTP id d9443c01a7336-2b9f25bd9a9mr90910805ad.17.1777966822333;
        Tue, 05 May 2026 00:40:22 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caaadb1esm132663405ad.20.2026.05.05.00.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 00:40:22 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 05 May 2026 13:10:03 +0530
Subject: [PATCH v2 1/2] dt-bindings: crypto: qcom-qce: Document the Glymur
 crypto engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-glymur_crypto_enablement-v2-1-bf115aeb1459@oss.qualcomm.com>
References: <20260505-glymur_crypto_enablement-v2-0-bf115aeb1459@oss.qualcomm.com>
In-Reply-To: <20260505-glymur_crypto_enablement-v2-0-bf115aeb1459@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777966811; l=802;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=i7K9Z6L1blSo4FLwUqtu/dPp8zle1D63zPXhfonV+ss=;
 b=zBaxGUh5pfPuhIRSAZnWq3SlzNJU2ziM6386cvXRVJd2V+JFXobNCfc4Y+eQQQQ5ZofCriZW3
 xt0pdqinOL/BJarOnv7tM1FBKJfk/0SUnp8rXfBOLuUzfpI6kHtGB2x
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=U9eiy+ru c=1 sm=1 tr=0 ts=69f99ee7 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=Hz3RRZfyAQ8605JJPKgA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: JwQeaTzj5ZilHCQB4gVm0JJJR14ZC8ai
X-Proofpoint-GUID: JwQeaTzj5ZilHCQB4gVm0JJJR14ZC8ai
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDA2OSBTYWx0ZWRfX5S16ue8yFKnH
 ySV7c0W6TGZITRERHPSk9bsM1OgVsFEzIo+RPasBF+OD1Qnx2yTvI4gOQXyhmQBpKtIFLewTw0C
 X2aF8q7Oky1XjmjaFyMe49RPUCzUo1/7Fs6ni3I3QLWH05CQDARUHl7gj9XkzDjY7HU0drLwMxy
 OiFMRwDqXFLGHXYo2WUJTFImXVBRthjk3j6+anQExtnR/OpP0pGs+V6im6Jt97PyW4u7xRwwnkN
 R+dJEA/NBud2pYqzcLNjA90n6AQA+rY7Ads3hWBnGtPPHzR+xffIuwdQOJV1rJCCJRZDaacepgh
 kHZVhTAThjeRFtgBDW1DIehBTr8Ps0M6dA7MCcq3rbWQPOEyRiOQhGPDFGz0MgfKiUtk0CpEK4O
 mtFlK8xTQHwz9+YrSYOok21DaKgYGCZ8U1nUWHUG9kz5kEo4O0m5hP3AvvHI/eWCTgNdLv3ybJJ
 fzIBe4zpQ9fy1Hv2dMQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050069

Document the crypto engine on Glymur platform.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 79d5be2548bc..0b62271f8bfe 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -45,6 +45,7 @@ properties:
 
       - items:
           - enum:
+              - qcom,glymur-qce
               - qcom,kaanapali-qce
               - qcom,qcs615-qce
               - qcom,qcs8300-qce

-- 
2.34.1

