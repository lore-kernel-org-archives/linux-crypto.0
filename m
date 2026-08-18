Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACC14B048C;
	Tue, 18 Aug 2026 07:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787037108; cv=none; b=O4G8w3HvPe/mN/mQjwUtgvs6vTk2LqR2JwuDtTphhG3ncR+16bBUTtMCdEbr8pMsagIBwuTqXHjJfF8FJFMTjNzEK/OKdh/o/vydYRZr1MYc7pcB43zU4lYS2kqIP7kkWHejo6hCRGDRTrb4PwsF2z7o5KcWWR9xnS1Es6iGSWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787037108; c=relaxed/simple;
	bh=J7ACfF6RypKB13iQCO82k0NWpsRWhh7YMW1/jcG1xkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uGkqyh9nNJ798tMdOhS7t7KLjjiZOCzWwVeTgr1S6h16O/OMW7VmRQ27lUXd3XU+m0r2UEhSmyyhSrdgI4gI4hdmINxje5GBghw7VA7R5l2L2fL7iErr2G/o1ppuxulfnYTA70euaGb0FX9I0EnhujvSD1O5KZHj6fbEucbNvBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=npeEkTwY; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="npeEkTwY"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HM1WUM758632;
	Tue, 18 Aug 2026 07:11:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=dnD2eY
	GRY06SEFxEmVSmqU1vYcLVXwx6S++ATCDN53A=; b=npeEkTwY6P7SJ0CNF4eLLA
	zZY60ac++RMLwN7k/huT2Q0Zm6hsoCyU0DtmLPGN/IGmGmz/seiqxEAUqqXGijdZ
	7GMJDqjuVMnE/k2hBidzXQwdZnNljKZ/ENmpXn4hsdBHE2wQ6vj1JLCrCkxZ7Eip
	2479FT/VjGsCYgT4uneSc6uLoVxwwHGh1FZ1GeKkW0sBAJiSEtrRbSAnfJuTlbXJ
	34pFZCTa6OjKO6CahHm5Sr0bP4W/UeaUQREjcPqPJTKn2Wh/5q/YdY3GdhJ7sMcf
	ch3sAmWzZeEiFlzXXONFcvPs20emuDLVcMvWOIjC70dqkTurfYECURhyaYd48E3A
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fsqpmxf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 07:11:46 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67I7BN6g015186;
	Tue, 18 Aug 2026 07:11:45 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g354y9nqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 07:11:45 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67I7Bfwf42402094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 07:11:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB3DF20043;
	Tue, 18 Aug 2026 07:11:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A11920040;
	Tue, 18 Aug 2026 07:11:41 +0000 (GMT)
Received: from [9.224.91.220] (unknown [9.224.91.220])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Aug 2026 07:11:41 +0000 (GMT)
Message-ID: <70657af2-a5ef-4d09-be35-37fd6f4a9f67@linux.ibm.com>
Date: Tue, 18 Aug 2026 09:11:41 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] s390/crypto: Fix return code handling at
 skcipher_walk_done in PAES algorithms
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: fcallies@linux.ibm.com, ifranzki@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
References: <20260817141654.77940-1-freude@linux.ibm.com>
 <20260817141654.77940-2-freude@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US, de-DE
In-Reply-To: <20260817141654.77940-2-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDA1MSBTYWx0ZWRfX0cYAquRxSOnq
 qSmH1BiVXY9rwozh+zUM+p91jk+doCQoHcsrUMZsZaTKKsrfyaJYh4h5tI7eTKvZTji3xXyypeB
 VpzJ7vsvVIIJjmuuFlaS8h5XM3+LJAf97bgh8kZoHftKkqTg5NLDdr7sRu2fWAMY3p+KCNDqGwm
 Iqk/gVJikGwKHwjGFiGewspB3CehTY5nfZ40sOLKKGVPbErmZDb/nGqh+/GLg8UC37FzV0g91wg
 jSCleGTHibrUicOEZZyaNDk4JxgMGBoEMMAwkN3H+3VXSZw1zzqRSC6JkbDvI6gleOHDJe2aUfY
 rHPP/KatSQ5y/ORoXf5YMLNS6/fhwKVrSz2xfKRS0fO6C+WaX8vdJgh7vQ3ZjCHOWYLJzAHR2TZ
 LJblcR+HAfVE0gBrI5ZtCzx+dt+h1VWvOukCO0D761ApOptN097VYPpQx+wmeeE1nZj/9xQX4NN
 zsp0oCcbFRwZQnW0RZQ==
X-Proofpoint-ORIG-GUID: DaWreHJ_581a-knkw2x6MMZcPy0y1hLH
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDA1MSBTYWx0ZWRfX8IyXAmtJ7v0c
 QX6evTSf6P/td31FIFVV+VQ8W7xgLhP2P4cfd8kCeaiwYhtaz/v6BUC1K9i1LyUhOzhdATqwHlz
 rA7D2TudTkpsm6DpQgqgQkdhIbBRG2A=
X-Authority-Analysis: v=2.4 cv=DJe/JSNb c=1 sm=1 tr=0 ts=6a8405b2 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=mGMtxAEF_H-nh_TH674A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: DaWreHJ_581a-knkw2x6MMZcPy0y1hLH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608180051

On 8/17/26 16:16, Harald Freudenberger wrote:
> All the 4 PAES cipher processing loops were not checking the return
> value of skcipher_walk_done() immediately after calling it. This could
> lead to error masking when both the walk operation failed and a
> subsequent key conversion was needed (k < n condition).
> 
> Add immediate error checks after skcipher_walk_done() in all main
> processing loops (ECB, CBC, CTR, XTS modes) to ensure walk errors are
> properly propagated and not masked by subsequent operations.
> 
> With that comes a slight rework around the skcipher_walk_done()
> invocation. It is now necessary to check if the walk has already been
> finalized (walk->nbytes is then 0) or not to avoid double
> de-allocation of resources held by the walk.
> 
> Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Cc: stable@vger.kernel.org # 6.16+

Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler

