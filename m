Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794487906;
	b=wkOeMNZHIT8YU0fKMNT9qQ69qRPOZnlNi9dtSfew4VkQWuLlL9JJqxn7cH3AIS+dcQS9
	 IIDQ8W/2M2VgC1k2fAQtuFJVqnGB5ewc6kV5+U46glcx6yreww4KXa8zW4932l1N0xgIx
	 a0wcnVsnGHMd1cqH46UoyF3BeSIBN+7zWCKYRUfAXteYZF+kLxi/O6WvoUJCoS2i8N5BU
	 sPGD/TIxaz+MNzxDiNWyFlmU8isqCgnx66oHln8gwUkuL3FzswoEpe4I+9XcCmPVw5gYr
	 Ys0TdqOlW9uouA5hcqHdP3ci3jjC9UF6VkItL42QdiFpkuo/sCyvKRD2O+eZGwFbU3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794487906;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=4KzwRoG5YP+rqPaS1TInFPrQ2vlnjrd/coRwFuyNkx0=;
	b=lsPAGZfZUNB/JM2Oz9hdb4yqEiA6VX+oMC9vxcVxuP5vBEHSl9k5B6CNuKDNcrZWJjcP
	 NdpNga+4NeuIc6mDPcGpz9atH9lbiXzsZMHFZ0s24EQDQxBEzpplEwwCT0WfwFRxlsGdL
	 cJm2Kvh+aAiFRLMft6iVlYj/IAeKr31JsqzqjSdE/i4CHM2snKryYc3VzTrMHI8zn/+Ua
	 BGDqAniwSydKyMgvR98mIrsJrTc8ptRnBGPutdq/X+mguO3aMMe32WaH2PIuFwarsZIEb
	 NLWe0chX/IxMYO7WRlVbgdDGlCGxR0ZuEeVyizGFVz5Xs5darHetvkI7p3O9aPa8MnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=AimTuc2Y;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WHL1JtWx;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95049606A334
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 12:51:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95049606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=AimTuc2Y;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WHL1JtWx
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC7ofx12819061
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 12:51:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	4KzwRoG5YP+rqPaS1TInFPrQ2vlnjrd/coRwFuyNkx0=; b=AimTuc2Yo9yJik+V
	+PM6lUNbKSS30/q+gCO4oJLZRjVqDRk3xFpQPxLuGGu5XzKf3gDfyyWjn0L3TB7O
	1dzsDAGOhNkftxBUeWAn1mxEtV9EXRx4jEzUBVhtPjnqDZL1uR7H1Pjs5WZUGb4T
	tLVs0jA6laI41zLrqaTCAjIL9xSBV5J1u/QofStmX4fshJUw0rJzBrYratRr6pcK
	tXyJ721YUIe1K+CGhzPxY1zBM3/u8ajzDDUKcUIhYBLLSK4BrkxdTOAsJDuXaGIp
	l2oQLVuMDwmbqdQGO2xNdnrutq/3sv9lT4qb1ME6mQFMtRkZ9LBcfrkivVvzXtOH
	DNOB7A==
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hw9e1924b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 12:51:44 +0000 (GMT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-824cc5f7fcdso5197467a34.3
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 04:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794487904; x=1795092704; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4KzwRoG5YP+rqPaS1TInFPrQ2vlnjrd/coRwFuyNkx0=;
        b=WHL1JtWxsFZoY6QW+h724nFvARRjE/mCmVTP+TlGS41IAcp9Ypq0gjnWASBB8umgB0
         yAya+eq/mc0ZahVrVUcAItpQO77pbxgxir9VT2frV48kTql1XpC+Xb5aYYGILN3iMDGi
         nJwAAkJRWK67IEDobXVJGPG232XVE96QS3BLuE3mmZ0Tjw7PRfwpWzuJcjuZ7l2nPb0i
         VG5JF05pzO7ouzIehPBEoUvUG/uoW6zjiiSjEjWcufsXpra+qOsb6rvn9DYUVbRE6DKz
         raqdNqg8SeM9okhDPf3fHi9UL/E2Duc2ATBvMcu9gtf9Sw4ouExuUG6lt6hSybJs+gTB
         TMbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487904; x=1795092704;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4KzwRoG5YP+rqPaS1TInFPrQ2vlnjrd/coRwFuyNkx0=;
        b=YnxEiL1r0Sie6EMpMlNwMGS31md5CSipPKF/5nIHuXrETAYwZYkcS29XTm5DNyVbu6
         uStIynl0TM9haFik6KXaYSGDey/4FJ7sVxoPtp+rOVPJKurisJdfwAyY3jdLDxYFbAkq
         dCw72Yus+V13jksyd16iY/PcHL/fGZb/tcTSFSLp8Tc9O6y347C+cqIuZm49Err02Ava
         nKuSl0cDEcWAwQSGPDANVYFEzpukUeXIXdtrmGUvaAwwCWNgIi38IBjXRDP+8JqOBUnA
         Sn1kfLyr7BYydi9S4e3Hft3govoh2hs9rkqGokFRUP9IfMkd/kovk4q1qNYsYTw9scVM
         aJMg==
X-Forwarded-Encrypted: i=1; AL+hErFUvogqmiuoGspLIT4i+wKNYisClA5jS/aytht1jxagF8LSkqn6WVubPv1GptSTpVA8irZfhBghKVLu1/g=@vger.kernel.org
X-Gm-Message-State: APuU4Z+KFrLxyyxXgIZEpH5vtPAljptjFWjRlzgCAmTL8BvZp4hE60vU
	9Vz+u5tfA9RgzfRNUGCMUNaQoJ2HrmjmBiz3G0j616dPvqh16ZhGbVmHuHT3Nl9Z1rpiw3sgcci
	aplq86pklq/Jmry4KY/xj/Mi09KfsDcufDSMzMh+JwhjK6mS4+mFo/hdzV+HDuUWFQznlStNYN0
	I=
X-Gm-Gg: AYBFou2rYGT9X5QVjZ/qFofRPQ67JWWscm4XSh44oGAxYBSdQ3Una6+mj1xxf6ItFXS
	eRz1Mu5amCmIkxtgRZr2At/dBF0e5mcL0bffjFAMcmqiBmwQi5NmdkoOxDC7en1y0+tz4mzqimw
	kAW1+M38FqA8JXMH6wLTWjslrgKIREZErw30KKXVCfyXklx5JVIu37UnfYzHUyi8tQPg060PiAW
	67nI6dkJs5HjCdYXGFfpAuIaUf5PquSRjB1u+cB02pJjevUF3VkKDyIEg3IrHmpjsAom6pNVVTq
	jJYsdhpCX5c/RX8f8F2WI9/SpQLC/xrS+UTUWTfR6wcnZ3U6lG1aFP+6iE4Io4vunGgEglOgI9a
	+il/5uUUMl/a1UqFHCfFMn0aLCOW03psiiSjtqfm45JpOe/4OoZapqAmfqb/cWSu5+jIyV3Q98u
	bcysfRrA==
X-Received: by 2002:a05:6830:922:b0:861:f4f6:1f81 with SMTP id 46e09a7af769-861f4f620ccmr593988a34.31.1794487903743;
        Thu, 12 Nov 2026 04:51:43 -0800 (PST)
X-Received: by 2002:a05:6830:922:b0:861:f4f6:1f81 with SMTP id 46e09a7af769-861f4f620ccmr593973a34.31.1794487903345;
        Thu, 12 Nov 2026 04:51:43 -0800 (PST)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-860dcbc7eecsm7608191a34.15.2026.11.12.04.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:51:42 -0800 (PST)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Thu, 12 Nov 2026 18:21:07 +0530
Subject: [PATCH v2 1/2] dt-bindings: crypto: Correct Shikra QCE compatible
 hierarchy
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
Message-Id: <20261112-shikra_qce_fix-v2-1-2ce112cc2ccf@oss.qualcomm.com>
References: <20261112-shikra_qce_fix-v2-0-2ce112cc2ccf@oss.qualcomm.com>
In-Reply-To: <20261112-shikra_qce_fix-v2-0-2ce112cc2ccf@oss.qualcomm.com>
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA1MSBTYWx0ZWRfX3pUtY09CpyJD
 b1As3/AA+Oqk/fjxgNSt09mauIF8FUKAlMurZM8mxKp3z8aef8L8xDy3XqYUsvhubJd9qy9QmTm
 Kg2YUy43lKRs+9NdRpwrN8SfxJrYJEM1nr5rIcc/KZYDCik9go0Ua78+RwF153mbQzc2I3sIFdz
 zRA170iArehiF8Mkfu3yaOv/7hXyZOxmqWYSHUyldlshaOizc5aebUohlG0RrSZDFvFExmKbO+n
 oByclMIaqAGJMtHnT23kn3zJa+j+sEAz7HwGPFXs/lhetu3+O3TV8I25gmtmst3YjdzyxB8a+Kv
 1IFqu/vc3wsoQV3H/ZMlJYYzkzijQhWddfW1UfpQp363HYB+dc8Z++m8lBPL6VZlKouBAe4oXtM
 +97rHSGby6kun1P8srJkEplNBDamrlDozrz3I6Qcr+7kheXheVY9Ffm3IRetIIkM3JGkUUWITTr
 eiPzg176cJkyvNB7inQ==
X-Proofpoint-GUID: jqpmj5Cnj6-8EOuK587XrnG3uuyi2iP_
X-Proofpoint-ORIG-GUID: jqpmj5Cnj6-8EOuK587XrnG3uuyi2iP_
X-Authority-Analysis: v=2.4 cv=F6fC5ahN c=1 sm=1 tr=0 ts=6af5b660 cx=c_pps
 a=OI0sxtj7PyCX9F1bxD/puw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=BEl7XTdPtaVR2fHMDO0A:9 a=QEXdDO2ut3YA:10
 a=Z1Yy7GAxqfX1iEi80vsk:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA1MSBTYWx0ZWRfX1+tlwVhS8v+O
 5kiO4CmXflXVXHnaxJu4R0vWF/sn+4NGUh/Lq8jX27Q4UwzwawO2C+ycXHZrAXr83jsyy9L/FvA
 DFXgZIROnQf5X3XQ0glLWmfJqcDjSgs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 clxscore=1015
 bulkscore=0 phishscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120051

Shikra QCE requires an explicit core clock, while the existing
"qcom,sm8150-qce" fallback allows the clock property to be omitted.

Shikra follows the same QCE clock requirements as QRB2210(agatti).
Update the Shikra fallback to "qcom,ipq4019-qce", which requires the
core clock to be specified.

Fixes: 45834ff95a6f ("dt-bindings: crypto: qcom-qce: Document the Shikra crypto engine")
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
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

