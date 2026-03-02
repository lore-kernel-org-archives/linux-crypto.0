Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9535426EC8
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467076; cv=none; b=Ah/w9foyoUzyC9EB+TSy4GThrq5uyXmSbLeuveJwPqvx0OSxRJDDDOQ5qdS+royu38Zkd8iT9f8lOTomMn5Yils2JBM6Asr/4tpsO5I3255G+Y+i0yyYmoOQdJJhmjWGcx0CG/G2VY7G2sBmfkvKG+VAjhxjWDLabIFdXl4nfqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467076; c=relaxed/simple;
	bh=aUMoNrCGDXfli/Niiqe45turoruXO4WeijyijWZBwgw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dXyDE/pVAIHJ05quM/O9d7H+O312BBO057TuePP6oQ/eEf96QKwPPKUq1ykxNbbfyNTTmAhzYUZmtAIemmmVZNAeWWyaXbJqdy2L6ImrNA3nRakEvYWjSGHVnRnk8h4f8P2f5LBYGyR2dJMqmY/40LIj32Dph0v1ypopJKr0kRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lLQlqDBd; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HzGSeRe6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lLQlqDBd";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HzGSeRe6"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622ElrXT2048888
	for <linux-crypto@vger.kernel.org>; Mon, 2 Mar 2026 15:57:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YTHMQ74pG40cf2TThEo/dQpxpxcnmIMpmWq++2akSHc=; b=lLQlqDBdv9RwvqME
	yBGs4nQ6md19yry3vx53hoMA4iTI9D8LDJOVvquidw7pWr3C2ACNmXVLaTfNATg5
	K4cb2Kep8d/g1SriXpAxFJdiCbo0mWaNY2/vtBX1GznM/B+0tg14MTiOVjSL1LJN
	pEfl8m0iJsNPcrwc59+ghfgorhlVSTz4WWokjTKdm1HkweluaexxwOjoBQw+2l+l
	b34TSYBe9e/9EedeqQd0H38q896cYJ3osgHbDBa6NhsmwFmQCZj3k5MZBAZ656ST
	cxTkGPK/fijtah67StX2Pi26fFUNUT/lVSRrVjl1q6jcd3wsE5CX8Sw2g5GLgsHt
	goyObA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cncmfrajp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 15:57:53 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8c71655aa11so5143892885a.3
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 07:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772467073; x=1773071873; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YTHMQ74pG40cf2TThEo/dQpxpxcnmIMpmWq++2akSHc=;
        b=HzGSeRe65rAc3rY5DoBboEu6v+ZrxvFNAiJ27ZY3yPwTVcZfM1LGnxqMnw5H+q9I0K
         tulZdypi8o3eENMNA+A93liZJyqW5RgCAbqNhmdHqiWi3+Xxv5/VtllmjEaTHP/9YR5O
         LQjKu2pFiEpqr8lV9pxaTiuu3HXEzbByu58ynsyydf/gj7PS7oUoQGR6RlMsJI90b9yF
         n6JwIMtECkPOwrnrCVDeSvijSR5IS3u4DsWGlRLMvWagRathbljn9IQaUOt9eVpmZzAY
         DBiXZLei5ZMo29peaNklkZ+KlqTJghTzrHF3rF5DP1NPsVzO4sNuYajbihtegBI4a03M
         0zYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772467073; x=1773071873;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YTHMQ74pG40cf2TThEo/dQpxpxcnmIMpmWq++2akSHc=;
        b=nacuEhYEizRk7fjvIF7hfI31el5AgBycwr1xpNCiW4XmMH/xAiZg1HvdQ7Wwp5axcg
         FrYmPlWRrStWlyJLKeKVLw/vjrXtW/8i3B6Rxhalw5CtED8WhN0C435lFQ/JhiYTJ0qQ
         q3ASqknr1sNJyJ13OoXcZkFvqnuDfZsQwBuebm7Vs6u9xjLoBQo2ZnFT62ekNeEHCNgv
         vHhOmEtl4BnuZElygpdKZAs2Hjd9GY8/f/xBGz0FSZtOZtnomR7/jbgkd63qTWFsJIiN
         vB+qmdtefwfWsV6/mHTHyPYPuGDeR4D6azAfQpggwAOTcQBZdR4W7HHFq9Hjgww6cPVS
         jsIg==
X-Forwarded-Encrypted: i=1; AJvYcCWuyTjxMCG1sgUpGE9Z3uGInTi4pjxo6w9vqkvkgTluiP45TR0JyK3Cq5FFosX8fe3pWo7CUju8/QQOb2U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGDZz/RCDicmQcKpfxOBO3pqKNkY4QRaZOqD0M3xSr2v7/CJy2
	PhhFWhDilbTXUJ0VaA1E+tvRkfmrDreisKxsM5TusRm7Mxz9V6pHmJWJhG/sbOC1ztLyuQVwxj9
	Dp61M1YEPi42uMH1qrau3csmVMNLsTymhvHnmaIB18u/79EJ2iRI4hwfzifH9r5c8rSo=
X-Gm-Gg: ATEYQzwufJ6VMe9wASEq+WhVTkrf3RLOjLt32JKr/0z/zlW1dykEv9nTC7J2GDDuP4S
	LA1DRwMSwkeOSX981/CtdX/Xh3IS9gYHGAtOnrwTbH6CvWFbRL98BYEhTo+ge6yLf4iZx/X00R0
	3OfrMQyIxiKesEyzIpBYC3qvL9zU32vQHPLVkVOYABrhyMVet+T3auho7ZRwi6PraA9arqtXK4f
	pH5U6YJlJm1XoN89RIcB3D2b2DnPi7gAvQpMxZesrHzYJGXOg1HLIQ/cSFBmmTeiYAl3UbhiFQj
	FuGDwsWwRmOI7s1hyC3GibaGRAqvUemJ4lKz1+qox4AfkbPZjCj8LM4flx+wia9H4ci82c7i+tf
	TPb8u4fknNP5zbTyYdZTEBuPHL3cVVC4+eUIA4GbYtZSyp9979fFn
X-Received: by 2002:a05:620a:2989:b0:8ca:ffe3:3d3b with SMTP id af79cd13be357-8cbc8d29be0mr1478734585a.0.1772467073166;
        Mon, 02 Mar 2026 07:57:53 -0800 (PST)
X-Received: by 2002:a05:620a:2989:b0:8ca:ffe3:3d3b with SMTP id af79cd13be357-8cbc8d29be0mr1478730185a.0.1772467072663;
        Mon, 02 Mar 2026 07:57:52 -0800 (PST)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:87af:7e67:1864:389d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439b41831easm11282438f8f.12.2026.03.02.07.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 07:57:52 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 02 Mar 2026 16:57:21 +0100
Subject: [PATCH RFC v11 08/12] dmaengine: constify struct
 dma_descriptor_metadata_ops
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-qcom-qce-cmd-descr-v11-8-4bf1f5db4802@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2241;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=aUMoNrCGDXfli/Niiqe45turoruXO4WeijyijWZBwgw=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBppbNrTjy/ojBhX/ZFgmg4UwznZqz412Fh06ExU
 MrjXRXycaKJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaaWzawAKCRAFnS7L/zaE
 w0UaD/4kKdICehR+EWUpEJ7Xw3Pn+Zs4aSTYcrf87riNyI4MzlhCH9lalV+/4BgyrQyWXL9jTIY
 E6LoPKCUQ+NdQNJ2vGxj+QpJpzJ6UccaNpN6ZUZK0rvts+QJ8QaXx3X6RBZmGgZOHe0cwxhBUWl
 aNraBhcjruZNqcafqUeryEjGqOqg+6rsfB0md5jISCrvM1Y3HPo3HeFT4vWipDT1qGnWh1u3rJN
 lMvE4e4OSeXuVXrB1TRCawmTN+F4B/3fWGKhTlSIvZoMPztvk3zPaBlI9x7CXKara6Ar0G9nUq5
 egR+gTGfmAmxqNojshzYdq4A/ok0vrNoZInhe4AR885iaIaBZukm1rbb+Egd8oOklSzOi1HMGv5
 OH1ZH+ZBRpeJcK71LxHRL3gLkkiwa4KnaLE45jL+8z2bRwGPN+RHc4vgkcmErEOWZFmN8X1YSQz
 uWCzc5urAtYMJXBFGkovaLpeEELBflXDQeQOpVyAQwdU6C+D0ln4C2Lftlu+zDhSw2+UuBe+WxK
 Rj4TxlDts1Enx2YFfESAsXxdfCIlJm6f7FsF0TEJAWdkm98ziV65XXVDtbT37J+NWU6OQMbGoqv
 aG4PjmKvoMvJz2sNe35Bw+OcH/MrfkY1SS0ewx3s0n6kx79xujbAi+fo01EvBPTKRt2vGywy5kM
 PO6CirSIe6kREYQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=Br+QAIX5 c=1 sm=1 tr=0 ts=69a5b381 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=XeVHrwws4l7kqE2Ex6IA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: vGHuLHkr8DN4Kl4MmS8wbOXNbfRL4CSV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEzMyBTYWx0ZWRfXzKe/tfj06UuA
 iDNbreYwS/5Taeh6AXrjpqF9DLLrCpfmfRDL49nQBXL61ozVxsC7e8UA1SKFjLG+sUIs+wtMfQ4
 +3LhI4CwsUXCafBzrJo6G3DBvw4w1O4jbGO3gjL9ycsWX78pIjJaXgwjjuK+ovqnG7OTFpUHvVA
 hsxO57Gfd2Bs9svoqT1XQRUH+1Ncynp0xUDGkDpqM+1toce2lVi56TMHHX9VHRpz3bSE9+6+daS
 lefrdL2I4v/ZUlPq34HEvx2CHSqzW1DLn0sm8zV5dsDt9tF6z2bsjlB1i1XoaAsnppKV1QgzRIv
 Y/L5fh1CNJBPCvI5rZMhsTN1W7smaVNnVAcPxNjujHhoDll82An1vM4R65abSULdFalOfHS7EZk
 g3x3/93bGwME9mXOdLFKlXZi/pkGIp3qIdu07n5hNHsq0Ge8MRsXvohUHK1V6McVOSrgTdeiLCi
 aixGcxoKaJtcimJpk/A==
X-Proofpoint-GUID: vGHuLHkr8DN4Kl4MmS8wbOXNbfRL4CSV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 clxscore=1015 bulkscore=0 spamscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603020133

There's no reason for the instances of this struct to be modifiable.
Constify the pointer in struct dma_async_tx_descriptor and all drivers
currently using it.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/ti/k3-udma.c        | 2 +-
 drivers/dma/xilinx/xilinx_dma.c | 2 +-
 include/linux/dmaengine.h       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index c964ebfcf3b68d86e4bbc9b62bad2212f0ce3ee9..8a2f235b669aaf084a6f7b3e6b23d06b04768608 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -3408,7 +3408,7 @@ static int udma_set_metadata_len(struct dma_async_tx_descriptor *desc,
 	return 0;
 }
 
-static struct dma_descriptor_metadata_ops metadata_ops = {
+static const struct dma_descriptor_metadata_ops metadata_ops = {
 	.attach = udma_attach_metadata,
 	.get_ptr = udma_get_metadata_ptr,
 	.set_len = udma_set_metadata_len,
diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index b53292e02448fe528f1ae9ba33b4bcf408f89fd6..97b934ca54101ea699e3ab28d419bed1b45dee4a 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -653,7 +653,7 @@ static void *xilinx_dma_get_metadata_ptr(struct dma_async_tx_descriptor *tx,
 	return seg->hw.app;
 }
 
-static struct dma_descriptor_metadata_ops xilinx_dma_metadata_ops = {
+static const struct dma_descriptor_metadata_ops xilinx_dma_metadata_ops = {
 	.get_ptr = xilinx_dma_get_metadata_ptr,
 };
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 99efe2b9b4ea9844ca6161208362ef18ef111d96..92566c4c100e98f48750de21249ae3b5de06c763 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -623,7 +623,7 @@ struct dma_async_tx_descriptor {
 	void *callback_param;
 	struct dmaengine_unmap_data *unmap;
 	enum dma_desc_metadata_mode desc_metadata_mode;
-	struct dma_descriptor_metadata_ops *metadata_ops;
+	const struct dma_descriptor_metadata_ops *metadata_ops;
 #ifdef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;

-- 
2.47.3

