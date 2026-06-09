Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0D54C77CE;
	Tue,  9 Jun 2026 18:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781031503; cv=none; b=cZ9HBOGlTJIPR0XSnWi2sBLA5S4wPQU4hjdfuMq88jEu/rRkVV6P9X9L8hyO1mmFkz2ThtUB6hSmQvvMyWEul893PD04rCNNrWg+ItYKQWMNgAqpScdOB0wkwQx6Rai8ZcAAGZcDYSBHe7Cx1K3SYFzMODBQYNpf0/Wq24ImlG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781031503; c=relaxed/simple;
	bh=L8VcJhFxK63g3GeeYh4o/Y6uXlMj/Dk09lzG3eFunV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tNdLu8WqL07vP681QxUfUqAis3oADSGzx3cj8VyfHj/6OYXntS0+fzev4vY4WpLI8qRn32VGejZLbmmPLWrsBH38PhJQlULg3e3HyxXBXbsqjpBYeyUQPC1e4xVQMv6pN/hp4Us6MsjoNrfp1UOmWnVg8OG09sAaEPMMKcxMASA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QOCkQ+Ja; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QOCkQ+Ja"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 659HU4nG3887500;
	Tue, 9 Jun 2026 18:58:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WYLGxR
	y7aSIfgfzuhc0N6xHkjoK9PxOBLeSOeCGAE14=; b=QOCkQ+JaOvwnBJ5Fp4XmKR
	wzhI9PJJB5IZxB21eHP/6kLh/3YcFxB2SrARZ7g/JdGYpwTXSW51Dv5XzAY2WE25
	XyUFo17Y099h8+zyosTuVSBBDrZfJn8Yurpjyo0O5bF/xn9aldYNHD+C3GG1hJOP
	6tfzM7d9sDFnjex42NF6ayzUbkRPSTILOS5dVK8DYMpsqzUxEoqTDExDHPuya3m8
	0R49CwooHJ7mzakj2rX2U9keXoHzxvN5CH6lwsf9AoXnzywEylgDVNglNtb9o4jc
	OCaaYujs7AMZ7e8lgIYcHIRkBsbssaiLw/QJpZOcVgVsowe0+tV5DiNx5iy3G0bQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4emb23ww3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jun 2026 18:58:12 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 659Ingwk005285;
	Tue, 9 Jun 2026 18:58:11 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4emych3bbr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jun 2026 18:58:11 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 659IwB2k000934
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Jun 2026 18:58:11 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C7EA58055;
	Tue,  9 Jun 2026 18:58:11 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 81C385803F;
	Tue,  9 Jun 2026 18:58:10 +0000 (GMT)
Received: from [9.47.158.153] (unknown [9.47.158.153])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Jun 2026 18:58:10 +0000 (GMT)
Message-ID: <bd992448-8ded-46f8-bf91-97792b9a11ad@linux.ibm.com>
Date: Tue, 9 Jun 2026 14:58:09 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ecc - Optimize vli additive operations using
 compiler builtins
To: Fabian Blatter <fabianblatter09@gmail.com>, lukas@wunner.de,
        ignat@linux.win, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260607112435.42804-1-fabianblatter09@gmail.com>
Content-Language: en-US
From: Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20260607112435.42804-1-fabianblatter09@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=b4uCJNGx c=1 sm=1 tr=0 ts=6a286245 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=RTuf3evP9GeFNN_N0Y0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: TkO3KmtKbF4ZAskeUAwkAe63D3qo4pTt
X-Proofpoint-GUID: 1CL4EIcqlM8b5JFwtL_keCGzIG7DDq6D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDE3NSBTYWx0ZWRfX6Z+ry4KU5H46
 k7+QV8nJwc8I1gRSFi7PpsioJk4EtobRPb1ienuqHEI0trxLMWjLJgrXggkbPDicJH2cBExsSqX
 GNmamQkEZOxii4hSM4fUaKSYC7Ilhhg50gqovRO5GfMS6CcPa4abejzfZ93L8GXltks1jrSY/n0
 sC6EqSlsw/owfEKUGfrEWJVMbaAWPzRNqFF7tVGns7zs6KI6JtbYPKi3vGKN8A2YedsQZz3drmk
 GRvDiMi7GFoLnd2AW13TE8ah6l8EAkUExsyOo5AyLYvwM498uFuncOcZt4L9W5Kx1U9nXCY1ReB
 gwLAbXpsOshkp65mb5ep4F5ZeaN8lKXiBykSfavq59ZPzmetZ1hOAmUgvgL6qKpQ8R+9iL2Y571
 VFxApDpeT3190TxqCLW51ypF5sSGjHy70nTkRjpUN9kysb8P8hrdYpyZdmdEWXpi6nym1368J3n
 yapojNdXz0LdBgTeJ2w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_04,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606090175



On 6/7/26 7:24 AM, Fabian Blatter wrote:
> Replace the software carry flag emulation with compiler builtins.
> 
> Even the newest compilers struggle with taking advantage of the
> hardware carry flag. Compiler builtins allow the compiler to
> much more easily achieve this while still remaining constant-time.

It looks like you made vli_usub and vli_uadd constant-time now because 
otherwise the loops could be ended early once borrow == 0 or carry == 0 
respectively. Are all the other functions that operate on the private 
keys constant-time?

