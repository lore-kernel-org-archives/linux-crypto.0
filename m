Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE788346781
	for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 19:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771441361; cv=none; b=GNAiHoMXfR2qculR5YKqaNZIswzoYQprKW4aZYe8AypmAZMqQ4wW9xsn7pjNRK329D9efd+ikH4+cL331pizVFhcbYVjREykhMq/ME+UM9nUSs6vpKQnxSFt6f7/hCH+PXazAdhPKkDtTblhXBBnWcAN1Wv9u0estAUv3srCYPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771441361; c=relaxed/simple;
	bh=NPAOoz43RYhuDi9jjIeNQ9/kIJzQjAIj9Y0mBLlSD+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sv0tJeCKfuZd0ioBZZayYUmCmsF34WMCxL26rraEaHvD2105mic5vEl1C+hXrEIkzgsfqxfYyLD4hUAQEBHBGDPCw9yplMMNp2H58q/GB/4NO/1ztqk1g4yjJlkxQYUIzd/ERHMxaS3NTKakfNFt+1Gn/swyUudT6/UIr1q4Bxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IWh8gHf/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MnsK3sDI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IWh8gHf/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MnsK3sDI"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61IBV2HG413501
	for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 19:02:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=tHJCzh7NaOhxkRn2RI+46rfm
	nRfRQdY+S86XdtOBNuk=; b=IWh8gHf/bIW7MG4nqxZcUTRpJ4wN11XMgDqdO86W
	mCWK5iJFRJLHXMZk2jBWKYS34q8kA/J4ENiUHX1rYBCYEtiIJh2/k7PnRu6GT5t5
	Gc3Kfh3wwCGZDjFcVV4Bck0wpze3EJSQAiLEPozL8Um7v9fYneaeri1cYoKNz+q8
	rS0FFCCjKtBhVrv2jhMG96TG2AHXSQdFnj2YXb0t4olSXAJ4kn2XPxpgvDKaHQyG
	E7bzODZKzjXdSet+/PCabyidlYK+LhRH41B6RhH6euUi6JW1xKcyt/DZGUfzEOym
	qBgxb59ixfFO4OOe7Vuqc8TOP2cc2KHDfufedbDACG7x/Q==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cd1q6tukr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 19:02:39 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2aaf2f3bef6so1050445ad.0
        for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 11:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771441356; x=1772046156; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tHJCzh7NaOhxkRn2RI+46rfmnRfRQdY+S86XdtOBNuk=;
        b=MnsK3sDI9oQa12V3+AzhLDoQ1oHq2URe4aPpRsSTSCCL776zRhUzt47lAiJ8wBDLt8
         X4Ach+/Y6O1VGQILNJ1zqNKb/jEK0fLA/9KncEBfpkZFAyAReRsCiZQAY2aVirdf0XVG
         kfSp6NbXMa7HP2pzmDVtTA3yZu6Mxl8YauEocVvfHQBJqmqaV8tEfejwGrSdMi8ZM9Jp
         7b7U9dl1hnL4gWFH6ZHe0PBnupUScCQLXf/Nw5fmxrgwz5jN/mGIOSnE5BazHo61Yi4O
         sA2vNBH86rXyKV52hg3Ax9f8ZsWtVVgAvHpLw5ON3RMSdTSxEVl4LDJx2FLC3B1YIDkE
         rXIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771441356; x=1772046156;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tHJCzh7NaOhxkRn2RI+46rfmnRfRQdY+S86XdtOBNuk=;
        b=vZ7r+9Cz5x01hPhKTTW/IBTwSdb9u7ik3drwnFDTtid5Mvlt1PRCHjtWFLdm/BOkvx
         UOLlZNGXaLIS6RDMKr8M0EYcCe2f39noQLFffRyLVdCFHbTCqW2P/CkQdaIu+a5/c8FO
         k5XYEiybgPnIorrKpsYHa7TjVXBi5MD/iqsvVkTDi3CK9RmqYmhYDqiumL2eWWs+eJr7
         gHsNm4mQMZWm397FjEDMEEBSvNH8cI62Jchk4+DNzSVxQm+nWisUer4OI99E+RZd7GJH
         NsCzDYOpzHUfcy54ODek0noUA0CTFaasfZB/fO8krIim67VXM5ZPUshHTJPQgHuyY1aK
         lVPg==
X-Forwarded-Encrypted: i=1; AJvYcCXOi/2rtNj6aHAAYJHTNuYlB/wceSXtL0zfAOPPZTdZuMM9fbYAkhjv+r2O8na5tK8P7h9m76llX739avk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHAVWzTewK9SYfwD6EEf+vc0OsAYJdfL/RP7YwBaCt0GVgnEZH
	UYctSqae6E6WgSxXlxiWDCWHxgCf2fr+EdYZVntH4g7JWcihdY1FrDbcc7LB0idNaWdSS9TYRS0
	amVY/KrlfgIrzGJBkxURIpmB+HHUfV5XnlSXpwcG00kIxHs2JuR4MIw2WZjlC0VHrls0=
X-Gm-Gg: AZuq6aI1MEzK2ObOaN+LaH/EqY/JgGtkI8nbc0yUQhXD7+YLF4wJmRunxuTOwNUejFT
	xmKAv8mC7nPg16WkpfspOA7TMlzq8+VqQMiSm0s3dmU/hAI44wfRBXk3hqi1rINBfXHZME6TYQk
	RpXP0GlyU2MxceN7c09nh9vUhZaNSq+SrwdrVU4IMgK9dzLzPSPxSW7YEQgcZiH8u/jSeENvUww
	kTUWykjOxq5YPKLuF94W4/0jG2RflCOfjFteirtSk3CsD6DerjmIoSDedvOqSW9L0vTt3dBuoyw
	yCTz3o8lAJ92TV0h1JWDhOX5M4gOJ0FSziQbGOI0uJ7gprXSlAV6sqQOnVgiyMwsDBl7LUnmgbc
	RVhY0k8CR+Uury35QZHj7jqYrngIG931nXnWImRHzdM1DXsV5aF0jJ9UWXtE=
X-Received: by 2002:a17:903:2391:b0:2a9:4700:2a94 with SMTP id d9443c01a7336-2ad1740bc3emr158533995ad.10.1771441356051;
        Wed, 18 Feb 2026 11:02:36 -0800 (PST)
X-Received: by 2002:a17:903:2391:b0:2a9:4700:2a94 with SMTP id d9443c01a7336-2ad1740bc3emr158533685ad.10.1771441355474;
        Wed, 18 Feb 2026 11:02:35 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1aadc7f8sm137306585ad.66.2026.02.18.11.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 11:02:34 -0800 (PST)
Date: Thu, 19 Feb 2026 00:32:27 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <aZYMwyEQD9RPQnjs@hu-arakshit-hyd.qualcomm.com>
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
 <20260211-enable-ufs-ice-clock-scaling-v5-2-221c520a1f2e@oss.qualcomm.com>
 <bfbe04db-bf64-418b-a75a-88879bf0bf2d@oss.qualcomm.com>
 <aY7MidG/Kcrs83O9@hu-arakshit-hyd.qualcomm.com>
 <3ecb8d08-64cb-4fe1-bebd-1532dc5a86af@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ecb8d08-64cb-4fe1-bebd-1532dc5a86af@oss.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=K60v3iWI c=1 sm=1 tr=0 ts=69960ccf cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=JfTRIjoQZr9pu4DAOa4A:9 a=CjuIK1q_8ugA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: IzK3W5of6LuSXwCEM09nnuVFyNjQx3Vn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDE2MiBTYWx0ZWRfXzxcdGWRy8yKG
 FdCkf1RDDleWEWVhhsNZ8qKEQOzBuSvwoF3ih3cxrPiTgnd2rc5/R2MP1WTKhBJl011hAGcY6G9
 aKERhUujHb/KIr7mM4J2tfAVBT3mde5CFLZCp7rZHDYDvaBD/I5JiDp3Nn7gYpbtA5UOg8ANc+t
 Zb7kClGQ8HPO2DPsJAalkTVwv3INruoeCccs3+iC9PjikqlSSYAI0185CuofA0QMy7C0mNaWp0x
 dEqLKy7duRfYHflv3Fd+mpw8NMu0FocO4Zc4FJ/zm8MknszG0q9nT/x8yS/5z4NvhWcueBP7MFD
 AzNvEkY5Ob9N79d/bqQKVnV0CnU+W6xUGmykIUO1VOBMYDSKWsvszKvjhRfqiBiANOzIwGJNMNW
 kqbbbLQ9hkBquSUqqCC3AnmOmBk+u5lY1HSmR8Sh6LPLcTHvqZKWvbZ4IGptPeqkWq+7NB6FtcE
 BBly8+0qewNx6rDk+Xg==
X-Proofpoint-ORIG-GUID: IzK3W5of6LuSXwCEM09nnuVFyNjQx3Vn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-18_04,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602180162

On Mon, Feb 16, 2026 at 01:18:57PM +0100, Konrad Dybcio wrote:
> On 2/13/26 8:02 AM, Abhinaba Rakshit wrote:
> > On Thu, Feb 12, 2026 at 12:30:00PM +0100, Konrad Dybcio wrote:
> >> On 2/11/26 10:47 AM, Abhinaba Rakshit wrote:
> >>> Register optional operation-points-v2 table for ICE device
> >>> and aquire its minimum and maximum frequency during ICE
> >>> device probe.
> 
> [...]
> 
> >>> +	if (!ice->has_opp)
> >>> +		return -EOPNOTSUPP;
> >>> +
> >>> +	/* Clamp the freq to max if target_freq is beyond supported frequencies */
> >>> +	if (ice->max_freq && target_freq >= ice->max_freq) {
> >>> +		ice_freq = ice->max_freq;
> >>> +		goto scale_clock;
> >>> +	}
> >>> +
> >>> +	/* Clamp the freq to min if target_freq is below supported frequencies */
> >>> +	if (ice->min_freq && target_freq <= ice->min_freq) {
> >>> +		ice_freq = ice->min_freq;
> >>> +		goto scale_clock;
> >>> +	}
> >>
> >> The OPP framework won't let you overclock the ICE if this is what these checks
> >> are about. Plus the clk framework will perform rounding for you too
> > 
> > Right, maybe I can just add a check for 0 freq just to ensure the export API is
> > not miss used.
> > Something shown below:
> > 
> > if (!target_freq)
> >     return -EINVAL;
> > 
> > However, my main concern was for the corner cases, where:
> > (target_freq > max && ROUND_CEIL)
> > and
> > (target_freq < min && ROUND_FLOOR)
> > In both the cases, the OPP APIs will fail and the clock remains unchanged.
> 
> I would argue that's expected behavior, if the requested rate can not
> be achieved, the "set_rate"-like function should fail
> 
> > Hence, I added the checks to make the API as generic/robust as possible.
> 
> AFAICT we generally set storage_ctrl_rate == ice_clk_rate with some slight
> play, but the latter never goes above the FMAX of the former
> 
> For the second case, I'm not sure it's valid. For "find lowest rate" I would
> expect find_freq_*ceil*(rate=0). For other cases of scale-down I would expect
> that we want to keep the clock at >= (or ideally == )storage_ctrl_clk anyway
> so I'm not sure _floor() is useful

Clear, I guess, the idea is to ensure ice-clk <= storage-clk in case of scale_up
and ice-clk >= storage-clk in case of scale_down.

Best would be to use, _floor for scale_up and _ceil for scale_down.
 
> > 
> > Please let me know, your thoughts.
> > 
> >>> +
> >>> +	switch (flags) {
> >>
> >> Are you going to use these flags? Currently they're dead code
> > 
> > I agree, currently they are not used.
> > However, since its an export API, I want to keep the rounding FLAGS
> > support as it a common to have rounding flags in clock scaling APIs,
> > and to support any future use-cases as well.
> 
> I think you have a bit of a misconception - yes, this is an export API and
> should be designed with the consumers in mind, but then it's consumed by
> in-tree modules only ("what's not on the list doesn't exist"), so it's actually
> generally *discouraged* (with varying levels of emphasis) to add any code that
> is not immediately useful, as these functions can be updated at any point in
> time down the line

Sure, understood
Will make sure to update in next patchset and make use of rounding flags.

Abhinaba Rakshit
