Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794985243;
	b=UXOVuVGxkpGjq8MqkrNrHVcvGC8RksWDVCzv/tCowyb2m2jk4sMWs00zqX4EsIopon4Z
	 jnrxMEr3O73/d2ATKu3vxuz1OeLrL0iqMtkE2yOsIpp9GpTWHTBmzcRSzqV6E/FC02sfT
	 LuF69biLGH861ver7Tzoc5lstjph5cHyy7adHN33ig23w03gYqAQxaql0S0aIzv6Lpl5Z
	 Q+9nU1qM61e6BYv2cZujhu9nJZGGrJOF6vogjO3HrURhkeoXzewGTLWqRx0a4q7YtBirA
	 Cum/0cXr13EILCYrmQWEpsOhQ3cdAVMi/mfPi7eNydAeodfQVfPKFZvUPkXNvvqWeDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794985243;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=jo9u9+PBJ84GTa0K5GJh0WhOUQmTKn1rL+9PA2nR/ec=;
	b=KplLvkDA0ayMqxAm1xzOBOjVMOmxY1kiEOlA1DQLQY+EKy1pRG8GSlSACUQP54aDcQ0C
	 PHGWWkhdix3Adiw6G/Yh13B5KPScQtOhpF/Muv/0io5jok1gr33PxHsOSOCChHYdWfQKa
	 7ro2D2ni2yAW9qd/PBp1ndYBUAPICvIsmu5UMunje3Xu3PVYQ7S0wseQz2d/RIwkdrzeX
	 eA1w72YFcg8i+qkygVB6y5ToEAyKxbygGzAjUnIeSloZJoxY0izyGPEn0T7hU1Vm+14I0
	 QnaOvCuLbmo06NLyNEGVFKKGM/sffbn0DUrrGIKHnqwDLGbGb4j25bS89k0QgGMyDeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Mjhh3aSj;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=L24lUooc;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A98A606A330
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 07:00:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A98A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Mjhh3aSj;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=L24lUooc
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI2Uwsk2602449
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 07:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jo9u9+PBJ84GTa0K5GJh0WhOUQmTKn1rL+9PA2nR/ec=; b=Mjhh3aSjO7ez2NXN
	TVy931wr0fd/ykGO9i5oO61iYbEkQfjhRzDQU5VR938UJ286w8guJNsRqz0k1w4G
	KKp20K8j6Yuamm2VeCozxY5Hf5C149x1VWAGMme5Jk6G+nisaGoiLMwyTKt8K6Cb
	jbYfkKWPDMn2GExzMaW6o7cnxT6drIKkOJPM5B1L+UN3ZomAm6/0ITp+hbp8ll+y
	6cJVfLQgnZ5vKV8l6aYY4FgGXWvVaf2lMniGZWkG2iUmIBwq5hF6dITwV/fjQFGn
	/BSDgNP2H563W4NLf5KazQbYTVLg0Gz7UXz1JVUo/faTXTjXiti1mB5sspzg+VNS
	XQCb9w==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j0yv71qh5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 07:00:42 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3aed37745bcso1508825a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 23:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794985242; x=1795590042; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jo9u9+PBJ84GTa0K5GJh0WhOUQmTKn1rL+9PA2nR/ec=;
        b=L24lUoociFyYcoRpMUbaUrloxqkg1UoTFDdhf0lZ6bp5KzRSTYzByns3b4GXhft0TZ
         EzqII6bl7QY5RkgOBcU2i+xYFHdZ4K0aQrRdGAdHcwvxA4J34RqW1gaKXkl5+rNKstL9
         s+CCDhEkBKS/D38CZNj6y0MFO81YEFn2cC/tKBzfKrkro8Kxs3QvvcXsRPOpEiQlVAlE
         cDvrXMh0C6IgK+64cMM1AdM9rpzIqT9yKrZBW6PKl6sjTmG/fxbvV0KKPRoy2Wkz28t/
         vIbuSiCJ0Db0RaoJGSyW+STN7r+IcWcx0gxcCTTi/AWIfytiDXzUvUHMzyM0kdCQwJtL
         ym6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794985242; x=1795590042;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jo9u9+PBJ84GTa0K5GJh0WhOUQmTKn1rL+9PA2nR/ec=;
        b=Y96MxaQrZmBVPNjqfS2a3+K/H+ZOncI1nHqWq9Zi5PHxrXqBkqxUmJzjBQylfTKPgu
         IxYgCvEZ5BNwsK/sVD+iJgeJzvVPI3bwC3rd4Q9s7rhRFnrEJv6W937+/UDKXU2tyWwJ
         ywUOLxL5CusBqK8713eg5WTR/etNsNPTyN1uf+00EARx/6Wjjf/v1Vv4U9fx74+nTXM1
         RJd6lzapoo4TK7aA0Ds/LHiWYmMnyWK70dvxQJut7AiG+BZNu8DiwjRKipEtgI0LACJj
         aGHWIgQxF8vT4lHYkQJ1ch6OIde7uK32vi1OxJriyu03avEZo8dvjQcWNSr5pSbRJMpC
         KY9Q==
X-Forwarded-Encrypted: i=1; AL+hErFdn2mSvglWTbJsxA3q5HEN4BT0pMRnE65AgEC5ZHNb1BP2V3qvvCgoqf3bNubFPGnoVk/1A27bUUZKrJI=@vger.kernel.org
X-Gm-Message-State: APuU4Z8u6Qm0tzJjEAXLbb0uxG9W7fkDSp2uF9Wv97eYal0hdEvqWso4
	sxAnUDopupLBltZ/wMB/NtTfGFevP7VDMVbaT7Xa5P07VWkMfcw+I1/x4UpmoPwhynxREH6jitQ
	ElO0pwsKZ2q9DSvfMraV7LcQSVgZSKWeuI5lZGiJBD7vvzCXC4pIKOpTinIfZX9xb7bc=
X-Gm-Gg: AZFdTZeDMgo8pvWMDU/KlsSREGWEtX/zmabid+d0GqXgAegLV5dDioC+VPr5Y6Iju/F
	jlN0o0HrXmGubwb19LXbMrP3AHGClpeKZJRYLuh+TR3RPAlDr+AwOE7jNJQ+fUKw3LM4y1Z+QX2
	A/xrJGyuiLAQ6kWzyx7GDWye0IYZlfnzwbgzSauJz46epZrrztuYu/VZzIVhUQorb0BIlQvE/r8
	ELCWTQPBNXc9RpcLeUK5eU2ZLgKDXhciycvl7IJwTfqOhjUynG+XcWErxwGe4uK7CgLVqWnbGGW
	vZLymlyuUvp1iafTp0Bsm0QWDG4mXB8qkSLKC84g/L4t6UpRhn3GVecCV49spmIM2KnFtB3twWg
	HT8JvgNan8JCOr70QO5su/1nOA3ylwvuG0pmQd5uDGHz4OWAD7yQsjmU/H4bmNw1lZLJUFagKdZ
	6hra5diEZgwppTv4biMo+YerDQFacWCveRfo7bi/FG66qKPw==
X-Received: by 2002:a17:90b:52c6:b0:3a8:337d:228a with SMTP id 98e67ed59e1d1-3b3d063d686mr1328344a91.6.1794985241515;
        Tue, 17 Nov 2026 23:00:41 -0800 (PST)
X-Received: by 2002:a17:90b:52c6:b0:3a8:337d:228a with SMTP id 98e67ed59e1d1-3b3d063d686mr1328319a91.6.1794985240906;
        Tue, 17 Nov 2026 23:00:40 -0800 (PST)
Received: from cse-cd04-lnx.ap.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d1acd118sm2743262a91.12.2026.11.17.23.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 23:00:40 -0800 (PST)
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Date: Wed, 18 Nov 2026 15:00:07 +0800
Subject: [PATCH 2/2] arm64: dts: qcom: glymur: Add ICE node for UFS inline
 encryption
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
Message-Id: <20261118-glymur_ufs_ice-v1-2-2ffe4bb931a6@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794985229; l=1345;
 i=wenjia.zhang@oss.qualcomm.com; s=20250717; h=from:subject:message-id;
 bh=KHd3LqwnyiG0pVhCXtBEcbPxB3BOCYgV9xgOZWJOkFs=;
 b=YA08BRPsTEF+DX3j64cLFrES8sjyl6AuQ8kXok4j/sMW6RoYt2SmGUfgNVf9NfaL6ReH6sNL3
 OyFrNilx6m2DEWuMPKnNQ8IDfjovRJ5nyTNHDVyWt0nBQM6IahgOWkT
X-Developer-Key: i=wenjia.zhang@oss.qualcomm.com; a=ed25519;
 pk=Of53/+6KgVgPh1R/xUMTbXVCnBiHTmHby8ySh2ShLtw=
X-Proofpoint-GUID: HJ2hfKoCnMpkCnXKzSwenkjkzFOjvpQV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAyNyBTYWx0ZWRfX9ayxFZaYMf+D
 0PFajnOqvnp3Ep2YzfH7BqZcYPltRgIDaMUcdy65yiN3AE04aIPn8zsvFRRywWea8LN6MXYi/84
 sgN8BEvSkAqpcn/j/2GzswB7rZnbSUa3+dWlr5DLy9z37d7VjAdhrdsQ9YMCsYI5HqweXslZZTQ
 gv+7BBn1RTYoV+7ZowxpEKWXaNKwkfenO11YRlAjOW24m/TXnMas9CY2vynQgGN1gJAKydmaOXb
 xm608GcFvmql28e9NdH4J60+Vf/B3zBmxzjGl9uFH0Bv/T3dD7tqIeRSjzOFduJlBN4UigCzeBu
 8JgAjw+yodbK7/tRXg22WJgR1sg1bTzGOAQRnYYxW8P9nruPHuj5+Et7FRs6+WyoSCVBysKEd/6
 UjZFea0tGoz0nwl/IxuV6dBj+YlInwEDUd9dt77IJEv4VuzTxZq+EKwH70n3tDuXriWIw1tDLH9
 akUz+SVEwBK7uZK4BDg==
X-Proofpoint-ORIG-GUID: HJ2hfKoCnMpkCnXKzSwenkjkzFOjvpQV
X-Authority-Analysis: v=2.4 cv=H8xOUOYi c=1 sm=1 tr=0 ts=6afd4d1a cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=7g7wA4PAc6ioHu1SxIwA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAyNyBTYWx0ZWRfX9Nru5CaPruMU
 hVP3lqTEyj1cXMtteF8s712ZrNQQINegKrt5B8N48JuDlBIHkaY7a/D02/FMOSll8IKIaebimgl
 F37OgtYMIwmWPtwiWtfoVf4koTu6vBk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_01,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 suspectscore=0 impostorscore=0 spamscore=0
 bulkscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180027

Add the Inline Crypto Engine (ICE) device node to describe the
hardware-accelerated inline encryption for UFS storage on the
Glymur QCB board.

Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index 165dfa11f17f55478cfda09c3db2143a1e5b91b8..ba949704e3b4fe2aa497873be6fa0a5cd2f3a1b4 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -4156,6 +4156,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			phys = <&ufs_mem_phy>;
 			phy-names = "ufsphy";
 
+			qcom,ice = <&ice>;
+
 			#reset-cells = <1>;
 
 			status = "disabled";
@@ -4201,6 +4203,17 @@ opp-403000000 {
 			};
 		};
 
+		ice: crypto@1d88000 {
+			compatible = "qcom,glymur-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0x0 0x01d88000 0x0 0x18000>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
+		};
+
 		cryptobam: dma-controller@1dc4000 {
 			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			reg = <0x0 0x01dc4000 0x0 0x28000>;

-- 
2.43.0

