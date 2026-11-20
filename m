Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795203309;
	b=SYQo5dbm+TDek68+PUs5dFFJy/5PEeagJ8wZnVYo7c5A9zBwNHnBmCcs5vLnyjDQmo6Z
	 fXCpHllSxAI8ncGUJiK5vGC2Ealt/3OAaTfoT+2JEdxcVDxlJQjf8eXXUd5YfuOTD3Csl
	 lIUUK2tcEpsKdFPuBphabz2sx4AeXVFPc7AWkZh4JAC58eeD99xZCGxi9KqS63H50cWKT
	 r3NuxgtCG1qmRDWbtuhCTnlgU5oXiQsGI2pXytufRn/Cj8TktzBp0BeqbPDK9ojs0Qvrm
	 P/7FvIPyTir6ppOlbcBmF4s2uizf6Nq2UlGKtf57BG/IqP8Y2aFitQi0a7mZrTAKc+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795203309;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=NikyEkn2Ckik4aNGE7wLG28YXcgo+vx8KHG7eWoRnWE=;
	b=CV+ranl7l7TSMLcjSn3yDlN0ZTj0ExrwnJVglPFvnRlDXH39vs3KCU8dxb/FWNDP0Zfh
	 2DSKxVIbuhYQty3rBKrKiUYjBQFTSE3x+UrlXc6IqDo4ZWTIx7a0Mj9qTaS4fypwvdcps
	 pViJ+hrk34AM8z9hmDybvyo9RenB62NTVWJTL1SWIewrmhXvfnRruxbPj0LZB0ucUSb1r
	 1t2YusFXPwXzmGwiptMfM7kcz6tiey5HsQSB4TB+gYsjtORic4wVoQ3bkC8TVCNv4gk2X
	 0lx8Zzs4OOX8+TfTnjYwdEBsNIvl21mg1PcNnA+FtEAoqauCV79hJCbnvwXa9lSwqNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fdC+1SgU;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Y3p6Q4W3;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B5760A260D
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 19:35:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1B5760A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=fdC+1SgU;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Y3p6Q4W3
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKGG8sL3831338
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 19:35:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=NikyEkn2Ckik4aNGE7wLG2
	8YXcgo+vx8KHG7eWoRnWE=; b=fdC+1SgUVo3ZJ+Q9pVZdg1/C+ZwBMDFDwT6pZb
	lc5EsU0ViuA7M40Y5na4t1ukO//FmM+6OnTyTiytcwDPHGNyjSgkb1/vJcmrs/Vy
	212Xcc8hKD8urVrro6/GoX83lhOJ5GNb8ShOVuwbsnzb/J7twrt+GyYyEUspZCxv
	SZrtayV93C+mCxvZ25lXwl/QYz7slip/qWiIEYymXHxqPshtRJSRj/kfwDBiuMRN
	yxG5Nwj1NpVDzY0Jb4rNU5HeCWKq1PmultyunQpHunTk6O6f57VZaYyXxL7Q0UUr
	FhDM+a5LHsa2UFOdG+fkNWg7ARNKM2aMX/Py1CrYdd74p7+g==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j2sjwgw86-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 19:35:05 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93e92aad34aso240569085a.0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795203305; x=1795808105; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NikyEkn2Ckik4aNGE7wLG28YXcgo+vx8KHG7eWoRnWE=;
        b=Y3p6Q4W3g+DyNDpyNs4wONLlTJRBNa7RfhPAbO+CHjae72YZJVsu0+eNYqC8F+h2+q
         wkfDW5rrVeAL3ykgy5pDZ6t5qz7AgPbjLtUR4daXW8qaINjnJ8FJ89m1vRV5AqwKHOPw
         Wv8sPpf9/uQzfib/sLXdaUd18FoVNXYR/l1gtgxMAu6Yzcp6jjHNDziIr+zWu1RsLfxX
         xGEF7N7i2qNCKN6nWJapoDCmCDCvqezEOBJgl47Cl4KjUOuN7FLMKupQBxYOLDFL9e++
         YkeGnwv3fjvVP4LvUXJFSJoiHzpjW0Y1hEeGrvhddnQzAW74bJnnocni6PnSy/ucB8fa
         sDgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795203305; x=1795808105;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NikyEkn2Ckik4aNGE7wLG28YXcgo+vx8KHG7eWoRnWE=;
        b=G1w4/OkG5Yqh+IoqskkDT4yp6klg1uW5RlXtmzjivW9UJxpiaNdSvY6RHBhgzJ4TGp
         nNp+x7Cq274Z/yfOQI/eMx5rdGRWp4J0Ej7an0b663k6vVJ3ASrPSCovQ8FtulJgrjMy
         o40MO9qCF1Qh04y61W62V0o7asaqAdPZRmvWPtuLV1KXJAwRexJNzcJsvX2p7vzn5AnF
         ZQwHCW5WSZRtU3AN4X1lr63PVauy1tSBhTC/2S7C8pgxy3z8t6zcjtgfqePCgqTG2Ev6
         LjkOFn/TAm+moUWY8dJhiiHpADo1c9S+CkGPTWphfWEUIcy5aJ14bDTNE8GKPGumMVJX
         Anbg==
X-Gm-Message-State: APuU4Z/x1P1oATUyLMe0Gv6IdcfbmttRBDLthMLFBboItSDEaEAscj5m
	3nbtLgeYq+Nrp5HfmpsVwOX48eLupJMbhqkF8dWYNRrlUED/uNRI5rlU1EJ40GAKWdAtYPh0+J2
	t/cDi+Dr8rTxdYMDhUkS6LqeG/gGVL2H9Bw7u77ejtMeLT1MVM5FcOnGPaKCrtLkcHO4=
X-Gm-Gg: AYBFou2VgU2M9SZLxE+kb9uu+Tw7CVnlx6vRr/425jLGQ79/c3mbm2LUo5qRGDorLF1
	EFSYUp1JzyKloig+/HF6GVztxHYs0yp3l7O5UfFAydRf0G+zeK8KucP2Zg54ajQQ1WtriBZVWWI
	h3+YU2TUhyW1KZZvLANu4d5WDvru/EaJBbhNKBhjQGUvf/l8RQWE0E71Na+q1vocejb206i3qji
	Yomq7/8qwc7xn7cVvNACMA53i7nyih99tu7CRrJ2ONMeYLcOOIwQKAWRj5NzyXs/2PoG3JOhjxc
	9ACv5XLu3NolZThK8ZYVwBYYRTODogAQ4hcrjliyWOFKD3s9DnT/3bXkjxIerSsA3XbA8aWbS4r
	BFuemA5dQjwUjfF8vUkKM4V7Ia7HG7OAv0BRBIVUpnAG8J3xhT2+uOvW0O/Hz9c4m3V7UmyjyuM
	NL
X-Received: by 2002:a05:620a:480e:b0:949:816f:cff8 with SMTP id af79cd13be357-949ba823573mr720708185a.3.1795203304789;
        Fri, 20 Nov 2026 11:35:04 -0800 (PST)
X-Received: by 2002:a05:620a:480e:b0:949:816f:cff8 with SMTP id af79cd13be357-949ba823573mr720704185a.3.1795203304333;
        Fri, 20 Nov 2026 11:35:04 -0800 (PST)
Received: from brgl-qcom.local ([62.245.128.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf685asm6806343f8f.20.2026.11.20.11.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 11:35:03 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH v12 0/4] crypto: qce - Split the crypto driver into core
 and crypto parts
Date: Fri, 20 Nov 2026 20:34:53 +0100
Message-Id: <20261120-qce-fix-self-tests-v12-0-b5a2a44bc5ae@oss.qualcomm.com>
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
X-B4-Tracking: v=1; b=H4sIAN2gAGsC/3XTS27CMBAG4KugrGvkmfjZVe9RdWHscYkEpMQQt
 ULcvQN9kIW9iWQr/jJ/xnPpCk0Dle55dekmmocyjAdeAD6turgNh3cSQ+KNDiUaaUCKYySRh09
 RaJfFicqpCOUx54SUvdYdH/yYiN+4q69vvN4O5TROX/ePzHjb/eN0jZtRSJGiB8gQQlL4MpayP
 p7DLo77/Zof3U2d+6Vkq1LPEsWIG5UoxZwaklpIiFVJsaSy46DBgommIemHZKWpSpolZ7IykDM
 49A3JLKRGOnOrSWtrdSadTWxI9iH5egNny1JMm4QWXMigGpJbSAhVybEE0ureOuODbfXOL6X6H
 /csbfgCWIVkfcgNCeQ/BRL6KsWppdDcNwy9C1q38gE8LIB6WQC3upwJRhNZjlqxrj9DMNHxzBN
 1+p2E6/UbvvMQ628DAAA=
X-Change-ID: 20260610-qce-fix-self-tests-492ffd2ef955
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5365;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=KTZtNkn180IMQ7q/xXo9jGDg6f/6/gZiWsnPOSwb7LE=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBrAKDkMgMOx/M1Q/T0IUCPzD0uz4f0ZMpVr5AxB
 1pzKZIRf8OJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCawCg5AAKCRAFnS7L/zaE
 w4M5D/4tEZWCpTfdDXReKGXBm48pn5Ho8i6GNuJFo2iU7XqMGO4KV2//FkufCsjxUhXUmZKKlvd
 d+/vzPdf/ft6Sye+tB2sniYIw61iqBy8bYw5lcAx2LAKkW3Pm0Elz5OP6rkEmNUrMtGdyxlQWMm
 kPXj+DHjQFTvz4EBxrUMO8iIkHEjvxvqn+STZpFNJpUCctKJXH34bu4bc/teVZA/7Ym0YbWsBLT
 lVikm7n4fObeDlXhNS8tj/9h5mspdsTNeJubk+Sn083IB0uSNRDRuLmS7yxdLHEP4TC9rP5p3Bq
 AyyEviT7TuXJC1vpv2mkEDwQvh2949kSfJl5NWgyzwhsYDKYn5u73akLTZHKPOKIO7hbBAswgKf
 HQ04E5Z32e3XzKSHb1wEzB/W2tdys7oN9SsIt4GYjNfuhB70M5jpno8NHfPOY7EV0/YHQukhePN
 rKCmON+gw6EODEI+xcJobaeJCmtjgfRmquB024Shw+41GnN91gfPpRCyxs1zYRVQE0pCtCQJ5S7
 KvWIL4ubH6nEfW3ts6Knc54CtvvbI4Atf49f+mCO8+E6DUS7aH3qaZFf03Z0Midn/852eKKJvF8
 95EjGRmbIrUKa0JucqPC/UipJ+bhkSZ2omWTzJ4pDUtDv3U18IjYmUDAAbcm+vVt3nnAEi/FkB+
 /wV5ISl6fnN45Zw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: O1Z72jNTIHizYSsrZRcrJfHxflqwrstF
X-Proofpoint-GUID: O1Z72jNTIHizYSsrZRcrJfHxflqwrstF
X-Authority-Analysis: v=2.4 cv=dZ4VTnXe c=1 sm=1 tr=0 ts=6b00a0e9 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=y0NJeVxnVzJs6a3GlOz7RQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=bC-a23v3AAAA:8 a=wzu_yjjtnJo_jeqIb-EA:9
 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA3NyBTYWx0ZWRfX/faz/JeX81r3
 gxsypJZ4xXCcxP1zTEUr2PKoQa1vZwT5ByZkhdVCj8WlQRM/62MO4hDZLOyUjgaYpGqD/shIW12
 /q26jEFvG0C8oAiLOcrW5m5V4BWL/DU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA3NyBTYWx0ZWRfXwb4H0PjhoCz3
 0EVOfHxUmw8Q+9UQA9wH/VkodojWylnGVhlEi1DP4BJjEm3Vsi9GWzIMMI5AHd99mlVOFM3Hl3A
 gnDhNZK/JFqNpeyxIr8mygN1wh4zVdMHJFZSLUCmGYcb6xc6VgoaM0D/rLngFn83Y6gqFTqZ+ag
 QCrtZ/6VZ/9ZXD2ylq+FQKHA0muzIi7RnuAfsZ7BWTF+PxL9Yn7HrjgTou0Rhc12b33GP0GFB3z
 SKbogdGTUiJfyWI3u7feRGvGWFexh7MBk5Pdh83S0fdg1+kYRC3q9VolIXfuhAMvloSr+fxjuZs
 puKwYoqN0JLOkzOK2YJUMmoMRaw5+Aphd9H166Jqzve9u6s2LMHpdLnkIUz3sWfHTsW4XxIrSAr
 fuzPi7oHm1fdaI9ZW+BHYaM5jTHjZb6P9g692BbMelHgQZ0JrB28MrSXIBP4mzIHXXxo8W4cZtA
 MfEqfDuIFha9sNrx+2Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_05,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200077

With the self-tests fixes queued, we can now split the QCE driver into
the core part necessary to bind to the QCE DT node and enable runtime
power management in order to allow to drop the interconnect votes, and
the crypto part registering the crypto algorithms. The core module is
then enabled in arm64 defconfig while the crypto part stays disabled by
default. 

Merging: Once the fixes to self-tests land in mainline, this series
should be queued through the crypto tree with an immutable branch
provided to ARM-SoC and SoC driver trees (with Acks from SoC
maintainers).

This depends on the final series with fixes for the QCE driver:
  https://lore.kernel.org/all/20261112-qce-fixes-broken-label-v12-0-7b5b9c7083ed@oss.qualcomm.com/

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
Changes in v12:
- Correctly check the return value of __devm_auxiliary_device_create()
  for NULL and not IS_ERR()
- Fix a comment referring to removed ICC code
- Assign the auxiliary driver name to the auxiliary driver structure,
  not its embedded platform driver
- Link to v11: https://patch.msgid.link/20261112-qce-fix-self-tests-v11-0-b86a65ee7107@oss.qualcomm.com

Changes in v11:
- Rebase on top of fixes queued upstream
- Drop Tested-by tags from defconfig patches
- Tweak commit messages for defconfig patches
- Link to v10: https://patch.msgid.link/20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com

Changes in v10:
- don't pass a NULL buffer to sg_init_one()
- fix byte order of the imported hash state on empty finalization
- don't recompute the CTR counter in software for every request
- reject skcipher requests with a too short scatterlist
- check fragmentation for empty CCM decryption requests too
- don't use a static loop iterator (duh...)
- initialize the return value in qce_handle_queue()
- Link to v9: https://patch.msgid.link/20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com

Changes in v9:
- Rebase on top of cryptodev/master
- Rephrase Kconfig help text changes
- Link to v8: https://patch.msgid.link/20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com

Changes in v8:
- Add a patch making the crypto driver *not* register algos by default
  but only if the user explicitly requests it with the provided module
  parameter
- Use the "offloader" name for the crypto IP instead of "accelerator"
- Fix device module table issues
- Make the core driver use a list (despite it only having a single
  member now) of child auxiliary devices to register to make it clear we
  have the intention of extending this once we start the work on secure
  media playback
- Link to v7: https://patch.msgid.link/20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com

Changes in v7:
- Add follow-up changes converting the QCE crypto driver to auxiliary
  bus, adding the core QCE driver under drivers/soc/ registering the
  auxiliary device and removing the BROKEN Kconfig label
- Link to v6: https://patch.msgid.link/20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com

Changes in v6:
- Handle all zero-length HMAC finalizations (like imported state with
  data already hashed), not only the genuinely empty message case
- Add an additional patch addressing the fragmented skcipher payload
  issue
- Link to v5: https://patch.msgid.link/20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com

Changes in v5:
- Dropped patch 1/8 that's already queued
- Use the pre-allocated fallback ahash for HMAC transforms (Herbert)
- Link to v4: https://patch.msgid.link/20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com

Changes in v4:
- Remove remaining ECB and DES3 bits
- Pick up tags
- Link to v3: https://patch.msgid.link/20260617-qce-fix-self-tests-v3-0-ecc2b4dedcfd@oss.qualcomm.com

Changes in v3:
- Remove even more algorithms and dead code in patch 1/8
- Link to v2: https://patch.msgid.link/20260615-qce-fix-self-tests-v2-0-dc911f1aad42@oss.qualcomm.com

Changes in v2:
- Add fixes for the full suite of crypto self-tests
- Add Fixes and Cc tags
- Link to v1: https://patch.msgid.link/20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com/

---
Bartosz Golaszewski (4):
      crypto: qce - convert to auxiliary bus
      soc: qcom: add core driver for the Qualcomm Crypto Engine
      arm64: defconfig: update the Qualcomm Crypto Engine entry
      arm: multi_v7_defconfig: update the Qualcomm Crypto Engine entry

 arch/arm/configs/multi_v7_defconfig |   2 +-
 arch/arm64/configs/defconfig        |   2 +-
 drivers/crypto/Kconfig              |   2 +
 drivers/crypto/qce/aead.c           |  12 ++---
 drivers/crypto/qce/core.c           | 100 ++++++++++++++++--------------------
 drivers/crypto/qce/core.h           |   5 +-
 drivers/crypto/qce/sha.c            |  12 ++---
 drivers/crypto/qce/skcipher.c       |  12 ++---
 drivers/soc/qcom/Kconfig            |  11 ++++
 drivers/soc/qcom/Makefile           |   1 +
 drivers/soc/qcom/qce-core.c         |  92 +++++++++++++++++++++++++++++++++
 11 files changed, 175 insertions(+), 76 deletions(-)
---
base-commit: 909ef7a9a30fa139e69e555e3606680f5cca7726
change-id: 20260610-qce-fix-self-tests-492ffd2ef955

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

