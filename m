Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D543A7833
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 06:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782715526; cv=none; b=fD2Odm/llPBWW4++yuESTNckALIBd4A2+gsIP3mBia0j6Idh1ywPNhUkIM7GgZaf4PxsTCnIrsWIWFCPeDyQPyJESjBS73XcrqDYRb5xVmh+YRRmkLl/59AiTYjlNWRdqeOveHBzWTN2oRroQyzSel2tKR6hURvnGToPrQHxlqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782715526; c=relaxed/simple;
	bh=xL/9qOPePtFeCrEvuk1rTnwRe+ZVfzTbrOhBn51jvoM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=o1vQiPlKlD8SFx3oBFpsR74cBYBma1jbblDsiVNIv2rHEnezDE1PXk+acaYWJ/bcO953M8EnvvtQA8MDmbJB5tYBsoHnPEDhjtulO6uZtRGDtEss5k/LHvh8gk/b6BG3Xdg4/ghlcsMh+vWZIWmvBh2B+fQ8NSVg2qcj7pbRwBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=V5DLabKb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GTJi0KBw; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="V5DLabKb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GTJi0KBw"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T6C4Yu1969259
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 06:45:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wVp9Zglg4dzVjkBcJglZFHQXwSqvRZ8fm9OhiCgGnT0=; b=V5DLabKbfoNwo7CI
	mwRJ5RlWHC8Nxx0k3rJwtkOIh/tf4YtR0cKK30QnezXRMt84jKUQE9PADCf/d4xU
	+eM62uiw8VoF9MtzLJBtv1cgYlqfUCKAK60DWE9qjaQbYa+y606PIKkL6qgV6Sn6
	fuIyIwGcUO5eeQ0WE6jeqiWIClp61eld2V6ORdKvqCIu9tWk0UKvS0QusiSxaqFS
	tTmOfR0rDDK6d+4M6B2sfSYHTMNi8eBjFQ+HV6ixH9LYFnWtfHLHtsq1wGi2sfG7
	XBaSzGQM4gcjv6rX833bJupIf/fAM52VhRWIg9rxuBEPMgcezHgjV6R/7PMorJ+y
	BkgwwQ==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f3k7vg9fw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 06:45:23 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-139fe708181so1476645c88.0
        for <linux-crypto@vger.kernel.org>; Sun, 28 Jun 2026 23:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782715522; x=1783320322; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wVp9Zglg4dzVjkBcJglZFHQXwSqvRZ8fm9OhiCgGnT0=;
        b=GTJi0KBwdpDa09n4hja+asOA3q9HVf/BsEc36Z7ZZ/f85NZ+GVgwBMKMycT8wnBzh8
         aO+PGaMZ1YPyPM2KwNWJCDUZebymSGyJOB/j0hXM4PdYm1GUyTZ6ih0JcUKU9ZwuWaCy
         5nNpcSZsrbQcnhyy1ir083f0UQ4uauhfVITEpqCqQDnX2VDDiHDJuqq0s/u2owQOxjZW
         Gh+3mEx4JTnh0VNNbPbCf88BJtjOa5L6P4Kqzkde4ctm+9hGJ4uwtW0cy8j82VRNSZIU
         Lr1UVEtFReHSoYi7JGFm9c0RNLMoxY5DhU4a3gNohxwQzJ1NeZnZlfmzP8HlxyZrCCNz
         ewmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782715522; x=1783320322;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wVp9Zglg4dzVjkBcJglZFHQXwSqvRZ8fm9OhiCgGnT0=;
        b=aYMnb1QV8WLX7w89z9rw05q1Lg0FU7Ct+QwqDlEfw1tXsdRl4c+WU30JyWk2Ykdwfp
         0legpLhlsxipKc3e4T9b7nvgZxFeL2LsUcyEWYAeeAUbk3bZPBR+Kyh0hyRYw3E0v9G1
         bBt6kiUbrlaNxC9E1hTS9NjB1xEJ/xGKoxQy0YMz1sFGDeyBCOEfHsER2ohf5CwHgwCM
         CgTd5+XZeijaLQ+s25woDcNkARWS/q5UfD+3u71kHXLpbBdQfpp+SeApcBN+oVHsI8rP
         jGFPM0DNOelfw7qRcmwJklVE7o17pWhazBfk5Z0Kef2bVS3bOed4X/f3MLbdp2chNw1G
         3p5g==
X-Forwarded-Encrypted: i=1; AHgh+Rpq4ER2XUP2Rxw5CIocHpGGUZtD0+8ddL7XZYSA9/OqBrYNB2M+XIRQJzyV766DXTOQIss+SXtGE2bn4w4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG1a/PWwjPQyume8KqP5WS8jwnCGoemj/glQhA+wGd1aS9Q8Xa
	cpvYhPhXCZUW4UieRNoYpcA5u9g5ooQ4sGyWudS+bTaeBnSpDSMwj33fUtcbaeok6XKc1gR1KSn
	vdzTvqcKeiWReB/q5UGIc18F9CUe0+9uXi6T/IeI3jtWnP7fEM4Saq09QkVxadOzaGi4=
X-Gm-Gg: AfdE7ckUF2f/7eELDpAP96ZoUPSw44tt8fw2Fa3Xsyn7i6nzGvrNMtGKH6pFMbfbZDa
	/iBDyGp6K3sN65wkzo4CIbEUBkZAYPZRojpHllV97RBVd8QIxXi1v5xeElSzuuYFGMrbOTGipj7
	uD/B3abeHTiGHDMyLWiaKX1S4r9/2YT6uuIfZDw4qkUGYw9jJnznBi+ZnAGqliaG+axpRyBtnTb
	qa3FadAHqQa34owPJFA6ZhiukOu7BkUkA3bs759lD/0zrd6wUq185pRAnAeMUpv65wmUo1SPjXL
	MTfdctKHmusu85kIAl5fdxgx1EuPVxOlKnQaDHNeq9H3YMLGLzNs+8eOJcygX4xuKSzMElYZ5vO
	13LzWeonMZ4b1sC6WtkzL3cMOLYbxmWSm46+NGmqfRgU2lShdDRS66VxGHXuI6w==
X-Received: by 2002:a05:7300:8b85:b0:304:bce9:25fa with SMTP id 5a478bee46e88-30c84cf58edmr12861139eec.4.1782715522412;
        Sun, 28 Jun 2026 23:45:22 -0700 (PDT)
X-Received: by 2002:a05:7300:8b85:b0:304:bce9:25fa with SMTP id 5a478bee46e88-30c84cf58edmr12861114eec.4.1782715521911;
        Sun, 28 Jun 2026 23:45:21 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c52d669sm43580424eec.11.2026.06.28.23.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 23:45:21 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Date: Sun, 28 Jun 2026 23:44:36 -0700
Subject: [PATCH v2 2/3] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Maili ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260628-maili-crypto-v2-2-f8ce760f71d6@oss.qualcomm.com>
References: <20260628-maili-crypto-v2-0-f8ce760f71d6@oss.qualcomm.com>
In-Reply-To: <20260628-maili-crypto-v2-0-f8ce760f71d6@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: aiqun.yu@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
        trilok.soni@oss.qualcomm.com, yijie.yang@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-3d134
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782715519; l=1367;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=xL/9qOPePtFeCrEvuk1rTnwRe+ZVfzTbrOhBn51jvoM=;
 b=0MpAjM8hw4q/ldOQ0TH5cNJ2JAxqUeToo95zB99B+KCWU64b9qgQ44hAyQzx6ZDkMe8+ap+0c
 uzzRTu2iFtpD6jMhMwF/CKObBHSqSZHacOlBtTc0vyKPX1YtZcmFYer
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Proofpoint-GUID: 2clEpeSL8ifQ_hhUMhyrKHGj8PtK-T0s
X-Authority-Analysis: v=2.4 cv=CqCPtH4D c=1 sm=1 tr=0 ts=6a421483 cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=CB5EDt9iCFRIAeX0j-YA:9 a=QEXdDO2ut3YA:10
 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA1NSBTYWx0ZWRfX0BDlU94u9zo0
 RJ4BSd7YSQbdWjEjks7ldVXveCSFKhI7jP4FqUltUf/26HEF3EeE383gzCA0Ik5LQMsX5SyQTVR
 59OIae8qrpnbe23OQnDmizPnsKd+uPc=
X-Proofpoint-ORIG-GUID: 2clEpeSL8ifQ_hhUMhyrKHGj8PtK-T0s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA1NSBTYWx0ZWRfXx63MKbN+A3rE
 iwhxB4L8NDXKI+dlo6qB8cn2C2Z5VsC2opOOjVJ0tOE1cNpyGIdbqNO/0f+MyC9dHg6EWIEoeZC
 eQtD5ULe721a+vvEuekqK+C0NVIzxOtIiQZgHrvCxwbqKvO44aHWTsPmx+TluQacvo4hIE6fE1P
 ZFgTWOu7cDTPbeJVYm8yqhfMDkpzNTc1J/dYLJNrQRni+ZS1iQFOqPSZoBabatLl8eZlcpLlc0l
 d8fH28FUB1/EX8c48PZr8cBdSfyE42nDnoGdWAHclhmsJmwRuaWKVf2oOP+VhRXp7+vnj3wDAQO
 MDUDMwOD4RiH145wi13ChBww7/t8h+Sl7yn9MU7LF+sErxnWcg8H4HfuEgzef1IjKbaq326+5kt
 A3sNQZmW/znPoMzKvr5qhHegX5tGr8pJViaSBePcWlQ+p1XI3LsvVImmnMRgds2wPYjaMaz+heF
 cGZ7eKOC2sKGFs2nEcw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290055

The Inline Crypto Engine found on Maili SoC is compatible with the common
baseline IP 'qcom,inline-crypto-engine' and requires the UFS_PHY_GDSC
power-domain and iface clock. Hence, document the compatible as such.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index db895c50e2d2..d80f8445393b 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -16,6 +16,7 @@ properties:
           - qcom,eliza-inline-crypto-engine
           - qcom,hawi-inline-crypto-engine
           - qcom,kaanapali-inline-crypto-engine
+          - qcom,maili-inline-crypto-engine
           - qcom,milos-inline-crypto-engine
           - qcom,qcs8300-inline-crypto-engine
           - qcom,sa8775p-inline-crypto-engine
@@ -62,6 +63,7 @@ allOf:
           contains:
             enum:
               - qcom,eliza-inline-crypto-engine
+              - qcom,maili-inline-crypto-engine
               - qcom,milos-inline-crypto-engine
 
     then:

-- 
2.34.1

