Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E702EC0B5
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 04:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766465325; cv=none; b=nz8gR4E9/emTIuTwmZEsgW0kBGLB6txQgpTlfuRyfCO4bvOhxn7qIhTGe7CvT7rCuKOzphN+Gz/YZY42Fhnrxqdqzbwf2igZDWKw3+Z5VTzTi2rpS+xjmIG9GCin7VP0jGqH417z0QbZDB3heXzy3mEiC/9IUhcgbPpR6/1TFks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766465325; c=relaxed/simple;
	bh=CMGGQL5QWJe/piAjltmzUTUwWcG5aRX25Q9dhRO6gxg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aZMRqpIWdcOE7N0xxjdeMUqFABhZUxsDQOiopw+fwJbL29sy2ib/AcCdQoYDstzH5KQNDD1oNjUqIi/f3p55mAlRm5+CIw/igO3W9QGsHQdf9zC9TKTmMRPyRWSxcKeNqJAQM0oe5eu03TDsCPnvvjDgPsp3ufUfAamkxa5TJro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Gh7SeYb4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=B0O9HRV3; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Gh7SeYb4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="B0O9HRV3"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN2eo9k2199451
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 04:48:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	j/hDBX5mLgOSdIJryYj4Sqei8YelgVM5i3AjtuOIU7c=; b=Gh7SeYb4eVnkcWtL
	Mnwfvgriex8bSxw7Lo8ur7gJ3cqt3hfqn19jnkx+tQlEY48zJbPCurIU44hMi4IZ
	es4w3nmI4kWL4cAv7ZRy7v9CTWUTNDP1nPMR89zrbzEkZziVMuxBvKH510wrLzOa
	wIs0NaY1Wfwq00RTX6ZuK/RqxpmhCa7PapIua7P4BYPmjxtiKnwcszXCoJYjk4+m
	OkyFBIbgdtybeexhrE7WfY3+h64J7erBUtk7PGaWGEOqEOOoOoW37nHK7V2hf3F7
	jQM2D9dXr4ukwM/LOO+aFR/uZaJQp8cbwvH5jiyBrjk460rviPUkf0egHtkrzsSi
	jdV5FA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4b73fwtu8y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 04:48:42 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-29f2b45ecffso76973735ad.2
        for <linux-crypto@vger.kernel.org>; Mon, 22 Dec 2025 20:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1766465322; x=1767070122; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j/hDBX5mLgOSdIJryYj4Sqei8YelgVM5i3AjtuOIU7c=;
        b=B0O9HRV3fY0YGSw00rpa2+XJuk7+TSygRUcSXCMS3jHlPBjU7cYkOAbmADyUPw79OF
         31mn0qmJuRw9zj7B60m8bqJg2zy5fSN4NP4WJxIcYfmZ1Q6Cryf95g0dDGgNMN4uYloO
         PwK7jBnhUmF8zUoQcyrNTiNST91Sm7LdS3nMUcQf8AAK067DUo9seM6UpdnDauUm19oi
         D50KvqI0lulFSR4dHqCHHx4qhjGWOeMOcLHyF7YaNCo7joYuunnQe+vQhWXTkJHl8UeV
         68rRCXTnOqFou8uMaf7gYerQzgbIDnMXTUJyYBxUnNYwKs9xHajp1JQJi/ZSQuT4vPYd
         nCxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766465322; x=1767070122;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j/hDBX5mLgOSdIJryYj4Sqei8YelgVM5i3AjtuOIU7c=;
        b=XyHv1Q/j1J1Fx2WcSPAPzEvwJ3Xj1qL2zsspycrYsrRQ0UFyU9BjR/8RBRi9l+qaH2
         +YaMkVVhrT+mfXuAlqRot34wkiN0bcOQToJ5BYwS9Ynq/dR+oro1vtffh3nR9ShD8WEk
         14rlocoYGWpypkD2wSqjLvt2tkBf9Mhmz1YpYC13zY2k260wgCejRK/NCzh+l7xTW4ya
         XI2ukkohHd0KQR/CSxTQCJG0r0vwhiapAub0eHC0vssXYDQiA9b51hgXJHUVGK4crQ0U
         iPw1XvBOKjkiAzWovhPvtgT+IXdVnRCmEF67UgQsGrGaR5w/PfeSjTE8AsmMn0uLTJpm
         Gk7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWBiYPQdThrsgyoIRTmszrquLX/43qHk9bsiRAxrM+LCVC3afVzDBFaYZwWp5FQSeSTd+7L479+ob39EXI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx66wJH678KZEWKO/OVXb1MMtaZ4KqLCbmanIYCYyw2oC2EUsTB
	B8iZ9ydEIH2N2ETLaRxNPDgGfMEUwcKSLmyUdqpIKsPbPghWDrDtOojHxqO/SKoaJ0yGMcvsmD7
	Vp9aZhidARkTgCTqCwvzmQXgMJ6Yt9GaTsmCnf+g/MmtbtFdOlhvICURE+netJyKguzg=
X-Gm-Gg: AY/fxX67xCKWx2pbIF6+HSl82CgdM/1TLBCsLlB2iG3L5gR8fpaxbO4UA0ShemHNkGr
	LUmiIfpw1S2HZAMtVBTpaQplUyZMjBOaonqzGOtb/AxbPidRNdzZUiHEGoGVQGxZ6o8L1ZsoNr8
	J7PJFqba9mKkiYC3nESJ6DQEA7FVQLxMCOXbxP/9RMi/Gk/FdYnkLBuqvYEXCeNLcy0/WwOoEQo
	ynANL8LU3OTKJuj9pJkfuMgzWnUrklgh//YkdwuJApaS9gr5iXMUNX1UjJ2+8E8xWPInsRPr4br
	HrzueoBkx2HegGseeyhG/vLMwSwj8VRXfOwhllb0cHfDnOD+hP5uoxIAHGJarHjerbBHvt/RM8U
	V9Pqu2UaVN7CmbP64JQ3GUczyRKXISpB4vUE=
X-Received: by 2002:a17:902:d541:b0:2a1:388c:ca5b with SMTP id d9443c01a7336-2a2f2a3551emr153992245ad.39.1766465321933;
        Mon, 22 Dec 2025 20:48:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHri+m8RE+iDJJCDrA4k39KHtgYbgIzbV+TNylaO/2pNchET7js7YqYUWunXoEnf3dMeNdyEg==
X-Received: by 2002:a17:902:d541:b0:2a1:388c:ca5b with SMTP id d9443c01a7336-2a2f2a3551emr153991945ad.39.1766465321467;
        Mon, 22 Dec 2025 20:48:41 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c8d10esm111316245ad.42.2025.12.22.20.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 20:48:41 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 23 Dec 2025 10:18:16 +0530
Subject: [PATCH v4 2/2] arm64: dts: qcom: x1e80100: add TRNG node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251223-trng_dt_binding_x1e80100-v4-2-5bfe781f9c7b@oss.qualcomm.com>
References: <20251223-trng_dt_binding_x1e80100-v4-0-5bfe781f9c7b@oss.qualcomm.com>
In-Reply-To: <20251223-trng_dt_binding_x1e80100-v4-0-5bfe781f9c7b@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766465308; l=989;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=CMGGQL5QWJe/piAjltmzUTUwWcG5aRX25Q9dhRO6gxg=;
 b=TGTiw49JnMKrMe62CtB5dYJ5m9av0bToWKPuGwOgYJWMqtgpAvGGtIPsuLXA1jHuZebz0k962
 ALs3zKyWZclCioTRnBvgcRwS234LAU2U5zGnA9VVrsKevp4c5BlUEft
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=ELgLElZC c=1 sm=1 tr=0 ts=694a1f2a cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=75mWG-WH9mJFzEGoRSkA:9
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzOCBTYWx0ZWRfX2/jnO1hdxcoW
 HNOOAKJTRO3bn3DlqcW+SQxVc5FHd+XEYVAtdCuH/01Hta8qDS7B24mB6ehT/QcJlisOdkdZ6/G
 fU2suQeW18kWQDWrGtXFfibp9s5N4c3KdpOrDPWDLcGq6yzRuHfd8HCZ5IgYzP6/+OlItRjuqvd
 Wisrzwa3M19P2GTSgfakvBrtj2Iy1b/77uJ9yYHE3EUtgO6ocNB3MxUmIRSVaP/BanZtFjdw8gL
 IGJGGRzJQhDgSSPt2m69cfk1CBp+BAFtgwTidFY3vLx/QDZ2ZqOK+wTlKxZg/n2VTFZPmeomZ0S
 0OIv4eQyBs0kvy3DTvPPLJyj2tN7mNMR/RsJQzr2BhaS7RHjG1wJRzWssEidxS8SnM9mijMF/aC
 nhT6BJOgOUXzQ5QdR9IJQ0m19FfrcvGBYQu19XH1luo/XSET7X7F1hetC6aF4ochd0oD429ToYB
 DPJVOhydvRvuHaTV3DA==
X-Proofpoint-GUID: 0qWVGxDeFrfYDj3kwh4GmTS7kFSvU_4m
X-Proofpoint-ORIG-GUID: 0qWVGxDeFrfYDj3kwh4GmTS7kFSvU_4m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0
 suspectscore=0 adultscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512230038

The x1e80100 SoC has a True Random Number Generator, add the node with
the correct compatible set.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Tested-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/hamoa.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
index bb7c14d473c9..1272f2d3a7c1 100644
--- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
+++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
@@ -3060,6 +3060,11 @@ usb_1_ss2_qmpphy_dp_in: endpoint {
 			};
 		};
 
+		rng: rng@10c3000 {
+			compatible = "qcom,x1e80100-trng", "qcom,trng";
+			reg = <0x0 0x010c3000 0x0 0x1000>;
+		};
+
 		cnoc_main: interconnect@1500000 {
 			compatible = "qcom,x1e80100-cnoc-main";
 			reg = <0 0x01500000 0 0x14400>;

-- 
2.34.1

