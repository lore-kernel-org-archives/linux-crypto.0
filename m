Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E24A255F3F
	for <linux-crypto@vger.kernel.org>; Wed,  7 Jan 2026 08:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767773767; cv=none; b=mn7ahh4LQI11dM0BKce89iqV8NwOjwmIHSnDlwzTmhiTTomGNGdpNHyNw6MmvfEVBOk4mK0yuuBTqGsTNSi3SXxO8b/X/hR/05q25GzWGDc7tIelT098PhhqHTZ5GSb5m0X61svn98cj/2hOMy8Ig1SOBwUgLh01lsQDORApsKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767773767; c=relaxed/simple;
	bh=o1AWs4MhRK9ALRPlsS4BuKxVmEr2fZTG2p/UNW2eyJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Arq1arHo3vTLg58eSxeN5a/jbVS9XBSk7mL+dDnSfRI/puWd+USFyWVEBwYmtOZlP7gS4jqInR/SKlKUeyG5abZ9VvPoFJDOiw2x5tzZMYbHAGBFZBY+CLDXZ/PndNXkG1yPecgQmXN51tMUEt/583qOZCUgSolPgwsxZI0gn8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WYkU0qoc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DZSAmyh9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WYkU0qoc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DZSAmyh9"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6077DMW61474698
	for <linux-crypto@vger.kernel.org>; Wed, 7 Jan 2026 08:16:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=Qm5MJrdnuggNNNAB6F8dt9I5
	TzWW/Oz189rKFUnNs0U=; b=WYkU0qocoyMYrpP8b1PRLyQ6jyqcNuOptcrZYj33
	1fxfO3T5IGMi3Se5aveHkB0UzjdiHwynNRfKseiSx3U+z9gixYIHRfFcgb4PZ1Sg
	1DBiIyRWqVJ9hZEXQqm3UXbKwY6VkkmadP2uMJ+MH1VCdMedLPhCuKOxsHlmgpEK
	PrEO1p/pTvbXQAIPbuctuvl0gcx5DY+ohleduZJ7gF2OHBPV9VGNcZI7Qt4gyaqI
	Ff74KFah0wiFEKA2ke9zU3FSBjeOSJjG2Jkymp4KzmLlvwTL0t3VBXLb0I9FD7Fg
	d1MBvazTiCqxhLrycb9JeyiNp38uU/Pl2vB77NBaXnrg9A==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bhayhshm8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 07 Jan 2026 08:16:05 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4ed7591799eso42366571cf.0
        for <linux-crypto@vger.kernel.org>; Wed, 07 Jan 2026 00:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767773765; x=1768378565; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qm5MJrdnuggNNNAB6F8dt9I5TzWW/Oz189rKFUnNs0U=;
        b=DZSAmyh9JiOkLcEQ/Dqacj0ug6dafZLZ+xIl/eZOImOkmfiZm6HILPFF5X/VivAwAn
         VqdRj9AXyDS949ADG2UUIXNUEgwXi3j7BZJjvnPtbExpRVUY0XpC7sblLxU7rYmVbFyr
         4foiTzc8m9Z7HKv1JMW+4I/zfD7fk94uvHrFZIzJSDA3kLrfl03ShkZHsZ9v2gyREZPI
         RajUB1slS52PWF8yVmvTacJYCZRKDscHC0QXdamsj6MCHveO/D2Ueu94eVASHe3BGrUz
         CIqDANU33pV7m12TeOWdZAYoHinNuvzEJIZvzbM5lgy8rvnzLMtXukFgFifW5b8xxGXB
         VWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767773765; x=1768378565;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qm5MJrdnuggNNNAB6F8dt9I5TzWW/Oz189rKFUnNs0U=;
        b=dPLB06vMn9IK0X3Ttd/SaAGIILvq7cdUmtdmipe5q8JiT5zBwnHudUF9ScoQsZoxYO
         IrEtd8xKu+BkOkYR4zHHJgpqbtNycFXU/e5mTVEpfOPB2ilj+wDCtxuWqJZ6A05HcmJo
         L1QigeQaQ7vYd3GqCCdCGOAIjercGUoh8e+NtDhTwlQtrUyFUyDBi9qmcA3CtUnvB9pF
         BX4HC2a+HTSMrw23d+GkWWqAPX3kFTghNzMsBwJzsuu7KrRnm6IpcppwQKoXgVYm5lCh
         isaBfibTGoPV0ekZ7L0mhwfT1MN5vgDWPx//pcyYl5F75nxSH5RkaBfpv0Yo/xXYOVWa
         iDXw==
X-Forwarded-Encrypted: i=1; AJvYcCVkgHQ6Mf7abM2Hp3xK8AMz3I3KeF+7w+zAmE0h+teW+MTbyoouk/Y6jwjxk/C+t2ytiXi7xrCEROLY4oA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7Rov1z9ZW7q9ZTVC/cqLh85kJhiGtsvNYwEuEnwVuOSFW/BSD
	uWyZZwPU9WzDwET8fg07vlhlfwi5feWd8QoujOf9sQg1NSFRhfxhnsXLFtkeh40qiPcbo6tiGF7
	VyR+bB498u05texdpFLxMKvosdRjERQDs36pd5JvyBwrmL+i+zo1OsnZDT5NcQckdwko=
X-Gm-Gg: AY/fxX4+Ed+mTwolgqJ+h5MNNihK5wVXdTfdNXZ5hnC1IY4FoZbJLLuoopZCszrJJcC
	hJAyWCGCAdz8iDAURokINfj5uwUjKM6LC2byVPi64m9EQOEJdTPZRh0kjIopGkAeJQpbsMk+rTF
	gO4pLwovE4GcNiw1Jbt6wOec+YV2I9k5GGz8bBmqDcZMsCwVJ54RVKns3jWzI0E4vpjZLKt5SoE
	25kn3bfBF/MD6LFiVW19ZWxVygQSF06Q0LeYG2Zbj/xyvGCDP+AI/Q7nvM0fCW/EHpv8JCVA3Yd
	NSjkz8a6cmrVJIU/yEdg/Fe1a6IjcIBoEgHLW4TwK0OCWry8+2zkUauZEfkvXHQvRK9bAcbA6B2
	spmmtpc6YdWw0OvbOcAKDt4s0BH3ZwshaPLnbBeHgAq5mtiuCnEDCt0x5T3SEfp/nDf3uoGOK01
	ElbsSI7/qEIxXxN2dpROQDKHc=
X-Received: by 2002:ac8:584c:0:b0:4ff:b18a:104b with SMTP id d75a77b69052e-4ffb4958e3cmr22070891cf.23.1767773764762;
        Wed, 07 Jan 2026 00:16:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHLeBGot7Id1we2Y9b6hS91s2FZEXZi38CtpMmDPlfGWQHJ6LjX4679mu2YzAgFfrJeuO7bxA==
X-Received: by 2002:ac8:584c:0:b0:4ff:b18a:104b with SMTP id d75a77b69052e-4ffb4958e3cmr22070791cf.23.1767773764383;
        Wed, 07 Jan 2026 00:16:04 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b65d0d108sm1137893e87.27.2026.01.07.00.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 00:16:03 -0800 (PST)
Date: Wed, 7 Jan 2026 10:16:01 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH 5/6] arm64: dts: qcom: milos: Add UFS nodes
Message-ID: <jbunqx5xj4kff7qxajgu7lszsmkpw5cq2bceuz7d2me3fkydph@k5b7aqggxb47>
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
 <20260107-milos-ufs-v1-5-6982ab20d0ac@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107-milos-ufs-v1-5-6982ab20d0ac@fairphone.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA2NiBTYWx0ZWRfX+YwdyuSC8C16
 HQZe4SseEAVWmI7oAtVC/1ygGbXCdF3nmrjSfeG2+FIBS3NxVsCk4f1uzNukQWrDEiSRQuviD9w
 51fR973uV5hETz9sCpj5KzwJs654QKQxn3HjGOi5fvBc4Nh682qKfgoYI7JdrclNqDvbTqMJgfx
 fwIG06Ssqzspiw0JDBcF7NxHg9MpTiRTlRMIhcJz82OX+S9a2GZUEfgYnaAXM0c5jH7K+3fsQWv
 Szf1MT7GLLEcsNu4dabOHBndilmo4zrCUvJ44STfOIf3ONBgZ/MNtvo98oVQBWMkTLv7dVN8VF0
 PcZgfXr7XiZXZmvkyNaH+kALS4bBd8loouX7YJWxZlwPVnM+zZqNyjZYQ4oJk7Qr6FaQ2KroVtJ
 YgiSsblgeG5JnraOLk+sbj0o/oDj6UkRX3ztuNMRkerFJUxmGYdOZhWbRki9vhlky2laIcVEHTJ
 EAHTc1tPfLtjAVDgVsg==
X-Authority-Analysis: v=2.4 cv=VI7QXtPX c=1 sm=1 tr=0 ts=695e1645 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6H0WHjuAAAAA:8 a=EUspDBNiAAAA:8 a=PvTnMlK2driW4fpN2xAA:9 a=CjuIK1q_8ugA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-GUID: d9swqLb6qKHMvDanbLYdHQ1F7mGfOSKl
X-Proofpoint-ORIG-GUID: d9swqLb6qKHMvDanbLYdHQ1F7mGfOSKl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601070066

On Wed, Jan 07, 2026 at 09:05:55AM +0100, Luca Weiss wrote:
> Add the nodes for the UFS PHY and UFS host controller, along with the
> ICE used for UFS.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  arch/arm64/boot/dts/qcom/milos.dtsi | 127 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 124 insertions(+), 3 deletions(-)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>



-- 
With best wishes
Dmitry
