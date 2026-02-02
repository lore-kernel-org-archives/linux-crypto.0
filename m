Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4672FD1C5
	for <linux-crypto@vger.kernel.org>; Mon,  2 Feb 2026 06:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770014272; cv=none; b=Ctt5C57qIpAFpr/ONhG7BXwWcY5hdbyMAWnqiuBGvDP8FYI07U0P4FWvtSLS86u+5Gg7GompkNVZd8VmYNdeAtfSzMeWi8qaYGGrbSrXgRBymMF9HEq4iZNl+zam/tJfo7F8KB00MsF70iPqDqTQuJWPV8HAgZqG2WKxIbmtJXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770014272; c=relaxed/simple;
	bh=cWD5eSAILeUuTTWaDvGUuJbhuiVAHyoHWHRux09XQKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=caItGo9+2SF1tv05vS4DM8D5tgD4AN0TFa2NDBRSH9B+mUMBPNiVUSpPj0LRjBtQm4gJjNPSXVFcSNVQv0Nigal4ZQcIn5atHM5JZfXU7AThkMgTYTgGN6biZPFKS8dsh7tJB1uex/WMrJy2vdBfmP+qaLwqrOnKb11WIZyfT/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Asq4OzCI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ivJOX+eX; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Asq4OzCI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ivJOX+eX"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 611H8aQ44111460
	for <linux-crypto@vger.kernel.org>; Mon, 2 Feb 2026 06:37:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=5d7BAWG81laRew+3TfSqguMr
	5kAYoIpiGVT2NJVANI8=; b=Asq4OzCI4NN7DjmSl43Iwk7pd/GbEFVtflPxiZYK
	M+qNW6eKhIegiQ49DwwMgs3cM4ZFWEHPlLbce+VrSaguS/pxfnmLHWIJswkEz2RP
	6efNE9cI+/WCOqj/F7R6bCNu51MG1mZMbplBTYUV4Es2TJhnKFnGyH1bBgX/xMv+
	yf/VLjkZrj/b3+Lvp8L1OFN0+/XWjnWNNk3nlr5gq/+l40e5Bh8xaySG27JagtiA
	lWjNiiztdp2uMdLNQ+HqtUI35nhq/mLTkEzv0YTU3iLIm9q9cZKblR0CbVE8vuNP
	jrTG2iQmNao0MOoiLNX8BI6KJP/Oiw7JpDocp5gf6nDbEw==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c1arec72c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 02 Feb 2026 06:37:50 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82181ef69ceso2009613b3a.2
        for <linux-crypto@vger.kernel.org>; Sun, 01 Feb 2026 22:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770014269; x=1770619069; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5d7BAWG81laRew+3TfSqguMr5kAYoIpiGVT2NJVANI8=;
        b=ivJOX+eXZ5Nuhfd7c9N0jMZI91S6rzE1UU65fTqExq+aH7jUOdEj54rkheeBZOY2zF
         ia/xfcdIgVDN0+L8e8p1iOGd7vUH9tchkOM8Q79fLnjehP2tlOke5nEeOcSugQVz8PFM
         svk23syrsjopw8rjWMI9RGYTPoob+17WVuwKmHtpBIsg61HZ3H7GimpnRg6BLGXU4SZH
         St+aLOMzilI3WKcFKJP9ypPbUkjqWMsIXQ9GXD+X72YdFP5XdbravmhgRhOnhaJisZun
         DKAU3CFFcAg811UqMC8YdGzBencN+l5l03sPb0TOY5dBR8YXq+OSXtROO0ftNXqUZiS2
         6Raw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770014269; x=1770619069;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5d7BAWG81laRew+3TfSqguMr5kAYoIpiGVT2NJVANI8=;
        b=W9T/iihYAbTkdW3oy+Slx1UE5H1GgfBcrEIsUIXFbGaaoRI/B3x9uFcmhHREjizyZ3
         MQ2slFmf+gicd8+H2gqtt2bWP4qaUaqOZPbWV3W/zQpTekDaSnob5hdxHykXsC2zLq5J
         A8b2FcQQkRiDR5rAhUvA2kjusCR6Gqnjs8QFfMlx4S5J7gTXD9kdjtiw53dzi7gfE74Y
         ga9W4KrSnrDoqe7/TiVwRMKjDDvoHbB/Ur7UnN7Vo9Zv4cCv2s+33WvkkVoEF5omSlih
         1KNYUI+xbuoA0HdX8HtPsXV8CburQp3D1ovQuHJceckmcQzgxbg3JTY2FG0stNUrZKby
         x1Wg==
X-Forwarded-Encrypted: i=1; AJvYcCWzdRNRuYQQcbHy/RRHb2CZ4oyDp1Eriz+ovvV5ahRYI/lONs+rNtHQlLUCKSzSi4iK3vO3KhLZ5gFAdWY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb4K+j0ihF9rdL4P3GjUjbFn3Ip3jXt0xCoPe3LCaKkYwC19C9
	UEH88Lzdiroeu4HCFWxJIpGqyAgm/FMwud70JLyYfF6ywdnKsdGYzsTV2mgyDJ8VpF7FBjqF8Ej
	pitc5mUCopNMqMt5K9JG1bfOwjGXcARVnWJgRFVAPKOASNGoB7hrLIJVUBlRjM13xv/s=
X-Gm-Gg: AZuq6aLlEpcSLXlUbO0mL997ANkXZQ+FUgJAXLJ6RwTdpWm0XoFzXDa54VOrvQIzmma
	ns0DrnxqD5vfNoitdSDafqIXTlHhGWh26OoSDe05awhASjJBBjM2SxAiSFSGcKjsEyTlhE06J93
	WSPWTwtzTyjmvyIwlbzJMq7PeO0IopckSazj7mFz/pKNPVNBIsnOi5oROOX9LZWwgVv5wn8FJzx
	K4boFXsHlt+mh2IwYWQ2/faBrMirc2AgM+6jHkzQ7B1W1LObNPEEkDYcd/bj/Z4Dj320RNk8fx2
	3+y8yZjaKGzIMeIS2eTsw350zq1du5hBEAug/WoVFoNW4mzAgtUqBZYEFtf8r9yp8yRgtHgKn/L
	0rerNUdnbpFMa9ueg6QBNjYUE9MZya3i2pYoxwbDPKdtjXBQ=
X-Received: by 2002:a05:6a00:3903:b0:823:edd:20c1 with SMTP id d2e1a72fcca58-823aa9407a8mr10103790b3a.67.1770014269000;
        Sun, 01 Feb 2026 22:37:49 -0800 (PST)
X-Received: by 2002:a05:6a00:3903:b0:823:edd:20c1 with SMTP id d2e1a72fcca58-823aa9407a8mr10103772b3a.67.1770014268474;
        Sun, 01 Feb 2026 22:37:48 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b4e96dsm14489764b3a.23.2026.02.01.22.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 22:37:48 -0800 (PST)
Date: Mon, 2 Feb 2026 12:07:41 +0530
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
Subject: Re: [PATCH v4 1/4] dt-bindings: crypto: ice: add operating-points-v2
 property for QCOM ICE
Message-ID: <aYBGNeZUFoEYs/Ih@hu-arakshit-hyd.qualcomm.com>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
 <20260128-enable-ufs-ice-clock-scaling-v4-1-260141e8fce6@oss.qualcomm.com>
 <20260128-amigurumi-viper-of-gallantry-69ab8a@quoll>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128-amigurumi-viper-of-gallantry-69ab8a@quoll>
X-Authority-Analysis: v=2.4 cv=NNfYOk6g c=1 sm=1 tr=0 ts=6980463e cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=040W-1HjkB6UkxdISe8A:9
 a=CjuIK1q_8ugA:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: Xez7b0meYicRae3PH1dQg3y5tSpiA-JP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDA1NSBTYWx0ZWRfX7klxG313mnh+
 lMPbILpG2Pf4UJF/fpGcrd1nJhj20faKSaYGIVq1jPCSeKhMiBa/epbB4+F/+jUomjqVT+w0WGJ
 g+Sxh0aEUhMxhMvMmkcQD6ouUNNyia2k1r9ILLirrdabd25P2KLWmXgFuidRef4nXqb93Of7qTj
 o5ER/1O/rqzVlG0CHok8WjeERSl98pyVwYLXbf1NdUomev8qqf5/S0/9MB3TMjT1TW9qWLLpIgn
 UFyBr6MBf626LcZ/7dGSEIK32EDlIdBz8sYHbl1+GIgfqfvsn1V4CjzdTLgiwxfUsynpLaiewrd
 luKH9vPhqSefkr9MUf2pRJ/LfvHcTqBf1iyyYeRXRY1miVP0c1L+dDu/9gVoGEpLypXJrKRRjuG
 icUC+pePKhuw4kvxgieTYeJrHrfWSQH8q+rw7Q/VyePYIx9Q2p0y5cfDiDfiH4+cnlsbYr3xUyA
 mtfDw8kCHmtvKYWK0IA==
X-Proofpoint-ORIG-GUID: Xez7b0meYicRae3PH1dQg3y5tSpiA-JP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_02,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602020055

On Wed, Jan 28, 2026 at 12:00:57PM +0100, Krzysztof Kozlowski wrote:
> On Wed, Jan 28, 2026 at 02:16:40PM +0530, Abhinaba Rakshit wrote:
> > Add support for specifying OPPs for the Qualcomm Inline Crypto Engine
> > by allowing the use of the standard "operating-points-v2" property in
> > the ICE device node. OPP-tabel is kept as an optional property.
> 
> Last two lines are redundant. Instead explain the hardware - why it did
> not support clock scaling before?

Sure, will remove out redundant lines and update the commit message as requested.

> 
> > 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> >  .../bindings/crypto/qcom,inline-crypto-engine.yaml | 29 ++++++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> > index c3408dcf5d2057270a732fe0e6744f4aa6496e06..1e849def1e0078feb45874a436411188d26cf37f 100644
> > --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> > @@ -30,6 +30,14 @@ properties:
> >    clocks:
> >      maxItems: 1
> >  
> > +  operating-points-v2:
> > +    description:
> > +      Each OPP entry contains the frequency configuration for the ICE device
> > +      clock(s).
> 
> Drop description, please look how other bindings define this.

Sure, will check and update this.
