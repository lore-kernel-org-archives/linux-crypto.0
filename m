Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDDD48CD75
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 12:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782647; cv=none; b=oY501ucte5cfNF7KrKjTSkuBmQHad5E4FgISDdag/CAQZboj2CqskUkhm3aLI8vg6HTqgjkSkzV1peXYpGgwLSBCsbILz2Ilg8So+KSvtY2gXVcti4+vlaJ2oZ1bvzkC636TBMtYhHPu+mwDQizfmJhaJ9w8njmyqCt7Onl0zso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782647; c=relaxed/simple;
	bh=WAzemNAMBlLHCy0LwRLtLcYV4tH22L1qXU3EjulLZFQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MZ4yX0Y+AqXnu0aMzUmU/MzS8/WezBoxiLOLsZBDya9yIAUniLOcXYVqIB6WxyQeTX3O4g2WIyYC1e17AqTKZRqEjHf103+9aOq/XcPBon24TCutsiHoZR6omBEZin0oDjTk1oHKBTiZM6zhUx/jNV45AE4mRxEQLT0Ow8IUKUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=V0G2IQKi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=U5wI79Ld; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="V0G2IQKi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="U5wI79Ld"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687Amxmv810029
	for <linux-crypto@vger.kernel.org>; Mon, 7 Sep 2026 12:04:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	DVWLuac2DwY39I6nVk6WwXTIYRO7n4Cw7TINDm6t1OA=; b=V0G2IQKitjbPpFxS
	SJ46EyVV/kWyfnM7OSrv4AR3EFHkEvE5wkW25KCrJlzejAmvzWFCr2TIchCirvLm
	gh+x7idC/G1ZMexwXC45mFh1MP6sZYqyhej5YrNmywEF5PpEbLZIXdzUUk3j21eZ
	mXGq1NXf9ZQ+/cK32IEleUGgh5IUN3rDME+KRI8Vos2wexzwnOEwEf86FA6uqdk/
	wo5OH/SurkT9nA6kFFNmM7EePoLyajwY/15rJspxR8P5L+vyE00h7Da5HFEgGdo6
	N8OPEZTzw9TRmbxFZOeULspj1l4MBAgHIW+G2UsMC6BZwbq3q0KwHktuXsLxjG/3
	nb41gw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghrua99me-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 12:04:04 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1c62f0d60so4706358a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 05:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788782644; x=1789387444; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DVWLuac2DwY39I6nVk6WwXTIYRO7n4Cw7TINDm6t1OA=;
        b=U5wI79Ldz0DDbJdD/BEQIsYL8H3/2UjVpgJ1Q/N+cFfu5SCWmeO6wkGqFnn5p3k/k6
         2bn/i/mX+B8RBzHavMYa8OxeYZuZ1EXidMWvA8mSTYxoa6b+wz9xchHgJSU+8rmj4PHU
         fmr50wsM1t5W+0kveK9/LfkqSIU/SMhBnWf3iyeUJGjQz7nZbNeGgU+wkadqFiWGODQg
         NQN70KqsyeVhUB8EXZEnJZ0eEqUTj1rPMvgvVyl1Sm++ybz8JgZIAet5B8tNGIA5SS19
         eucd6IdBSq5JvUZcQjwETP3gZ/gnAhuOXSe23amEDMQksnmgGa3OUo8M7cdu+HDmTuE/
         A94Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788782644; x=1789387444;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DVWLuac2DwY39I6nVk6WwXTIYRO7n4Cw7TINDm6t1OA=;
        b=k74KS/LwwcCJsqTBHoyu0H4WTxBcwh6CYPTpXHpAqGuDKV2T/b0GV64o7JmeVj2a1Z
         cNa7EtP5VyQYSFYxTNmmoGFB35nJ4YLBOaSTWRxG1wlipHb8DglhZB2Ebgh83ldXN5OR
         IA3mB/gmElLOVRRK9OvGrXFDrRRobulx8FjbW/pw+KPHj/SOBo5JYzg9MTtACr0M6/Lf
         8iKJAziZBb8BG7/oSasjPfSH/8zBulzUcuM47iC9cV6TQOgbdUumB6jIIQ2QaGxda1Wg
         bK5g5HvuiAv+bbrfTOF1PAvnyaD0QLmLM9iHBJ8L8Pgua3cdRXmggtGqfqiiC2AIb44a
         XCmg==
X-Forwarded-Encrypted: i=1; AKwUvByhE6RIB2fIWwocvMdK0Dh5IgntNCGmIxSIeQihvLDm3HHApH80f5WG++/revzf+06Jfz0xp/UCj8apiS0=@vger.kernel.org
X-Gm-Message-State: AFuF++mddg3EYii7uK45oFwdvojpdDYQOXFQ3+RoKA1h6BFun/Wera1L
	c/A5PIJ5VU3iHnDEEBgNgtKRdxYEYYhHGZFTX5EaQy7J1n66J0AtTJ+Sdqvky0nPM8+JeZw1A54
	sqBzkKs3VAgCHVLI7kbwuB6TpBxZdvIltcfXzJA2IrJjqTZwZUeDlE4pfi7TGdOqKAd0=
X-Gm-Gg: AYBFou0t3yieSvr8J9X5hxTPssHKl1zSd6QWJrIkHujcPjM8T6NVHWqX100wy8u7GKY
	poKsERcIQ+Ufh4kClqZLj0hrfWg5OdMMeT4G7dLg0Z9aVNctSQk8G1gBjXKSO9zDD8ULysz9WG0
	OBkq4Kaj2nZoROJe/GmRBNc2HXj/g2bK91NuHZom7hMub1MwbLmv7iVhIcISnhn428NkiZjEKqx
	K7ywolFPJm/+5xjNy4AjXkAkoxYyUn0bjnK2/El1Ya/3mdErUVvhWDWXQc4yRM297h+rPT2hu4b
	maiqnmNIIKfZiLYmnjzAqaXL8Aq+NVJPxPAUWhZp+SsgRvKeobCkvY23e4YngDE4gtSi2VMs9rT
	TxeVIZnZgfnpikZbU96w+jrLhRdCV4hha6A==
X-Received: by 2002:a05:6a21:15cf:b0:3cc:ec12:a788 with SMTP id adf61e73a8af0-3da39b57e15mr36356192637.4.1788782643530;
        Mon, 07 Sep 2026 05:04:03 -0700 (PDT)
X-Received: by 2002:a05:6a21:15cf:b0:3cc:ec12:a788 with SMTP id adf61e73a8af0-3da39b57e15mr36356089637.4.1788782642990;
        Mon, 07 Sep 2026 05:04:02 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-333959d5f69sm26345960eec.0.2026.09.07.05.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 05:04:02 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Mon, 07 Sep 2026 17:33:36 +0530
Subject: [PATCH v6 1/2] dt-bindings: crypto: Adjust Shikra compatible
 hierarchy
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-b4-shikra_crypto_changse-v6-1-0676f61894b3@oss.qualcomm.com>
References: <20260907-b4-shikra_crypto_changse-v6-0-0676f61894b3@oss.qualcomm.com>
In-Reply-To: <20260907-b4-shikra_crypto_changse-v6-0-0676f61894b3@oss.qualcomm.com>
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Proofpoint-ORIG-GUID: dXEtG90iXMEFhT0DOj-reaRV1xdMmKhq
X-Authority-Analysis: v=2.4 cv=U+aiy+ru c=1 sm=1 tr=0 ts=6a9ea834 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=DcSQVDPtFCqqlbpqkFgA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: dXEtG90iXMEFhT0DOj-reaRV1xdMmKhq
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDEzMyBTYWx0ZWRfX3hIHAPQZnUw6
 Jf2mHpxBZ4giD/aQmucoEkS3enJsUiaymJqZ00NVy3fBB99HVToctkw9WUyzCTu7bl4rIrhSky6
 Q4gZ483PYRLailhmLo363HGom3X0eNY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDEzMyBTYWx0ZWRfX1jxoa+RIYOOb
 y8ikISkIiuJM5tvv+i+tZw6EUGhf2ncWhXONaB8pBcuQNiWlfYjvlQYfcv4ssRGvyU8cadmsr7Y
 jTVLCCMFIyih9IO/D3b8RgHeGQhyl9s/k8z95hxVQ4kMLHUSZsyug9JNbudzx3SRJtvXl2Lgbyv
 3qNnbSClE7OVRErYP27bavZ1pij135saTjt2YE6YdD+eUe4rAA8jBwAebqnBkYR5l1dFUF8KQr8
 /CCsUVrvoK9E1NB5y2UTcmekeseA1APooekGA/xK4IwXKH8r31S2i7iFZs151DArzllxqLNByqJ
 ReQBdmBile+iAF42jSf13RRRQD4b39nq0rEA06X7cezlF98DXwRU3j8LOrN0vlgonFz2pEggdsr
 0RLJ3ZRgw/jCTe9oJYXUJP4CsCZOnvYRlnqhWvi04BgB+br2ZFp3w8O5Cgem08AAi+GBXAQFQOW
 hscsWR40om/eELdPcBQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609070133

Shikra reuses the same QCE integration as Agatti and should follow the
corresponding binding requirements too.

Move the Shikra compatible to the appropriate binding hierarchy
(matching qcom,qcm2290-qce) to reflect the underlying hardware
description.

Fixes: 45834ff95a6f ("dt-bindings: crypto: qcom-qce: Document the Shikra crypto engine")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 5a653757ee75..fcf725bfa36b 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -39,6 +39,7 @@ properties:
               - qcom,msm8996-qce
               - qcom,qcm2290-qce
               - qcom,sdm845-qce
+              - qcom,shikra-qce
               - qcom,sm6115-qce
           - const: qcom,ipq4019-qce
           - const: qcom,qce
@@ -54,7 +55,6 @@ properties:
               - qcom,qcs8300-qce
               - qcom,sa8775p-qce
               - qcom,sc7280-qce
-              - qcom,shikra-qce
               - qcom,sm6350-qce
               - qcom,sm8250-qce
               - qcom,sm8350-qce
@@ -133,6 +133,7 @@ allOf:
           contains:
             enum:
               - qcom,qcm2290-qce
+              - qcom,shikra-qce
               - qcom,sm6115-qce
     then:
       properties:

-- 
2.34.1

