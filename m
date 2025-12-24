Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0AA332EB3
	for <linux-crypto@vger.kernel.org>; Wed, 24 Dec 2025 09:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766569272; cv=none; b=D7T8lBxV2yvzpSTEVf99hMOBk98NYAf0Ijjq9YMqdorAVIeDebSZly8a/6IIjgU4B3nmPXhe2t+4A141FUsd/dd+txO6yzYHevyeysYIfpAnhZItmIAGDVbsoIgavvkBzb0GXgKUEIJABwfPy33YhRZiTyBShOox1+WtalDi/i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766569272; c=relaxed/simple;
	bh=6Zs66C66e51oF6bvJb8P8PjF0Cgi9dm/YRAGCfn1CkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cRAZCqbP6Rl6s8P6QgV7Qot7iz+FIh0nrqNdVuSpiAYFDtL0mdzCD8QMdXFpTIF0G55XkXT7oT/ERBlPwAsc8nvpdl3ztHee3Fm2F0yemYxudRwjU9c+0xAENXtDVt09hPb5qKMjQBaP8ksPhKmSAhUkc+W5a6w6Ev7ykMCByE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=elRKjmpk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fgSfsdTx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="elRKjmpk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fgSfsdTx"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BO3wVAL3796889
	for <linux-crypto@vger.kernel.org>; Wed, 24 Dec 2025 09:41:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=SQ6f7DLxCQvzo2zoEIFtp+6H
	URQyrcbTpjg0JX/RPHc=; b=elRKjmpkM2BGjT4K4eEatMZAFeO8QrUp3gQFDv1f
	ePk3FhIjMdEi9Zt7R0ewYBWOSvTKJmHEc7lZAYuQ3ykNHXfYd6aZJinB2I5j8oxH
	FRrxPuTeCGTa8Itg+PYZfj+VLtR7B+D7JLT+44Xpk7TmI7UbhWH6jgEJKgNdV+8O
	R1fgPM4VWZdyFw1myrQyQG6U9L/UPLtAPINMi8TipMUSI8/bBAlBikvmIJeU1BIN
	oDyd2p5S22lWE2riiIbeJmGeJKKRIyRS3mKw0DoGdTeIH+Gv/cyoZimvFhnhRPvk
	5/fFZ3obql4sfBujBC5pmXHf8GO8uGoeQNeSLxrW/BkOww==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4b88r68sy8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 24 Dec 2025 09:41:09 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4f1d26abbd8so156804911cf.1
        for <linux-crypto@vger.kernel.org>; Wed, 24 Dec 2025 01:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1766569268; x=1767174068; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SQ6f7DLxCQvzo2zoEIFtp+6HURQyrcbTpjg0JX/RPHc=;
        b=fgSfsdTxKB5Dz2KVAOcCAov3lKuadn6axfrepwkw40EZgW0r/GHY8J6lmCTXILX3Be
         xDYhNhG2+FYbrRikLhcAUUn1CNkF4dhlc6yyrURwHEOAwV2lvcVmXEqR6sv5ryZVWnCr
         0b/jkvQXEVbVwJ7C8F/okJUydjHarWQjcbY1U9SyTPE7Pt5SGNOHO/RFZsiGCNmw9DVK
         r7A6BlvinY9Pifq2DxLvk5BNXwSTnHd30D0prO16jBx1jBRNtb0TKfNBofHxMO5dZjyL
         q2XjbBoYgI0tN58ESPQ858ADz03PTfqvtkQEMomgYsup0Slt/hn1LlNh4ozeXWX2bP2I
         PEUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766569268; x=1767174068;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SQ6f7DLxCQvzo2zoEIFtp+6HURQyrcbTpjg0JX/RPHc=;
        b=AddtSgvJCqtxk5SXg+LsHFVWZ9w/NxmP5/JDg0eB6alUMiBydkza/O4owdcskmdRW2
         VZ8BCMur3VmPz1dBmhZ6bIhBuyQMs6uiEXjz0d7Zv054ObLOWBrNBDE8HTxWDVAeqeTz
         budfEhk95/KRl28M/O270tcVdSdNDrZOKnhFf8D+MX7+CO87+WLJ/yOa4+ZZNiAZsd6o
         dc/svk9EZp26nNEFXMFb2lxXQsBhVhh2VgsCsJb+Po7w43dBemHsdzfsXPtZrDt2jRmS
         dnTxl2DNmmwIlC7EmbbytHUHGe+qIQC7XHM6NR4f/ut/fr4kt7yM/gr0WTqsn+09bsLF
         AtNw==
X-Forwarded-Encrypted: i=1; AJvYcCWoXc6B4rSmBPCbYI01CBdsq3H4HkXOwaCDAIBajUtiXmGEA7aUd36r4JuVaorVWm9ojYavBr5QT+b4LA4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNQE7X83d1i8Op3sS3wOMnD1eYh2EdMlVOKJvi9c1fvNZhtILX
	Dld++DAV9OnnJVJBtuvI15XxdPlibYpAKpN7PvsffZ3MkUgsNJpknsE6sZyeikRVLq6sWO8QWH3
	rZU5o1jkrqo73N6x/6IW/bzM0jKHWvyzH1ct1/zfbPNN+xWDxMfofvieTHHpAXjqiazY=
X-Gm-Gg: AY/fxX4y3YPz7UzXquEdMdQodGr7RCN9Qjh/wUmRtzCVnjbWnBiNqIVJWzsKY18Ewet
	7fspxWsKid8akFTubaHg7pA/WIYZ+0yPnRWQW2A1fxj+Nyzoua4SGXzrIr6IMl3trdCbzCr0emU
	9PpB8KMM8+oMqSechUcWHtKF/wsU7kon1Ar66eQDC4AL5IB0iReHHog0JI8pPtLhvcfQzEqO3jI
	CvdeP1uOngBicRedgZSpELyVe+Vrx2sAnTwh+tyXkGdY4qQARQbKl2bCkhn05oA+pUmlWJpMe8N
	A4Zkh+wmVhrie7aEctgJJi/nQJVeAZekrFX2t60/JFiT0ESTlqvS5GugrvTlnDjMywVHmgs0H1l
	PJCkuicm/dQg0Gshqjqx7Tg==
X-Received: by 2002:a05:622a:428a:b0:4eb:a8ba:947b with SMTP id d75a77b69052e-4f4abd026a1mr231577051cf.24.1766569268474;
        Wed, 24 Dec 2025 01:41:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQc/ycrEnXUpKToNeaSs4N+eKD+QMU/+LSgAENEXipeVqqqlcrAtRbgahJ/iqg8JC2K5dwjw==
X-Received: by 2002:a05:622a:428a:b0:4eb:a8ba:947b with SMTP id d75a77b69052e-4f4abd026a1mr231576871cf.24.1766569268031;
        Wed, 24 Dec 2025 01:41:08 -0800 (PST)
Received: from oss.qualcomm.com ([86.121.7.169])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8056ff4925sm1261298166b.31.2025.12.24.01.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 01:41:07 -0800 (PST)
Date: Wed, 24 Dec 2025 11:41:05 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v4 2/2] arm64: dts: qcom: x1e80100: add TRNG node
Message-ID: <boaewq3bo74emhq5rfssdbnu3tbqvtddodqn57bthywvo44wwd@75ifota7jfk7>
References: <20251223-trng_dt_binding_x1e80100-v4-0-5bfe781f9c7b@oss.qualcomm.com>
 <20251223-trng_dt_binding_x1e80100-v4-2-5bfe781f9c7b@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251223-trng_dt_binding_x1e80100-v4-2-5bfe781f9c7b@oss.qualcomm.com>
X-Proofpoint-GUID: JL8AiAsjS6eYPlmhr8oNIrJ_d3cmgKSt
X-Proofpoint-ORIG-GUID: JL8AiAsjS6eYPlmhr8oNIrJ_d3cmgKSt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI0MDA4MiBTYWx0ZWRfX0aG6d9RxJeOW
 5ei3xDOTuTZlY8HKHWYkLUWIT4jRhelXyKxUOHHDso+8crJ59n6Og/1sVl18DF5hu3FbYtDEOQg
 8LXJsDX/I99rYL0WPIrJK0tdhgAn6vw3BtjS4xt6SviNd5w0Sv7HIAdjwsowr8uYo7OsxUh8ObN
 U5uKt2ZHW0jfDZwnWc0l1wAsLzMgIY8cwXu+zCOYrsL8yJ7T8H4yQDgNIKt8sCp61YZ0qMG872r
 TnyvuWuO8nmwpN35/0+FtKRqKQgTiYnYiazIc4s+h+T6lvcBUkP/TLlrB8KBV5D3TIdaM3y+xwu
 Iqg3XnFzmLn4/ZEDoJz4ryLNo3LJvTGG/Cysuu9vmnhBK+VWqOHxE+KnHsnaMxaug+BbJm7ZBR9
 zfETgIFaI7ea9Og6lGn/mdgYfeWwxUfI22IoJ/17P4KmqlwuR7DeKUnazexTRN3ZpqMUu2YvkZK
 d+QopUuWio0QiUTHV0w==
X-Authority-Analysis: v=2.4 cv=Qahrf8bv c=1 sm=1 tr=0 ts=694bb535 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=DdBtMnqNxkYIvXj6ev4VzQ==:17
 a=kj9zAlcOel0A:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=WmeePSlto-DxRHfBUH0A:9
 a=CjuIK1q_8ugA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-24_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1011 lowpriorityscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2512240082

On 25-12-23 10:18:16, Harshal Dev wrote:
> The x1e80100 SoC has a True Random Number Generator, add the node with
> the correct compatible set.
> 
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Tested-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
