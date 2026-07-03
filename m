Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4B0344D90
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 08:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783067914; cv=none; b=Fekboh5BS4oPHHKkT4p0pjPys7c+peYrdWwt5N/y1TLia/sel/Myt8+d4b3ANqgz1BzQgMxFDFsMgXqcJQqFgGXw8eWf1oE2ZmPz0CH9YBAogVnotCcsGyzx7TtPB4so8/Cq10bHynN9bREBYAwtlOhZGe2qmT6S/WMf272c9nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783067914; c=relaxed/simple;
	bh=cdBpJkB4l/ZRo4O9VKG44JGa5I2jAbDW8goIFlmTmp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cUY4w362mtbgZcO872CkPd26l/CPQMsc53ojwjNIfAetcExVaUmBEKDSmpBGtNP+Wh+D8wgc5lDWi9A2X38YGLb0eJ1UCLUWc/y6FxcOZwn1TfguFvd8sT0Xfcr5KBqCekWiEKnPn26aXYvDmWvZs/cp+PtHnXJQqKeTsGi/N0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WlqBeQ60; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dM6jI659; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WlqBeQ60";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dM6jI659"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6635rx9U3109544
	for <linux-crypto@vger.kernel.org>; Fri, 3 Jul 2026 08:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hswMxx9rR2coXNNSZIKHclwuegKHDm4R8y+AVY1VBRs=; b=WlqBeQ60qkIZLhWx
	Kf4n1LSI6Tw0suSiShNTHd8D6b0jay0AG/pBMBgFrS1kQ1LgxiKay+T5CXIFCr6d
	KXz/dMxeHlxCIhPaqYHoH4DRLcjgIyEi07Rslbn0ne32eSoY/rbl1s17FTwyUAzj
	rdsPz48ickOfyZsdL57OwYx06JWoV4teyhunVc/NUHY7RorO9kjHRQ9MnBEj91Fk
	1oxQjDQedUoz0WxfIhTWbCwnvTs7fTnLhZcC3Q8MlOJd/d7GK8TKRO28/44QQ8XG
	EKdLpfHOzWfRFj/ZW3SHEtaEkNX4EqvOAf4RZkbskcb0PxUpCesWqxsgDI6MFsQx
	XznlXw==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f60eya56g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 03 Jul 2026 08:38:32 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ca0d4fb061so7202915ad.3
        for <linux-crypto@vger.kernel.org>; Fri, 03 Jul 2026 01:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783067911; x=1783672711; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hswMxx9rR2coXNNSZIKHclwuegKHDm4R8y+AVY1VBRs=;
        b=dM6jI659XygDcPD9ZihuiG76xg4zPAGD9NmIM9/yB7Nuzn7qKzF7w1duq980gIjqCA
         a8aSf1x3Fx6BftyPJUoPjiUm8XnnqLq65+R9EGax45ABkjUBH4xui3Y8fzFma7hxhOIq
         8yBOkvGQKu/JLn2CHZXG0UFSavc3Ra4KCD8gix4oVF+imLYmMowiGym/I+PwY78mi4JQ
         e09nnPk3SRbufurr/R3PME2Dk5gcRJsuwkaJSIdCqdy399C9hz0rtxJx/pFE8jrqzAts
         EfpMThpCySWX9tz4IG5MNmnRrYZHzkFdvVww0VhYV0gt4lcvVR94VIMMktJmmeFzQsgr
         gz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783067911; x=1783672711;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hswMxx9rR2coXNNSZIKHclwuegKHDm4R8y+AVY1VBRs=;
        b=MW3GimJhV2AN41PGyMqkFBuXH76GDEsvSs7xxSUb9P+LV9YJTxolwI99Jifv1ouddg
         Zz7FykvvRRYxdMiDRtmH+jlwk+WQZB9obsLe1Xnlx28sCieJswLCmqp/pizysklHpBHi
         2Q6Gei8d+ne4E0TwnuzCgFHdPI7CUCxELLT8dg0KO+DZSkFAt0ih5i7JDOlpegvIRP2U
         8mHi6hmVPFdomKX3X5Ey9rkn2+zYG1dcmddhn9EG2qI9qEvUNfEvHMeEhxmMVGafb9+B
         HoEwyO/2KKrul1li88dt8DluCuve8uWyFcwRWcgVu8C7catl6Miltk4h4KRFMfhjkS+0
         YOlw==
X-Forwarded-Encrypted: i=1; AHgh+RowZOi9w/O5AKVf5mwPp6YgYQLjZUaP+We3MPJ+0m+URAV4FjJf1zpcrcWr4MwCKbYN0e3wUKTikmXJgfQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGNEVrCa8Lk3pODlGkNniv1SPS4CDKtbZM30tSz4MDvdzUYqdK
	dBPeaV51M5pX0Ogj3WzbWvV9L1QiNpbSWr3iRs7iSBXsfdFxlLlHVRmqoeUxhX3myOZ+kIxyL8h
	70SUhP4BohIPoPbKjuvm9G26lIAXRaFwNQxZUqYlYbmf2TBpb4cKIXbfQxbDkp/lYFPU=
X-Gm-Gg: AfdE7cmjB9CnaoBM3KoZnCCG6lXb+w8D2zmQN3nRHZP01aYMYUTEmtNRbwJTgU2jjbu
	DO/sVFkKPiyNuul15/GlQxIhllw6pWSQTbEg9xpoSiatpeTsUVe7/mBa4vbaz2EyoKhQaGGR1N6
	AgEA1Fe2H9BJlWQEsmxd+qoeH6A42Ok8WWYrUgsDhAjkeWxTx1aI6uwSSZeEcNdZqIhHQ7MWXv4
	6jF7lhWlCjdJAE4i869XZbMzx9n2pIocG9lxcGIekDpaXcv/l/kvYtdiCJZb94e50k2vzm93Ra7
	ui9kyKo227Dlg3ks4KBTyzNQQSr2HmowCJCXuUeukoZQa8ibxQRq0btHoa5jsrjCMQIUEZgG2p6
	ysEGKv4feCx/f/g18ps1g6N16C0usUokbZ9yESQjECA0=
X-Received: by 2002:a17:902:e54c:b0:2c9:adbb:5862 with SMTP id d9443c01a7336-2ca7e8b686fmr96679085ad.45.1783067911351;
        Fri, 03 Jul 2026 01:38:31 -0700 (PDT)
X-Received: by 2002:a17:902:e54c:b0:2c9:adbb:5862 with SMTP id d9443c01a7336-2ca7e8b686fmr96678625ad.45.1783067910779;
        Fri, 03 Jul 2026 01:38:30 -0700 (PDT)
Received: from [10.217.222.146] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b3c876ea9sm15875811c88.13.2026.07.03.01.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 01:38:30 -0700 (PDT)
Message-ID: <e53f9b7d-66f1-4922-ab20-f6e66015c912@oss.qualcomm.com>
Date: Fri, 3 Jul 2026 14:08:22 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] dt-bindings: dma: qcom,bam-dma: Increase iommus
 maxItems to seven
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
        Konrad Dybcio
 <konradybcio@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
References: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
 <20260702-b4-shikra_crypto_changse-v2-5-66173f2f28b3@qti.qualcomm.com>
 <20260703-steadfast-greedy-seagull-ad32ab@quoll>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260703-steadfast-greedy-seagull-ad32ab@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDA4MSBTYWx0ZWRfX52XBszNSOI+1
 JLdkybVlNn3rvXCSU/QSkOLQmzbElW3eviKfuW0s3YxpTMyiqeVzxLEmCRXW7tWoRgSXZgVHmQD
 N7uiaw3GqToNeH3MY/QiUraU/yS28ZrZKTDBd/BhJyzKpQWp6kE9IqmJoRUaEscuc+jlRd8xPEM
 7ArCV08FcT5vbX9sqyGJcKeZdrfMrUJqaY/kk5g2Piwd/Jxuo+EYKsyo0Lc2Z/xkx0PW4pU/ejL
 bf+iwybkU/1RLOrIsmQl7qU4h97RBO5A4Bw8Mjaza047K1+7QNBQuk8ruhQY8fQg7hQVNRzIsoF
 ZAfUivuBg2caLBzGhdJ3bYn5ordfZOJ8h2U17vsq98AdPCqePTcPLh9/1+L40wgnymafNbrW8uY
 MzB9HacIzIlLZVMx7dazQMkYxeTsAR41OhU3tBR1J1bizEOo3jpo8I652RCWjN2e9IwzPnTPDPC
 NIodONm0FJ7eq6aRrHg==
X-Proofpoint-GUID: 5L597He5ebxeBF6XYZmxmMoOwv3Uylbi
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDA4MSBTYWx0ZWRfX8UGsmOupDcuF
 5gtHEA38CTouSxpajNb8qn+aWnCMO/gUJSEh0mX2S2+iajX9/vhUBQPrTrvQSKo4Zvy0m0CVLyj
 xJGARjnwl19xvjadnsmci3EYN9sjvJM=
X-Authority-Analysis: v=2.4 cv=SPRykuvH c=1 sm=1 tr=0 ts=6a477508 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=B0NKSWsiUjiwxuKyzxsA:9 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: 5L597He5ebxeBF6XYZmxmMoOwv3Uylbi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607030081

On 03-07-2026 12:24, Krzysztof Kozlowski wrote:
> On Thu, Jul 02, 2026 at 01:47:15AM +0530, Kuldeep Singh wrote:
>> Upcoming Shikra BAM DMA uses 7 IOMMU entries and not 6, so increase the
>> `iommus` maxItems constraint.
>>
>> Fix below error:
>> dma-controller@1b04000 (qcom,bam-v1.7.4): iommus: [[25, 132, 17], [25,
> 
> There is no dma-controller@1b04000 in DTS. Please drop all the warnings
> which do not exist.

Kindly check patch 6/6, it is introducing bam node with 7iommus which IP
describes and hence, updated bindings before to accustom this which also
helps in avoiding rob's dt-schema bot error.

The same way we add qcom,shikra* compatible before consuming in DT,
isn't this case also similar where bindings are updated as per the DT
changes?
> You cannot add incorrect code, 

Shikra bam actually has 7 iommus and hence, bindings need an update.

-- 
Regards
Kuldeep

