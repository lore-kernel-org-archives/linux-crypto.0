Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D752F37F01E
	for <linux-crypto@vger.kernel.org>; Fri,  8 May 2026 10:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778235336; cv=none; b=uWZ0ohryY1NH2CaWfzkBZBj9D+CGX+QFN0cS2PsDxTDD9iQFhWg6mPS3TqxvboCCX/lXGbyjjKVwAUl77Y3iCaRpw+gJcNts8JdyEkp+rRl3tACEGlccmyVFpbufxnQW/D401rbyWvkHQ5aqNOBr9BH7Cp53fLs/5PSJTHvH0Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778235336; c=relaxed/simple;
	bh=WLedKuZPuDKCqCqHoINHvHjza8SW+YDijRmxrez/934=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OYjcQkDuh/cT8yQ6oFWpmeUOl++X91mDpDq+1+A367rJelfuvy/pq9RvGmrf/H3ayOtyxCtCEdP9vGO+2+YjD8LOR4fHxWxsiJsv3lOYO3UhYGS4Q24iCWS9nBLeMTIJfuFRo3Bx0jsksZSnKkfTdMQnNdJoYBv4hiIaZ1DljdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nEoyoHA/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ag/wBMqX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nEoyoHA/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ag/wBMqX"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6487KYto317365
	for <linux-crypto@vger.kernel.org>; Fri, 8 May 2026 10:15:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=gWBtzZ/qvxKX6nOMhDTeyvxQ
	OevmU9VUTHONpMGN5HQ=; b=nEoyoHA/lExsH8e1z3rol6owxcE4E4og/eNPM2lC
	AR4QLhhhw1QDR1TdShUBb7zgmjsykchu1gxkzj8qo9ng7MPK3SX1iLNsW20J5Bcs
	G7KrFeyvJ5eSp3tSg23pImazd4UhCD++SKuNQcbaIRYZ3jeZWD98aIyT8rVuL0F+
	MJJmm7kwrl7ECCDjTC+rbdwGSc5NqIqTui8e/kjKIIdIRjt0gfSfAegWIsbkFIjA
	q5xShiYgcKo1VViSAW4YcXuLlxZBmSF88P5Y9FXOm3PF1OnGEvpg1hModbUEZ2KP
	51GN2yv0tCELqNsKEidveZt/FsLRcCfKh+hDVFrhQut1Lg==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e1bc00pt8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 08 May 2026 10:15:34 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-12dfe06b670so2862747c88.0
        for <linux-crypto@vger.kernel.org>; Fri, 08 May 2026 03:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778235333; x=1778840133; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gWBtzZ/qvxKX6nOMhDTeyvxQOevmU9VUTHONpMGN5HQ=;
        b=Ag/wBMqXZvmOJ4F50qe6qmoMe4upILiBfPW5mTrqtJ3Ta0aj7j2rYn5oHcQN4V6obU
         YD7hI8qqtkPwRNNzzNDYOL3sNwPoLWqo6ZbC/2ZErDbx8K8Z1qZqxL7KOugguc3VITNS
         JS3Pvrla0I7yDQFncGCGcBUizox++hJoazBSgq1AFE2p/4HfqWp2WCovxTbQEyH9SSDI
         2nQwwLLz9H5CjbtKdHTGCUy4dTCroiMtGg/4xysi5No32PKnkpoizaw9+0MQu/3JtH0V
         cRmQT6EE5dQ8A08jvVmTT2J7PdVc3KCmn4XcI4TkCFGYV2/zaxak3ULDJ/+Gwvca/B5S
         94ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778235333; x=1778840133;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gWBtzZ/qvxKX6nOMhDTeyvxQOevmU9VUTHONpMGN5HQ=;
        b=PCQMv3j9rys+C2w5K0dWLE341LDxh0vRO0/omos0wXo/UrRgAtOGT3Ai9YbalDBsmw
         HwqWXg+k0tl5Ps1l6WlgzZ2gh8r9/MkAbfxf7mbMMZ2HnV1oQeYatB09TiDZIabrG9ZN
         Km04sYmUBsHDoWR6vV8UW+dbHoFtsDXT8KzbpeeUh9K/VonxHtoHtfhuF8uwAz6+lb04
         cd1+OLaabSQrcsWsaSnHgKf/gz0V50QSQUYpjndcv/i4Po4R1P+6nKy98+5X7Vmltxpq
         YPIvwF2eYs4cRhpQrPdnShTRkb7azAibtGaVEa4N9QlzWoEEnLY4aSQw8PAIAAwoJtUf
         114g==
X-Forwarded-Encrypted: i=1; AFNElJ9sp8e/E/A9UdU0GPaTxzBH7e7LQ2LLct9juwPX+qnuNOS7bCxeEt1yD8r4CBry3zA813Cd6zQT9bANMgg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy456Gcq4m/K5gXFJB+r9yUAeuUzYplemfLtUZxinDclV26Royh
	zu5vzdCtOaCguT5gAr49kJwQDUtBVKW79MI/bfrGHwpXvS5c6xjYy561pY5RF5MGYpHu7iUX+Ix
	70fBzv10RI+eJy/GclZj7Chg/CJzplit/4y0xXjb7glnzHJKBE07vbUS1+/hKBxP7JFI=
X-Gm-Gg: AeBDievnI5bIZQGLjHj+s/AFoC5co/+fQ6RyOvFilSc2wP7aBs7CdSDJ+IZhcgb/6nB
	7tgYoB0AP6mewDnKAl0/V+hQc7virLVZJbY+CM5uhHLSvycZqMMJYEOZJVJDVbpj9YhFtfhahWd
	NQVgxIIbz/Ak/oactK7yCZy7mjYbfpjqYyndfD9fTqPZQ584X7Uyfllw4inIWht1XknpB//0U1P
	Z2hh3CypRq7hl6L/1tJQjuu628HvBs7xesecX+QRlJrtYjCn0VSuSzgav1UjtNlUvFJg90DYvLm
	QxH/ZF12ev5mMKH/OeVfZDN+NbF5ba1d9AfQMJFjmGkMJVMKEbasWCuwa5mPUXZjwkdRpdTcaFw
	8SCyEzRLXQW/+m8RtHkdVviyqSnQlUnX3ESImMQ/fQdL0H7jym3xGUVZueCME+atw
X-Received: by 2002:a05:7022:ea22:b0:130:a479:7995 with SMTP id a92af1059eb24-1319cd3ec60mr6486671c88.33.1778235333502;
        Fri, 08 May 2026 03:15:33 -0700 (PDT)
X-Received: by 2002:a05:7022:ea22:b0:130:a479:7995 with SMTP id a92af1059eb24-1319cd3ec60mr6486653c88.33.1778235332920;
        Fri, 08 May 2026 03:15:32 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-132787673ffsm1942800c88.15.2026.05.08.03.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 03:15:32 -0700 (PDT)
Date: Fri, 8 May 2026 18:15:26 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Nord ICE
Message-ID: <af23vhe-LQvW6lco@QCOM-aGQu4IUr3Y>
References: <20260427010527.230473-1-shengchao.guo@oss.qualcomm.com>
 <20260429-important-panther-of-drama-00f5af@quoll>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429-important-panther-of-drama-00f5af@quoll>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA4MDEwNSBTYWx0ZWRfX4Vut8R3SNYcR
 4UZwA08exmfqL3isOhdAe62CJSCjV7K1FpWQM+4gjeKG7q4QeePAm5PGtXEetl9GvRac9VqkORb
 SoMM72LYyJkP3qNKY4YravRYZe4ntzV5QmSGDxN7Lu6vWrq12WKS3NJHYmFRtYd6HidFE0G7ypP
 b+a1rCNKnzdnD0F7YvLW1GaB0xrL0fKAguVpSidl3JisigCOHkBqqw0JU7/lw7utya7/vAB3vSs
 6sFOPFTBa3FE5KgYoe1krp4D9yH8ggTQBvuqx2MEdVAjfRgFqHXRaZWW6ZHjvGjfCpGuEHy9eDH
 CL2tj69cdTg9YTfttAZlUrrNzBkaqxlpvwbxRu8NadaWpVYpUAKFHxwcuJv7SkoWfwB8NsIgHoy
 gpsJaKKkAd30Lz1O8Xl89nUFR+nPDkzJJg3jT9j3fJ46GKFyev6kR034QWQ49k0DD5qcnM6mNww
 D0crELcSMdeNpsY7PjA==
X-Proofpoint-GUID: Zhi-M0wL7BWHuRqVfn0G39q5DwTM71vI
X-Authority-Analysis: v=2.4 cv=JJQLdcKb c=1 sm=1 tr=0 ts=69fdb7c6 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=OgxhjLVz-CMH9HgEXFAA:9 a=CjuIK1q_8ugA:10
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-ORIG-GUID: Zhi-M0wL7BWHuRqVfn0G39q5DwTM71vI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-07_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605080105

On Wed, Apr 29, 2026 at 09:15:35AM +0200, Krzysztof Kozlowski wrote:
> On Mon, Apr 27, 2026 at 09:05:27AM +0800, Shawn Guo wrote:
> > Document Inline Crypto Engine (ICE) on Qualcomm Nord SoC which is
> > compatible with 'qcom,inline-crypto-engine'.
> > 
> > Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
> > ---
> > Changes in v2:
> >  - Improve commit log to make the compatibility explicit
> >  - Link to v1: https://lore.kernel.org/all/20260420073301.1250197-1-shengchao.guo@oss.qualcomm.com/
> > 
> 
> Same comment as for SoC patches - do not split patches targetting same
> maintainer - crypto - into separate patchsets. It's one patchset.

I will have to resend this one alone due to the request from Harshal,
rebasing on his ICE binding update series[1].

> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Thank you!

Shawn

[1] https://lore.kernel.org/all/b8805117-d54f-4e42-a7d4-6fa18af63e69@oss.qualcomm.com/
