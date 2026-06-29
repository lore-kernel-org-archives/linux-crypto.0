Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C2338AC83
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 06:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782715527; cv=none; b=gU+ON3S2MRJjiSdLgxlqvJKwyigpYIKkW+ImLRfv1hh6otZlG0/TQm8RmAjy6gjf1JJQEzCCFN4/8H8Wc2PRjIXe6dnkDW3OB4kSUdiU6rfVccQICfpElRJO2INBdBGzVW+QFa+PsLXmihnVVIQvuoqgkHeMKceJe/CeKqqmTmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782715527; c=relaxed/simple;
	bh=ib5g92loksXZmXiRdLEH7dcCqaG6DfiNxrgUNVm///A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eu4njMuiK5yXoDa/MrH2oG8ynTaqIRkodoM1eBrxux0G5Gqc5Ct8WpiVKnrVU5k2SiNGoq61mIZxjXh94hGex5V7AmlAnr6elF9QR6KWoG3IYYfcqN4VjUYOrofwAc2QH1nHwDuMpRA5hRNp18aLyLSW4MDHO3g3O/ZH0DmqfbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OtG7Mic7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YzErfYek; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OtG7Mic7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YzErfYek"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T4NDX41772176
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 06:45:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2qwmS4F1HHI0MHwQbDiJ79yyIP1FA8QXvJV7bjonB8w=; b=OtG7Mic7nvxsywt2
	hNO3qiWD+4dHG/9l2Lgnu98w4P7hOLaI1HlVDL4TWQmnK/PTIhmUU2KZagpOX09M
	kX+0a8EIoSIYXdEXh5T4jetUNtKk8J7KaUJ5B+QxLhvj1Ct7D7NlRxKr3clZvVQY
	hb7aAQjsq8bnEy803Q+A1wxyyIWqi74bSr2FBsUYKYczsvyk4rp2RdslXUSh2fJN
	stUlS9PGYtjDjAkcK/Lne/MtXcAC2hprihRz5GjMQD02fh2t8h/M1TRqRpQswtu2
	JR0Ba7t9nBIR4cvbUpeEuNuaadYGdRS6TBL92nT0nmkeM7vLe+jSvIt2OF74GXle
	81q0Bg==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f27085188-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 06:45:24 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-30c1f6c5559so3352780eec.0
        for <linux-crypto@vger.kernel.org>; Sun, 28 Jun 2026 23:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782715523; x=1783320323; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2qwmS4F1HHI0MHwQbDiJ79yyIP1FA8QXvJV7bjonB8w=;
        b=YzErfYektzAQz6ZyPXybBnh5mbA8SGGZTFmID+mWFNsHqTKZTNWIiTT7dusE7jwJtf
         3d3h5u2XY6GvtgXRykwaEe8uljMzKEX9OpnSUSVptTqiAZWpw25KWfia4ii+mUf2RwA0
         8R6WSgiBhoW/Uu3/i37GmzsSx61XwqrYuJQ2o2ByzyXMEGx7UAqCq2XLGJDou86Oi7qO
         LKZMUtKcziWDsN1Mqvrh8SEXgd8CL5FcZxOdP9p6QypweZ9a9XVJZpTgb//3WBOfV/JU
         6+eLKEamk/J0pNfiwNIBhSjs93fAiXLJ5KgU39ug6KY2sxaVvK4Vz3NaNwBocWxXvoyv
         NPVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782715523; x=1783320323;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2qwmS4F1HHI0MHwQbDiJ79yyIP1FA8QXvJV7bjonB8w=;
        b=f/WdEOSN+COFBJoj2+xW+u36TXLSs9tfRAxmdmc3LLySQNTvvZ8u2YAr7SCquh6xTw
         yoxVVpVIyQMLFqNkS+eN9KK31lUFA/oQj7t6UgPpImHVotCk0vcW7OYTNyuHbCa6KOKg
         B/Erd0CdKDyilBUgJ4Th8m8XuDKSYVK6Te0TCQm0JC5yRueYLM4GhUkY+V8siWlLj72M
         syewQRx7Mq7ArVI1v9g7kqmBvjx2SIsEcWHa9jJaAfEnB5tl/J0mlIxNtTMmsZnqYzQy
         bwYSuOn06WpY5RvHgqPfe0kI78MCfuhHa/gjeyzvE9GkHJaQrs5rHa9FJ35nalRcycL7
         QgCw==
X-Forwarded-Encrypted: i=1; AHgh+RpKTqFcCEp6FauJ10x7/abbw4wZd2clCDCL6irw2uHYsEI8Hecl5Bi5IL5i/lNoh3GLtq4HvrhwiOj5ETc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzErXWcV/R9bTIh+XE5wfCyvm1SxTfc0KKq2BRXqALUn6ClIaE2
	RZQypXT9QJ5epc0AlAQxd4UYaJ6q+X9EINM1PNVLkj2kEk6seRJZnWPUH6kkGmWkYucYsxsmyEW
	CSv+e5t/wE7blHmpepKl0v8jBj89Sn+vqW/cremgPNDAnUPaKcLUW5PcVxa3BltBj578=
X-Gm-Gg: AfdE7cn7TmdflpZ5LA6nbKSJER8O16zAVgPOSRTfi8R+0iw7j9AOUevFQlSuTn4QKQo
	A/yNnVPrkhmuTRh8z0OtzGASRLAw+sy93EK2Ga10Rt32SGgvYj7hvah9gE3DjBek4wghSeBdIU3
	jHm1bHIRUL8p7YJcVC8zZSNH1Dg6Hy/iIPBcrqxk7Vg21PA7LYZ6rDlVc/6/sY/bvZDectA2RDb
	c0gu25vVaYDG2dW/tAjlKpSzZrrJCUkVFJWNFfAHa+VVP20FeslndEcHXJk1IBSvhV8PidSF//3
	ANufmeLi1JrJ/gxBf3bBxBsqaVoQl5NOTudiuQ7OelXYjRvBOXw0OJwQHAp1glSOqcvpgvVfDLr
	EE8nB0B0VaCvzM9vxhTCmqcmCuJVZyeHaB3hLIrE/1AKSPEioi0Fq39MYSPS8Hg==
X-Received: by 2002:a05:7300:1896:b0:2c5:220c:5670 with SMTP id 5a478bee46e88-30c84b1f43cmr15065973eec.2.1782715523281;
        Sun, 28 Jun 2026 23:45:23 -0700 (PDT)
X-Received: by 2002:a05:7300:1896:b0:2c5:220c:5670 with SMTP id 5a478bee46e88-30c84b1f43cmr15065941eec.2.1782715522739;
        Sun, 28 Jun 2026 23:45:22 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c52d669sm43580424eec.11.2026.06.28.23.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 23:45:22 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Date: Sun, 28 Jun 2026 23:44:37 -0700
Subject: [PATCH v2 3/3] dt-bindings: crypto: qcom,ice: Fix missing
 power-domain and iface clk on Hawi
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260628-maili-crypto-v2-3-f8ce760f71d6@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782715519; l=1048;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=ib5g92loksXZmXiRdLEH7dcCqaG6DfiNxrgUNVm///A=;
 b=73ag5aveZqYbsC6rIKjJX71ZqUJrCDqTTDn7NOXTdHKaBwY26TAzskfb7JnOoatjhLvX/7yA+
 hTus3MTGC4WCM7fqqn4dZxCKrrU0AUgeFCmLPB9CKvg1gsBtrcwDxcg
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Authority-Analysis: v=2.4 cv=ObKoyBTY c=1 sm=1 tr=0 ts=6a421484 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=pbqL9iGvPPrSSTFfp4kA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA1NSBTYWx0ZWRfX7HyjMdTC5LIo
 blyUyKvGp+moH3d6es+vu8HFfF1fcEwsNLOd3eX8Y9jKXF5fWZwaWQvRw486/gF/ncj0vk9OevW
 WIkIEVRr1I2m9P/9iVk0nHsMm3Fxe0ixXehAF31bWDtqvTtJ+dCKuVzgfgpAzlbhQxBWPXBzQGt
 7U49sCLcqKlYUDZIQl5aXsmPLEK11TofWhGRuwgkGyHZO+4kyfmUxTuN2JSrVMTDzuQMvysRQiT
 kouP2Ku3rFQYuIha+roN9G5clL6vu5d3X0ElUHZ9P60qLbXzMXNyIoyKo9x6WNLgJK3UjRTE0kp
 QmlFlDlwySjrgvrsULLJ4n7XR+Nn9war30TTdp4EHIbUCGtoSFIeBnGfUIzt1Dq0LJjt8sRXhUJ
 PnEmDknRuHGlhBMYlKKVY8h+Qzb7HoS/iM9kAIdOSRXLvpv5tOH7koa8pA1OhXTIotBwUXW9Lji
 xnCzsYVIgNTDVWgnHrA==
X-Proofpoint-ORIG-GUID: LhfVWnneh1y0TkH6tlitO54pAESBcbZk
X-Proofpoint-GUID: LhfVWnneh1y0TkH6tlitO54pAESBcbZk
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA1NSBTYWx0ZWRfX6+YA3PDhs5ug
 f4pbbHH5vhJzasSnTQZ+O+FLfLNpMm/fsrhAXri81Ip76eP6HHIg5XWzxiRKXEbS4bVye97D3Ue
 9dnZWO1ov/w6N3Z1hX37LQxNNfGh1mg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 clxscore=1015 bulkscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606290055

Fix the DT bindings for inline-crypto engine to require the UFS_PHY_GDSC
power-domain and iface clock on Qualcomm Hawi platform.

Fixes: d273b258d8d58 ("dt-bindings: crypto: qcom,inline-crypto-engine: Document Hawi ICE")
Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index d80f8445393b..a67a4eb88007 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -63,6 +63,7 @@ allOf:
           contains:
             enum:
               - qcom,eliza-inline-crypto-engine
+              - qcom,hawi-inline-crypto-engine
               - qcom,maili-inline-crypto-engine
               - qcom,milos-inline-crypto-engine
 

-- 
2.34.1

