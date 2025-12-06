Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3532D94B4
	for <linux-crypto@vger.kernel.org>; Sat,  6 Dec 2025 11:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765021367; cv=none; b=m7is8DIk/b6VG6XtlU3cYpvIQ/NRXKrAGVJBgmq3fipi1XQL/eGqOaIzS9a8dYtgrHsnc37F2/5WD9HwZyjkY+rBGq1q37Rd6GLxgEslIG/t2VpMI9s037F00cImi6qvRh0Db1JnBJvhXKR5DfFTGC/ZIK5NeC2aMjaJnfZyJio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765021367; c=relaxed/simple;
	bh=uSnV1L/yoLoYSmvzP4okgFwrjeu+CCdIqOIDRC7h2d4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DR3aHDyNRfwtBc7WfQoWcPA0IaQCe5nuwnWVQVQekdyZOQq1NxHWBDa5QJYFWqPf5Zf0PY7MCHELR7p7u2dX3okfQQsbfKeK7tdGt12qEtYXrOvwuYeFF07KdSfirmnU4OhuduP/i5hJsSjcVx9B0qYtwDfZqexa1p4JPNlYyOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UhAu0gMS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LEcbBQ+k; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UhAu0gMS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LEcbBQ+k"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B6AXho03418709
	for <linux-crypto@vger.kernel.org>; Sat, 6 Dec 2025 11:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=zsHIxuXaNGoM1O/Vkbmg3zxD
	3eb+BNwHk3XxGSWuP3U=; b=UhAu0gMSkWM5NggVwjfYksNUQzN5WR9fzVDds12a
	yqxAl/xh1OFZonc8DAV83/ZU+Ziv6ERvTwe0A2Giybr4v4J5wL4b/MLKxThssy1T
	sP7UWKE2qffLygUhODTv5RjFWUWF8bx7eQk2DOgW8FaI4YYDkqssxb+oS3+RC4tr
	ZMCexKb9r+9Sv+R4eTDk6SMx2woLwfM/ITjI+16gBlqdug1okQa6lUDH9lIYKuOL
	+GnOnt1W/0hAaKj1toTFzlpk3KEfYUxPNyldZHqqUZwFRkO54Oh92CQrQXB87Pfw
	RZ9zyJznlIDvGLqIrddHya/URgwPjWWT5hd84l6LmU3Gtw==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4av9uprxs7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sat, 06 Dec 2025 11:42:43 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8b29da49583so810706785a.0
        for <linux-crypto@vger.kernel.org>; Sat, 06 Dec 2025 03:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765021363; x=1765626163; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zsHIxuXaNGoM1O/Vkbmg3zxD3eb+BNwHk3XxGSWuP3U=;
        b=LEcbBQ+keBEXDNHu9i4hcLLlbgDJfE5WxMJfypjAW7OA8cW6792l+4w/fz0oN5kgar
         42Uf9KTs6gN4/Uv7mCZW4961eltkZhuA0rtYhx0LZXPHUicyIOPY+QL8g/gcND3Y2pwM
         J3JXWe8z3u1A/XI3B9siQaKjnEWj0fMXs6yKcBaMv9ROudGVOOhYP4PAeTRlpGRrIvm8
         /Mi3UT2Zwq1QvEa5E84XSZdlwh1bZ3PckFwCn4LK5ZQq+nPnRyuQNwNbzMc4BJQKcY1E
         MFwwatHCllLK6L/jXddp574MMifOVQPUgtXT79G/8CiqxTfTLUnPxci2XImkHGEhy4/L
         4jyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765021363; x=1765626163;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zsHIxuXaNGoM1O/Vkbmg3zxD3eb+BNwHk3XxGSWuP3U=;
        b=UtunTEnqjuvIvpecE/URd54K6a4oZfv0g/T7W4Pi4S8/Cxwxc8KJw5sKlhDOpHZARF
         OFKrJ+dgNR52odWHCZfC/lzPplzH/Jt58MFiiwa9QogKG0dlwPRJagrZqSL4D5eNmdH7
         E9fmIHtvx8QnQaREERJjZpsz8sHypdFQha/sg9TXHDmT/2qhZV0t7Hun2iBL04Hdt1Nq
         KdMIbOWlNoqTQLO9h+GaCEObuYL3wqTdhL6BYQ8m715A0bfp4pPXf0o8dj0lfig6pDpg
         sPrFzN7CvMg2uQeHfxOQ4T80PhHlsafJnZI9fkHvy7CY7DbmecJ7BZ3UYuwJXeNoc5TX
         rhuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBQSTFgej/SQCwxMw4ex9VzH9iSbgSr3nlgjZBH486VLwv1QSEFvooXTHNfz4aKPYduDMF8bnqsuLQMBU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ+UIiKQuaWncL77ntfiQdqZqNjqfl3qlJ2RapQH6FdwfgZjQq
	pKU0DDAqxEfsn8mss1EBcI5DGCKOC0nd+Ewwggx6/q/PxtRdr2Pr6kQiU8B8YgBnkkqS8Rsgk6i
	QaTkGWWSuXAt8M4sFkZvfNMMf6HgQ5LadYon9Z2t4KVQ/b4wV5gM1e4a79e/TbGwWBFg=
X-Gm-Gg: ASbGncsavBrUodRZ7Xt8DbksnYVkNUmZ7crX09OPDINDufuEOOe7wqdiFFlzOn2Tjbv
	wdRygUk5tiCbBejQ9cwacJeQYMHisjfPY2VCizf7xBUQ4lEI3i5tlLdhmgZCKG4ryls77eWTQxj
	AutpgRU7RnZ/FtYBQzQFMmsmRFqtY7wGgtihnR7I+kD7VuogGMbann9d6CZgWJx1MU5Isrb+i0E
	j8FgxoGpdfJ+JudxGPr3bIEAxzuvbY2P+6kSoA48Fbm3nzumdsk1BcFMVXZu8qVgzHs4szVQW7O
	7BFG7qs7eI57N+VcMxXQp7u0PimqOemf5WVNDZfNAGRs75HgM/AJzZqlzP8LzU1pgzVOr8c1Uax
	RSdj4rKqDLyJ1lRvFgaJJB5unKxcSB9G2Vqq9BoTOzekTlMHJ0Hyjr8msiV5Oow/0jftCycoL18
	h4bDBOZkxkaWGQ6C6qlcDF0+Q=
X-Received: by 2002:a05:620a:4403:b0:828:faae:b444 with SMTP id af79cd13be357-8b6159b7a2dmr1361616485a.20.1765021362614;
        Sat, 06 Dec 2025 03:42:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFcZrNL4Sc3FjzMtUYj6baDuC23m6S1Oe/SmVjHFc6/ndE7RqpxwssM9vRMCufWsbeqU/ljaw==
X-Received: by 2002:a05:620a:4403:b0:828:faae:b444 with SMTP id af79cd13be357-8b6159b7a2dmr1361615185a.20.1765021362169;
        Sat, 06 Dec 2025 03:42:42 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-597d7b2481fsm2338116e87.41.2025.12.06.03.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Dec 2025 03:42:40 -0800 (PST)
Date: Sat, 6 Dec 2025 13:42:38 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>, dmaengine@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH v9 02/11] dmaengine: qcom: bam_dma: Add bam_pipe_lock
 flag support
Message-ID: <bizsf4ubgudrzu6sa7p3s5aruitjssc5juhfsr4uq6p6igg2ak@m6k56syfcz6o>
References: <20251128-qcom-qce-cmd-descr-v9-0-9a5f72b89722@linaro.org>
 <20251128-qcom-qce-cmd-descr-v9-2-9a5f72b89722@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128-qcom-qce-cmd-descr-v9-2-9a5f72b89722@linaro.org>
X-Proofpoint-GUID: 87hAXzXB7gis91-GlWZjoEWFqrHjV64K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA2MDA5NCBTYWx0ZWRfX6Hmg+NkEnDQD
 9BUUP87t2WcSlzos0cA2aqHID6dnNLajRpBNNpB+IwxK7RWwCcWC7ZXmACmGP4Y3li9oUJ8Km0B
 qizQrqpVe49OJeCCVBida9LJXw+1w89Tqed/2JlXWsQCFWK1ctgQz/x/Zrcyx1SVpCqTnsytxQY
 OmZ+N1mJVUd/z2dGL4yMQ0566FhFzIaiwjwwrcq4992UrEvMUHFg9wsjiLwHQJ40UuH0m0wLf81
 7tiab7hQFLJE5BQxpTSf3/1g9H3bDjEbymSgbYApjkTHLLBWVjRt0Ji+aoQACtOE0HSu/ZmC+uQ
 7LssBrMtUyn7Isc2bsyGFfY9JIVzyI4VFJrTNfqCfLk4ArAAQp/lKmj0eCNvqWuIP/5SJ4nF88F
 Ba9aiZXMo6Qf+XI5D9KPgkaHTGXs6w==
X-Proofpoint-ORIG-GUID: 87hAXzXB7gis91-GlWZjoEWFqrHjV64K
X-Authority-Analysis: v=2.4 cv=NsHcssdJ c=1 sm=1 tr=0 ts=693416b3 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=8EdCfmeLOmFKhcBkMyAA:9 a=CjuIK1q_8ugA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512060094

On Fri, Nov 28, 2025 at 12:44:00PM +0100, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Extend the device match data with a flag indicating whether the IP
> supports the BAM lock/unlock feature. Set it to true on BAM IP versions
> 1.4.0 and above.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  drivers/dma/qcom/bam_dma.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
> index 8861245314b1d13c1abb78f474fd0749fea52f06..c9ae1fffe44d79c5eb59b8bbf7f147a8fa3aa0bd 100644
> --- a/drivers/dma/qcom/bam_dma.c
> +++ b/drivers/dma/qcom/bam_dma.c
> @@ -58,6 +58,8 @@ struct bam_desc_hw {
>  #define DESC_FLAG_EOB BIT(13)
>  #define DESC_FLAG_NWD BIT(12)
>  #define DESC_FLAG_CMD BIT(11)
> +#define DESC_FLAG_LOCK BIT(10)
> +#define DESC_FLAG_UNLOCK BIT(9)

If this patch gets resend, please move these two definitions to the next
patch. Otherwise:

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


>  
>  struct bam_async_desc {
>  	struct virt_dma_desc vd;
> @@ -113,6 +115,7 @@ struct reg_offset_data {
>  
>  struct bam_device_data {
>  	const struct reg_offset_data *reg_info;
> +	bool bam_pipe_lock;
>  };
>  
>  static const struct reg_offset_data bam_v1_3_reg_info[] = {
> @@ -179,6 +182,7 @@ static const struct reg_offset_data bam_v1_4_reg_info[] = {
>  
>  static const struct bam_device_data bam_v1_4_data = {
>  	.reg_info = bam_v1_4_reg_info,
> +	.bam_pipe_lock = true,
>  };
>  
>  static const struct reg_offset_data bam_v1_7_reg_info[] = {
> @@ -212,6 +216,7 @@ static const struct reg_offset_data bam_v1_7_reg_info[] = {
>  
>  static const struct bam_device_data bam_v1_7_data = {
>  	.reg_info = bam_v1_7_reg_info,
> +	.bam_pipe_lock = true,
>  };
>  
>  /* BAM CTRL */
> 
> -- 
> 2.51.0
> 

-- 
With best wishes
Dmitry
