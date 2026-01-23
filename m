Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BFB36EA91
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152422; cv=none; b=Sl9kDHuufUEAKqstZw5iVan7oWufMHawejoQ/bCNUWkbFreEAA3uDBc8Sh7gTpx2hKQuGbBDkh/eGLEVNFLDB4inivwGFlWcVBIq+RLM0gHUKKDokN+uhzd6twaw6gtZKXXVBXOBENKC0Dqlaas75J5x2LtEIml+Ia6b8x6Kz6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152422; c=relaxed/simple;
	bh=h2BGt+oLruhKNtRDwx2YFXay6bpO6ryLjJ9UHjI4QSI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OkV35dhGS8LU5TS6lIuTPSn9qfe5Lad/TIaUo4fcN2RvSjw4DWYeJRRnqIbaoKQsVtBk62Q8Nb74MTycaVLDFqveoZGHY2NGMUHjApp3HI5xKPukdmJxS/mRukEO55otd8eHGjjog09fSaZznUx2kSTgy6wwwcLKSdM3BNEBz9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KyKQfKoc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hfOs8d2z; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KyKQfKoc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hfOs8d2z"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N5683R3656282
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rKsEvIZ1Zw3Y1fRSMj26DwJShx0tsjXzs7N8oHy/oLI=; b=KyKQfKocz96CECzy
	AqVZLzucjN1kKhfxDxueAIOuiygJDKxX4Q5+7ZULMiojE4g4LyEllDrrrUU1aViQ
	wQ5tUkazxEO6QvaNAr2aeh6uC2Lqid0ff/RhuxIhw/JMK07mjSqewc7piIG11qGs
	AH5YqLqONCRwqfPWk/ooBK5tvdCOxOB2QQt3MKmPbeRYgjjs2SzgJZfodT5N+qOs
	tuZBTsH4o7/NGg4iGvGxGk2/oyxwgcxkeSQZA4kf6aQICQxHbK4sih2vTawwe+93
	lqrtFMSnli137wBaGNG85DojNCM5uGicLzeewr+iLEpb4/aZh+LcJjT1pQU9ARLi
	LMM1MQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bv2hw8d0u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:24 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a77040ede0so17868365ad.2
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jan 2026 23:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152403; x=1769757203; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rKsEvIZ1Zw3Y1fRSMj26DwJShx0tsjXzs7N8oHy/oLI=;
        b=hfOs8d2zf6cYk1kYOO9vcp6S9OdRYLYuo0L6H2LXGeclbaa+7scz/K2YXIVOiU+iJp
         axL+6mlUKeSWcl7KGgxUq+zEr6+Qe2VHDjpJ90xpGs4Fck9IqxLkDk2hrD4MNz6DruKV
         DXT87Kt+0DRNhsAWE/elvwGvGH6GOSqTIHWO8fX7x7eyEIpoxOCYfXmucU2rzLQ4I5Ic
         B8q6VDFHaUazgBRDif3H/IBEqEr5Cb3AZqoJ2ox5envE3cTHye57XD8a7E237wnIiAAG
         ZMSnsQ6QLYkU+QKeOC1UYntBnU0Ph+5Wq/gqKIdQu8mIyCohqF5KOdxbnIVNzpfvmPxU
         bFKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152403; x=1769757203;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rKsEvIZ1Zw3Y1fRSMj26DwJShx0tsjXzs7N8oHy/oLI=;
        b=P1ppBhZ9P3T6Qi8G8WbmK0BvkalTd3h0D+DokgU8XfUXQtfSmaxBKsS9oUtSVq3pIS
         F6X9mChIxsPtINdupomd2alzmjjMXC9WljDsG5NQeMvT8QAarAq/oADHhimNTRpL2Hay
         ueYfH+uiAt/d1jlhmrsVwBZdSVoA1WvoI3VX8/orfGF5A+AXM78+eIOSwA6UosjhFXhp
         Nv2dZhc9qjPLtM3QU9IN9AxtKpdTosTrkBea4M/x/JoqRB5EiqzqWckOyJIRVViLW8Um
         hn5XiQ9vOMYbTcUFpfal2UXpGnUCMsNhtLqpq81OH7SOqfgQYO0veC335kQrz2dwK2g0
         zXgA==
X-Forwarded-Encrypted: i=1; AJvYcCXUJ1z0FK0fbAfUUDTRYtm+UNNWY3J/Y7huFp9sxdJjvANcmLmtm8fxcuCu8/UEWYH8/z+kLKROqgefaa0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMyMdOufyUFwnev8h3jpDzZ5TpPzytCBz4eqVDzisYfQbcuo9H
	9OlEVdQDqEwp6UAo/eJTol6dFihtaW0BDpkg0QjMASSRN/Q2cH2DMp9ql9oPHHx77gnsf2lby2d
	HpjKnTP4vV7OUS9pwN5nWgHVs4v6ue5+YrkL3GUdbjTsKlWXIdXnjE4+fsV2GjtfjWjM=
X-Gm-Gg: AZuq6aIw8G1g4++nokfzL5cGON/ytmK7+jDHSeiewSUFXbPnnMqpv9usn/45G/OfJOi
	qvkHpWFqM39PISj4kSj4EZ65kklBCl00cIKgSHaSIR377kXprZ8YB6pQLRwsy6nZErV+SCgjKt4
	lnJ/K67bNJzv71nBG2wvrs8dcOGQEKIV+9uYOiodPlStqIGWSb6Vu9Dc4480P9IcDN88poRdKL7
	zhzOYKKeT832qkBKGrEldfLylYnHsxn6Sohcfq81eOqoFubtHcH7QgsiXqN1imYu9LcmdAkJdH5
	O1akPanM8Wg5CPpGZE8agg2Njx9bkUSJ9jr2OlQ82dOJHwnKyW3gHLPKG1aq70f51yNjjtUmzN/
	QEmwlYFT85Txyn8ErhzhIgIRl8u/heUXvelo=
X-Received: by 2002:a17:902:ce8e:b0:295:570d:116e with SMTP id d9443c01a7336-2a7fe741882mr22734245ad.41.1769152403263;
        Thu, 22 Jan 2026 23:13:23 -0800 (PST)
X-Received: by 2002:a17:902:ce8e:b0:295:570d:116e with SMTP id d9443c01a7336-2a7fe741882mr22734065ad.41.1769152402786;
        Thu, 22 Jan 2026 23:13:22 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978b8sm10979795ad.46.2026.01.22.23.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:13:22 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Fri, 23 Jan 2026 12:41:33 +0530
Subject: [PATCH 09/11] arm64: dts: qcom: sm8650: Add power-domain and iface
 clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-qcom_ice_power_and_clk_vote-v1-9-e9059776f85c@qti.qualcomm.com>
References: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
In-Reply-To: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769152357; l=1172;
 i=hdev@qti.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=h2BGt+oLruhKNtRDwx2YFXay6bpO6ryLjJ9UHjI4QSI=;
 b=35Vni9ObKR8T+NeSWe50ZZfTGBFFtwU+U3+b04NPyWq9zqUSk6nND8NBhgjiDt/ABTKDM9ud1
 Kc6IQoOLLd8De6SxUGsl30QXtrokCrAj7oqui8t2K8USTPzbtcPzgn1
X-Developer-Key: i=hdev@qti.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-GUID: MtOqgr9BNTTHQqVbNAE_r2gRU9IUbLo0
X-Proofpoint-ORIG-GUID: MtOqgr9BNTTHQqVbNAE_r2gRU9IUbLo0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfXyhD8pEG6V/v8
 5gFVQDjbiR5DGNV2qkZSHHovaWkAbIh3cqg34thqyk+Wrau6GckRWUpWHhezxxBcED9kFVWXAnQ
 JRwVZjKQiFrz9eWA1UUTqQmJqdAyHFS7nMX7fNoUmzAYmdbPI5s6EbKsUIfS4u3adbOksTGx+Lk
 tsyv5Am1+zyyksk8VQCFVBiF5P0OnEfKdlpxR9RjXzVDq1bhbkOfm8hzlofRV53g2MEuskdhl8R
 QmabvFJ6LmyE2CzOAqVMSe5vzLjfOWwAQNwUkMmVzr4FKoSRUZ68BpJDdHaUT3XIw10gjTy4Jva
 vVnm3pMa283Ht7OyPnaSsRCmCtLwODTPpWoZLqg0vlGQwAMef0rMlaHmf+zriXwAtH459+rTLJK
 Sks82TnXB+fqx6KC2cP5N7IgqQht48yvvXIxB4u9ssFW/5nGnbYxeDcNUilx7t/NanNXBZajeXw
 vbJwJOdrPx9Yo+HlfFg==
X-Authority-Analysis: v=2.4 cv=A4Rh/qWG c=1 sm=1 tr=0 ts=69731f94 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=n08Rq-YSkjsL-2sbs4UA:9
 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_06,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601230054

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for it's own resources. Before accessing ICE hardware, the 'core' and
'iface' clocks must be turned on by the driver. This can only be done if
the UFS_PHY_GDSC power domain is enabled. Specify both the UFS_PHY_GDSC
power domain and 'core' and 'iface' clocks in the ICE node for sm8650.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 357e43b90740..c32a817efdb4 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -4081,7 +4081,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "ice_core_clk",
+				      "iface_clk";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

