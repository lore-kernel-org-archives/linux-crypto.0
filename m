Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2EE32824F
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 12:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764331742; cv=none; b=ZYvchKod+pt0AekL3NsJUDNUw59QUWeDSBuVoWpD4S7x+KnMWObv1Bcl8mQ4KA7KRMFTeOIbyQtmCB83NSBBu7tHYuDh+319BFleD/X+xTGmv5vi6Og4RHfc25Q/p9CkABnFbj+ALgVOcGMJhLSuYsb0AGBprZO62UYqo+6+eaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764331742; c=relaxed/simple;
	bh=ueLyq46JDjBihegO9qj7nvGBPhhfHALgUnFEM90Acb8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FfhNEu6KlvgIc32oFd4iIlTXzKTYodJxfGsWxCNQejNXp9S77HCsKEuEri4IjV4QoZsM+Cz0Pkf+hSFulZhzLXNNP1JIGLV8SwtbOUeBFd/5AMzVSrUtQvcNPRuABykKUre7sVbRFNLyerj50NW9p7ta0HhnyO48+L36aaaijDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Wl6wxasr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RLyRGSjE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Wl6wxasr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RLyRGSjE"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AS8Nlc63122945
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 12:08:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/AMvgGr+A3VUPf83LfDwUwYIePu0GXYwS7q7hJotv5M=; b=Wl6wxasr5uWhH+yp
	XGPWcbtqtx3qebtX19hT3w1qs3t9v0S3K3pr1tjIk7DLXghxMbb9Eg1vsYLa6esK
	mmY+61Y+msMzPumjPb6Jy96QxhIRl63IaVlVgh8WKtB+XiQVVz7Me6qM8cORra/J
	aNWsWRn59rYFGsiPiF7oDUrRkpBSkJuUtIhfkXbBGqsW33EahkMOsumFfgqa7sjh
	YVZXzdOoNbiz6yM+JnTqYZHifIe30h7Uq816FA6vuca9wxj+gibSle85lB6R2MxU
	W0Toc8vZiTvE83l1WPTAV43193Zdf2fDHx3uit/kfDy52d99UtcBgX+EABLPElvO
	oOoM+g==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4aq58uh4r1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 12:08:56 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-5dfb8e7d182so179043137.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 04:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1764331736; x=1764936536; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/AMvgGr+A3VUPf83LfDwUwYIePu0GXYwS7q7hJotv5M=;
        b=RLyRGSjEn9LnHZondWLGZmFvMqoTL9Lq+pc8K7OGAcIrpgrVNIRgJRUyyWPrt6KVvq
         xCoyebtmopiNZWl/z0spIBKZApJSYOD1h6fHmZdBv76A6q7mS5vKl4KUeyLSf50AQJ0z
         acEAVfKU3FHxH1S7+9HtVcp99EoBpUa8D/uY7yVQZSuSRx0dr3qDEkVSutapWQznMH2G
         x7708Pe/5cq2w4J4YYAzsYEAWbFFEhq9R71KS4jpAjwUqjD0H8vq9uYLdpaoaoHZSqga
         AhrGi9F8Ms1kF+eSIpnGh5V/4X1R8RWa3Z+JS/Zg2TNnzc0vQfRYgRQ8op5QkN/JfH8w
         o9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764331736; x=1764936536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/AMvgGr+A3VUPf83LfDwUwYIePu0GXYwS7q7hJotv5M=;
        b=JZq76zq07Egsk0rFaLyKFcSHnjWQSrGXkCPwKf9IpUe0Jm/Hckqg+i57EM6eIdOrmU
         S42P05yhk1dZKOXIBel6YHRErO953ULmCllMtdI+kxaFJMWTEqE2w+fbFurWyVfIfsXl
         PXHVZg8DyRhtPcxgEK50Q5M+URDDSj+L5ZbZ0OPrYlcKJd9FgoYzXoC6eQ4efdJLj9U1
         V6ug8igrCtBCJxHxaiyjWinCQE+E6R76U6LJlXvjEgoF5C9S50vbFSspFeR3kOylXc7p
         XgxccH/0Ga23q2Sl7qlhLouC25D6UUmMIDptoEfS1tW3VfMHm8+HZzSu0q8y24mlKWrP
         zr+Q==
X-Forwarded-Encrypted: i=1; AJvYcCW7M2dvIxMDKyvhPO2QQ57BMWc2k9gD4MhwaXeftv6PMXAT2Aw4ice2qg2KMVASA+RAdt1mALD7nlnrovM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/C+33Y2C9qacaVmgJMhLI+FHNtxZJ2M+cnlnDXe2nDBEhwl8G
	vgA56M5YEkTJiueJDHu+xVd1N8+yU68C1Hes0QBA/L4KNOyMOpuT6HjTpli1/cc1js7EsbSntEV
	Ud8+K8TzDMSURQ10eS2nuTaGqudMrOVBhqOSVUpAz17ABP50WAuIWw1fEtngDpmcP61Y=
X-Gm-Gg: ASbGncunT99oH3tT+lzGaomTX2sSYnvUzwfpKz/4HaZ/HbC8aZ+6uDK+mx7PqJCve8u
	FASR0s8g3oRjazVE8l2KhglMy6noUF8+9mQKo8Kre3Ml/5ZznMB5I8f9HI1JDYjvZBX+51nDW/D
	9MQsuOFKLOHLBqcPA40YhU8umR0/C9sMz9p//kzirPzuXaA8yPtjKBacc4Pp9JCMaFhZe5QrPfn
	aLaGP5nP4f10kfgVCBqnW2uSvdtpvMnsMvHncVU7UpXBtrf2IcYeH0Cc/a15xvHnltPrnvG1Box
	R7mpQZpEHaW2oIdGtQAYaNia6NBvrQN/VBcFUuQFI1pvc9ZE8AS5e8+VywlSzThjtJwo70Krtv8
	bnvI0GsqMVl2s7Wy/lLvP60uNr0+zIyjJpLU5ASTkanAq7Zbc/Ersi/VqSpLQ6TIS6zU=
X-Received: by 2002:a05:6102:4420:b0:5df:c33d:6e58 with SMTP id ada2fe7eead31-5e1e617ee0cmr5243514137.0.1764331735640;
        Fri, 28 Nov 2025 04:08:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGcDNhnYB3uQVovzvtUAgWZaPKJAKjhvoad+skVmq1ako0hV88tZALhYbd+C4wBmEePnEEdrQ==
X-Received: by 2002:a05:6102:4420:b0:5df:c33d:6e58 with SMTP id ada2fe7eead31-5e1e617ee0cmr5243461137.0.1764331735249;
        Fri, 28 Nov 2025 04:08:55 -0800 (PST)
Received: from [192.168.119.202] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f5162088sm432375166b.1.2025.11.28.04.08.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Nov 2025 04:08:53 -0800 (PST)
Message-ID: <afde1841-f809-4eb2-a024-6965539fcb94@oss.qualcomm.com>
Date: Fri, 28 Nov 2025 13:08:50 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 11/11] crypto: qce - Switch to using BAM DMA for crypto
 I/O
To: Bartosz Golaszewski <brgl@bgdev.pl>, Vinod Koul <vkoul@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20251128-qcom-qce-cmd-descr-v9-0-9a5f72b89722@linaro.org>
 <20251128-qcom-qce-cmd-descr-v9-11-9a5f72b89722@linaro.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251128-qcom-qce-cmd-descr-v9-11-9a5f72b89722@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: qEqeIm4LC78sxIhoiF6wirhhvR7eg-iy
X-Authority-Analysis: v=2.4 cv=UKvQ3Sfy c=1 sm=1 tr=0 ts=692990d8 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=KKAkSRfTAAAA:8 a=wXQIig4NBtMv4ZYXLh4A:9
 a=QEXdDO2ut3YA:10 a=gYDTvv6II1OnSo0itH1n:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI4MDA4OCBTYWx0ZWRfXzh7oPad+uYwb
 7NORP4ut5HWVq5m6ZWc1VLyHQRmX2IYUjn/nzeT9RxprIJpxuItjRxVPKbcsr0MjkkB+Ml7s+UO
 2geCULxp5TjIyRMpD4A8pVZFeP2aRfUpEyv1AjHn30ivv5qbewKaHNTbngGomLjkN3dkgsSZvl+
 mCoiUZIKaJqCtuYuGgP57/Ir0EYZv4tYJQ8c+GGjPWZabr9eNwuMoOxZlyf1r3wfP9DgwmHYHqz
 701CGT9gX6DkzrJLWmThvYLu9Kz26kehGAWF7tFu7nU2ciwGxaYpsdfZjguzGPh7x/I4G5QjVu4
 f7hMhLaZyViRVFS1D//SdmQ+8yv/z8GqjJEjxWiWBq7WNwPDzHYL7sm6tWY/8kooiXYAK5guxyp
 Va+sqq7Egcoms7TVcmfWrMuFnGbkRw==
X-Proofpoint-ORIG-GUID: qEqeIm4LC78sxIhoiF6wirhhvR7eg-iy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_03,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511280088

On 11/28/25 12:44 PM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> With everything else in place, we can now switch to actually using the
> BAM DMA for register I/O with DMA engine locking.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---

[...]

> @@ -25,7 +26,7 @@ static inline u32 qce_read(struct qce_device *qce, u32 offset)
>  
>  static inline void qce_write(struct qce_device *qce, u32 offset, u32 val)
>  {
> -	writel(val, qce->base + offset);
> +	qce_write_dma(qce, offset, val);
>  }

qce_write() seems no longer useful now

Konrad
