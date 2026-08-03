Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F387402B8F;
	Mon,  3 Aug 2026 11:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785756940; cv=none; b=UMigM3V28KmnYEEnHE4U39TsDI0cUIZWDgxlutKb4nxHT0KTa/Z4bY/Fv9MRdR5OU754AkbqMoFTZ/DjCgyZjGkjpVyBfXRL8jc5+CqPLhUoLzj08WgwaqqcWyPGNDa9UU9Wrybs2DcNacfXIFUhfwD7h0xIcjkzJATHwP3QnfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785756940; c=relaxed/simple;
	bh=0W4xU/Zt4wxerYDPdGszSIOr3mWyBB/NAN07IyYSZOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+1nUUNk9eHI1h5E3Eal3DqZm+6lK/MbCbKU2FNO73Hyt5aroJszgBF/Y21T4zg6Jm8ohEVhvZj9LOn+8pogP7ANb3EpIdzv52r4oE+ymejifO0lTmIY10mXkH7z7V4R0lFiwboSmp3jbxYBgDXv7akaHYC0rtEGBRXjoEBuwYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CX0mBN68; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CX0mBN68"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672Llloh159860;
	Mon, 3 Aug 2026 11:35:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=78juEHzstpBekaD9ScfeGc5nvzNB2b
	6WJQs8UNFwsRo=; b=CX0mBN68J4oCSChQfqU4QeccFQXlhJWMluUB1H9I+GqvDq
	jY41/XvDAw7riVmF2Ug++vWE7ADsLMn/TnY8HhHvBM3T2fwakQTkR8a7vstarcek
	XCiQHOV18541QlJmKHU3jVGJxlc062ZBuXC2nlgzEJn1BrkjfgJmiEl+B/LsMDrD
	qs23aynYuwks9gk47UGZ0w2BoOqY8t9LRbicAGBhwyPQVTNLGAHKeeetkCAlnKWE
	/oazjEi3QBJk5xCVYGFO0qvRXj87Tlq+nj0heYyFONQ0ZolPHqZejh3DxIl2kDsM
	+fhxuHq18Zp2FPE6TdF01jhFJbFvwLm55uJQanCA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs67hgejf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 11:35:27 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 673BBIS0001123;
	Mon, 3 Aug 2026 11:35:26 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswbg4x99-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 11:35:26 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 673BZMm648103688
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Aug 2026 11:35:22 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C6F62004B;
	Mon,  3 Aug 2026 11:35:22 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 020CC20043;
	Mon,  3 Aug 2026 11:35:22 +0000 (GMT)
Received: from localhost (unknown [9.87.133.185])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  3 Aug 2026 11:35:21 +0000 (GMT)
Date: Mon, 3 Aug 2026 13:35:20 +0200
From: Vasily Gorbik <gor@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 3/4] s390: Remove cond_resched() calls
Message-ID: <ttj6yuw@ub.hpns>
References: <20260731165004.2758105-1-hca@linux.ibm.com>
 <20260731165004.2758105-4-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260731165004.2758105-4-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDEwMSBTYWx0ZWRfX3o+owkVRY4Bf
 140QTrRnQ7G/xcAG25QVZw6Ib+mhLVUdDqbaBtKY9GuA91jESkiAoemGftgsV7HOsa4QVVUwrsx
 E/Y+lQZGV34dHa5WhWyLdaEJ1R09T9o=
X-Authority-Analysis: v=2.4 cv=I7VVgtgg c=1 sm=1 tr=0 ts=6a707cff cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=aT64lE-xtiG-fBwKLyoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDEwMSBTYWx0ZWRfX+1NnmsuQFeh7
 XDhm9anYF5XN0bfaxsU2+fDHT94fFaVTo4TZjUdD2BbbjqJq0QxmkjBYHKv+36aiF5Un/p9b2+y
 5OGa+NsakR+aTxPgsW21cv18hYl1pbsxXHUVnvwwj9fvp9ZoxGuHBN6Ju5CBw/FkFHNG5G9qiff
 kjTaJ6JOhM5q0oNwbYj03dSPV4IliD0l/sVEizSXHan8ChsiGOlSrLLbYar/IareuhpHsMiD6Qe
 IjaL32/JZ/A3nh6pXyxnkam3DwPFWyhMa9P2NAknUCcOeEf9EmX3QY48D0t7NrfDcsC7ENhJTvF
 ZYDAr/taLotuR3BF8iI09GcL4VELEG7mRXCwlZDGux++s5labyecAzYe9J28R78nvWmQQxUu72o
 d+Uxxxgyp4T9yMM/dRF5T79G5cjf1YeBqQkLAFrEc774w7eOGFemPhyJ+6PQkzOkOaOQcbf0JID
 SPR6gi/d5vHQoeaYXFA==
X-Proofpoint-ORIG-GUID: CI-uG5MkgplWTfo15vJw25FLg6DoC8pV
X-Proofpoint-GUID: CI-uG5MkgplWTfo15vJw25FLg6DoC8pV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 clxscore=1011 priorityscore=1501 suspectscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030101

On Fri, Jul 31, 2026 at 06:50:03PM +0200, Heiko Carstens wrote:
> Since [1] cond_resched() is a no-op on s390. Remove all calls.
> 
> [1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>  arch/s390/kernel/perf_cpum_cf.c | 1 -
>  arch/s390/mm/cmm.c              | 2 --
>  arch/s390/mm/pageattr.c         | 5 -----
>  arch/s390/mm/pgalloc.c          | 1 -
>  arch/s390/pci/pci.c             | 4 +---
>  5 files changed, 1 insertion(+), 12 deletions(-)

Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
