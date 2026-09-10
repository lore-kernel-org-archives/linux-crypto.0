Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C699B4908CA
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045317; cv=none; b=tbBM04w4xm8PAhcRMinZ9oToQ7tDdp1gWLLRdzJecwd2pyoiDhFDiRyWRCLLnLlNrPRrThsdvYQkKyXE3+pWVhjDDeSe5K80rj/ozraHgil284LJf1c9RnAEeq7LQM2As/6cUcvyF/JzqzIOI/j7Cw3sw5d+D7PTyob4QyfGCSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045317; c=relaxed/simple;
	bh=XytiMa5fLcLcaPGL3M1duTpYUfhHG3JelygOKP6fjNU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PA/VjF3hzINLYelFPF/kT+JIpKqwh/iC4H8v02oEDdbRAzjZgv5tOZV6lFsL+sbXZsoNjk4VEiku/n8YzRNEcfZAcfAj5dsrJcF2CYqxwuFH4N6/Nnc9CGqpjlcH+PH5aCWndfOI08YBoG029mo8vEFPjO7g/bNDtYLQdyGWAsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MRR5mWrk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=f/pfK1mR; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MRR5mWrk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="f/pfK1mR"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AC7dTn383434
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9y+j0WrhcaTeosIVoQO4AEPtqrqZ1qq4THTfq6/CiPI=; b=MRR5mWrkw7sp8mrb
	+st2fTWlOsLe8lbB9suYJkmM+1KixoDyRS9GRUgWRKcFJmLZbi7zIxyxM7/ob7Y7
	qzhr/dzvcDBwNWNNusGWVTv5uC/NV29LDNxqDnf0O84tTobDYCFIxFyffL7VM/cJ
	QvF5t6qtA/BVh5hSQS2tmRhbkUrfgTVyTBknzDS1O6UPggTc0BbBDzHWRJC+87oQ
	aZTEYOTCRXFRk6cjObUtEFYKQv1D921HO1acxRGOlc/+CZbIda2yMsjqut4sbDmi
	aqjlj26YIQWnaERXcJ3r54sJGbqiextkb2g1ndRqTvMmAvmWheKhrT3xi9MhkjD4
	D41pEA==
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com [209.85.217.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkcyduvc0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:55 +0000 (GMT)
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-790e3ca4c85so217725137.2
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 06:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789045314; x=1789650114; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9y+j0WrhcaTeosIVoQO4AEPtqrqZ1qq4THTfq6/CiPI=;
        b=f/pfK1mRF07LwaoKiVCQ3H/1CdsIBtG3s0cc5BVG51EY9w6yRIAOOoMiE//KXsRk2a
         jBmSDZ1gE8J3HOj2y/QKfkyer0AMDRuaDl4ACgonFEgxqCK2TNxG7+NNvfguATwSX60z
         0xpBHHnH0pg7UlWWDsA/jIUd8YvEIrlC6c309MZy/BPfH1YJ6o+erBUohReZZn4vDKLw
         NP4PVvynn68JlL/WN0hUyHhe4WIMO22Yrc48Cpfh9BrRD1ueEkiBsOKCMEm1wjGtacvV
         6tHWap6844pG+pxvh57grPbRJPFVlmobQlhYVDBOk3V6E9K9wsRx/l2F2KmCR109+4IP
         QfZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789045314; x=1789650114;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9y+j0WrhcaTeosIVoQO4AEPtqrqZ1qq4THTfq6/CiPI=;
        b=H1nJ1F4dQBO8kclHh60O3fTYLYbd9n7GssMFpZ6ANpur7HTZkBSydqobrS7Jm5gfjG
         e2HlHoJE0HhOFzrOqhc/5Hib1LH7qOfmy0PAGbe8lNdwf52XyJUBocKcECW11e6ps+U6
         ksk4LR75eEF4hCZDvN57wJ/j4jc6EFdouIPQEtPkC4XKzhmQTW8v3mObH98NQMGG7vjT
         oIqvH5PFVPtCM/r02UducPfETEYnTQVzJV1BeVpC2GRA3jG4pAdbH2vin0cT/aRP9gU8
         M5RIfKxGIXf4eBLGKvwleGq4aMVuUOIKW6202RhLjiL4sS4TNUmi8zVQYAcg/3njB+Ml
         orIw==
X-Gm-Message-State: AFuF++nSIlRaCcb9VeY46HTLHBMTiU1MZQmfKGf/XF98BB62C6M7yKzm
	4C7jcLstFNKqsrz6LaUn9cA4ONlyNIcdLb667A4xzUoLDEQS9df56xedu6U87frAuifuke+dxON
	E+U74EbJTulA/1u0GdlNLOkGuzHOW5ZpzJ3A6IqSOCCDGttK8bhXb5+iFfukWVHEMx1s=
X-Gm-Gg: AYBFou2xbY5ret5/TuTtwKhf17EdDi5iYeWho4WA2EuH/cNWIHppsraRQrf5SHN2eff
	ulgh19yjOXinejkLcUVuffLTQBte2FfweoppSy5x8yixMPUeOREN8C4Y/v78fpfvLCm1AUEZJ7m
	ySeA7K2YjqI4ODdnS3A6XGlJnKwy686dmSqUpfGstliI9tf3z907K2DXAn9V8DEQvcCSJbvzs7y
	df8oAEAOyjsqjoJVAyHc2905bIuMPGXQJO9ZZTWvLd7aZ1b1keGu0QEFnMmNrNGkHoOf6+NVxsp
	/96zlbh1W96n3f9/3KgAYb8Lo+HbJXfgkcsYQGyf1xJVdK6Khd/snEhlYbYw+KSWXBOg8UCMS14
	KP2wbEsbbMfxYtf1iIhQSFxct6Flc
X-Received: by 2002:a05:6102:3f87:b0:780:7e65:f0ab with SMTP id ada2fe7eead31-78f7380daa6mr4474396137.1.1789045308951;
        Thu, 10 Sep 2026 06:01:48 -0700 (PDT)
X-Received: by 2002:a05:6102:3f87:b0:780:7e65:f0ab with SMTP id ada2fe7eead31-78f7380daa6mr4474097137.1.1789045305373;
        Thu, 10 Sep 2026 06:01:45 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c9b1:abfb:f300:5e98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c26204ecdbcsm831849866b.25.2026.09.10.06.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:01:44 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 15:00:53 +0200
Subject: [PATCH v7 12/12] arm64: defconfig: enable the Qualcomm Crypto
 Engine core driver
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-qce-fix-self-tests-v7-12-cdbd2718af14@oss.qualcomm.com>
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
In-Reply-To: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=819;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=XytiMa5fLcLcaPGL3M1duTpYUfhHG3JelygOKP6fjNU=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqoqoUrCFfw/iAqEZLzK2v3C4rvF8NfOJ9iaf7c
 3KA62RFrlWJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaqKqFAAKCRAFnS7L/zaE
 wz0nEACPCIp3sLsj4aRZlzCbLYit9IwxonmbBkqcEq760f8h60L9eE9t0yHHjUfOil4qhUE8p15
 Bw5i1QId33cfrfJZbIbp9zS3xgC7x6nxUuYyjsFbWeRncWyDLrQZ//NLPYwhi73zfj/RySl1Dlk
 cLMFeRghi+VmOSQNX/goJ0vuvxK8XXoITqDH0rJ84eiuUT6uBvnBqxd7/3B+Q9+qtX+0lCYaDjA
 GlkvgwPl3tC7MqM73SPNI2vMgfg1BXRi1WwDQxBdxx8V1MiFTri6SwOXty2dmgqFCeiohT3jAul
 +bzh1leY9oWFv3zBvW3Q6RJkQY5m+s442XUYWpfI+skPkZA0N/J6d/VdjvBjqSCVAf03XvjnHWo
 gqQSBPzqUVUfv2r25ZSC/XMjgbkZbUSAqbQj/3tpPZBQPUb7OxLGnwf0qlaOpjNuFxM3L8hhz7A
 utibAbZQd0vQcrdwlsNAVNO+xGjm/01UJCuEP0Nipk1/VOyQjaBpKvy6eX19lAq14mO6r+Ryona
 JG1IkXWLcarVeFY5unAZr2YeRU1SZLwXoh1bUiOU8tjWw/+J7UCyr6QH1rs08osvlowFfkb3Ym4
 bsAEDli70AhlR4FUw77XGUDrWrRGxJkW9wMabWVOCAPv0DA0s0SFLNoTSiA5nqeaK4ChyBzl12a
 nd/sknNMqkdANkA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=IfsSymqa c=1 sm=1 tr=0 ts=6aa2aa43 cx=c_pps
 a=P2rfLEam3zuxRRdjJWA2cw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=talSHFZyAPOHLlyXONgA:9 a=QEXdDO2ut3YA:10 a=ODZdjJIeia2B_SHc_B0f:22
X-Proofpoint-GUID: B2AXhgfiEvOV4JQDITzzONpI9wLgwtiT
X-Proofpoint-ORIG-GUID: B2AXhgfiEvOV4JQDITzzONpI9wLgwtiT
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX2YbK5Qr5/JMt
 lz6dkP6l5Bto77ROfVrxU/Xy8kklWOcozpWm5RGkepCIV2GQjBy/mbVgoN5QMbP6lyyinwrn9zc
 WR0lAsI49zTsadrGk9ARUivfUtwMGDw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX8xreBUggcKFO
 RY3W17QiRxogICFltCSw+yhbdiW6JIUET4A8aZj/jRlw3oy/j+uM4WhcJYMWmFr07ypoOzDL89q
 BDJpdFBY+FyGGhrLF/hOzXLKMH9T8EgIL8/AWIQD6WkzfVXiKs6RVeHu5TGoZlPzqmsQoQyjMzj
 ew7i88KI+/+Du/0Am+rpRx2yKyJkA3gpJVedm03OrdSgpvjdpPWsF81C6tk3Y69dIaH+Kb1+dGl
 1fRqpSKsPhsijWRluH6gS/TXLmCd0L/124+xnoskY+SnKrg6ODbCZCCGyozCA7sV2CajzVn8l2K
 LpFusa2SnQsLdke2Tp2nxVB3onVUXHqwfclnWkzwdzAiLMmdWwTGUTGotpAf7f8fgM9fIzT5ZK0
 dPDWfeZOZBPK1XSnx+BpfUD9zlhTjYGwHgZNZEPcQEmJXktxQzqq/AlqmYEremwvQJUI+3dV0O+
 c+xe8drVkaPZY40ge4g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_04,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 spamscore=0 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100156

The QCE core driver should be enabled by default as it binds to the qce
device node and scales down the interconnects if no child auxiliary
driver is using the IP. Add it to the arm64 defconfig.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index f0947c8176a16b2f0c80b17ce8820e4820c77b3b..ba9450d3bf024475a92d13ecb8e21d3faf4f63fb 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1666,6 +1666,7 @@ CONFIG_QCOM_SMD_RPM=y
 CONFIG_QCOM_SMP2P=y
 CONFIG_QCOM_SMSM=y
 CONFIG_QCOM_SOCINFO=m
+CONFIG_QCOM_CRYPTO_CORE=m
 CONFIG_QCOM_SPM=m
 CONFIG_QCOM_STATS=m
 CONFIG_QCOM_WCNSS_CTRL=m

-- 
2.47.3

