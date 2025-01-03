Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F291BEF93;
	Fri,  3 Jan 2025 09:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735896176; cv=none; b=k7V286ZXGjzlVBiiUzVxQOpXq3pJ7ekoOTAMEUTOeAEiSq/KO2KwEP8dzeAxAWJqqLWsK+kBoMgLLxZBiYUb/uOHN4nj4sY2ejWN5PbJtRe/xnkqMlbKXCDHOKMYP+I2Gh/1q9aD333GXqmYABKP84FK+HGYYzl7bBiYHRtrguI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735896176; c=relaxed/simple;
	bh=uiKl3dS6OGrLjOcwOMUe9Q48MhDxG/8ZOjHm6Cbowb8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T5IG9V7Vx8YTJEHpMehcpXTant/Eh6O5PphLijdg7rXfNzU7WEVdUvGrtcQuP9TKlFccfhIFE8QCZIM1o6372Fgu9xSyk+MpKC17sgkS4Fx69Q8qbD8n+a+RjZCZXrwRxBuJaIRr7VHf9edi8YNkFv50K7S7D8LvQZgJcKmVV+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=R4FKj6Xz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="R4FKj6Xz"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5036Y33r005488;
	Fri, 3 Jan 2025 09:22:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0LtTGE
	+ru0EnfXE4JU0KFFu7vWnIxdTJGBxB6kEsc50=; b=R4FKj6XzhI++zpRBBzL5mW
	aeb4c17eJX3AZarlSeKT+i9vwH4MGCt/nm3tlSvJb1fwPUMAohI9LReaPvswg1K5
	rArZ1t1klAUOcHXA/EjCzppm+FaZu+huWfZK8jgDYjwRDzO5p+Fa7u/zdrFdMdyZ
	G5IwPvm5+6iX5R2Xd3ylhLjlViVT3tzmGirQU4/Kh14zoGnaStBDOX6b6A50Zez5
	qTRRVn4a31k4YtU9bKvvDPBR1eG4tl7A4SM2Oml3Op6/8FbHcSaA2DFT8wZB1tO4
	5qQkVMlqTqqquWL7O+hBjX6pOC6sfq8wYnQGI7L0kpJyd+9WLSDSv0aBqqOG/ooA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43wv94uedk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Jan 2025 09:22:49 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5034xEg7014595;
	Fri, 3 Jan 2025 09:22:48 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 43tunswvf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Jan 2025 09:22:48 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5039Mkqr14025192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Jan 2025 09:22:46 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B73592004B;
	Fri,  3 Jan 2025 09:22:46 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 765FA20043;
	Fri,  3 Jan 2025 09:22:46 +0000 (GMT)
Received: from [9.179.12.171] (unknown [9.179.12.171])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Jan 2025 09:22:46 +0000 (GMT)
Message-ID: <be093e96-aef8-4ec1-a9cb-b08146bc4f6a@linux.ibm.com>
Date: Fri, 3 Jan 2025 10:22:46 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/3] s390/crypto: New s390 specific protected key hash
 phmac
To: Harald Freudenberger <freude@linux.ibm.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20250102094615.99181-1-freude@linux.ibm.com>
 <20250102094615.99181-3-freude@linux.ibm.com>
Content-Language: de-DE
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20250102094615.99181-3-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HNdXdYdwD4Jzq72bjik_Kz_our9beGcX
X-Proofpoint-GUID: HNdXdYdwD4Jzq72bjik_Kz_our9beGcX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=636 suspectscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501030078

On 02/01/2025 10:46, Harald Freudenberger wrote:
> Add support for protected key hmac ("phmac") for s390 arch.
> 
> With the latest machine generation there is now support for
> protected key (that is a key wrapped by a master key stored
> in firmware) hmac for sha2 (sha224, sha256, sha384 and sha512)
> for the s390 specific CPACF instruction kmac.
> 
> This patch adds support via 4 new ahashes registered as
> phmac(sha224), phmac(sha256), phmac(sha384) and phmac(sha512).
> 
> Co-developed-by: Holger Dengler <dengler@linux.ibm.com>

Please also add my S-o-b.
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>

> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
[...]

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

