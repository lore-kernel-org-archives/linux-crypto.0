Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7DF3C3F58
	for <linux-crypto@vger.kernel.org>; Thu,  8 Oct 2026 08:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449317; cv=none; b=dLstRnnHUv1OslL0xZkY2Oui/GMr9ogxkPsObrJYAUVpud0qsZznx1M5Jt7DLNcTz97QmQvBIsK4F5GL4D8zkHfv2fvrGeX5ngqc7j5a7KvVzoBRZ32vOA/oYnDm/Q2GQDi5NwOWDtVoLwhr8BkrMVv2rELQrmFC5QmIxcO1mrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449317; c=relaxed/simple;
	bh=M38zr4UDDSTutNGbAEBqRcN/i549+qASNFRF6ZXlXao=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=GKlU8lHLNPDSA51n8jHmzwYdfcuT/YtNYx4Wn2o/kkgmJUhgCv7Q1ZZxliOR/AiBvmbz0wDZB7rRIHv88bs+rus2D2bmcKaLMaiwt3vw+v5GY4rYwntE9ZlPVdQZQp88ppFViPeDYvdNrfI/CzpObjvGN+ZYmXdYPK5GMhrPKnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=alXGJfJJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JHX5kbX6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="alXGJfJJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JHX5kbX6"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6987KBlA2560127
	for <linux-crypto@vger.kernel.org>; Thu, 8 Oct 2026 08:48:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=lTF1ykEwo5DXZWlyE50I/v
	qpScUvMcBObYB/UQq3D9Y=; b=alXGJfJJsfyOMO/kf6/xMm4Yr5Q4gP5iJIqCgZ
	6MAmJSknJQdX/ur0aYRLyAVegkWSVranv2SIvv+faX4DPQjsIOrcZtqgTifd5sYv
	js6o7IKgc+dfDbBc6N7lDLhkXUlZccugLGm3C15pe6bL0SIcGoQXmOJUSLQbWZwA
	wdpajQJKjUnXMhwYx2czUsaus1e2JVKCRa+0fgJLpxtWCp3FZhbBB9kXyFiVJtTg
	2KviL7vT+9AfWad3J8nWyqOiIyLN6vwSzRiiu7wEhoVbo90hIetximT9QcPobbdG
	0M+Ozfh5jnHaQTlQsX3JyM4exrH9N2MqNPk58fiz4bWTjaRA==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5xe81y0a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 08 Oct 2026 08:48:34 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-34ef5fd7934so13582118eec.0
        for <linux-crypto@vger.kernel.org>; Thu, 08 Oct 2026 01:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791449313; x=1792054113; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lTF1ykEwo5DXZWlyE50I/vqpScUvMcBObYB/UQq3D9Y=;
        b=JHX5kbX6FvooFNeR/RLesxcL9IKHkjULuuLuv1ULaO1SN2HweW6c26Q5qEKatoy27p
         90oSrqx/Iqzn/aHJeMHaY8J2Qfa3qi987rjKaVNeQcObfA2IKD0ZhP913aies7c4dHPh
         dtn2WXwlOETIwDMkS5cvXO5OV+7UcJriwJb0v1mIK8oxvrq83YRNqtr1zgN/qvj9TofW
         95aKqBXIFrys3sLUI6oEdJVf3GL5TVr5AnkiqTqmS/YVHhIgc2S+KIvX6xmCZdC2XUlD
         RCGqK+XZ9ttX03DHCutJnDwFFb+Go3dreEcuIYvCIR1l5v+Y2wuKS2iQx1lh6MOy6eb8
         adMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791449313; x=1792054113;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=lTF1ykEwo5DXZWlyE50I/vqpScUvMcBObYB/UQq3D9Y=;
        b=M1Kn7RtWLxGtwO/SGyd4mOG2FpuVHmOyIsiRRiIzHdP6hIlRiD2+8cp5m/9JPk9/B5
         +p4uY2VITAtlzEnzq02WrZsLG9/wEve25LluI5yrNqGQmYu2LMshSxXKu7dEi67HdbfN
         BXDDHSi5CJWDQKxKLDOUbliu6L5VbtQb2rxr1/avfw8mu2AtbBgsfcZgf/NvA8268eQr
         7r1IfQTuBboIA0CMpVna+OKYAQN8Wb4B474DFyGhgWH2N28WoYyNMXgByMO+ed1If9uJ
         mtpEtzyZ2yx6tglmcOQhCDqA5VqVl/+oo8VWPff/SHQCMYCzR0PmB/ozI+0+OL14lIz7
         ee4g==
X-Forwarded-Encrypted: i=1; AKwUvByB/NHzFLC09zt7BlYPp2rUi7hqehr7ECvLoHwl66twHnJezINdwo3mHva0BmVQN0qR2sCZtx38qY0viZ4=@vger.kernel.org
X-Gm-Message-State: AFq9FYIVz3eZv01flPUBbT+gUyx6WKtd2UCDc8gywSaEKO1rrKh3PECQ
	79s1MYFkwKfASb0PsAu1QWAGLHtSNPuEAXXeu4aL7LUxkgjUIvRUOA5I1dK/ImnyJDYxKvpy4kM
	uc03+T2CegZYiZeacV/FvC74ZNVDef+TnF4zciOsMJpYAevwK5V1+SWN4PN/HE6wsXeA=
X-Gm-Gg: AYBFou3B/i9lXNkvEFfe4paOEcCPMeiRHUxUszhMW7fkKLCsl82EqsY3QYlaBPDTcS9
	vT1KszZthwrYBB3Nb2KvxhfRxdFp78z+qzSgOazhWxp6Amg8GuHDHEnJ2flyAFP5hlqAbrRxCh3
	HvcB0aajkKsvvucXWm+jWvulBjF0XnVdU7RDoeIjkM9BX7+I7AhdLWKwRiXF7jjF025oosVDx5X
	mWyiy+s21fvqlJOz5/dG+Uy4ogoGBZ63m+XEQkM+Le4K6Rngo7tpcC4+D8kmurLk8VC1E6qvPv1
	oLu68G78TMheH5zNdDtpLrqqiLT9o5Npqo65s2n7RPzxBsnjI1D6g3unVNxwd+R5C3gEMPFFUz5
	39lUMVOCdlfxwIL5+amrPE0lePwPwBtSsLX9ZaiEVm+Zpnpr8fR9OKHlYKlHy2gtu67U9YtlbOg
	APZTD1GypBNrYacpf4ZRI/qVUCA8rvNw==
X-Received: by 2002:a05:7301:670c:b0:351:5b99:5f36 with SMTP id 5a478bee46e88-3515de80f23mr7606201eec.9.1791449313238;
        Thu, 08 Oct 2026 01:48:33 -0700 (PDT)
X-Received: by 2002:a05:7301:670c:b0:351:5b99:5f36 with SMTP id 5a478bee46e88-3515de80f23mr7606146eec.9.1791449312571;
        Thu, 08 Oct 2026 01:48:32 -0700 (PDT)
Received: from hu-varada-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3515aff5dd6sm15302755eec.26.2026.10.08.01.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 01:48:32 -0700 (PDT)
From: Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
Date: Thu, 08 Oct 2026 14:18:24 +0530
Subject: [PATCH] dt-bindings: crypto: qcom,prng: Document ipq5210
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-rng-v1-1-785580a8b48f@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIANdYx2oC/zXMSwqEMBBF0a2EGndBEvxvpXHgp9QaGLsrUQRx7
 wbF4X08zgGehMlDpQ4Q2tjz4mKYj4JuatxIyH1ssNpmRuscxY1oijJpbZqkmS0gPn9CA++38q2
 fFvqvEQvPCG3jCbtlnjlUytEe8AWhPs8LZjHjD4YAAAA=
X-Change-ID: 20261007-rng-1894b2545628
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDAzNCBTYWx0ZWRfX4W7TLZzgs/C4
 sBL7r9OwniMbjCVAeZ/4mwLjjbSbH7V6iUL4nxoNF6AXsLeDT+zKwtKr7kO0S2Xaou+/G5+euhe
 4V63xEM3ZfbPgoNTgBXg2q6WqcNxbxFlkwypabNydTrYMf8OzTentEL4a8DHDMPckQbZYCaYXUC
 eOveOEvV6vHxZ1qLUeAZNeyZliUKn8tOSWuPg7/slx9CrSNkEedNOzlqigE6CFi9Gf832Y+Pb0y
 xu92vA5DvDOJEnameie0WInF9Lu2eJoD3eeaPXfXMvegDphUbIDtnJN8XViE0df9pY28bEQC3ST
 QbNm6g3VlKFh2ioaYLfuX2camHv50P7kVoBWq06xfuRPjf1KiZ52Vf37FyGZPx17Gs/uw+nXkTR
 22NvKtaRM988t+nyRtRNcaQCO5RZ59F3+PYzakKbftR96zFePzo+lLXuNz+I+h9AqSBY+Ck/qKt
 ZSyXrSi43uM5rAGReLA==
X-Proofpoint-GUID: sRhYcYwSJxutzR-XrGaPgdGWntPQBLCn
X-Proofpoint-ORIG-GUID: sRhYcYwSJxutzR-XrGaPgdGWntPQBLCn
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDAzNCBTYWx0ZWRfX2iXBWRNS2JK6
 KCzjk+RMu9vT8UOKGTxwbWY+NxVJrUNoLH0AeY64iuX5dbB2K1kkZY1AV/FUx6jdYtB7eS3VbPd
 1px5F/UoUWsumrxuT31es1u5T6oVUfw=
X-Authority-Analysis: v=2.4 cv=MPT1C8Zl c=1 sm=1 tr=0 ts=6ac758e2 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=8y1xNrmuCni0Qpi8TC4A:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_03,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1011 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610080034

Document ipq5210 compatible for the True Random Number Generator.

Signed-off-by: Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index de323969fe64..2acb629e816c 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -19,6 +19,7 @@ properties:
           - enum:
               - qcom,glymur-trng
               - qcom,hawi-trng
+              - qcom,ipq5210-trng
               - qcom,ipq5332-trng
               - qcom,ipq5424-trng
               - qcom,ipq9574-trng

---
base-commit: cf4a8255a424f691f95dfa378e88336f33aa8ae4
change-id: 20261007-rng-1894b2545628

Best regards,
-- 
Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>

