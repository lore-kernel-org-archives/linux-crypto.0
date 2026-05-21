Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162043E16B1
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 13:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369494; cv=none; b=lxlKy/bbg8c+6g9ysqyHcx2pKQR6RT5Z5kwaM2krnNRrqSJM4zB13hTv6ln36bJv1FHV5Sdiwf/Zi+/MCJbfT+5O6CBkloQoqDcd8HMDmJxHD51FuweeOnb6r90+ivDerBGoUcUmWKZ4iNMOohHV4NEHmXyScPiihehSnn4th2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369494; c=relaxed/simple;
	bh=cmb+NBPdV34mI8XyHRuMaeHAtTIUx30FJhXF5CpewcM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=O0mfeNP6sqoBihfjt2TZDL6x2ou5ctOzFCP9kTsASeDwJJRQub0mv2G+n8qE+mSBDM7mDuEk6XCB33r2GOQJfQnGwbcLWCsq4nAuoTq/wpK3e7l7TInLQs14o9Svmltx7k7g5PImVYPQDdS+KZ3hfZhlfvV9IstPAjKLrYMqkXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RHZOZukV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MfXV3Dem; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RHZOZukV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MfXV3Dem"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64LAXrXM818826
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 13:18:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oh56qnIxN9olLqtfYhYt0e21nfWmA+zC+Yu/IM5YCDU=; b=RHZOZukVNQtCk+vp
	9x2qqBQ6uAoDc7kMTczNp4Rzyg5ZVAQ6jgGdY87zhdVYmQFCR6zv2ngcLd2UPWYg
	bDiAQr7KT1Ys/eNCylwCIfUwvOeD0FGVkHUZggH3Q8GLOFH8mv31coOwQi3kuOE8
	w0SHUtwPmnaci/VTcnuFN94k+V25nRhWSk1FkYyX+9BVBRFUFncpDROWqcmcci5Q
	OOlLxfktyr6mfiGTdN5P5qhAS6wBu+GPStEwM6xtLjelFnQHc0hALv4lcsIzumns
	rarjbsAPf88bVDkIbHPNEvWHff8Hhbbhr38dPDUbviBPnQunXXC4B2X5xwS6ORpW
	ABwBsg==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ea0dkgjp4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 13:18:12 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-82fa6c3a77cso3541473b3a.3
        for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 06:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779369492; x=1779974292; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oh56qnIxN9olLqtfYhYt0e21nfWmA+zC+Yu/IM5YCDU=;
        b=MfXV3DemNr3+85U41blbRf9a3UKAfWXQ05gLI0b5Enlum/SlcBrAA/8JK7AVkZ5b4+
         R8kLNEC2OSugO6zex1l6tT0M5v7IUQTYPWb82zBXC4YNsMf1hQzA70/xm7MEst59HmfD
         +36+NKKdHRlnNda1WUbAA/dhmsJhIKTv0q8LTez8ur0IfqqgeOIBp6EUtzmbJuVy9Kmk
         2JsY+QwTjtz4Oc/sGnjhK/gSlF9VZ2oUVl4z+Td2Eesh/0KWqVDbAq9m9e9+S/LzjAO4
         6ZGM0QQlpIVAtYAv3KmmsNy4WuRUtXLbDWIqSvEREg1x5BiOSx1NNsPJrKp0yfYMCp1b
         u6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779369492; x=1779974292;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oh56qnIxN9olLqtfYhYt0e21nfWmA+zC+Yu/IM5YCDU=;
        b=aDEJ35ZtObel1xmtutg0l6O+zceZaHDOGSPgYAo65A2SDInTc+ngzGf2qVPJEgV4+u
         lrqMO0+mF8Sdd/ZPdb2j2UVYRtX2czxH86f42499A+widH5Yx9Jp1gLHAx5ai5TYuoHG
         vL1qEOO0VvTMte3FR2+1LXZAsO22a68P7vyPhiQRrLYcro9n6U9yyOy9njJnYEAbU39e
         xLVKdjVuDvg+WNB1RLVo6EDveivo/8+EyI7yczFSBpY1Rv1AdLnIaRLjXYgrQQotQ6X7
         wSb1sTN9MBFM5NVzihLtLUrFV7ufyMjyQnKQWDQZghk9Jlqi/I/GsTgKFHCYrSj/CUkY
         te4A==
X-Forwarded-Encrypted: i=1; AFNElJ8LnUAH2HUMe1WTFaE7vPEIeSuJUCr3o3OkFDyoAuVUiITUZkm23oUj4qzBEBzPoPUijz2SHnn1Js/ASAY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4nBg96XXiMAWKrkWytP6v5CNRxnLVDscK71SjDorR+SaqQd21
	c/pm+fBreHgd3b5zYy47ljv3ctkEaRqqfsUpJmMDuNHW4ZDiGZMQyo/O83YWC2JMQtpEDagWnka
	UEXmgAJLsxTxCjdyQTZgyz5gyLXlx3pKfQayVOru+TcwOxASCYu108Dy65GQoCRBaXiU=
X-Gm-Gg: Acq92OH0DUsZtMKqhCZw+CmV0lAX06ieIVhcDBdQMIao4gUdxRKfqObo2PAGxgTRyC8
	zd0Qwrc0HRATVZjfywR+0gzL0bMNUCv0H/zI4b/M187f/OBJ092dsGgq5C/cPNQED32DZ/m19Iz
	7hRn8mOmV+Bohiu2B9KZsEi4YDOODAo3Ms/UKsKx2VHl1gZ+cu3x+fod7QjCO7TL2SMa38Gqtr3
	HLBx979JyDpZIpEPObkYks0pYVBqUooqWkCUSpMpchztxClB6ndhEc+r6CJjWcCvGysf3It4TVB
	GUWLzN178SaV/TUalakSUDAmMbtemiMgovzGIU8Bbs9r3MBBcp6EgfVth7eWYrysFZeerKdX6ZW
	ApHpCeajgpVbgpaUNZbq5rgDkJdUIc/iNmPXxPNV5XYHXTBJ2TJBzqaY=
X-Received: by 2002:a05:6a00:391b:b0:835:4291:6975 with SMTP id d2e1a72fcca58-8414ae15668mr2866502b3a.39.1779369491606;
        Thu, 21 May 2026 06:18:11 -0700 (PDT)
X-Received: by 2002:a05:6a00:391b:b0:835:4291:6975 with SMTP id d2e1a72fcca58-8414ae15668mr2866449b3a.39.1779369491072;
        Thu, 21 May 2026 06:18:11 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84154e22f1esm1687731b3a.47.2026.05.21.06.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:18:10 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Thu, 21 May 2026 18:47:08 +0530
Subject: [PATCH 1/5] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Shikra ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260521-shikra_crypto_changse-v1-1-0154cc9cc0de@oss.qualcomm.com>
References: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
In-Reply-To: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Andy Gross <agross@kernel.org>
Cc: Harshal Dev <harshal.dev@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDEzMyBTYWx0ZWRfX4Y9ZJjpABlLH
 8+Idt3FQxA2rNd/vey53thQmMzI8h4e5gH2NrJviAovjahm5oxviD6WVJwIRwdsgIQtZMxVaIir
 Vg98wwXvvuEBUe8UKihYPbxLZvgLnvAEh5WIH5aPvX7SHD/jubyrgoE2WONZbsWtDBFG7Af0KHl
 pooWZ3zOduispBF8naKbN8GCpiqZzGb2oZKQcp5zoSLXPnNhkav+6QE+Jea2VjWN9OemLXBs58e
 ICU0TyXfoEiCBCoqsedHLUvA+hF78NVcbTmiPmuiAYtnVKsTnLwOIqEgXzu4HeQLK68mAdCCFvb
 HuqAR64JiXI/+B3xbJf29c/CmFVNSH/1MXiPIabzhH4wT9wD4gCYhOsjuWlH2BI1ZwV4jfitzQv
 /NsLmmDwJutF+WP0iiHhBDwOHUNf+F0i05osItU5n6bR6TNlSKCRGbUhz/thuhiFyZD4pFx8xZn
 dm0sFHmYpNvqVBzgiNg==
X-Authority-Analysis: v=2.4 cv=aueCzyZV c=1 sm=1 tr=0 ts=6a0f0614 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=qMhC6LGQ_1aKn5J9HqIA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: MhstkZWUT83FbLmK4yg5Bv8vzUVaIp2i
X-Proofpoint-ORIG-GUID: MhstkZWUT83FbLmK4yg5Bv8vzUVaIp2i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 adultscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605210133

Document the Inline Crypto Engine (ICE) on the Qualcomm Shikra platform.

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

