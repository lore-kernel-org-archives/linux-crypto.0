Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777133E0C69
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784277416; cv=none; b=NQXC/yXXNuwKZXPgHl8me/OPb7iRMCO03KRYz7fUxyJ1NWLVEP7muFu/Uu6vEJLxEOHDdfN557q8odmQDoE8ge+andcTknwgHjnxtUQ90bJcvZWzlbf9vpA/XWerdaLrsW2Oy1Pnnq6YsG3Xvrp9VGCG2cD6f4TIfK6jIeCdN0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784277416; c=relaxed/simple;
	bh=4rg48NDemzg51/IQMQpCHk0IqY4umKmggiXS39T6YYE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=HWAeh2NqISu9Ff2+Zd0e+L5PnQQoNeiiaVgOzlmHe76l9hw+7XJrvngD2lrFQSblRq1eHrBQQ19JrjvLMMjYDZj7OLKaZgbuJoMm/L4GYbXofEmdo1vgWUbh1QUXS+zpA0Ywf1q9Aa7iZV0f+JyCrNiNkX5OPSCvfH+UJ/FIC3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RXdBJP/u; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GG2Tp0UB; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RXdBJP/u";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GG2Tp0UB"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66H6cTVu851698
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:36:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=Ulbk7SUBqC4271pDNAelJS
	LWuvYZmid0i2ru9VU0c4I=; b=RXdBJP/uthxsyzVrzvaoT4WyK/dJpgCMw/QaP4
	iEe/N+EevFv4EnxfRM9kyqBj+c2HWTM5UfhbH/AGWZ+L2CU5Q90MxGUu528/mgTq
	BsWu8HPUVW8fJANo9bKxY6/Wfh3udUhpKKLgx+FRMX25yWJ+I9806vG3OUTpWxNI
	qC3S+QD9zwAfb9dGpuoaC1QNlrjrLTWjnEcePd5RbQNeSohDENSXRQsrxc++mnZ+
	mfJcAUuZACP6Ue0Av+MqKkc0rVlKDjUZu2EO5gE9LNnIb1CTE+0qjUcnVpOltcaj
	w4D6jplDR0c/qlYNJP7oRCHriFYgQi44WWi630kBNk9YtNOw==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fff9p8ej5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:36:53 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51bfe3fa93bso155105541cf.2
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 01:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784277412; x=1784882212; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ulbk7SUBqC4271pDNAelJSLWuvYZmid0i2ru9VU0c4I=;
        b=GG2Tp0UB2sovozsHB0JKaIWuP8XFOXG4v5UnUEmN9ZzHiXpB5nzZL6CqWRbWnVKe80
         8fDv+c6QvjsByCwvlG58nWCjMOjA650YW4UZ2zqePSnX+n6Dex4QhxLmUWjopu/DJ6YC
         m1lWZnz6z/fhAoWc50pi4t5jQchctXM+odm5nuCTR2CsNzA9rFEyMLBAa2tzUiR1sTA1
         1lSv7ReMeh6Cfz2ZRwAciiL6RFQhF+MqU7JXwmv9EcH/w6rU3+hZfMY9K0Ag0VkhTAUw
         luyVG0B4KysbIDXt6Sy/pN+2cxu+rwdhDergghfUMfrHkL8oSRtlrQ9SUGiv8FQnTxuf
         y4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784277412; x=1784882212;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ulbk7SUBqC4271pDNAelJSLWuvYZmid0i2ru9VU0c4I=;
        b=cDk7Zb8qHCImRPFGKs7+aYl1Gi/QoM1OgYFexWRltMSofeZeKO7HPoZQ2TL59CDuUu
         720RDegOagjE5qW4iI8AE6y94ep/wBkTIOXQNodkoDgNeCxhExsvnbiSr4NFyi7gBl2f
         ehpm4lpLeS2BEPcSWP9n65beGSLkm09VqvXz4LALyyIwCsOf9pNrnI5+KRwB4z/ROuEC
         uaAOqhjgV8i2w27jgzS78F5Gg6XfuK87oOmXD8Apm+DX06yX3B0A4capc47R6dhrbJvY
         DHLe3GorD6Olg3BhRRLhOk2Kfz+tPTzA+Q0pqN8dM+JaU2y9Iw1FrvOHeU5knitCq81r
         DrRg==
X-Forwarded-Encrypted: i=1; AHgh+Ro45uaE41S4gXOOYk4Dq7H4axxrbFx3XkJjOpO/0A+Pe6FMMbblu0gL+czNcfnyhczFFO8PntJQz+LPEyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsF/1aIpo6v9ICBuySuJdiw6eie63PU1Ghxcm/XrmsKjSQ0IB/
	grE0DI2iO7e+/wt2R+IfqCXJ1WriieIQSaRn2Y5l/IaNxW+nDhhHl3bgbRPqA2bS156f7Vg7h/g
	wc1es6xrFRWJbV62ebkAV+MBDEzXAfUs8LcRBW9JDGUXRvAdrebT9VYr5fk62P61xZcs=
X-Gm-Gg: AfdE7ckS2YerPQQleWJqYLK3p14b+WCsjJn8JStPCBGjSRCfD1LsVyUHiIaFCtMgh6n
	XonOa2vYYMhDDNdIcZoOl5L6shudrX9PYbkBdDUlfj0ver+Sa/KBXzuktzmYiHjh0x/ouEYdpSM
	XNJ0b2hCh92sMEsdNfvtG8LmE/HBF9bx5Gm062xboZo4o4qJW/uqjgkSpShIKUPHuem++VzcbD9
	FtuEB1sJBwZrmxAZ9zDQu6OsT4ZnMQl3+7E49E7PByDlPxtL3NvAxjDUO0V98VhfVF4G9chKE2C
	uVyVzOAQEiwSu2V7ALQrsRW4biBJuMQpGOg8pA28w4PXNGoLsICfmuehaooMUSiWoyeUz8hPqzU
	GRtCxYRoVjJHtvUqCI+hWfng5F//hgA==
X-Received: by 2002:a05:622a:2596:b0:517:71d2:37d2 with SMTP id d75a77b69052e-52138ec1feemr12570071cf.0.1784277412341;
        Fri, 17 Jul 2026 01:36:52 -0700 (PDT)
X-Received: by 2002:a05:622a:2596:b0:517:71d2:37d2 with SMTP id d75a77b69052e-52138ec1feemr12569591cf.0.1784277411713;
        Fri, 17 Jul 2026 01:36:51 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dc44:5b1b:5396:79d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2b893dsm31268205e9.8.2026.07.17.01.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 01:36:50 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH v22 00/14] crypto/dmaengine: qce: introduce BAM locking and
 use DMA for register I/O
Date: Fri, 17 Jul 2026 10:36:26 +0200
Message-Id: <20260717-qcom-qce-cmd-descr-v22-0-ff0d18b27246@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIvpWWoC/3XTS27DIBAG4KtEXtcRDO+uco+qC16TWErixm6tV
 lHu3iFqFEuFhZHA9gcMP9duztOQ5+51c+2mvAzzMJ6pA/Cy6eLBn/e5HxINdMBAcc5Ef4njiZr
 cx1PqU57j1EeVXeAcs2auox8/pozD9119e6f+YZg/x+nnPsliy+iD0zVusT3rc0wpehD06N1xO
 Ptp3I7Tvive4lYG2KrhyHBeoYFgnQH4Z3D2RIC7KsIZKYgmy4Am+SR34zxvL1/+SB+fttT8Wfx
 haSYY1C1OFjkcVQrSMmhZsLJoAVULyBLOojAIOiNrWWJtmbolyGJO2xwk2iibllxZIOqWLPWit
 x4lnYxp1ks9LdmqlyonaIMSmtMJJNOy9MqCxh51saTCxKPHEGLLMk9LtTJhyFLCK6ckl8G4lmV
 XFjT2WJLuHF0rBzp4bK7Lra36peEl8cxKA5hiQOkbFrCnpaG+Ryi5Vxo1hd7KyFTLWuXe8Homo
 OQ+RFBWZE7Lq1m32+0XxfQVWYoEAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=13771;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=4rg48NDemzg51/IQMQpCHk0IqY4umKmggiXS39T6YYE=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqWemQ9FBskN+TOPZmT76gO+3ReVMfoNKGoNnSu
 pVXVKvuRfWJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalnpkAAKCRAFnS7L/zaE
 w5roEACKj4b8V68O6GAJF1vv+DfYnqeDSo7QkZEMBhLevvk4/jIbiwGwFcwpcaoU1PSzNh9vHc5
 F3zzf5EW7bcKcfzsT+5wgLVik8XZef+kuLbtODkOhWLDPgTby748Tw2qmFCQ6q/HTZOIq9EeXkd
 4fEdj4zLVqYWLkB+PTuMnEFd7aKeg0tFlj723XNKLYH4kKBgp+X4QQu94HnJAsuulfsrm8Jhi3+
 UO4k4tdFeWt6v56NwjkWz6p+srQiNIJNxB+dvpHjlO3HDudb3pz88Yc1RkkMTmnuZK2k1roE/gl
 yXSsi05l01wJYmWqaR61sJIw9tLIaN+dD5Hv8/dxcRrDkV+3ya526z1pT8l4xA4XNw7DLEgEJKs
 nHvv8yxBIthFtApSaJDlfV+kcLKeHzZXkUFZAn2gWacSct5hlrDQ5XeX7Uu82D5s390uCSlnx5u
 uuJnBSeLowzcFykDthfvnr7RdIK32EwlYvpGVioZw1BUoy6B5i6By5nMMLzJ3k9btgXVmgGS5Ay
 DbaTOr48GyRy0QhZ2CkU0GOO3XZ1i15HIOYfPfb/DNMGc5mbpAQL6F787oa5Nc698zAhxzYMl+N
 tDigqS+zxL0XZdSRxgkvJlTcFVXSpeefSe2mN++raS/tg1hzUvM/s+8tCVkC5MBmnEv0IPXtUaf
 Els6Xxq7lovm7ew==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: 8zTqEMeqq9jCp3A--WTfFcPWVaGqpKPE
X-Proofpoint-ORIG-GUID: 8zTqEMeqq9jCp3A--WTfFcPWVaGqpKPE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDA4NCBTYWx0ZWRfX3XfbNdP03mqi
 w3pU6s3hgYR0YSeRlGaLnzMPpfVEFEXHV2oKYH23TdSaDaf3FiCl+5DQeFsGmj9FWuTNiMPk0iy
 wPA+j/NvUAlhwyKOCQjD9TMkpuL7SRQeaspq4mwnMluLPc5tJZ3cvvHd2egDKEz3xGOV3Vosq9X
 tlxXVZegictFy2cOZNW+xFwqsmULqBxukaLHVzQZuNaGaomSmkLxx73xWkX8BApsTdAG90+Mu+/
 F9dqk7KOLmcyszVPCGa7SZqD5AhzpyWOQhprggDvCEsF4rnJIuABTqcwn+K0HraAIUHltU+dz4N
 2fq6sevThrbh9z1q0YzJhqvbbE2kx726EeXQ47wdZOOSyzdxEzmseIHLkJHzSD1dYUatnHuJtFC
 nkbd8z4IRHAvvmRi3Sx42O6ClY7yiiXT/emE2bA8DK7I0DJkDvVBCM54BHQDBH5RDzSvuyBdyAn
 3p2BvIsDfNeOWz7Z0rg==
X-Authority-Analysis: v=2.4 cv=TaqmcxQh c=1 sm=1 tr=0 ts=6a59e9a5 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=bC-a23v3AAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=COk6AnOGAAAA:8
 a=nO133AHVhrog2Mm9YB4A:9 a=3Q6GwuwGmGBF1VFe:21 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22 a=FO4_E8m0qiDe52t0p3_H:22 a=cvBusfyB2V15izCimMoJ:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDA4NCBTYWx0ZWRfX6I5FkeFnts7s
 lyr8XTjWa71KqJKHmW/Ljgxv6W729dA2UlkOf5RL+ooVYcdB6mC4RX7hcdOzyrw7+g11ypR5HSC
 mqY1uP3oaRoODX1L1BzPgX4FacxIhFM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_02,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170084

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
 drivers/crypto/qce/common.c      |  20 ++--
 drivers/crypto/qce/core.c        |  41 ++++++-
 drivers/crypto/qce/core.h        |   7 ++
 drivers/crypto/qce/dma.c         | 175 ++++++++++++++++++++++-----
 drivers/crypto/qce/dma.h         |  11 +-
 drivers/crypto/qce/sha.c         |  10 +-
 drivers/crypto/qce/skcipher.c    |  10 +-
 drivers/dma/qcom/bam_dma.c       | 250 +++++++++++++++++++++++++++++++++------
 drivers/dma/ti/k3-udma.c         |   2 +-
 drivers/dma/xilinx/xilinx_dma.c  |   2 +-
 include/linux/dma/qcom_bam_dma.h |  13 ++
 include/linux/dmaengine.h        |   2 +-
 13 files changed, 453 insertions(+), 100 deletions(-)
---
base-commit: 9c2d57db8bee1d5603f98c1a5a510c2114fb0d26
change-id: 20251103-qcom-qce-cmd-descr-c5e9b11fe609

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

