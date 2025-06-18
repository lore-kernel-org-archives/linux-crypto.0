Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C6A286D51;
	Wed, 18 Jun 2025 09:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750238490; cv=none; b=g//6TNC8+PucQshubiHRmaQQtX4LNQKY6dzXHTl9TCSSD0ylWXbhbB51mNO55QyZGeUp1s4VhbxUcJiUyRJREB385OayDVX4UymW44WG7JtOFQzW8sElJACy6JfQXH+/n6I1K4q7G3kB02CgLsMrKzVOOrk15UPi/FmmSCX/2+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750238490; c=relaxed/simple;
	bh=RGelcMrMqAXU3udZ6+V/2JchItUx0kQ5RE6eKRS71e8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ji4P/8vWweeVpat5wnbX01CjTQLU6BoCgZBs7NHh5/IJlVL0KHc578MGw6shZ9UwBI7hx6fgzspNGOShb/tW4FantVN7+kO8D0x6fstk0YBy1x7Ob/otfgV6w7zOlFNZ4CTWdMC/0M7S26NIAu91m0JiWd5deah/HX6yCbECOQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SurU4g+O; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SurU4g+O"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55I7cIRh016045;
	Wed, 18 Jun 2025 09:21:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+Jrlj0
	C9h4PPza2Vwc/ovUyjXArKuUKc90LSb1rLyfI=; b=SurU4g+OeC7Ei4/BDYI15c
	YY84sttsi8cG4V7csxBCnOE9D4Si0oLiz4QyrZxu8UM/goiIYk+r4GeBAYWjXsPJ
	tpTlyCHZFuX7EZlpIRAPJp6mVKedAjv3BWuGx8AX9BeOgGqH1IL3BL2+VaoNjc3r
	nLaLowZ5jjXbFoJqE1bRuVDuzK0pOVZ5Nt92hzqxDI9Ut7hfxvX6p3qEwWYwcoFP
	xs4lwE7j9PS6fnUYSqSaY+0qxZxFnsR6ECMBi1InRcug6O/kIgPqKrESOV3hycbd
	nGfoswJtPnJHoW8z0k0pv6CTFg08Pwx776LGk9TOyX77qTEmCwx+LT8PRGiFc8kA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4790te5wxm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 09:21:27 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55I8IO78025755;
	Wed, 18 Jun 2025 09:21:26 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 479xy5xad8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Jun 2025 09:21:26 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55I9LMVv19792324
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Jun 2025 09:21:22 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 788D42004E;
	Wed, 18 Jun 2025 09:21:22 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1AF0620040;
	Wed, 18 Jun 2025 09:21:22 +0000 (GMT)
Received: from [9.111.39.61] (unknown [9.111.39.61])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 18 Jun 2025 09:21:22 +0000 (GMT)
Message-ID: <cdccabb4-8b39-4261-ad89-9264844f253e@linux.ibm.com>
Date: Wed, 18 Jun 2025 11:21:21 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 3/6] s390/crypto: New s390 specific protected key hash
 phmac
To: Harald Freudenberger <freude@linux.ibm.com>, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        ifranzki@linux.ibm.com, fcallies@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com
References: <20250617134440.48000-1-freude@linux.ibm.com>
 <20250617134440.48000-4-freude@linux.ibm.com>
Content-Language: en-US
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20250617134440.48000-4-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Tf-giKkd_SciNa3RQi26McO-6Wu6cXpI
X-Proofpoint-GUID: Tf-giKkd_SciNa3RQi26McO-6Wu6cXpI
X-Authority-Analysis: v=2.4 cv=c92rQQ9l c=1 sm=1 tr=0 ts=68528517 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=tV9you1X9CY752Hip54A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE4MDA4MCBTYWx0ZWRfX460WYI+iHQkV T+nyUNkRGWd/BA4kA/k9hdBcvM+ymroSR9PWggtW5HX8qES5Hfu0zZnJ6zR3vCxJIXrd4pTIO3Q 3vrqWNxk8jAA57O6KJ9yFwBx6z/xhB4koxOxYqKTnhBcDh4DUmt9OfpoP73A2X4gjBA0mcw2lmo
 af16xqziWrFxwvK2YpMQdQ6FvDzkDJccxBbcLBJiO+XZyKR2JelHCQOtmVXgKwrhCijnUwZSjw6 dl8jv7jPL6NjfOVCOy+5Zn+S/F+/dAHg6BSAjdvWtekIWwpD7aUEoPAnitLayEX0Lud3MCP0Gsi 51tizigDKnlQ2FkXB/47m5a0UM+9GqUskuiVoNLtTgEDAX55J2aevRjeghJERv34PN0+nmP0jnM
 xOg8qL5Rjni1+mjim34B8P000S/laum6lW7YijsIYtbivDffH8qXEXEk16VgwxOedoWN5yQE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-18_03,2025-06-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=612 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506180080

On 17/06/2025 15:44, Harald Freudenberger wrote:
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

According to `Documentation/process/maintainer-tip.rst` (line 313 ff.), please add my
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>

> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

