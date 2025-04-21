Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D751172A;
	Mon, 21 Apr 2025 07:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745221901; cv=none; b=BlGuwYqzd/c7ZLe9VhFDLwKyIVjnnvg8owwEv643pJqErRzkIMvJSAI0JiAjGXbqjPCHycmEb/exJMfjDSM4MCebha/Qx5arbXrTuxDzvZz7Pe8mAvL8SOMMakQIR3/cS7+9riIy3NDCYwUWGdW4yAsU//aQxQXo7QF8P6bW8O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745221901; c=relaxed/simple;
	bh=3EkWytvG1FAq4wSiAgBGR+l+bJeIVa+qMUoJsIjq+G8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VidubEG719APNjAARjM3snHEiFjMU/xtLw3TRkjpQekd/hUUgkWU81l1QDcmZcgqSyRAEaFBIidf2IHa8JpuWpX+xNcQ517GbRGb3ciSot547sB0qLM4Sj7KKqGR2eUHKJXIt87lHMabtqlruW6oCQMwSbJoLEMhZJlpctvzRRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Imqomrpz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Imqomrpz"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53L6kP4p002241;
	Mon, 21 Apr 2025 07:51:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Zrxe4BNXmiX+JsfnkgMsSiUWHNsZF/
	9cngeWX3ef/yQ=; b=ImqomrpzNxCgrQYaQmUIUOt4z7pdd9isSZeReR9twXUZva
	D276bTRcOJm5yvzgrXe8dsvSmM7N+CNFUOM7jn11vLVteR5vAZsulrUhKkQmkqfD
	ig6Uw2QBmfnr6oNnoIRqFnupf1AQW1AGfMoNJhmMYPgys5cr4yoSAKnIL149HJQ8
	3abIbBQ27YUw1twEHj65jm1a2GUceIg22INtt4h7Zdd7T9yEL5PCQGUyWOeV8fBB
	Luhi7syGPQWwefT0tJMhH2wkgBWUj9YELdeIRIjFzvG002cNtsHazE63jWsbBbr5
	DYRO+hRtCEEqQ1wqVtn0IuKN736IlKiSa9r8OpLQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 464xuhud3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Apr 2025 07:51:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53L6Hagx012493;
	Mon, 21 Apr 2025 07:51:36 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 464p5swkds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Apr 2025 07:51:35 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53L7pYCn34013524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Apr 2025 07:51:34 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3733620043;
	Mon, 21 Apr 2025 07:51:34 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAE8420040;
	Mon, 21 Apr 2025 07:51:33 +0000 (GMT)
Received: from osiris (unknown [9.87.139.110])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 21 Apr 2025 07:51:33 +0000 (GMT)
Date: Mon, 21 Apr 2025 09:51:32 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] s390/crc32: Remove no-op module init and exit functions
Message-ID: <20250421075132.39860A95-hca@linux.ibm.com>
References: <20250417163829.4599-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250417163829.4599-1-ebiggers@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QS8RGRcVQCRxBNwMwTrXfFOHbArAlT7P
X-Proofpoint-ORIG-GUID: QS8RGRcVQCRxBNwMwTrXfFOHbArAlT7P
X-Authority-Analysis: v=2.4 cv=LbY86ifi c=1 sm=1 tr=0 ts=6805f908 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=kj9zAlcOel0A:10 a=XR8D0OoHHMoA:10 a=1XWaLZrsAAAA:8 a=VnNF1IyMAAAA:8 a=Akb6hcwL4JXZyUYhJT8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-21_03,2025-04-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=695 phishscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504210058

On Thu, Apr 17, 2025 at 09:38:29AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Now that the crc32-s390 module init function is a no-op, there is no
> need to define it.  Remove it.  The removal of the init function also
> makes the exit function unnecessary, so remove that too.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> I'll take this via the crc tree.
> 
>  arch/s390/lib/crc32-glue.c | 11 -----------
>  1 file changed, 11 deletions(-)

Acked-by: Heiko Carstens <hca@linux.ibm.com>
