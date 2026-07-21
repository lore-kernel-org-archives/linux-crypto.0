Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4233360ED4
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784640819; cv=none; b=B7QuIYFgZ11A1whsosk+EXV+D1t3AlOs+42lh7Ui7rgYojJ7rlXv+YJeNxaqHCFe30LEtuk60wTpaSMuqjM+RxmzlolMubIp10OASdjW/BqaVSu1wUwPEbsFAY7wBxl2EcfwXvmA1WZxrq/48FxZYYD83oI13MopPFlGh/W4V6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784640819; c=relaxed/simple;
	bh=qufaRDM3ELUIkQ3GN42VFLouSw8vfXLw8nEQxkCgUeI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=fzqIB887mfPWbMRUE0CTi+7LcpSc+qU4k3aLqnvQvhjzfVd1N78/EGULQ8shEjo02X8TxNq2ZxRI4mrP5nHVcln5r/8OWrGLkyDmsPNp7OPxB7GYOxfvQIht1RpIHzvE6BCilDoo2cEWDiQOGf+G/2gRkA02viMWsiXjvtlHhbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KImvba/y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JZIGzxcZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KImvba/y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JZIGzxcZ"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LDMI271793878
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:33:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=36lsZqMkhxe1tyxw0WZEHY
	VaTrXfgR4FpvvmH2w2AqY=; b=KImvba/yufTjrCSlNDsocBny62gEs0b4XJRdJe
	Yxq4eUIo3hcmwv+igwpA0QxBVUBIv82uRPF5P9d6nbzlfZZvEW2ZPImGwFGL9032
	SHcaycHiOSRrAmlNJl6uqYoLocXJmnlUS/YIyvB7WKZywKW2k855aG/Rn3trtSEk
	VGS/FNF/EE8Ll+HKdpYrdqwWmZuKrQ+tEJJf5H3Ag4f8o3tqdzykE3r2XlF8Ch6V
	rsWdZ+JvN6mtN92/AgAT7D/7rngMwsl4+Z1bUSaOOhEsckga1E5/tVc/n+Ky0esq
	dgvaZcDd3xkIGkJsz0ppVb6y6xen/oSGqhaRq/MjLkPHf+7Q==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj1se2ehv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:33:35 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c0199faafso172445211cf.3
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 06:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784640815; x=1785245615; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=36lsZqMkhxe1tyxw0WZEHYVaTrXfgR4FpvvmH2w2AqY=;
        b=JZIGzxcZoDq2MbOJxZm6bGYsymxmETVJYJPttj1SsArn19wvh3YcqZz//KRNjGj4Pq
         wYKJoU8t9nSyr3IirUFfUSo6KSBi9VAmuTYiUp94zIU09vien7Mn787IVgP3snwJIzIr
         R3YJEFBqqk3gBNrR8l04XDg4YKbvFZ/YNmp1jG9y7qcvz+xC1wLGu1YiS8NUMKP/kMlZ
         RjeUPZtrGN8gA82z0DQiWD1bpuWzXWYDtCDPPNtmOXs3YjnfGG/JAGLkMiJilAUqBX4n
         FnadDC8u/ISy4GIw+vztI2SBqpw4JhHFJ4bkURnT+mSuFq5dFxTEzkYZDClHlkpDIfzc
         3P9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784640815; x=1785245615;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=36lsZqMkhxe1tyxw0WZEHYVaTrXfgR4FpvvmH2w2AqY=;
        b=nLcB17znf1QVEsWpmjoXCHq8JROOIFqwYlO/NzjXH/CmrARVtzCk+PMRHHiENneAS5
         LX1paoM9tvxswR3g4LcyRL7Wiom7SdfHjJ8+k/oPcmyKUe29nNX0SwgW0XXeinRSHCHG
         6bj2gGJGRO1FGfTO7TnvgVdsTrNDhfzfDJq/hvhMSVKwUd52uqIKha7StXDcw7THhckH
         eeVDo0RZsPK0PHDrnrU7lqhtMA9NxhAfG5fyPZ4HRSwDH4bXK/Q13ANuNB5ZegeqlUDV
         NPn92Uef2GY5yPp6KVNOs0dcghoEOXz+NGd3pQNBqZ2tLKV3wNjO/YAwiKJelQjrLkBD
         cPKA==
X-Forwarded-Encrypted: i=1; AHgh+Rp2Sd+pbNViYBFZY/w3QIK0/sAfGeUlGgQT+95I8kdTJTSw6X9FUhFKe9e08WQUOVT11yC89AJAkMs2Y6w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz9s1VH3aCNxv4drRycL2zfRSbwfaCXGYqJnGDm3WQ9p5c/Em3
	qtrrjEFXJB8PiycTK5Jw/ydjITrgCaU0CJEPGucB2/oZdJJK35HoZFehTyNRZkVaq+OgCSz6G1u
	jdiOWsKvTNwC8uZZ2hyv9/Mh9UUbddOjPG9rGUEKYpM+Btan2YLrxZAml4SXLXPEuDbY=
X-Gm-Gg: AfdE7cnvcaRohG7b1hvh5G7j8a1jGxaBqyryDSDnU1QMhbJh56sTZuMhL9+ZRjgUtBl
	A2yUrLc3Y3c1WccQrnaXv/CSLIHSmlILLJPLUr+fqeettBLuzqe4h3uWodFYAbdwgk4eL+GuK3D
	X5DoYSBxlExSc7WrLvU9L7SU2welmMx5/Euazxxy54aa6rIOx0ZzrTJt/tpw3z0Pi6pptn4jKPx
	HVFdmPTDuG3i6CzMArXNoYz4pjL+xSIGhVe+Rau30tVc6/BZj/e1VbDFkk5xlCC89j5q44Urb1B
	DJ/SPlAduudxwTG3NQ/CirZAfmYiH+sMmicHZTLfZijkhDlQuoabexaidO7Jj9rgyXl3qB76qrE
	m2EoeZeQF8T+ysBN50wigT8rRZztKfQ==
X-Received: by 2002:a05:622a:1f17:b0:51b:fde4:cd4f with SMTP id d75a77b69052e-5213c9dd981mr176841421cf.30.1784640814577;
        Tue, 21 Jul 2026 06:33:34 -0700 (PDT)
X-Received: by 2002:a05:622a:1f17:b0:51b:fde4:cd4f with SMTP id d75a77b69052e-5213c9dd981mr176840741cf.30.1784640813986;
        Tue, 21 Jul 2026 06:33:33 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:9dcf:9ab8:bffb:ec35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495499d1d4asm237901185e9.2.2026.07.21.06.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 06:33:31 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH v23 00/14] crypto/dmaengine: qce: introduce BAM locking and
 use DMA for register I/O
Date: Tue, 21 Jul 2026 15:33:05 +0200
Message-Id: <20260721-qcom-qce-cmd-descr-v23-0-1be02deffda9@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABJ1X2oC/3XTyW7bMBAG4FcJdK4MznDvKe8R5MBtEgGx1UiJ0
 cLwu3do1DCBkgcRICV9XObnZdrLtpR9+vl0mbZyXvZlPXEH5Y+nKb2H01uZl8wDEwrUAELOn2k
 9clPmdMxzLnva5qSLjwBUjPAT//hrK7T8vqkvr9x/X/avdftzm+Ts6uidMz3u7GYxl5RzCij5M
 c8fyyls62Hd3qbqnX1joOsang0fNFmMzlvE/wwQDwTBdxEQrBDZoiLZHLJ6Xvf98PkdPvjj44G
 bfxbcLSOkwL4FbLEDpHNUTuDIwsbiBXQtZEt6R9ISmkJiZMnWsn1LsiW8cSUqckkNLdVYKPuWq
 ufFbwMprowdnpd+WGp0XrpW0EUtDXAFsh1ZprFwsEdTLaUpQwoUYxpZ9mHpUSYsW1oG7bUCFa0
 fWa6xcLDHmnTv+Vp5NDHQcF2+tfqXBmrihVMWKadIKgwsFA/LYH+PWHOvDRkOvVNJ6JHV5N5CP
 xNYcx8TaicL8PKGFrZWv46It/soMriIFpXpWNfr9S8G5T3U1gQAAA==
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
        Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@codeaurora.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=14344;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=qufaRDM3ELUIkQ3GN42VFLouSw8vfXLw8nEQxkCgUeI=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqX3UY/v+B08iMI0sFjjOFHZzgy/OUzFwiUx3Qf
 9u5CDDBgKWJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCal91GAAKCRAFnS7L/zaE
 wwWDD/4jTes+5+hFiFcdRQcl/RIl8h7gXbmPIDTYTrZ6FYnK8gePmRUrgF+HyQkoRkfx9fdIwaO
 4ZR1dKYEGQUox1pjPEilCChGM5elewBvzHxJO62VE4hCWY77VtOlbJke8wN3QwMe8zvIlLeUb0G
 WWf50YHV2G0Dmrh8jvQzjS8+4RsJDkXSl4kwOVHnA6d3VGDfzW8odvQXnbjQKZGqDjUvjnZR2A2
 tj2zhYbQDciicLAsSK7nwv0m8OH83vIMYupq8cwOuI4AYpiFdL0QAjsOr/m2QFTVFalVTQ5hiJM
 XhoyHKSZSIaKgQqSMppd60a/ldNXxk1Bafgam+T5aFfDyGbqDmJJEbacSJQAqlaf6/rEyh7gh/z
 5iS5KBBs9jODIfGgS48PTFlcjYN2PMiqiDALPykibTKsf/pBgYrVV3HAGdAU11SMkSS9HfphBQA
 pSyO+0v5JVFt+5diaxBjApm7hLjs4PWmTA7mtEd4V5mD2m5l6dL7xVzwmqP56rBxsaSUZo6nurL
 eW0g3xsF/ErcKo99wT6jDuhFPd5TLofUR88egQcPOvf+Fbqyr6/OIu5XxumLCwAROMdODxiE+Jr
 l2PlTt3PCAT0RcPWjllFNEtzuVzOhaP8s+Hg+5bgk27yjtfCqwlMAcVHmgd3skYj+xFvtZ5e3b+
 P9hXugjyL4JFPqQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: hDcDGL03nT6ZKTSE3pcj2jSAlpDZw1PU
X-Authority-Analysis: v=2.4 cv=TIZ1jVla c=1 sm=1 tr=0 ts=6a5f752f cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=bC-a23v3AAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=COk6AnOGAAAA:8
 a=rl9B2ycCaUGxRu6LYUgA:9 a=BPQY48OK92vdoY-E:21 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=FO4_E8m0qiDe52t0p3_H:22 a=cvBusfyB2V15izCimMoJ:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDE0NCBTYWx0ZWRfX5FlbQw0/K4yT
 zRciSkOFdqrw6bOgRilnv1bduYi2t5osHug5fqs+ESRbHen+NTl8ASdVrzE4Ek88ZOrd7iY5hNA
 HCCNoeRpXzD9ilTeKYBXYaUaGvL23fw=
X-Proofpoint-GUID: hDcDGL03nT6ZKTSE3pcj2jSAlpDZw1PU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDE0NCBTYWx0ZWRfXy7vKLxJ6dUVA
 Pt8hYeMTFA5z54N1qW8as2jVF49Z6RZitSPGV1MjyJpo95NENQc0s2pTOBpHv1imJFH25kQpw0V
 Ke9j8+6wiat9DDB87zUjV1f5WgRdSNX8Yx2XKZtesAPkH0Jih/Qq0mRFg6fJFm+VWlG/53s3i59
 BdGsqycr3X3uOBthGuoZzejYxmgIecnQr64rBT/Rvzz3XW028cfcWrSxElrAt2U+TjnSiWBcigb
 DCdef1m1yLV0TQYIMve/4upBtvs6KOdI0xmZDQDxM/nQSKGGvWaxVVbIt+MExbEBNdBaHkrCl+I
 Rk5gPxNN/fRyxjVLZrQrpVkU4mECVzLECnxSQQ95b8fGugf5bo3RHeCwyM3NZfS1x8zGuFSIdRc
 sWdm8jIb5hfHJmRbBuo8SIerS9NtYRdafXuXiJfrtOVdTRaheMJYUZeVs+NvZwHKkqYpdHuSnhi
 7bkpKPgm9gn4wvF9OnQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_02,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607210144

Another round of issues pointed out by Stephan and Sashiko. Stephan: if
you consider this iteration satisfactory, I would appreciate any
Tested-by and Reviewed/Acked-by you could provide in order to help move
this forward.

Merging strategy: there are build-time dependencies between the crypto
and DMA patches so the best approach is for Vinod to create an immutable
branch with the DMA part pulled in by the crypto tree.

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

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
Changes in v23:
- Use the same struct device that was used for mapping the scatter list
  to unmap it
- Change the type of lock_scratchpad_addr to u32 as it's a IP-local
  register offset, not a physical address
- Queue the work to retry the transfer if setting up pipe lock fails
- Fix missing argument in dev_err()
- Fix commit message wording for DMA direction
- Validate DMA direction in bam_slave_config() instead of storing it and
  rechecking later
- Link to v22: https://patch.msgid.link/20260717-qcom-qce-cmd-descr-v22-0-ff0d18b27246@oss.qualcomm.com

Changes in v22:
- Switch back to passing the QCE scratchpad register address to the BAM
  DMA driver using the slave config structure but this time provide a
  dedicated peripheral config structure
- Rename the scratchpad_addr field to lock_scratchpad_addr
- Remove leftover local variables
- Use the BAM struct device for DMA mapping instead of the QCE device
- Use cpu_to_le32() where needed
- Don't silently queue data if setting up the locks failed, defer
  transfer and emit an error message
- Remove redundant is_lock_desc check in bam_start_dma()
- Link to v21: https://patch.msgid.link/20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com

Changes in v21:
- Fix a potential race with new descriptors submitted while hardware is
  processing a locked sequence by clearing the bam_locked state right
  after queueing the UNLOCK descriptor
- Link to v20: https://patch.msgid.link/20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com

Changes in v20:
- Don't use DMA cookies for LOCK/UNLOCK descriptors as this leads to
  dmaengine state corruption
- Handle re-scheduling of a DMA transaction on full FIFO
- Fix DMA descriptor leak in qce_submit_cmd_desc()
- Link to v19: https://patch.msgid.link/20260526-qcom-qce-cmd-descr-v19-0-08472fdcbf4a@oss.qualcomm.com

Changes in v19:
- Fix more potential issues in remove path (sashiko)
- Remove unneeded return value check for vchan_tx_prep() as it can never
  fail
- Link to v18: https://patch.msgid.link/20260522-qcom-qce-cmd-descr-v18-0-99103926bafc@oss.qualcomm.com

Changes in v18:
- Free the BAM interrupt before disabling the clock in remove() path too
- convert the size assigned to command descriptors to little endian
- don't pass DMA mapping attributes to dma_map_sg() in bam_dma when
  setting up command descriptors
- Cancel the QCE workqueue *after* any outstanding DMA transfer
  completes
- When mapping the scatterlist for command descriptors: use the actual
  number of mapped segments for dmaengine_prep_slave_sg()
- Drop the leftover read_buf field from struct qce_device
- Unmap command descriptors only after terminating the RX transfer
- Pass the actual size of the metadata struct to
  dmaengine_desc_attach_metadata(), this is not really required for our
  use-case but let's do this for correctness and make sashiko happy
- Drop double assignment of bam_ce_idx in qce_clear_bam_transaction()
- Remove unused QCE_MAX_REG_READ
- Link to v17: https://patch.msgid.link/20260519-qcom-qce-cmd-descr-v17-0-53a595414b79@oss.qualcomm.com

Changes in v17:
- New patch: free the interrupt before disabling the clock in error path
  in probe()
- New patch: cancel the QCE work on device detach
- Hold the channel lock when attaching the metadata
- Reorder the operations in devm_qce_dma_request() to avoid freeing
  memory that may still be used by the DMA channel
- Register algorithms as the last step in QCE's probe() to avoid making
  the resources available to the system before the DMA is fully set up
- Fix error paths in algo request handlers
- Don't pass dmaengine attributes to map_sg_attrs() as it expects
  dma-mapping attribute flags
- Fix a dma mapping leak for command descriptors
- Rebase on top of v7.1-rc4
- Link to v16: https://patch.msgid.link/20260427-qcom-qce-cmd-descr-v16-0-945fd1cafbbc@oss.qualcomm.com

Changes in v16:
- Fix a reported race between dma_map_sg() called with spinlock taken
  and the corresponding dma_unmap_sg() called without it by moving the
  descriptor locking data into the descriptor struct
- Also queue the TX data descriptors before the command descriptors to
  match what downstream is doing
- Tweak commit messages
- Rebase on top of v7.1-rc1
- Link to v15: https://patch.msgid.link/20260402-qcom-qce-cmd-descr-v15-0-98b5361f7ed7@oss.qualcomm.com

Changes in v15:
- Extend the descriptor metadata struct to also carry the channel's
  transfer direction and stop using dmaengine_slave_config() for that
- Link to v14: https://patch.msgid.link/20260323-qcom-qce-cmd-descr-v14-0-f323af411274@oss.qualcomm.com

Changes in v14:
- Don't return an error to a client which wants to use locking on BAM
  that doesn't support it
- Add a comment describing the DMA descriptor metadata structure
- Fix memory leaks
- Remove leftovers from previous iterations
- Propagate errors from dma_cookie_assign() when setting up lock
  descriptors
- Link to v13: https://patch.msgid.link/20260317-qcom-qce-cmd-descr-v13-0-0968eb4f8c40@oss.qualcomm.com

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
Bartosz Golaszewski (14):
      dmaengine: constify struct dma_descriptor_metadata_ops
      dmaengine: qcom: bam_dma: free interrupt before the clock in error path
      dmaengine: qcom: bam_dma: convert tasklet to a BH workqueue
      dmaengine: qcom: bam_dma: Extend the driver's device match data
      dmaengine: qcom: bam_dma: Add pipe_lock_supported flag support
      dmaengine: qcom: bam_dma: add support for BAM locking
      crypto: qce - Cancel work on device detach
      crypto: qce - Include algapi.h in the core.h header
      crypto: qce - Remove unused ignore_buf
      crypto: qce - Simplify arguments of devm_qce_dma_request()
      crypto: qce - Use existing devres APIs in devm_qce_dma_request()
      crypto: qce - Map crypto memory for DMA
      crypto: qce - Add BAM DMA support for crypto register I/O
      crypto: qce - Communicate the base physical address to the dmaengine

 drivers/crypto/qce/aead.c        |  10 +-
 drivers/crypto/qce/common.c      |  20 ++-
 drivers/crypto/qce/core.c        |  41 ++++++-
 drivers/crypto/qce/core.h        |   7 ++
 drivers/crypto/qce/dma.c         | 175 ++++++++++++++++++++++-----
 drivers/crypto/qce/dma.h         |  11 +-
 drivers/crypto/qce/sha.c         |  10 +-
 drivers/crypto/qce/skcipher.c    |  10 +-
 drivers/dma/qcom/bam_dma.c       | 254 +++++++++++++++++++++++++++++++++------
 drivers/dma/ti/k3-udma.c         |   2 +-
 drivers/dma/xilinx/xilinx_dma.c  |   2 +-
 include/linux/dma/qcom_bam_dma.h |  15 +++
 include/linux/dmaengine.h        |   2 +-
 13 files changed, 459 insertions(+), 100 deletions(-)
---
base-commit: 84c5cd8a9fb10675b694baa37094a3429d907fb9
change-id: 20251103-qcom-qce-cmd-descr-c5e9b11fe609

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

