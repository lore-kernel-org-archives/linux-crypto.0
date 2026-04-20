Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A7D38423D
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 07:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776670457; cv=none; b=NMFzopfs8pD+h/rfQmz+C0AiJGPqkhle2P946rgjZOUd1WjZrAGYolSJSVzhRiS5aFfewQOZ5KQrjbSPepJ6PWfgpZB2VpaUK7ZA7H9kvNMGxFjo8ZHFBl3JC9iohzxwSCDBEE6nr5LxuykngfBIl0wTJZDH6baiikXDaZX6hj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776670457; c=relaxed/simple;
	bh=CSaLB4+lx66rKWA1HMABpkbkL8JeBB916Ok+DqqthyY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z2AN4syvCxNyFleMm97984Hkyw0AYCOoe4upYYIq6zaoBZGXxMqYJJGQIXWcs5f9qtp5UZ4aU4M5z+iBFzzo/cuxnhsuwyG7VLtGaufxSNB6lKHPAEv//1JCFFIzCp7dF3v3dqDWjl6+bBXze05CmbYrGYwcdIvUlom3bGloTTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CAgE+gVk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bVPSztZ2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CAgE+gVk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bVPSztZ2"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63K2kRMp898295
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 07:34:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=KxFF83B13ERhO+7XgUP8mezEJV8Qj/w8oxH
	Q4pf6is4=; b=CAgE+gVkp6yzMJNwJqI8W93ABEOu7uZDkZ/gCGIPZVIQ6l2uVQv
	bxY48LDRcRNCOj9a7QAduHZI2cnLtYLMt/Hh+eUKI04ijnX+jKOi5LTZN48aNT6f
	7PmALc3DUD63qH/I7ib1Fl1nKxmIGqiWCRC0UWuJeLzPfQG6j+UghOFkeYC1U48x
	l6wVjJftxyXL6aVo+2UWaFSHm8pJ9F5uB28LaQ6qiuU6fjfD4l7Xp9JzkU8zCQKQ
	IAUGUlK7GGF/NuwT20PqzTZYOq/MHp/Hu+oStIpEh0WTFxGI6ha8b5SqFnUK6YaH
	cPoMH9foAVL0GudTyTsE0wMoCv29ui/UGng==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dm388mkfq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 07:34:14 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-12c6ebeb545so1847665c88.0
        for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 00:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776670391; x=1777275191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KxFF83B13ERhO+7XgUP8mezEJV8Qj/w8oxHQ4pf6is4=;
        b=bVPSztZ2d9V7WHdanAEDS59n7o+A0fhxx2iZJAd4x9yFlcg3oeFNbiG/InI8jtS4wH
         FbTog+zfpDGgf3hTXg3qZlWmmetsuPmemsHSjPWYmxvLCEQXCIazfOjyIUb4sfWHM8T6
         ovFPpBDNTLlpj0gGMBRaSUrvdoV0fjwLdyLYXQpREyCLSLWCGVBs/wku1kLRzEeF2dBF
         9mnbG0XdoDZc//SPG8ZqcT0v5FfWWzTpxJ5FSk/W6RSusFjfJRwkKRiOv9mF6hWEgsh+
         NpmeU/HZGcElNzSkeBlhbTwzKAMLgKFJCIwWfNj2LxmVGP1uDE5YHf4TjKD3VUq35pIb
         ZRNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776670391; x=1777275191;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KxFF83B13ERhO+7XgUP8mezEJV8Qj/w8oxHQ4pf6is4=;
        b=XoxDXALpuyU/9L3gDR4/byU0cGjisuihYvVvwWTzyEjskRjKDU7BsybBaQS/J9EhGL
         TIFR0etQA4GnN0xaFtiFDRSz4FcQ0CKnPe7OIqgmeiVajWINwVt0YL0L9rb1tSCrheHe
         OmGd/DZoiIYLa6THosJ9uwZ4JQveqK+evkOgzpalmD9jaWsTNGZSvjsjuOF4hQkcxuiW
         KcDxbP2W1n9f+O6BnJhzWC9PslEIy5x/EfD9cq8mLKQcAWq7Wl7KXqTM0M+L5FzzlqjH
         kwmNuguSDZpbNYs37YZIbiaQyGZNlYv223fSmEJ4WNOvK9pjibmBSEtgtg3DQ1C3tfTj
         BaZA==
X-Forwarded-Encrypted: i=1; AFNElJ9CYgHJHj3smHe2gNGusrtUX6zPBWo0OLg36hCNIH+B4NBbUz56Y2H+d3Ni3KdPa99DJptj6MD+QymLmu4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4VrxD+yvhXKEe3zJjVICA2Eg8gUGj30GkSoQ4QVO9ngKlbZHt
	PFYXx4XVkcJMQaandx+29Rfe5zbIuajFaxQ0sb3tZItXJ3FUdo9brLrMpEFthuyJ//UNpGpZNp8
	LW98M5TL7kU8MkJT6NrYNJUV+BQ/rP3vmFWD+HfhrYlUdFE3XGITJhoioVe6f6CRMAVE=
X-Gm-Gg: AeBDiet/JZtP/T+vm1tluE0rtyCpokWyMepBe8PwYE1Y8/PQCYOYZQIqCSn9p8mRdrq
	wjg015IqVeMBq2a+C+cEbYaWpsB9gfarxZGWSpdmMcPclthNVKiRoFIfIzt5cTbiyvZnF7UvEFK
	qPkw63cfj5YmeV1vNxDrSxROJdSvDg/KlWKPnA5QBo2SM5LC57dv61Nvs5h3QvT94tifQVEB1wo
	32svgRacy6apxwQJthbEdaedhuzkkWMq6Qr0g1lpDFayBQVM96Z2uE1+HPK+60c/5maxlPCCRak
	eSkk6c2slEDNh8UDZbFD57InuY9vYZNn7NpnH1wgcbFn7XTdAonW2zUb5bEOboc12BrZFj8kjDh
	CSd+vodEl3/SWgTN/p7pwSUqIGctCV+5l2vOEklVYlX4lB4iTkC6KU1sJde/nt2CwqY1wPSCOab
	eIRS//EKu8y3Clrc5I
X-Received: by 2002:a05:7022:fa0:b0:12a:72af:83d1 with SMTP id a92af1059eb24-12c73f6f6famr6516756c88.11.1776670390773;
        Mon, 20 Apr 2026 00:33:10 -0700 (PDT)
X-Received: by 2002:a05:7022:fa0:b0:12a:72af:83d1 with SMTP id a92af1059eb24-12c73f6f6famr6516739c88.11.1776670390198;
        Mon, 20 Apr 2026 00:33:10 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c749c422csm13714081c88.3.2026.04.20.00.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 00:33:09 -0700 (PDT)
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shengchao.guo@oss.qualcomm.com>
Subject: [PATCH] dt-bindings: crypto: qcom,inline-crypto-engine: Document Nord ICE
Date: Mon, 20 Apr 2026 15:33:01 +0800
Message-ID: <20260420073301.1250197-1-shengchao.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=GthyPE1C c=1 sm=1 tr=0 ts=69e5d6f6 cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=SOTGmrOMbzj5vsbwRJkA:9 a=vBUdepa8ALXHeOFLBtFW:22
X-Proofpoint-GUID: psx49TsTUEKJ2j0Cse8cmLhxZc3jxs3m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDA3MiBTYWx0ZWRfX69l7b/1kP8LN
 xSt4+om107cr87DywH5CJlp8/6W6zOzEkIqNR8i3DFBwlnieDl4uSiEMidq9HzaEsHtI84zlj/P
 ugzEpmDrOqJY/D3tVQ21h0+CHsQsk7qs5i0Ffh2JqzuO0lUm1qgLKfh6MJJtGiILBwkneso5+Rg
 0mPdLTsoFkoJhnoWSOtrqMSVa56tVRS4V+6tiSXLsjRrctE1XP0Il5ncmTFpKEM8bXtFMkDFVqS
 Fc+4/Ji+fYV8eW25EJCcs1ddhXwKfbZcOl8b5Cen+mgJycos87W2nQaNzvtSn7+bIqFKXUheyCv
 OAz5t19lkO5Py1+chDk8KbrdHiMB3h8oILNtRnwgX8X3zzXmK/fC1NZhwNoFUbLJuGdIAzGbDHK
 CG0cIRjoC+uKOn1mcyMrUjNRyJyoQ1+gUgN9ujxFm1M2kdZ4XE+3TZ+P6Xt1a+Gbbeu3jTj897l
 EH1IJM30GoZtK5ERelQ==
X-Proofpoint-ORIG-GUID: psx49TsTUEKJ2j0Cse8cmLhxZc3jxs3m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_01,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604200072

Add compatible for Inline Crypto Engine (ICE) on Qualcomm Nord SoC
witha fallback on qcom,inline-crypto-engine.

Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
---
 .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml    | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 876bf90ed96e..9251db2b8fcd 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -16,6 +16,7 @@ properties:
           - qcom,eliza-inline-crypto-engine
           - qcom,kaanapali-inline-crypto-engine
           - qcom,milos-inline-crypto-engine
+          - qcom,nord-inline-crypto-engine
           - qcom,qcs8300-inline-crypto-engine
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine
-- 
2.43.0

