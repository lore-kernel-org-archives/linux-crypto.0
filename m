Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD5570838;
	Wed, 14 May 2025 08:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747212025; cv=none; b=XKFKpOTxkNOajwAZP0NFmXX/qZU+GSKqyCf1NoGG1dYuoD4n+xZt64Pqn2bwKygushPpQbn/HPcmx+7jqRXanw5RdEMQwJAYrL/aPixf5b2WVaQJ/YZ+1E36H9dAFjPPPRrL81NTzAnVOm3lm5oUI5aBTU9/xYUwxDnbm+GKiRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747212025; c=relaxed/simple;
	bh=/vjTh32LIaKC7B/B5g4Z9Pnush1J1/skGCho2wFNgMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t5Wu1WhHmawO3f8krAiz0+wiUOHHlQQbOCoq+RoinzyP/ZETlDfAmFWoIdzqFAVkoywRODDCxGtiFZioHQI8TS22/l/UvnVpkg1mIxppYoH3fcD5yn9G7JLAw2wh41IFaaRcAjyA8zDhp2svIJX68BQxD2d6uuKUiGFpmecF/bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZMbkviBT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZMbkviBT"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E75TnS025383;
	Wed, 14 May 2025 08:40:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AOFqlK
	ixQIh+C+X7cWieRXyoKw62N/2BHOA3hej/Tpk=; b=ZMbkviBTwlJ21NR0Zrk76W
	zsAHaLBAqQWLtqahuLbhsuV5fjpog0b0/5EPq95/8lFx4qH7WX+vaA3fFPMXTGR+
	zAbNmHkklU6kwHFOVGuMlFjAYq6vjfEGHyOFZlF6KzZWXT+KHVL6QINRpi3M3s7A
	ugwUmrQnGtqWyhy9Q+khyQtlJZeFI1+13hZY72b4/QFXsUUV9H9QshadGVLWWOV6
	L+caJQ0XuY1UrgQbRlYwUEWaSgZS+AaFRF/rIfBdEVtZ4cb/P0oivi9LJLP8IjgH
	omDExCsEWJxR/+AcL2c3OMFiqBkowdXC0t51n1Qn9mXM0mgQ962Beq61f+Y8G4Qg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mbs6k21b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 08:40:20 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54E66E7o026939;
	Wed, 14 May 2025 08:40:19 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46mbfpb7yg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 08:40:19 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54E8eG6L31458028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 08:40:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 30A64200EC;
	Wed, 14 May 2025 08:40:16 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8163200EB;
	Wed, 14 May 2025 08:40:15 +0000 (GMT)
Received: from [9.111.42.183] (unknown [9.111.42.183])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 May 2025 08:40:15 +0000 (GMT)
Message-ID: <1ba53553-8d13-4894-a343-08c1dab3ed53@linux.ibm.com>
Date: Wed, 14 May 2025 10:40:13 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] Documentation: crypto_engine: Update and extend
 crypto engine doc
To: Harald Freudenberger <freude@linux.ibm.com>, herbert@gondor.apana.org.au,
        ifranzki@linux.ibm.com, fcallies@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
References: <20250509102402.27287-1-freude@linux.ibm.com>
 <20250509102402.27287-4-freude@linux.ibm.com>
Content-Language: de-DE
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20250509102402.27287-4-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA3NCBTYWx0ZWRfX24p/1VkK4TdX BaI2Kkn05hOrAj5M8uFOgZRFyiNAjK9Vx46xyQPyTAMk79nOvCv1Kf/jjzPYcSYrO1cQhAk/nvy s5atW69AShyRhOVtjvsfmG/Adc74IM7ilYT3LravT2AOpZcyvQi7MW55w9souL1AjE1y/0CmXGw
 CKfAaM7JLsAjKaSiS8WzNkYeeVYA3iS7VGzuR6c4D775fXXNN9UvtMpwbBfhMV23znqIxS2gjiS 7dZMPYMCzjv7xUpzJYmNPRD3Vi01qpH8w7mj0nI96cLbEfGymIFg+R3ctVcWqSRUCjBtSU7FLJ/ ujB7XzbRQAk89BKBGoLr0f3tRalc5fQyBxf3Kj6IXsmWW0QjI6LpNeCFYTNIaxS4UqRb8PRdGIB
 2beuzXWwkXX4bv4cZTBk3kw4c30so7ZQMhkEukyBRxkRsRDYCkHo0ZZXSJ1WSg7axRWh14hY
X-Proofpoint-ORIG-GUID: q5n65fZEOUUoAHAAcVNypTO3Fgr0JTpz
X-Authority-Analysis: v=2.4 cv=d5f1yQjE c=1 sm=1 tr=0 ts=682456f4 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=w4HzK-rsqA_2YikTyBoA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: q5n65fZEOUUoAHAAcVNypTO3Fgr0JTpz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_02,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 mlxlogscore=805 impostorscore=0 adultscore=0 phishscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140074

On 09/05/2025 12:24, Harald Freudenberger wrote:
> Remove outdated wording about crypto engine context.
> Rephrase and extend the usage of the crypto engine.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>

Acked-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

