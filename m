Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9A23FA5DA
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801091; cv=none; b=EIEPbguxv8GLxHlO0GdvN3zzPkS3Aw11Dwcw6WTV0fw6Pjh2zhL+Z/QJKT+qfgge0eJjYvjqthDu8ZG4Mt8TdOYpcH3dMtuIQnkHe/QdNUOmuQljDFMaLCqjqrA4GzJVuLVmWTLJYW7ncdORZ6RuWg/da9C52U6LK3p8KpTEseU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801091; c=relaxed/simple;
	bh=szNr7XYlP/RmxhFwkiXdqgSbJMTs5djSMoKrGxWxQpw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bZzE44LUGAVvPR7LtUaJ4+0vjZIavIVtrCVeUpoH/cMCDvsD7UzLvV7FBRQclQrY2K8lmlx77ToLQBaMdtfpy1/qAE9egoJuJEwME/XeAO3Kg644lawjOdpMpVrM9MfFMEuFvGTGSG8T91iadeNlEoyGHXWnBKO0WAYqmLh1jLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oUThSWJX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YxdGYCPz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oUThSWJX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YxdGYCPz"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64QCsgac1164019
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vBHLofPVeYPfx1ZGHrhJ7CLmG7Qg01nr7l3iawgtmCw=; b=oUThSWJX0k+LUVnG
	Aeh4v1t1v+5z6edxnBkd5OiNBDuYJZ4F92akANGhGklEtPs21l5JjZZB4oYVymbC
	BdyC/PW5q5sZ79TUk9x2ACWhl9MuzRE19zfP1KHvLB9cZem8/pSOeHmlNt7Kcvcs
	ME5Wb7UvS4OGF+HB9qFIlG7W90xvcZOaJFYg4ucPpN7f1EP0KQRdjhD467BB5Eh0
	gh5rIgrXjdY0eFSzpS16CST1r56k7Tk+MXwihasnMdo7qX6Xj34VJnIfKHsTf5ek
	gZFnb6kkseJySR81w+K0LSbavZo+o6SFnwa+AeF82tfPQe9jLXHAn1t4H8jtRRu4
	ZzZCDQ==
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com [209.85.222.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eckyqn4e7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:27 +0000 (GMT)
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-956804755faso9987424241.0
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 06:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779801087; x=1780405887; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vBHLofPVeYPfx1ZGHrhJ7CLmG7Qg01nr7l3iawgtmCw=;
        b=YxdGYCPzDEUcqCusXQDrYxCa6aqVge/gAQzdG/NdU+cwDUkEjy87Q5ORwDUGgREXuz
         PPa/aeJVOWQB4jCaqPkDqrRpnGLCWbNd5go8dm52D33fMwHUaDGIL7PR2RJw/uj+honq
         NHe7S03n5ocrEBTlNrcDX7SQz9xFO40/lBUmvPVCWMZVVyocVwtzweCp0PcSuB/+8xpc
         nnfI41s3pT05kr+j8OJqE4g27Y4DWNFrMrHyYoP0V45o0grsvfozaqMy44iSlsoQ3paq
         CPhP1daZjqWqpXADiF2GhysAyDb+SB0d8UY32kor9BQT0ZuQjo+T4+J0fk9meAcwULHa
         IPJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779801087; x=1780405887;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vBHLofPVeYPfx1ZGHrhJ7CLmG7Qg01nr7l3iawgtmCw=;
        b=OG8w2OY1kTbrLzqKlZz8uf512Ulzxq+TQpYdXfPooT7mI6oqVlwHkLYUdWsn5e0fhh
         p9mhmb7h1qFTXI9LzrsogvP37h422nMjMNc0tw/BmxWNN7EGAJTptqgjlnX9ovbECU4R
         JMpPoBHQ+L0Zktb4N1/L92znumSdccDPmJ+/D6BCcTSUU06EGbgbGpP/vP5hQMr5+2vk
         CLaNO2QTCkF7Dd0eiHji6wlEklfXHvrgrZWWxwp774ggS+siar7K6+bOEfFet+IdWHP3
         4ede8stZyl+BGYgd/EGOv/H3I7whewsxv6sFPDm2zkrnlBz0d/5yeIXp3e4PnOXRMv3G
         gYBQ==
X-Forwarded-Encrypted: i=1; AFNElJ8LxykKpoXwJjaIk8lnnv41LG1mtx00nz7Kcc4Lyv0mPp6BofP+DDBFDU5T5C0eQxogyRVtH+DZJANQV1g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLKWqX/NFqfXUSF7VXLpWldEwzW8gxD6G7nIFDJYERNNIv+JyA
	jIWKn8D73UznCsSw8jcMK7zi3rmtxrJ+NW8I+AZNFb3+4s9C8XVM3JWiJSGcD+zUGvVOqF+CU7q
	OTIWnRr48upDBogilb9gGGUFW0oU/ZKqsvA9flQtUIhnQahCBdrrjCLEw0o5jSGgXY3k=
X-Gm-Gg: Acq92OEYv+eIvuNGxB1wSNZu6k+tOXDVpz7eIAQR4AiW/swWvDzUSwT4+BGo5iDF2DT
	hAybQtnF/dPVEe1yehPrL72RDQDhyRKE2E5H9umzrgNOFH82wTFlJPqDuMbZSlfMOxLMMO+Xbs2
	x/WaSbbirHtVfGpfNQ/kVAw1jOVhFpmsRFN3DhqALHpMUcmtNmf9rtp9CyfMCTB39QfgcgK10W/
	yZCcnMwgzxYCPp+xBXFgh4GbZ3CmfmVT1Cfl9jZ01oixvJXXANg57cOiurdb8J7QpAaWBl4X3vc
	3HOYOsYM/aP6MeZB7JLVfaFEFpfnGuDJGhZyaiVqdz2R8WtPKvpHENi+NsQAgp3wLXwtoxiT2a7
	PnW6miYc6Liy0zGZkPU/Zh3daj9Ogv23Cl8QOGXMP1zjjnixdtCs=
X-Received: by 2002:a05:6102:6447:b0:631:d445:171f with SMTP id ada2fe7eead31-67c92ecb981mr7786988137.15.1779801087361;
        Tue, 26 May 2026 06:11:27 -0700 (PDT)
X-Received: by 2002:a05:6102:6447:b0:631:d445:171f with SMTP id ada2fe7eead31-67c92ecb981mr7786956137.15.1779801086891;
        Tue, 26 May 2026 06:11:26 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:15ba:1d70:65ea:9578])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5e484sm34259426f8f.30.2026.05.26.06.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 06:11:26 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 26 May 2026 15:10:52 +0200
Subject: [PATCH v19 04/14] dmaengine: qcom: bam_dma: Extend the driver's
 device match data
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-qcom-qce-cmd-descr-v19-4-08472fdcbf4a@oss.qualcomm.com>
References: <20260526-qcom-qce-cmd-descr-v19-0-08472fdcbf4a@oss.qualcomm.com>
In-Reply-To: <20260526-qcom-qce-cmd-descr-v19-0-08472fdcbf4a@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3778;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=uxRjFVxEhrXgn9P1PbRyStGi6yK9KFcQvfp9JiG64Wo=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqFZvrKUL9qIkIN19qHPEpzuE2u/9bNVcl14aWN
 QqSrjVTl+aJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahWb6wAKCRAFnS7L/zaE
 w1dFD/0cVIC3rGapO0PKyqz7apZd6ma5SpNf5q9iP4D70P+gdIIaivnFTjRV5khLy62rL8tKtiD
 X6NA6JDfEdj7cW4AlYdEvmaVdtCs9onD6Ug6szzgaUyAEB/BkAEIaPgPBx/jgNR0dVSDlV1AQ6Q
 SuDIaG3gdJvzEavdwzuKmGJ7U5e1F0RhGPLVsrPrJfGH2WqQ7KvrXIkuzylTvmC8luChR6vsneZ
 RQVwNPOCJJfoDkz35045GwPpd1NTIofdUImh5xGo/eTc7/5LvMApBCEpUDAPuojV2ghp+H3pVpO
 wEIhCPb6SucKoX+0TizqrOnRE/QdIKTdIQ8mP+KqhG64dCXm06jXch1h31lSBkgV9nTnR6qUYOR
 ckgplFhHkXnZFSsDCIi9scdtHZxQa6zQUMKtPMRQSGx9Jw8xJVE2bhJHLzw7HyJKL/aJICPdy1s
 icQMOFwDWGlfP5TSappPtJpouBTbUIIpJSKIgLGuY3pZaxLsRLZv2vnaBqwv0DVqJbR+50lyk0Y
 1RexXxlbo2Uzz21FflwZKCLfQHG7mOvuDYQyzGqDjQOHRjMgvnBAU1R0Te4JyUoHHbtu71fBYRf
 hQ6uiX33ToVBjIr8MOf/OmpSLcpxcQwFUixfMf1Na7lwH6iPLcno4kd6IA6w5J4n2NzOijXI5LT
 bKeFTl3PBHQGIEw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=RMyD2Yi+ c=1 sm=1 tr=0 ts=6a159c00 cx=c_pps
 a=ULNsgckmlI/WJG3HAyAuOQ==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=Fb6uNmSZeVr-t7npd3wA:9 a=QEXdDO2ut3YA:10
 a=1WsBpfsz9X-RYQiigVTh:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: WcGF0uf0A58rQ7ZX4oBUh9--0kYhk_U5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDExNCBTYWx0ZWRfX7w8TGydVoDCs
 dHYqopG1j37FzLqyGBOrIIqADAI+xZGNFN38mSOe2WIzo+pJFPhngPuPvBv32R3F9+ULEQaUzmU
 pS8e0IsjJBmbFW22MvhmLsxDO/AHR7qxqERSPg6/3g8rbEFhaN5KqlmNjN50Cfr18O5NH38siXA
 M2ZU9dWm768vkCKZSvhAB4atWpUOM0PzDi677TFeByxIV4eAjRBgF76OV7iO4MZ9iJj0HBsbKtU
 8X79H9YfP+uYzrcexDCu5Bw9IRsPfchP5UWkuefnU3CXJ1yjzt2iiU+mCb/kBko6+mN7UhHNGEH
 OfXHhIOW4fxlEztbydM4lD1osHXGbR+UvPWfBJZuc1X/BxU7QpULMFXlEZMq2AmoTqFOJamMRcq
 sQlUq0l0WH2ex4x4fwVVX5ergZN7y5H6Ti8fBbtnXv/iYKTxw3Xzf8NcUlHlo37VCC6md7VTD8j
 H52TUKbdGdVQnr4b38A==
X-Proofpoint-GUID: WcGF0uf0A58rQ7ZX4oBUh9--0kYhk_U5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-26_03,2026-05-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 malwarescore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260114

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
 drivers/dma/qcom/bam_dma.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 1c62f845ac0b956e311857b93f5b504086662f45..2129ff5261571581a2c086c13dd657dc63e16f90 100644
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
 /* BAM CTRL */
 #define BAM_SW_RST			BIT(0)
 #define BAM_EN				BIT(1)
@@ -393,7 +409,7 @@ struct bam_device {
 	bool powered_remotely;
 	u32 active_channels;
 
-	const struct reg_offset_data *layout;
+	const struct bam_device_data *dev_data;
 
 	struct clk *bamclk;
 	int irq;
@@ -411,7 +427,7 @@ struct bam_device {
 static inline void __iomem *bam_addr(struct bam_device *bdev, u32 pipe,
 		enum bam_reg reg)
 {
-	const struct reg_offset_data r = bdev->layout[reg];
+	const struct reg_offset_data r = bdev->dev_data->reg_info[reg];
 
 	return bdev->regs + r.base_offset +
 		r.pipe_mult * pipe +
@@ -1205,9 +1221,9 @@ static void bam_channel_init(struct bam_device *bdev, struct bam_chan *bchan,
 }
 
 static const struct of_device_id bam_of_match[] = {
-	{ .compatible = "qcom,bam-v1.3.0", .data = &bam_v1_3_reg_info },
-	{ .compatible = "qcom,bam-v1.4.0", .data = &bam_v1_4_reg_info },
-	{ .compatible = "qcom,bam-v1.7.0", .data = &bam_v1_7_reg_info },
+	{ .compatible = "qcom,bam-v1.3.0", .data = &bam_v1_3_data },
+	{ .compatible = "qcom,bam-v1.4.0", .data = &bam_v1_4_data },
+	{ .compatible = "qcom,bam-v1.7.0", .data = &bam_v1_7_data },
 	{}
 };
 
@@ -1231,7 +1247,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	bdev->layout = match->data;
+	bdev->dev_data = match->data;
 
 	bdev->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(bdev->regs))

-- 
2.47.3

