Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8286B3EF662
	for <linux-crypto@vger.kernel.org>; Thu,  2 Apr 2026 14:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775141766; cv=none; b=ObQYOG9la7UuOs/AHFh0yNJKZjgxoUueXS/henTCb3WgD22Dmw5qkvyXp6t2GY7moFJ890r686u72oTprZx/YJeGOJYpSy90RotZgRkC8IjILjrmFuLBbwyfLGt5oen1a1u7z8jhQhZTxicJtfhAN6cqKea09PxK3Mm4k0yAG5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775141766; c=relaxed/simple;
	bh=aFvWQ0r/9MeZDMiHp0RHPM2rE3l+aKHR+uxUux2PIyc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=K2GUklQAJ2F0N+fSIJ9xcsRvuC9U++v6MjGTcucy8HA5brHb1QzeiBPdMTomR1DFFYmxyWYDvBlRZlBqF7I5h2iwYuOAsoHGsg/GAqKbVVuGMUmveW/qwJvxH+feLka3t04xHry6GLycjTZrRwKPdzsFafXuC3g93YX4cLTqtkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kNby8qbh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=crRNtGcD; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kNby8qbh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="crRNtGcD"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632D30BN2798832
	for <linux-crypto@vger.kernel.org>; Thu, 2 Apr 2026 14:56:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	j+gmvqmnx6Mc+rqdGbk0x4TnThgU7BC6K13sY2POFME=; b=kNby8qbhSvkAQU+f
	o+viVz24FO74MfkKbVPx/SkcraBCc16GeP3vbVHxU8z/q6XakW/RHBK7BqPBWx3q
	E9OizDUEJXiYXdwma3Os3Xr/839mrb1Ck7ruXevKpd4GyFP8RJQWBtRS8TNaF7lW
	/d5V0QIhFexsODHwb/SK6GPzIjGlFkpDl4eJ+AYxTMl9ZbR97D8o19pWaeyL0jPk
	7XqreCX6TFT7/0gPIhVYDrPWWnGiSrk3zPRoxlgRqdIqf/fNGi9GVvAc6ipUfX+V
	YYWzvW4SqHxpb0FqevNaP4ogvVB09mUic/CToAeIHCJiK2G4NJKImxRqCVVRAA4W
	OmX4TA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d96hk4pt1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 02 Apr 2026 14:56:00 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50b31cff27fso7779921cf.3
        for <linux-crypto@vger.kernel.org>; Thu, 02 Apr 2026 07:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775141760; x=1775746560; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j+gmvqmnx6Mc+rqdGbk0x4TnThgU7BC6K13sY2POFME=;
        b=crRNtGcDNQv78HsXRCdsyoR+MeJKYGvmS86bjqtNjqGfhyXuEG3VRjt2lIegaScFfz
         Oow0VeSmCIPVTKj5Uyz6RbFVOdDGRzMW9MWLs+UTD5OGfRStAUGJ3p6VSm5K5/CJKnwo
         tH6o+m6SoB8tjna3CNY4WM0xkUr0cqBjZi9aGxXK+/aDH4H9UVY9/jI5Wq23U50vZc+e
         gxh549ejVnTmygUHdgYTMEZ2E0JGTO/JilwvxzrJr1InQSlF1XG3puHPspYdO1e8//+d
         5vwnbeu8rjNGQRw8QuwUYJCc4nLqDBvz05boTf6AE8ENvT2BvY4f+K18w2iHaLzkghwu
         sFIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775141760; x=1775746560;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j+gmvqmnx6Mc+rqdGbk0x4TnThgU7BC6K13sY2POFME=;
        b=ewbgODdMCItOK7RJhzBbkDIl3NN4plokU915CMEWh4wVj3j3r/njelmabPBE8tG6gP
         O35A9f2kwwZ2nsjMUZAdej2onD2yC+8sy/ypOHGRD7ZycyTVHBXFscfeQydQW/NxZyga
         GmoCMS+FFb1PT1pJYxx1nW2x5PIpduGuPsoErtZ9qcgCIkNkbvYeib/v5rISNGcdoXag
         NMgWI9PJaLH4tCm1jgzyHO9dz+ay8L0bMNM76Y1PFpQrvgE6QfXFNAU/lQbUUKrY5czU
         oCm785AgAVYbIVLefof+Wle1t63zGWUpoO5vI4da1PhyG5bohw8fPKiX/HQ7CGtnpjCG
         4DTA==
X-Forwarded-Encrypted: i=1; AJvYcCWORXAnZ8uYeGBLI3rMlhQm0qKk5+eSQPZsceyRLdYzcfjj/Pw76xM9vPSei70vyRILjOqTBiHNiFT+QM0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLGo6Dh5Z0Iuw5znSSsLPnazdU8GZvlGIPbfs5BQGUKyDINq2/
	shzZcMdj7uptrI7PwOzjzLbOEDigp/Ct4vH9ug8kJ/iCPXDzH9QHT6vyDgZGE04s35XW7mM8rht
	OXdcy8lKMfSYr/bwnSz5tDSV8PgqgJj45R90lIwZ+xPfg7LdQpRuu5f30XcselQ7bLgc=
X-Gm-Gg: ATEYQzzLTHuL6ojw7nHfbJEgNkcGlKuurHv/ZI5s1LsxFeVRfBRMaqMz8hnPq8c3DK/
	HKUAHyz69YGLiUFq74+r8M6eIWgEJx04GgjAOQZ+HFpUqQQf5AMuilm8QreobkL7/4E392gS4dx
	QoVrrkdBSGie7COM95/6d29ToKK7qYR8em2uwnK/LLGG/nx7WG+KGkpJBTWP9qGHsEaN1aE/Lv+
	fdJ7NjejjPTYS+MOs+vraD5s8Mv9uuxWnbdkGLnbLvyqS9ZobW6AoV32ofZFAacVdjCBSR1csf/
	d5OO8v3u1yLXTcc1FlTBDOFqchf73rLtrOJL3eU5Vq+997wNR2M1F54+8fj4F/8+9pRVSno5+4c
	wXzrHleBktTTVpwDV+PX+v11VnnzG3lxrmdHNem9vwBBr57DuQqQv
X-Received: by 2002:a05:622a:1482:b0:50b:277d:efc9 with SMTP id d75a77b69052e-50d3bce073bmr112580161cf.39.1775141759847;
        Thu, 02 Apr 2026 07:55:59 -0700 (PDT)
X-Received: by 2002:a05:622a:1482:b0:50b:277d:efc9 with SMTP id d75a77b69052e-50d3bce073bmr112579421cf.39.1775141758845;
        Thu, 02 Apr 2026 07:55:58 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:4ff1:3e57:22ec:dadc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4f5294sm7234038f8f.35.2026.04.02.07.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 07:55:58 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 02 Apr 2026 16:55:15 +0200
Subject: [PATCH v15 04/12] dmaengine: qcom: bam_dma: Add
 pipe_lock_supported flag support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260402-qcom-qce-cmd-descr-v15-4-98b5361f7ed7@oss.qualcomm.com>
References: <20260402-qcom-qce-cmd-descr-v15-0-98b5361f7ed7@oss.qualcomm.com>
In-Reply-To: <20260402-qcom-qce-cmd-descr-v15-0-98b5361f7ed7@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Stephan Gerhold <stephan.gerhold@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1476;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=EVDb1irXK/80h7Y6DY4Kfs/+E6/12M9d/9hBrF4TLTs=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpzoNu23GADjlJCRDcsn8vhTwpGPYfRCrRUbm3+
 nhopRLKKh+JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCac6DbgAKCRAFnS7L/zaE
 wwFyD/47lE829UP657get8D7cIgkr4J9w+JyPNijwVv28MDus4Bdqt4RIdyqaJOqlKwEB4799lE
 1SGYs4j0Rml+fB/NqzA+gvStZNWs9yF18pIS2XVjceGrxl7qEAhTcIR1mGV14G9sjDNKUvgIpB+
 2aWfWhdfg5TxTr55fVAcr3XveF9jtdkHr4lU9toHbgQMY77ey6nPrQ+VGhfvacyJvFM7nSDT9o6
 Fqj23lWBB6BzMiEwigVQTPJb9f4AaqvPzMR6lp42BiqnRHCw/vjb9lgwMmaMAUYwkZ9HB+xfow+
 ZQd35vtlLf0cPf2A1zUhM0TvVMrmJGnGtIZqhjKujpSQe6lg8m4CeI2Ex4Z2gWm0jXZm1Q0c9Xs
 35RNOyCcLIuoICyPDYEEDpBivmbPPYwBoGYkua7ZfmyEpR1SU2S6d/6sldD+fVNYBSSkng0SXvM
 QB6FPlF087kfJVMpFGmldX8fqO2K3JoM4ijy8khWpYP9P9AjCHCtTWurfmwI4Wlj0R9P1S9BqU2
 4L4fQOauy8Vik1aRb5gnrCaJWapZnucRrVjf9i9kHm9WC1p21qbELBaUuPODzkfggpVPjB99W1E
 G2n1XMmM1VJYts+EXj6U7NHX9OE17l8u+LY9nXyUNWzmsD8Chv7GKMt3d2FeiDCU5i8zQuW3LIh
 7rc8aAnrvwDUFUw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDEzNCBTYWx0ZWRfX5knKUu2gJ/Yt
 Gkksw9sHLHjaljeBOV+viMGQZMZtvCR2kKF08UjZEzw3uoaRk11TwFui7P73LstwJjqiTbj+COl
 ZbFxROHcvxpnVerQiIis6aJ519N6b1Yb4ZN2WQaiU4CuTl/WQsgMXXgxLaF1agKDwJkztDWIzkk
 14GzH25hrHVKK4p5NplrDvBGbM53iFrStalm+Iej38ACMhU9zgInrI0ROrNCIp7dguJMaoJmqV3
 52P8c3sNVMDzGg2X2nyRP1c27LeAq0+9E+5jbxc4yGo9VZSZ9troN1tECHDsmPQDFHJq9IY6scL
 lhe1DZFounKYTengcUOQ0YlT0gkJDwMjeuyLkzW0pUmDaENBTEBZTuke/HsNMjyKIra1xc6wz5c
 6zX82xZgPPGXeUNjwpOF/trzqUi1AMmfT4i66uqKEM1wzGb9X3EQx2UJsyC9eH5rTObo8pIJdmG
 El26QGYRBMFg6bSxJLQ==
X-Proofpoint-GUID: MwMv3ZxJHF35pU3w1YEpR3lfKWYs3Nkv
X-Proofpoint-ORIG-GUID: MwMv3ZxJHF35pU3w1YEpR3lfKWYs3Nkv
X-Authority-Analysis: v=2.4 cv=e9ULiKp/ c=1 sm=1 tr=0 ts=69ce8380 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=ZSnkYuKn9ZpO9KHknGoA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_02,2026-04-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 phishscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604020134

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Extend the device match data with a flag indicating whether the IP
supports the BAM lock/unlock feature. Set it to true on BAM IP versions
1.4.0 and above.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/qcom/bam_dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 8f6d03f6c673b57ed13aeca6c8331c71596d077b..83491e7c2f17d8c9d12a1a055baea7e3a0a75a53 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -115,6 +115,7 @@ struct reg_offset_data {
 
 struct bam_device_data {
 	const struct reg_offset_data *reg_info;
+	bool pipe_lock_supported;
 };
 
 static const struct reg_offset_data bam_v1_3_reg_info[] = {
@@ -181,6 +182,7 @@ static const struct reg_offset_data bam_v1_4_reg_info[] = {
 
 static const struct bam_device_data bam_v1_4_data = {
 	.reg_info = bam_v1_4_reg_info,
+	.pipe_lock_supported = true,
 };
 
 static const struct reg_offset_data bam_v1_7_reg_info[] = {
@@ -214,6 +216,7 @@ static const struct reg_offset_data bam_v1_7_reg_info[] = {
 
 static const struct bam_device_data bam_v1_7_data = {
 	.reg_info = bam_v1_7_reg_info,
+	.pipe_lock_supported = true,
 };
 
 /* BAM CTRL */

-- 
2.47.3

