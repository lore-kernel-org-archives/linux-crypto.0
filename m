Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA363FC5C2
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782727301; cv=none; b=r0QytvpzB4RMg87hA5vJpBXshxOZ1SS1dJGLXGmyPlDuK9zlzg6ffiOePRANpqYnlVfD0sDKnfYYNsaPkq+EYWmFxX56F++tp5AdPt1t0tdqb2TibsdGX5r4KN45NeBlnNcmczWWJJ5PW2of4CPBvhles3/OSs9lMc76BbHo0Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782727301; c=relaxed/simple;
	bh=zHIuoWgA0JNzB45qmsTvX1DiRfFAkkbG2L0hbAcWpaw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ofMPAz7FNcdXakRCsiZlFr1JmM2nSToTa4nK1Zi+BryTRS4+NqH6Q1Behj/t2MpSg5F0//44IWjZs3OsXRUMZ5QpJ1uS5D69cexR9tHCZ1IJNTFx6WchKD5tTHRInsXexdWMDWPRSC/gjVEX4xwOgfXznEy3WszOlflb0SbinLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UI0gMh7G; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RZxXpWXI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UI0gMh7G";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RZxXpWXI"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T91O6G2400899
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	d0wSBB0zdvgp8nv5/qOGe9s7Ri2Cp1uCk4+HjNdiilI=; b=UI0gMh7G9/BxQuDe
	2oTQhN1GZDkR6J5JyO18ZkYYzav5oG8XdQ1ND4iD6FZLwMWX7yZOjvm1YKH3Yp2F
	KDFjFFILjqtmeVTt4IREZyzipndGDH/C8Okw+I/7+x2Ql6SoPVJmDwttWkB2CPKJ
	o61luCPpFMqS7ci2GBmcupRtpLgeq8H+bpqX5TOFIk7mq2EDKrS7oApu0mpz86YZ
	t1wuXOgcNYDT+PB0bA3z9YbgAm1OkDgg2jx9XSHVW0zsk6L4h9dCTNnqEaRVhjvP
	qHKJav34vUz42UIX9BOue67rLI9j56XA9yPMkgazCVXFxoQoN+bqd41BUZY+Hg++
	bOZ80Q==
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f3nq888bb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:39 +0000 (GMT)
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5ab02fb3054so2558642e0c.0
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 03:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782727298; x=1783332098; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d0wSBB0zdvgp8nv5/qOGe9s7Ri2Cp1uCk4+HjNdiilI=;
        b=RZxXpWXIqF4HSzLl8BjkPERBIr/P9GvqOO/n1g5ExegtaeJiaFJ2aLc0KNDj0DnE1c
         lDy+ETtwTs6VWo5zFbmMqA2ZqzIHFDa/frXjSWghQkHGuyYGNP4UPV8QCoRSbOcifVWV
         EUb0v+fk2VXcijcb/NYvP/cmNpzzHPiN8/3fmetHOQ1ly/ev+KeHjQm857BSA+QYwr8R
         r9D1am9nBXeCcJHeZctOUY3dwJXcT2YdyqaffN0tYiXHzkNhf5VQBo+TCY7XRJWKeMWo
         ZuM9Y4o4la6kLtlOWz5L4KSZyGW1j+PHDb+QML8pdXUEU0Ve9m9X8bIg4GqBU8FpNly0
         EoIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782727298; x=1783332098;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d0wSBB0zdvgp8nv5/qOGe9s7Ri2Cp1uCk4+HjNdiilI=;
        b=F7DDryKQNrWTonYbwLXWBL6A7pxTJFaSUBJbVtPgO9BcMpau25jqmCZXdmnjM8j+Hu
         t23KbgneNZNp8+hGTGvACxLF5hjb1DmpFEYW8ISipgtagggZMbvhXWOUv0v4X8J3raAl
         Zii2LWTgGjsEVgqiPselE1ykMm/WKgaIHUzP90ir7ooN/jXk0aZlFUHOlqEar0CkmPJD
         AmLGFzikK+oSc+z6URyezfDDZ3BiaqrlgVBCJNcRzSm4j4wjpDYiUqp4gmDy9C42DNLx
         OsefPn/vKK0HCSBRqPluYavtX6zKJz3UyYrtwh4doFAo8dmaBH6tyLqCwBCu1fpNu2e3
         bs9g==
X-Forwarded-Encrypted: i=1; AHgh+Rp76/7/+0pVMrAldbaN07MZVq4D6Z+1TYUfp9kc/meSRGAZY70jvJCeFT4Lt7rPO2nKvp5Heu1I7uGbxLk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx3wA6dZLzP4RbDaMitnimz9+nlovls2h72hB1CLGaiO5X7xDY
	Dn0shnLwUEZd2K77yJ5/K+zpST6uO7+78nlEyKnL1cqT38tSFkNdO8LnJQg67N1czIT80MNEZjf
	FXUCK5XAG+6yViOinaNf4Hzg9dGo1IQvta6UzZh6ASDT6t+HkqdUH5ZqTiyzWJ5LnKcM=
X-Gm-Gg: AfdE7clMPkBqqQmyeCTjRXZtX6ymmG53NizadjcGIAgZRChQk8Hqr8o9fxEOMFNizo6
	NUj40ePNJntV5mUy29WwX/fXrFMRTX7H7x531z3kKxVx4QN18l0IH+v+zzSAOED5uEXfpqZZ9En
	5jA0oC2JpA/sEtvOUmNrJDHX0nElx+DEAZZnKGcHrqyHcIOFScZzgzn3yJgpR0nW3G8pss80WYO
	xXEifBKrloBN+blVT84etda2BQCn/TXjHhLb56fy0dKMNB5jmKjPFcsurFDEpD3wRpVoIAxV/1T
	mzg4QVqfst0VQfayxl5nU/la6G8biFpFLA+MceuLbRWQrvgv/vwaoTq2HtBR/mJOXjicDEQnJp2
	uLY1wr/nwhtr/+Lwbnz1hQdkfxQF0s3A6Cs9qgk1y
X-Received: by 2002:a05:6102:2b84:b0:720:7e04:b306 with SMTP id ada2fe7eead31-73434037ba5mr5559556137.5.1782727298328;
        Mon, 29 Jun 2026 03:01:38 -0700 (PDT)
X-Received: by 2002:a05:6102:2b84:b0:720:7e04:b306 with SMTP id ada2fe7eead31-73434037ba5mr5559506137.5.1782727297785;
        Mon, 29 Jun 2026 03:01:37 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:4640:d76a:6126:9b65])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4705f8ea729sm24729405f8f.0.2026.06.29.03.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 03:01:37 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 29 Jun 2026 12:01:07 +0200
Subject: [PATCH v20 05/14] dmaengine: qcom: bam_dma: Add
 pipe_lock_supported flag support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-qcom-qce-cmd-descr-v20-5-56f67da84c05@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1807;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=8sCOVL39BX2AFiqeGpscXeG1puX7rtAOjEFEhJGJOUQ=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqQkJsmv/o1deas2zWEHYrq8lFB74FXE5e17jFN
 KDp7w5BZ2eJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCakJCbAAKCRAFnS7L/zaE
 w5mDD/0dvYsn8wcOxoenL45TBXSA8eIJDIl3WnXKcembWmr26XchibGSAHvzgZJctIVAo5xCnMx
 7+Edz2oy35G5iWFqChbqYmOWOPtmX9/67YoQ4FoEfxLgbcfupubEkvaWaVMECA3Pwp1Gb+x+zlC
 +1zjrfZdDGt7rQXLiDf/Wn/drI4XdP83uvvKckIMshgyANpYJg30TNf4BqDWW5RYbfJgkODHDH/
 /Tn4M76WYCpM4yAvguy9VyuN0mwwf0h3snS/klxm7ak95iUvTwT5ajSzSA1OZq1inYpL2zlOfgu
 1ZSPMczAbt/yJHNeW0+qk3SAbOEL41DKRu07/fjNy/6ppBp8hLc3tG+SRBGSMKyjAUEvHyJntCP
 u0EwNeEhCdATHfccGu6mHCdzz6XPiwEAOwMyo7H3x+oExfaJCA7A+TSid8quk13UvJ/WfWcvDfb
 1HISaclIm7oHGQlkGofN2HBon2I7yRTDV2PH6Oymxq3K+Z4Hb4cnq86zLu8ObzLpi0/hCxxHDYJ
 L+P5FXXnPZ+xnHgDczHNHX6J4w84Ql3lDpLPtlLQgRaiRO6kTD50G1a8V6AuBB7Toq4tW0gNKlA
 7/jLfL748dBJy/CncsCWcE/ZsVAmFY6e3Bn5Bb8ttFurbl4Hq+78K5JWaDhH0ecbY/N4oCWll4M
 ijiy6x8iosCX4sg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: 4OGjf_J_6mKnv1mUq7pdWR8IfblQjTT2
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfXwIFxmcqYBeXD
 b6+B79P+Gn5IU/vnMzSO7Eg7qOpMxi+0swCcz7ib+kj27I2r0zOBnnTeCDsJlIZ+FjaJkuBtuBl
 R7gGHWNoQw9pqxSHKADoGlNfveDDz0E=
X-Proofpoint-ORIG-GUID: 4OGjf_J_6mKnv1mUq7pdWR8IfblQjTT2
X-Authority-Analysis: v=2.4 cv=PqSjqQM3 c=1 sm=1 tr=0 ts=6a424283 cx=c_pps
 a=+D9SDfe9YZWTjADjLiQY5g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=ZSnkYuKn9ZpO9KHknGoA:9 a=QEXdDO2ut3YA:10
 a=vmgOmaN-Xu0dpDh8OwbV:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfX7JE/KVOXpumL
 pOLjVmOMP8RvZno0QfQ7O+oFRMOn5HwAQSEpveWy9K4pt3+0HFW2YPL7FnnreQuUrYyh+/LOy0F
 55S9OxNWxULhSr7UAFEWu/GISbR5qEKWIelY4FKjyyJ2YwjRXBBwSpf6ZSUtJrzgWRXygvbfslw
 yUIVnKzmxaJtpdAX78DQDv+f0DDFZ8FuIcPUqM9YKiF63OVgllvr1MKhaaFKsXSTHSTEqdgKqrK
 vwm36serDxsliR4pQLDe7I1LxkHIDP3f3Q/at67cMEwAidZay2Q4U9N/a/YxkG9vSjW3j39CZn0
 J7zzU5uQfh0wnzAjXFuPF8E4uXFe6Rwf4Kbf2JD3QxAVuTKJK/KDXtWLVeNIe5Ee6RVHrc76T4/
 x0pQrgXEHl2Pzo2plidxmDxcUCiu7hBTSCQqjMeek9DlD12n2g6caTZE/+Wgm+1U9n55WSzbUJd
 hV/A5fWsQobvFHJWjOg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606290080

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Extend the device match data with a flag indicating whether the IP
supports the BAM lock/unlock feature. Set it to true on BAM IP versions
1.4.0 and above.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/qcom/bam_dma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 8ce0fe085c5fea6cc614edd692b5cfd264b94d5a..f3e713a5259c2c7c24cfdcec094814eb1202971a 100644
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
 
 static const struct reg_offset_data bam_v2_0_reg_info[] = {
@@ -247,6 +250,7 @@ static const struct reg_offset_data bam_v2_0_reg_info[] = {
 
 static const struct bam_device_data bam_v2_0_data = {
 	.reg_info = bam_v2_0_reg_info,
+	.pipe_lock_supported = true,
 };
 
 /* BAM CTRL */

-- 
2.47.3

