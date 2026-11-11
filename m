Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794406663;
	b=kHulLaA/1j3tfhRfsWfqgAK28AHoU6TImG/kzw0GJYCYuQ8Cpz3KEBDepYs3BTkYqjd0
	 Bj59TjqoOeGS37DAFsv8fQ3USSzWcnRZyVG5XdDDvxLvVh4L4VFK7ZPs9uzuvWaocE4PE
	 RPoCsrPFoCxgQ7jXMevGyYe3r+DeRibbOJzsr7myhoD179qcnIeV5PCMnx2Hc2UEPSoyp
	 CARxUTr5qTItaEi+MLCD2EY0M70FeOyjapFPFt674XAAFpE464sfCwRayC5NMbZACXUoU
	 UGexLkvFgNojPI29DgPeB0VSOTFi3jNwSNJKpWYIJFdw0YYkTVgQT8pCu86rN2/vUgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794406663;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=eW2UhyRiYSQk7BrcYmKzFS/v8E8s6f8Ay7GtoS+hhwU=;
	b=fuRHCJPYSabP7fMwwhQtL9b+9atq6/4zYYE7c2NiUcW3Kh9mtzVhTnXquDvTyGUR9KLc
	 7wrTkTIvmIQq3GR1lHPwwvlPcPtn669MAaG3pZU7iyR+YrorBbgKnA3NsVsi56mim9JTw
	 lv+PlgYXxBv8aCOCPq3kuxVjbAjZoYgihdaVIZ79eb4JOw71amNEcjtEbQBprjUTpqLN7
	 B1BvNc66jmXQXFZ+wtdzSX79+lW0GNjUFHqeDc3lAVNNozlzlG/aqFPtqfGx+mznh1fUM
	 GPIsFok5yI/+s7FXN3jCHInOe2AKcTZknNW8vYOEjRRkayeMVpHXhc1jrtBDBD4xIqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jKFpuinj;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=CGkqqwyg;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DE7606A327
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8DE7606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jKFpuinj;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=CGkqqwyg
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABCZIqK2975696
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=eW2UhyRiYSQk7BrcYmKzFS
	/v8E8s6f8Ay7GtoS+hhwU=; b=jKFpuinjau1zLYnX5zUchqtM3aZ6lC8IQXIAtV
	eyh/DxW9o2cfReyRrOJMmXrjbpvx9zA9yp/cT2fPo4290pTbJ/sF+DdH1atkrE9Z
	T9KwMi39K/CfdWgEjHmpWA02DI+lUSvCbi3f2F82GR4sH1j1b4aj0AEkRMEbgGOP
	leACprW7BtwR73xSGOtzjG2mWM77Dv/eBqQphtsSZr79BBmgybqKCTKzXDnCf+z5
	/PXdRoBfjJfxzVWRpYjtUPN3Sc62iuM0otkOIvbxT28qfRWf+927XkrSKgCDommW
	vZOdPjZK5wr64vPIJbiEPkAAq8bNqC9frQ2SMkK9SFBFIkWg==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hv97cc6h6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:32 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3763bd79663so1378282eec.0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 06:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794406641; x=1795011441; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eW2UhyRiYSQk7BrcYmKzFS/v8E8s6f8Ay7GtoS+hhwU=;
        b=CGkqqwygIBIMCyOf+eJlxTdMmBsxjwE2G42yybuF1qcHvvGp8KvfjIFiC2vvnjGC+M
         1S3RxvSmYYGhVrhU44l8hEjIPkdd0AoXcLC6n4BQgdwQtMqYRCc1QdkLxfeAaHcLNXSc
         JvVnnkQiY8RO3mt+ovTra6vLDtz/lyL4q8Ea1c2RPH4JTDZ9D1KboiB7WBDbDr7c4FF8
         htKWVLlVI/wNIhUgCtIn3z3zebTCf5JTifZIEpuCZS36TyodUQBfaEP4KAF9K3L6D8t2
         wkeFq5I9w2KzRLWfBIZ4I2EKu5Y9KiQdz0vkHAoOdHphbpYeqgYAAlGoJoKMXbjj6723
         B8OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794406641; x=1795011441;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eW2UhyRiYSQk7BrcYmKzFS/v8E8s6f8Ay7GtoS+hhwU=;
        b=FwpQBncoXYs/DB8RsrNgpWXEYeNyQEuJUAZ77xMcTHjIzdaNkL8YyvRi1y2cbdvK+U
         efJ9SgZMwMaUtkCf9A5JnEs5n8N9R5Qdp6Qu9AE5Gs23N2WalQiZN5SeEnF4EzYX8RyX
         d6/WVOAm8MgyFKCfgrNx45NMyqmBTX1Th+5x/J+BU6Pd9WsdywwiAwGUcSlY9KVGJvxT
         KnJdwCGI1iVrnZ7dpSgFflTXVDBqE7cuFQU/JT4ZANPTOi8C62zCuZFTKz9RTw+GjRYS
         tepcoo9jdY6JxT0cV4Se7Y+zxkP2E0YLxozLULe9YZtHpKVPywJ3iVP9fYVyTuLkypwW
         htSA==
X-Forwarded-Encrypted: i=1; AL+hErGJ/bCEOGQdGlxcxJEs9To10GxBKHQP/UQhahWIQKtEFtXbSSXsceKU/F9ZWBMRG5Go0spt+iEciLje6ng=@vger.kernel.org
X-Gm-Message-State: APuU4Z8o5uZ6/E/Hp85AfAQrlAmbQhECJhRSiFMBrmlFS4wzvgEC3Ee3
	pStlZYf1GaqF5YHO2Qa9Tudm3kzq+9mT+exN2YgG9lGvSzPCTkazunQKojts/S+IVFEFnUKsy7m
	2CDPMsliBMxGeqa/dFk6Aj/jhidd4QITcn1+tEBW6pFmlQQOkN3wt1oM0WcR1IQXLCMs=
X-Gm-Gg: AYBFou0FwbVB96qZPonwzE3k94VsTeiqJPb75otPuH1gh9e2gn9pqMVgNdQFRsJfhJe
	EKtU1Xr6mznVMXpEoHz8sukUnXHg3rsd3Z2/MvtWTBpr5I5/mQNQyiJgG1NphKagyBOGZpOKXGA
	CHdaUYmUSYX+6XUB9z1/BfeVSHNrhHgRRO3UCbDmjqjapV4AfsdbC8nsC6uIO0XMwD0u5/0tYbl
	oKBaWzHFzu4NqVefVx/eECXopcDy6osuX030VhvrkrFu/pBPLO/fkYAdFS52UMs8RSqCArvqt9J
	mt64DCtQOtsLA4Mc/dLeLoiFozZYcT3k5VBHspuxB1yafiYxHtw0pr5qse7j/iw6MWOB0EYn5c+
	vA70OtdYjnDpXcfUaLVfC/wgJK7LIHqcyLz5ub4hB4lFp5S+t9SF4n6d8YsYe2i6jBf4kVnQUsA
	==
X-Received: by 2002:a05:7022:ec04:b0:19a:8e3e:530e with SMTP id a92af1059eb24-1b3c02f12demr2549962c88.8.1794406640711;
        Wed, 11 Nov 2026 06:17:20 -0800 (PST)
X-Received: by 2002:a05:7022:ec04:b0:19a:8e3e:530e with SMTP id a92af1059eb24-1b3c02f12demr2549910c88.8.1794406639438;
        Wed, 11 Nov 2026 06:17:19 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2fc09sm33747063c88.10.2026.11.11.06.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 06:17:19 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Subject: [PATCH v2 0/6] Add support for a TEE agnostic Inline Crypto Engine
 service
Date: Wed, 11 Nov 2026 19:47:00 +0530
Message-Id: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIANx49GoC/32NQQ6CMBBFr2Jm7ZC2BAyuvIdhMZQRJhGqHWw0h
 LtbOYCbn7yf/PdXUI7CCufDCpGTqIQ5gzsewI80D4zSZwZnXG2NsyiecZIh0sK4MKMmj1T5vm6
 qhrisIS8fkW/y3q3XNvMouoT42U+S/bX/fcmiwc6UVccnos7QJagWzxfdfZimIge027Z9AUUog
 ti9AAAA
X-Change-ID: 20261021-ice-migrate-tee-svc-a5cd6959ae36
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794406634; l=5437;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=x2E2YNTKZj3RAxxnbF3g6SwjXlGHcONpTaIQkMBGS/8=;
 b=64OiN5sq39/G16H5ou1+rLokpwVcvzrkH0yaWTd8gn/Ai1zOhL8xzA2W3pLJfDv644uNNdwMG
 1/80Bm4d5mJAbnTJpH7f57ohtu6p4Vn+HnsoA+f+UjMIwlzUsxVELm0
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA1NiBTYWx0ZWRfX3XrQb4vLjLAf
 d2JFlBNa938KHJZGIF9ruBy4Fdx4SPJzbK6qPtop69j5YNpvFbwpOXL9JYkvAks9uKV0Rdf4qlh
 Fs1lKWFiZG/W6Rs+StyxgS41h3sODEHbxupT8V4mh5M9/h4dyOI8GqxZbEdi8cA7BP5FxJ2SHSc
 vU3N+TAxsCV8JB7IMfFiG25hGDq6TptUH3Nt+pIOxjS0s2cQsj9KZy9Ct1gxgEFj3qwwu9SbQ9x
 Pppq+jzXrWgyojAt9+1f/SJBlbeyYG5ExiiKEEu+TgacSNYp689Xqn5sfWSJqZBGkyZNUAUUU0x
 QqNmXqUdlFYr9taeI1fEIxQ6r1N1ceHDAW1t4Cvl8vqbNopunBshAlav9VmthGZJPH6aSHxygUi
 6pc5+iQ8NjvDdgQBxtcj2J0MeuiLcqlfmh23gEOthTXsvKYtT2rQ0SOsMNQRgcWOnDHokhMaoU8
 DK8TVWfJ5pqzCbUDRYA==
X-Authority-Analysis: v=2.4 cv=cJl1IVeN c=1 sm=1 tr=0 ts=6af478fc cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=_EMmJvYMAAAA:8 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=ZDveMJu3P3cY9s7oh3gA:9 a=qcg49hLlgF0N60+LroqrWnV/Vu4=:19 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22 a=emCv1hD2LFd8cNRmW21v:22
X-Proofpoint-GUID: VnVxRE0ddxyEyoXcPTlQNqcnZtP0CCoV
X-Proofpoint-ORIG-GUID: VnVxRE0ddxyEyoXcPTlQNqcnZtP0CCoV
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA1NiBTYWx0ZWRfX9MtyEO1x339r
 lAwogHXyJEpFK79Ms6L2S3h6NFQqQrhzOV/A5pKwtXasgdqaMu6NQ7HiTg5X6GkGOWNJn5OmqlB
 7UneWyGD14rn9FZ9l5fYVUkofymGPi4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_02,2026-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611110056

Qualcomm platforms such as the IQ-9075 EVK now boot with both Qualcomm
Trusted Execution Environment (QTEE) and OP-TEE [1]. However, the Qualcomm
Inline Crypto Engine (ICE) driver currently only makes SCM calls into QTEE.
With the arrival of ICE support on OPTEE [2,3] for Qualcomm platforms,
there is a need for TrustZone (TZ) agnostic APIs which re-direct the call
to the correct TZ at runtime to request programming of the secure interfaces
on the ICE hardware block.
    
This patch series adds such TZ agnostic APIs to the ICE driver for
requesting secure services from either QTEE or OP-TEE depending on whether
an SCM driver back-end or a TEE client driver back-end is registered with
it at runtime. This series is logically similar to the one introduced for
Peripheral Authentication Service (PAS) [3] which was recently merged to
provide a generic PAS service for both QTEE and OP-TEE.

Apart from introducing a TEE bus based client driver for ICE, this series
also adds support for optionally registering a TEE device which represents
a particular TEE (QTEE or OPTEE) on the platform bus to enable drivers such
as ICE which poll on the availability of a TEE interface to be notified.

The ICE driver is an independent platform driver which polls on the
availability of a TEE interface (SCM driver) before checking if the ICE
secure service is supported by QTEE by querying qcom_scm_is_available().
The TEE subsystem currently does not provide any mechanism to notify the
availability of a TEE interface, i.e. whether QCOMTEE or OPTEE have probed.
Without the introduction of such a notification mechanism the ICE driver
would indefinitely defer probe until the OPTEE ICE Pseudo TA becomes available
on the TEE bus implying that for OPTEE builds without the ICE PTA enabled,
the dependent UFS/SDHC storage driver will fail to come online.

The TEE bus based client driver introduced in this series which registers
with the ICE driver has an ABI with OP-TEE that is 1-1 identical with the
SCM driver's ICE ABI with QTEE. This is because both TEEs implement logically
similar drivers with the exception that OP-TEE currently does not have
Hardware Key Manager v2 support and so the inline encryption functionality
with OP-TEE is currently limited to Qualcomm platforms with only Hardware
Key Manager v1.

Validation:
This series has been validated on a LeMans IQ-9075 EVK device by attempting
file system encryption via the fscrypt tool.

Merge Strategy:
All patches in this series except one touch Qualcomm firmware and soc drivers.
Hence, it should go via the QCOM-SoC tree. Request the TEE subsystem maintainers
to provide an Acknowledgement for this.

[1] https://ldts.github.io/qcom-buildroot/index.html
[2] https://github.com/OP-TEE/optee_os/pull/7906 (In review)
[3] https://github.com/OP-TEE/optee_os/pull/8137 (Draft, depends on PR#7906)
[4] https://lore.kernel.org/all/20260702115835.167602-1-sumit.garg@kernel.org/

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
Changes in v2:
- Merged the furnctionality of the middleware ICE service into the ICE
  driver as requested by Eric.
- Introduced tee_platform_device_register() to fix the issue of indefinite
  probe defer in the ICE driver when ICE PTA is not enabled in OPTEE as
  pointed out by Eric.
- Fixed type "Psuedo" in ICE TEE back-end commit.
- Fixed space based indentation with tab in ICE back-end Kconfig.
- Ensure tee_shm_get_va() failure is checked and ERR_PTR() returned.
- Validate out_shm size everywhere in qcom_ice_tee.c
- Zero the memory holding the key when TEE invoke call fails.
- Check failure from qcom_ice_tz_ops_register() during probe.
- Cross-check out_size and lt_key_size in qcom_ice_tee_generate_key().
- Always return 0 when qcom_ice_tee_probe() is success.
- Did not collect tags from Abel since significant rework undertaken.
- Link to v1: https://lore.kernel.org/r/20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com

---
Harshal Dev (6):
      soc: qcom: ice: Add TZ agnostic re-direction functions
      firmware: qcom_scm: Transition to ICE TZ agnostic operations
      firmware: qcom: Add a TEE bus based ICE back-end
      tee: optee: Register TEE devices on the platform bus
      soc: qcom: ice: Migrate to the TZ agnostic ICE APIs
      firmware: qcom: scm: Drop exported ICE wrapper functions

 MAINTAINERS                                |   8 +
 drivers/firmware/qcom/Kconfig              |   9 +
 drivers/firmware/qcom/Makefile             |   1 +
 drivers/firmware/qcom/qcom_ice_tee.c       | 443 +++++++++++++++++++++++++++++
 drivers/firmware/qcom/qcom_scm.c           |  90 +++---
 drivers/soc/qcom/Kconfig                   |   1 +
 drivers/soc/qcom/ice.c                     | 173 +++++++++--
 drivers/tee/optee/ffa_abi.c                |   8 +
 drivers/tee/optee/smc_abi.c                |   8 +
 drivers/tee/tee_core.c                     |  21 ++
 include/linux/firmware/qcom/qcom_ice_tee.h |  10 +
 include/linux/firmware/qcom/qcom_scm.h     |  20 --
 include/linux/tee_core.h                   |   9 +
 include/soc/qcom/ice.h                     |  56 ++++
 14 files changed, 784 insertions(+), 73 deletions(-)
---
base-commit: 8f7df005a7564bd7ffa75da9c3085d5b996f1e16
change-id: 20261021-ice-migrate-tee-svc-a5cd6959ae36

Best regards,
-- 
Harshal Dev <harshal.dev@oss.qualcomm.com>

