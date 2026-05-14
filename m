Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285463C9457
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 20:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778790629; cv=none; b=F5Fbf9MgZFiiM/GCREhJggfJD5TmccORVj3+xmF44SLg+Kg/p8hLjKn3qBc6wmBTe7rJk4X9idclwEsZLI85OCaAjH6tGMmShm88g7z3D75pX56iSLWj+Debb5oGgr1Wb+qIh1XZT/lTybx9zhkJV6cTRJ8DZt9z3tmhqxfB2nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778790629; c=relaxed/simple;
	bh=RvUqiWlt1Ergu4NMH0uwjjsce6vuybjCzM+VDSmAESU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QFxUrKrCqc3GrB40auZMcv0fWXCEVWfxbOxl2nUZ5IW4SAQBM0yw55nFOS/ZG6wCr6eZvojcryCvhUS8cujNGrWWiDdl25Y5st/Q2Sz/FyVLD2tJXW3LBMst+EOvt4WN5gHhoaoIzZX+UvZQYNwBfZAhURpZCx1VadZm/iXT+0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SlGE6xjA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Y4LJDzvP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SlGE6xjA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Y4LJDzvP"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64EIpbqQ3671116
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 20:30:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xhsrID1K825RqNqJYg3J6AtzbVLQFOaNS/VEzGY3CqI=; b=SlGE6xjATffQwsgQ
	9ch/9EftiCTdDcVvw1ld3h7vG4h1vZCc583h1/qFE7iwM8UoLohzOcppQXhXunq1
	RoK7gDYlTDS8iI/n0JyC/Tm6X77EQwIF/eME4JRzzgBXfRNwG/9vuXrdiM6wBXJ+
	XCqjYiplFTZcUBxrbbBFBWwb940kjHSYMLMeA2Y5HtCqvGd60TIaA1JlvLcrg63H
	a8+8mTvKQ/Dl9QauYgLu/YV1UwfANxuIPeM1GZVoYPQMBpBSnPl0JiNii4mvpf6v
	M6WjqVlsK/jLNpGCay0VZEnbInFerO1qUDC5zSvR8uzoEhwaErc7B7rX+2fygt92
	94Q3XQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1s0abt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 20:30:27 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c823549b1fcso11398124a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 13:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778790627; x=1779395427; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xhsrID1K825RqNqJYg3J6AtzbVLQFOaNS/VEzGY3CqI=;
        b=Y4LJDzvPsBOhtBf43zlkTg/fkkre9Lvgz2IwTQrMBv4Z/S74bl/krWtdEvCF8HojhB
         amxfBe3c7jT28HExJp5vndYYUsV+iZMnTabzXumy3tuGkTl9X7YfLxsgHUWBleGN3Ftn
         hObvO+za4BMxv9kK8JCpFcHy7E99uSTmwSjk8INK5EIzQz4O33zLg6gzgxREWklkquTx
         YNMZvqtQGBXfatKul0LVO2NaDZ0NH8goAOht7lP/7cHFLs9rxNGdGzCwifdr8KhcqKOw
         oPk15KWOTqCBPqdhTZMQUqAxVGZ4pLNqThmOmS2P0/Cezv6WvH4AcxNxtl4+2gZWg9bi
         eKWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778790627; x=1779395427;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xhsrID1K825RqNqJYg3J6AtzbVLQFOaNS/VEzGY3CqI=;
        b=dxFhMb2QKTy1xmObX73zRPTbFMiyKtLdnIt7pcbZWPNOR2/zqLxsCJw7rRkTbwLXxS
         ozLrdkctBusuyJwv+J3K8Ffo2yBLGVbvuaKcT/I/xnQ1qW8BCrok/DkRb+nOJ46zUAlm
         pOLTfo6jEDNyQSrRUYpoeflFDQsLFxPCwX+zLI8pYCFdD0bFpG2meVGgpBGaHU5EI95c
         9AsXwc4c5u5j4FWggXsExVnJRRq/s54TlsyzuVKMLqZeqBXmgprn7dmU0PInN94V2aS1
         g1H3dkt5XuS8/2sG0Xo/jZt2wZrfeAkvA6UkdOujGGgCbeXeL6irF/3XjmDrd+2lhnmK
         pCNg==
X-Forwarded-Encrypted: i=1; AFNElJ8FroQrIfho90kDfB3DAStrLlZc7o19TjXX8s9j3y+SbsJauxeQbq+FE0Zgd3qK1zb8QAH1aHrYCk+GMFs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYZVBJctYrNI4P7wzx/KN/kyaJiVlmZ9wlzUzRBee8GAUPN3KH
	8gO5G3HoCY6apBh0IZiLlyiJLfalEL1JJenm3/qVCMU0+crlmNv7jAVTZNS9u0ktyTGbDKkzqH/
	XIzTm4/xKYknD3YlfLr5Pe4g/bWGhZMdnUc+9PnL+J/uRMhR990v2Y/DFtVtq8pb4Jx4=
X-Gm-Gg: Acq92OHXiLWBPXmeRMEQgtdYHz/7sLn7J1YsygvbllRxCIzTGDIwVuY+A2OM/9DdD/w
	vTmNfSgVJ9ME+LXDFFJHY9RUGxP4kInmSJm86x0L89rD+bNkwub91+WWt3OFiTl3wPB0d3+KLPd
	vQntrvfRSRISQfs4Ne2sHaMGB4pYVszX86fdjStXCWDVyB0ei3ogfrPERAw8TCGwntHSXWZfXwc
	khlFT9KzHNFb7stsSBLhVIxr/vn0fEG1z11QM15lwvzIPeDCMLjnjLJoSQ7GaEEqaWTTgG8xLqL
	QAj+C/utY0B4vBVsEeXaZuhJrXsxFV35uZ/biH8IVmbUNMhJFtc62PztcgbOamgrqwD4zBwkFqZ
	DIA97gPJyVL8kI1kG/aeRrJY1v2Ce7bHmbr12LtCS9Ysq3MsT3Zaz0oE=
X-Received: by 2002:a05:6a00:3387:b0:83e:2eb5:b196 with SMTP id d2e1a72fcca58-83f33c344b8mr1153370b3a.26.1778790626817;
        Thu, 14 May 2026 13:30:26 -0700 (PDT)
X-Received: by 2002:a05:6a00:3387:b0:83e:2eb5:b196 with SMTP id d2e1a72fcca58-83f33c344b8mr1153333b3a.26.1778790626335;
        Thu, 14 May 2026 13:30:26 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19664a59sm3666952b3a.1.2026.05.14.13.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 13:30:25 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Fri, 15 May 2026 02:00:08 +0530
Subject: [PATCH 1/2] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Shikra ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-shikra_ice_ufs-v1-1-b1b6ced70559@oss.qualcomm.com>
References: <20260515-shikra_ice_ufs-v1-0-b1b6ced70559@oss.qualcomm.com>
In-Reply-To: <20260515-shikra_ice_ufs-v1-0-b1b6ced70559@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDIwMiBTYWx0ZWRfX9A0sRt9dlIQ0
 8KMR5joQ/CNbJPeRjAB50JhZ0aT2hW5vyxGm5ZceI7wTQeElZ70CTi7aQKbYmfbiUTf826/GYzE
 IeEeXl8aEPEpJFyU7Mb7Lguzv3IQojm+0m0y9w7DouUibx55GdAXHssAApKQkFzfWkzPDPdVDaY
 pNmXK27fGHlqWb5rNu4ALZ4zVDc5nWv58E1wl/nFZZBfLNP4XMSSiDPVux9XMqNWWd/0hzKBTAP
 mIpUkL4YmnzUCy7YfQGnhmO74c333zCiaBsBCozRKCw0EvbnYRMKi9YKw0+af8W1wkpXsD/PCTD
 4hoT36vu/IHjKXHW59vnGeVMMI3OHb/G8ADXoUaEi15w9jFWlHA5MKIUNC0q2SR7KOUG5aTgWQt
 o8yIJ3rSM2cGBxnp7HzCUBodB7xJuKnhazEjhBAn0Sx3Mqu7TyuJjnF7esNakLvUu3ufCp70uGx
 fuMrGfsRqiGLPEpo+WA==
X-Authority-Analysis: v=2.4 cv=Md5cfZ/f c=1 sm=1 tr=0 ts=6a0630e3 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=twW8G0p2hbz0t8568-wA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: YeY5U8Igb1wToomwkgdmc2EH4qP9HSXv
X-Proofpoint-ORIG-GUID: YeY5U8Igb1wToomwkgdmc2EH4qP9HSXv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_05,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605140202

Document the Inline Crypto Engine (ICE) on the Shikra platform.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index ccb6b8dd8e11..c0b083da78bf 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -20,6 +20,7 @@ properties:
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine
           - qcom,sc7280-inline-crypto-engine
+          - qcom,shikra-inline-crypto-engine
           - qcom,sm8450-inline-crypto-engine
           - qcom,sm8550-inline-crypto-engine
           - qcom,sm8650-inline-crypto-engine

-- 
2.34.1

