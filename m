Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794216429;
	b=H+Ytj8bJ4wMhjJppLOjr84FDQynHfrnBajYumGunHHBBQO3RXDNVS+5tYcER5U7NGgKI
	 rH945z6MMuFpTeCbg2OkhqKe8G06d5/ZByacU3EKJ+sKMShETCyedD9H3nzo6uuEZxK3C
	 gCCARveelX37JxqkxOpoMN3NCh/+SxGqNelpqJ275JN1i8WmWLVFDVzNRLi6VAISLgKeh
	 UR4+NQXIiAPPTMfHBMWc7953yLFBqPcc7sC4NiRdQxGiBSBXqe8OigQPYksCwADd4hId2
	 v2jWYmzDVVLmCA5oLLcab2oCO/ePbQyBCoJ/dtVOK8arIALsUHSkX47nB7+VjTrsd/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794216429;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=k98AldNnLDpToTE1usQ6ljOvdKlSyqcs1qtKA1cJ9KA=;
	b=x0tDGGYE630bAQQd7Jj42IQxGWyZM5O9/DEmZGH8hReQeIzesq5kVDiSjmem0DAgFLB7
	 CXTI+A15CFeydrFKy9o3paHSZrKFDLLFViYcRb9xcWIUwdM2iE2rieII0DQkMc06UcTbA
	 9cM5sJxAB3Vg02BqSJf52lXi7xrjJ4OaqKAaYYjBUzYcdWtbFVyHPWNQw/Aw3bFMN+Mld
	 AKp2KqBB2khkJoybPcFVn7wSDnW1rCNDrE4/ucwmFib5hIn0ePLHluSMs34WkIfQRdJQT
	 rFcWdvOHB/VNWLJhstxPZiplA9rgUXMpABn7xPzB3pc8reiBTs+ehKP1a/Mgz6QBR0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gKMQwUUU;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=aS+CbvMl;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62ABF606A32A
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 09:27:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62ABF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gKMQwUUU;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=aS+CbvMl
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A96AacY2008237
	for <linux-crypto@vger.kernel.org>; Mon, 9 Nov 2026 09:27:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=k98AldNnLDpToTE1usQ6ljOv
	dKlSyqcs1qtKA1cJ9KA=; b=gKMQwUUUEeo+I3aMqxy/wLQMDWMf3z2dG+pM9i+I
	V9+diFjLR/XeoZNRr3PTTXwE+xloGrPDuuhtRIEePQt3y5Tq92n6Z4K6PWB1wqYa
	NG/ieTLs4M0FJisJp79ntwFPFDLyfBsasZ8wYqZvsS8pdl6K+yYBLCApF/vf/lmt
	vluuc4pV2/bi0p1Fb1/AnqRXtODTQ5/TTZSLoPGNAaq1vIIf5Ue8syUDRdqXggZN
	SkCqZ/9YDkZxPyGmbrAAnRGS7Jq87wm1yrn5OQUS7NeLEoSe8CfFGN0KA5tXpTI3
	N5YDl3DxaQFfBXRDWnPlLZ8cVn2sI00GydtCUfFATo1dPA==
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com [209.85.222.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hsw5k5fka-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 09 Nov 2026 09:27:08 +0000 (GMT)
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-99063f4065eso254637241.3
        for <linux-crypto@vger.kernel.org>; Mon, 09 Nov 2026 01:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794216428; x=1794821228; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k98AldNnLDpToTE1usQ6ljOvdKlSyqcs1qtKA1cJ9KA=;
        b=aS+CbvMlvbFzd0c0FE71ZGbrUiKGQg1bDxDPdeYpFFlE09m0vSOVQ6VTdxJ6dvVdHd
         PLt40791iu19ixjtx/1KALJg3yi1yK+2TGPMmp4yVg7AXvG5OCkIZaoHDJZKf1w5AgaN
         wA5pcUXPIexCRKSgeafNw28R1PurxkWeG/sGNAdp/W/PUmf/HbCH8AbmbJCC7tLIiRoo
         TTD5XXo9HCPMXHm7JXJ2bOUqKd/6FymIS+qyaVU+PMVHLRRc8v1Zp6H6pmwa/ZN9XvdE
         fLZZ2I9GLcRDDFMYJvOq/aVBJsRSFyx37D52POl7Lwvy5TrIbRtH3Nn7GJqGUIpFA7NV
         9yEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794216428; x=1794821228;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k98AldNnLDpToTE1usQ6ljOvdKlSyqcs1qtKA1cJ9KA=;
        b=jwnZX1b8AjIsSsRl4PaF61yeoWNwb8kJwXnaEYQ9bFVXhkmypdK4ZbMu7pzreeWVl1
         hUFEtWjurhxs6PNKQhjXje1UsbRgSqxyoeJpxFS9dqcdkT3cTTE9MfRnPEaIIuqlOBv/
         019rvNVMoN/roSGONOVfOie0Zke5l2IksZXHEA1+ha9LNyU5IVimbpBJPWqLCPpa2yas
         2d3/5W9kgYgoeNbyDrvKkcxylFxOiHMI8zuwK7QrrSjBLLoLLTSw1mRpOxXqqp1gspGO
         Jzsghh8FYcMuS/ISedqeLlJxD0eZjKK02PPGcmG+6pk3v14hUHv+g/iSR5eMYU4RyX/V
         cRJQ==
X-Forwarded-Encrypted: i=1; AL+hErFkYk6/Zdn3LAeo0mEinV8s7EPUNR83pqYA3hnXPwb9OTmxDQAtIMLhi/JLpT/+07HUTjsQv+3t0vHn6Fc=@vger.kernel.org
X-Gm-Message-State: APuU4Z/mU/pNKl/2lPMO9Enpa/yJ6WIMMSwn47e2mNaHV980WQN7agH6
	4MRplMTPLzu8GKvw344QWmas4vwu3Fy3dIpB2/ZFt4U6KN25CVITOa/q81tmb527mn0UKz9+gP+
	aioqD51NqbUd7CIeMZjJ6BvRmCp75ohrnuRksB1mtnf4vY9/Ro+FxiNmAJ8VBVfbDXmk=
X-Gm-Gg: AYBFou0qXDVXAHVdlw2WrI4oRWU/HF53MhH9F/g+PP1dZLw/8YJ88PTfcNXHVDs4fvw
	7bwNYUIwZef1/bPvdaHS0shT/EaJjal1oZsSMHlV6qJOCnB/T/2vA9/MyifINi2Yi8gNpwE9RMh
	DGtVWB6o+V7K/dmqYyDwOPyLgoiTZFzCBi/okmeCNxwx4WQHcO6YVOoT9gCoKf+Z7qfx4Rqd3sb
	83JRc8mGlJ7MWQA7sIPvPYzrbEXGutlWo3TEwz94sXDiyZ1kLua/Jo/iT0AO9Dv1Iuc4DBHYwVw
	N2O0TjNOIgaG4dIrZoo+z+Z6h7tifiRrzmP5krDrhc98eX4tieBh8EIcESguQNeE3oZOG/LWaA2
	2OKg/TV6u3pt1EJ5GUUl1TerfOBUEnFingDZlQrcG+n0zGVUDac0ycwTFsPJhNCY=
X-Received: by 2002:a67:e702:0:b0:7d2:cdd6:6c8 with SMTP id ada2fe7eead31-7d2db13142fmr682423137.21.1794216427364;
        Mon, 09 Nov 2026 01:27:07 -0800 (PST)
X-Received: by 2002:a67:e702:0:b0:7d2:cdd6:6c8 with SMTP id ada2fe7eead31-7d2db13142fmr682404137.21.1794216426710;
        Mon, 09 Nov 2026 01:27:06 -0800 (PST)
Received: from oss.qualcomm.com ([188.27.161.77])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49597371cc4sm8477370f8f.36.2026.11.09.01.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 01:27:05 -0800 (PST)
Date: Mon, 9 Nov 2026 11:27:03 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Andrew Gigena <mail@andrewgigena.dev>
Cc: Abel Vesa <abelvesa@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Jhu <stanleyjhu@google.com>,
        Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: sm8150: Use standalone ICE node
 for UFS
Message-ID: <s5rb27nhurw7arvnem4yec3z65oscezjvlj7flmywcjfqjgyou@25v7efso7zf2>
References: <20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev>
 <20261104-sm8150-ice-rfc-v2-2-d697bbce0278@andrewgigena.dev>
 <dxb7s2d25ixowmfifhvetctpckj7h4y5puiai7orhkimgj7uxu@ekhwvpm536mk>
 <CANn8UmeS0Fvdkamzu0Cgbv25+WdjHsXvCLMpsL98QSo-Gd731g@mail.gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn8UmeS0Fvdkamzu0Cgbv25+WdjHsXvCLMpsL98QSo-Gd731g@mail.gmail.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA5MDAzNyBTYWx0ZWRfX/eJ6e9AEskq3
 /vJebX/JLyNoLCNTZyYb74ZI02BFp9d13039XuH44F9pw/X776bUDiRYcwi+y42N6eFwg++XKzC
 +Qu2773Kh/bpj2ap1fkHmc/T75G7yE/5zQIVcz86u7hllueMJV98ZcGMrpnocOiLiTZhciT3ryq
 MGiHk9R9hHUnpYKCXIcw/9Af8ywCuS1eWkXlQzzO0O49piCw4I9r8wav5tzV/cZbeGofHJ6uQEt
 Hv0nJzergQNNEi2wrUnAE9n/OiVqYT6TpZcyE7zHE/5xt9bl2H+PFv0MPLwc4wtAPRrsuDygg07
 XhGvYK0UMnTlUJKaBPjf+wWkZZLOXHDWfC5NBHaZ4LQgPd+vzsJfuTdPF/Zjm8TTXaRYHEunpep
 mgnYwE85matVzh3N44g4UEHK1ez3XSBLTGH/nygIhUw/Iuqm0FCrPlG9ACWVTNf+pT209BiEsHI
 ScXRA92w/MWyA1zdOSQ==
X-Proofpoint-ORIG-GUID: ZxJTAGbaAGvq1eguswBMJzp6KyZs3h_Q
X-Proofpoint-GUID: ZxJTAGbaAGvq1eguswBMJzp6KyZs3h_Q
X-Authority-Analysis: v=2.4 cv=G/aJgNk5 c=1 sm=1 tr=0 ts=6af191ec cx=c_pps
 a=R6oCqFB+Yf/t2GF8e0/dFg==:117 a=asF+/XNaGoxFafzDDLC1GQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=n44UkhTd5bL0-s0LC_0A:9 a=CjuIK1q_8ugA:10
 a=TD8TdBvy0hsOASGTdmB-:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA5MDAzNyBTYWx0ZWRfX7/akmwh0nI0C
 zDT+JNMsnlO5E1GmOSJYPAc4TRVOgN6jes3T64eU3YeKamS7kGO+SQU2Te90p53DA+E0KY1oslE
 3Y1nRWbQNsjodGI40ib1AKrg6AbgX7k=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-09_03,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611090037

On 26-11-05 18:51:44, Andrew Gigena wrote:
> I understand, I'll keep that in mind for future patches. Should I
> release patch v3 removing the "Tested-By" now, or wait for other
> reviews?

OK, now you are top-posting.

Please read through this:

https://docs.kernel.org/process/submitting-patches.html#use-trimmed-interleaved-replies-in-email-discussions

You can send v3 now.
