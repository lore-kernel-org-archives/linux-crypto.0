Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF1925D1E1;
	Mon, 24 Mar 2025 07:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742802629; cv=none; b=IStjyHMc+yanaQqifuCv9zJuBtFFZ4cvfKuJYpuhfi2AmCjrJcoQ6FKk6OsSCDkSGlXF+Hep6dlVnkAeravdSr/EjaN79etvvxcHS1WFYySx/2LeomUucSviB48VrfuVbpW9D6Y25/+JjtD548bCNJSKZjjfxDsCXDOQe2Vpamk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742802629; c=relaxed/simple;
	bh=YTA5qOwXxRgwOPzOuK+lPUfthDkjJNu0amthMUsLyqA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HvCXBpfCMF3deDlx9jm/x0FnnYCVslN8blRN2CdYw/BjZL7mIMTt9pWHwU0esOauDwF6GtVWIZKpCYRHdVznmnKy+jkkusG7rjda9sB/IpIJFuL3JFtH8fxEWqhHng0OZtF0ZLYwPmEYbiBrpG52zxl5Eais1pqQNh8VQCPM0q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lZu0UkuI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lZu0UkuI"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52NKaAQB029937;
	Mon, 24 Mar 2025 07:50:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=qyqZBq
	a+j3fytxjPqh/XteT2d2TmwLLA0E7y7Z3b5+0=; b=lZu0UkuIMeTfrRfBG/Atel
	0MtI/o5D8/6GxjKEjN++UpGXLGVMKooSKu7KMpD/egeaHMMc6+jKZjbdJX6Iej+L
	fkntQcvU6IXyIvLMt2KSFBA+UTN29hnDRbin4yBAvvGmDN/qBy3gDHsqkFDJzmV3
	PTxq7TjxP24w4W1nArYl5DxFqBm7ELddER8eZatrVxDAy4oB9zavK68t+luDtG62
	ZJ5M4n5Wqughop6F9LgEufpB6OSqBdw4WvJaxGOLa3m4BZI6PbG1ooSCZOQVrdx2
	0dk1eGdmZ3xYulcNgutJxqlB3taHfin5IM1r06pgv4FVOH4xmLr2R/RQ5442LjhQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45jsfpa38x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Mar 2025 07:50:24 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52O7FE1u030308;
	Mon, 24 Mar 2025 07:50:23 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45j7ht5dnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Mar 2025 07:50:23 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52O7oLFq37618088
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Mar 2025 07:50:22 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D63DB20043;
	Mon, 24 Mar 2025 07:50:21 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CF3A20040;
	Mon, 24 Mar 2025 07:50:21 +0000 (GMT)
Received: from [9.171.66.77] (unknown [9.171.66.77])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Mar 2025 07:50:21 +0000 (GMT)
Message-ID: <b7bf79e9-9b75-462c-9c25-71dbc708760d@linux.ibm.com>
Date: Mon, 24 Mar 2025 08:50:21 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: s390 hmac
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <Z-AJFwndherQBH2W@gondor.apana.org.au>
Content-Language: de-DE, en-US
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <Z-AJFwndherQBH2W@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: r8LpRDNuZ-d2lfk8RlW_ZPpW5CvEbbeI
X-Proofpoint-GUID: r8LpRDNuZ-d2lfk8RlW_ZPpW5CvEbbeI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-24_03,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 clxscore=1011 suspectscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503240053

Hi Herbert,

On 23/03/2025 14:13, Herbert Xu wrote:
> Hi Harald:
> 
> I'm working on making the export format of hash algorithms compatible
> so that you can switch between implementations seamlessly.
> 
> I've got a question about the s390 hmac implementation.  How does
> the hardware tell if it's the first update (where the cv from the
> param block contains undefined state) or not? Is it a bit in
> s390_kmac_gr0 or is it the imbl?

The bit s390_kmac_gr0.ikp indicates, if the instruction has processed the inner key padding or not. The bit is zeroed at init() and the first instruction call for a context will set this bit to 1 and update the cv. So, if this bit is 0, the cv in param block contains undefined state.

> 
> Thanks,

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

