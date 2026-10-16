Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D30457E71
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 11:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792148940; cv=none; b=VU8zyp60llFv7vHpXxjBx/lVDlvEO0prtz5jdmz/6IV26WOGb7aqRmlFSxLTcVBq3gqNPJcThnzIEXBd7kzz7r8uPRyhJwHiIzTEZX2YykoNVMzQ1F9GCHEz+rwXA2JKOju+Z8yZuDHFpGQIrmLIFDwt2VMnCImpwFnhyaSbTno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792148940; c=relaxed/simple;
	bh=+Mqjw/52ocTM6ONRI+XSBSoq2w+qKyPB1f3+Wxqs0SI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=tCp5AtINGNz4d/nEi6uST2zKic21wCfJL2IiTdPa/OSWtlmRogNDAbxT5CEPPtM7YSWd01wqk0W+eC3+c21qY2jRCTysSepktxf3V/KAvLboWYIYdWo3yGidFp0n/1Aw6wke1H1BTxRbLzMpIgmx3yEBxEs6a4JUZwcOi/V5C1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BYSCw21T; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RDd6ThCx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BYSCw21T";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RDd6ThCx"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GAAIgH2998528
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 11:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=gWl3ZUACDSH0+HI0Kf7AzS
	vg7+UULz4toCsh4XD7F8g=; b=BYSCw21TXr+X39CJyRfxHmYgu+/2fDVtYI4ARd
	UWsWKot+0Fdiae0kt708pyGihunSAmEmYUxJlscQzsKY2H7by+naeSSAjLLznQ9v
	d2IJ8NrfEofyEkXqmxK2eJQykZ7FNiztLuw0pXTjD4sQUydpXaiivLoe2SnvGQwG
	TSkMddyL8hzXGssPVhRLrpVvweS+66+QVMwN9Ze4JnqezHLJZEDBkCe6VjCkL/2f
	OO2aEdvUvoM4bhTYFiZOj3b6gKz+JoIlUzD4Ucf+Imnoj/rejJAIYaZxVjrr4c7a
	1ZUdF5Ot15KRHNQ14k/7uNyNizIvU53ahM56ATZD0eJ3ehQQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb8r1291b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 11:08:57 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3510d0baf63so9038487eec.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 04:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792148937; x=1792753737; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gWl3ZUACDSH0+HI0Kf7AzSvg7+UULz4toCsh4XD7F8g=;
        b=RDd6ThCxEDKa3383MToKKmtoIINrp9aUL4YEsdh/7iFHhD8ElWr50KeLwYdoewrGgD
         bLdmP8oTL6ftxeb3sh738nVl7xL9OCk5uefAeadsOtNCKTNCbCI+BQhyLvQRk9QtdQJS
         qTJ9WT4L+t3b/GPxNO5VevbdZ42mnaxafmuM09/3lDmkukv32Wb2sGtOudUdc/wP33Y7
         tmlRgjiTOqRYwP885CnBxObLfOn9/oIR8vT3OMMJLIOWhQlBDI1lJswposqBrY0kXujV
         xkxtIEdP1Av7KwhZtZjfdMfTF8GR08fYN2HeaAOCuTIocUSvn7NFg4JjfriXee1LOXeq
         WvHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792148937; x=1792753737;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=gWl3ZUACDSH0+HI0Kf7AzSvg7+UULz4toCsh4XD7F8g=;
        b=10293dV/+SFYnEMOBpftYXeQRweXgEAw0xpuXSAsRkiMxXr1SEkPAMkmzVm2qF8L8Y
         7e2a3vnviYhEMaufVHUpiZNI6TIR+V0CTlev3nWv5AlPAp8yG0HpbT1Eg5SRnVd4unSy
         82PKNWAv1ugBp885UNIMmVNrWpnUNTEJFQubUFb7uxSj/KZ+mL2ZmleYklq+yqS8QnMI
         ngRoFo3Rp0indDYmdTShPJy/IVTk/nq7AiQVeAs/NHL6U1BhHwBpEAhKpwu643mkL15o
         GdgWirnPgvxW6Bx1zNC/9+EJpQDpX/MjQ1HPXoxrUecaNZ2zjztHYGYL7uNeAxV63Bbv
         +V0g==
X-Forwarded-Encrypted: i=1; AKwUvBzN7CUuelMWpVnxftmX9Mex70ImqMisvCUHezsoMt7VLqlPee8rizs/Ld3LO4xDsf1EPMaptbID4YTEj9Q=@vger.kernel.org
X-Gm-Message-State: AFq9FYLDH4iRFhBaR17UgOnHgXpmwC4VSHPXfhZFM/Wqmvl9VzmIHzKc
	/2ovndzHF7LQ2ayYl3OF3M6K7Pg6ROxyV7B6c2B63+xte3c8/ZV9wLSdc7zqTHEa+WGzJjts75F
	5EenuwposUDmZXbmxacC5M5bR2qZgCNYIkuT5T11o6OgGjEClxdtMEcMaq+73yHS/wEc=
X-Gm-Gg: AYBFou0O32+lE9FzHzZpoO2Dqj57rb+YEZgMfVvy+Jdaf1LtZlkdID0nKtLg+LTYXBJ
	Yy77G6wH6nt9qgitlXxC6W5m3MgYmJtH3wzZQiYVDxp1M5zP3Lg3THuslakq4b7X4YnQ1T54wEX
	cCe/wtMlZVYxULl5QwsUa1IP6wRaLNhThFx0+3KBHEXgwcbngkDmM7gf1OTPRV3C4qIbinndl70
	2ZVMuEjHwb140zgEeWS2N+Rz1vpavPsN85KvcivT+mwyjgBLBj6lUuqW/RCYNYxOfU5xvFDjlmu
	gjzuyGJAELuruy8pDN+IzRYhTbAfPoQ6ubD1+TPEc14UAtAp7O4GvuA8V6XNj5LBzRYt8k1qmsP
	L1hcOTqTAa1k2zMYouG1Jped9257ISdLNUjDsk9NXLystx3AH812R4r9ICtTRZq7DBhxmkL7l58
	5eblZ6wc7ZL7zTZhwhVqVYwW2y34Tnrw==
X-Received: by 2002:a05:7300:f814:b0:361:1dd6:531b with SMTP id 5a478bee46e88-3611dd661ccmr717543eec.26.1792148937218;
        Fri, 16 Oct 2026 04:08:57 -0700 (PDT)
X-Received: by 2002:a05:7300:f814:b0:361:1dd6:531b with SMTP id 5a478bee46e88-3611dd661ccmr717496eec.26.1792148936073;
        Fri, 16 Oct 2026 04:08:56 -0700 (PDT)
Received: from hu-varada-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360826875b3sm6487485eec.21.2026.10.16.04.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 04:08:55 -0700 (PDT)
From: Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 16:38:46 +0530
Subject: [PATCH] dt-bindings: crypto: qcom,inline-crypto-engine: Add
 IPQ5210, IPQ5424 and IPQ9650
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-ice-v1-1-4098b1972f31@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAL0F0moC/y3MwQqDMBCE4VcJe+5CojaIr1I8xDjVPRhtkhZBf
 PeG2uM/DN9BCVGQqFMHRXwkyRpKmJsiP7swgWUsTZWurNHGsngwzNgOrtZNU1sqzy3iKftPefR
 XR7zeBcvXSINLYL8ui+ROBeyZ/+Cd+vP8AuPNL6OGAAAA
X-Change-ID: 20261016-ice-e1d8ba304436
To: Abel Vesa <abelvesa@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: vmx4CkqpzTRExn-xz_87DKyZGaveJ4WT
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NCBTYWx0ZWRfX2UMRnvCObMTq
 QxqvxOFW4B72PiErBjCW3PigbDOTiON3vt9Xb3EY9iGuEDUOtJOhW8UFJy9TaCGeXER0CifDAxt
 xHHwT3H3HIi15gwFmHNkDZuyOxQ6X+c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NCBTYWx0ZWRfX5ljH4Z/3Q2DA
 Nj7JU1yCGllXF73iiYyfSFafZ//WF1Am5GD2TmfMzhfpcdp3NqLSALJ94aihaMlh64yeJNzHrR9
 zIpwLEp5u1FOej9qWOpnNy09Bns021ii9QZpOztlQETknkC3x2A5DATnRo1Tvz2QfIzUYw5omYj
 YR18JheqGfMyeSj0AnOiJRJWifn52l04hgkUknypoY9iee07amobAvr5JHLAZ9lKV6RBrXdYzXV
 AAAQGh8A8+hvpQPdrL7FVD1r7vAvWc7jKYnSny5ac1TwYKR4GW2jUWJTvyExXFxNukpcs3t5xtm
 BjVsL7goaTMlZgVPHBdDlj1q6yM56AcvlOL+QKdMAVYj29dTGIpgpi7BsEHX4kUEUS7TWMA8pCY
 tEcBdNHAgwktx0ly3+s4cO43VDstYSyknUBliBtHYtCoJXM00LAmNEibcEbCKe2Ck+SvTHZkfrJ
 TYlevFOG27RXU960Hiw==
X-Proofpoint-GUID: vmx4CkqpzTRExn-xz_87DKyZGaveJ4WT
X-Authority-Analysis: v=2.4 cv=L/CI0OT8 c=1 sm=1 tr=0 ts=6ad205ca cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=Xq4CliCqeop8EqABAtsA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 malwarescore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160044

Document the Inline Crypto Engine compatibles for the Qualcomm IPQ5210,
IPQ5424 and IPQ9650 SoCs.

Separate the power-domains requirement from the two-clock requirement.
IPQ5210/IPQ5424/IPQ9650 require two clocks but intentionally do not require
power-domains because they have no RPM.

Preserve the existing requirements for other platforms.

Signed-off-by: Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
---
 .../bindings/crypto/qcom,inline-crypto-engine.yaml | 27 +++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 23bf98c2b9fa..e838694bb70a 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -15,6 +15,9 @@ properties:
       - enum:
           - qcom,eliza-inline-crypto-engine
           - qcom,hawi-inline-crypto-engine
+          - qcom,ipq5210-inline-crypto-engine
+          - qcom,ipq5424-inline-crypto-engine
+          - qcom,ipq9650-inline-crypto-engine
           - qcom,kaanapali-inline-crypto-engine
           - qcom,maili-inline-crypto-engine
           - qcom,milos-inline-crypto-engine
@@ -81,7 +84,6 @@ allOf:
 
     then:
       required:
-        - power-domains
         - clock-names
       properties:
         clocks:
@@ -89,6 +91,29 @@ allOf:
         clock-names:
           minItems: 2
 
+  - if:
+      not:
+        properties:
+          compatible:
+            contains:
+              enum:
+                - qcom,ipq5424-inline-crypto-engine
+                - qcom,ipq5210-inline-crypto-engine
+                - qcom,ipq9650-inline-crypto-engine
+                - qcom,kaanapali-inline-crypto-engine
+                - qcom,qcs8300-inline-crypto-engine
+                - qcom,sa8775p-inline-crypto-engine
+                - qcom,sc7180-inline-crypto-engine
+                - qcom,sc7280-inline-crypto-engine
+                - qcom,sm8450-inline-crypto-engine
+                - qcom,sm8550-inline-crypto-engine
+                - qcom,sm8650-inline-crypto-engine
+                - qcom,sm8750-inline-crypto-engine
+
+    then:
+      required:
+        - power-domains
+
 examples:
   - |
     #include <dt-bindings/clock/qcom,sm8550-gcc.h>

---
base-commit: 525d50941ea7764239624e4c22ef4d2658ab20b0
change-id: 20261016-ice-e1d8ba304436

Best regards,
-- 
Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>

