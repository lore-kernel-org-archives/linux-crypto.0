Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BB2414DE5
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947736; cv=none; b=GArLIRIdbGcpWSRnrFyABATNyQjH0G44WXMplty2LTcobVn394tY11UEhspRmIXzdD+jQXdX5izmCMRTXeWvunlWSkWg/tXNPRmj1URE8Du6V/cJkkJ2qsekFuvXU+3pICaga/ELbvdZrJ/F0gmFKUbPLPxtOplpUjA5S11v/4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947736; c=relaxed/simple;
	bh=xewtmBe7Tjse/Oov1uLM7I+VZpNX0SB8ljw+4HhCUeA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cwHwQCrNafjjm9ojuRn/JVNqUl3Qv6PQGfPH/HvKER7VmtLuQeaCRyt4yxO3R6plObhpQcHoXH2j5k9ZrS7uKG3D3Um2/FvqwbEFpvHd01Jf02wuXNW6gU7EZp0kF1xgHccfsjR6AFBn9QSDZRntYZf+tly5xYmTlpdzx9wwoD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NMRute2v; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=E/o7DbTO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NMRute2v";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="E/o7DbTO"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCERdu1333742
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:02:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MsWDKH/w5P6MtO/VNux/FoMTI22L7P5oBEgCNW8qbYk=; b=NMRute2vZku5bVXS
	QiIvvm9xeyBMm/mv+rlCvBNNpOJnef8oU//tA05q5vNoSvGUNyDoVoWq3zayf/CK
	3ETL9z0O6xPQigL1KSvDFL3eSHcGikuV7BYFggUtg/EmVIGsWmQEM1OXkcRF1ume
	GpWWL8fwdDsPbMhEZnhzXqzC5nPGTuYXO1/EOAH9GMxVqowSnwiui4BIRbwz1BHS
	eUnRZKYWDBKPV1vnR2qjg5RhJ8PQ+GSenAxYMvpON1z09vPt1KwjpTdyI9WaDtVd
	qtAQw3oO8PlvylR0t8935vWJNIEuJQTyCo+9fiU0dv23l5ONSnApGHKyVVKEGR9B
	lvu26Q==
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fctc8hkk6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:02:13 +0000 (GMT)
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6a3856a293fso4789167eaf.3
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 06:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783947733; x=1784552533; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MsWDKH/w5P6MtO/VNux/FoMTI22L7P5oBEgCNW8qbYk=;
        b=E/o7DbTOOVfBovhcypRhgR++kaTjc7AVZU7VE1aIv1SnZ92fx3qwTygIT58GJpjUmq
         EWM1qInGYG7MVvLTB4NalOghhcWFqZL26hAhJscOu3htqViGaWRpQAX8xLwHZWUi2fp3
         hmbVuP4/XdXwc/EXx8kyMueGvB95H0LQnCxlWqUUklnuoiLYzVS+oj+HhsJkArtX82kb
         /YVT2nhgw3imCSKG7PXHT+ASBx5TDiwSfR17XuHyRCVCtrR2BYFZgQbuxfYx1QYHAJi/
         12wZfG4moPRuSOxiM+0KfSxedd4Am40iqxFFRVqM05VJ4N/UZd0prggyvcH3D7ww5GqL
         xitw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783947733; x=1784552533;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MsWDKH/w5P6MtO/VNux/FoMTI22L7P5oBEgCNW8qbYk=;
        b=SOnmzE5mrZFVIY3oQHqbTSUhPe4kkVetxqqEPVkV+e36MzV9gkiGPTsSX1Eo0U8ebi
         /cYA2uj6LoQC1N5QIWIvwTYp8FKh3P+NBGAVUKyR8BlVEHRscYSWHPBeB3R2lNg7/g3F
         Ixn6eHcTmBaTfH9d8QhEizPUC31Zhlx0LZTrPAUSM6xxjaKgxM4RjlXhASpATSa5koNf
         NMYCfsGEnsKNKpApfFQf33G2fSrAC4LoFXsOnDqrlh32MmuzoQ3UTIlVztwEZX4Wdv58
         M+TmW2l45uBwZFEKObRtQ3NAHwTryNJk/N89iGeHRwF9Zt3SkQp8NjpbzeqfDHt9R0et
         jGSw==
X-Forwarded-Encrypted: i=1; AFNElJ/XZSqzuHOoZly1lqaIaB9Qod1ltjYDb7uHZlYtOzNn01E0mnyad6uHy8rII52BqCy02Q97GRYKXgPxGRQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2Uv90+O5LvqaihvRnCDEGC3s/oUICSlxU0m1IWv6Aaaa63zAh
	4b+CvVlQYvCI1dGpEPdd3BNGHFkyNKy0a6EiOWD25TUKzeSowN2/RgAJRPRMAt6grRidIvAKDBD
	vusMWbueCzI4kSOszEdK84lkZz/GvRhhzD7uNhLxwgo0PuYphezrdnlk1LVreJUwLnZGokHBVUD
	Q=
X-Gm-Gg: AfdE7clRpa6Rssst6ChYlHCeTtBE0GipX7XhexsU2usoOdtmKY3WIbnLiv2ykgYp7Fj
	LuA0iQiNOoCY+d48hKpZ+SvdcTNgyOnBHMYE/6xlCkn1akIMYpcogpCdcukeRFGpfEN6HcCuozE
	BREeIiqwiblEQxE9Ubu5kQlwtme36NTyhfCtFn4zDrJuOzupY/N+QBDO23KiGko+XlQGR7XqLin
	/b3lmDaNRePyh9+9tjCipkTI21PnqgTB7rEE5NoLgn+5x7IePcmMiOg32xpqpCXwTJfLxgWcSaB
	smodiaJfr7MxTEp1cLBXck8CiB0+qChM9G6UNNWrMuptS0MbMGCTzh5DgXr6g+y+p3EseiaFoZS
	Q1ZAF37vuVzC4j/9WuBqTdjzD1iTnfpmMWQN92sV3
X-Received: by 2002:a05:6820:200d:b0:6a3:94bc:bdcf with SMTP id 006d021491bc7-6a39a72fb8amr5196997eaf.57.1783947732964;
        Mon, 13 Jul 2026 06:02:12 -0700 (PDT)
X-Received: by 2002:a05:6820:200d:b0:6a3:94bc:bdcf with SMTP id 006d021491bc7-6a39a72fb8amr5196960eaf.57.1783947732495;
        Mon, 13 Jul 2026 06:02:12 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8881:83b8:89fa:1a2a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2d97527sm306129725e9.2.2026.07.13.06.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 06:02:10 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 13 Jul 2026 15:01:15 +0200
Subject: [PATCH v21 14/14] crypto: qce - Communicate the base physical
 address to the dmaengine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-qcom-qce-cmd-descr-v21-14-bc2583e18475@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1859;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=xewtmBe7Tjse/Oov1uLM7I+VZpNX0SB8ljw+4HhCUeA=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqVOGhfrH2NKXSF17KSmqZSYmJCy4/yZakaynWt
 vvKhTmcPlCJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalThoQAKCRAFnS7L/zaE
 w4OvEAC6nTAxezYrhc+HKbKJEUbU9SmhCNsd6nEk+cW/LBcJ4dP7CB7TvqbWxccqG/JN/L7HKcZ
 BSIWDFlfruG4HGl4gtYo0dE7OeePRr1k+klnQp4lQkg8aPtlC93WmZOAR0xYFfRgKsEJ9VJkjW8
 tNP7UB6Y4uls2OHbjBWziBzTIqB/ooWP1jYM3oS2scHsjnHbx1p00LOdVUta7jH51XAUeKKamfq
 KYeB+s7GkLJ5cVFjlocnjkOuvcalhZbZhfBugjGCzJQ+g+bH7HwAOwqonKJLYtXo5780qe0fed6
 68A2iXZTVurWhhxp+JS1OOZxO+NahMqrzCR2mrLsHwt26rR3qnTfgoak1ZBHtiuy2uKxuOHXj4i
 cgA4nlJxxHJ96b+RLkQ1zKiZoOuN4gXp2Bj3tbkl9+x4Z+BgV1tv+8aJwaJ4OXErmZ/MdemXkAN
 UqTvYK3VKHsq+8I0AN3t6vm0b/+a78X6IpxTSP0B+GLupECFXVO57OeHO9tRI5BC/S2C/+5Tq9+
 O2KGMVfcN1RUAKPYXu4ndc+2tfbpGkk7wqWVf4vUqXP5iqWLIsj3fldX8ZbErizdigVTaTqILbB
 SpZEtBHelPypXOfqmyKM8eQec40XcEesHJlo+o8wYxXoU+WO6deS3cwQKOV649qF+vIVVx9QtTZ
 zhP7w75muXabpzw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: U0U8LDuKkkM5NGRn6-PAgQX-iikkckQ9
X-Proofpoint-ORIG-GUID: U0U8LDuKkkM5NGRn6-PAgQX-iikkckQ9
X-Authority-Analysis: v=2.4 cv=UtRT8ewB c=1 sm=1 tr=0 ts=6a54e1d5 cx=c_pps
 a=V4L7fE8DliODT/OoDI2WOg==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=TFgmKHP77OfOvYwKDSoA:9 a=QEXdDO2ut3YA:10
 a=WZGXeFmKUf7gPmL3hEjn:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX/Y5KPpRDR6Cc
 CrdQHvh+qa/qL9lDrDDjLeJNDkagwHJDBf/0spNKNGcrzHgiQzI+a4Rl9j/Ev2kntSFaKA9dvnU
 ION977ofEuJmeFMGyYbMbOM1uh1w64c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX+K+es9HxFv89
 X7lXik+FlP6XHi80i4ECyh30KKYvk7yBgLddbs6W3rRNHYdyYRR/HFDzPSGlnpR/7r3JymI3pPu
 HUE8EROAiWPbqrU4wSaWjQZ60XXm7o09S1t8Z7LoUyv9gfItmVktYiGaVB68B0siukeoBjV6v9Q
 Zosm4XzYrH/gWFWmAHKqgne3wG39pClUylCz4x/xgYJ/YHD+poTawkWq/jX8UuwMDZdnc6VD5Kk
 UYbIDcls0wqeovFifoIW3ydzUZ2ycoS/aZKo2vTJN97Q1fSyBHY7+v6u9gbFcSFkTRnxzLppe4B
 Cz36bGYh6chuEE8D+fsOM1QmJPXIZFLdefIzjXKec2BMMznk1Zc7WFFJHiMGNzC4SRoJTa7/kh3
 g5ff1YGWVM+4dSpR9Ub/T1lWeIuu8cA1XICKHqLPobKjZw6DAYEMSzIS4sfqQiJ4ASFQQiomIye
 p/p98fQxp41SFzPfulw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130135

In order to communicate to the BAM DMA engine which address should be
used as a scratchpad for dummy writes related to BAM pipe locking,
fill out and attach the provided metadata struct to the descriptor.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/dma.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 1b43c56503334154be4b8000e5a9330b2005cb64..6410f8dc5bcf517223c768a3e8f87af245076c84 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -11,6 +11,7 @@
 
 #include "core.h"
 #include "dma.h"
+#include "regs-v5.h"
 
 #define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
 #define QCE_BAM_CMD_SGL_SIZE		128
@@ -41,6 +42,10 @@ void qce_clear_bam_transaction(struct qce_device *qce)
 
 int qce_submit_cmd_desc(struct qce_device *qce)
 {
+	struct bam_desc_metadata meta = {
+		.scratchpad_addr = qce->base_phys + REG_VERSION,
+		.direction = DMA_MEM_TO_DEV,
+	};
 	struct qce_desc_info *qce_desc = qce->dma.bam_txn->desc;
 	struct qce_bam_transaction *bam_txn = qce->dma.bam_txn;
 	struct dma_async_tx_descriptor *dma_desc;
@@ -60,15 +65,21 @@ int qce_submit_cmd_desc(struct qce_device *qce)
 		goto err_unmap_sg;
 	}
 
+	ret = dmaengine_desc_attach_metadata(dma_desc, &meta, sizeof(meta));
+	if (ret)
+		goto err_free_desc;
+
 	qce_desc->dma_desc = dma_desc;
 	cookie = dmaengine_submit(qce_desc->dma_desc);
 
 	ret = dma_submit_error(cookie);
 	if (ret)
-		goto err_unmap_sg;
+		goto err_free_desc;
 
 	return 0;
 
+err_free_desc:
+	dmaengine_desc_free(dma_desc);
 err_unmap_sg:
 	dma_unmap_sg(qce->dev, bam_txn->wr_sgl, bam_txn->wr_sgl_cnt, DMA_TO_DEVICE);
 	return ret;

-- 
2.47.3

