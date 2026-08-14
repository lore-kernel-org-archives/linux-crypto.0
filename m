Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FD63009CB;
	Fri, 14 Aug 2026 13:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786713710; cv=none; b=up+qwWST2uNS2mU3Wt44Idjb2BkFjcCB+dGFumg9CkwT8JYO5X/zzPrMhOeIO6C8FZ1LrBTBoUTRbqnF7Hon52wNhszlbhHtyeXmH2nYxeHxyhCaSHGZJUXmVcWbk2hanxu9vmgiSFY8zKW0seDztm5Cl5RxngFy0mopxKbmgGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786713710; c=relaxed/simple;
	bh=/xZZIuRa0DvdRtE1PjONAUv31uMwbnQvur75RittiBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cLHAsavHZhgNblEkdasAxyTlI1Q/bsDnV8vo2jU6cZ1Iu6ltGH/ChZAkvzD1BmF+LxYpW4xBpCkx/9kIkPTJN5mOKiMf7iuV3YjHeqvcxxnmGGuCJsqmifP6Dp8G7YkoPd4y/58eYfUbTj0aTfarXKbNlL60NPVK91UNAgN/YkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ytmg//ny; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ytmg//ny"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EB1wUd3274170;
	Fri, 14 Aug 2026 13:21:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Jvd+gJ
	xO5v4BSZWz6EpGQ97sUvt8EAaAZKp//hRrVPY=; b=Ytmg//nyW8u+2MLt3JwGPC
	TD2PPFUFcI6t7E570S0PRB92HubMcDMTMuTZ0p8imfZGozdUyHA3QBbdYQKrYKkk
	Z3IMivF0rjOIMXXu62l8jKn+OZnLEBoiUbzbvutLUFPgUqmf+F74+qSD2KCVRDvw
	1gZ+KaG1cYJKFPkpE3yJ1anfiV32CpbQnnExBIAni3VVUtpWVVcyi1M4ArI/sevt
	kj9wjeXrorLwcFEfLTpckeHAyL9ZZP1JPeS+ZG3dkKa3l9XNg7+g4gK7vzkITGPf
	K8T6jro4d+yX3i6cd2uSG1mb2a0FRYN00IwlVp1/+zaSyb1QH40+1dRqxN2kEAyw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvk0cwj0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 13:21:48 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67EDBH8Y023521;
	Fri, 14 Aug 2026 13:21:48 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g1rpva57b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 13:21:47 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67EDLhkX39911814
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 13:21:44 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D3A6620043;
	Fri, 14 Aug 2026 13:21:43 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A38120040;
	Fri, 14 Aug 2026 13:21:43 +0000 (GMT)
Received: from [9.111.74.75] (unknown [9.111.74.75])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 13:21:43 +0000 (GMT)
Message-ID: <3a21be7a-3377-4a45-b802-266fa8bd2a1b@linux.ibm.com>
Date: Fri, 14 Aug 2026 15:21:43 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] s390/crypto: Fix use of mutex in atomic context
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: fcallies@linux.ibm.com, ifranzki@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
References: <20260814123711.61145-1-freude@linux.ibm.com>
 <20260814123711.61145-4-freude@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260814123711.61145-4-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDA5OSBTYWx0ZWRfX6kUBoYbVfNnx
 qE50FbkFLCPQMwcgXIMGLPQ8JC/0b6MSWXU59Ot+jHHZX+0mbN1lVw+jpLC00bvPFd8MV7Dudob
 +ePzgQaks/WXCHYRIt+ICcD56BKIvX1OLWcGQQj1KXzhiP9XtktbsZqGDzZPfcIjTRFy4zfiX0+
 81dwOlIQOxKMD59U1ChQnFXIsytE5kxRWfV9XB8yAscdAQfoSV4NYGlMAOrGIALXPazYHcv9K/6
 5lY7tP9vIiEYM155Nl6P3BUV2bNupnrg6uTGpFJhTuT4jWO6all+q9pcmvRHxt35YX3Y2rrdfR2
 S8rx5lduLNxcFhnQiJCAmdo///zuSpI0uZNr0o0mkg4gm9KbC+2NVnYctNQOC4y0iuprhZKu5NF
 UZxV6c2Pq9aZ31OL/bFNok02FTQP/SnropiebtFUTYmz4cFT5LnpLCkzrqQwMM0zOtxrBZTIXNv
 LJBvEQy8bujX404vwEA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDA5OSBTYWx0ZWRfX2G/3zciVhi0/
 WbNWzTHeBTpPthnujTQGUqkLBA4vryGHBJBEwFoksJId50Dvt9CDKlbkMz4fsfck6dNyVjrqCtS
 xoIliiNmjNYLY1jU7DAqCkx5z5TWvIs=
X-Authority-Analysis: v=2.4 cv=RqD16imK c=1 sm=1 tr=0 ts=6a7f166c cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=tge1r-VoQCY2V-tqNwcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: xt5foZkkSUnxBGLpbi8lvsIQNtayYfRN
X-Proofpoint-ORIG-GUID: xt5foZkkSUnxBGLpbi8lvsIQNtayYfRN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608140099

On 8/14/26 14:37, Harald Freudenberger wrote:
> The AES CTR implementation used a mutex to lock one page of exclusive
> memory for fast CTR processing. Unfortunately a mutex is not save to
> use in atomic or interrupt context. So use a binary semaphore instead
> which is save to use in such environments.
> 
> Fixes: 7988fb2c03c8 ("crypto: s390/aes - convert to skcipher API")
> Suggested-by: Heiko Carstens <hca@linux.ibm.com>
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Cc: stable@vger.kernel.org # 5.5+

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

