Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794523179;
	b=OkGogmPtgbWAuwvcFy4eVD/qSEfG1m9br5qw7Rlog8o87Kc/frB0FNaweZFhT9MLr/HY
	 7oc/fvvHp+M6FHavjZsp84DPOQcntvQmcfJgPGEBu6t0CkSVAkF50168jVvbjHFdcVJWg
	 3yCefYv5mJc62Qwpla8+osDudAAfgE6jWXVqU6W2fUiUlEiPMMcn4RzNDrlU+sri9iuF+
	 SevsvKwZoVZ9LqCwV2WRbHi76w8uGpEwTJd9E9tnf7DDgMTGjOZGZcXTzFMWein4S+RD3
	 BmsaHw5VDQCvW5cHPnvULZKPgxQsxjt5EBVKinhgK4TrIQrzbQWNjJ/mcV7ATp6bypw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794523179;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=h5d7qQ1TmiafTLELdwxVa2K3qpo7e3rfmt0oQazEA1I=;
	b=xWDJGMfK/QguQByA/L5o+JsuCfu3ztOSYlqnFIEHojgsmEVJNDBa/q/QxccW7mpIpulf
	 DrEiLmizB2QgLh8L5g3yFEeYS3VttKgwSoB24/bKCqOWfb6KIc1mFyyS/4fNo0dOnpdfj
	 GheTlT2wGa5xPiiqu+kI3awUuVviN8d/R5uN7ImrNKQ2nfusX07udwHJIV7BYWRJTcx5z
	 gbc1PEBWddUW64Fh1sjW35Tuj01KPpH3LxG8+PFOB2PGUZVwWzvC6IRdvX7Hk9guiOPM0
	 aDoWw+uw+LKKCrr2PRNsFLODTMBWwPNLJ1pr5Kp+TyHvi3ICWRbZ9/0I4y+RIDIvHeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=PffptluP;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FeJVhMhO;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAF260A2623
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AAF260A2623
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=PffptluP;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=FeJVhMhO
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACJZdNN1638262
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	h5d7qQ1TmiafTLELdwxVa2K3qpo7e3rfmt0oQazEA1I=; b=PffptluPAo9AWFlH
	b6SXJuXvj4CNYdzrEcMKlMqjIGmfFAw7foySfT9Ag/2KpLeCba1+0DawoDpHTet/
	73jnUhT5yV+GliUh3/VuOF5hAa4cus18hUMidkNVdBA8XY3KvosqC9SIzaJzcRKh
	yjbvZBJvfvbLJBA/n6rG/sDuFoUufFwb+te7wO2ngClA95Jk/OQgtKjnrn5H0/yg
	XTtxdmtxb6DFy0nPlmmCmPMbsw0em7LuZcdq82epzuuMJSWB3mXTWToMe3c0kCPk
	Bhwkm8+QdgpVkcNYwvvx1kqHLq/wwlAENMop6WV6iI2gPMBG4a/+DS+BZHOKTScv
	YfpPnA==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hw6re3q47-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:38 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1b3ae327c55so827368c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794523178; x=1795127978; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h5d7qQ1TmiafTLELdwxVa2K3qpo7e3rfmt0oQazEA1I=;
        b=FeJVhMhO1ZG9zVHEigvHJWvYBBrEQHXGoocJNJSCtxDoD6UxFFMkxlupoBaqbA+M4V
         o8RmQQyw6QkQKGovol+mM7LYC5u0sDQTnVGFzKHx7n6eccYUIIvLAi9/7igSEqwhHXmh
         ZSFFyhTsuHet4QGuEsgffBo5vWNeR+5gCJC+d593K8b4jJyg263NniFo5585dgY8n/1y
         RaRZPCYNLEvC+uOeyK8fWOqOgiNclpLf0x93LpwKWsdbvMo7Vo+GGNOY4jZ/hJIbroZ8
         R67DBYj26P+C86ChVIXXAwVMPGFfYxzcbTuO8acVjwf0Y7uMvRIlvtCPO5UOHmaBkCxM
         8WHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794523178; x=1795127978;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h5d7qQ1TmiafTLELdwxVa2K3qpo7e3rfmt0oQazEA1I=;
        b=wk3u9mwAXrdbKK8TkMlxjP+jyB5z9oOArQwqIiBf5Drl5ReW6obJ0DFep8yqxmv4gb
         JQUOlNbZuQjnKb4+fO+NhFzMfe9C7NCq3uQOAuzNlyITpWzpNY1nJ7PiPhX9yRbGGD+j
         Gz7CSOSGcjSaNbdfWdfP6G5Mwx8X6IrNQkqjyvHMsMHg2KggMyia5XrIXHH9gPWRfb6p
         9ToncqaWSs+qZzryjgLv2dXKMyT8VRLQKlO7r4X0lJy8NeLkKX5Wkm8Sl6MtZ2hTt8gQ
         PlSuuieEaerZX++j4o2PveXZ7hHgshBC8zXWV7CLA6IDngLNH6DugBYqGRbRrdCOffMj
         Echg==
X-Forwarded-Encrypted: i=1; AL+hErFuFU+8mfYuxR7jiA4i0aZn6yPNegPZjjlkUsGI0FWlY4iD9Ih5N5+ldElWwaU3tu/QLN5reRjNOoO7xUg=@vger.kernel.org
X-Gm-Message-State: APuU4Z9ntDMFfx3xWvOTq/ndxggjMe+T5eHhalGE8Ee8J9JxxQle0xN6
	U5reit5gxF+vh0MdHvMmiNI9BcHWNdDAJYsjnlI4IWxa+qEqZk8pzt/sclNWCGa9iHdXLaxYcqU
	9xFPId6Cauz7CUur0T7fFLvm3+jMerD/0k0aPdJyInMkpeLoOctCmyEo39r7D7vZyat4=
X-Gm-Gg: AYBFou1FTdzVcflPPRysWxWXhhPUmiSywi8qsOclAt7bCki2tR6AAunMczyViBiq0tl
	P9pfEYqHMDH5YsHlwTcPpZrinMevDk10oyMXdfBTt5hA2gTmcfsU56PSoghZmrIFV4FKw+oop7C
	el6dH5pTGXYMkRutY6JZaBgXUx2QTuI0KDpQe6Cpgz52GjxPIPMs3VicUx3a7YjSyRBtdHVHQoa
	75D1VjuuzrpJEwkIx48eIPgq7tjwi+dWRHcF99TycZzUmZPO1hej2ffpSOanp5xd6vSBP1U1BCA
	apyXiOhSR8U24MYmb0YexkVGs6B5NXkvBU9QcHcal1H3hHn1qjXJ4vlM8fW8w3m8p7quFNwCX9E
	IlrWQjoxMhFnL2WIVq/ycot2sTyHciQSY2cpTeneOH1BCjgvpWbZ/oxxTA9dN+80KSNsJBEn9oF
	ajnUkKIlFygg==
X-Received: by 2002:a05:701b:2402:b0:1b2:6d4d:9d8a with SMTP id a92af1059eb24-1b4f5ea832dmr2727947c88.2.1794523177995;
        Thu, 12 Nov 2026 14:39:37 -0800 (PST)
X-Received: by 2002:a05:701b:2402:b0:1b2:6d4d:9d8a with SMTP id a92af1059eb24-1b4f5ea832dmr2727934c88.2.1794523177498;
        Thu, 12 Nov 2026 14:39:37 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm2333496c88.5.2026.11.12.14.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 14:39:37 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 13 Nov 2026 04:08:30 +0530
Subject: [PATCH v13 4/6] arm64: dts: qcom: kodiak: Add OPP-table for ICE
 UFS and ICE SDHC nodes
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
Message-Id: <20261113-enable-ice-clock-scaling-v13-4-258dc817bd63@oss.qualcomm.com>
References: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
In-Reply-To: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
To: Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: jg61CpdHguzhfpRFUkPgyTjzJL3nW_hx
X-Proofpoint-GUID: jg61CpdHguzhfpRFUkPgyTjzJL3nW_hx
X-Authority-Analysis: v=2.4 cv=NJhAaE6g c=1 sm=1 tr=0 ts=6af6402a cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=Gfx0KCctoiflwLzBlNcA:9 a=QEXdDO2ut3YA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX9SdOXm5wT6LD
 pL7nfTZrhCgtydpnxEVOv/0EW0hhbTvK9L4uF7Ad7in0qXw1ttK6FjyM9olE4blr0EQ4RTdmGc7
 YW/qirQFgmeopRL87RZvTukS+RzW2Ko=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX97Y+WxYWBR+V
 Q8itisvEWIzCkM6QPmD3uEEBCpQIXRRhchUF4XZFhh8gFL1WbSzuFqH/6UB0bDqpfT5jsiMfItA
 L3fXuxkO19p4lq/lhy1rQhk4Nom5XlTlspTa6RSuVsPbBxFdmtn3eomAKVAXxpBf5VjzDXTF3fR
 shP1MYadUNsklFcKShwyfvMPtmI9ntDIN1UXm90BfhMGYSTxOI8b+h0ahxd7CkSdRJm2m8yd8JG
 TuC82E7H0dZ/zPtOINt9X96gXxoRJIuk6POvSsoP/tsvZIcVVy7eATJwiw7tf4X8JREqhStG+Nv
 DRihkzanrLWFrgvvSFtVrKdoujiar3F1k2Qi18f5ATRwi9PirhaWGskm1PnKe39BVYlV9xF+Sut
 Tso33wPUfGwZsVo7Mm5QBmCAS+/Cu0DxvD8A8gzjZdIy+eBYktjH6uKc2+lyxZOOmcqiAqfz+n8
 0Cj3EvKHwheI53cGuog==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_03,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0 clxscore=1011
 malwarescore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120090

Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
an optional OPP-table.

Add OPP-table for ICE UFS and ICE SDHC device nodes for Kodiak
platform.

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/kodiak.dtsi | 42 ++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/kodiak.dtsi b/arch/arm64/boot/dts/qcom/kodiak.dtsi
index 10e9a5279ed60cea1514097354b8f0f59ffca2fc..397764d78dba579fe95654deb7b01ae3b1735f89 100644
--- a/arch/arm64/boot/dts/qcom/kodiak.dtsi
+++ b/arch/arm64/boot/dts/qcom/kodiak.dtsi
@@ -1100,6 +1100,27 @@ sdhc_ice: crypto@7c8000 {
 			clock-names = "core",
 				      "iface";
 			power-domains = <&rpmhpd SC7280_CX>;
+
+			operating-points-v2 = <&sdhc_ice_opp_table>;
+
+			sdhc_ice_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-100000000 {
+					opp-hz = /bits/ 64 <100000000>;
+					required-opps = <&rpmhpd_opp_low_svs>;
+				};
+
+				opp-150000000 {
+					opp-hz = /bits/ 64 <150000000>;
+					required-opps = <&rpmhpd_opp_svs>;
+				};
+
+				opp-300000000 {
+					opp-hz = /bits/ 64 <300000000>;
+					required-opps = <&rpmhpd_opp_svs_l1>;
+				};
+			};
 		};
 
 		gpi_dma0: dma-controller@900000 {
@@ -2608,6 +2629,27 @@ ice: crypto@1d88000 {
 			clock-names = "core",
 				      "iface";
 			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
+
+			operating-points-v2 = <&ice_opp_table>;
+
+			ice_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-75000000 {
+					opp-hz = /bits/ 64 <75000000>;
+					required-opps = <&rpmhpd_opp_low_svs>;
+				};
+
+				opp-150000000 {
+					opp-hz = /bits/ 64 <150000000>;
+					required-opps = <&rpmhpd_opp_svs>;
+				};
+
+				opp-300000000 {
+					opp-hz = /bits/ 64 <300000000>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

