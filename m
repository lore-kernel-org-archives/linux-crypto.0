Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C0F35A3B1
	for <linux-crypto@vger.kernel.org>; Sun,  8 Mar 2026 16:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772989045; cv=none; b=c49sKUg9FHbx6Au1t+iQJH5qA758GaHrRM9cD2oOq/tVkGusjaMyOee7rcl6/+aCa/tsDTrd37/YFizM+J6sUmRAyFtpLMJG5Wgah/dsEWbzorbv7PGV04pgk3vwxt1yLQw0YZ++WXtqZq0okYgBogyX7SuMJaoSFqExJ8h8jRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772989045; c=relaxed/simple;
	bh=X3wrQSXnnCcmNuhfF7cnxRhEbjLadrA8sMb9cRcRBrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jVUEWN4hkyaESdSGfr15iaLX0lZkrwRA+5HNAMydH5spwphNzuiZAmrmScpsUzhDxkcV4b7Dl6t4U4ot15Wv1W0Ceq9HqHvitdBRgD7n8+R39qhjHEBBMgr5lEXev7ezDhj4PcT2Xd/x5gDZrMvOSo8gRWITi3OoZ0XWLInTL4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KVRoAiz2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=azIZyKdI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KVRoAiz2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="azIZyKdI"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6285FIaW895140
	for <linux-crypto@vger.kernel.org>; Sun, 8 Mar 2026 16:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=iAM93eomdwoH7HQgq3/Vroer
	EAtPZOSWavBhBp94HMU=; b=KVRoAiz2iDzEeWJ8jDRkRn/zNE/17fvaMFqazqeF
	aSR75uOVVzQuRatYm0JOU9NW3hM4FY5FpXbiSl18M6akwgsytjY94/U5ATVROXnV
	o+TuXZgAJJEUOvV/dcnNQ/fa8kBkDO8C+/7AatvAqG16QWYfSS5GnCBvt1+qyhUm
	sZqH+CNd4jFYvrdpuLveUaPZSUDU0TWgZl0g9gdRe9PfS1T+vizlSPQHQbUGK37a
	O6L41v6zUdLAXUbN/GRk4Xmk6HOo4qh4rtzL5bBcz8p1ch23bdbgDmRWby3Rs11E
	snaVYZWT6qN6QXWIyaHtAiWlC55TxdSabThWRoAek7jQWw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4crbkxtvjp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sun, 08 Mar 2026 16:57:18 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8cd7c4ab845so433270785a.1
        for <linux-crypto@vger.kernel.org>; Sun, 08 Mar 2026 09:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772989038; x=1773593838; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iAM93eomdwoH7HQgq3/VroerEAtPZOSWavBhBp94HMU=;
        b=azIZyKdIvx0j4d0KRcCU4rsuygy2aLYlc2b/XG8To4wLQiyhERsgAxyt32/g7XDcVx
         l9HSGkSE3PIL/H6sZorWaw581sQno8eYHx+V2QKVgPOeM/9nGzzDkj52aEteuF6USwni
         OhuYZI9xgzJjH8v0Oixi8JTxNIqWgVmPrqHnOGvb+WaX8W3AMjc8PZhfahRevynulx1q
         9f8fmCx2AFuqMst93Ez6CjzSOvRIXv4PQd1jTEs6rFrAtNgOkRbjwjftLXza2KmPPdkE
         mUB0/ZQFPsXQWqDzG1gRjc4T9Jp9FcW6GmqK274YjGlkmqk+EKYUPwJV3cb+nAja8KSW
         xacw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772989038; x=1773593838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iAM93eomdwoH7HQgq3/VroerEAtPZOSWavBhBp94HMU=;
        b=D3GPXP50ZopMVnW9d3xaUSDwgwaNPnW39/KEqiSWonl8P8a7XP/mtvJqKpHpxENRGu
         zWtHwkjiqC1O/Yy0UwVu1Nz3QOSPpOOR75k7TGH6Mbk7Gd7/P2rjNYYKWhTo6cXCBXT7
         Xvwqa42rgatgGPsYTP0f9ZJpgql7sjOH/hD8cHfX4tUtdAGhOkRXzgaXbjm0PG+PzqrV
         sDhok1IJZe5xL1uL69oO7LrKkaP0nypaEczxUJuIlAbN5AsXK6OzWHQeuoKE5CnBx0cc
         GlouRvfakMsxi6l9wk/g+ZRXgY7VChYkJ1vdE2sOGkCsP9BMoimnNFqrQaRvIQeuDKGr
         RjLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUkVAGWaJ4Pc853wmebXN6jTnlU+l2f6WFhQicr7XfJ2/4D47qVJKTsitzu7ANQd1lJzRj9ICJMc7AbOU=@vger.kernel.org
X-Gm-Message-State: AOJu0YynCqQ1k4+jSO8Aa8V4NF0Crrpf6FZXQQifpW2Bi7QFX4f3FotF
	oQOLX972cbFJ67D0B8P8LArUbUoMCpZ6SK58D5silsdpfT1Rs6qaJkJdFbDbyiDauLrgyNTLTDe
	SUA2MrqrH9EKIQK9d/Oozeov1AjhEYeIExrFS4Jq1Eb5Z+bh2ReLBFJKvm549VZOxseg=
X-Gm-Gg: ATEYQzxsBEqUkWUpEu073/H6LXg2aL142Ko16GVVYVCGdAqKyg8Rb6oyoHWStH3GZDX
	6slykS6Z9rJ6b/f/6BWyevk37oLzygmKi1YpKdi7BmPiZIlp53+G8K7JOzU8lY/PVczSbrKr1JM
	+C1xqRyEsQKHwK2NHFWkhlREFxVq/bNqpx5DDetz+ZmEFPgV3b/TUY5DEcORGOYHCQDZh85lb/s
	yLTlFxEehXiBRcd0Niubq9qsolz16xAg/5pGVENgpwAGmZsROfNy2BdIprkhou02DTK64Sx/MMi
	N38vHGhUlg/ekp2kb+jwnBgjQ8r/5wejQsfBhY1Nyg3STAq3Cmj0FJo/0KIFskOO71TnrKUXLpi
	8CgrpdbNtjNyPe/s/k2Mr2+b/+s/h9Zfw2M3kuLi7dNHKjILABzFT5K1Irunu7eobl9C6lL2OOh
	Vemp67OlbSGwwHTZbG7m3ZIr4XnDAASUdyQTY=
X-Received: by 2002:a05:620a:294b:b0:8cb:4543:c5cc with SMTP id af79cd13be357-8cd6d36c445mr1018185785a.20.1772989038121;
        Sun, 08 Mar 2026 09:57:18 -0700 (PDT)
X-Received: by 2002:a05:620a:294b:b0:8cb:4543:c5cc with SMTP id af79cd13be357-8cd6d36c445mr1018184085a.20.1772989037726;
        Sun, 08 Mar 2026 09:57:17 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a13d07e074sm1631045e87.59.2026.03.08.09.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 09:57:16 -0700 (PDT)
Date: Sun, 8 Mar 2026 18:57:13 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Alexander Koskovich <AKoskovich@pm.me>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] arm64: dts: qcom: sm8250: Add inline crypto engine
Message-ID: <zq3rqekjzvlhsnya2knmvz4xni6nugl27lm46f3vferfywbdju@xe4d77lus2ro>
References: <20260307-sm8250-ice-v1-0-a0c987371c62@pm.me>
 <20260307-sm8250-ice-v1-2-a0c987371c62@pm.me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307-sm8250-ice-v1-2-a0c987371c62@pm.me>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA4MDE1NSBTYWx0ZWRfX1dRnLcfYQybQ
 DMXrhdGyC21grkdKVjQZTbNOAuvO/LRQYg5YlUsXC3/OzhVm6ITpI6ajRrDhKBLZ3NTaHeobTYJ
 5xTuXzfC03zCxB3ux4HD0aDypnxCW0wfa61DnVTHTiN4kQNbEzL7bncmbhkHBEG8dOYOlbMjHLh
 LjBvXQAxo/P7QLHAm8qrqL4d7m1f6e3fdulEnoQnDhXUZlWbvGP2jGNOmDyH6hlKaX3/Dj8ye2W
 8Up0qmpN/esz7qL2VqiA91eL6hsIG6RNn44Cv8S3nNuCnm8Ctm2B5/BoJtcFKz894rf+oT1TYVn
 wXGEbqjEt5Dapq+kW9xfZ5nIJlCbuT7nc28XTx3tVzuD5I6W/Cc2BDYXvmeFQXhX7yXgMDIhve1
 aat9IoJFX5LNqlM4FiQRYHs1u7qXeNLL7VZALOWbVbJht/1653//TDwmGJEGPM5OctRwwE4anie
 3CI+9dWAC07tvM8dvEg==
X-Proofpoint-ORIG-GUID: eRaDMR0noY0JAXBqaYMPLr1m4-4HK8RS
X-Proofpoint-GUID: eRaDMR0noY0JAXBqaYMPLr1m4-4HK8RS
X-Authority-Analysis: v=2.4 cv=LOprgZW9 c=1 sm=1 tr=0 ts=69adaa6e cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=F1DPrRZ4MOdNTT26lOgA:9 a=CjuIK1q_8ugA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-08_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 malwarescore=0 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603080155

On Sun, Mar 08, 2026 at 04:49:05AM +0000, Alexander Koskovich wrote:
> Add the ICE found on sm8250 and link it to the UFS node.
> 
> qcom-ice 1d90000.crypto: Found QC Inline Crypto Engine (ICE) v3.1.81
> 
> Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
> ---
>  arch/arm64/boot/dts/qcom/sm8250.dtsi | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
