Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E2D407585
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 15:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772467061; cv=none; b=Rkm2euF+PQAvhlbqfNs1g2uSyB+bkWRKW4rFlsdlQAKEFW4e8+UNgNwiz9Ujn2NOSE9ohe6GOhSo/f1r58W0uKRwL98+/dPaFf9EfJMq/p1kya4BwJm2sYyfpZZqnxNLZR4joFynbXx/Edl3j7yZZYwtH1UDidDKntT7CmwPGZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772467061; c=relaxed/simple;
	bh=+rsIHYxr7aRb0VlKhLNY3E/THaFUhgQFWmdMPoaFtxA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=K3NQYUwj81Hk7sjgidgynSbiCYVlssAUqSs5s42GSSilqyiua2nLUB7kaNQ2icR1Qx1/kH8LRGywz1qdyiUgNnsWoROlMh5CT3dzgEcwU0fQTHWyJOCXstE++rQNFiblZJy1w6hU7QdyKNR3bDLOw2Qzb00y4kcm1XDh/ag88h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VfNmIN5R; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cKU/wrpU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VfNmIN5R";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cKU/wrpU"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6229K2MG782713
	for <linux-crypto@vger.kernel.org>; Mon, 2 Mar 2026 15:57:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=UBPVifjsKpJfcJOnzKb3B9
	AUl4kCX8yoGo6L+5eqGYw=; b=VfNmIN5RgI2qWvg19okagiH0V3Bf9JU7swDZxG
	zIzlSQKmBsUFxZFI3ScqgBSpZu76DLsZ+B/24a3Xm+oI0PIksXXToLoyI56iHwE1
	i4CeiMALgItibO/NepcNymXwbml5nj8wWoiCYVg/QsmAChs/vPJC8ZeG+R+VHi2U
	J3YA4j01b5yLMrcmDtlAKC3GLPdDBzHaTeoZAAuIlsQGAZgcO/HzztQQe2fRj7tE
	eD3sn/jy10etmnlaGDu/TuBIPFDvyFMg++F1i+ChPwp1zWQ4OO2NupHJwZHrEujq
	P6kORvl8fy0KvKzalVMTM/Illq4CkYyfDkJSwNXOwNGIyZrw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn7u01b6u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 15:57:38 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8c711251ac5so3373202685a.1
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 07:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772467058; x=1773071858; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UBPVifjsKpJfcJOnzKb3B9AUl4kCX8yoGo6L+5eqGYw=;
        b=cKU/wrpUZerHCu1Pr/zBZVRLJU8nWWrAvBVXsBMqsEU8Ql8NwD0hsRWQqdlT+Pd6Tu
         Sb0J/ehqDDrSYO/p/aG+VYZ6GFmGJM8Gcok3Bwu554P5rdLjkTfBTH2CJiVvxyb25EOj
         4AAF1vbVfnJ6LsmFFxQY1h9TOmkZ1P2+ygx2iWgjTdW4wT4KR+rzboa7RxmcIFN7g9S5
         OUmazqZ0PLhc7cqgM6B/3/PI1/RVJUgnnLcsmoxSfcmSHfQL85fbVANcfNlwY+zZjUyI
         Mrox8AOMrxzEXqv5+KHLcH5Sw0XNezWL1AIcBx3YAUctHhs/B2OkXSNyMUwXyDAUMbNo
         FCdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772467058; x=1773071858;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UBPVifjsKpJfcJOnzKb3B9AUl4kCX8yoGo6L+5eqGYw=;
        b=d4MpeE6VkGU33HIOpX4SfzxKuE0P5fhgLCMXKZmhnWGAPyyhfIzptFaWwamvBFtPNk
         fmqHxWU4Zs6kK6aECqlEhhBO4Lox+wIgFZrkbM1KHcNWwqFtLx07Q/grfS8ei6BSZPHB
         Xy7Hv9p7psbhpbhRB+niwKy7dMqwd//O3N8nHjdsqJc+9oztR8kM4d0PVE093QHbpYxm
         CfvS8JvY88PbFWEgK/gm4J2s3cF1Uzqihmeh2Jd5i7G0k8Ox2y1nwHIurbzd3f7lHtc9
         7cYSIJxMYQ4ve7n5S1/Jk6DtBVXmvU0SUiFpiWmhNhbKANWF9vz8wD5XI/rK6ZRnRqW8
         rvLA==
X-Forwarded-Encrypted: i=1; AJvYcCUhPfl8xs2vajeumRO1KP52ThIYbby+CJy9wrf7P7Wtk96IjnU89Ju3xrsROMXyIDncSOYXgsBXufoOz/w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKFpFzbrbq2DWV9FSgb/SeekAtPWBZtA8rM4W80HjjtOFj8HoF
	cK+8nMJ/H7hwoDFKDIuAtRZEX7/Cm9jpdFlOy6MLbqjVRPPkH8GBuh01Hf9PoTozKXXm72FjttB
	irt5ofeARPMPlAoXS330hbbTqVHoDlAhg+oSh1wGBUiMiXSmG8iifIE3zwsi2mdcktSc=
X-Gm-Gg: ATEYQzxURih65GBIXbKF5TxOAcQ0qyU2VVPrY/oXW7U9ynjUBuhtHjepR/vmStP/CcV
	NoZ2QmTGO+MuByUL84katOMPpLUrgBWCd1StBZ6xa5RORtwO/VmKA517swZYwjpfjgP1G7gMTBO
	2YLIxn2iEZksXxQW2fpzWkaE6qnBmd6RGN2tXXmbK7x6OPCxZCqHqNFeTg9xjVs9c5nRYuHjjnG
	EyMRhdOyGLzu+i5z0y0t37cjPdlKUgLR1Sd3WVDJeiNQdtmflUxDQRwKJ6mOb9zBclo2NG8EaSV
	j7C1LJi5w6BgYa+ep0vujftezIU1gre8hdKrtKbMWX7bqcGwWmn0+gOL+r2H1owUgog7UqPPQgn
	qLiGQxVTcz9tJvEetmrE3UyqMpEs+6f3/2ZV43pPEGal5fU/+c2pW
X-Received: by 2002:a05:620a:7106:b0:8ca:2baa:76e with SMTP id af79cd13be357-8cbc8d84a1dmr1792017585a.19.1772467057605;
        Mon, 02 Mar 2026 07:57:37 -0800 (PST)
X-Received: by 2002:a05:620a:7106:b0:8ca:2baa:76e with SMTP id af79cd13be357-8cbc8d84a1dmr1792009285a.19.1772467056961;
        Mon, 02 Mar 2026 07:57:36 -0800 (PST)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:87af:7e67:1864:389d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439b41831easm11282438f8f.12.2026.03.02.07.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 07:57:36 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH RFC v11 00/12] crypto/dmaengine: qce: introduce BAM locking
 and use DMA for register I/O
Date: Mon, 02 Mar 2026 16:57:13 +0100
Message-Id: <20260302-qcom-qce-cmd-descr-v11-0-4bf1f5db4802@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFmzpWkC/23NzYrCMBAA4FeROZuSifYnexIEH8CreEiTiQZss
 yZaFOm7OxRhF+xhBubvmxdkSoEy/CxekGgIOcSeC8TlAuzZ9CcSwXEDlFQlolyJq40dJxK2c8J
 RtknYknSL6KmSGvjwN5EPj0k9wH63hSM3zyHfYnpOn4ZmGn3Mas4cGiEFWeesUSuOanMJvUmxi
 Ok0eYP+Z6hm1tBsaFP6WrWNrpX6MlD+IQr1LIKSFe9rWre+dsatNzHn4no3F17uCk5wHMfxDdy
 J6jVLAQAA
X-Change-ID: 20251103-qcom-qce-cmd-descr-c5e9b11fe609
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7682;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=+rsIHYxr7aRb0VlKhLNY3E/THaFUhgQFWmdMPoaFtxA=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBppbNfhxvb7V4LiRoa46xtDOqp1t+K3Nkby1Hgg
 9DfJ2DR0NqJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaaWzXwAKCRAFnS7L/zaE
 w/koD/95Ne6UkZ2nK94on9Ak6+otLdbGHdGyyh+AT7awy1PWhSA9r0idPbeldvJCfxz7SecA8Es
 WEt8SJoGQWLVp/9xEOuZPvOvXyuZXE66PjJWVaXG6/nfRE3hoB8zPxBO0uSrAHqM2r94Y4oQ4iO
 xcmXnkjTyK5xSpgkHGCDoE9faDnO/JQ90kE/LLODoqlmKNGO/+RoHE9dr9/yjqzGUYmHV8O44fR
 Ee5x+y3dpwdP9lZ5GVdsCqHjGA4TBkSWOPpbXLSYDU4ViHOFKJBHDtirqhNe58zJbe/HGBncbKp
 XhAHi/vCj/7ohvt/HkyaZrNeblN9vEXk3oCicNcikonCFYb6Kss80ij2D7fMzFJwvnveMjF2YQJ
 xQe3ByDQDOC1SzSkf5cB7Z8OVRRAAYE7+B3oyGl0sFdNFBEzsLCKJvyQtY33Rw80U4Zcdow5fiI
 oGWMLqXGi2JLF8hioRbcwxKANeqfYTHu0DwNf9M6Dfin5LQHLU+2IUbPUGnrAj05nr4ZMwC4ZtI
 KazJXPSOk7BqIsy+VDk2drK5CEP9OIUzHudt7PhRH6UbFCox2b4S1PJ13EZwzwQKql7DZiJ4R9H
 M0HF7e9Pccp/iIAowMy3BFfNcRvKgmEuJQ2Hbz/MaiDHXmu/puXOJr46aPvhgxSDIl9miJQwnCO
 LtK1T45Owd9jRRQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=GMMF0+NK c=1 sm=1 tr=0 ts=69a5b372 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=KKAkSRfTAAAA:8 a=COk6AnOGAAAA:8 a=Ic074KEQ1cGD3t8WRRcA:9
 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22 a=cvBusfyB2V15izCimMoJ:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEzMyBTYWx0ZWRfX45fernYi3vWG
 bv+rTAMjgTb8IfSduQbUkoir/9+PIV88KWYm1HACr1P8Y4ej+gznDydvMx3/PeOuFk1h4td9RLG
 /7yGVWpztrZ0lZLf8s9SdjnXiNpzpB8q/8lf4s1S/mI1dTHYPw2wS270XnJHBHFD/BK+yoIOQri
 lpC4VRgrtemb74Y2cG3ixZvmrQ7NcJSuMeMNncMS8NcJTyzj4WGzerpKODSbAERWJuE7Pi/ekA+
 1IF1PxAGVTFwE9BSRPR+LrT99ZpSzWJJTBO7/jD4mll90oUwVR+/lT8aN/JWWHiRlTvQgsJAyCk
 X1GWbjsVup+Htc/czFrPoptPD8k2w9hmCje2vNog+aKGe53ja5YMxHk87YrBuAv5klPSgsPLvqz
 WKffJPr70fgpNFvuhepOdIbUTWUVWOF26lupU1S+7sJngDGu+cRfnEnTpLxz/TG+vRtSCCaPlQk
 KShPgef3ptRZTW9Y4ww==
X-Proofpoint-GUID: 2BLToz2p2QU0JRU6KlAY4BZ4Peq_qVDD
X-Proofpoint-ORIG-GUID: 2BLToz2p2QU0JRU6KlAY4BZ4Peq_qVDD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020133

NOTE: Please note that even though this is version 11, I changed the
prefix to RFC as this is an entirely new approach resulting from
discussions under v9. I AM AWARE of the existing memory leaks in the
last patch of this series - I'm sending it because I want to first
discuss the approach and get a green light from Vinod as well as Mani
and Bjorn. Especially when it comes to communicating the address for the
dummy rights from the client to the BAM driver.
/NOTE

Currently the QCE crypto driver accesses the crypto engine registers
directly via CPU. Trust Zone may perform crypto operations simultaneously
resulting in a race condition. To remedy that, let's introduce support
for BAM locking/unlocking to the driver. The BAM driver will now wrap
any existing issued descriptor chains with additional descriptors
performing the locking when the client starts the transaction
(dmaengine_issue_pending()). The client wanting to profit from locking
needs to switch to performing register I/O over DMA and communicate the
address to which to perform the dummy writes via a call to
dmaengine_slave_config().

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
      crypto: qce - Include algapi.h in the core.h header
      crypto: qce - Remove unused ignore_buf
      crypto: qce - Simplify arguments of devm_qce_dma_request()
      crypto: qce - Use existing devres APIs in devm_qce_dma_request()
      crypto: qce - Map crypto memory for DMA
      crypto: qce - Add BAM DMA support for crypto register I/O
      crypto: qce - Communicate the base physical address to the dmaengine
      dmaengine: constify struct dma_descriptor_metadata_ops
      dmaengine: qcom: bam_dma: convert tasklet to a BH workqueue
      dmaengine: qcom: bam_dma: Extend the driver's device match data
      dmaengine: qcom: bam_dma: Add pipe_lock_supported flag support
      dmaengine: qcom: bam_dma: add support for BAM locking

 drivers/crypto/qce/aead.c       |   2 -
 drivers/crypto/qce/common.c     |  20 +++--
 drivers/crypto/qce/core.c       |  29 ++++++-
 drivers/crypto/qce/core.h       |  11 +++
 drivers/crypto/qce/dma.c        | 151 ++++++++++++++++++++++++++++++-------
 drivers/crypto/qce/dma.h        |  11 ++-
 drivers/crypto/qce/sha.c        |   2 -
 drivers/crypto/qce/skcipher.c   |   2 -
 drivers/dma/qcom/bam_dma.c      | 163 ++++++++++++++++++++++++++++++++++------
 drivers/dma/ti/k3-udma.c        |   2 +-
 drivers/dma/xilinx/xilinx_dma.c |   2 +-
 include/linux/dmaengine.h       |   2 +-
 12 files changed, 321 insertions(+), 76 deletions(-)
---
base-commit: d8cfb11ffd167a413269993d7e24d307ad47aa49
change-id: 20251103-qcom-qce-cmd-descr-c5e9b11fe609

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

