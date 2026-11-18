Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794990040;
	b=rFCT9IwlBGG3YH4lWKXf7/rr/EKiCZgifWldAzk+axabo4GPhUj7NIQCEUrsEwwg08JP
	 vy7xdp3+Er4SKMyoQYdmlNdWCWZC7UDH8kX4go2UPfuUxQIYBVcQ3EExzFoapwl2zH0v0
	 L2B8TU0GdncRGKmFSazTTx1Vv4Wv8kIlOdRPD5pzw7alAiugwv87tUq/oWCLhBarfXjkO
	 FngER8xAyHZ+q+qLVxqI/8ZRRa5fOnNn8JEQE0SFzVmMsRaCHkWssdbggNXKj/KjiuFhV
	 G257IDF6tRE740AoZAGNPU+G06VBRELEqhkhZNoljlGeUBL6hnigRHvae/vooC33usQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794990040;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=QkVY5AHVK18FZcn1ra/vmEzvx5ZMyaYWFnvweY5o15g=;
	b=YtYdt1aWUFn8BuIv+bOe8SUS/m9x9aBsXWSnWueW2HT3qzTilBUIGEA8D5PnOmvXsoev
	 JIAShUgV+/m72r2afGnGsq/WgnkvsbhMwr0FbUNI+/VbW0QtIbnLE2SQUOSi35Sk3CXVi
	 I1zSeoXaFgWUCUUyJXe1cZlH7FH4Vr08OydhsiybIwOj8O8xzzBNweH1AKxgYIBNb2ZaM
	 T+3walps0A3bTN0YBaeIa1/8K0jvUzkInJfwKO0yQq19qMyzFGEOCDCDIXPVqIH6rtwOm
	 WBkm8MYvlrqveydqEsfNj+kkDoYbjYccLnhYtFts09YVChmhnA74ImVsijOTPw0P2Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="XV/LeNew";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ZkmLnYVW;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C4E606A332
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 08:20:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69C4E606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=XV/LeNew;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ZkmLnYVW
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI2V3xD2106389
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 08:20:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QkVY5AHVK18FZcn1ra/vmEzvx5ZMyaYWFnvweY5o15g=; b=XV/LeNewwfUEG97k
	yldzCY5BeInVpnb//uYe7BSxPYCoUq/Ml61abvB39O6M8yeosUHXKNb1EnHduRqx
	cSM7zz+89FalgFEbyp0C3J+TfAHoGVK4Nj+NzcgzKbPgVogVX71fpUAkDyAVibSK
	yAhjdjMOVMzwQYv0BIMxQOkS5aLfSirpKUMkUwFmfE50MF8d9asypIXMuuLPA7I9
	VDHHUYh/meL90Mvpy6wVjpgk/iCvWCy+PETaneKlSWlwTnFn2Ygl8PsU8/ff241a
	sqRtdwshfqTlPpFAmGi3YbjMoP0psCxqEJJkUR1C6C+mMylggGp/9uSEjEPHAbmn
	nP1dIA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j0yv8sybr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 08:20:39 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ad704d4760so728416a91.3
        for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 00:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794990038; x=1795594838; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QkVY5AHVK18FZcn1ra/vmEzvx5ZMyaYWFnvweY5o15g=;
        b=ZkmLnYVWNFOVA9ITI+PkiKDIlG6UD0+MwNW9UOb0Ni8D6XwPFTbFealcIt740d/+23
         iNgXwV8Zd+K7esfT3sKTH58S+Wo1nWvq4O5dYBYnF6rTA/e+oSZMLsvl3pSGsM/+w9fI
         EQSqnQN6OSy2QGO+w1J/tWQSSYrtUdesksxAZ0Jd2fb0ofHl//kvD82xxtXK6TLuEbi1
         XNb4deLOrisvF04qWnmr2quZYSUQ64puoh7gYcDXiH2witRxPUmV+JlDNNvHBJL6itR7
         Uki6VDJJuCPCZIHbS9WoJG4YOWbzwxPxbZVCIZDHrDOznsbt2OBperlmGgIU3vFhaYkk
         fr8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794990038; x=1795594838;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QkVY5AHVK18FZcn1ra/vmEzvx5ZMyaYWFnvweY5o15g=;
        b=sHT0EQFB4XLsZ40zwK9GGXX6a4kNMvmDD4Vmzi1edUAj/rearf7Xa3dl9afnGAOrff
         HtE6ZbT3j6jrrVhvkBFQLSH0wmCO4N6SXECD7x2kYMRSpKXPATByo/oKVcODBzYI/UrJ
         fQwq57pU2Wloho88JQguhwuyXn2kr7+N5uJz3uB/gvw29xiKB6asXyICaig7d+FPMvUj
         Qa+BHzAETvw+HIBAfWL2kXxXufovP7iiFanUvj7on1DiEQ9+9bR6PLKiwYiJQOqKEbNz
         glNZ/F6k7N02Mv9YMAHTChhS3KBWRHolMEAQTiHugTUjBik/OhTLL/H6BHdOurq8taEy
         1wwA==
X-Forwarded-Encrypted: i=1; AL+hErFTZwzyFpEj4/bp1GczM3/iug8NZEvm+x9GSuVwtSAoseUp3pWATdykmv8pOyIxUMdbMWq8pV6fXw2ClPQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z9hWDzmSnTGqMrV0Bw5OG8b04NqusoCp7LAxWlM2+4u3TH+kBjp
	1TWubL97RXhoODixyi2z1CHMolY4fAlmAJMWcKlJCb3znLTQClBGQIyANFEG90St4IqhUD9s1SE
	RsFP6G+tTJ4XOhAWKn73/giSHmq5BSkanLZ4BGsCoTSdu812359RWaO69HhMHQoRrvGU=
X-Gm-Gg: AZFdTZf5QwOy6RWLQD1J1v46LVmdjWPgBfwxTIrPYOgIB/rVdsKxdVIvIIDCtv4WwrA
	bT3rNfdEOC6CEC33hV+Ni+AfyqVt7bp9dE5HdtqiK26yC1COxIPcy1HFQmyD9X3e1w6ARsyccYD
	X2V/at9X+9Krz1BKB9gUjlqz5/MFt2FgUWcKAzhiLgBvAWLFYOS/Q+T3j+iEJqRlzYhjrJ/gCGm
	iTLbMrePnvvLvZoBB+zrrw64ewENALuA+h5QX1Df916r8w/MGFKlR7l5a0KfgO43/a7MP8yB2wi
	lZCNmVoRPMLRiyQGsBChhUX3gPU8EX6c9kkVLp746IZj8yRYFye2ADj2lKaVEe0yI+q43Xiwz0O
	lOB9UW7TBvicnozNKckj52WDX1tXW7q6mhQgBxhIrEZSCKu+voGoHeFOFRg++fMLc92DkIXfm6g
	fhcRZiJlJiGML7fO19qHsZ0Bv8Xduacf3xngIkW9+iP2UB4j8HD6I+/RMNVWfoqbSd5FFkgbGB4
	QKz
X-Received: by 2002:a17:90b:5643:b0:3b3:a74d:f848 with SMTP id 98e67ed59e1d1-3b3d076335emr1655102a91.15.1794990038069;
        Wed, 18 Nov 2026 00:20:38 -0800 (PST)
X-Received: by 2002:a17:90b:5643:b0:3b3:a74d:f848 with SMTP id 98e67ed59e1d1-3b3d076335emr1655077a91.15.1794990037633;
        Wed, 18 Nov 2026 00:20:37 -0800 (PST)
Received: from [10.149.108.218] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3ac292c53sm8037771a91.7.2026.11.18.00.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 00:20:37 -0800 (PST)
Message-ID: <36bd7e8b-8319-41ca-8d47-eebabc6f02ec@oss.qualcomm.com>
Date: Wed, 18 Nov 2026 13:50:32 +0530
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Enable ICE for UFS on Qualcomm Glymur
To: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>,
        Abel Vesa <abelvesa@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20261118-glymur_ufs_ice-v1-0-2ffe4bb931a6@oss.qualcomm.com>
Content-Language: en-US
From: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
In-Reply-To: <20261118-glymur_ufs_ice-v1-0-2ffe4bb931a6@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: vzqyP_6qjFphxVQf0dPiYRdO72By1MJo
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAzMiBTYWx0ZWRfX0CvZNoEPlacc
 p/yNJgNi1Bcnzs2bM1S94p3jHlocxiSyDByD7iLSuo2MDdOOXrKykHb3JwOBjqoy4ne2vQ3VOAH
 RCaoVKydLWgWmxlL9HlfHy2sfPKEBuQ=
X-Proofpoint-GUID: vzqyP_6qjFphxVQf0dPiYRdO72By1MJo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAzMiBTYWx0ZWRfX5/H3ouhMh1Yd
 ONVjKS0sHYO8OEcLojyqhLub2uD1fHMcAKSc9QY2chh2qOupGrJV2SfGyvjbSA9Iw7ZjWs03OYv
 +VNpFreGs/vS6pg9J8pYxnNhzwTHQxwjFxb13JwZj7Oir1VV49HoIXjHJY7ODBRn5PvKC8rNzFD
 63rI5uFQaGots7mbmgWIs7HhDmw7/PMueoWuXvyJdZJU4s6NJFio6j0vAwNk+x+ZwIgNzvXQIiO
 cwzPk+aBFaA1O6Q3+4EUYAkU33+1Ru8uVsPVv4ZLkQTiJAOQo8OErfetnKConvJyOFNjY6WeXls
 r5TQjS3sNPWDVH/mkCS+GA9vu3mT6mccLJLmh25dYjUordB5Xk07xZW8ohYHf8lDIKiB6CTBdQK
 egA+NpGFtpVuPI5IHchBDPbFb1grnytp0jrOfm8/G8iXN7h9HH1lP4Bj9lBn9XbiWAbokfAMwJ6
 r2T+X5FCP6ndTYetFvw==
X-Authority-Analysis: v=2.4 cv=NNVAaE6g c=1 sm=1 tr=0 ts=6afd5fd7 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=knTtAJwehH_nPzmuHUMA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_01,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 suspectscore=0 clxscore=1011 impostorscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180032



On 11/18/2026 12:30 PM, Wenjia Zhang wrote:
> This series enables the Inline Crypto Engine (ICE) for UFS storage
> on the Qualcomm Glymur platform, including the Glymur QCB board.
> 
> The hardware reports ICE v4.0.3 with Hardware Key Manager (HWKM) v2.
> 
> Patch 1 documents the Glymur ICE compatible string.
> Patch 2 adds the ICE node with its registers, clocks and power domain,
> and connects the UFS host controller to ICE through the qcom,ice phandle.
> 
> Dependencies:
> Patch 2 requires the UFS nodes added by patch 1/3 ("arm64: dts: qcom: glymur: Add UFS nodes")
> from the Glymur UFS support series [1]. Its patch ID is recorded as a prerequisite below.
> Board-level UFS operation also requires the QCB enablement and PHY support from that series.
> 
> Validation:
> - Observed ICE v4.0.3 and HWKM v2 during probe.
> - Standard-key and wrapped-key tests passed
> - checkpatch --strict --no-signoff: no errors, warnings or checks.
> - Targeted ICE DT binding validation passed.
> - Glymur QCB DTB compilation passed.
> 
> Prerequisite:
> [1] https://lore.kernel.org/all/20261028-glymur_ufs_qcb_enablement-v5-0-09cda5e3bab3@oss.qualcomm.com/
> 
Hi Wenjia,

Please drop the prerequisite and dependencies from the cover letter. The 
UFS series is already in linux-next.

Also, I can't apply this series on top of the latest linux-next. Please 
rebase and resend.

Thanks,
Gopikrishna
