Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795203317;
	b=uOAeR2Mi8PnpK5s4mRpttjvET4rhJxzzaow9ILTbRTordLi1MBfZN8+zJjwnd07r44x1
	 J8aeaPPRLB4ZZt1Fx/S8M8Gedz8zqNRkSp6YPPdQgGl90kySskQntzB18BP1WbCKujMn9
	 piNM7m3Lq5uooHfVpgcpgoGbZeKnbLhkrxbjj7sCCCWs3VHpz4oUER8AvXKrnx5p/R0h2
	 cUHjVdUMnaeBnZAcHKlP9LHYFYgQ9/mgmmLWquQilhSrZa/ZNzrKkzGHfmRhbSRuyLS4l
	 brWlanIxhv5HKgkYngVI8U3QSUYC0xR4JOxyP/BfnMaYN6nT7QYyqBfvokYn7g9M5/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795203317;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=dL5qrymGK7O2V/TlXMiVhWk57sq0Wg6NLH/zPnd4phY=;
	b=PpUQcYLaJzZD2X7hV0Sc59ghtFt0vxTolKXSnY39Ww3soWt+f2UAzkibwtG9HwMWhaP9
	 RG+0hibWBZ8pTlImHVuTguDIABC2FZKJ80232PlmJLW1l490vHMXAS7IZgV1F+ZiGiu/J
	 juVdxEUpGTeG+UXycCBodEpoCxw+HRWBWxZlBdXhUpIv/xnomjTmuWuSE2QL48C/k/H+U
	 VOEgeaTSLZh6BzXFfY7IsTUTD8Px9rSGXZ0hRZtd5BAd40Bx/Wt70vKDzufx/JRMsZTl1
	 iG/yafe8i1DDW3jCtyfE70MczMg+Srjv4wV1K3dYzFeyiEveM6Mdp/Uz/OykukJONTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LseF7q10;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=f213JjZ8;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9BC60A2611
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 19:35:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED9BC60A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LseF7q10;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=f213JjZ8
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKEfSWd048804
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 19:35:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	dL5qrymGK7O2V/TlXMiVhWk57sq0Wg6NLH/zPnd4phY=; b=LseF7q10Yx0HSNMi
	Hv0eYmithUeK60i1eJxe2XOogdFyikPL7D+DwgwA6DsjXOrU77m1Sq2GMWfFHuQp
	ByoWaJiHBNquvMU3eU2AWBxkI0mUulbgYYXPIKgjXNkJnmFsqvczd1JxY2qDdj8o
	ZNe+DY0wf5UXI+qZI5ZivjQBdObZ9f+X3Loai6Pg/vfCK3NCGTbxwiFG3sZDhP1X
	aRHJPiBnvASughAXzUWfWojG4KIhbKf7i/il+gMeU2RNAnsh4jWfBIkRJ4IurQhg
	JS1QltTyvArU202mKhqgeV/PyIv1Sl3Tf/EWjRxwCxLSi0ubazge3bflzPwMiqTR
	NQvReA==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j2mm4j633-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 19:35:11 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-9213c7a506fso15102736d6.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795203311; x=1795808111; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dL5qrymGK7O2V/TlXMiVhWk57sq0Wg6NLH/zPnd4phY=;
        b=f213JjZ8Ng57i6U8tU8MtyyO0Ei8RWBSDL7hEgAQrQ6r4X835zQHKMdSNTjLe3CryV
         RLz8/JvrMQGfP5DDmHPe72N7TjxEVXd1OBR9Nw988+P2wo+9vb9NYA7PL37o8adnzRqf
         iGnwR179Mp5fQaQjmUaGfLD/I2DGpo05XIB4OB9Dm+0uph7yyamKaC3o+oA2/yyIBAKy
         pnGQqsHEtBDlJajx4VMyHCtyIsCPXzDL+uXoBO9JSBBaol5MNGNe09AELq9J/jtRdvIc
         qSav4AO0MSeAD45F00HIds643rFqsu95pnFkRWyDTI+u2jQmxA8QEXRAtDpvvuTyb1cn
         ycBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795203311; x=1795808111;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dL5qrymGK7O2V/TlXMiVhWk57sq0Wg6NLH/zPnd4phY=;
        b=RSnTDJun9IN0V/5GJHdxDekQd+1OWN/Ob8JjxmJOTgoc5QilVxKy+PiMFEqWv+Qlvh
         ZsiPs6NVWd9EIBe2Inpb9No7BAWHI01m1eOInXfbXOuJAM1xknyaB3QIENI4VfvAMTdE
         w7X/mnxl8jVahcWxgkw4g8R0F9YJ426P84iLDCSxKkskQ6X37cc7ACcGB4U9rlsNPXvk
         +ePn4Je0vNBBJU4O2mMO5x40e/hjTe94kd3NyqnMSvP1CBejjg2W+TqY/d5q7hyTk4hc
         FF4SfzzZZf0z47ae0u9rNmdNyARfXSnZHiGlcKecQF4wWqKxZLP8lSnHBiO2Bj3qh19f
         OTQQ==
X-Gm-Message-State: APuU4Z9pzMmy4/XgiLj0s6fwbIcgMMvAK0tw0bqgFghPUFintLTUzYaL
	T7UFGFxUKmJWBFfzDyxO19ardtHdslHgbze8/CxvIN1t7/6QRxmYf3ZqDbt5HSFpKifxdJcnqri
	r7bf02dhJp9PGY6luHNG9VT3qQgViQgf3FL5C5Sp4B+MZyTDzLV62soneuOzXJiYFTmc=
X-Gm-Gg: AYBFou3/D9ocZ5GLKoJmjX3czGGc3NlrUG4pvpC+GOqpXIJaJ7hpEKD2CdTmqigON5b
	lCxKkKuKgM82TWlOL9ekWbyDx2PPWW7mTnEdnj3a9uQlegJ+pU0CphJXtEtIqyGSM4hwmeM2wSx
	1N7RfMKJ1sbAJGM0gEU5HByD1oqYy5wu8VQcYyIs5QptZD2N1pyO25JdVuBRtTXl1RUN/s1nKlS
	S+SZRtL1vj/B1zghInhyOBJbnORz4K072rStVm6DOkamvMKQ0rguuWhzTnm7hIcBVMApCkm7LdY
	zx+sR8+K6ItJtSmUhsOCmM2+tkAfANZALU/IPPoWJnvFg8hbs/B2pBo+XhHBI4tHzbKIz9C6jGk
	Y0IRD8lFc8jm2Qq1z14Qi/JtCPdC9AHQZItUa8F1QfF8U4G2kWKyYYYCtIjTbaly1BAHSlbraC/
	R8
X-Received: by 2002:a05:620a:2a12:b0:93f:1d5:9973 with SMTP id af79cd13be357-949bab5a6a2mr648561285a.73.1795203311237;
        Fri, 20 Nov 2026 11:35:11 -0800 (PST)
X-Received: by 2002:a05:620a:2a12:b0:93f:1d5:9973 with SMTP id af79cd13be357-949bab5a6a2mr648555585a.73.1795203310736;
        Fri, 20 Nov 2026 11:35:10 -0800 (PST)
Received: from brgl-qcom.local ([62.245.128.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf685asm6806343f8f.20.2026.11.20.11.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 11:35:09 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 20 Nov 2026 20:34:56 +0100
Subject: [PATCH v12 3/4] arm64: defconfig: update the Qualcomm Crypto
 Engine entry
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
Message-Id: <20261120-qce-fix-self-tests-v12-3-b5a2a44bc5ae@oss.qualcomm.com>
References: <20261120-qce-fix-self-tests-v12-0-b5a2a44bc5ae@oss.qualcomm.com>
In-Reply-To: <20261120-qce-fix-self-tests-v12-0-b5a2a44bc5ae@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1275;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=3i3hdwFui/8ynH47JNYu7VqIYczjdvme1AY4IJcpfg0=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBrAKDlAWUz7MHSnecvkIFD8fzhr78XWyGqTiqFp
 ba6dRuHuFyJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCawCg5QAKCRAFnS7L/zaE
 w0QGD/47iqPh0erUxpbyfM/v21ZsiKW4cVcUfs2IqyRlfHRc5SzLO0mtLaz5LB7MedcpOhE9QEY
 iflgwSDDEmM+mz7j7i8fLtuCvCgTI11KDajRLFCoc+NW3UsnLRJZnl0CabUcb79OXJmNgWxy8lG
 tqRyaC6eyWhVlmVFwHAT+1e1TVQyOJ07mGfcp3m6PCZDUrFmJQawmfJmSMyPX4BdNbli/3Qzav4
 r1tDg2hK1n4CmgArmOTwEdCb/Sxbo0xq40yX0HjnVhNmm0DKll6MKBTh0vUAFrWc7bzlfXG3K5f
 srXIiqYIEmjXsOEATKEjqdP2CSd150YKi1mq3/eHL3zmvyGjgWk835y1DmqtvjTH826EDdkG+3y
 6CeUHNdC78aMVYldot1iia8S75OikmhaAbzpOp6bLYaCaIwavutP7rCbHbc4H3quvZJOzCjTmaI
 lhXwZFMV8zRBNRHVNR8Dha1NCnJwc3Uyvs60+M7aLRV6zGhl3v0EFZRvkRipCFFRfXdX/q7TQ7G
 fLnpeW9nBP+a89DJz1CDFjhLDNLBqf/eu+ZWUiFMj8sIsa6cyCgOJSwS+bwETqDttqwbB3eTxdw
 zQe2biR8a+XHr4BrLfHLPZxeMBfmmIxJnZmkcaA68nG+y4GqFJY/lHzv0tMs2BM0hPlQke5goUh
 Ttbiw4m8FjdMLlA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: q3eQjTwAZW-7_zGawp4G-lzE0es-vlhT
X-Authority-Analysis: v=2.4 cv=RZYFmFtv c=1 sm=1 tr=0 ts=6b00a0ef cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=y0NJeVxnVzJs6a3GlOz7RQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=5AW58fNYxLuDjIPvRSgA:9 a=QEXdDO2ut3YA:10
 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA3NyBTYWx0ZWRfX9UCtmQQATEK/
 +4v5Q6XcOdLN2Kttlw5nwKqigMRbVXZOwbR7jAJRbzxwzXBZSw1wQ1tdJ7BLdMVlBtvfzj7sVK5
 Hax7AL+nLmEaFR1DB1TC+QAuCBp834E=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA3NyBTYWx0ZWRfX+v/jimirRBWz
 4iyEnDTrfT6RpOeF5YlDLjn3rFdi4D1QtN6Z3CrdGV7Cj2/t1Xtf3GrHqsCQnsrGaFYfxbSreUM
 J4q44ZcEvIivQO8XZTzeJccGCFwMMVZCcAdL7h92WuncBJnsvFpAkSETQXFDC+3Psdelc8qhoLz
 xhV7IADswldrX+Qo62Rq8xmBl6l88cMKvqBjItrBzNmNUjHPm8cgG6qXxIaKhC2P3ekHrcjtUZz
 tqa2AjlGaZzy+DUooFKh7Nk0YmQsIcX6qpXF00+Kz93nb1D6FdUAtJqITCPsQbJthbEdM/7NfEa
 zhAPf2OZWAxhr+hNy4WVDeUC7HJv+duiECjbXQNytGJe8X3j1BsoWUHyxUpw+E0IAMHHfSd0xvv
 mAectpwHhDuf9ccXol4tanAyjOe/nbmMd2r/Vxc2jI1rxfxPOJwNgb1RgXvmkpT26rkTAXFWD6J
 WnhwYJgfxMOTr+E3RGQ==
X-Proofpoint-GUID: q3eQjTwAZW-7_zGawp4G-lzE0es-vlhT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_05,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200077

Most Qualcomm SoCs contain the QCE hardware offloader. The crypto driver
for this IP is being split into a smaller core stub that doesn't register
the crypto algorithms on its own AND an auxiliary driver than handles
the crypto part. Update the arm64 defconfig to only build the core part
by default and leave the choice of building the crypto part to the user.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 arch/arm64/configs/defconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 9c5b64f34a228883a216cf205181416ac2f95edf..1e0a7b81c738f62367df0ed59c005ea1500714cc 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1553,6 +1553,7 @@ CONFIG_MTK_CMDQ=m
 CONFIG_MTK_DEVAPC=m
 CONFIG_MTK_PMIC_WRAP=y
 CONFIG_MTK_SVS=m
+CONFIG_QCOM_CRYPTO_CORE=m
 CONFIG_QCOM_SPM=m
 CONFIG_ROCKCHIP_IODOMAIN=y
 CONFIG_TI_PRUSS=m
@@ -1801,7 +1802,6 @@ CONFIG_CRYPTO_AES_ARM64_CE_CCM=y
 CONFIG_CRYPTO_DEV_SUN8I_CE=m
 CONFIG_CRYPTO_DEV_FSL_CAAM=m
 CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM=m
-CONFIG_CRYPTO_DEV_QCE=m
 CONFIG_CRYPTO_DEV_TEGRA=m
 CONFIG_CRYPTO_DEV_ZYNQMP_AES=m
 CONFIG_CRYPTO_DEV_ZYNQMP_SHA3=m

-- 
2.47.3

