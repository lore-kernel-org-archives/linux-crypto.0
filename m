Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E973E1219
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773756163; cv=none; b=OOQrdPEAqzpaO7cUZRXo22rqRo2QdkUhdxmX9/TvTOtEw90QSFjPTQNgOkoWSEgqEyKB/uKuwLl1lOVUBPqsVUtSYGBMoRHZ0zl3r7s0UYAVU+a0Ze9SQRbDzDAxdMTA8jkPpVFhRrUGyz9eVZkBr5vnPNopk3NkllrGisE0waM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773756163; c=relaxed/simple;
	bh=n9QmEUx2k+Xw5vQlxuhVJtgHskQc4Z8JEF4CUt+KmJU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=hOsZhpIfjVtGqqPcUkTQPnXlAtDUdVZ6OSpUr0rRl/JlcACbOWMs+RhPJSJawBRg1GclmE8iBfdqOu8cojQQ9rieeJM2HUrQ8y6zar6DJ1t9VxI+0q4y4NYsmr2W/OdD4C8P64nm+dyw+LSM1jY//GYthp9kMHP4cEWAtaVQHI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=W7imo8Xz; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KeO6n7Cj; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="W7imo8Xz";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KeO6n7Cj"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62HD4vBL668915
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=2ux4cjLGAHyb8qfNLkf5TP
	+0nTrSK+UTuTiz6cAxiMM=; b=W7imo8XzMHXgcYaVY5hor9HlBbNz50eyP0bE1w
	itTPVA+SSKb3Qin6VZE2ut1C4ZpZl1yxC+KAgErE76Zxk2eFxE/vVbdBm7vBNHF/
	2kkUIFgZbyb6PvKC8QO1+S3Te7S5QUnOkheIx8bEXlBVGMnvT1/bzwNXskw5ZtIQ
	Nr6oyJx24YEH6/liD7bStQAKWcMlAZRIbpmcDpi/gNWKgP8P8PBeVlE463iUgtgO
	HG8a2aEwRcNMGb7RrBYj5XEzmyUNzqx9+T+CC2B8NgxjewmU4eszi8S+eBWp4HG2
	81R53Yme3Uz2EEbsOaByAhZ7QpkhsXk9Mc83C/7dBm2OrBtA==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cy7he06ut-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:02:40 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-5fa75a19f21so6439560137.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 07:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773756160; x=1774360960; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2ux4cjLGAHyb8qfNLkf5TP+0nTrSK+UTuTiz6cAxiMM=;
        b=KeO6n7CjRGDmcF+t2jPl7sjEVCdjuEuJ38NBKokhDCnxjH/7HTvouuPurRYgL1dar/
         P8klvJo1tUBLM88/EMnEglZ+DN/ip71Jm6BhUL0oI+dfu6Tl37fyaDSi2xz4NmvzvpWo
         lxjBX7ekRyapVjXiuntenlANO4BJzVkfVNj+v4EF0KM2EMMjplLQxr1VcTt4LbuX0zxu
         KdmIPppmY4buH9W9anLE23yopdTx86lqA3RjhwGjA2Txg9PCpL2mK7/ZtwKWsb/zvBq2
         PMCt7T9e81UnH3bLkFfCcB6WkOFhtriMqtXSX6jlRH06vvrnvOtmXKEb7UJS2Er6G/NG
         6PxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773756160; x=1774360960;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ux4cjLGAHyb8qfNLkf5TP+0nTrSK+UTuTiz6cAxiMM=;
        b=RyDhKAMVmcxVM6N/D5iXsM7aVr1MWNl8i6I6oH1rElIZmKTUo078ewMbtK90BALbTd
         yGBA5Jp4N9umvSCjDUC0xOKFs3Cog6scYnokh25h/HIxohwcRglSHmwxeAHiwFbMJ3s+
         SBf+508LNYRkkHVH533dGgIKuj/mjttjEDGOCzGKa9J/CtX+YUllao0xke9i35bbZEpj
         SQyc93lNT2W87RyqShvfkyt82Db1ev3omvyBXJoG+SINbbJ4oR0SOUNwGjRin3T9PHyA
         yVgJgja0hRICmh1CCKzFfmDnz1mAB+KLpgUhhtgr8GejfAodJdHxHDG7A3MrgO7X64IV
         O46g==
X-Forwarded-Encrypted: i=1; AJvYcCVUD2mME+kpH3BtoGZcA/KiC2SQFFrg8JGw8XIB32fwk3485P1+1R29GBCeZjRQumYl/wNO35hamVtRxoM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yybll5FYxZBmgOSwwt+g0PDELU7naWlyG3v2Cr17o4kxXiueqrN
	+qHAeF9gsPpckQLBiMSWW9vsFgnEWtrFkSww4uShYdckF7z8LDS2DP/jrWDQUrGXoRMbOydYtHi
	U7Y/lI80D73JKEbzmtEYpSFu6vl6znQ9TOzQU6rV1gaaXNxy4MGve4YMXvxXHpaBMaLI=
X-Gm-Gg: ATEYQzzn8ThrV/a/9jZcbsXFlRvRbOrHsG/2mr5TmeV/0QrT5MTxRKT1Mhl7fhXA1xw
	AYVi6bucbsweHfmOs0r5DWV1Fwv5lCuOZyIzWrsbycmpRa/0ZrpSOdVNedd1AuRMeZ+At3nReV3
	EKRhTrhrL3BNQG57BW23CUe3kk4ccfCffpuO0m79+ZlnC7wa4X1UDwPV2xw0IY/ZVPiBaXLBoEK
	yJDmdOK4gWImq34ZoJnbIUrQ9xoN8THoyq0JZTQdXCMuJhzpJhWoRVs4q3RvzAwqL0/VjSpdoQQ
	hyG3FdI+4N0q0HaB1e458ScHxCzbhv2ki2MlLIPTKkRTiC/00zE9HmTD763hlxrKX7Al2iU5Nxk
	mQlaKbTDSmA58IelBayAWiBMuT27nabPVJscP0lPPwf8+o9PGzka8
X-Received: by 2002:a05:6102:c46:b0:601:f6ef:af8 with SMTP id ada2fe7eead31-60263f20317mr1644331137.10.1773756159090;
        Tue, 17 Mar 2026 07:02:39 -0700 (PDT)
X-Received: by 2002:a05:6102:c46:b0:601:f6ef:af8 with SMTP id ada2fe7eead31-60263f20317mr1644234137.10.1773756158287;
        Tue, 17 Mar 2026 07:02:38 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:6aa2:dd35:4d6d:8eec])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b4938854csm9359709f8f.34.2026.03.17.07.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 07:02:37 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH v13 00/12] crypto/dmaengine: qce: introduce BAM locking and
 use DMA for register I/O
Date: Tue, 17 Mar 2026 15:02:07 +0100
Message-Id: <20260317-qcom-qce-cmd-descr-v13-0-0968eb4f8c40@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOBeuWkC/3XOwW7DIAwA0F+pOI8ITBJgp/7HtAMB0yI1YYUt2
 lTl3+dWq1Zp7GBLtuxnX1jFkrCy592FFVxTTXmhQqqnHfNHtxyQp0ANBgIGKYXiZ59nSsj9HHj
 A6gv3A9pJyoijsIwW3wrG9HlTX16pPqb6nsvX7chqrt07N7a41XDB0YfgHSiKcX9Kiyu5y+XAr
 t5qHwwwTcOSYd0QNUzGaoA/hhS/CEjbRKQgJUaN/RR1cKHf51q784c70fDcUfqx5N0ahRLQtiR
 Z5Mg4hKk3Av6z4MGiB5oWkKWsiUpHGDGKhrVt2zcPZJ9J3gEAAA==
X-Change-ID: 20251103-qcom-qce-cmd-descr-c5e9b11fe609
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
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8992;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=n9QmEUx2k+Xw5vQlxuhVJtgHskQc4Z8JEF4CUt+KmJU=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpuV7qLy5l6tr1UR4kURPLEzoCfhd+cG1mKezrM
 xr85OwW8HaJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCable6gAKCRAFnS7L/zaE
 w3ojD/9PL4cZEgdCxe08TvXlNVNrQFpMS/F6pjgg2kc3q461h4h6SN57M/Osl7Inze8QeoKeD6X
 xTyonz0jRmcvvx7CDXiTVCEk633rF9j+rOkgGMb7ZyR1JVHCD5Y/6gk3h0S/EAY9t+VppRhv6Dv
 8nIA29FBStDhDVRmo/st3tzD8b9OlS26J3gaj27SIT0f9O94vuOR5lYTpKltUtuiqzU2gH6Jy6+
 q2p7z4w+TgBrmt61Z6ZWeHrKhpVaVugdIuKewdDEVnsHeq3Q5rPnjJ2Zdwjh77ArmL0qzYO/28O
 OXbYD4r5VrQDpJFI4VNijPw5HeuTd9XDYmqb/cFchkqUYHzwgqo8xYa0lVFH0WT27IYVSEJwak0
 8dbYMpP09IWi9DzI41zq2Xh52QPl2w8W+APRjHdr8Enp1Sa2UfAR4IUQXm6qEL+VubxlrFMcldm
 vNDyb94Jhy8zyyikuqdhHQx/ViJKhqdwrZm9f6g4k/v3gjTOLd/djkNsZ8rMX/qBfs6lAjuMqd5
 lKVNMQF0AZ+obFSevqedoo29V2JBFdYeHioZrf8XGTsQS7vZIjxyUKeimlVQrTdIQO2JAf2u4ES
 zUtf6T99R2xPexms8OJRQxrMb7lrpLvMJeVRwxbvkzbRCKxcX+XlIuIze7sxra1ZtUw9EJlmUqb
 jDZ6o2S+GNo4T0g==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: -Bo1CyNnTWHkeFtxdotoPtqJBTfrHB2W
X-Proofpoint-ORIG-GUID: -Bo1CyNnTWHkeFtxdotoPtqJBTfrHB2W
X-Authority-Analysis: v=2.4 cv=QsVTHFyd c=1 sm=1 tr=0 ts=69b95f00 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=bC-a23v3AAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=COk6AnOGAAAA:8
 a=3F_D-PAzLxqp5o1pZYoA:9 a=QEXdDO2ut3YA:10 a=gYDTvv6II1OnSo0itH1n:22
 a=FO4_E8m0qiDe52t0p3_H:22 a=cvBusfyB2V15izCimMoJ:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEyNCBTYWx0ZWRfXwzuijRKenJEA
 rVgjz2eMEeB/ybZjLMmzl5FX2Lox8lY12IIO4cXFED7ZyxaPvIBZ7grPnRYLf+LzY9DZloacInS
 sj8Rl01fdMJejeolJBXbVb/nWIHt/8usL04OZE24ILZ3c+cGV5mGn4VVjmbeZ5bBRCGEoMxuZlb
 Qxb36aWVtkVE0KC3SqaqePjlpsdzt1wVCVgnPCPlj2d+sAUMIwu0AVzij2ND1hZbO3zspZqDXV4
 cgK0z8DTNELqC8uXOPD+WvpJDCu1A2buRM16zwk0rGpV4gDMsOMNnE8eTIDlKy+AcCDv1COKhTp
 NV2E9TaUVe7C8Wnn1JwaSBVthz/VxxHHDXr2bkBgWUHV569C/yhfxr6fJJy7HB8Ch5Q1/w6hemv
 RIQpUcXdYfs5IWSKa5a7agx8DBAUYKmvvEPa26lYzWy/EWdkjmePjW3X+9Foug14Smyj2fFME7N
 PbziyvZoH05e29j+BQg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603170124

This iteration is quite similar to v12 but uses the BAM's NWD bit on
data descriptors as suggested by Stephan. To that end, there are some
more changes like reversing the order of command and data descriptors
queuedy by the QCE driver.

Currently the QCE crypto driver accesses the crypto engine registers
directly via CPU. Trust Zone may perform crypto operations simultaneously
resulting in a race condition. To remedy that, let's introduce support
for BAM locking/unlocking to the driver. The BAM driver will now wrap
any existing issued descriptor chains with additional descriptors
performing the locking when the client starts the transaction
(dmaengine_issue_pending()). The client wanting to profit from locking
needs to switch to performing register I/O over DMA and communicate the
address to which to perform the dummy writes via a call to
dmaengine_desc_attach_metadata().

In the specific case of the BAM DMA this translates to sending command
descriptors performing dummy writes with the relevant flags set. The BAM
will then lock all other pipes not related to the current pipe group, and
keep handling the current pipe only until it sees the the unlock bit.

In order for the locking to work correctly, we also need to switch to
using DMA for all register I/O.

On top of this, the series contains some additional tweaks and
refactoring.

The goal of this is not to improve the performance but to prepare the
driver for supporting decryption into secure buffers in the future.

Tested with tcrypt.ko, kcapi and cryptsetup.

Shout out to Daniel and Udit from Qualcomm for helping me out with some
DMA issues we encountered.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
Changes in v13:
- As part of the DMA changes in the QCE driver: reverse the order of
  queueing the descriptors in the QCE driver: queue command descriptors
  with all the register writes first, followed by all the data descriptors,
  this is in line with the recommandations from the BAM HPG
- Set the NWD (notify-when-done) bit (DMA_PREP_FENCE in dmaengine
  parlance) on the data descriptors to ensure that the UNLOCK descriptor
  will not be processed until after they have been processed by the
  engine. While technically the NWD bit is only needed on the final data
  descriptor, it's hard to tell which one *will* be the last from the
  driver's point-of-view and both the downstream driver as well as
  the Qualcomm TZ against which we want to synchronize sets NWD on every
  data descriptor,
- Revert to creating the LOCK/UNLOCK command descriptor pair in one
  place now that the NWD bit is in place,
- Link to v12: https://patch.msgid.link/20260310-qcom-qce-cmd-descr-v12-0-398f37f26ef0@oss.qualcomm.com

Changes in v12:
- Wait until the transaction is done before queueing the UNLOCK command
  descriptor
- Use descriptor metadata for communicating the scratchpad address to
  the BAM driver
- To that end: reverse the order of the series (first BAM, then QCE) to
  maintain bisectability
- Unmap buffers used for dummy writes after the transaction
- Link to v11: https://patch.msgid.link/20260302-qcom-qce-cmd-descr-v11-0-4bf1f5db4802@oss.qualcomm.com

Changes in v11:
- Use new approach, not requiring the client to be involved in locking.
- Add a patch constifying dma_descriptor_metadata_ops
- Rebase on top of v7.0-rc1
- Link to v10: https://lore.kernel.org/r/20251219-qcom-qce-cmd-descr-v10-0-ff7e4bf7dad4@oss.qualcomm.com

Changes in v10:
- Move DESC_FLAG_(UN)LOCK BIT definitions from patch 2 to 3
- Add a patch constifying the dma engine metadata as the first in the
  series
- Use the VERSION register for dummy lock/unlock writes
- Link to v9: https://lore.kernel.org/r/20251128-qcom-qce-cmd-descr-v9-0-9a5f72b89722@linaro.org

Changes in v9:
- Drop the global, generic LOCK/UNLOCK flags and instead use DMA
  descriptor metadata ops to pass BAM-specific information from the QCE
  to the DMA engine
- Link to v8: https://lore.kernel.org/r/20251106-qcom-qce-cmd-descr-v8-0-ecddca23ca26@linaro.org

Changes in v8:
- Rework the command descriptor logic and drop a lot of unneeded code
- Use the physical address for BAM command descriptor access, not the
  mapped DMA address
- Fix the problems with iommu faults on newer platforms
- Generalize the LOCK/UNLOCK flags in dmaengine and reword the docs and
  commit messages
- Make the BAM locking logic stricter in the DMA engine driver
- Add some additional minor QCE driver refactoring changes to the series
- Lots of small reworks and tweaks to rebase on current mainline and fix
  previous issues
- Link to v7: https://lore.kernel.org/all/20250311-qce-cmd-descr-v7-0-db613f5d9c9f@linaro.org/

Changes in v7:
- remove unused code: writing to multiple registers was not used in v6,
  neither were the functions for reading registers over BAM DMA-
- remove
- don't read the SW_VERSION register needlessly in the BAM driver,
  instead: encode the information on whether the IP supports BAM locking
  in device match data
- shrink code where possible with logic modifications (for instance:
  change the implementation of qce_write() instead of replacing it
  everywhere with a new symbol)
- remove duplicated error messages
- rework commit messages
- a lot of shuffling code around for easier review and a more
  streamlined series
- Link to v6: https://lore.kernel.org/all/20250115103004.3350561-1-quic_mdalam@quicinc.com/

Changes in v6:
- change "BAM" to "DMA"
- Ensured this series is compilable with the current Linux-next tip of
  the tree (TOT).

Changes in v5:
- Added DMA_PREP_LOCK and DMA_PREP_UNLOCK flag support in separate patch
- Removed DMA_PREP_LOCK & DMA_PREP_UNLOCK flag
- Added FIELD_GET and GENMASK macro to extract major and minor version

Changes in v4:
- Added feature description and test hardware
  with test command
- Fixed patch version numbering
- Dropped dt-binding patch
- Dropped device tree changes
- Added BAM_SW_VERSION register read
- Handled the error path for the api dma_map_resource()
  in probe
- updated the commit messages for batter redability
- Squash the change where qce_bam_acquire_lock() and
  qce_bam_release_lock() api got introduce to the change where
  the lock/unlock flag get introced
- changed cover letter subject heading to
  "dmaengine: qcom: bam_dma: add cmd descriptor support"
- Added the very initial post for BAM lock/unlock patch link
  as v1 to track this feature

Changes in v3:
- https://lore.kernel.org/lkml/183d4f5e-e00a-8ef6-a589-f5704bc83d4a@quicinc.com/
- Addressed all the comments from v2
- Added the dt-binding
- Fix alignment issue
- Removed type casting from qce_write_reg_dma()
  and qce_read_reg_dma()
- Removed qce_bam_txn = dma->qce_bam_txn; line from
  qce_alloc_bam_txn() api and directly returning
  dma->qce_bam_txn

Changes in v2:
- https://lore.kernel.org/lkml/20231214114239.2635325-1-quic_mdalam@quicinc.com/
- Initial set of patches for cmd descriptor support
- Add client driver to use BAM lock/unlock feature
- Added register read/write via BAM in QCE Crypto driver
  to use BAM lock/unlock feature

---
Bartosz Golaszewski (12):
      dmaengine: constify struct dma_descriptor_metadata_ops
      dmaengine: qcom: bam_dma: convert tasklet to a BH workqueue
      dmaengine: qcom: bam_dma: Extend the driver's device match data
      dmaengine: qcom: bam_dma: Add pipe_lock_supported flag support
      dmaengine: qcom: bam_dma: add support for BAM locking
      crypto: qce - Include algapi.h in the core.h header
      crypto: qce - Remove unused ignore_buf
      crypto: qce - Simplify arguments of devm_qce_dma_request()
      crypto: qce - Use existing devres APIs in devm_qce_dma_request()
      crypto: qce - Map crypto memory for DMA
      crypto: qce - Add BAM DMA support for crypto register I/O
      crypto: qce - Communicate the base physical address to the dmaengine

 drivers/crypto/qce/aead.c        |   8 +-
 drivers/crypto/qce/common.c      |  20 ++--
 drivers/crypto/qce/core.c        |  28 ++++-
 drivers/crypto/qce/core.h        |  11 ++
 drivers/crypto/qce/dma.c         | 163 +++++++++++++++++++++++-----
 drivers/crypto/qce/dma.h         |  11 +-
 drivers/crypto/qce/sha.c         |   8 +-
 drivers/crypto/qce/skcipher.c    |   8 +-
 drivers/dma/qcom/bam_dma.c       | 223 ++++++++++++++++++++++++++++++++++-----
 drivers/dma/ti/k3-udma.c         |   2 +-
 drivers/dma/xilinx/xilinx_dma.c  |   2 +-
 include/linux/dma/qcom_bam_dma.h |   4 +
 include/linux/dmaengine.h        |   2 +-
 13 files changed, 402 insertions(+), 88 deletions(-)
---
base-commit: a770d984685255ef0e29fc2c8fc91735f94b4432
change-id: 20251103-qcom-qce-cmd-descr-c5e9b11fe609

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

