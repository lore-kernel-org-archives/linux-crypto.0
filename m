Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEF2368260
	for <linux-crypto@vger.kernel.org>; Fri,  6 Feb 2026 13:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770384218; cv=none; b=a8Y3tAh9yk1KoRwF/H+hQIcF5KALJ9dLazeT2x7TGsp9jU5hEA8gQFg23N26kgnKwb6gHSvjBIvRY+UYVhB4Yw3janTNvrx11mOOsBtj6s6COMZI0Pn6wTXD7iX/JkwrFXeLy8F3X3PZ7XFKZn0OGGiG+cp3qyu9PsJbrvYNGj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770384218; c=relaxed/simple;
	bh=fqZ8bqAlwUxBwe4Z1+H16jnykQV8yO9H8sw0Vqob/0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tjQd6fqZd8WkPIrQEBt+a+9Gt5QaqxcVXCme95+hpy6jyzD9cMALVv6l2D/h+tAwY/4iHd6P4WYq7MOEg2J6A8FGP6qldjPaHi1VG1FUay7FlHs1iFoK2tcMETYFmnYjhQUWfGEZBMF+gY/cRKYi6PosGUXHp0Rco2/qOUJ9cps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oYLKpI92; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YuVg3Ixy; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oYLKpI92";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YuVg3Ixy"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6168Prjr2058595
	for <linux-crypto@vger.kernel.org>; Fri, 6 Feb 2026 13:23:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=Qcbx8hOqgZKgbdxSnQdVeh45
	s4d6AAaaCPjmsAiQNIM=; b=oYLKpI92S6Q7d7Cf1DrAwDVbpDZdYaJQHEEYEz8i
	q7+upvosTjWwB73AvGT/DpOKcSWDuqZsIRNc3KnITrFiQLJ9IuzuwLK1Qfe8SWt0
	xPKxsdF9JGSpyQg0voI3pl0/RVSfz+qXq5gSgvObQ/RiECziXWgbdOst8cR9u5jj
	VyrWYjteW0DrTXIcgYG0io0DMfwjIsWLAZaB2jGQQBJZjYo3mhq2bdmMDiGyAXfq
	jONDLiC8TLq+60zWtaHleduCLB62m34ekmTP6UM3zy19XRfBebWJeZ4HjjFecNsT
	YIduTS67LujAYsfXJfj4LtxXw00N9peEy8qZ1FjldKVPFQ==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c4x8bktwe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 06 Feb 2026 13:23:37 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c52d37d346dso1320573a12.3
        for <linux-crypto@vger.kernel.org>; Fri, 06 Feb 2026 05:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770384217; x=1770989017; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qcbx8hOqgZKgbdxSnQdVeh45s4d6AAaaCPjmsAiQNIM=;
        b=YuVg3IxyTS7DKgG4lVjz54J14oaNIMAFgY2VXC03zh1iYNiftCB5w/t5Uk9Dl/Edbk
         Asd5g/cRj7xPa2XAHV+SuRIFToUzeUlSnyYqdn/gHJqGdVrhmDkKQZ9vT29ntf/iIoFw
         S8+ySBkNtRM2ZWsMSr0kSXf14xxziFu0n1TO/G6UTryadQE1YHcaAXiHG6ZRFmxa0/Z3
         YHtxFaHL3L0oSMnKo98az484CkD6VK3NNGVvSzc/EdgZBzoz7DreaywLWgktu1um0dce
         CN9mA3MYk2VCSpsbMLs/B/rWkVEoe4A0XWrU26l66roVDSrh+BWCIr+vHMKqc+OXav17
         g+Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770384217; x=1770989017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qcbx8hOqgZKgbdxSnQdVeh45s4d6AAaaCPjmsAiQNIM=;
        b=YyRV2G35QaMlxAL6Jhd4zH8DChHnB151CvR5UNoFxn+fD50GXSby9rsNbVAFrerDlU
         9y3yz0VJCVEOlOFXhW2edWme0SKWtaFGLBYK9pf1dxPOGNdUfojvb5WDC16fxMvJR80n
         m7RW1o3/kmAzaqtUd/wpI+RnAViRQ1pHzxRi5SN9oMh2nw2SgFbmv5gJe4hmxiE3VYlU
         85LRXPik6t7o88ftAUI19mS7hpidBd7Bg2sNRoBpzXInSbopUmgeVHqgr7iReKMhocQI
         YRFCGqeamsGU8/SrLJNPywRnIIBI+k2Go633mVSkLMQZ9u40MHiSThyJ0cbYLoeaq2kz
         R4SQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW6HshMQ+y9DVvKLB+hC7lNc7AaEBW1x0t95VkZ+UNUFbHf5dFg1dwMF9rbfZi16+2bEJQgoSSgVwcy68=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIydOoA5FpNKlBqmtsI3BuiRePgHSmf3kOzzNRCSZ7k/zCcJIw
	6yF5yOZ4c4YvP0WQSNLDZcsaWMNbpvefMCAdy2LsYly1kGtb21iajVjNLkDgSNr07PIuIsdvhIt
	qEjX8pfS532hkAu0suCAwIPwwactQHmawVy1APpcoqSeX8HN/ry/SrH/TWq5kX1FkI/g=
X-Gm-Gg: AZuq6aJDfA55WYNvdWX7x10kUsnhQGk/bxKujajNeXF7chXjXpZRDwdIDvFYp/02nV+
	DiEqNP/xgxRPX3X55aCCV0MBbhcC9WkqTlEbIo8XRHj6JjjrMxcCwEkarmFd1jyYjmVig48PakF
	nKkI1VwqsaIHzxns8Ie7sTa+9BXsIpjA4pR3NXvdT1ZsQDlm711+CLU6FnayuAnYmbCcaZW+u7Y
	CBLoF1PG4oZnllC2I5HV8b9+ltQoya07+PsLt169vhM7i5ItLWaMPIBTWwj37qMMAon5njxNf63
	TDEL/vNVy/GlvdbL+asavveNG4PaADZLKZK7AhUFgE8Dh3po8rrmUlWAssH+tYiwMexEhrJ9pBx
	QmDBFcPxBmC9jmEiPpmrNyrZVoXEi5VPcdXxAvfCkbmbppoo=
X-Received: by 2002:a17:903:244a:b0:295:c2e7:7199 with SMTP id d9443c01a7336-2a9516fb30bmr25300675ad.29.1770384216751;
        Fri, 06 Feb 2026 05:23:36 -0800 (PST)
X-Received: by 2002:a17:903:244a:b0:295:c2e7:7199 with SMTP id d9443c01a7336-2a9516fb30bmr25300415ad.29.1770384216215;
        Fri, 06 Feb 2026 05:23:36 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9521f3b6asm24313205ad.77.2026.02.06.05.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 05:23:35 -0800 (PST)
Date: Fri, 6 Feb 2026 18:53:28 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
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
Subject: Re: [PATCH v4 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <aYXrUM+Wuso+aHGc@hu-arakshit-hyd.qualcomm.com>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <20260128-enable-ufs-ice-clock-scaling-v4-2-260141e8fce6@oss.qualcomm.com>
 <20260128-daft-seriema-of-promotion-c50eb5@quoll>
 <aYBE/VljJTUNx3LK@hu-arakshit-hyd.qualcomm.com>
 <b556cc32-2b8e-4451-b333-aec2eddee7b1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b556cc32-2b8e-4451-b333-aec2eddee7b1@kernel.org>
X-Authority-Analysis: v=2.4 cv=GaoaXAXL c=1 sm=1 tr=0 ts=6985eb59 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=utnUQDMwVCZhAfiAu78A:9 a=CjuIK1q_8ugA:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: _eJdcy2Lef1oT6FAkRx5GtvYC2V0DcDn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA5NSBTYWx0ZWRfXx0y7thjQkZL7
 MAq7Kqsv13nV/JFBq6kgaq/GIJW9hx8Jmix8BNPuZTB3RIPqO/rkmwFFMSN9tSHCb3hgtI3Bxqf
 +1HXm0E7t1eBB5aXxk/+3dN/YtvbLA6n3g7d0ByyL+XuL8QZOkNJSb1Ov5VC6+cSwYkLzV0QVXF
 UCBm/zXuorXb2yoL9R7csCg+aUuAvcYQTMWy81+49ORZWl52R90FHB2+eSMpoOFaKMo9miOo3TC
 TBU5Zft8fqExEPx6g/iUm5/4SMEP1haANzkFyUyVLuSb9y3BRj6u9Rtz4D47LjdG5F528gE5+7j
 jwAQEXGQWBRgzoyoIgmoY861Q/XXg4WpGYmagvU5DoL1roaN6RoEzecyz0Rsg49zONE3cKmHukB
 XODXOKLADge04odE0/QN79WhLluHwSdnTK8Zqj/ibDreBk7/3z86PTVgBoZwfIu4FrfQVhmwWnR
 5+8QOomTnahb0WQMmlA==
X-Proofpoint-GUID: _eJdcy2Lef1oT6FAkRx5GtvYC2V0DcDn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_04,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 clxscore=1015 impostorscore=0 phishscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602060095

On Thu, Feb 05, 2026 at 12:26:25PM +0100, Krzysztof Kozlowski wrote:
> On 02/02/2026 07:32, Abhinaba Rakshit wrote:
> > On Wed, Jan 28, 2026 at 12:04:26PM +0100, Krzysztof Kozlowski wrote:
> >> On Wed, Jan 28, 2026 at 02:16:41PM +0530, Abhinaba Rakshit wrote:
> >>>  	struct qcom_ice *engine;
> >>> +	struct dev_pm_opp *opp;
> >>> +	int err;
> >>> +	unsigned long rate;
> >>>  
> >>>  	if (!qcom_scm_is_available())
> >>>  		return ERR_PTR(-EPROBE_DEFER);
> >>> @@ -584,6 +651,46 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
> >>>  	if (IS_ERR(engine->core_clk))
> >>>  		return ERR_CAST(engine->core_clk);
> >>>  
> >>> +	/* Register the OPP table only when ICE is described as a standalone
> >>
> >> This is not netdev...
> > 
> > Okay, if I understand it correct, its not conventional to use of_device_is_compatible
> > outside netdev subsystem. Will update as mentioned below.
> 
> No, please read entire coding style, although the comment was about
> comment style.

Sure, will ensure to use the correct comment styles.

Abhinaba Rakshit
