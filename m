Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422212DCC08;
	Fri, 23 May 2025 15:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748012536; cv=none; b=WKPu13BOTgV8dnW11MYMSIvNNxgMnoAf8VaMc9oyW2a3RZi33SNnWUw3lyUxno75CXvMiAfxcXKRD3apW2txwXBm5k0qKhsgfiPmzHQ27f4ENKlZzW06jPrDV5qFywZiskYpAyYL7YpxKUPO+1/q2zvscO4c+7qfSzPlZ1d2MWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748012536; c=relaxed/simple;
	bh=ZfuoQrECJMLtQnZn8BYimFrpH4SavHehiEYlbvVVqMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LfUibNwzYTWk322ZfzzMnl2S15pB2sP1lcJHNlbY0BK4PdfvXpbXApF0K+fAC6uDRmKoYcw6PHSGxlACohjeE8E32DtymRY+HfoRmSjuyDRftwbILueR37nbCDt2qHDnM3bwAp7yB+7yxaxzkbly5bjR1kDxSSW9E/PTFCnlepQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EGKRaTsm; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EGKRaTsm"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54N9rqxB024716;
	Fri, 23 May 2025 15:02:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AXuczq
	+4zIOz8tLGLw7OYMMQ8nWPYgqt+3uWiO5GUzE=; b=EGKRaTsm4m/z8yXBwN1lOR
	HBVfrHAZRopqSOJNfuk6xPIP4TV0rvkSSLCPuk1EkoCbdMJh6iEdij3EF9BnMZYc
	x1LRVgz0n7DyZ+13Qo6J69yT/acB2Q2A4W5SXmflmGtRIkwEnYJzbKkbH8Sr0gp2
	t1hHMcL+R19Mow78wSZvhxGM751/PXKI5ZUlHmLTisoqyvDq1Wbm1xUQIasaEDY3
	YS6xXV+GnBQaDCJSVx8DL3Dbj9LyrZhMcyEz9GmBsWVJbrxoL9Cdf2xRia/CwdqC
	VV9GbKAq6APo6ebBxydnrVdTNiCngG7Sh0SBx2404gvSBnMZRgO5aARZQtj9cuMA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sxhwgdhp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 15:02:13 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54NEtusg015487;
	Fri, 23 May 2025 15:02:12 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnnq1rq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 May 2025 15:02:12 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54NF286F30147250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 May 2025 15:02:08 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 58EA32004B;
	Fri, 23 May 2025 15:02:08 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F1A4A20040;
	Fri, 23 May 2025 15:02:07 +0000 (GMT)
Received: from [9.111.78.193] (unknown [9.111.78.193])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 May 2025 15:02:07 +0000 (GMT)
Message-ID: <505bfaf2-da36-4c0f-8165-f44b8813eb0a@linux.ibm.com>
Date: Fri, 23 May 2025 17:02:07 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 4/6] crypto: api - Add crypto_tfm_alg_get_flags()
 helper inline function
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        fcallies@linux.ibm.com, herbert@gondor.apana.org.au,
        ifranzki@linux.ibm.com
References: <20250522085755.40732-1-freude@linux.ibm.com>
 <20250522085755.40732-5-freude@linux.ibm.com>
Content-Language: de-DE
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20250522085755.40732-5-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIzMDEzNSBTYWx0ZWRfX07u3gs0uUMX4 Q4XhB+l8Fi57BS18MgE9d9WIz/fi+9jBRfkxcovMVihhq4hE/vLHZWqq8zlf4JHVd3BqrUnov5N w5xgRIFxI+t8VQ1l6NusLux+GuN+WDBbx3FF5OhdF7xDvlOcKtN4SzD0E5gai7YcHhZTu5HExee
 318nyRxJelTlvcTQyqWqMVoANNNc0Gmbo88aRO4jZWfkfR0ShNtWJRBGzKslSm3Yp8NO5tOZsqZ yxncscesi8f1GC35+Dqe9CAuG+KtnAAraJ0VcC8Mok7Egtng1Tgb0HUkk4fqFFlHzCgdY2vuaAH Ttk2JPGk53dGXLbP6vvJXl49LEr4KdN7f9RxHooxIg2oDpt3qCop04DUPwJu8xJEfkhk1jmQ76O
 SXhgWUAFlXW5Cjbh83oZThUejSfOkmutlIU1WNXmZ7f0sYubWpg0HpvoOQNDEWvmul3e16tO
X-Proofpoint-GUID: -k0lOGgdZEJcN1fAotP5U5ZXEHppiwiw
X-Authority-Analysis: v=2.4 cv=O685vA9W c=1 sm=1 tr=0 ts=68308df5 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=w46-cfdy0MOtRbFV-QQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: -k0lOGgdZEJcN1fAotP5U5ZXEHppiwiw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-23_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=905
 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505230135

On 22/05/2025 10:57, Harald Freudenberger wrote:
> Add a little helper inline function
>     crypto_tfm_alg_get_flags()
> to the crypto.h header file to retrieve the alg flags.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> ---
>  include/linux/crypto.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 1e3809d28abd..a00047a53690 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -452,6 +452,11 @@ static inline unsigned int crypto_tfm_alg_alignmask(struct crypto_tfm *tfm)
>  	return tfm->__crt_alg->cra_alignmask;
>  }
>  
> +static inline u32 crypto_tfm_alg_get_flags(struct crypto_tfm *tfm)

I would vote for Herbert's proposal for the helper name and function (see his comment to patch 5/6).

> +{
> +	return tfm->__crt_alg->cra_flags;
> +}
> +
>  static inline u32 crypto_tfm_get_flags(struct crypto_tfm *tfm)
>  {
>  	return tfm->crt_flags;

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

