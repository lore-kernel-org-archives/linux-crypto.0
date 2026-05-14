Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0795B35A39F
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 19:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778786647; cv=none; b=m/VK0hu/lv0tUh54q7s1TbZTGjR7aJ1UavwjXv2rAVl80SBgX3CNLRq52r5tv0RQh69M4eDl70kmFVqEn4JkYrLufmQsmrRdYw+79ZWnf5G0cwjxS64j6YiW5FriVBllf3pUyzGk72EqItFYMildSWpofy/ODNWsKr7hTVUeONk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778786647; c=relaxed/simple;
	bh=O7Nv9vX15koThNNmsXV5Ll2RptDkHxpOaS5DSqN+Wxo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KJogvs3IneN3LnI0rxNiX4wKDLVrzq8QRMy0rohFNAZDBX6qzWinL5W1+mlW7qsV4i/hgAVJUzjMurKkym2Gi1TNjHbUWPWZJ+6MRpOPrdapXe/Vhp/tdbPBXB1sQmF9J1g/gnEJjvmBqZjBlCnzq94XjvdZmE0NIpn4K5hKQN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IQh4De6O; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ehkT0fze; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IQh4De6O";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ehkT0fze"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64EIq3M14022529
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 19:24:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XJbLX3SOQ5nHO6qbquKX49XEzMv+jauXaF/R269IlRU=; b=IQh4De6OZU4oFh5r
	b2tUh0L5kOZYXaA8McIvyh67oioRwUukG7m1eo2GxGCrvOEvrmDlJEh6Psd2BDbv
	uCuaUhBIEUSzyhKBqUO3OWw/EEuLyRRrXCtF3VjSiXY+wUtXIlOXbWSlrp/Yd7B2
	51Ly9Ra+7T7VV+ozidLzDWznGhsLp0yaQ6uOJ53AVU83LGnZQtt1AFAc+ibQ0+9a
	mSmfGYlbDHRXAjVxp22AAFFAzst9FzT5A8l6rC6OMKu4v8X/zWqnKm2Eh/iWGJ5w
	NIdc8xow8mG37kAY9ZRVmpUsg4fz7/j1kYMmQXQusV7Y7iHd86v18utnXP234hh8
	zZihfg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1rr3q1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 19:24:05 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2bd6aeb3637so16009085ad.2
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 12:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778786645; x=1779391445; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XJbLX3SOQ5nHO6qbquKX49XEzMv+jauXaF/R269IlRU=;
        b=ehkT0fzecu7KgC6+NbKWdbF0y1vh8q3e+05FqlB1xXDTSbW4YvvQWEcDpVT82oW5Hk
         B6FRT5+TVRtDNwAl0jQesWTDtgU12QFt28kR4WzJxQ1SIz9c1fQQWxQabR7u9Zx6g00w
         OnFCbg1ZsggqbX9ZW7V0pVkRM/4B10oj4N+yHG8izVwT33Ds5LBz+2qUwSm4237uOHUi
         LGZ2USWEdP7Onkt3RNxVGLUFVNmEBT5UmxMSl/4YbZi/fNUD0HhD9aYfbaPU2RILsdBo
         /SC2vPpVRj6MqQf5tJAGqOq2NOhJBEAaQcLyVGdQvkFlQrlXQnjM2IHOVcezLxlwPRHl
         KsBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778786645; x=1779391445;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XJbLX3SOQ5nHO6qbquKX49XEzMv+jauXaF/R269IlRU=;
        b=hpmF9k+RdllIKvaRtg4D4DvB93INFAznzInpDGgqeDKY8jO0wPOnEw+2zUmNeT+gEb
         ghvJSSlc5L/iAbEsuexdkGkhMBWkYcKl55JELzGHaOtcLrqrkRj8xLjC30vLb+3y+2v5
         XVmtGXJU8tVB4hGnCKryH0r/5/3RaAcadyWH5l3ROciDnj7cqe5TFOiNvi6MsKBsTWGU
         HgZMVsdTQ00DTYb1m1OzXZrRWSPkNTF5LH0xImsKtktY9qzTpL4HDnAtX24rQkfA2NrV
         FVRBmuzlS1VO3WhloZlchTqKuj2C5NN7FRa5dc8xVumFlh94NXjG4UEKB7hqBx9Yi1ra
         kx2A==
X-Forwarded-Encrypted: i=1; AFNElJ/ijrl+BWwDbYnHAhX8vjyJoGMjNDsElqLlyLdAzYAAohQiFzV4kZ4+RLYFCbri9piCz6mfQf/gHBconwI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzysQaWuJ1g4NH2kdAJwzKc1W3frq5h27HXxAPlEma9fxTjd8Yw
	o52fnF0FZrVEkenaJiM5Lq0SOL46OLzMnDtwXv60IjaTyGaapgftHyXsI3ihRBcJeawYEgrx96C
	oHURZv+1Ng2Sd0z77B+a9yij8H/3UCwgallaM46isdSHN5jHyWYdaUkpU/Yh356C13ss=
X-Gm-Gg: Acq92OEC40VHd0+ABZUxJ3KegoHc3BmsUcuhiTeQTHH4u2OUOPDAN8tLJplK+ZVqbtP
	s8S/ODmJIjsZPKkAjqKm0ytZ4DLrkyyFTdaYerwKmwGjOGbvs0Q/P8mlqGObCdjbsWjyIYiQCEa
	E4YXRm0g921F/ACW6sF4DDzMKKq4M8AKojgHqnVGh9+Nckhqxj76cDtjq1NZ6yFYzWJC/WmeZlI
	VPzkppNrC20OGUfX/Ick3h7z7JELy3hbJiwZFFSEtBwnfw4OAK5njP8zicOjavLyZv5YbT0ikOn
	PQWgGONdWYrySOa1U7g05/C1+OgF2hXd80MLuz0ZaGj3bXWO4vdKpjYvJmlXusen3vTv+Wp/vRv
	dExshb+QwNDcm5ZWcst1HZJeEBDOk+8n2FPYzUj1L6HtON5QgGvqTzKMRk5uGLMPGTg==
X-Received: by 2002:a17:902:9042:b0:2b2:9d60:5eaf with SMTP id d9443c01a7336-2bd7e77b6b6mr6497485ad.6.1778786644762;
        Thu, 14 May 2026 12:24:04 -0700 (PDT)
X-Received: by 2002:a17:902:9042:b0:2b2:9d60:5eaf with SMTP id d9443c01a7336-2bd7e77b6b6mr6497175ad.6.1778786644310;
        Thu, 14 May 2026 12:24:04 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5f291sm35506535ad.15.2026.05.14.12.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 12:24:03 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Fri, 15 May 2026 00:53:37 +0530
Subject: [PATCH 2/3] dt-bindings: bam-dma: Increase maxItems to seven for
 iommus
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-shikra_qcrypto-v1-2-80f07b345c29@oss.qualcomm.com>
References: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
In-Reply-To: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-GUID: sM4cQdsShokASfJmYlFX18OriHxaZVT7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDE5MyBTYWx0ZWRfX5ROHxX/xIhi0
 cN4oIVdv88Br3boozVAtAgQD9qY7Tsv+OFTxm+wBLAb9notvt6mjfDSq7hAm3XMlLj004o7tZUz
 FYbc0x1qr5oWIPXWNxVBL1+Hk3GDXIFIjWAs74hYhjSBUPVUjCD8wTcy9L15o6CUv/F77bqjvxZ
 o8ytJsoPt8BXeFt44tTPGpXii/zS57ydbb8teqd2gftz0MMW8jsWZLSwEtLOYteeLY9l3wF8S1S
 v/zYgjcKdlrbdMMo6NzE1akMnA3pzP3JUGN+b4Ywcdz2UeaJFQ4ItN4RZmBL7hS9Y7xBQ6fU24q
 9vtPAyjErimU9RsI6+pLqG04Q29iqaMnpBKXmk55aqHDmWPs8SRmpHkTVC9JbdmMOaBLxymlF0O
 P1cpgBZRTV43/y62r79AVGwSqaXNY2qKdPMNFtFZk71ZKug02mLtLrdahHsrnazA/ykCA3UgcY+
 gdYHamO7FLlAc841CSg==
X-Proofpoint-ORIG-GUID: sM4cQdsShokASfJmYlFX18OriHxaZVT7
X-Authority-Analysis: v=2.4 cv=JPELdcKb c=1 sm=1 tr=0 ts=6a062155 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=8lsXshAdeER6dGNyxukA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_05,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 priorityscore=1501 spamscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605140193

Shikra bam dma engine support seven iommu entries.
Increase maxItems property for iommus to pass dtbs_check errors.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
index 6493a6968bb4..ffdb308352c3 100644
--- a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
+++ b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
@@ -46,7 +46,7 @@ properties:
 
   iommus:
     minItems: 1
-    maxItems: 6
+    maxItems: 7
 
   num-channels:
     $ref: /schemas/types.yaml#/definitions/uint32

-- 
2.34.1

