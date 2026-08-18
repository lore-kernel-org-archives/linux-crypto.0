Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A583FDBE8;
	Tue, 18 Aug 2026 07:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787039648; cv=none; b=UefHtLFtq4q2V5wt7hQM+EFfU529yK5ePiT04ISPYXRYvbhkQ9vyW9Nnd4l33ldl4YMOMxwTmk90SVkZcTcEJyRRPwodIul88hAhmYwS6L26waBg3rry31+9I1u5qfHbIzbdHOcHZD2v2MBXUyXdVy+7FfmB8xZepWZm+ibs6nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787039648; c=relaxed/simple;
	bh=XvSnb04kCeuiA1+WkHGMs9b/GeSBRMLnvE4wDSaPmFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jr5PMYQ8o/I4YfP3sKXfNzcu9wolbVo5Im2e+wvgQgok0RtjQbHMMkVy/lv1fFD5YP2oxNpZcRXMaCfgMQKxH8np+0xMoqcOkWqj5af3xtI952xLPPInWkJqB5N98Pxe476jbFl45h+o9Be/bVpzYY+maNtC1ArU5JUXp/9nIiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=b8bdo3sQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="b8bdo3sQ"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HM1kHZ1515085;
	Tue, 18 Aug 2026 07:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cD3j3R
	jllSvp4TiUcomCDG9EyqvW2b1VBuPm8BmuqIg=; b=b8bdo3sQ5+pd5nkpZFcsIf
	X9vPWosnfhsFQJ4WM+rIfcL3fud55YSsI1aXNJYh06bgAP4QRlADlLa8LcvYOJPI
	lmXI21xqr34KhVE7FR04N5ScH33z/MAw4w3wJzJuKmBAwwI8rMYshpoosFO4lUCM
	/dxsd2D9H31AurNEQaUl9IPeXrvk/N1ZMLeODB5Jsvc2kyT+357YWdlISDhZQCxT
	+EM6IkahleVDMl9MtyW8J37Rz8ozXo1AC9UEuvFnRhcCoK5WKzjNrGOWrOZt6Ug7
	X0n9d3uHsL9xSqxo3A+qOCtpj7VH5zTraUk5ZCcSIauuUxRncgn6LFQ+S3F3yw7w
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2ehe6hdv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 07:54:05 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67I7fMp5011578;
	Tue, 18 Aug 2026 07:54:05 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33xh21dg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 07:54:04 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67I7s1jJ52363646
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 07:54:01 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F3AC020043;
	Tue, 18 Aug 2026 07:54:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C08C420040;
	Tue, 18 Aug 2026 07:54:00 +0000 (GMT)
Received: from [9.224.91.220] (unknown [9.224.91.220])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Aug 2026 07:54:00 +0000 (GMT)
Message-ID: <0521d42e-7945-4eb1-b8cd-5e8380b2fa9e@linux.ibm.com>
Date: Tue, 18 Aug 2026 09:54:00 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] s390/crypto: Fix missing cra_flags in paes_s390
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: fcallies@linux.ibm.com, ifranzki@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
References: <20260817141654.77940-1-freude@linux.ibm.com>
 <20260817141654.77940-5-freude@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260817141654.77940-5-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDA1NSBTYWx0ZWRfX0qlLk41vVxFN
 xTdiMGaJQ1qiZ+B2JRzFWL6Z0y1TKBPjETvOzlxLcDudcqf2FmET3l5a9S05xQgyPqwrDf1dQtJ
 oBD/Xmgdeu6tRKhF7Rk5db3vM4FdtiDWNTaKTO3PCr7d8l9SwsBjVTpE0H+J3IUzpXJgERmfe4l
 bAvqxRx0NJcF48j36IWG3fDU4nH64nBQf/iMVg3e+xtHyKR8KFQR8wEsaAG6lfewI5tSdZExopa
 5w2DUWCv1LB1VNoHiMCBgvaKkNUCTUiknDbLjSkxjbQmCOvr9bxu+JCxMPdSbZFYWA/u0lfHl74
 CqwuPSKoKKTvX1LFXAPamQBQQDePI5PX90JD8Qi1eqdgberXmQSxkvIZ2fz8gU/ZtluvawZfs0G
 O6sU/VbAFJeYHvYqWgPuWXxwr6WiQilwgZjfSukxlJuWI3tC3VyZfplhzoBRWTUaf1dz0MZkwkC
 m0P94Yz/Rfrl9EKvm2w==
X-Authority-Analysis: v=2.4 cv=DY8nbPtW c=1 sm=1 tr=0 ts=6a840f9d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=_d3cljRNzoOdLoMPedgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: f9mzCeD6mIdz7mf6UzmyfCPtRwpSyrSA
X-Proofpoint-GUID: f9mzCeD6mIdz7mf6UzmyfCPtRwpSyrSA
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDA1NSBTYWx0ZWRfXyVm21eqxKkCP
 BnNoVOURtRKdE1GwDshtuW+MFCnaS5K2QyQZCvC70T2x+RRCDqJ5q5eLgtavaWXHfaBVXIao3lh
 Unw3q2Cgf6rUdYvPkxZR55aREC97fKU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 spamscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608180055

On 8/17/26 16:16, Harald Freudenberger wrote:
> The 4 algorithms implemented in paes_s390 never had any cra_flags
> set. So add code which sets the cra_flag to CRYPTO_ALG_ASYNC and
> CRYPTO_ALG_NO_FALLBACK.
> 
> Fixes: 4ccd065a69df ("crypto: ahash - Add support for drivers with no fallback")
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Cc: stable@vger.kernel.org # 6.17+

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

