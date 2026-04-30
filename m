Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F241940DFDE
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 03:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777519306; cv=none; b=G/1z0uEL2jEWwzDR5HWU4DL9HqpePKqym8akG3F0NGSCou1E79V1ey+GawxpakMtyW2XN1xH6eVuyfu6g0Af7/ViVtilft9Xl+7odBPc5XFYo6chg/4+SSD+caTy00FmMArB8L5JLzNQzvGnwpC/f37C2jUJ/aa62ERm68J4Org=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777519306; c=relaxed/simple;
	bh=uEo7zaCsh/uf4vxt4ajAnacXjK7944M3mjrrLv7CPaA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GtRGgxJ+fwCULs2UXF8qGBLyT8ZnWh1vf0Jejym+dhnTUQMkjvBzdwJWpAZ3iEuGs/jEhPJ+1GcHY1q1mUu4kjK4+xtRobypSu1/kGmt2WRs+t9gMsDAGs2sNXtqMaUepKAZ7gOR1EqbtcUMKseosZRtZW3lovOJbeUbQLvYG90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Rx0Heh2M; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ykk3Fe2N; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Rx0Heh2M";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ykk3Fe2N"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63TKbqhT1132965
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 03:21:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=2m+5w3clrSY
	zovj5QjtuRiasc4IUCrKMC9+BCcw+7R0=; b=Rx0Heh2M1yQjoeX6Z0c3QLKI94v
	3peDiEnrxfH8FKHQQTbV3MEmVfET1Q3lJfa34fT1VEKI1U0m8adDInoIlKqJQEG6
	KWX+9NcDZxSMp2s0XVOvLUaPDM3L41bkFDGvXlADywQSuE3uA0TdSx8T9oh7lucM
	uCPWA+FF9JNR9iPKGCgwXUc+0TjA1LX7FjCyfDnrwvKoJ2zaAVEh/zJXlx1wMtbD
	YkyZ/zDk6oKqevuXJbLHzmUT+fkBtY/S0KyIRosE59qrh147NKRd8AtB4a0TLRQ7
	5ZumC5gVtqzZ4uR2iMVocXSjEAuh3TuFf2x+MLo/8BClG/asHovcakkXunA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4duch1mj1k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 03:21:43 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2bdf6fe90a9so946041eec.1
        for <linux-crypto@vger.kernel.org>; Wed, 29 Apr 2026 20:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777519303; x=1778124103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2m+5w3clrSYzovj5QjtuRiasc4IUCrKMC9+BCcw+7R0=;
        b=Ykk3Fe2NbJKMwbI2HPB5XIcDswwWDZw06odBPdkqNx8hHPbI9zajJ8aDsVPPoYqgzi
         Rxg1OYUfJlh0ILGPytkr7WnBDLxCj3Wp7ZlEIKe0lLYm4R/rmEezqnty/D0GYx3kGw5Z
         t7XR0oLSCuXLL25MqpsoH6nNOdxZjcaAyasq7jOFDprF/FJg+Ry+6Brq4YcSdj+GeCW5
         WztWaS3/2NUwh1d1splfdInT3X/eUrnYkVm9HRDgkOcMxeBcc+rzaPE+xs2LaDyEPReb
         tWrIJMS7m3o+U7Osr0sTXEZeW6RCsXJTpiISOXj4mjL27/XW1Inh9fxBZURknEKjnwUS
         iZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777519303; x=1778124103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2m+5w3clrSYzovj5QjtuRiasc4IUCrKMC9+BCcw+7R0=;
        b=myTDF8WWmYr9YLOlx6Ej2oQpJrofvn0crp1fQMuI1Am7pKSyYArVPfTSxs2RpTclyD
         wzrXITA8WYFff8KDwtjRnUk3o6ONaakGU8z7VmbcuMvgzl9wKDAoDtMO4js32cVjLumx
         Ud4QTrtlI9Q1Ly6RZRf5mdtTKhubbuWnmSvFtQlfrwGnunOxz5Smne5xRXuH4JHox2z7
         5NJPNQonCW+9AtSsmeQeNQaq3FzhhRk75GtM42Je6CzxpTpzpzzD0Ragc4SX4LT9AfnE
         2bE3XYNGbFw8a3CxbuhmOTzhBN0DtHy4FVlFITdJn89T8E8w3N4to3oaItosZBHOgW/S
         ucqw==
X-Forwarded-Encrypted: i=1; AFNElJ/Bfk3MIAOBfYd+Zk7QQAWShJ4YhHl7zMvR33956ih+oO80lErTYzek6DwTeTdoAh2bGEWfjYgRKgE4+ZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHew11juH1UCZH3HtLdBRDeG2OJiejIiTgcbqP3H0T5QI/9Gf4
	kidIufrDeBCUkRLqXHSXjr/630qzMKR0XisSmG/9Dbb5pmZ6FxoGivEbEnwGFTvDJeR33O8Thho
	qSxleQDyUlpVl2x7/fsCrp67YfLQBHr+QcwnNha8i12u6q1CMOflMphG5m+Facu1IOFw=
X-Gm-Gg: AeBDievzL9+crNYWbJ+c1QuANgwjxlmvcuCxn2rAx3peeqB7RtKGq4TerSf1/hyOLMf
	bvMYPbIiAD8NoOf8ZKB/p6A22HRJRsVPGwv78uj/IwJ1o5jlg/ir7rsFji9FR2MmGflBHkT3FoZ
	O1gyPHr7YWgyKrn2qxPJriEJGM1ibNBxXa95ox4LVAnyHgv7ZJPAZR7PLcalcgHGBo2wy7xQBYm
	tvhyI0CtYVuarrJUWV3MRTkehVZiDrapzw69EGcoAkEYGvVf3GVH+GWgArboFlpG+ttu86LO23u
	j3YPSHxRIf37JMnY9zEiSu1dUdvw9/5iTzoos3k+zVWuToY/HJlqz6QvZaFFSYLHySYhTDCxYtb
	NYSaaZ1LcGzpWS6vWBG0ol52dTPwhLFcWnuKWUc8wRutu4aARvccVGyL2aaZrM61VmSyQur4xKz
	byFxK78IHypbzxHBs=
X-Received: by 2002:a05:7022:b88:b0:128:d375:f1cc with SMTP id a92af1059eb24-12deac5fe8dmr615659c88.12.1777519302628;
        Wed, 29 Apr 2026 20:21:42 -0700 (PDT)
X-Received: by 2002:a05:7022:b88:b0:128:d375:f1cc with SMTP id a92af1059eb24-12deac5fe8dmr615649c88.12.1777519302112;
        Wed, 29 Apr 2026 20:21:42 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12de321df36sm7572644c88.7.2026.04.29.20.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 20:21:41 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiggers@google.com
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        deepti.jaggi@oss.qualcomm.com, bjorn.andersson@oss.qualcomm.com,
        quic_shazhuss@quicinc.com, trilok.soni@oss.qualcomm.com,
        konrad.dybcio@oss.qualcomm.com
Subject: [PATCH v6 1/3] dt-bindings: crypto: qcom,ice: Add sa8255p support
Date: Wed, 29 Apr 2026 20:21:33 -0700
Message-Id: <20260430032136.3058773-2-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260430032136.3058773-1-linlin.zhang@oss.qualcomm.com>
References: <20260430032136.3058773-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=arGCzyZV c=1 sm=1 tr=0 ts=69f2cac7 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=UuHxjPGgWbCNvu6MkpoA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDAzMCBTYWx0ZWRfXzjsXrqVDcdYh
 eAt0/iOGY+Mzu1VzwKudq/Wn4sR3sg0s5XQTQ64O105ld6FK9aK5ofLbQVHEkcfr+Xk93EmEt8T
 gJKPvR0KdqPE2s3dwM40X2tzw8XqTCY09iLf+vbOhTfPAPjioNrYQ2P9lFbqJuM4h0gVTb9Jhva
 ma4K3tmUyU6bTgFkknCPB/4/yYvwAaeQw3ZQg0fg8+1uKmyxgTmznDhai5VsvduchGM8XkHWavN
 YM753X5i07uSq8fctPEsdA/9hpR7eQcrg29vIiqeE/NHxFL2g37rtfCEcqp1iWES2fLKRqQIQLR
 XD2k0sEQjyUCJcGDfkezarzLDdyfPSXT0/msUCLjxSLq1nohz+sCfvBDCp39wcUvHMHFHGel6Vw
 sBvei3xkfQFuRzuzkgpgcIdM6JPMKCTs27wdNFqYo8Wp7URWsNfoSoVXJeUbWGkXsaSEENYKF4z
 CQBa4emK+x+ldhbgU0g==
X-Proofpoint-GUID: Rmy6AiVEVkrgZtRAM_F0qQhpOLZzOa3Z
X-Proofpoint-ORIG-GUID: Rmy6AiVEVkrgZtRAM_F0qQhpOLZzOa3Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_01,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0 impostorscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604300030

On sa8255p, resources such as PHY, clocks, regulators, and resets are
managed by remote firmware via the SCMI power protocol. As a result, the
ICE driver cannot directly access clocks and must instead use power-domains
to request resource configuration.

Add the qcom,sa8255p-inline-crypto-engine compatible string and make clocks
optional for platforms that use power-domains instead.

Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
---
 .../crypto/qcom,inline-crypto-engine.yaml     | 27 ++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 061ff718b23d..f90e5da550db 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -16,6 +16,7 @@ properties:
           - qcom,kaanapali-inline-crypto-engine
           - qcom,milos-inline-crypto-engine
           - qcom,qcs8300-inline-crypto-engine
+          - qcom,sa8255p-inline-crypto-engine
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine
           - qcom,sc7280-inline-crypto-engine
@@ -31,10 +32,26 @@ properties:
   clocks:
     maxItems: 1
 
+  power-domains:
+    maxItems: 1
+
 required:
   - compatible
   - reg
-  - clocks
+
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,sa8255p-inline-crypto-engine
+    then:
+      required:
+        - power-domains
+    else:
+      required:
+        - clocks
 
 additionalProperties: false
 
@@ -48,4 +65,12 @@ examples:
       reg = <0x01d88000 0x8000>;
       clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
     };
+
+  - |
+    crypto@1d88000 {
+      compatible = "qcom,sa8255p-inline-crypto-engine",
+                   "qcom,inline-crypto-engine";
+      reg = <0x01d88000 0x8000>;
+      power-domains = <&scmi26_pd 0>;
+    };
 ...
-- 
2.34.1

