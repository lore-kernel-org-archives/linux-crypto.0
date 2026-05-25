Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D5536F91D
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 10:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779705848; cv=none; b=awFtJT8n7Yy6cjZMQ5vqqFDiA94P3UwtWyrG/iWgC83l+iVeRFMUtkU43wo7fWFz/RnKopbXQyifAf7Itts9+hmLYuHhmS+TmYNxYhI9OADSDWn5MN2KTRPULkhyFtlLVA4tRDl/ux/mwtF7S30Km3hscLFtPlBDGFOch11TTQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779705848; c=relaxed/simple;
	bh=h/uqjF3R3sz2YKYkVBCkZA1z2qZxypPsZhVBXAZQnQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7Ngx9anQ088kl75u709wNx3dqFkQd2Ac7bLOJfAtfhtZoFg5pAbzD6dJEXiWK/CyuU+IU4YSKqOVs8hKN+s83L2Du2IdWtX0nfLZcif4/JcPCc5ZNKU42S/faC2jXKYqi9Dee2j6zK5WitIu/yiuWcFnhuSraUp3X/eoFz5p00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Pbx/bydp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=M7yGZl8m; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Pbx/bydp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="M7yGZl8m"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64PA18AL2551045
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 10:44:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=Z1raWWhLV0vMOZgDp8fhNzwX
	X9rXSsNT5f68RVt1IR8=; b=Pbx/bydpwQyQYuMslTHRkLL4d+B4FFarFnUiFEtQ
	nfjVfqqnpE1888w+zQ/1LKvErVSPgda8jYbtOdBHGN7q8JHna9pjtoSwP9DVr/GP
	alz465/XGeLqOUQ7XksPA9I0zOWj47T1wbIQW2iAV5bJ/NVTHoEUs3Y/EFwQQcXy
	qOb7GLuDgRub0JzWPheKVNfad4QrCyU4wp4kPvn1b4u7Vn+ze6VPVuDKVVqrIhUX
	DUfAmo9RTbs3Qmkm2MuGjq8dZQKo2cLyTOeEEc3dfZ8gElVks2pNI3cxMOGnAWtp
	aL7CFmncY4aHBvVZIqMRicBub7OA3TYCJWHKbZvMPkiazA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eb4asxbe8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 10:44:03 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-516d13328dcso71721981cf.1
        for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 03:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779705843; x=1780310643; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z1raWWhLV0vMOZgDp8fhNzwXX9rXSsNT5f68RVt1IR8=;
        b=M7yGZl8mrd+GW1/lCmROMiSBCIVn7OheKqCWe9/xr5BopDRgJO/+YHyGephHV5oBDb
         We8f46OV2qmuavVgXx8emJZ/QwGaIkkPIN5tEgcZBOf3dhA6ZRPc1gr7U4Wo1ThE3eau
         7xwbRfGjtXQrm181jvVh0OD3lrboWiWSWp9xarc7h5U8vDWPwmEqHgn829oHAtU2sex8
         Kz+8Ti9rL6C+gN702QKezwS5HC6kQoM9qeXZOZq0S8etm6HPOaX4u1jtqm9pihBqgNC6
         FaVd4F+yJy8kZlBH74eOPIIr/A9vq4kf5KmE0xyba1J/9hrM2CBJgBQWb2tZbPwoveTc
         QC+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779705843; x=1780310643;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z1raWWhLV0vMOZgDp8fhNzwXX9rXSsNT5f68RVt1IR8=;
        b=k0EOiXlaBElOPEpaeWjGJSpF4SgN5l4BtD4e6lDv41AakxB1lcBSxbCGbaiyMfV12H
         RPr/GyhfjKI0l3pXdkBaIV7en7/pk38u4XAiVKhLu8P8m5Y7u91fsKDCWBBWzv8QPs/K
         eDlKnX3Mm/DyC6M/cS0VHmbjbpOS8mW+NVtiR5udbambIKZ1X3BdB2cCc2J5VstMJ36g
         KFcR4Fx5B9dgEZ0CIyaPo6+wAP7r2g0nS97du0RGVMpLG8XHCtsJDjobn/egyfVdkf56
         4jhnuirKsleSMgCjGGELc68Qvv4qUs0cgZC0AT+39NC6gBWvyUco0+znmqcenIVf5TeN
         Dt8A==
X-Forwarded-Encrypted: i=1; AFNElJ9ymIZuWSDIO7ZEnV8dBk8Vh0A/i0FSX/P9+OvpUmn44OkTPxiIT+ngf5tUj83ZqpieQDbzvRMNDsClOUc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX61c2q24LTP2yWopV93Rq8Donvqa9djuuSqBBmxVVKsW4aTIF
	1KORz6Lk4BfMoIMsF+MUpoNeH7yHApVCrKhjX9kqgUnMvQ5P2A4yJCvpFIF7PwawJWfnAnquTTd
	2vPIbJIpdQgIiHN3ALL1cQrPlhX5qd3IWOoeRYoQXzIcp3Si9LiStzD/A05fT6ou8kjE=
X-Gm-Gg: Acq92OFB2s0BAqGMBHz40WLao97aLJgUYjr8UQGLVM8d75kI5uURFSqKyXwP5ACv+cs
	GHB2Vpb5N6Y/IG8lKz58sHq+X7QQu5uQwhiZcqfmpGZ3ghle112KiEHySlWFvRAeWQPc/P8YoKg
	KyD6yUxqzxVycSi38iQNec596nFiV1vDJiEkvDSZ5Fh3t46VKpoXZvZ9eBVfcfKYfsqomInkZTr
	tBJxRYvWUeTISP/9a46o9xIPJ+ye59SpnwBblR3iLyK5yLiHw4Mnsc/4fsPgGRzx5xzDGN6jQbu
	qIprwmkTG74U6r/I2e1cULoE1SO/g4/C1Qm3zxRGLGuUortyXcpdANPDUB966ELFcKrQOCbrh9C
	3tfvfs8l0uDM+7PSwe9B0+EhsRzEijorrSOJnqJHtAQvm+gvbz8R1ZKhTLsqyEfLKRQAWwl6ott
	jAE4t6A6xsgJfDCFGXR529cm4Iig+vt7Vs0FU=
X-Received: by 2002:a05:622a:418b:b0:50f:be4f:465e with SMTP id d75a77b69052e-516d466fb5dmr185266971cf.53.1779705843000;
        Mon, 25 May 2026 03:44:03 -0700 (PDT)
X-Received: by 2002:a05:622a:418b:b0:50f:be4f:465e with SMTP id d75a77b69052e-516d466fb5dmr185266741cf.53.1779705842593;
        Mon, 25 May 2026 03:44:02 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395dcc0a9d8sm22226301fa.26.2026.05.25.03.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 03:44:01 -0700 (PDT)
Date: Mon, 25 May 2026 13:43:59 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 3/3] arm64: dts: qcom: shikra: Add qcrypto node support
Message-ID: <cadke5cbqfnnbcwlafgajy6g2xj3s2apmtpzp5uwb5limtehyx@4nnoww2kmytp>
References: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
 <20260515-shikra_qcrypto-v1-3-80f07b345c29@oss.qualcomm.com>
 <8dfa0670-7605-497b-9d53-db9b4a8a3d8d@oss.qualcomm.com>
 <57c26520-42dd-4159-bd2a-69874945cbbe@oss.qualcomm.com>
 <algvollvttjlu4qpawi3gnhwponwml6pts47ebmcvrjvlryl3a@qjq5ildo4qsm>
 <8a1d6c78-fd16-4994-bae9-cf75b1e7e3c5@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a1d6c78-fd16-4994-bae9-cf75b1e7e3c5@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDEwOSBTYWx0ZWRfXyLoYc5se5w3r
 foA+lLjtx7wN5c6VlgEHoq+3z7EH7pvi99z0nI0BfW+HII68v+Sd9oLkZqErfMaANU0vV2iX/Zo
 RMgTDiKOYK7l6tg9v+ZyxhzGn8FV0oGQwgctzmzpD4/qnwhq271tDTvAS+S6Cr1T8jJY4Nr3PBY
 +jKvy8ZlbVAOhLkvFHnMVuRuRcHnftzjX/DyHgYZlmY4eGvJd2goi1mHSPfrMgcxzz8cW61eMjm
 IOv8kSF8NRi8xw0sswQuyq5LFhlsIV7GPg2/gzHbbRPbpFH5qZEqQEb0CS/wUU04vfZw05HNfYP
 XhLLDEX1ZhJkX6hLUx10xdibDeQd6+jSgK4Ve2+fKz8SMI9pdMmN244t9SP2bw0pQd9cPeITGMX
 9jRM77circ/RUerLo7802DMlKhrgGHb7iPZHheiITUdqilifJLKdJX5AyU/1kpdd1eaDviIFZEx
 iKI5jfpRfH+hUnS35dA==
X-Proofpoint-ORIG-GUID: VH7CKrMiB8OlVbn2S7T-OM8uzPwBMQRa
X-Proofpoint-GUID: VH7CKrMiB8OlVbn2S7T-OM8uzPwBMQRa
X-Authority-Analysis: v=2.4 cv=c6ebhx9l c=1 sm=1 tr=0 ts=6a1427f3 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=eCBvbIXyoX1lJJg6tWAA:9
 a=CjuIK1q_8ugA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-25_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605250109

On Mon, May 25, 2026 at 03:39:17PM +0530, Kuldeep Singh wrote:
> >>> These two entries are logically the same (SID & ~mask) as the first two,
> >>> does it still work if you remove them?
> >>
> >> Yes, resulting sid is same for 84/94 and 86/92.
> >> Basically, the resulting sid could be same, it's an optimization which
> >> smmu is doing which can result in same SMR(Stream matching register)
> >> routing 2 different sid to same context bank.
> >> So, 2 sid can be used even though resulting sid remains same.
> >>
> >> Also, DT usually dictates what hw capabilities are supported and hence,
> >> captured all apps entries here to match the hardware description.
> >>
> >> I hope this answers your query.
> > 
> > It doesn't. Can we drop them?
> 
> Could you please explain more on what's missing?

Usually we don't have duplciate SIDs in DT. Why is it not the case for
this device?

-- 
With best wishes
Dmitry
