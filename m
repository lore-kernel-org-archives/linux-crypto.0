Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB542D3ECF
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773155555; cv=none; b=bIeI4Sxc9Yb9CGXzEc4h+soMa8RXGLlCFjfsc7o5I727ezrvpM9QI9iMhaBQidpGqjUesBFWkXJlr7oF25b0TdClrZrL/bTYZX8UZeppK8ggTXiR4Z7Y/JXtL4p/P63fAohMtIgUob314LZfEVMpewwtV3rhsaDhW3htX7CcUGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773155555; c=relaxed/simple;
	bh=CPs1c/G5mvCMSxqg0kk/dMapsjGjXKO3sabe7GK1NkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtLtvQ2DSAxv9Sav8y7DlrXO4bTjHT9W8PtVQiG94gyLYxkAYKbxb7Qb8Dth8J1+KX7YyNYzwHYsDzYTX4bMf07TT9u9yby4U+foJd0h0GpqHNCbrZSQSUBI5zECLoCWTGdV5UMKSWCT7qRs+k4Jr7nkSxR/q40gB2VuDp22KWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gyXstwd5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AzUl5erD; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gyXstwd5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AzUl5erD"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACaVMW1502945
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:12:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=ihC7DRtjTPJ
	USDPh8rumlXblahonstifNwos0OC4Pr4=; b=gyXstwd5LAxtanZgsTyX4QyRsGR
	CG451z6Jzitlcs7vihFhXTq/g8ArivDy72xnzzypbimXRxEjYkqMfTNjQnzU05Ry
	n0WFo4Bj7cOQWk+YzVpfu4A9sQwsdSzy9aaP6yN/vyIfnz8g8k484mABN4rL9Fzh
	PAXK5piaExIeyyzpbKBruu53DEnYBKbxkHvIo8op0FsfwMeq/G1mTt+iZW+wQKzK
	7cjzwgiz0KSdLO2GvFdhBPww7VrNV6bBVJdLN8byTBEyngKuXoPXscnhueeG66ZV
	ml7Cl8Y+3StEYWXSEk36bN1TMCtCZiPszU6Ab41x0MDbtKaUznWyqlzRqEQ==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctdf8j37r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:12:32 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8cd7fc27cf7so1506596685a.1
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773155552; x=1773760352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ihC7DRtjTPJUSDPh8rumlXblahonstifNwos0OC4Pr4=;
        b=AzUl5erDJAxTl7kRtF6+L3FL6BV6pAOWaSpSjMELpqU0gRoSYuCxMFBSxTa5Ji2T7/
         0nDl6XPhCahhEkxpQTAAz03jt12Fc4QI586sFXK/7BeeKHD/xrYVRqytuV5G49uCUqPK
         4KNsh5BMhtZbOk5XQrXbDkaOvv5g+SHDscj6lxl/eCIvEsEFUIOOK0TuAUZJbrDHsevm
         bUHEbIGhtp5ASsR4jiSZ/274IByrGAiTe/47JfwvmfjZMLls914tTo25Nd6tlHpamnch
         t0yITr9D2Iukp6F9vUYuYSTU/yHRQGh1VxNGmwg+lJALMMJl4CxsOZr4sKnxY5/erm0Z
         xkZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773155552; x=1773760352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ihC7DRtjTPJUSDPh8rumlXblahonstifNwos0OC4Pr4=;
        b=NEBJKFnRWgJtNMmzS5CkkEzZyKXlav6d50+UL2CAf3J6F/6bSGmq0HURoZieWVEAYJ
         DPqnYVTVkg2q/JfpOaUMby67aiiYJol8keoG2h0WoWkm3CULANalHeekrDV/WTCrmaoO
         AC8FEGPHEFSNTdiCB8VXKawpBtiFXRG3xvV/QOJ5gVWDWaCerA/+GtF0RS6RwfKyDHm0
         BSYq7QTLVZ4gLmzYOhh30+Lvh6kZdFYezLQdJ1ntzMvu9GomREXUD/cPfwTqgX0qskZN
         zzG8MLjbmYi+QL83jL2HpXksNz6B4xK95OK2BqB4kAThbEgyaW9VPQlNpXy5iuTCYexx
         ndpg==
X-Forwarded-Encrypted: i=1; AJvYcCWbzIcyYkCfRYl/0DD6CZHoo/zrVf75S1UC5XSjh9enRokI/nsX4SJ8+VTx6jXffHB79DVwXu0ApX/bCws=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK3c9nZsnwx04gYnZfN5wr/Bxay9Pe3TcsrNFeccJFxCVFUEW6
	rcj4GtwOtolGZpn1TnQ/xI23qPl3hjYquP3esbFxS7ChqNTLrLxTgCps7OOgAREtzKws2KPXEIK
	TjXrF+B8WfQ4+Sh28rVqH/teC2+ty4hfitcsS4DXCUYORayXg3ofoy1EeyyXp/GpJJHw=
X-Gm-Gg: ATEYQzwR5Z24G45zEv41gRUt23G3p85SVJGDdBslK4he1ZO+OTGWFFt1K5A0hmrvanH
	yGSad8ds56kMDFpL6aSQx8ZxviTFAJhHUymRWVRykCH7zsZHzrAzn01Q6I+yNCueFAVMIyeSNak
	Jl7q0xjOHmaj09e+SoO4sQVu7Ttizl0aGVKXZduASlPUraKE3sZeEuUK/ZJyzSTcmhplBvQw2xJ
	MKVIhpg1qtah4LSG7HJ9cdG0FzhKgALJ2TsPNsEkhweP/wlkoreP2+Ze83yNXYUG8vPSzlt0c9k
	C4m3UGNoRtUvyaUTlTd+nYgqfDu/ACRy3idf4HVxWo8JfzcHjKNT/+14ou8dZEZSRrV/UxNsN6L
	I7G58pWkG2kccWbmzS810TMsHC0QDftFZzwOZ1Eg7oXCzj6oAOn6hjYqtSQHIVA==
X-Received: by 2002:a05:620a:31aa:b0:8cd:8f04:50f4 with SMTP id af79cd13be357-8cd8f04560cmr686118785a.44.1773155552343;
        Tue, 10 Mar 2026 08:12:32 -0700 (PDT)
X-Received: by 2002:a05:620a:31aa:b0:8cd:8f04:50f4 with SMTP id af79cd13be357-8cd8f04560cmr686113485a.44.1773155551871;
        Tue, 10 Mar 2026 08:12:31 -0700 (PDT)
Received: from hu-yabdulra-ams.qualcomm.com ([212.136.9.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae45786sm41529852f8f.32.2026.03.10.08.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 08:12:31 -0700 (PDT)
From: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
To: ebiggers@kernel.org
Cc: amadeuszx.slawinski@linux.intel.com, arnd@arndb.de, dakr@kernel.org,
        gregkh@linuxfoundation.org, jeff.hugo@oss.qualcomm.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mcgrof@kernel.org, rafael@kernel.org, russ.weight@linux.dev,
        troy.hanson@oss.qualcomm.com
Subject: Re: [PATCH] firmware_loader: use SHA-256 library API instead of crypto_shash API
Date: Tue, 10 Mar 2026 16:12:30 +0100
Message-ID: <20260310151230.3478726-1-youssef.abdulrahman@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260306212052.GA9593@quark>
References: <20260306212052.GA9593@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEzMiBTYWx0ZWRfX+mLheOvILUjq
 JeZg1gUadr21xr3igvvPAAuHdEIP5ppDOHlQDf8UcmVO0ysP6HAhVxL7IZkZu+4YK+5468xjDxo
 oT2XJsY55Rf79XaYt1FMrVitXrgr4jjtfrnwsEVTgl/IN+6fLXOJFKG0SiSvYKfYG9q89yzq+Ri
 63PUpAIu6Ua4vJINp/GoIjamlGiVwFHSmNV1G6IbN9rFpoc0YXhF1PWrer3IdBRBamU+e5Arpi9
 C5P05X7sSA3/xjg0dKhxcTlW1mskNnd1GSk7z8gJk/fOp9Y/xyLq6UeUU2cVAlebApb5rTmqJTU
 ZXzQfADCNpt0kxid6hrKsptvBuvY990W9p42P71A/kfCzqzXTih52MVAXILX8XY248dASjGDTRY
 PSjSbHeExr9CBpGEHfAESvxSAZlosHuasWt0jpnk2qytgdR1NZqJrL3XoTKdFsgw0giw2XwEf0z
 XX5Okxmdn6aTVykgKFQ==
X-Proofpoint-ORIG-GUID: 7bTBrmQOz58vqvJ7xo3vOIoee2hA_kcC
X-Proofpoint-GUID: 7bTBrmQOz58vqvJ7xo3vOIoee2hA_kcC
X-Authority-Analysis: v=2.4 cv=b+W/I9Gx c=1 sm=1 tr=0 ts=69b034e0 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=dNlqnMcrdpbb+gQrTujlOQ==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=VwQbUJbxAAAA:8
 a=B-Biid8fbNSdKZqIvtQA:9 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_03,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100132

On 3/6/2026 9:20 PM, Eric Biggers wrote:
> 
> I guess this further shows that the upgrade to size_t lengths was a good
> idea...
> 
> There was recently a similar bug report where on old kernels kexec
> crashed in crypto_sha256_update when loading a file larger than ~2 GB.
> It had already been fixed upstream by the upgrade to size_t lengths.
> However, due to the large number of backports that would have been
> needed, for the 6.1, 6.6, and 6.12 LTS kernels we just went with the
> one-line fix "crypto: sha256 - fix crash at kexec"
> (https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/?h=linux-6.12.y&id=70165dc3ec8cff702da7b8b122c44575ee3111d6).
> 
> That increased the supported length in 6.1, and 6.6, and 6.12 from ~2 GB
> to ~4 GB.  Your "6.8.0-62-generic" distro kernel must be missing that
> commit.  You should first ask your distro to cherry-pick that commit
> from 6.12, and it will fix the problem for sizes < ~4 GB.
Thanks, that fixes the issue :) I will request from them to cherry-pick it.
> 
> Do you need support for sizes > ~4 GB?  If so, then we can come up with
> a solution for that in the LTS kernels.  (Besides just doing a lot of
> backports, one option would be to replace the call to
> crypto_shash_digest() with a multi-step incremental computation.)
No need, 4GB is way larger than our image size already.

Thanks
- Youssef
