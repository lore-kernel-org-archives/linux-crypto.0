Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792662724;
	b=sKxusEaJnuLYbmYBmFvUxy7eAlhbN//K+2cOFYi4JWwhPLawRd+nGcFMmZ/XMZjFO4lZ
	 4rSW1i7vpC+C0F+rsbQxOly3PfJ0+45vdjXlvz3emfh7QNholNDMnMHXQWBAONKAIs4kj
	 wnSCWbPIOo0sG0RVprAzryBHfyjqf6jMEG8kCxLtBHZJfoke3cdsTfCs4Kk3iIAwyQvCi
	 wtWXGTUU0Vkh7WbHImwm5TgWIpvtV2HLfffsXe8WFDAjeZULIeR+4Pb9LK5bra/oDQwTX
	 45A8Gd1hnAQdasWi0wgU4FFai3MEhkb+CR/DysfJaF5t38+E1yaw2qEiB0qVBdC7bnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792662724;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:
	 Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=ibZbAM6mxwTviQGJE6mRb86msHnx1wYpor8WMO/JeSc=;
	b=ZgsBAjo4mclmtbm38KSDdqXovnlj+F1yIM8kV79b1badNNbuoYNKJigN/gBOwa0rIC6R
	 VBORmZAe2kHZKa6utIt7hlfJpH5hykRHPiW1M+UkZJ+0VkXQE5AJ4jwFkJDSqk5YILj7j
	 8ZBX/7SCEELMUtOddWu/fmGy72Lf/G9acdfZ4Yk3axgMZxH/IObW3Ij/OwXxFs+CFkDpT
	 H2ukOj3MRRFDwuKteoQX8eDA02T/Xw28PKrQ2DNwP1Zq+CoxiL/njZE4/LIGua9jozuOw
	 cOfBmcteSFsuAdzcaYHXS4wZc9PLUeEmzoOhzCJwLABxEv9sbN0eULqLb6Ta6auJyWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=C7Xzwrny;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SmUBGrpg;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26EC606A31D
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:52:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F26EC606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=C7Xzwrny;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SmUBGrpg
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M9mgX13968831
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:52:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=ibZbAM6mxwTviQGJE6mRb8
	6msHnx1wYpor8WMO/JeSc=; b=C7Xzwrnyd9b9GwslpMsBv5OubS0kInrGpENouM
	O6O3cNuzljTdAxD09OxwUiu9GneqxHbEdsZjGn+jfoKED7NRGKTKE2fcQ6uk2aU4
	aHOx5/8peflJn1j+eN+OtdzZRFVnGN402bn2b01qb0jENTsOk8cFPAKUjrA9M4CF
	nS7R/CdRSOAi8y1VzfipC/szB5xyyTx0ARJsDnGY525C1AtpcvGwLttpLkH5wX4m
	EqH7G4D841pyLMsaPNtpE4lRa3bYiFa3bqh8MiIBBpVdm58gp93QijbUw3MKu+Ym
	d1QydRW2CzCnCszkW12IbKIYFmwBjD0AZ/iFiJJApc2T4O7w==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93c9r0c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:52:03 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-35c3c370b17so2807586eec.0
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 02:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792662722; x=1793267522; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ibZbAM6mxwTviQGJE6mRb86msHnx1wYpor8WMO/JeSc=;
        b=SmUBGrpgJUf+Tq9+aT80UlaXIpb35ocvWF/8JPjhbZZwzP5H1GhnQn3w2vKhsVB9aW
         mwML6HYM43P939haimf0VL4Z/F3Snrw83eywgLTyx0w6tqQ9bOFfqjMmEhfqak4llGxa
         sUGAq017CS18nXPZz4rfLqj41UdNuxNsCcOL5CwRFYacvVjjz+lPIYBQPSg+KDC/UbIJ
         zxnHu8nxZr7BOp+G8ZeMhD4kSm0jq8qNpWTtmr+XaU8W/lJ3nN4gAYzhyOae8XpS2pPV
         zOAmzanlrWrLyi7kDs5ulX6mllRZVUr+Owr98kqBFzA1rZfC5aZD2n+6bRg8sq8d47hf
         2Tug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792662722; x=1793267522;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ibZbAM6mxwTviQGJE6mRb86msHnx1wYpor8WMO/JeSc=;
        b=J+ivjnkIKqqhytEXXmaib7SpqQr3cH6kY0Hy8Q8S6KL+E/mLb4A1pHJSmWKYlqzlYD
         SvBT0kF6K9hfHQGAG3mGTYDNp7pwHZzW6aKPXjmW0msjKdBzLIuQT6+I/KOwNjtgMaTf
         vk+FkC9Ki5zzpgzggatugYmxFokwO6GV0XqEXU5nnvJ+HZL3fAS25xTgLa6j9jHMcbCp
         YlW6v1tB0GExCRPXj++iJf45QsQvJTgDjbRvkjxHd+I5IGDv432eFrpZ2KFUZMtVqEZz
         yzuOSabtau25No5GrRLitqn3n+c+xivRCFEvasCsvzj1cj3ypKEDJ9XdhjLF1z7xQ6pB
         nayw==
X-Forwarded-Encrypted: i=1; AKwUvBxNFe5YAD9ajXQDSE6Ixr8cLOt4xRtSZhjxpxsQh3BR3tbZkAL8ouJsowxoAnRrziO7bEl+clwnqcVYy2k=@vger.kernel.org
X-Gm-Message-State: AFq9FYIw6e4rbK65RydTfe8qS1CNGB8MLzJNN74aIFK5lfJebIURKX/X
	EvPmr+WyWID3tvDX4N38kGa3iogggsqfP6hV1nsTDRak8Cg4GOCM9WOMClWqg5Jm4qk2t4dgNVH
	gQgU7xJThsdy0bPvoTeRa3ESNkkLJdHTmhz3JCb7J9aPja5DPO500HXLUTlTvnjdpMiw=
X-Gm-Gg: AYBFou1iAlQfuL0aT4xOc8CT8d7YP2e/Orl8TZLfNehKSPw7MixCg1TmmOUCLCh1r55
	PIai0MKAHR3BSvyh4Mr5+e1gpKOc+yWh38A0G6/sy6LrOfBZn0vWE8IX/g+l95Y/5uMp1Wra2we
	ta5uqhMpTyoCABWdlEpPGxxCZ8Z9y46FG/eWtbUGAbQeeUuMhIjhovjiZaNSsehScO7I6gyZ/Uw
	R7oluPiU8KTKnoSHb76+8F/NZT7RNn/B1x9AYUEDMs3qKxSty81k6UGS94P8MaKewj5B1T45rWh
	MMwxdSB9BxKBMsFrt//5yTh7lLxFkmDCqyk0YoUDnfDX4WHrqAJUgJU4OoKsrpzsf72PsqI6eE/
	Ju0msPliVlK/C9m8lp0ewCkK0HxOskQz0
X-Received: by 2002:a05:7022:f512:b0:187:efba:9ba2 with SMTP id a92af1059eb24-190a84c55a9mr4905142c88.44.1792662721999;
        Thu, 22 Oct 2026 02:52:01 -0700 (PDT)
X-Received: by 2002:a05:7022:f512:b0:187:efba:9ba2 with SMTP id a92af1059eb24-190a84c55a9mr4905106c88.44.1792662721247;
        Thu, 22 Oct 2026 02:52:01 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3673e153519sm15742170eec.3.2026.10.22.02.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 02:52:00 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: [PATCH 0/3] ICE: Enable runtime PM support
Date: Thu, 22 Oct 2026 15:21:49 +0530
Message-Id: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIALXc2WoC/yXMQQ6CMBBG4auQWduEDmqCVzGmocOPjpGCrRASw
 t2tsvwW762UEBWJLsVKEbMmHUKGPRQkjybcYbTNJi75bEtm85ahdypwY+8QGv+CqeTUsvV1jSN
 TDseITpf/9HrbnSb/hHx+J9q2L2ZT2vp2AAAA
X-Change-ID: 20261022-qcom_ice_pm_enable-3c5d21b99e42
To: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAzOSBTYWx0ZWRfX7JS8A4UqiQIY
 1ha7AJcQ9KO1uELccJnwssEvdtZq/uM6NY2lcZE2krx6JrkDXh/vw/7pS/LZrxGlp1PTwmMdbJ+
 zw1JTSOsk8bUwdGHZzA+OhDASfPfQNA=
X-Authority-Analysis: v=2.4 cv=ReAFmFtv c=1 sm=1 tr=0 ts=6ad9dcc3 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=q2l7TY2mCMnZi5pTjLMA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-GUID: 6K6YCU7kD9tZtzzAdGysNbXX0W7GPc4m
X-Proofpoint-ORIG-GUID: 6K6YCU7kD9tZtzzAdGysNbXX0W7GPc4m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAzOSBTYWx0ZWRfX+/OMeEhhBEuL
 /iObGimidPq2Vfa2a1euc85fL46CqWqUSOHDWG9thP2yvH9AR9sTvv8DvR70+FA444RxVSrAOyM
 acaYqymP9hOjI7nAAovjuw08kpQ68baAdaz5p3vm1rG1wFiHo+Z6bBx9CqzJGjJ2QkNWApOfs/g
 hsq18DSyb8TiyapNID/C6aliiRGBP4TWQ60SxHu25Y8ON+wJk/l0xjDsJxIabxGRdu2penQIOsQ
 qH7tdpda3lwMnJFqGVlrwsFa1ZUPfjDhGUHkriNX7fc/A1SEPO8JR8A1aWkSnfiSbd2VFHo7ZXg
 /vrUgqTiaUGl0tzc8YJd7f1y4ZEY5VuHOi+3WwTsVxJNKcPGHVaIrAtC52tdTVtjiM2Vi2I0FQA
 NWb+WAf4hKJDuRQ1osdRpBMtE1tp4R49krroUMrjYxhnuP4Y2+rKtHuOG6euhDeQdaiubpHeHLC
 BvcZ4qV+//1US/wEeWg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220039

This series fixes ICE clock lifetime handling when ICE is modeled as a
standalone device and referenced by storage controllers through
qcom,ice.

Currently, ICE driver enables clocks during probe and keeps them
prepared after probe completes. This keeps the ICE clock voted even when
the storage controller is idle. Add runtime PM support to the ICE driver
so the standalone ICE device can enable clocks for probe-time register
access, then disable them and remain suspended while idle.

While enabling runtime PM in ice exposed couple of sequence bugs in
storage drivers(ufs and sdhci-msm) as any key programming call used to
go ice and never complaint as ice-clocks were always on.
Example, unclocked register access happened from ufs/mmc in
qcom_ice_program_key().

qcom_ice_writel(ice, 0x0, QCOM_ICE_REG_CRYPTOCFG(slot));

Fixing this issue require ice instance at early ufs/emmc probe so that
correct sequence is established and ice is ready to accept key program
calls from blk-crypto or any explicit storage operation.

Merge strategy:
Patch 1/3 and 2/3 are storage driver fixes and should be available
before patch 3/3 lands otherwise will result in bootup crash.

Validation:
Tested on shikra-evk, kodiak rb3-gen2 and sm8750-mtp.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
Kuldeep Singh (3):
      mmc: sdhci-msm: Enable ICE before enabling crypto support
      ufs: ufs-qcom: Enable ICE before enabling crypto support
      soc: qcom: ice: Add runtime PM support

 drivers/mmc/host/sdhci-msm.c |  21 ++-----
 drivers/soc/qcom/ice.c       | 139 ++++++++++++++++++++++++++++++++++++-------
 drivers/ufs/host/ufs-qcom.c  |  29 ++++++---
 3 files changed, 142 insertions(+), 47 deletions(-)
---
base-commit: 9a482184d910775cf648863148944945b74e2815
change-id: 20261022-qcom_ice_pm_enable-3c5d21b99e42

Best regards,
--  
Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

