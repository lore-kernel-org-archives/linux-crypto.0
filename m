Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794406648;
	b=jXjT3iPz4jXZdN8a0B84R34rUkgupv3CjWDjFeH9/iRJYlxVcZoFKZem2RB+UBnq//uH
	 geDSMts5IR2iRKM032iG7kQbNfUVrNaO0UsYrSMtuJxVFFqCPAi6YRL3Bd1/Ij+xzcRs6
	 30k7lqBsbtf6vwuW95VG1/RMaDmGb50QvkS7nnwTCLwNbS2nUNHo93RgL5RjGKZWapED/
	 GaCc+8hAqhusCZGB/ZGe6gVkXRVkr4PkptHM7VvmxwrLEt3NGTj0IyrFWt6C+U9YHIm7k
	 RJKDOpLct8vxNTMdAjIAr+DP9qZQC5gW3itXT9S3zqhUj4XDdiCAKLm9/3lld6MSMBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794406648;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=INKPgv0UQ5g64jW730Hr9K6Juzy/BAoRk4OPlmTA1sk=;
	b=0I+QA+gg3rcwaJVp/3rfcIWUFnpdppgKHB/d3qV25l88uffQVMbDDmPA0zeu/4maiKCF
	 j7eNAYWY01oWq+BXaPmR4f5AOyv3bfiyKs5K//mVFFEoXwPManlJvwtvVnz6I+dm4jkhS
	 OZj9rBSFpN0r1rS4sTUu6GDoZ/memjTAzwEidg/gOm5y4b88GQ1C8cPeT4u3PPHijFHg3
	 gJYABTjwWtLJHQR9ZddeuPIa59TPUnSagRxzQzh4pDFQPcahbeCKtdTZEaU8/srKX/JVJ
	 ufyUSlZewcRYPI3kaoi+9JpNDt/lG8KUKz0WiYWORqBOfyUConp9zXsBDz1YtqlMgIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=GWduKCsF;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=CIoz7MEN;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D1C606A324
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54D1C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=GWduKCsF;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=CIoz7MEN
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABCZ54x2001552
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	INKPgv0UQ5g64jW730Hr9K6Juzy/BAoRk4OPlmTA1sk=; b=GWduKCsF+T8AYjIq
	+ltI7zxzLSIy1boE5Ho4aIbuyURdrhLoSBAPMsJxitStXqT4zMVADe5aolBalsR9
	CI2bYJvkk3o8sRPNTDo1Qyra2XH6OPFpYNE97i/4i6ALw0BPfzSYHidfSq6G4a/i
	k9UfnHDBDwIBwV0dzaDR5BRHCGLf0AwHu8Y6f9rX1JStDlpVol7cnx8JjmHc1mnZ
	3aKLngKU1f/PCzsmsnOOo02XLQsaMh1lFRET9DNXgEQM4SqQI+5Z0fhq97T8Fsq5
	mgqhguqEahVS4pK8OHa9ow8XbzLIAjSMsr+Dd8cRfyAJy91aJ9acUr+xMo3IeV/b
	q1nr4A==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvdrh30k5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:27 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1a5005fd0f8so15972c88.0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 06:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794406646; x=1795011446; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=INKPgv0UQ5g64jW730Hr9K6Juzy/BAoRk4OPlmTA1sk=;
        b=CIoz7MENylzrsLGZifHLlVdEeYNg7W7gaS6Xr4tW934bvl1aggvgVUgCqKdw5U9xv8
         N8KPrCHa0RqXzSeKS65aAaulRv837oXb+GkjeYVk0awa+qKq5bP0L6jMJ2x4sFS1DgoA
         zFlmxyUod+1UObEiM45GKYolyIscdMxUQ060DiC8a/03mcrHDK2JW+BPe8V650yxcdxy
         0+AzuSQ57HDmySpeRFHvekaGWWgrnDXiW/Lx9eSgwzeAZajHrVvRIydDLGYNDFOQlyyk
         3fSX61D0lnA/ahIvT0i3veq4zl+fjmO2sreVTrC/GLkDlm3TMzHjL98B3z8nkxgDPQLd
         oyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794406646; x=1795011446;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=INKPgv0UQ5g64jW730Hr9K6Juzy/BAoRk4OPlmTA1sk=;
        b=RyykLnEoeJNvefxEBxz41HDh8PgiJQY1qd1oe5T4clQq4Uvepd6to8MirDTlj6dWFU
         mLT9ldgTpp9g0uuB66MoUKhl0AVuBSWQAOitP9vTOHdxaY48kInDSwVgy7PSlQ2LMjIX
         MoFOJJ2PznQn8ZxJaN8dw5cgVuBxO7lp7z+d2f+gtJFAO2H6VQViTDL5t4Sf+/xLTuco
         L0Hmp2tB8WdhLASe575W1lrKxy6K2jKW+q8bo7nV/Ek1HzgnV5NK2Umm5Ln7SSKXS93q
         iOtzzHDEhqdsYfbl8z8FPMQTbygScNzvtdYrTTQLIpBZvpzN3Q9g4CN3ParqjOiERcrG
         wiAA==
X-Forwarded-Encrypted: i=1; AL+hErFlURlHkBinckq2yy+dgDv0Uqj3azOyWpKB6tC0AotbdAP96EXBoxfDjgpRaVkAw5FvMiXsKIFrIjaz61w=@vger.kernel.org
X-Gm-Message-State: APuU4Z+30FUuh055EwlFF6kOu1hxget5I4yBN73dRDbOkM4R0SBvNNs/
	gAnQD0lmNIetBeXDgAtVGTnXFtsO3+hUhvaa9AFq6ib1+N5s5i+XoFHqF3BFEKOxIhNucnUMAdK
	MIL+M4DvFZkw3Mo7yvedqga8pPpjLMCgWqhh0Kv8J4WIXAdX20OP3jBpHkTK6ZEX09ss=
X-Gm-Gg: AYBFou089K7ywOUD51zSIEN/9sonaO1j6ts3oFS3/d4hagE4Dm821q7qv5QkYzcBbrj
	XOGulkc22mBdLCzD7JXBm6fNkMubp/l5Evlyj9lPSE9x9NoXhQQmZz641iFoG8DkkgF3bfS4Ki/
	LhItfkMhOE3D7M7uVBohzUBTSGfgxg2MHcs29d+ObAzdNVJJ3iFiG4qXag1FtjlM6Uz53MRMBYU
	SJWRAMiIroqBw3o4OaRWRMBOpxImt7iDcgZJuA5NFrpRkm/kVMWGAN9uS3Qsg+mZNKOKKpqnLIo
	4PXcXpXzIc69gA4+I+xcMo45JrHq0fV62I62zX9lqOtiJDAuW9rPElDrG6G/mVqlD1kIMjBRmCW
	FKEDk27KqychUEfa2SH5XoGyB9wEQGpMdHN8BalDSv7XU/2pyWbIFksU6EV+N7PjjQ5JbchtBfw
	==
X-Received: by 2002:a05:701b:2504:b0:15a:9834:73f2 with SMTP id a92af1059eb24-1b3c0346852mr2286690c88.38.1794406646050;
        Wed, 11 Nov 2026 06:17:26 -0800 (PST)
X-Received: by 2002:a05:701b:2504:b0:15a:9834:73f2 with SMTP id a92af1059eb24-1b3c0346852mr2286654c88.38.1794406645260;
        Wed, 11 Nov 2026 06:17:25 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2fc09sm33747063c88.10.2026.11.11.06.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 06:17:23 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Wed, 11 Nov 2026 19:47:01 +0530
Subject: [PATCH v2 1/6] soc: qcom: ice: Add TZ agnostic re-direction
 functions
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
Message-Id: <20261111-ice-migrate-tee-svc-v2-1-29d19f6c92ab@oss.qualcomm.com>
References: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
In-Reply-To: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
To: Eric Biggers <ebiggers@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>
Cc: Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794406634; l=6890;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=U/F0N1m9z5s/jWcGR7AWZ8785xtrM8Lnbkax3sg42pQ=;
 b=tW/Kc5xDLUAuqgwhCTnoqqxnDJFCQuDBZ375Onj8DJKqzjyatjnlWdaKWJGxbE6Ohf9hAnBEL
 n0iJLzEu/K+CkEAhMol4pLs8RSIuss+rXYq/DN6FKowyF1C6s8iwl5l
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA1NiBTYWx0ZWRfX8I9J0XFZKsDH
 MmbUuZFbn6dt4Ii1PEizlRSEc4rsyI72BSoACOVPWZ8PpBcwTBB79ulj9cGrcmJTcc715/dG7EM
 iD+pWdkBbzz4IcawhiJEXobo/IIdd4o=
X-Authority-Analysis: v=2.4 cv=PoQG/AM3 c=1 sm=1 tr=0 ts=6af478f7 cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=0IJvIL8Rtrd2xGF69cYA:9 a=QEXdDO2ut3YA:10
 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-GUID: NSFGz3KQzUthU5G0vYQj_mnuMvIIxyoA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA1NiBTYWx0ZWRfXyRBRDXu3JTDI
 tcW6z0gsxE4QmP/iJEjuniba80L1jlwqab8GKNcOXkyYerb4/nyXBbejvBIPpA+y7nUbBKhGrEX
 NKgdoPQbC/3L4ierhsSHdlk4iyPdn2P/OpVD67W2cVgbCXfduF/MnC7t3LZX+5NvmbdTLQOM55a
 45sV/XzTYAEh/gFVTHZjd0eGvv560VqoIHQviAbMEPC/gUcow+r2TycjF988v0RyTx5FXqh01ko
 aiiRXUh4oqqKwC9hTH1XAgV31a0ujtxdDPLJYpf+ymuqsSvrObe5RiML1N4k0CmVFI++sWaoGAS
 Tr3n7k/yzlrFYZr0glXY9bfe7W1CoKPVijeKVnshNqpGLJLoXX4UIhEh8+U3RY9ZjBPt/Drh46a
 UJC8sM7a6gEnL1ZgCS9WXLPuARrM0fBsUK3zgL9d5Hf2g3fpwTJkzTCLOyil+WGbzFf2FApym4n
 GCqrYQktvjN8ax9cmXg==
X-Proofpoint-ORIG-GUID: NSFGz3KQzUthU5G0vYQj_mnuMvIIxyoA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_02,2026-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110056

Qualcomm platforms such as the IQ-9075 EVK now boot with both QTEE and
OPTEE. However, the Qualcomm Inline Crypto Engine (ICE) driver currently
only makes SCM calls into QTEE. With the arrival of ICE support on OPTEE
for Qualcomm platforms the ICE driver should call into the correct Trust
Zone (TZ) at runtime to request programming of the secure interfaces on
the hardware block.

Add TZ agnostic re-direction functions for all the current QTEE SCM calls
which can route the calls to either an SCM or TEE bus-based secure back
end when registered with ICE.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 124 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/soc/qcom/ice.h |  56 ++++++++++++++++++++++
 2 files changed, 180 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index e256595b9826..452896b1858f 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -118,6 +118,130 @@ struct qcom_ice {
 static DEFINE_XARRAY(ice_handles);
 static DEFINE_MUTEX(ice_mutex);
 
+static struct qcom_ice_tz_ops *ice_tz_ops;
+
+static bool qcom_ice_tz_ops_registered(void)
+{
+	/*
+	 * The barrier is intended to synchronize the data stores for the
+	 * ice_tz_ops data structure when client drivers (UFS/SDHC) are in
+	 * parallel checking for ICE service availability.
+	 */
+	return !!smp_load_acquire(&ice_tz_ops);
+}
+
+static bool qcom_ice_tz_is_available(void)
+{
+	return qcom_scm_is_available();
+}
+
+static int qcom_ice_tz_invalidate_key(u32 index)
+{
+	struct qcom_ice_tz_ops *ops;
+
+	ops = ice_tz_ops;
+	if (!ops)
+		return -ENODEV;
+
+	return ops->ice_invalidate_key(ops->dev, index);
+}
+
+static int qcom_ice_tz_set_key(u32 index, const u8 *key, u32 key_size,
+			       enum qcom_ice_cipher cipher,
+			       u32 data_unit_size)
+{
+	struct qcom_ice_tz_ops *ops;
+
+	ops = ice_tz_ops;
+	if (!ops)
+		return -ENODEV;
+
+	return ops->ice_set_key(ops->dev, index, key, key_size, cipher,
+				data_unit_size);
+}
+
+static bool qcom_ice_tz_has_wrapped_key_support(void)
+{
+	struct qcom_ice_tz_ops *ops;
+
+	ops = ice_tz_ops;
+	if (!ops)
+		return -ENODEV;
+
+	return ops->ice_has_wrapped_key_support(ops->dev);
+}
+
+static int qcom_ice_tz_derive_sw_secret(const u8 *eph_key,
+					size_t eph_key_size, u8 *sw_secret,
+					size_t sw_secret_size)
+{
+	struct qcom_ice_tz_ops *ops;
+
+	ops = ice_tz_ops;
+	if (!ops)
+		return -ENODEV;
+
+	return ops->ice_derive_sw_secret(ops->dev, eph_key, eph_key_size,
+					 sw_secret, sw_secret_size);
+}
+
+static int qcom_ice_tz_generate_key(u8 *lt_key, size_t lt_key_size)
+{
+	struct qcom_ice_tz_ops *ops;
+
+	ops = ice_tz_ops;
+	if (!ops)
+		return -ENODEV;
+
+	return ops->ice_generate_key(ops->dev, lt_key, lt_key_size);
+}
+
+static int qcom_ice_tz_prepare_key(const u8 *lt_key, size_t lt_key_size,
+				   u8 *eph_key, size_t eph_key_size)
+{
+	struct qcom_ice_tz_ops *ops;
+
+	ops = ice_tz_ops;
+	if (!ops)
+		return -ENODEV;
+
+	return ops->ice_prepare_key(ops->dev, lt_key, lt_key_size, eph_key,
+				    eph_key_size);
+}
+
+static int qcom_ice_tz_import_key(const u8 *raw_key, size_t raw_key_size,
+				  u8 *lt_key, size_t lt_key_size)
+{
+	struct qcom_ice_tz_ops *ops;
+
+	ops = ice_tz_ops;
+	if (!ops)
+		return -ENODEV;
+
+	return ops->ice_import_key(ops->dev, raw_key, raw_key_size, lt_key,
+				   lt_key_size);
+}
+
+int qcom_ice_tz_ops_register(struct qcom_ice_tz_ops *ops)
+{
+	if (!qcom_ice_tz_ops_registered())
+		/* Paired with smp_load_acquire() in qcom_ice_tz_ops_registered() */
+		smp_store_release(&ice_tz_ops, ops);
+	else
+		return -EBUSY;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_tz_ops_register);
+
+void qcom_ice_tz_ops_unregister(struct qcom_ice_tz_ops *ops)
+{
+	if (READ_ONCE(ice_tz_ops) == ops)
+		/* Paired with smp_load_acquire() in qcom_ice_tz_ops_registered() */
+		smp_store_release(&ice_tz_ops, NULL);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_tz_ops_unregister);
+
 static bool qcom_ice_check_supported(struct qcom_ice *ice)
 {
 	u32 regval = qcom_ice_readl(ice, QCOM_ICE_REG_VERSION);
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index 4bee553f0a59..89e62e151b85 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -10,6 +10,47 @@
 #include <linux/types.h>
 
 struct qcom_ice;
+struct device;
+
+enum qcom_ice_cipher {
+	QCOM_ICE_CIPHER_AES_128_XTS = 0,
+	QCOM_ICE_CIPHER_AES_128_CBC = 1,
+	QCOM_ICE_CIPHER_AES_256_XTS = 3,
+	QCOM_ICE_CIPHER_AES_256_CBC = 4,
+};
+
+/**
+ * struct qcom_ice_tz_ops - Qcom ICE TZ operations
+ * @drv_name:                    ICE TZ backend driver name.
+ * @dev:                         ICE TZ backend device.
+ * @ice_invalidate_key:          Invalidate keyslot callback.
+ * @ice_set_key:                 Program keyslot callback.
+ * @ice_has_wrapped_key_support: Wrapped-key support callback.
+ * @ice_derive_sw_secret:        Derive software secret callback.
+ * @ice_generate_key:            Generate wrapped key callback.
+ * @ice_prepare_key:             Prepare wrapped key callback.
+ * @ice_import_key:              Import wrapped key callback.
+ */
+struct qcom_ice_tz_ops {
+	const char *drv_name;
+	struct device *dev;
+	int (*ice_invalidate_key)(struct device *dev, u32 index);
+	int (*ice_set_key)(struct device *dev, u32 index, const u8 *key,
+			   u32 key_size, enum qcom_ice_cipher cipher,
+			   u32 data_unit_size);
+	bool (*ice_has_wrapped_key_support)(struct device *dev);
+	int (*ice_derive_sw_secret)(struct device *dev, const u8 *eph_key,
+				    size_t eph_key_size, u8 *sw_secret,
+				    size_t sw_secret_size);
+	int (*ice_generate_key)(struct device *dev, u8 *lt_key,
+				size_t lt_key_size);
+	int (*ice_prepare_key)(struct device *dev, const u8 *lt_key,
+			       size_t lt_key_size, u8 *eph_key,
+			       size_t eph_key_size);
+	int (*ice_import_key)(struct device *dev, const u8 *raw_key,
+			      size_t raw_key_size, u8 *lt_key,
+			      size_t lt_key_size);
+};
 
 int qcom_ice_enable(struct qcom_ice *ice);
 int qcom_ice_resume(struct qcom_ice *ice);
@@ -31,4 +72,19 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 struct qcom_ice *devm_of_qcom_ice_get(struct device *dev);
 
+#ifdef CONFIG_QCOM_INLINE_CRYPTO_ENGINE
+int qcom_ice_tz_ops_register(struct qcom_ice_tz_ops *ops);
+void qcom_ice_tz_ops_unregister(struct qcom_ice_tz_ops *ops);
+#else
+static inline int qcom_ice_tz_ops_register(struct qcom_ice_tz_ops *__unused)
+{
+	return 0;
+}
+
+static inline
+void qcom_ice_tz_ops_unregister(struct qcom_ice_tz_ops *__unused)
+{
+}
+#endif /* CONFIG_QCOM_INLINE_CRYPTO_ENGINE */
+
 #endif /* __QCOM_ICE_H__ */

-- 
2.34.1

