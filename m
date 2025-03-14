Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605E51779AE;
	Fri, 14 Mar 2025 03:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741924045; cv=none; b=YBobLmOTdkJsLaUlYCBA6JRhs/FMY06tKlXWojm7CilPbDGCBbhOees37GiFA9zkC40cox9x0V6KPjdqCuF9H3FTWQJdpb0wLdpuAk2DpR7QeD7ZevAFfD6VjQYAvtzha+A6h/Blz2l3hTh3+4Toq0sB4y8KRk0SSUgmsIzDPrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741924045; c=relaxed/simple;
	bh=E8miDbWFRAarkkOftrPlxHt0dCvX1QfhfFM0L55zfwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NRzI8LYGPe8HGfEwxdOBvbfHSob5ir/uR0v6P/S4fYzWJiI+8SiRhslttKIN2jQBk8aLrsBbxktl3jE5+bBMtElkaBZm26QYdkIm7tRNlDjqunCwDScn8ecIeknSs6HlVze7DYyS6SqYBmBGEZBfaIsatB8rDM+RTAHvQgaDm60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BfgXg1TO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BfgXg1TO"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DNPih4015112;
	Fri, 14 Mar 2025 03:46:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=jn35de
	RvCVcgZ11e6phbQa3ao0XQUYGI0q9A1c6rtG0=; b=BfgXg1TOrWR79MFSST42tx
	0o+2sQIf07eiwDXfZ8hbUsGyhJTHo9jrVa/wamYq9Aih2JuwwJhpEW0DoefWGG1p
	R42MvwLMHOraOHKQ4EvXOFyyO0KWMl3hsKTOmXP3DlUfRBdmPorTcNkm6xj9x9jr
	/JZj4qF+7hNBO2wfAwyJ5Ql/pVlZFmg+yyy1su6rFaJDRgObp5q7W+fR5Yn/IVc8
	lHTJAY3LBdduIeg10dVcneF8RBics9YeyV++zdTkGWL4flfcENft8KZ8yzu0lYfP
	0UuN5VGu0Bpjb3296LVX5lRoHfrOhUNOEQ4qA4u1NQVdQBqth0emNrb/BwSYWjZA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45c6k01dd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Mar 2025 03:46:58 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 52E3kvKb028609;
	Fri, 14 Mar 2025 03:46:57 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45c6k01dd6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Mar 2025 03:46:57 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52E0F5iU003141;
	Fri, 14 Mar 2025 03:46:57 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 45atstw3ad-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Mar 2025 03:46:56 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52E3krh432702888
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Mar 2025 03:46:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5891820043;
	Fri, 14 Mar 2025 03:46:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14C9D20040;
	Fri, 14 Mar 2025 03:46:50 +0000 (GMT)
Received: from li-c439904c-24ed-11b2-a85c-b284a6847472.in.ibm.com (unknown [9.204.206.207])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Mar 2025 03:46:49 +0000 (GMT)
From: Madhavan Srinivasan <maddy@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Danny Tsen <dtsen@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Breno Leitao <leitao@debian.org>, Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>, Naveen N Rao <naveen@kernel.org>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH] crypto: powerpc: Mark ghashp8-ppc.o as an OBJECT_FILES_NON_STANDARD
Date: Fri, 14 Mar 2025 09:16:49 +0530
Message-ID: <174192385438.14370.17442105998926160601.b4-ty@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <7aa7eb73fe6bc95ac210510e22394ca0ae227b69.1741128786.git.christophe.leroy@csgroup.eu>
References: <7aa7eb73fe6bc95ac210510e22394ca0ae227b69.1741128786.git.christophe.leroy@csgroup.eu>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TWCf0-zAmmg-MthTRdUY4FKpVwhV-5tA
X-Proofpoint-ORIG-GUID: wjBXDa6-ut0NTyU-5dfrFA-wQCQyM5ej
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-14_01,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=922 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 adultscore=0 spamscore=0 mlxscore=0
 suspectscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2502280000 definitions=main-2503140026

On Wed, 05 Mar 2025 00:02:39 +0100, Christophe Leroy wrote:
> The following build warning has been reported:
> 
>   arch/powerpc/crypto/ghashp8-ppc.o: warning: objtool: .text+0x22c: unannotated intra-function call
> 
> This happens due to commit bb7f054f4de2 ("objtool/powerpc: Add support
> for decoding all types of uncond branches")
> 
> [...]

Applied to powerpc/next.

[1/1] crypto: powerpc: Mark ghashp8-ppc.o as an OBJECT_FILES_NON_STANDARD
      https://git.kernel.org/powerpc/c/1e4d73d06c98f5a1af4f7591cf7c2c4eee5b94fa

Thanks
