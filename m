Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794523192;
	b=4EVpdMXkuGXx7u6vGUTvJiKIhrZlJ95nGovetQW9SCbtNu61NRWdBelnUrT0RAzlhIq1
	 N/BKAyQqFKtDatfCd1HtsLrLoMzSu0dSY1oyIWrPzo0B7WtX8cbuKNKWwxwNRHUUSkisp
	 aG8Mprlt/I+OIVOEoDZI9NRXn4k3jPli54CRYFI1+lVVtYo+oyNZOy+7IwDx2lPwb2X3l
	 pIcgYt3nPRo6v6OZaiofZbKwSFcKQm1vLrxbldGihODLyyb7/Ia3g+eFdN1yHrJb6xQqJ
	 SiGxf3VsBUIVO/6C+Cp8N5whyORAdNKm8lOsWnQgRdsdw6BauXBvP7djMRsXTnJBL1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794523192;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=d0jw8JKgv0n0ezdqZ8dsYLNGQSrLdfYWJ7gZlA49lV0=;
	b=ZgmySYYS4MKdQvj/J/tlG4I7J3Ew4w2fWzWJpgeUG8xzN4GtEGPDeKT7ws1cHh/fuBqO
	 Z3DKtlWgGDcF8sixk0xcll/9PG7xXzJMRJ7SlMYi5kD/xPcFaFqpzXhSN2KpeDg+S/Lww
	 AK4DnjNMeQig9I3ljlgqPQEMIf4ryznwyb5tnPYLfc7GyyTADi91OW74dk8jDwcbPwq13
	 XsNWQ+uHn9IlnjCkQ1sOSePAv8DWc53g9pRIDmhPAvqhqvpKRqsdDYexaDTpkfjhMvqyg
	 z9KD6qfLjB7BQEI/BCMWXKuJ78FLxCujxYGHxYFoeSjhR0EYR+mWFjj+3hzH6COaQVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=V63K56ZY;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fj+43oaQ;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692E6606A8A5
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 692E6606A8A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=V63K56ZY;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=fj+43oaQ
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACJZtFq3121401
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	d0jw8JKgv0n0ezdqZ8dsYLNGQSrLdfYWJ7gZlA49lV0=; b=V63K56ZYhmMmzVzi
	Abvhos0ZhgGq878N66gbiQpvGPsraM5OnL7XP2Qof7LnhO78uTu1exsRapupGRDp
	hMh+Pm/TmhoVmH75rLbqRM+1QJ7PgEs4TWHDY8YslJUW27q4NZNPfes2ZyMQFcWm
	eQdIHslArBMU08yLQUmBmodWUZ30+ah4iOYQp2F90dSK1e/zPAbgX5p8DNBcT1mW
	daqj9GY2wl4o7r0LxHzvNXHNFdHahSPt+wtmp9o3gve3KFMi/gZzLJ+k2lKU7mzv
	lRN+J79LnAsL7YpkNnGDuSps4S6VeNBZ+jV1OgzDabUoqPteaYQBT3zqnFMHS8Rm
	Zzpzgw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hwbx32gyj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:51 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36f26e6abe9so394028eec.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794523191; x=1795127991; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d0jw8JKgv0n0ezdqZ8dsYLNGQSrLdfYWJ7gZlA49lV0=;
        b=fj+43oaQb7W17VghbCtiaJXL6dS3HCupr2yoW0NgM4Vyos/XAZ8QLRD0+BQzivJC1Q
         MT+M1Pk40l1v29lvp6bEoPQc+NLmjchyODP/g75H90zAw+1/IoEht1eveBWhcuXJiNXx
         NixaxkG5edH5wjNmFEsyPp3T9AzbvU5HnLkYlpEaFFfHjwxQWPqzr/5mCvMPrudGNzwT
         Rdwr3QFhXz0uei539IIpqGybtzXauQLIyLuGEEadZRrbtl4gcWBV0TY7U8COKWjC05kl
         PLMxEo0V1n1abVUmLyr4dPqIgsXmwe2ya1wG9pgeMifPxfgZgzO3LpRRWL2fPJYL84uY
         RZJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794523191; x=1795127991;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d0jw8JKgv0n0ezdqZ8dsYLNGQSrLdfYWJ7gZlA49lV0=;
        b=gtue3HaJrf75832YWDD9COAeg1GB0AG1rBUNKVJZG357m/ja5J+n1JinuHhRIMdBWq
         1glZ+fESR819D7P8eEqoTPUY06QaGYVVPXt0ET2MosmuYoNVmvKgTTBtIIuSQ9JWKWLj
         YOquI36/azT+9gt4w5ZExWVWH7q5uWcafxPLeHtFkZoEAOmu+E3S8xwQxJrqROemzrcP
         whB3v2aeBq5UeZBXiAVIKW+goPM1doIMcUL6rIGM31FVuR3V57I4978qsojHXbR82lZ0
         qQUQk2VoHJNCo/tTvVuCszLbEE/NjD5OOCHmHjDWhd8gX/UBwZf168IgDVC4lj0FUtQb
         wkww==
X-Forwarded-Encrypted: i=1; AL+hErGCeMaAdoVQwWD6dy6vM/8ca0ljgsnucdUS7p6aPMAmltGW5stxdD3lawINHoL6YnHegUVuf42WDCiKbUI=@vger.kernel.org
X-Gm-Message-State: APuU4Z9/8UYUDIYVMll+Op/okZpc5nAzepMznGbL2LCsfavUvtMzbDTP
	rJ9SviDynj5C+krFx5wQU4R9c3FDLEIpMyT+aDgr0sHkRcqcuoevk7SGU1qGtAjVpBBY9qXTbEu
	p2+UJHPdl/C+ZiqBHr19CAA7hQiP4QpECPsMfdwIXFmUwLTvoH23/4H0DId2e3Ed0g9A=
X-Gm-Gg: AYBFou1GyMbF8U+nfNfA7DXD3rRjMvMCY0j1JUeHw9MeNtz3V1fK29y3Q6q5trI3kmZ
	QwToH/z2FUaaZ1bpgFH4IPTOlz1WdkY5D6ljKBMNhdX4EV4S5l7qcAFwU7/AvH//jILN/HN1E3T
	fr72mci9HWfZRjQdY8syvBbAqTtcJS6PSqEKBsURokwMCYpktzxesDndrslSsKSozEAm+xA/sgQ
	PXNLQS8JL519tMgMh1zu/HqDyux4mktMCxS6gnKIuwfSdkVg9MZltm1x72AUkVEnAxTm5UUK2QN
	I4ni1u6091mvu4a6tEADbtxzwy5FvRUnJppLX5MiknoEPoU6IffRERskOuN1Zkkhw+FiDwHbF+O
	Kf0Oh0D/5hM11t2EshVg5CnOrQ/A3znPavJXzvUgsTpgrbrrQ9QyI6dZwTeYFhNRdbvcNfwSZxs
	hd3/QJ5FopSw==
X-Received: by 2002:a05:701b:2050:10b0:18d:5ef2:1644 with SMTP id a92af1059eb24-1b5031247b2mr877023c88.30.1794523191090;
        Thu, 12 Nov 2026 14:39:51 -0800 (PST)
X-Received: by 2002:a05:701b:2050:10b0:18d:5ef2:1644 with SMTP id a92af1059eb24-1b5031247b2mr876999c88.30.1794523190428;
        Thu, 12 Nov 2026 14:39:50 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm2333496c88.5.2026.11.12.14.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 14:39:50 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 13 Nov 2026 04:08:32 +0530
Subject: [PATCH v13 6/6] arm64: dts: qcom: lemans: Add OPP-table for ICE
 UFS device node
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
Message-Id: <20261113-enable-ice-clock-scaling-v13-6-258dc817bd63@oss.qualcomm.com>
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
        Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=S+5MU4sP c=1 sm=1 tr=0 ts=6af64037 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=ASeq7m8wwX9lxpDCPrQA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX1BnCHaiPW0sy
 tuI6tFqImoZb1JhuTorwnOAAq++IECcaj8H940UHWHuYqUxBNfA7aXoQBrrGv4a7a2rfvhtbKIv
 731ioj3rC9eQ6wwoAhYoONhfNWod1DNYQLVX2TMwNuUuCIkvNA8aaM2gKXCMPulvxsp+q1lIMHa
 pxkupSlwXPZ9y/n13qePzkx7gmk8Xjj1z//cAsxcRmCfPqkT9olaykDVaWfolVHWnD+4oofiYq+
 fyUXkoa/bGUNsCdAR4fsAOQwfv6+SXNGqtIGvNZIbKKG3azbaQTI87FgckNuvyBnOFeTx2o32BM
 q6IhOxIdfXLCFLfdJL+f/y2Z3CoJanRQOZTj7XaWSRnK6z2/+zpK9NExHyGmD8aGMl25sddZ/IM
 6jzOkSABAsLW6ITR2RzlXnnV5d2v4NXAvGDaN/XgMOCpXNzn86VS2VPTzmoSVB8lSAdp5pVAPQB
 1qb2VA5KERJXkzr0iaQ==
X-Proofpoint-ORIG-GUID: D_pbpQbyFjIlqMVNEu4OESP911ERrUQr
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX+tMX7xh4LaCw
 sTmOVacacFHOimQECLn1Zb3Xgf+sRqxT/Hkaeh5OdnrtCzz29h6VvMzVxXjQQ1zkHKoTq7Hf1/c
 neKe8LRLIMIebYi8ajCVNg+Eur9tgww=
X-Proofpoint-GUID: D_pbpQbyFjIlqMVNEu4OESP911ERrUQr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_03,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120090

Qualcomm Inline Crypto Engine (ICE) platform driver now supports
an optional OPP-table.

Add OPP-table for ICE UFS device nodes for LeMans platform.

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/lemans-embedded.dtsi | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/lemans-embedded.dtsi b/arch/arm64/boot/dts/qcom/lemans-embedded.dtsi
index 0be39bb9de1e1cdbb7d67a992172861a5a10a05a..a80fd8f96427488c20205c5ad798413aeb53964b 100644
--- a/arch/arm64/boot/dts/qcom/lemans-embedded.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans-embedded.dtsi
@@ -1840,6 +1840,32 @@ ice: crypto@1d88000 {
 		clock-names = "core",
 			      "iface";
 		power-domains = <&gcc UFS_PHY_GDSC>;
+
+		operating-points-v2 = <&ice_opp_table>;
+
+		ice_opp_table: opp-table {
+			compatible = "operating-points-v2";
+
+			opp-75000000 {
+				opp-hz = /bits/ 64 <75000000>;
+				required-opps = <&rpmhpd_opp_svs_l1>;
+			};
+
+			opp-150000000 {
+				opp-hz = /bits/ 64 <150000000>;
+				required-opps = <&rpmhpd_opp_svs_l1>;
+			};
+
+			opp-300000000 {
+				opp-hz = /bits/ 64 <300000000>;
+				required-opps = <&rpmhpd_opp_nom>;
+			};
+
+			opp-600000000 {
+				opp-hz = /bits/ 64 <600000000>;
+				required-opps = <&rpmhpd_opp_nom>;
+			};
+		};
 	};
 
 	lpass_ag_noc: interconnect@3c40000 {

-- 
2.34.1

