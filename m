Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF5441B36C
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947709; cv=none; b=ZJM+MzeqDbDaGkV+8OscBZZlrpHLBWWabbXGstC4/cypJKsKI7XFmLAZXWqUPLSjs027IMNp3DO0HhEBW98Ab4yn699huxzeFOiEW23Knec2HmUbDfDSAblgkspq+51aR+2GtLSXX+qnUq++O4LMFpPqkYh/KKyf38MZCbj6/JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947709; c=relaxed/simple;
	bh=zHIuoWgA0JNzB45qmsTvX1DiRfFAkkbG2L0hbAcWpaw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=F3UOkeDaO50qxInwjiPcUpqI7gkMddLSOsTNzbe1y+Hs7DAhEoSeF5tFxjCD0Or+Xkb8zPvjB7PiEEMbiC9+OcPYLx7QHXUp1dGtVo/UQxILlh9KtImYhniIDO5vt9j8+WWLPDwzZA/PzMQneY6rGDNkdCfELeJ2bSR7gdjxDVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Dr8id1fb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=N5D4CIiq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Dr8id1fb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="N5D4CIiq"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCEIwX1495445
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	d0wSBB0zdvgp8nv5/qOGe9s7Ri2Cp1uCk4+HjNdiilI=; b=Dr8id1fbqQe0mNys
	bDRxf66KIWEKPjeeJ8XwNjYo/t3irvtChuVaq0aNn/TsugRGyygYjTsdye7NCGZI
	bMaFovRNSLO9jG8rzE6+I0oYU0IbsKamMwKBWXfeb/hYK9OeXhaxJv6+EHCLi8u6
	kxSZZ314+LXRlHtAng+nbCRofqcehn78SgHJoI7FJ9qpuAReKcnJ/jUyhAi2vz+g
	qWjE1qysPOhmjWDwtO+MGkR/F2tCGQbwVabZTcTnV72qOfYcOK5EQi3xOEa1dnL/
	fuV70a/DSTdkpv91VrS2joaMOzdxdh4+QF1QIbAwobQ0nn+Uvdv0Lm+QGdpgjULq
	Lb9uLA==
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fcjnm2mjr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:46 +0000 (GMT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7e9fa2cd5c9so4547446a34.2
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 06:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783947706; x=1784552506; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d0wSBB0zdvgp8nv5/qOGe9s7Ri2Cp1uCk4+HjNdiilI=;
        b=N5D4CIiqEZGCjCcKysjayiGdQWFR91kLAgNkPCOc3LwKO5LmiumoBLWvuNhL602MLd
         LSCC/+AwUhiD7YdVTRHE947NoKuu9LK4CIf5/NvqyNknZgI+OdCTz5bT2sjLlE6tmeJJ
         aIll2QovVztJLCg8JLI73HZp8yLrCilP2+fTFTkWW4TtM6sGl9jYaG+3blDcr8bMIG9k
         EqPG0BNdZNLod8ijZmV4eRRdyJ8fYoPaJSl5zpb3VcuY+5DUK0+ziNbx51uxqqIMNcvm
         nTzvUG3nO8PXl2mP8P78g0f6uxx1rYaM3IbGyLCnrwkOBuIlx3w7rd0JNBNgO8qZrdeX
         mMlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783947706; x=1784552506;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d0wSBB0zdvgp8nv5/qOGe9s7Ri2Cp1uCk4+HjNdiilI=;
        b=kWP+nBjge7sTXT3d6ShoTQC1fYNJ9a6jKyz1zXHQzbleery1BYayoc+m3ZeLvnXR1j
         pbxUONV4pnUtWDe9aRWtAY8L2b24wNIqFgx6h9dw4xTVzhV1w6VgaFdgjaubKvCgHEDU
         WekwoI/3zzQhJN0hDo4ish0P711NFSz5ABpXVpom44yTZq4bHUi+BSY7azzQnZdQfFVl
         imaVhIsfJRN071mBLfXLKuAP7fxFBgwer/QUactDnVV7lKzbNsBIJq7v2fx7Bp4rPiP7
         dtkiGycM5SpFn320DzCPX0qsQWIPjhPHEcJYrNxpbET807zo5vESWLxIQZ9GlHVhD6Wt
         1CfA==
X-Forwarded-Encrypted: i=1; AFNElJ+PdEDjD+95CHO5Rw9cguQvzRWelnMLSpSi/ynn2JsUrWZQvudVp8LJxgaf0DplLMMl7p93GR5HWKIyb+g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYC0utm17C+Womy7RtrRNeXSW6xNqtTHwadiRwkOHTWf6v48z4
	iG7ASdqw6RdOlu9nMlbdBbIbMCoz+NCjs2/Gd2N2JohSTgEOY/a3IsTijYxImJ/+tYT+FkP93bO
	s6+Oq0I6OJ0VoN/a+A8GJ1wYSo+DOPBoPWoVwFII8v57C2Qkf3ZAnp0IP3xEpzsAOEh4=
X-Gm-Gg: AfdE7cmMvhlOs7hO5UrZekqx4PN3CYbUNyanW0vcMM+ixKze23BhSFQHnEVDvowUHnS
	Htu8CWqbhFY0z5BWWsz7lU3/kx4khSvkiNXP1RjWO3TeT2/bvS38C06WalGesOkPr2fYsNfxvWT
	sXeoEUuxlH+zriz6thPFcLilf0piYe01Y1i53hg44larDbgyGHpJuP+6uW5ClUY9agdHJF1Rve8
	/3V/5CBs504PI2ZZQxK0jqkrVGFuuLqowvcKIFob+2pyk/g+FMEDnbo9LoxmVoCOlXWZKupuJSJ
	3Kn5W0yG8I4RIytxh+6vCyTA6HkY4d139NdrxePcsQ9Ey9coTPITvWfvqeFQNMx0UR7QYdbMkLl
	DyOJ9H2PQIZEekHw0wlLSV4/SeRmpLCOAzyjxXbRb
X-Received: by 2002:a4a:ee84:0:b0:6a3:80b9:d7aa with SMTP id 006d021491bc7-6a39a6cd4d3mr5189800eaf.34.1783947703025;
        Mon, 13 Jul 2026 06:01:43 -0700 (PDT)
X-Received: by 2002:a4a:ee84:0:b0:6a3:80b9:d7aa with SMTP id 006d021491bc7-6a39a6cd4d3mr5189750eaf.34.1783947702509;
        Mon, 13 Jul 2026 06:01:42 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8881:83b8:89fa:1a2a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2d97527sm306129725e9.2.2026.07.13.06.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 06:01:40 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 13 Jul 2026 15:01:06 +0200
Subject: [PATCH v21 05/14] dmaengine: qcom: bam_dma: Add
 pipe_lock_supported flag support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-qcom-qce-cmd-descr-v21-5-bc2583e18475@oss.qualcomm.com>
References: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
In-Reply-To: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
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
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqVOGaPsc0Fa7oCOUveANJ60kMxtnneAWu+40XI
 sHiKYzzr1CJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalThmgAKCRAFnS7L/zaE
 wzQ+D/4y8gxcLmowoTwpYu6/hbyBFcOrtC7x5BDbiLFBPjw8I/IW0TFnJ+GNhGJQX0rglPvFUGk
 E7Dt1oHIW+5lFWTJc5kgUdyCRZHTLY4Li23JVCxFj/cf1a1VF6fJC9rWpod3vmr3j0+pF+OFNMn
 boxzJHPB/pcJF+YiFEb2ZKmOG8LSPKhXnjWUTSyJI+D90cfyqLC8T8hTzIaNs7GUmeivuZaEIp8
 ykxseEOkwZ5iV3LDhkInSNXDwoegrdxf8bBiJLMw2aasSx/8DZeVmulN+6EP2bQxmvwKMzIlaVV
 tbFGw8MmR6KCFFROM9Ew7a+aBNcDVklXTs4bwKjMtZuBO4fl96oTLWi685Kdpf4CTuRZMECeU9I
 RQxMk4Tn1+j7gtHSq2QkLcNUPHnSblikm/wl4n2QNgmREo/nTzIFDuiS/7qObgC8SdGmjNIpol4
 DZ6m+yx/THlh/c0RMsfBev3a6ipc0zOXf0MDkqig/XW7SwFIickz0gL2foQAgrrv6bwIZLuI7iu
 p/cwEC0JBQN5OwY6R9R5KlY+Zv2esWxK0LI6V4Q8dm5APmI0vSAaidEczpSkeNQWzhWGDAYOtUp
 CO/n+FNteqnrNMOz+WTd0A3Hvvlkffb6siLl/Zl/hbBDnMRnNBDjRDTQMjUHsXXpwbZX+eHrORQ
 hP8dkSZdbgPBmBw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: PZtP0H4BUNfyMH_2iWNXoPM62cFfdtTp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX6+6YseoMOCxw
 GoAM8kDLoucFcLylOxeYG+wiRULWkffS7y07Xaw5nn56kbDSpc/XxnfMa93moUc+irY/I2kywVT
 TySgRvlWluX5pZOU0xPaGStxTpu78E3gD+w18aIxSyLJiQJTXRJeDrQd7fIYtXQsruP7aBNCMnT
 lnnAiRlwv/L62ZjKI5vlO8VNStksOhmzMBLI7wXL9BrDNoqW1/1PcxGi9/isFWnPZj6QG2Y4fv4
 8X0pszKLIJV6fkvzNUriac0QGyoQSorrEHa+lxaShlGHzI3yil8AFlhbGsBcatnDuvlpAATL/xE
 w3bKkqPUErDmaefKIrX6adRy32zaKT9tI43t+Rik+yQxU3Rnu5oLJJr69XumR/YVQ0rVncAA2O9
 MzvYErgl4qzdszwHkxtLAQe0mxzk5Vi+qLmTk5x5gmjiHOXXUnKyokC5cbwtXgANaOFoKvGSGoi
 TWRd87awSqtOx+endrQ==
X-Proofpoint-GUID: PZtP0H4BUNfyMH_2iWNXoPM62cFfdtTp
X-Authority-Analysis: v=2.4 cv=AfmB2XXG c=1 sm=1 tr=0 ts=6a54e1ba cx=c_pps
 a=OI0sxtj7PyCX9F1bxD/puw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=ZSnkYuKn9ZpO9KHknGoA:9 a=QEXdDO2ut3YA:10
 a=Z1Yy7GAxqfX1iEi80vsk:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX/yZsfHbr8zSh
 sPhXNTGFSM4wlqVgVAvfoYb1BsjbQB5oyCPl1XNgCfslcGF9bnRBT52vmfJZv5oGLrqur7YkiR/
 72SsqvVN/Q8+tIZCaA0iDXPoQzrvuAc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 clxscore=1015 suspectscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607130135

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

