Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CF241A79A
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 13:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785160789; cv=none; b=u6c4wRko5VIq5datwqQ5Vu5f9DLZjZvzSmMD67CFkqyn89hCn5c6fKjmoi6WTYX7k1xTTZViiHU8PAWqDPU0ec7jh/zS2EG8LAPRyIDIALNF16VJTb45QpV/gzQLVqWQc18toryf9YClBqilrSeQb2UDM2etpdQXifPVOG00QqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785160789; c=relaxed/simple;
	bh=esRGRTb8ZG79IogezuYqIV6Kp9GKse/U3um4WLbcgIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LNAPHVN1Byd9ip4eK+EUmB5S05ikV8EHjyCk7nAWSAed/2iVgsckVTC3HZ2Q/mjHG3V6aooAJyJVR6q7dox597y7rspbaHxsIjDMaBZesYXEV/hg8C2JT57WWQWrS1eMPjwaGag5pZgBlVzHtfbOwtzw9NBuUBnzDFS443nzZwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RDC78ouC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=f7tnRDML; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RDC78ouC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="f7tnRDML"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RDlijo4061167
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 13:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=vraW4gIu1Rib0dQnAHZaMKCf
	cAcoUn73+F+RRFpCjKc=; b=RDC78ouCmrG4LvSwg/YiudSjJrG7PUzN7W8HOY/G
	ylujfJ1IOvidH4Qb0AYieXeTgC0kvL0NTdK5Q15LEE9NOphHMUAZmhOTXTRLPhaB
	8B5BTfUpATMVyw8b7beThT2HVEDrg6yU8ESgSiPYXFUsyAm+JFU2xeFBZMYvR0X8
	l/d1Kz9ixbfSayfNCjauW7nXLY8nt3agi0zsEg/R6PUvB6Q54FrojozdrbverR6q
	cUhE7wYlDU+nUdgCs9LZpAFvdNAMYOcWV1gOLWYw23a8o8lKW5qsuv4RemERSplM
	99q4gJVDYttytHIUiSaS0x1PcIc1SxgUHQvevuKEOgB76w==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fp4mq11gc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 13:59:47 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c0e702df8so33547471cf.2
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 06:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785160786; x=1785765586; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vraW4gIu1Rib0dQnAHZaMKCfcAcoUn73+F+RRFpCjKc=;
        b=f7tnRDMLgqJcheF5HJjtnwGbCRFOWLzuCbs4czU/cLnGi4nNr/29FWmbsantBB+wn1
         Peuno70+5Fz/JtSkxdB1ZI5v9Gu7v/3jKyaUuCshLjVmgUyQGM2TPR8njKZbDUnAT873
         dqbwS/17NCPK9Dskc1GagEBoA8TqWFcxQrDGRhv2kQzQYdFgGNHRHIEwMORwRefTn1aG
         jx4c4qwxy+8D8uQhBQjIAUY0s5PRP4/FmhINmI+hh+LbsRLTeb3qc5tNVL7lclA0h2Ko
         vd72yYW0FDni/aSLDp9+a4jt1U9bEiuLh8Ls7+GRomrGUfOnTDcd5RB8p18UDWkQBzv5
         3KMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785160786; x=1785765586;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vraW4gIu1Rib0dQnAHZaMKCfcAcoUn73+F+RRFpCjKc=;
        b=OQz2qISjrgci4vjLzkFaJI0qccreVoUwwEFwWOSNmBIRBVZLrggK23hiHpqrdVEnI4
         QZmNxzHOuocj+xbPFEON32g89jXDUaSj49s52YSmWfI/f644JNkTKdDyTk9w4Grq9Pt8
         nvC5k1cZ/4XHXSbplSs51lUzDXqg2CeRdmIDB+mYn+j2JSwvie90Dw/Go4TjxJoVLr4J
         muCGF8jgfbmaHXzDL88ludjpTKi0js/EfzXWcVZ8VrQK2qmCrcT7E2EVDHhJVIjkKOrg
         jJO3hwSxZD/JJ+eKsx+DaHwco6Y2xLSi8g5OFdscqiS4kIzDHilAw5HNc7rS3UEt9yOX
         17rg==
X-Forwarded-Encrypted: i=1; AHgh+RoMaUTSLoaGMtv68IFNQuBjIKxtN2XhKmkpacmJMwKHHp/FCkPeg3S0QAq0sDVTVwS+3J+JWotLYr7zcl0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUD2pt2q1gK7JU0T1Idnzfn15Yw2aLkbjr/dFCGLBnWWLhYCj0
	OJJjSgoHZXlwuxblLCNtcZlnFolHUwoloLwA/5x+vr0k9GCxs8Z9nTaO6knattz7pV9X+YPCvAn
	L5GmOa8l5GdTRtCnK7v3Baana3h+BsYD6iqphW1YnFY5Qmt1sBNzPsWDC5pHaJmEcT5k=
X-Gm-Gg: AR+sD12BtffxOBmsTeF701NFghtZ9fJbg+XTaENEf2LvNYHcsDsNu0Q6RmeaGFSnTHe
	/ZCj1oAw0P1x2y88Zh1H3EwPm/YIcIko06Bl/gFa6yww4vLp74MZoy7Ex+OaZLJr/wapG0E3+hs
	JhovVcxiiSBaNUY7Q7a4ttPfy2R02JvMsRPKUH+lIcPn9uMh9Y6ts2GOUJs+YgAY7ZbhBsDr0rd
	CixERKoYvR6y+/PdUtsNYFBMAgzQ6iMTL7QfQW5fqqsAp4wZjXC6/+f3gsjdY/3NrJia6bDbWF1
	1HJwLsG38cInYn3rxJaM5DBms36LzDezjdNbV2pLOoDwd9CO6Yn00HVNe+2lzfq0HFpd4QEEQbi
	q7NMFARYn44cDDf4=
X-Received: by 2002:a05:622a:60c:b0:51c:7b12:5fe4 with SMTP id d75a77b69052e-529a8870affmr76633441cf.80.1785160786428;
        Mon, 27 Jul 2026 06:59:46 -0700 (PDT)
X-Received: by 2002:a05:622a:60c:b0:51c:7b12:5fe4 with SMTP id d75a77b69052e-529a8870affmr76633091cf.80.1785160785879;
        Mon, 27 Jul 2026 06:59:45 -0700 (PDT)
Received: from oss.qualcomm.com ([86.121.163.114])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957bffc501sm199217045e9.4.2026.07.27.06.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 06:59:43 -0700 (PDT)
Date: Mon, 27 Jul 2026 16:59:42 +0300
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@quicinc.com
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: hamoa: Add ICE node for UFS
 inline encryption
Message-ID: <rlsjzz55hshfy5zrc2wyqfrjdqd7ekbxlrdbnpbhzuvhy6lq7s@bh5gn6yfmt56>
References: <20260722-devtool-v2-0-d7e609ef7388@oss.qualcomm.com>
 <20260722-devtool-v2-2-d7e609ef7388@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722-devtool-v2-2-d7e609ef7388@oss.qualcomm.com>
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEzMyBTYWx0ZWRfX1mEtMJ+l7MZJ
 VLMhK482D69LEU20gVcQ1rY7VLldxASmvixa5i6wf/1iLqB/GiKKEa+8Eg6N3qlQ5jAf3r4zad6
 Uib8RR4ZOQZCQyutUx/kfKW1/w0Yqtg=
X-Proofpoint-ORIG-GUID: J9v5LFQpr8zqXpTyEvhR1T0M9jhzaSPg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEzMyBTYWx0ZWRfX0ZhQUQsjYP/B
 4tcBv9rFNpaUIsadz9aur3xgu13CJpQMSxX4Er82LVJJH7AfbidLaA9mWdBFhol+e1PbEsdwICk
 bKE2m9oJW3PCwQZ8YqUULmhypzaWWBIxAB9eTRXonTOJwvMjQXjqwaJpvf+4Uxnf+iuTUQywUoC
 nG01MiZyvXxD8RyHdEwA2Uc0f17+uUV47sfa9HwNugW3CcSYFCKSbjkRL5LNCXgmf0HEyyqBpCU
 jRHAZ6EzcrRFiRSYSB6uLtC8Vxt+HNBr9+EW7rfYCHbqtwDRr21AOcWu2zRQ/2F/0pIKpgDbT1u
 zgubSPGhEKa+ZKzPRcU43HA0fXGTzpV+sOpvDzjRccHfpvKtnQFf9c4Mg0tqcwSri57s9hF38H4
 zU1PFD2wImzJyrpR3afHpEl08fi9DMXz4jZYxhJGSL6TsY6dAuSZOnbj9mJl7sauxcdyHdktgWs
 TCw5Z0txYuWbIB13PMQ==
X-Proofpoint-GUID: J9v5LFQpr8zqXpTyEvhR1T0M9jhzaSPg
X-Authority-Analysis: v=2.4 cv=TemmcxQh c=1 sm=1 tr=0 ts=6a676453 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=6dw9+iwJWV8PcCi9M4lOBg==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=SooqmcQUKh5i17ny3PUA:9 a=CjuIK1q_8ugA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1011 impostorscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270133

On 26-07-22 17:26:29, Wenjia Zhang wrote:
> Add the Inline Crypto Engine (ICE) device node to describe the
> hardware-accelerated inline encryption for UFS storage on the
> Hamoa IoT EVK board (Qualcomm X1E80100 SoC).
> 
> Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
