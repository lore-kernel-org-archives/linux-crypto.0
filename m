Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCFD42B73B
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 15:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467081; cv=none; b=sRBjGJlpRuLYLylC9lnij4zf+f3MFdHb9hlQ9nz8MfsBgrXvzgmcY/B/cGKI4hp/CWsRq+8IODggN29x68ImY08H1FP88enk/SvpUbeVhqmKrnAedIgX99JtKHI2E3M8UWVL+eOFhUT/21ny2rRKHchZpWKj3Y+X7ZRP8zLry+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467081; c=relaxed/simple;
	bh=QtDKw3sIoTdfDtZw65i+I58veFyHFSLP2ujI82KTTCs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sEGQDptfHjJjZVsSux/tmZWEbWiCcwyZxEP2rHHIa6YKTkdjnZ8h/H62+nMpewFxtZI5tqVLGvwDMElGWdUV+1lxZSZk/hcx1Gn5Py5qNGqs9tmvG9XrLXuG+ug+KuersIkCTwiZSXsUaP/2qNyccs1UAb0WMdTuTQP5UdWmBgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pQ1cF/MH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fEFjOI5Z; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pQ1cF/MH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fEFjOI5Z"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622B4NB43561558
	for <linux-crypto@vger.kernel.org>; Mon, 2 Mar 2026 15:57:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	AJf/VHFbEfrJ7fM8DpDhu22yxXg6EYy+KGz73+G0kyo=; b=pQ1cF/MHYq59woRz
	oPrTjawyd36QiltIrv43pzT61p3G2qkYzR/zqYARzavBpUevniNAZXa1EVozR2PE
	RbUaTpzJdtRHFOP7mHtMmZl9GdOAPUGNnztZJOdUxGIf7ppNfPUR85fQhI6nAoj+
	hfkbZuQG4T3Zhd3V422sOQwPkHm+lkLJRudA8Ar4m8of5apM7xIz6yzQB2vJBhZX
	vBjN5x/zBYjil+QO42LFEWpPtdaurRGUCpecBMuk7EPEg/QD+/NGvvzDErfDwP1b
	lgJ2351XzPs7Uv+UQpq+SIPjiwBGb3Kk22wy3j8vJod/lMMA/RYfgM9B5WTv0Vgg
	bRJXGw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn9bv8yeq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 15:57:59 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8c71500f274so468758585a.1
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 07:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772467078; x=1773071878; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AJf/VHFbEfrJ7fM8DpDhu22yxXg6EYy+KGz73+G0kyo=;
        b=fEFjOI5ZZfVUrHIQrBzM85/ZrTaxhh2J5tXIDhSdscNRCOoXgIxJmGI/ysz6hjnsD0
         wcc/A08cFwk5h2zGgGDMNyPEHk7og5m6PanyS2lHaGB2xRL+nPi+Dj9GHpCDvF7H9EjA
         nicOEA6OF8KrkDRUhZ/Pz7SfORh5+JbwmDWnYvn5By/GhzIUCB/ifsWsfOMrwGNxayGW
         ulF2W9DldLTbCvs791djKjFdKfd29xI0GFl8dxlGGgiy+gWgV2tRzC+RSSyYKdb8iGtJ
         dQe/9IoHavkdJ1MeM4ySWLnAPWhpK1NHVJk73zCaNlrqePLLsvxEmLZkDRzNitrOog+l
         mXbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772467078; x=1773071878;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AJf/VHFbEfrJ7fM8DpDhu22yxXg6EYy+KGz73+G0kyo=;
        b=jsFxhTDG8psIWMYQPY5+Blp8jbsWOufcJpcX1u1ED7t5R/duDvO1LvC02ZZ/zvr5YW
         lM9Coe0BmH91Guiiklh+14EcDAp27tRVaeZt/7VZi3fCqMjW0+ayEBvif1MKOaemuiIY
         IgwRWZD/y5WPpf0EjP4teFdJmQWVgKUhmLhBAtu7uwdOZoyCrKNx5+EVZeQ8AM6NZ5O4
         dFK37zs6TEZ9zBP2TjggRIP/6Nxz/Td8SzG6A7nlkDLif76V8XzlHcxIOa9/e/whaqVw
         W6wvK6q9q9gWW28ydxueRmEwfbgerPudHJlN6hfvYvyrMZKLchqyLftydHENQ/zkcgk1
         uplQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBYHyX1cdosAW9HofpHzOPpT3uHTONo09SYt3aFM4wCFDk2l4ACpEF7Ce0DZaknc3Ci0NuCmvPIDkMoBs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxMYGhLP+cQyAGMZ1sPpvF4NMdnxnKD055LdPObsxdm1gd02EZ
	5BPHwuUSS6waMUFjCgrle0RdAvaoOUyYPCMQPnelosWYBxXZt2LiArsNHbUTVFUJVD+zZn5qgHF
	cB37Rr/vLul1DdlvCUZD5XRA1U4mKmsj4SP0vR72Iua2CXoZiygXMfZ1dPg6MhqcGdUM=
X-Gm-Gg: ATEYQzz6JHBcol4e93L9e4LxJEFpnVl0y03CaUK+vC8c2h1dJ+Ci7Fup5wynsAB5KFX
	o/R9p3qVUlM09WYJPexop+KgwwhzCtAAfE1/2Kv9MTTxQdAksfu+P2OVhHB73zIvxw9Uwm31efr
	ddGAnCCJz3Qu9QxV7K9wP8sO6QirWb/MRspiBhJCTWh5rCfAB/FCkjZnBnTJizvs86+XoN6tqxj
	MeYLG2XOCwV3rT5DcFja+VfPcoX2th/qoLFpwQURV8IvD6pvWbZ8EPLUfF+nbnMi3XcoCcHkP5l
	X8JReRXyzrFqSilnJ92uWaF35mzLlLWrfJVyZ0BryZlfqMaqYPW/0/dxQHIreZwca5spUgZbJVe
	4W5c5JzLJ1ieEa71WC8DdTdc5Wdy/eY/fY6zoarVhrMVfomohrT2j
X-Received: by 2002:a05:620a:404d:b0:8ca:2baa:774 with SMTP id af79cd13be357-8cbc8e82641mr1612984585a.18.1772467078442;
        Mon, 02 Mar 2026 07:57:58 -0800 (PST)
X-Received: by 2002:a05:620a:404d:b0:8ca:2baa:774 with SMTP id af79cd13be357-8cbc8e82641mr1612979485a.18.1772467077944;
        Mon, 02 Mar 2026 07:57:57 -0800 (PST)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:87af:7e67:1864:389d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439b41831easm11282438f8f.12.2026.03.02.07.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 07:57:57 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 02 Mar 2026 16:57:24 +0100
Subject: [PATCH RFC v11 11/12] dmaengine: qcom: bam_dma: Add
 pipe_lock_supported flag support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-qcom-qce-cmd-descr-v11-11-4bf1f5db4802@oss.qualcomm.com>
References: <20260302-qcom-qce-cmd-descr-v11-0-4bf1f5db4802@oss.qualcomm.com>
In-Reply-To: <20260302-qcom-qce-cmd-descr-v11-0-4bf1f5db4802@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1425;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=gfl+Fn+ISpyM/izQ226zR5pAGJiHs0gWIagW7nCmNI0=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBppbNt5bDUkL7J/F9xgZHxua3RHn7yN37DQAd5k
 a81DXZBCUmJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaaWzbQAKCRAFnS7L/zaE
 w1AsD/0dIvkbcuCLSVavXlzNy2A5vtB4RVHS7Sh8XU1wqW/rudIXRcE6A/tT6zQwwRl9FKk72R4
 LRyW5woC/F8fOtXQbE60wN+nyNhHJqFaQrXGcgvkIdjSeMEPHBP0UGmLQc/DlMK7Myvcmha6NBq
 a7R9i65yQ1O7/TjxzvKbo4c5VsEJosG9sqsIFAyo+cctWRU5+DVpaHS6Watckmbme0qFNGqMumJ
 ZK+SoYfWp7qA+QUakyhPHwWmBJCyojx0QWjNQ8jaXYHBMQvDDGeTv5aXLGbiN/X7cONQ6t+5gok
 bjmeSoRCll96nWdaXevAKoCcIZSlLAZtKNrPRTP2GWc9NskijVbNH/58e7ZJdTtHcrHe2AuqrDX
 5IoxbK++ZYng/eVj0Co2mqvxa7b9p17y2odXkzVfMnvcQiwUd3gp9OHNLvtUjXhwgnH2+9bLInl
 7QeLiTkq+oxQOUFnF2NkQSywZFTVeUuczgyvavqi+GMgYUPijvaprVjCA3R9hLuxKq/Xj99E9i0
 bHNrt3Nd6WdtF2JvBKm+xXlADr7nUv01fx/TDwiXIhzvk/GnJoT/ZfH0BqGi/ktIBdPqgujId+7
 xcRzaDdTjSY+NCHZL0FfykhDxXOXZjG03CXeFld/hXWHgD9mY3CgjRQ8lj2++jdO2J9Q3dLNRSB
 Ddhf8CtiibFMAxA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: 6m8RRvYHqA_TM8ysnQY-RShr4KUqjIxW
X-Authority-Analysis: v=2.4 cv=S83UAYsP c=1 sm=1 tr=0 ts=69a5b387 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=ZSnkYuKn9ZpO9KHknGoA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: 6m8RRvYHqA_TM8ysnQY-RShr4KUqjIxW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEzMyBTYWx0ZWRfX3Btlttcltqnd
 SK3JomFPMgAOjEXBZzsZLmmWKij3tKrpAu4FNYvDYiMAe7lJKYYQKDP/2prhZH+dEJl1P7XcfEn
 XHz5YhMmlRZgapmM4oKeqii43SS1wd6Lxn/TYPM5ZkwpJUOlw0RNu9+wlV1bWW28jRAWpXAiv+U
 Csc2e85fEGgpVQ5GUNtKmrMGci1dlAgKiZQoIjcUN7Z0E1nyECetOs7D2Cmxumlm2MC+wLmO8mm
 xhHgeyi3Xacf19FiLUNnGaFv0d/4Fu81qpDpArSxXYHVo4ehkduazXgCjKvTa/UwQohtYRMtpld
 KFo6GnpZEZEehm4GQEuxFHinYhP8JuutIq8I6I0hqk1msAgKM1o/Asv/wwSerE/ZyEzVX2KalwE
 BrGorufqXV/59mPYAmPkUGX7cFveBJHxEJG8OGJczscbjo0jNoE4soGVue8kZ0h0bbgvKSJ/lKh
 +nHxoPg90cTy6HSIYuw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020133

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Extend the device match data with a flag indicating whether the IP
supports the BAM lock/unlock feature. Set it to true on BAM IP versions
1.4.0 and above.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
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

