Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7DE32B9A1;
	Tue, 18 Aug 2026 07:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787039385; cv=none; b=A++owjPmwHNmzaAoQ37JPjMntVzpZtly7dcMsezbk30xteztVhQgFCBwTlbM0i+uIilyYj0CnoNaX9LHpxHaDUarT7397/45/rHHsWEN32vZ5yrAw3seIn4lo2vTQUK7bfLu07D7+yq+LE71IHzb04pjTdkPmLj7U8+I0A5YsQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787039385; c=relaxed/simple;
	bh=SU25jOfSiWnD+xRHltQrTbW8Y+1WTRull2JGIVz13S4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tESHjlpHGP6ZHSKP1pkWqfs046XCg+ce1ebK0zZeF4RoJJR69Tm1V05cjpeX7aUCzZmROoGu6mgQmjAxm3xkd4Nuk+HCC1V6mmnxEs5aaa9O0tBqQOm0+veVFmhvoDQh2IHi6WOubQx3PREKoNL81/ghna3X9aAu4s/DgHCCCDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Jsv4NV2m; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Jsv4NV2m"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HM1nDx2625114;
	Tue, 18 Aug 2026 07:49:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Rs8xqe
	3sdJkAOPogN/8HeNEz0zw64uOqL2oyCiVorJI=; b=Jsv4NV2mcLk6swpK6gaFFq
	JT4S/0omNV8Xpzz6lSEh5tbSAL9wKHKH/8or6it0lAWHNeTg/ylb+/mqecgIpIWh
	hTNIUysbVCYm4QclA+u0P3uWVRNVbLgjinem6L8t6bTm1VgHhoiyp93iwRQ7VFGT
	2QhH+BHSa9apMPpmKlFmqZ3htqzKLX23u069sq4GuBUVT2KUPssKJHA36jHPtaMF
	4/79kKe5GbnUiEJPKi9nEq5G8pWm2vgV/nhTS7C/4VKW5+t4qiPKRR9QEUitl0VO
	KLJo/gUcj2bxQfvR8R4mnEvBaHuaBQdak4kJUTXsQynE6UFv7o3NDIIkZKzdKrlw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fu4puex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 07:49:43 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67I7fLLv011570;
	Tue, 18 Aug 2026 07:49:42 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33xh20yh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 07:49:42 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67I7ncHG32899400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 07:49:38 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28AD320043;
	Tue, 18 Aug 2026 07:49:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EF63420040;
	Tue, 18 Aug 2026 07:49:37 +0000 (GMT)
Received: from [9.224.91.220] (unknown [9.224.91.220])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Aug 2026 07:49:37 +0000 (GMT)
Message-ID: <8fd6af9c-6e4e-4b13-8499-786576208df2@linux.ibm.com>
Date: Tue, 18 Aug 2026 09:49:37 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] s390/crypto: Fix use of mutex in atomic context in
 PAES
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: fcallies@linux.ibm.com, ifranzki@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
References: <20260817141654.77940-1-freude@linux.ibm.com>
 <20260817141654.77940-4-freude@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260817141654.77940-4-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GJIF52f3MkhUJNxT09zXHW3BEjy-WFOL
X-Authority-Analysis: v=2.4 cv=NLLlPU6g c=1 sm=1 tr=0 ts=6a840e97 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=tge1r-VoQCY2V-tqNwcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDA1NSBTYWx0ZWRfX3WmZVI8/1+96
 +mU9IAsTAsGDsfZBwpbUxoabDG3qQYe2bUfgJu/rdnE2Qjs7ynDrgI68JFko+OtsIFIXkFzzmHd
 D7FL9r9dwb4wAtlhnt6SunNQwZst5lw=
X-Proofpoint-ORIG-GUID: GJIF52f3MkhUJNxT09zXHW3BEjy-WFOL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDA1NSBTYWx0ZWRfX0hfUNv4N21qm
 JOiDGWvTP/H9p1w/s8kTN/UvXMlUq3b5Rct/FqGuWIqmMXknZSDo+aowIVfBwhV6KxabGbbzq8s
 sSBKG0Ohr1rR5iYGxg2JLJnNRkUyjMBO7tl6MO7UdugYxTjzs7iL4E8Hr65KouCb/crl2iNZP2k
 jLAs+pHjw1mNEScuCempTaLmcYa+HgyKsg4eL3p1FovZUq9hkkw4bpbZse8/YSroRj3v0VIxIHO
 Dv8n4PEekEP+JZ3P1IVBw7iNeSMHia9utkHoU5Z2p1O7zqv0pKBsOxDxu8AHXJmTa/0CkWiMdQP
 qUBJvMnFCTRj3YP/WYCfvVsr10hUonvB2LlofZLWu1C2d86saIkGJ+nXaDhyywD8lH6kOyLEKCR
 j0QLNyXJkrriXZU8csjJm0jw3qotQUfbk/lBuPdhrMOoMz5ABSzIVlZiFvc5BKuNpMaSjhjwdlH
 NG01oPsb3q3kMqIaqXQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608180055

On 8/17/26 16:16, Harald Freudenberger wrote:
> The PAES CTR implementation used a mutex to lock one page of exclusive
> memory for fast CTR processing. Unfortunately a mutex is not save to
> use in atomic or interrupt context. So use a binary semaphore instead
> which is save to use in such environments.
> 
> Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Cc: stable@vger.kernel.org # 6.16+

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

