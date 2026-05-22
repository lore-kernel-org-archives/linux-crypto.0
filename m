Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD5744D022
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779457242; cv=none; b=jfZiCTYDWoQUzgs70Xe1mI6WvT8cHThSlUn2Rr0W1uRYLslFriG0QaIJ61pOZ3b06yzjLY7ZTd+LFAA+BVAwbJfRqlVI9Mo/MeQNMk52ZMZSV78OijHEtfauLsiK4oesNHH5898v4omlApauo25s/mgAtIkYCeysaXluAEV+hZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779457242; c=relaxed/simple;
	bh=51qllpaj+ejQVsDQ4eqpW9Xup6eGEgdlD/8rDBDvfEM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dPFClP6L926lM+8+SvBqfshihox6p78HSOXJDNXCv4iQqjUx6Iz4m4UwLDUKObC7+8TTTuTmju25LVi38X+WZfKGtVGrMWrvmYNnD2L474TV6YxRzpy9b4Brbd7D5ehFDhyEx73LfrK6t5Fur/ZFvKSOxkVKdrFIgA/S+G4cWBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iCK2lo5U; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fDmjaUIO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iCK2lo5U";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fDmjaUIO"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64M989fc1815982
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	q6yvC1N0mVZtsuZtG+L0tsQS32fNOMK+fMHNLzdHkLY=; b=iCK2lo5Uo3mqAHZO
	VjRFrMm5+qbBrs0UkiF+o3YL6Ebf/gyIzitwZvAQYYU7XdeJiP7RHwrJi3K+Hk0D
	4KVUMlQcNHJzglET8AKstFTGWMTJavA5JSkhLin+QMKpHwCcm0VTfnvy0r/WNggI
	vqraSPu2nfcokeSERfDRWDvzmurz7uYEFL+uWa+HdaEKz5hmHKs8nJS7hS92zld/
	TkgEogR4LX6P2seaxavVSAMDU9R57BiEJkx7wVSKpcs9dcAeG2hyPTBh3fxHS8PO
	9rhV9HRtbUCsg+TU75lR4szhBaoBe5cg3RiosN9fmglZvA6X1YjNPDMrCSsDI6AI
	jODnwQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eafrm264e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:38 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50faf575af4so196979361cf.0
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 06:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779457238; x=1780062038; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q6yvC1N0mVZtsuZtG+L0tsQS32fNOMK+fMHNLzdHkLY=;
        b=fDmjaUIOKoFolidp2kJIxXWurfXrs/VU0zz0/+37DtglHMxAZRQE6gI1rkvV4/eCNx
         Ul1NMDP1zvh5iW95iJrUopMLLD5RlhPeuBhPXzepWtqRwOG8RV7qdtkN8Iwy0rivBhzT
         c0JJ/e4NevVeU7rG3iaUIj7ehQMfHN5uvnqVGiGRafmoe9HcP7DRWmycKFgl9ux1btPu
         eErFE06iRJWGnaSYXiFxuMYl1cOtFCc6XUuhpWYIvU/Djg09wtzR5RwOb7Z2GtxWi0xq
         vPzoeRwCE1VC/POS+zQwe+vlgtlyuQWSTM7UxbjZW6DXDXx7AflP1vooskYIVn60mgbG
         2B/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779457238; x=1780062038;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q6yvC1N0mVZtsuZtG+L0tsQS32fNOMK+fMHNLzdHkLY=;
        b=VJX/Ft2U6qo+PkdgLe4JQoy/kwNMVr4hXWYqHuPP8AHJr56mykfOL+mzAZUJsHJ++O
         SLGr7K7IBQCGavg6cNeIcrZZDgZRb4CWRhY4pWszvEL19CLNYDiHGOmbg9yOtiUYdSP4
         U+PkYskNQtZkPOQD8uPktJ7bUMdCaWpUmoWDkU2g/U1kFxHmG5A4JbT6km9Quq5fEETs
         ravV65JZI0CwJTphf5kjLnnTV7e9OuoWFEO0IjB7824R3h9Hbceymar+BU6ILMwzlTBS
         cFGxWThWJCb1PVDzAHp3mYIQEr2byrt+CyhiTrQ840O8eqvTSFIrijgO5WgXuKq85UIf
         Z4HA==
X-Forwarded-Encrypted: i=1; AFNElJ//pfFKhZSYBGWBBuUbKJyqcAllEBp+BEjzkUqDyn5idbkQExamR/tcd/64Dv0dEqZSi7vraQ99zawwIN0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxL1/xgFdMWLRgw9b0e7EBiTF7eLSd6G6qSfLe5OBSQFnTZ/K1Z
	ZImiXCwZIyvhFT7mfxK/K6lKo4RdUPk5+1boLQprRq7/euzvJ0WJeB8eoXtNx2UWbcoHQPaQK8O
	0+TjAKYDMQGf9PZW4PPOBPij+1PptYcLdzEmOczRq5sMkgHETWpMcLNHLrW0tXEXjsjZMMIHfG3
	w=
X-Gm-Gg: Acq92OGVzGCOVUaMRetiEJMLtjWLLiJWoNT3BlwGb5uIz8AG6JaVfs9dENgoQWxim1g
	pldBN/Zx+XX4Mg+ApHpP/3b1e6Rozz0i/rMzKoZleUUMxk0mgWtH4ufI2B7YJ1lP3Ak4tbtHMa6
	vysyrCoPS9BGdHl79EMsScvIk+n1OP0BIOoyyNb4dx6uC/5+QB8fOWIaIoQ13cKi2vobZf86ROr
	lyoVabjP0rijB7Hwnwe/24O+bvDoILFvcy9WtSRopzeOwPYlROuUvXQ2T4ggZZl26Dypb4BMD8T
	CauiIW/gKCL/YnXr3jxtV/iA8mkCfa0YaJq/8/8RcIPDkvzbOH5+8kTy+cHqG19UxUAEpP2JEYn
	HxosJNUKV6gh2SBs0dndeAXdOJJsSiGPCa8M7n2QmEFNMHo72xcJ4kUCOh+Ln
X-Received: by 2002:a05:622a:189d:b0:50e:5cea:a519 with SMTP id d75a77b69052e-516d443c718mr51205831cf.12.1779457237830;
        Fri, 22 May 2026 06:40:37 -0700 (PDT)
X-Received: by 2002:a05:622a:189d:b0:50e:5cea:a519 with SMTP id d75a77b69052e-516d443c718mr51205201cf.12.1779457237308;
        Fri, 22 May 2026 06:40:37 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:2fa:6280:a48f:fb37])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454c600esm44912825e9.3.2026.05.22.06.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 06:40:36 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 22 May 2026 15:40:02 +0200
Subject: [PATCH v18 09/14] crypto: qce - Remove unused ignore_buf
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-qcom-qce-cmd-descr-v18-9-99103926bafc@oss.qualcomm.com>
References: <20260522-qcom-qce-cmd-descr-v18-0-99103926bafc@oss.qualcomm.com>
In-Reply-To: <20260522-qcom-qce-cmd-descr-v18-0-99103926bafc@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2066;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=n0Cml8iSZ+MTejAlSL1Cpzw3FwIEirUqeMzFyFiqzq8=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqEFy73t7RClzY0R/8YYWO+mVaNF6zAcKbAxXTd
 /hKSx01csiJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahBcuwAKCRAFnS7L/zaE
 wy9LEACDslImbuzNtup9YTuGUbBN7OVti7fpeZJRpKp5U0Y/I732k4RzXG9MFik0daokMSHkKhh
 jA8/uBpQ1ntj7c0AIGuiRMcFXAuqhUPc3uy69Z601sB2qpGfUBuOkioiX16C7JJ7BFngTomc3Bd
 sLmHH5i51inclmd/MvnjOALcpYlgftfEzjcU0OKfhxEA/ygadb2n5bnUd7A+bcJ7MJ6Utl23iQn
 231ZOxR007HN4BtOIUV/ctZI2Xwl7ZL8AFzKdoKHPsIV23gcKZwFWVtrOmQRlHzgVZ2qmnwtw68
 5ftTEg5MpYChmociSl0hS4Xj1ivgkr4Sl6CmlZ3CuSHk9V/sJup+BcsnkS+o9ADfGAl/sLJ4Ovl
 d9D5vd0HQ5WpjeeNMVJ7c06FwzKxjV497x2qE3Spzf6i6enrhVAyADdmv1P71betrLbWQ18vhly
 kUDE7Zl+fxuIQxGf1ArInMCnAE/J5pwOYYkRsmnNG17NQGSyEWEMRtc+VYtYS88sUGqOBV5iXk8
 IGkkIG3u6a38/SkyPO4RLZfnSogs3mFanSvNg+xGHouz7jwljuskcEiw9/sRNHapfgHM1Igdb9h
 hKZ6Tvcsw3FeouwBa4yq79p5fdgJNuCI5L/Br66ncxgUIDxwrEq2sL3XEdisBOLsUSDhDwTeAWe
 dL4mK/25ipWnEvQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: 5YYYuEMKPmsX68p12vC_j02jTXGoTzuT
X-Authority-Analysis: v=2.4 cv=Zekt8MVA c=1 sm=1 tr=0 ts=6a105cd6 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=tWRRbWwrKX-5tUpmLDIA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEzNiBTYWx0ZWRfXyLU5DkzJG1b4
 YjKP8ZKntcU+Z7DWWeeLGUAjnQENxVdY9hidNGi1xoGgMltZ0oJUJg7ajG+HVBkMBERKFQtfg/c
 DWn/1ED4pdWyCfWhcFqiUeQZhfjmVLTimmFOKSWHUDa2FX7EEwiMtqxgjgSTwa7iAmydcv9a5Mz
 WNkZ6UwzAtmwp5GwLMUD4fKAVpI7oI1ZikKhduGZaH69ADWbaXxe17+lIsGSgJSjzTBVfyjXKpI
 IMlv0P4llTjoHYIBGGQnyJ8RoJuzy044f7QkW8avdDU6682p6OOVHNxZORUalZNNg0zwrCchQH3
 9gMQ5atqsr6Q/iJa/lAaD4aGO/WigGgiyMZ1AWJUc7ML7B0VAqjg4jq5sk5myQT03/k7uw120Ad
 g8V/H9YtW6z4pLwLCU5krWtP///Mhg9cXIziwvoq73GyAQEf2p3pZ1sACJhEeSOWUBdsU4Fn/1c
 L9poi572tf69LONK8CQ==
X-Proofpoint-GUID: 5YYYuEMKPmsX68p12vC_j02jTXGoTzuT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605220136

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

It's unclear what the purpose of this field is. It has been here since
the initial commit but without any explanation. The driver works fine
without it. We still keep allocating more space in the result buffer, we
just don't need to store its address. While at it: move the
QCE_IGNORE_BUF_SZ definition into dma.c as it's not used outside of this
compilation unit.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/dma.c | 4 ++--
 drivers/crypto/qce/dma.h | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 68cafd4741ad3d91906d39e817fc7873b028d498..08bf3e8ec12433c1a8ee17003f3487e41b7329e4 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -9,6 +9,8 @@
 
 #include "dma.h"
 
+#define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
+
 static void qce_dma_release(void *data)
 {
 	struct qce_dma_data *dma = data;
@@ -41,8 +43,6 @@ int devm_qce_dma_request(struct device *dev, struct qce_dma_data *dma)
 		goto error_nomem;
 	}
 
-	dma->ignore_buf = dma->result_buf + QCE_RESULT_BUF_SZ;
-
 	return devm_add_action_or_reset(dev, qce_dma_release, dma);
 
 error_nomem:
diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
index 31629185000e12242fa07c2cc08b95fcbd5d4b8c..fc337c435cd14917bdfb99febcf9119275afdeba 100644
--- a/drivers/crypto/qce/dma.h
+++ b/drivers/crypto/qce/dma.h
@@ -23,7 +23,6 @@ struct qce_result_dump {
 	u32 status2;
 };
 
-#define QCE_IGNORE_BUF_SZ	(2 * QCE_BAM_BURST_SIZE)
 #define QCE_RESULT_BUF_SZ	\
 		ALIGN(sizeof(struct qce_result_dump), QCE_BAM_BURST_SIZE)
 
@@ -31,7 +30,6 @@ struct qce_dma_data {
 	struct dma_chan *txchan;
 	struct dma_chan *rxchan;
 	struct qce_result_dump *result_buf;
-	void *ignore_buf;
 };
 
 int devm_qce_dma_request(struct device *dev, struct qce_dma_data *dma);

-- 
2.47.3

