Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4B32F28FF
	for <linux-crypto@vger.kernel.org>; Fri, 13 Feb 2026 07:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770967939; cv=none; b=T/DhiYRkuszqBv8CP8hNXKfGE1ZEjO5YZlYIHHV+wZg+JRfvyqE/bXrlitovmPKGbZ6EwHwhjwdLVEpbeJ6t9MXKpFLNqFF6ODnLXrix7nDk8oW58JLA2CuPJi3KfGSbITscLDpdtecLIlPudnBz+QyWpQaWWoVf8guTGBJXcJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770967939; c=relaxed/simple;
	bh=KxGrcbG7a2AbG1ZzfagulwCjbri6LMG/biCnPE2s2X4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qb2FE5Xd5KG8VVI39+UrDxZ4Xpm2a0i+c7Eq+hpz69hflryEzRXJpEdrEHrj2kNfzms7ccryDaPZg6cgtWXRRx5A+iexc7rZbw1EA8YREvwDZDUpSh6mmuqMm9/9CgfAg9FHycHdxUE67Pk1D18HXIz/q7Am3k0OYxwkDU5PquE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eyrv8dt+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HgrgXNPj; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eyrv8dt+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HgrgXNPj"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61D7MV8f2627978
	for <linux-crypto@vger.kernel.org>; Fri, 13 Feb 2026 07:32:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=v2kqgpaQTaqY6+39WGQboDU7
	g1wqPRchcEVZFWkpBCw=; b=eyrv8dt+nlV9kMvHcXvKRtLeD/dZnh2JrqClaRxR
	dwhtBjTDxBR4piXkVuTw1or9wW52FhEuEIm+29zfAoOqiadeRlmo6Sgb1/gKleQH
	AT6TUKFvyukTrmurQEfEK+O0xuMZ/NCzJPNdWghIbYXytpv+rnUoLm2Wx2pubvO8
	AwW9+8GMFFWeLtJ6qnZNuxrfnBzJXPzmRv2ElHd3h+R01veG1S3Y8x0/8GVRoQNT
	A+GPV0RXxqoDbozN5/F/o2fwV8AuHO6ih603PbYqEmMU+kkmmfsyWsad+JN16x/h
	MfNsMnfOwl67wCRqR3RvNYyMszP+qE17jg1YU+mHOfssBA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c9ygur0xp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 13 Feb 2026 07:32:17 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3568090851aso2769243a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Feb 2026 23:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770967936; x=1771572736; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v2kqgpaQTaqY6+39WGQboDU7g1wqPRchcEVZFWkpBCw=;
        b=HgrgXNPjNRNqQSgCLUULg/FSXGcOoqiTeO1W35T8NeTtPlcydDlLc0S9/KL2jnhLdv
         0hitHtJQPN2tBLmJkd1YJ6qqHfV2rQrTU2rbZqF4/U/cmu7kYEaHiv5PWHlj+eDSvm1k
         CBGhiKh35KBH9B9Il+LEot2trrZcVShywmoI36J7YzXUeP6RzbxHD3csuufWXUjDAC0A
         jgk8ESOo13ivhejhvvHJcApNOKgaJsuUBDfygjS0ILa34ViEw1t0Bl2j/VcKKvEAN4vf
         1n4JElMcPph+gbL09V0Z885Txlb/nkQDDT/ElXhGmCPz/bzrHu34Z6ay08miFJuA8Kah
         8DAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770967936; x=1771572736;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v2kqgpaQTaqY6+39WGQboDU7g1wqPRchcEVZFWkpBCw=;
        b=K09Q9v+sRiJ19rS68R94FxtUCH+p+iYlqt+uu96jcGapF3sTpOp6MpK00sIQQyRjYf
         MQ9kYGkgwH7Ck48lXgx8ZnAQt1JQzDtAcP6KZlwuwA0DDRRBUg1azwFHfjSJHaPm/HM7
         br3mZo6XffCk+J5mpH4W7iARaC2PnCA9jOOOpSLpnQTSXKSQNzzYmbfYXTSmQIH5hwvi
         Q4JCm1TYaLevchT0m4AQvQ88HrOOlrmj7ckhiLIxViHlg1QlOvQp+dXOcsrxcoBaAtU+
         tP/g+rVgeyMHY1xr0n2922ZGxCLUzBO5N+lKvojPFDyRwc4MejHlclRpBkOdyE/NVCAZ
         Zp1A==
X-Forwarded-Encrypted: i=1; AJvYcCX5FhGvYFc2shicoiax4ThB/RAUqp1d32tt+HNcqS2KQXTaMHQA9Z9HW04lglyPA5Yb6wEeFJVnARzaF9k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq9FpG6D8f6B8GadDR0ERGebJH1r/9JdEefYbC1AaUUJ+AbI1i
	VK0r/C0wqs/3SKkyBtjepy4VXJDkQJXp+h4cJgBwDBP+LPHOQGIFEBTskTI3wQ32pzTZ424/RFe
	pAsZDy44aoX+2hieRb8ASAGE1mZ+y+wkI86N2CMee+lBLu30wg3dSwe1pCePyIio8IXzSRyMkC7
	Y=
X-Gm-Gg: AZuq6aIwgWqaxxmsDlXbO8kfmrqex+6V2ShbgR1b8zwqhyDm7NcCaSWXxaEuxZ4mZIE
	NYqiFKHe9fXG1wg+Zzy8oSAJ4xOqqoeS1gRKVh9CbzAfYgCBht7uQ9WMfRlFyyqCs0cfAorXL5e
	ti7j1hss71OoU47xL2uFDOxvcK5s1QErjTyE196VKnmIG+lVpfQZFILhvgue3+hrIY9GaHmMi3C
	naEFoymzsX34yRz3W+/GuE4L/71iuI1OPXOgb9kUkC5rI1/iU0ku2nNe/UL/UucMnzgqsoq+2eM
	P18ewg6CJ8VTZ2DwnVZL7i1EEaAVedYH8pMFj8LjA+vsRSJLzQLUk7jxAKRqVw0tiV3sG1zuZLa
	Y4WD9T1zRpERQK3OtVc93bwrivv7qXJLbn5dshKPYVC/1aZGDqXXsfFDGRrI=
X-Received: by 2002:a17:90b:586f:b0:345:badf:f1b7 with SMTP id 98e67ed59e1d1-356aada1582mr965985a91.28.1770967936243;
        Thu, 12 Feb 2026 23:32:16 -0800 (PST)
X-Received: by 2002:a17:90b:586f:b0:345:badf:f1b7 with SMTP id 98e67ed59e1d1-356aada1582mr965950a91.28.1770967935771;
        Thu, 12 Feb 2026 23:32:15 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6b6a17fsm1831435b3a.34.2026.02.12.23.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 23:32:15 -0800 (PST)
Date: Fri, 13 Feb 2026 13:02:08 +0530
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
Message-ID: <aY7TeBcMicmvFvDv@hu-arakshit-hyd.qualcomm.com>
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
 <20260211-enable-ufs-ice-clock-scaling-v5-2-221c520a1f2e@oss.qualcomm.com>
 <bfbe04db-bf64-418b-a75a-88879bf0bf2d@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfbe04db-bf64-418b-a75a-88879bf0bf2d@oss.qualcomm.com>
X-Proofpoint-GUID: 0G1JFaWpLIIwprSNcEF3T21kf12BLW1I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEzMDA1NyBTYWx0ZWRfX+sxZJ5erzB/6
 LKurd9cpKIQd6i5WudEbf/ujdvEe4ZkbBGUaYzWuBs5xxr5OkVLjOq+3nxm/R/RYpn8H+XWZ1jH
 1fEJttg5b3MuHEc0s33BLX5RAhzhTjYmRaUEaboDN9NWEElp1jmw8ilWTXTaPwf/HsCzTmdhlQ6
 yXIp45BvpraswWqVepaV9DD3Z55t5CTP3Y1HSuchNk2UCYmZOvZnMvFVL+m09sg3A5WCHrlnNed
 1xRLYSAfaXtgNG2ts8Vn2qJIvYYPBmkfWgKfRVQjXRo+lhpK84lSEQIUIMSOb/C/MfgHzA1uHju
 6C1iE6I1XDUgKOlx0pil1ngMe//Tr/D7OMeb/GoQ5FccZSkHh1ie8mTtMi27oGTgBXnECoCmK11
 6UWMhPTDV2O0TCVxLjTRli2JmrA1PVRu5CZzPm3tLz0wZVhsVsMOmrXhBh7hx/BObJ74I6FZkyC
 WdP7PLE3LkK1HY2sbAw==
X-Authority-Analysis: v=2.4 cv=If+KmGqa c=1 sm=1 tr=0 ts=698ed381 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=GuRBVjywOiuAmw1d6-8A:9 a=CjuIK1q_8ugA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: 0G1JFaWpLIIwprSNcEF3T21kf12BLW1I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-13_01,2026-02-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602130057

On Thu, Feb 12, 2026 at 12:30:00PM +0100, Konrad Dybcio wrote:
> On 2/11/26 10:47 AM, Abhinaba Rakshit wrote:
> > Register optional operation-points-v2 table for ICE device
> > and aquire its minimum and maximum frequency during ICE
> > device probe.
> > 
> > Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> > core clock based on the target frequency provided and if a valid
> > OPP-table is registered. Use flags (if provided) to decide on
> > the rounding of the clock freq against OPP-table. Incase no flags
> > are provided use default behaviour (CEIL incase of scale_up and FLOOR
> > incase of ~scale_up). Disable clock scaling if OPP-table is not
> > registered.
> > 
> > When an ICE-device specific OPP table is available, use the PM OPP
> > framework to manage frequency scaling and maintain proper power-domain
> > constraints.
> > 
> > Also, ensure to drop the votes in suspend to prevent power/thermal
> > retention. Subsequently restore the frequency in resume from
> > core_clk_freq which stores the last ICE core clock operating frequency.
> > 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> 
> [...]
>  
> > +	switch (flags) {
> 
> Are you going to use these flags? Currently they're dead code

[...]

> > +		break;
> > +	case ICE_CLOCK_ROUND_FLOOR:
> > +		opp = dev_pm_opp_find_freq_floor_indexed(ice->dev, &ice_freq, 0);
> > +		break;
> > +	default:
> > +		if (scale_up)
> > +			opp = dev_pm_opp_find_freq_ceil_indexed(ice->dev, &ice_freq, 0);
> > +		else
> > +			opp = dev_pm_opp_find_freq_floor_indexed(ice->dev, &ice_freq, 0);
> 
> Is this distinction necessary?

Just giving it a second thought.
Well right, these are not necessary, infact we can completly remove the scele_up
from the export API and make use of the rounding flags eventually.
The ufs driver can pass the right flag, based on the check against scale_up variable.
Ack, will update this in next patchset. 

Abhinaba Rakshit
