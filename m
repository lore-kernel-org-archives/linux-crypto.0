Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867D33FBB67
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782727300; cv=none; b=a025Oy8mppK3EG6MpfLX9FUPjX/AoH2ReZ9SOxPfnRvJpz7eF4xyIeNBIl+NmZPB4vZCtoBPj/RpoHkVkrEzVRImGglJZ4sU/n+w8mH2tZx2S9Sj+N3DbqCOfXzOfDOdE/HHBGZrjNlNS69TkiQEroW4dvjvzshNbuRq3vawkp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782727300; c=relaxed/simple;
	bh=1Q+aPsoEc8W4PfEahFbzsFEdkzT9tiwxUCi1Nvr+Dts=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=McHT9yJD8oWm3fFeDq3d7x/xJf3nAu76FlXxn/0cS7TOEgsHfaEs49SJ2AmIscfQVtzXXHGNk8P0pLZjGYxN7RoNaBEWZHhcBEH2sPxBzq3x03265jqUMva+SKOne/098reJRmpXu97PVDQhgavD3AQq0vtydIWK8s4TFQ7AkqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YsuC4+As; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NJrMGAgG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YsuC4+As";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NJrMGAgG"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T8xKVd2447472
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1SQ6fBG0Ah0G+Ee6NE98a2a6c+tVDqglySr17bUd1/A=; b=YsuC4+AsGHMSzIAn
	rmr/rPiVskzymkh+ff8DKRVStqcn57d70p3RmEs0cS3Soj8BYKxZOU1Y+g/mBQDr
	bIpaCcMTjYfPUnxTYQOyvMoCautmlkbac/MTiWh4lgs6AkBVJJ4j6HIZGz9HKQkc
	hxiQ4EgCRuV9rTR+tk4ul/j0JRkDcdCcvVvyF/Ptc9AWeBdD2wPlxzbFpuCu6Ikg
	99m3qb6WtQU82vbJubQeIgfAgMVHm5+UwhHV5MAQqD0JviBmiww8pDMjU2WNWhXZ
	9y/tJ3rwT6QveCqv+yblwCeKTuJROm8bBCqCC0jwqIjkESM/RhJddr3JbVIPYWoa
	LQt/WA==
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f3np7g8aw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:37 +0000 (GMT)
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4959c49e054so1298907b6e.3
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 03:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782727297; x=1783332097; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1SQ6fBG0Ah0G+Ee6NE98a2a6c+tVDqglySr17bUd1/A=;
        b=NJrMGAgG53xwTczL9iM9Slv9TCyFRlfHBAZGkH69B22cCaQgi2JusIA9EX1oPjtZwc
         k7fUcyUOVJIFZ+vUZWcO5OUfw/HNXmytp/qAB3iDG7RXIty8rmtT2Nz2CwjsgMjO91Ff
         BYTWbBOtxmRHhYvFp0jTQWD3X72ua2Dev38BZhm3NxWJG2Lv/1eaWp7nheIRoKfiADSK
         pmh8OgBXecxZYi0NEcoPOkpC57g4sUe0IxQ4/gy1Z3rD8MJ+TuUJuSQFTf4guLAWZnPy
         Mcqd4fHOclCdJ6DzxAfqzyCvm9nT0Q57K1outoIF1qDFbRYmmVavYYAaiVfR293++e1w
         IGlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782727297; x=1783332097;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1SQ6fBG0Ah0G+Ee6NE98a2a6c+tVDqglySr17bUd1/A=;
        b=JFbAUtzd74DMoZufF5U8MBeYGJ9/uLKFLciTATWhIBlX9pTATEzwU2ne/yzNaQPXda
         p3F7AZcJRG4Ejm6xO++erCJSSVMDy1szpF21f5rJ4dMhnL+oVVaN3ttBE1aozJOZXi+t
         89Vis+PZ0N5q5SZEFepfbdz/X/HituDF6Eh6MSi6E16CgGOF9/K7Dk4Nlal24VtZyeey
         zqO2YL4gyeQFqyO3B1xmpqYBSJqshdfiN3SXDm0MZKjxKPoVUrvgmqnn85wfb1TvlNkn
         hrBKu86ccqKRQb2yazrTo0Tgs+LvXgdjRcInB1fJN0iMkuIXWuWPwHPPGtXLeb8a2/+I
         1oCQ==
X-Forwarded-Encrypted: i=1; AFNElJ+nTe5xNW1QKWPfqXDUL52dguOdVlR+/Z5QFxSTuIXIkVE4HjLRmGJ7bq2v0XG6zaTCPJ2A7X1cLRZxqig=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ86BKDvBZaMbgRnD5S9xMeqVa3VlsgUQ8iLm+ikpdWgeBSiFx
	W2bDTAF+hAOtS0kj3kLtzvw69TpmAPojJ/CfwiYrhrYk6JFm5NBo1lkBdMRWvr7+sJaDdOyYp5L
	v6ly97GFo8mBJh+0oFPftFK79NNbScjbfDf0TO9zPl/ELGcmPc6NyINZ3RusuXvnjMJQ=
X-Gm-Gg: AfdE7cnZx9nZMEYEMnjJ3hO6gPX0Fx440p53Mh2McyNh9TYU8vUm/GkgxbYD7UuAy68
	yMEqK7Cmw5GppqUmLTo+YKru51As/G1XB4WzmJ3+ABoWXdVlseLLTwinPTDqOIwa9YZ1wa+0Sqb
	BgyV+f/stVgiU1BjvV0taHd0tD8FwPid9k/7UkmZV09B1VRJSGzORWbBKmIiK9Ja4BIeanMw7xI
	tcNdS9f9ri/45gGgzrM1RMugpY5I1Fu65wtgwp4Agm1o/rStg7/5k1Z1IqeqSAraQBFBgo33Hls
	bPsrCWRTRv3bx0ENHqQmn9daQC1dX7rpxWgtX6mUlV8wfajKIha3OcZYp0i8k6wQ9Gx2EcjUoG+
	EFnk7Hx5q+U2tppcOHxfmJp1vCfnecKZCy5xhbo9p
X-Received: by 2002:a05:6808:1b1f:b0:495:97ef:b41e with SMTP id 5614622812f47-49597ff0929mr4551657b6e.34.1782727296617;
        Mon, 29 Jun 2026 03:01:36 -0700 (PDT)
X-Received: by 2002:a05:6808:1b1f:b0:495:97ef:b41e with SMTP id 5614622812f47-49597ff0929mr4551638b6e.34.1782727296160;
        Mon, 29 Jun 2026 03:01:36 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:4640:d76a:6126:9b65])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4705f8ea729sm24729405f8f.0.2026.06.29.03.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 03:01:35 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 29 Jun 2026 12:01:06 +0200
Subject: [PATCH v20 04/14] dmaengine: qcom: bam_dma: Extend the driver's
 device match data
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-qcom-qce-cmd-descr-v20-4-56f67da84c05@oss.qualcomm.com>
References: <20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com>
In-Reply-To: <20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com>
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
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@codeaurora.org>,
        Neil Armstrong <neil.armstrong@linaro.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4322;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=HGeQqzQf8+DrUa/4bzOvLohFWS/bDVC1MPHUwVaBFAE=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqQkJrR7CPyvsenTdz66zDbeFqHDDGugXN3lznr
 16tzveSf+CJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCakJCawAKCRAFnS7L/zaE
 wwEjEAC8BxDeqzVB/FiSqLfBuyiSc+udm/QP7Ano2F2ABRLcPRibEPFFMP143fGC/RYY5oZnqZs
 2zGG48hkxWC8orAZJOotoGULoSVZ19Qe5vl4VAR0VjePneRaJT99/ZULnjxoIa3S+vGybMQ+mlG
 r9xiv7hfIJjGSua7ta5/jpQfMQ5mNPETs7dJlt7qq6nHwXjpBAfUqBgSDOjt1rVwh1mLejS5pT7
 sl1t9rcTsEuToWf3tQNMvKPofcj/P4wYiMbzt8CpM+1p/zmzjBwFGDw7i+EUnCXle5c1ldKMI7n
 pg3ZfKNmJrNfZ7HQYcvTORv7MSg+5GU7+dDIyQFUnk/71l+X1wKX63j4yGN9OPxaWhWZIT90qI2
 rUFGFQVLZeaSeuYHJJgiUxVVX2nwDwPD6FMlMTPQRcxDds15S2stZJujuBmZEPn/q9dzJoEBNDK
 YKkd9eYKai5OtBCZhZmB/Rw2cEk1kaTTXJqyI0zGv4P49wV1Aetqj134wzGm1fWLfGyqqxJLeps
 pAPqGI//pu3o+2ciKnLMJOBkJWMd015L7YaLrUOtK+zUqeIM6vrJfZGzipYm9Budf5x+xe9s4ms
 YRZWUKzVyLxTzMJXRaOoXa3CZcP1DbNFXAaSBUoOTQm5fxh26q7UVxpS6s0fNNv6NrhQ6eHePEZ
 zLyKdIitZ3HAvxg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfX+k6o/hiHlMvt
 F4WlIhYPSnRqED7mOUfiSBCemiv9+ZV7JeHdx7/4MuVoFm6IiGSSwDHC+WEaPX5e/hRqVJi8Fl8
 JMLngFomMmyu1iGx1Qo4k2GxLxlGnjg79+TAGpQwsnxVg8RUAHswHcVrlXmswlhepmUJx8avSp/
 x/KHR9YcDoQX2ahIT629Ffc9pJRdPCfrQOX2Xs46YQafq3TWpW1y1P3DRxYPfI+5Gmop67S33ZY
 nm5m590gX9Rz6ykJ92+yPmwz3o6ZUpFhgwtuLYD3zdlSBApB9yK3yiVbZ5qwQdzRZ1R5JCKxE22
 O13LbqjqLbvBbYiAY9+gmuAcrKJYPYH00RLUhLSEY7poxMEAwd6EBZil3bYgJ64ZxUBW53Uzift
 ImChbNifizitfh8qug3391wVk87krri6RU+8mpMjxJD9Wvdn6AzeEFOcu/jkXzY/OX1Iu0pk6CF
 4SxRcde1V7CJc/1MTSA==
X-Proofpoint-GUID: DPhco2EdDH7b0_BPn8ioB0KF6F-145qZ
X-Proofpoint-ORIG-GUID: DPhco2EdDH7b0_BPn8ioB0KF6F-145qZ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfXy+aIGOnVn+O4
 wAtcfXUvcc2e8oq+Gt9wUdsjhX787v8/C4qe9mPrFa6wPBhYj+Zz8BfPAhFNBFsVZfTnDJagpl5
 RRK6sHFEq+6UsVpIuoddDL/9ySPrhwI=
X-Authority-Analysis: v=2.4 cv=OcWoyBTY c=1 sm=1 tr=0 ts=6a424281 cx=c_pps
 a=AKZTfHrQPB8q3CcvmcIuDA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=ioP1PY9e4_dTeLeN8ycA:9 a=QEXdDO2ut3YA:10
 a=pF_qn-MSjDawc0seGVz6:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 spamscore=0 clxscore=1015 phishscore=0
 bulkscore=0 suspectscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290080

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

In preparation for supporting the pipe locking feature flag, extend the
amount of information we can carry in device match data: create a
separate structure and make the register information one of its fields.
This way, in subsequent patches, it will be just a matter of adding a
new field to the device data.

Reviewed-by: Dmitry Baryshkov <lumag@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/qcom/bam_dma.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index ea3df28e777f99c0532761b6aee6807ab23ab4ca..8ce0fe085c5fea6cc614edd692b5cfd264b94d5a 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -113,6 +113,10 @@ struct reg_offset_data {
 	unsigned int pipe_mult, evnt_mult, ee_mult;
 };
 
+struct bam_device_data {
+	const struct reg_offset_data *reg_info;
+};
+
 static const struct reg_offset_data bam_v1_3_reg_info[] = {
 	[BAM_CTRL]		= { 0x0F80, 0x00, 0x00, 0x00 },
 	[BAM_REVISION]		= { 0x0F84, 0x00, 0x00, 0x00 },
@@ -142,6 +146,10 @@ static const struct reg_offset_data bam_v1_3_reg_info[] = {
 	[BAM_P_FIFO_SIZES]	= { 0x1020, 0x00, 0x40, 0x00 },
 };
 
+static const struct bam_device_data bam_v1_3_data = {
+	.reg_info = bam_v1_3_reg_info,
+};
+
 static const struct reg_offset_data bam_v1_4_reg_info[] = {
 	[BAM_CTRL]		= { 0x0000, 0x00, 0x00, 0x00 },
 	[BAM_REVISION]		= { 0x0004, 0x00, 0x00, 0x00 },
@@ -171,6 +179,10 @@ static const struct reg_offset_data bam_v1_4_reg_info[] = {
 	[BAM_P_FIFO_SIZES]	= { 0x1820, 0x00, 0x1000, 0x00 },
 };
 
+static const struct bam_device_data bam_v1_4_data = {
+	.reg_info = bam_v1_4_reg_info,
+};
+
 static const struct reg_offset_data bam_v1_7_reg_info[] = {
 	[BAM_CTRL]		= { 0x00000, 0x00, 0x00, 0x00 },
 	[BAM_REVISION]		= { 0x01000, 0x00, 0x00, 0x00 },
@@ -200,6 +212,10 @@ static const struct reg_offset_data bam_v1_7_reg_info[] = {
 	[BAM_P_FIFO_SIZES]	= { 0x13820, 0x00, 0x1000, 0x00 },
 };
 
+static const struct bam_device_data bam_v1_7_data = {
+	.reg_info = bam_v1_7_reg_info,
+};
+
 static const struct reg_offset_data bam_v2_0_reg_info[] = {
 	[BAM_CTRL]		= { 0x0000, 0x00, 0x00, 0x00 },
 	[BAM_REVISION]		= { 0x1000, 0x00, 0x00, 0x00 },
@@ -229,6 +245,10 @@ static const struct reg_offset_data bam_v2_0_reg_info[] = {
 	[BAM_P_FIFO_SIZES]	= { 0xC820, 0x00, 0x1000, 0x00 },
 };
 
+static const struct bam_device_data bam_v2_0_data = {
+	.reg_info = bam_v2_0_reg_info,
+};
+
 /* BAM CTRL */
 #define BAM_SW_RST			BIT(0)
 #define BAM_EN				BIT(1)
@@ -422,7 +442,7 @@ struct bam_device {
 	bool powered_remotely;
 	u32 active_channels;
 
-	const struct reg_offset_data *layout;
+	const struct bam_device_data *dev_data;
 
 	struct clk *bamclk;
 	int irq;
@@ -440,7 +460,7 @@ struct bam_device {
 static inline void __iomem *bam_addr(struct bam_device *bdev, u32 pipe,
 		enum bam_reg reg)
 {
-	const struct reg_offset_data r = bdev->layout[reg];
+	const struct reg_offset_data r = bdev->dev_data->reg_info[reg];
 
 	return bdev->regs + r.base_offset +
 		r.pipe_mult * pipe +
@@ -1234,10 +1254,10 @@ static void bam_channel_init(struct bam_device *bdev, struct bam_chan *bchan,
 }
 
 static const struct of_device_id bam_of_match[] = {
-	{ .compatible = "qcom,bam-v1.3.0", .data = &bam_v1_3_reg_info },
-	{ .compatible = "qcom,bam-v1.4.0", .data = &bam_v1_4_reg_info },
-	{ .compatible = "qcom,bam-v1.7.0", .data = &bam_v1_7_reg_info },
-	{ .compatible = "qcom,bam-v2.0.0", .data = &bam_v2_0_reg_info },
+	{ .compatible = "qcom,bam-v1.3.0", .data = &bam_v1_3_data },
+	{ .compatible = "qcom,bam-v1.4.0", .data = &bam_v1_4_data },
+	{ .compatible = "qcom,bam-v1.7.0", .data = &bam_v1_7_data },
+	{ .compatible = "qcom,bam-v2.0.0", .data = &bam_v2_0_data },
 	{}
 };
 
@@ -1261,7 +1281,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	bdev->layout = match->data;
+	bdev->dev_data = match->data;
 
 	bdev->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(bdev->regs))

-- 
2.47.3

