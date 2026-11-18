Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794985239;
	b=1l26WvbeMgV31O1JIuGgTVauQMQgaEI2KjUXanJwJ+eAnc+OTVR16QhysmZTBm4GJB8S
	 Guzdr07oRbodb1waR02FhyX6Chp8j2JfMCC9OeRv9UmVZ2Eo6Sa08azuB85R+9oSfVxVM
	 kLwpWjlNs7BswDNzdCkWySf1f9Yrda2qAdyUCDU5bMmOLk37U0NqBVymJniRbHx4t3Wze
	 7XDVU14vkClTvdyYwoZLCv+ifGfI76cotNbY3qyRztyLo3oSL7h929ozTadKrtKP98LFR
	 tSQVZHFTW12Y+cKAm9aLHtqZNcjjt47h62rIDIGvCAUh64vOt3sbVGxCYFQulSCwasA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794985239;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=j5kdx6NAwXYQ+s5wwaFpxHmeZDnTcIjhOIZ/bjBA6CU=;
	b=j7eTbR6UAdINp6vExt5R2bjmCZudoazqsB4q87ApJyDEIeJu4V05XpPhrOY906l7G7Av
	 VVhGzT0s6qUe64fGNu/FeLGRxcMt9G2r5sN2MXH7dzz15aJHOSkhyFJzI4F3jUV9wsG27
	 72lBvoH9p9XMf3cBF71lwmsLfid0uqICnKyd18BQ5sZ+3HhE/sGI6lVzZqpwk6C4H6dI/
	 tVFHJef0zJKCjoV593zz2BT/8XKFDoOflJ5xLUf4eyHbLIekauoNIQBeXL+A2XoDbQc1V
	 Kz/FWN6L0kcjkzL69ylRn+5GRBa9QhTkshujoF/QoTdvWpCTxwbJJzSezjUld0gxaOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=XYsIDQUD;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=esdnwFZ4;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845DC606A32F
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 07:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 845DC606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=XYsIDQUD;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=esdnwFZ4
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI2UxP21430529
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 07:00:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	j5kdx6NAwXYQ+s5wwaFpxHmeZDnTcIjhOIZ/bjBA6CU=; b=XYsIDQUDcnIRxC4e
	rKcO48ZiJuWI7O2yuqilCetwKDSvWa4v7cH9BCD5Q5923xdsOa0GzcNrj8Wdda8R
	RnTNegNGDOrZyrUxyJtLBNZOVCBQfD+pkD4pL1Fi6hglTi6rrzWmQTdKyphS56RX
	CGXQBwxc6WOfL+k5yn/ozWXwBlDsp80SqK/+Q37PinhwxnBXnF9Q37weBIw43Aw6
	4dLL2sIycTnGppq1DfYssbusr69y+r6NR/fJeg6fyp71LnSgCG5YIUw31EbRn5oc
	Rlj+wg6PGM0HnkkH4foChujx07znzDIQWctWk/IWbQsHYh0mijyg7PlYHJb6fDxc
	YE82Lg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j0yv91q1v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 07:00:38 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3aed37745bcso1508771a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 23:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794985238; x=1795590038; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j5kdx6NAwXYQ+s5wwaFpxHmeZDnTcIjhOIZ/bjBA6CU=;
        b=esdnwFZ4G3+kF2oRddDkUmzyKkFsob5QvhXLe+oVFY4GJu+pLzoXvckjhi6/jbxp2A
         CaldhaisVRArA2mcIW3qL5mtQ7eR8Tm2WcShnUTRLfahjBSH57WdoduvRKjkbNEFoCNQ
         mQw57VLLI+jF9DsvhSVd1gWjQ7H3nA5pycWL/hyMipBsXEhLa8WODj5i4KS+WfTk3Wih
         M5ABwaKUqQbe3MDIX7gJgf9lZFgC93pTcNROQPw+qJbW7Dl+m1GrOrI7uRwECqQ4KQ5Q
         FA6rZipwjavl4MEDs2NXKIic85hQhExAydB0yhjtJCEZUHrhdQDCm25PSxq/FG5n0i0M
         xmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794985238; x=1795590038;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j5kdx6NAwXYQ+s5wwaFpxHmeZDnTcIjhOIZ/bjBA6CU=;
        b=aaRJIDHQBhtheojXIX5zZvdHcHjy7sv8RGHGyWctf5NYWgXuvl9yd4/AMm0dPyDt9t
         FuAJKzdwa7fKMBKUBORSrKQiNyScoJ7bib+rH/7y3jVAZrADGbIAYAm5OX1ZN1NTW0Y6
         nVFjSt7QwmvSzJQhb3ujecNpuBbIHw5+mESXEmPHyDxgVQ394nBLqXq/N7QuJXraSuaT
         +euhqg+ph6DsG2oYCFS596pzRESQBbxhZfUbqPGvAHAKPDT6BkSDMuwA+BBFP9/79n0f
         l3GEFdm1ZNeFJVPpdZ3D0HD2K4QX6DTd8nDCPzvcX3wSbei1JhkMFYzY5OwWLUAW+dvW
         WeNA==
X-Forwarded-Encrypted: i=1; AL+hErE4NNb8ZyQAgdU8PZ9zM6RI3K0GO4xtGqgEKcVryTtP9AtTbH8n4eLjHmMHrttWZkN++SqKgzIH7lBf+9I=@vger.kernel.org
X-Gm-Message-State: APuU4Z/BQ/z9GiSeSapkPyRBJQvVxy6NdduhY0oyk74kl3yVAHUwKhaP
	0QCYXn+ErzGTxBJ+R8UuNIchRSAUstq448QYvAQHWGir04Pf4pt8rM3sf58P3ugBwoKnqlyhyKR
	JyLyGK7cUSM8tmp2iR06EmbGN5p7Qf0o/NrEZhBYEMQ90L23odQ/VzrdSQiRz1yaeM5g=
X-Gm-Gg: AZFdTZdQYhm1LMS9H31cRD7ScWUSsnjNy3VJihWFNy5rmc86h/dxXuNBY0hJU+6K/jQ
	zp+62jSDqZvBgwAMcxJ9XIkp0DIQXm68eUtWlIqkyo902d90aO769lGjx11UYw/BX5cu+LwNJKB
	dUygR14rTs+a8zjYvAH7Pz9eNasv0ENBYrKDGJzKM99R6N6Y8j++I3hJjqUZn75//WxoQZ0fnnO
	B1tAqfKjjDlGtfO5fxT3RE3GTYBZAJiwcVF0usHVWCeZU4873zsFxQ1DldCDx7aGijVeo4NZV7b
	De3EXFoPRIApnO+xVAyoTKITmMDCFbVGEvvuLgvhOQYAt6YhrZ2UcOJCQGfj6bArzgl8ikiu7MV
	JZkT/RHBATfMbrQVTJMZ++WKUYjaR/ljjzT7fW4eJwN5WK6AV38/dLJeV4o5iOVL0/UbVDQB2q2
	+scp2ECQ7UT5ikFMnpalOk/4t8eNCT7nlMBUmaDp56NhDLqA==
X-Received: by 2002:a17:90a:d60f:b0:3a0:d7f2:5a58 with SMTP id 98e67ed59e1d1-3b3d063d6d9mr1237231a91.3.1794985237809;
        Tue, 17 Nov 2026 23:00:37 -0800 (PST)
X-Received: by 2002:a17:90a:d60f:b0:3a0:d7f2:5a58 with SMTP id 98e67ed59e1d1-3b3d063d6d9mr1237210a91.3.1794985237187;
        Tue, 17 Nov 2026 23:00:37 -0800 (PST)
Received: from cse-cd04-lnx.ap.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d1acd118sm2743262a91.12.2026.11.17.23.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 23:00:36 -0800 (PST)
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Date: Wed, 18 Nov 2026 15:00:06 +0800
Subject: [PATCH 1/2] dt-bindings: crypto: qcom,inline-crypto-engine: Add
 Glymur support
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-glymur_ufs_ice-v1-1-2ffe4bb931a6@oss.qualcomm.com>
References: <20261118-glymur_ufs_ice-v1-0-2ffe4bb931a6@oss.qualcomm.com>
In-Reply-To: <20261118-glymur_ufs_ice-v1-0-2ffe4bb931a6@oss.qualcomm.com>
To: Abel Vesa <abelvesa@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794985229; l=1009;
 i=wenjia.zhang@oss.qualcomm.com; s=20250717; h=from:subject:message-id;
 bh=d1zDDePFJIPVs+rwiQvZLUWqDZvC4Pb/+gxCqJ3DmHU=;
 b=95KjsX53H6q18VdjLq1oWVWsUncuKbVOF8jqFhBV7JY0+t3MyJhid+MeXsz/+TG9g7qrKaYTD
 g7tAVxNjs1ZB6WTLp7bFT6SZsHK02VOtB4y4w9HNI+yINUY6rhiAoCk
X-Developer-Key: i=wenjia.zhang@oss.qualcomm.com; a=ed25519;
 pk=Of53/+6KgVgPh1R/xUMTbXVCnBiHTmHby8ySh2ShLtw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAyNyBTYWx0ZWRfX01OjgsvgnIjt
 g20Mg3gV002aO0jxw8Qx3emtGrS2eIq0+spBpJE0QcGW6LSbk/zzcFJwCH1xmyDVBD0ZCRFgfKi
 JfyGYtJ+MQqegplazgl2iTPNJBtaccWYn+Pznb1oJYt8zCC9MYGTTlWZBDGX8JYgwnIpYr0Ex79
 zWcj8EZmmlVX34hnxdi2/gE61+eA6LwXbWAb5CmPfQGA9i9ucX7sP0COS9yyGf080RYybMAG4Mb
 0m2KPKm8Xwa4spQoblU4FNTKhWx0Xe/W2n9CB+uwDP9j8A6nXA0vjNFWVP5FJIsGRLzXizG0pMX
 FNNLOfDRZh7HtRrk4HjtdumnF+Z67DaCZQXY/ZnnNptI6lqgYiVlSP9BT9Nmr+UAa3h0I4a7E2/
 u++lpnoc28GeUgGcbwbRs29X8qRHECq4zXn5vAT50zmg0tp38jFZfBbjYeL64YVYVFLkabF2+hc
 YYjV1eT8cFDrX6eauyQ==
X-Proofpoint-GUID: O_ZSvyDjU5ZwDaf-UOeAiPyYq8fEyhek
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAyNyBTYWx0ZWRfXyy+Di39AcM+v
 ElGfjhaqVAiIjtf5CCAd+I39OkjgjXVSFgjgffVMDCpJDrEAKrwwDLSnExRrZG/IhanJLJNrTha
 03Uyl1450vIJAEHEfiWaC7ONw7jENqw=
X-Authority-Analysis: v=2.4 cv=LuQHWXdc c=1 sm=1 tr=0 ts=6afd4d16 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=B4SCuiGsYTXXqFn_0MoA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: O_ZSvyDjU5ZwDaf-UOeAiPyYq8fEyhek
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_01,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 malwarescore=0 suspectscore=0 clxscore=1011
 adultscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180027

Document the compatible string for the Inline Crypto Engine (ICE)
found on the Qualcomm Glymur SoC.

Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index b98c4c6b77f05a4295b7225007187a7b05387338..01a1a36652d759610e36d5ac3ad56f4b2d45b96b 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -14,6 +14,7 @@ properties:
     items:
       - enum:
           - qcom,eliza-inline-crypto-engine
+          - qcom,glymur-inline-crypto-engine
           - qcom,hawi-inline-crypto-engine
           - qcom,ipq5210-inline-crypto-engine
           - qcom,ipq5424-inline-crypto-engine

-- 
2.43.0

