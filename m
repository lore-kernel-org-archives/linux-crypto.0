Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4BE518151
	for <linux-crypto@vger.kernel.org>; Tue, 29 Sep 2026 11:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790682785; cv=none; b=CjYYfkcQ/hRMBaTmfvwxsWWt1jV+rflOXhljSqgHZESRAKaJbe0R5gDnd9Fl0j34QTzXN1CUZ/xRQxz4Yy2LcN+Kr0RQC6YzHwTdOkmLRvN3nxoA3TVNIj+D/jIUN1++l7pOn/11u5RTHBttSLkBj18huJG/YhuAnCmLiXNQD/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790682785; c=relaxed/simple;
	bh=Qq4LyVpNA3VxrY74dQ66xruuSGokXlWRSJ3ANyBO3G8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wp6yWMBeBeqQmtOFoWRCH/5a0F9Bp0Ap+3m5W1sDk19Sn8Ema/v2+Kz7O8lPu5aAdnQAvnAKfQVusIcw8xLfOceVbg6xYwuWaBOsDiWrJJtmvzZd9OYNnnMl3Dj22fi7AFsd2iYit3iXeMvI1RZ+T9ETmxT3vbauc1ppUF9LP1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Fr/eb0uD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SnbRiSVt; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Fr/eb0uD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SnbRiSVt"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TAj6EL335142
	for <linux-crypto@vger.kernel.org>; Tue, 29 Sep 2026 11:53:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Wc8pBobLAB4TatrDh20UoHLU9V5aquvkKxmU9lFHUQc=; b=Fr/eb0uDuIOoxz1s
	57noKmRlC7krHWZUNMOqhCDKFgmqSrdsqW7Rt0HX6ilWZSQP+g1IJJSBPVZY4gt0
	RPfS0bjdmCIk78dBXOcDsfX+GVJ4xw1goNCNAs89N3EZqjUX6OztyzwdeN9EiGuU
	ZCBfpJCZUO5nFqy0BvqpQRNDfdOdwkZbLcRH/JYgS5mKMKoAMW42H6+m0fJxl5wP
	4XctCd3mTpEI6p3Wra8mwmi5dwvLlzyXy8L0sOGitjhqWZzMZeBPPtNko1YOxBGR
	1RTN1HGo3yU677qVXaitJ6dCpqSpximPO5VSxMeK5qNw4JXimmsYnmA9RT/Hhbkp
	LIc0+w==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h03ew28rw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 29 Sep 2026 11:53:03 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cec4226c70so32499235ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 29 Sep 2026 04:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790682782; x=1791287582; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wc8pBobLAB4TatrDh20UoHLU9V5aquvkKxmU9lFHUQc=;
        b=SnbRiSVtmeMpb5qmiiPgIwk5tKlCxkv+Tq1YYvzom5CDJhtdw1N3C3/xqMcRumKD0D
         7xwA/1KnL3CRZsVudXg7j2yuH9du1PFhqSdEj1aTh1JqXE0FLuSx7Yk4knEn3MK4HAxG
         JsPwlovv95Tz4HVYAwotPFPnwU9oAgfsZmzOq05KGTEVtAZuc4YiZxvpGztmhOG614ok
         xB/nKFs9sizjLwYULHxBq44FaeSbp5uQnE5/9oXir4f4jG8J371fW809IWRpqafzuWbY
         WxgW7/uP9NoMu7jPkmhqf9RAJEiaic/5IqzKB1XU6su1RJ0nLUGv6FUUO9GGPyr5XZEK
         P+VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790682782; x=1791287582;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wc8pBobLAB4TatrDh20UoHLU9V5aquvkKxmU9lFHUQc=;
        b=GjTxyaLhgGSp1KSDb7nChoTRBf/qu0VxzcO4kNMvEFy1JWr8mVPE6X+h9tuPicpPT+
         eo74aDppuQLzo7HDtXGS5QZYl5rg8ZRa+/cIrJXr8fkJmwkq0qkBskJDQke8llliM6jo
         FnejzCd5BURhxfTL/4kOCv7cAvuGM0c70fi5boLuzAs83o6YRmx3kHZk2CdY4b8BxTAU
         RStFg5jfPz4puFMA/IpWKFdk7A0dqVmax9akfx861+TTUeQ/e3eRCCo9rcWDk/SpZ87m
         ur9wp2Ia5rLOvDNANr2VzQKRBraSF52pqArGpaaFL6naTRv4JujpxoQjWPv9tSyQHyXH
         za8w==
X-Gm-Message-State: AFq9FYJ6JhKGbTyO3GpylVWQ7ZJkhnDrdrKe/Zkp7NHgr4MuVerbo557
	TaAPMGDy5XiyHCT2ioRylaYsUye+TqsHVlCe6nWpYBDVU0eEYtZR7Ap8t49gfVA2WgpFe1uQTdy
	2edgnY6uCN77RGwRq6WnxR8Wpenhx0tezE8sVJMWGC/4o+DFoLCNHdInC4CJErfD4JRw=
X-Gm-Gg: AYBFou3vQglJPDs5W4dgtP3APLkFEYjxZVdnMm3kU1hHTYfnQK7nRMT3wzMUUhQJnvO
	OEY7iO3l7mef1c0nhW6hQZU2RJfVkv6UXZ8tvckrT9pdHI4PtSm7uzCGSDCKmZNzT3nYtH7d37a
	fTbwYzWw6K8jQxh0WdVT/w6mgqCyPxvW5LOUkoQMViTaTjGsZG05ttQpsHX3BR+7+Bor6ZJtsVZ
	syR3xv0Cbrmgl1fvTVBv/QOFEdRtIzl5Uj5vsWZBBHcGRpZv2x+aFUjCdCB/li5wqaY0ANLJxjv
	WooHqhBqlVlxdgqPwgwiJ76xLVVrhqHcvCRGJ9oySr5viWqxfMlA6gS1EBWSeQrelHMYipP34Hj
	9p1SyGy9AYEbrImnr1qq6UIGz4k2ZWIoElWPSTUMfh8ORvWppysISSjuZFyjubSKKJ3ClAue8Ql
	RMynUuZkY8e1oMLmDbMA==
X-Received: by 2002:a17:903:26c5:b0:2dd:c0ff:e727 with SMTP id d9443c01a7336-2df7dfd63f0mr137881735ad.57.1790682782196;
        Tue, 29 Sep 2026 04:53:02 -0700 (PDT)
X-Received: by 2002:a17:903:26c5:b0:2dd:c0ff:e727 with SMTP id d9443c01a7336-2df7dfd63f0mr137881535ad.57.1790682781734;
        Tue, 29 Sep 2026 04:53:01 -0700 (PDT)
Received: from [10.79.116.160] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9146ed7csm53972585ad.80.2026.09.29.04.52.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 04:53:01 -0700 (PDT)
Message-ID: <4ee090bb-b404-4b0d-a239-5eecd93263c5@oss.qualcomm.com>
Date: Tue, 29 Sep 2026 17:22:54 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/14] crypto: qce - Fix crypto self-test failures
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King
 <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
References: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
Content-Language: en-US
From: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
In-Reply-To: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA0NyBTYWx0ZWRfX3/LYfX3fd/Xa
 ZE0/+hly6mvA3i8VLRp7ViFqDdcTGMFFuyo17PuABOzMUMD6zJj/j52to5xETbKO3aWF8SK2Eap
 o5SCzLoKkC6img/iAdIYUbpWiKKtdIg=
X-Authority-Analysis: v=2.4 cv=IIOXmQvG c=1 sm=1 tr=0 ts=6abba69f cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=4UECf4yVBZO8k2hVk_IA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA0NyBTYWx0ZWRfX963CtpAkYRn3
 xjS8eDXoM/VnM0gWw0kIbfsRgPwZOuASkdk0Mg9xn8UVR4SUROHcOyE1Hxj0Ttd3YBBIom6jyw9
 W4I1oPUkSobiaqAaPlbLgU+9G7MeS/wcc4HO6cTEHaeFf5yNb9NEC4PL/gp1GLSn78RPwUbz78m
 haUXly6GrWl7C4tf+kSGEF2dPjVNpw3kUTLf6uSkrnVA47Q3Fc22I3POx7CRtup7owj2RHnAYib
 CMan+szFla6E4cFMCxnesSal33mtZUhnRr5FwkbPBb+TpIOfG3gucc8Lom1YjHBbf/6C2+0UEdW
 T5JGxChAB0oogvJvtUff/acYCuX0H+5Ak1D3+ZSoUwRRbc0b2Z+PyxTRueqCPNd4eimtRGUptBs
 atZvEC/fBpeuvadMv8YFgNBV7TyLt/Ik/l3BNtKsNBgONsOczvmQmyTfisVg6bD9LbahstyQ0Pq
 bRXVIrLDirt6lVjkOYQ==
X-Proofpoint-GUID: UOaS_0iEbg8u6oxDWaL9aMpIeSPU4BGj
X-Proofpoint-ORIG-GUID: UOaS_0iEbg8u6oxDWaL9aMpIeSPU4BGj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609290047

On 9/22/2026 6:27 PM, Bartosz Golaszewski wrote:
> This iteration - in addition to the previous fixes - proposes to split
> the QCE driver into a core part necessary to bind to the QCE DT node and
> enable runtime power management in order to allow to drop the
> interconnect votes, and the crypto part registering the crypto
> algorithms. The core module is then enabled in arm64 defconfig while the
> crypto part stays disabled by default. In addition: the actual
> registration of crypto algos is gated with a module parameter that
> default to false.
> 
> Note that remaining reported bugs will still be fixed in follow-up
> series. This series addresses self-tests and disables the algos by
> default.
> 
> The QCE hardware crypto engine has several limitations that cause it to
> produce incorrect results or stall on certain inputs. This series fixes
> several bugs and adds workaround allowing the deiver to pass crypto
> self-tests.
> 

Tested on Glymur-CRD, the s2r suspend blocking vote from crypto gets
removed during suspend.
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>

[...]

