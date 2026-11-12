Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794492656;
	b=fyV4zZ80csNCfnPMRmJviApHkYSxGITd2YxYsV8ONsVJ+YW7hsgAgBBfoDNN425a9bcH
	 ckNSADhO+1PtaQZCLaWWi0fmSZ9U/n8xKoBwgBDpwPIpQ6w4wiGF5qjEOiyYA34YbRZAl
	 icq/9yQvW3yt3y8oOHrcKbJpCR8zFLrm36aHvICu+bIjTNQvzQfL/ndW8L3Igl2CO8Ibe
	 N024P7uuFKmniX4m5TiyoP4V0XFfzOzM7yDHm//NdRlu1ASLZkqUNaEOyG2jhUzmPavXS
	 igo/GIeGd/N/bpf/moWJsEnDBKXQYdSGNYFgff+CuNkU8AtAKMB77uK655ve6KHwgrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794492656;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=nxz0IxyZ0qklpIDkMqdgjYELFVGmdSKRcaGfWcs3vIw=;
	b=eHnSArfJRjANpbDs6gjN+Rg9gop0foRbKZRNmk/I5pLi9tn4pO5po0Mo9kuQ29VSHn/i
	 fNJUsSfnEHUt0ibj6bCyYbtamvQBXzKnWR1DNL1OPCEFgq7g5eCg44qTfdSIFxtT9RQ+P
	 7OgRpUk1MnkkCI0IDhfFWd4saV5HnwQeCKugi6Wyr+G+ZwRTY/rlqF0pi5yhVbtgUAZnf
	 FO+uXYdlNTo0ykuU+NTOUJKmM8Eyjtty+yvCd9p8OxH4e/LEW8I9KamyTwGQnc5N5QV88
	 OE3FrdF9jqM90DM+EryhWAiHLsamrFiT7duOFVM3lUA/izXoKgESBW3vzeU53L603Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=WVGjJzZI;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DiqapLmy;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CC5606A8AB
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:10:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07CC5606A8AB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=WVGjJzZI;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=DiqapLmy
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACAxDqA3893714
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:10:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nxz0IxyZ0qklpIDkMqdgjYELFVGmdSKRcaGfWcs3vIw=; b=WVGjJzZIeob9bIej
	nMTml9n/R5SiVaogsSaU601e+NKusrEJNrB1jiXFnCrVNuQWxA61+RsKgOKMo2tD
	0BuQxqMtPfyepnT7jSxJETcghbMBgKat2IoRurTgCeiL/V3W+SwhDIAiLUYfdFjT
	9e6cy/J9EwtLOwQz1wKZt9KDowLVBqpNh5DjK7dXIRIGLG8pxtPMCPe63Um7zcnk
	B3UPrlZ0uABRTW91QWIV/kkS8dk12vq9bQ7qOFtoQIn5hivvSn3JLMCTK6JyiUXU
	MlunMISvIlRZGQ+Y44WRaQQQjZSxDGycBvh5leWdEgnBJ6w9oQjC+S0K6sWZw5Lm
	y1tJZw==
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hw6re1x0q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:10:55 +0000 (GMT)
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5ecb636b587so1197536e0c.3
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 06:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794492654; x=1795097454; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nxz0IxyZ0qklpIDkMqdgjYELFVGmdSKRcaGfWcs3vIw=;
        b=DiqapLmykv/YUs5MkTbMNKYLq4Lz5Dr8uKHwic7xNPQYiZWRTBQgDaqeguEqcHSwYA
         rchP89kU7Z42l1Fka68IAbK4iyA/e7YuLnd3clYm/iFr7niloLZtl4xzy3ff/g3S1TXo
         XVcBIgWR7iw9umwD9ki+LxSQE7CZZqnaUlVphbEgivxkBxH0L4ixgT0Qr7Zvq+noq9gc
         SdrH23+uhWQ8ToQW2KMuWCrkOAvNnskoJiwm1I3sHmfcielpecvbZ+k0RfS3yjM1WjPJ
         6o3JM0MTF7nQ/svbWLTLpUw8vKI3eVBszOE1gPWbEvSBWr8be0hSs4yMVoYr+allYI2Q
         GF2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794492654; x=1795097454;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nxz0IxyZ0qklpIDkMqdgjYELFVGmdSKRcaGfWcs3vIw=;
        b=Px1KcCKuIGx24to81U3TLtgp2vT1og/JiEVrkKYmhEKLNob8HGM8b0/bmdpSAa1mgE
         YC7Ba49vqEkMwqr1EIe5a6mQ/JHC3XxMqN9QYTyVJuGQyiaAjnAR1R6waZzC9iUc9CR2
         wKv5nE2ptxvcOIJp/XKsz6QGxRuTGLGA0e408MtFn4ydRTXcGlDBK1rkbnhJwM0qbhsH
         1wcT0SxlJAJ2Uv+HXwuvP/SduUMy/aAjpqlOJmiEaFNHhzvZfHYNLzUfK3Z0eSdFiUMZ
         1A27WGRFunRuTQ+0JOdQzh4oRM3LO4i4pd2hiyOrvubCRFg+VY5BxSXM+45GKPv6Aqu2
         f1DQ==
X-Gm-Message-State: APuU4Z895Tv61sTma7UqelM7SdAERzb8EGID3QDZPRDfFaLu4tYjKCWT
	EvXoHtpQi3FG8hD/Yfm+SbMNx/js9y5+p4aYBOU+JyVCfgu/3L/H7UfdNJvNOZzvpRdPus9qkta
	pKHhpSeEcTgNEcigUaq8kQsniezFk+mpUiY0uJjoXambER1LUXsOQ52cdZQL9lJsX8N+AWmjJCM
	o=
X-Gm-Gg: AYBFou36drUGQZDMdMLyOkwdBCuorO0Y5+wolpePbmwmfm2VKsM6U4l7R7gsk3HplpD
	BsRRVxIVtLRyVc5SSGeRQmGOYA6id9EHhz01nLlcrdJ1Sv+5IAO989xGJKEyW55jODa3UsftUMe
	x58iJcl0YNGKo4td3ewOYNQgW8OFK3G4Scq++0hu1t/GWqsT/l+7hpwkEYloG+S5AqvbagOnAZm
	tI8MFkwwmtfBMElltXfyDpw27pKsDbNvxZfQIOezdeSH+BSiO0JPtMIAaACgRhhsNYeXSwmnKS6
	1WIIxcMKS68f2RYYxhlAPQsGw5fHW9T0nSkYMeTcwSIt31Of8LgHoEtYDiL1JMsNew8yTX5sTZh
	v6ZD0vW4IuecU2dAadklwnJ6/mS4lH/KjIIWPbvKJOz5lGleYAXmNodvyIZr1B44ke4YrRjHqW9
	W/qUUsoEw1Iced1MR+JPpos8rDIlVqbAEMF8D+8716oF4vTc0s82huw0g5HhjrFJk=
X-Received: by 2002:a05:6122:3119:b0:5ec:d70c:6326 with SMTP id 71dfb90a1353d-5ee1c46be08mr2351962e0c.23.1794492654277;
        Thu, 12 Nov 2026 06:10:54 -0800 (PST)
X-Received: by 2002:a05:6122:3119:b0:5ec:d70c:6326 with SMTP id 71dfb90a1353d-5ee1c46be08mr2351938e0c.23.1794492653647;
        Thu, 12 Nov 2026 06:10:53 -0800 (PST)
Received: from brgl-qcom.local (2a01cb1d00dc7e0089167b9b97a26c96.ipv6.abo.wanadoo.fr. [2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e271378sm81817775e9.13.2026.11.12.06.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 06:10:52 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 12 Nov 2026 15:10:43 +0100
Subject: [PATCH v11 3/4] arm64: defconfig: update the Qualcomm Crypto
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
Message-Id: <20261112-qce-fix-self-tests-v11-3-b86a65ee7107@oss.qualcomm.com>
References: <20261112-qce-fix-self-tests-v11-0-b86a65ee7107@oss.qualcomm.com>
In-Reply-To: <20261112-qce-fix-self-tests-v11-0-b86a65ee7107@oss.qualcomm.com>
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
 bh=WtO6aZCAkjOIZjzSkn3SdWOc0GthFTg4IDGn8knbBYM=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq9cjlADNyic9kqSgOBPEjApUyRLS0M2VjdEVhi
 jHnGi7k/RyJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCavXI5QAKCRAFnS7L/zaE
 wyNHD/wN3ge3XOkQAQewv1CsqcXmlrtv2VRnzTM2OFXGbrdEGMeXv9p0wAH+LrBDFSwseEfUuIo
 fbw78Sc2HpDlmS9/rd/11olWyIQ1GXulBtwBbzr21c7m0LM50t8IuVafGDmdENGI2ZzpDGh8FDL
 IHy1facCttMxma6eLUlEt9nrW/qIf3wNAwZbrllDQLnCEFAXI2QUC2BoGQZYRjKX++D5K/eHAuu
 WkF325e0JMpBnPAttKtworXrkzu8X5u5CMKGLEii5sh/p4fFMCiQwgkYKZF8L4JiNhhJyxDDbrB
 YWYXE097EzSfukj3M+9scO/syqzPSTiUFL3f6wLRTBs1ZU+hHeZx9bWwp6ZMwB+j0DWvbUczjsG
 RZk0HxNDWbFbl4tcIyIILowMuWCcmTqGkCrdAs3K2jkwUgQcHddWtwiYMms++oXiGuCdA+Th+Mx
 kxEKHrLevhBvAV6J1BTQR9tVRMY2CgcMIlKDCeQkUHw4yIKiPKJvI469x4cYy7xMYHjIpTuWyZZ
 MJ3ujyuEyBzA2GeAUMjU3//XAEcqnWMqxFcTmzzMsGusY8zrPR51LnO6TYqpo57dlj3W72IveOJ
 Yn9a3mKVS4cuG6G3P5sQS4p2jxOzLmWLLGa80hruLooShMJHRFx13mTp4kxiAxkYvno0vtQqy6B
 dn8alaocjC4w0Mw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: IUHUo_D-qRxbzUtKk30urzPBqGrmu5N4
X-Proofpoint-GUID: IUHUo_D-qRxbzUtKk30urzPBqGrmu5N4
X-Authority-Analysis: v=2.4 cv=NJhAaE6g c=1 sm=1 tr=0 ts=6af5c8ef cx=c_pps
 a=+D9SDfe9YZWTjADjLiQY5g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=5AW58fNYxLuDjIPvRSgA:9 a=QEXdDO2ut3YA:10 a=vmgOmaN-Xu0dpDh8OwbV:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA1NiBTYWx0ZWRfX2q1y7smmqoSM
 udFdQv5lqgDkVr4GhrEo4SCFTjvviK7Cb0Sfv2XdjQWwsIdvz+FdNx76kUaEDeFeDA4L2kp8Bvz
 tBNY83hECP6TBZ1Y9J8VXefxrHVVFuI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA1NiBTYWx0ZWRfXxNspNQsluE2J
 WB5USK17I2fa0dLCgrD56fY7Cmks+BeeN/yrzxblJZPONlyXdpRpgt9wJGJfVPqpL+jLrNDox1y
 NssobTEnyGuqM/j05EarAWo9KM4mysV4NiaNLBzQ12CbmmcudH2gzrbaOZ8SsO01t89N/XPlIt3
 Of73wvZWJjNfinPAzw9oAagb89KAJlruOZBxVs4iLDWK4u/cWlQFQwTtITrbQ1l/OeBwizcvw8u
 +OF6+qIiOgeTqczCfGzPfrnX4G0IxgrozCa4ogjqm5bWo/mfumJomNAnWGn0z8yGEz6wPnJtLTt
 mF+kDWtmW3dA0ddPAJbnhqKVj9m5zlxitsuCNLJNuE+oHxXc2d/5yVVmTXsYRfbWj31hnShuela
 UmbsY4IMTRNYm8DAhIN2JHuGo8iNXsWVY4hETBI/6BdCx+6AWY+WjKS1YHV+Cv3FCGYo3XUJBxF
 HnwTCOP+HQ67a+m+ZAw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0 clxscore=1015
 malwarescore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120056

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
index f9179bba64de773886d20cee388293cf9f538ab0..cc81a68f234b9818331d05b51b40735c3296fdb1 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1550,6 +1550,7 @@ CONFIG_MTK_CMDQ=m
 CONFIG_MTK_DEVAPC=m
 CONFIG_MTK_PMIC_WRAP=y
 CONFIG_MTK_SVS=m
+CONFIG_QCOM_CRYPTO_CORE=m
 CONFIG_QCOM_SPM=m
 CONFIG_ROCKCHIP_IODOMAIN=y
 CONFIG_TI_PRUSS=m
@@ -1800,7 +1801,6 @@ CONFIG_CRYPTO_AES_ARM64_CE_CCM=y
 CONFIG_CRYPTO_DEV_SUN8I_CE=m
 CONFIG_CRYPTO_DEV_FSL_CAAM=m
 CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM=m
-CONFIG_CRYPTO_DEV_QCE=m
 CONFIG_CRYPTO_DEV_TEGRA=m
 CONFIG_CRYPTO_DEV_ZYNQMP_AES=m
 CONFIG_CRYPTO_DEV_ZYNQMP_SHA3=m

-- 
2.47.3

