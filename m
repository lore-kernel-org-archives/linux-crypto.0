Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948003CB567;
	Fri, 31 Jul 2026 11:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785499022; cv=none; b=NqmFfTb2q7nxSnCMkHc2pTgKH8dvcFxClQ6o7EA56D6Kn5ejH9PZGqCehC1jffL29lJ3Swq+Et5Ak1PM98G1Em3TDiw4Yj02UsPhJEjUPS5UTLbK8U1rnOdvN8v4NPJALkv96w9Htftzq4aC9vqGtBtyIZhO8AYnW5xxcsy2cIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785499022; c=relaxed/simple;
	bh=Wf4kDabg62/t3QOZJCcU6tcPZRhbmX4EHrVdOMQEETY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNW+VjNMTKSarLD3EkEip+msspd2p1hesrad04Bd3rGiBiQLS6gEZGfetcCLZGzyasGNupUxVSJgPB0xOVhKiu21oI/OpICBu40LVKL9ObkAdpgcVyF+oK1twAtOaq+cdpqMWGon1mck296T+zWi6wyTwxx0P9T+jzDDJQ1q9iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fe3qVzP0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fe3qVzP0"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VBlg4N1670344;
	Fri, 31 Jul 2026 11:56:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ZiHYm0Vn6iPnB7kC1HP6qjZTUWsk7r
	eyzByGz3nxnSE=; b=fe3qVzP0DXBctFT9nOHsgoJ9Lz7ajWtFp5Yw8gAlT0W7AJ
	Er84am/XBGT0Jybtr7VDBQPydm9FCMGQX2ZuAXynXO5chbFf9IZeS6VbQCju9FEB
	aMj5rhdDmm0aGkZBEkNkX1Q48V+ueE0utHhIYnap8Zmd2yDCjszRuNu7SqeKeKB2
	eP9XZvZCijaktZI2a/GT7fnjUq4LaxdlPRSEWo0+8jV8X4j/jlFZEhrJy1aEls8M
	wt1IFbGqpoNuF0j9FzbzJ4evdnD0U1EqwVAWM8xow1ibRMivbJoU2hxW4NfOOhIO
	6tEUvSF37KKXGM8iknVVyoPLJUYhBTqeP7/C5Ufw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyjkte9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 11:56:48 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66VBfFWY031991;
	Fri, 31 Jul 2026 11:56:47 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fn7fqqwax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 11:56:47 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66VBuhuv27656762
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 11:56:43 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3DD9020043;
	Fri, 31 Jul 2026 11:56:43 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA18820040;
	Fri, 31 Jul 2026 11:56:42 +0000 (GMT)
Received: from osiris (unknown [9.111.91.157])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 31 Jul 2026 11:56:42 +0000 (GMT)
Date: Fri, 31 Jul 2026 13:56:41 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Holger Dengler <dengler@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 1/4] s390/crypto: Replace cond_resched() with msleep(1)
Message-ID: <20260731115641.8638C01-hca@linux.ibm.com>
References: <20260730052907.2607026-1-hca@linux.ibm.com>
 <20260730052907.2607026-2-hca@linux.ibm.com>
 <20260730101157.GQ49951@noisy.programming.kicks-ass.net>
 <39570813-27b0-40f9-89c5-8e2dce05e2f0@linux.ibm.com>
 <20260730124819.GA776954@noisy.programming.kicks-ass.net>
 <18c36e42-8f96-479c-8152-2da3f5034f04@linux.ibm.com>
 <20260731084027.GE776954@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731084027.GE776954@noisy.programming.kicks-ass.net>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA5MCBTYWx0ZWRfX0x2YBMvCcPNp
 IjBirJ+3LTKdraG7U2MwwPZp5UxRJI0vJ/jir9vewGYa90eO8yzcmx+HLtbZkELwfXUaB6ParVK
 crDgIRfa6hil5aZgrtG59X3DCxtoZAs=
X-Proofpoint-GUID: -MpqO2u1bSHw4qQK_5ZrNqFZ1YI0cPbR
X-Proofpoint-ORIG-GUID: -MpqO2u1bSHw4qQK_5ZrNqFZ1YI0cPbR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA5MCBTYWx0ZWRfXwI9SXSmGzTWl
 JoqC5bOcbHPntMe8Mw/bCXyBKv6l3reBFtATftZkLbf1mKB3Qy+80iFMATicVDCwEvCFEjDXo3Q
 jNY7PpdTfdS4M4zpw9AImBzuNkdraxaY37S1dklzHqvZod2Z/T21ygX8k5x/+Bohk9KB4QAxIKo
 No5FIMnPGOWbLjPiWtst+37djz6Rkx/reomLV4+kkX4idBZ5Hd2ZENh5Ti6h/gZ1/NBVZrIvyev
 E6ty+mqjpLrq+oJHLDOB0b3aI+HccfzWpNCWOoecidjBpT6ViV9LL4TO9G/kcQL+erRN0ptypJ9
 zP7ooVO7sh7g2z+t3uwfj2vCqoU0UA5tPAOdT9DmKzQnvW5R90ye7imxIwmgbLN9rwJpmkggH4O
 bBPdnIz/Whq3/IXbJp1B0bpJ6FDf8NEJxYHzxiFQ76K/WlHo0Bj2cgt275KskHY+fKsVTibs/3M
 B5e/VCBTUCgEor0Fh8w==
X-Authority-Analysis: v=2.4 cv=X5Vi7mTe c=1 sm=1 tr=0 ts=6a6c8d80 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=3mNmA6R7fTEV-jVun7UA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607310090

On Fri, Jul 31, 2026 at 10:40:27AM +0200, Peter Zijlstra wrote:
> On Fri, Jul 31, 2026 at 09:44:57AM +0200, Holger Dengler wrote:
> 
> > > Yes, guest migration is very likely far more disruptive than most
> > > anything else. Perhaps clarify the code comment to include some of this
> > > explanation?
> > 
> > I agree, the comment is not telling all main key points. What about the
> > following?
> > 
> > /*
> >  * Protected key expired due to relocation to another
> >  * host. The long runnning re-wrap has no asynchronous
> >  * completion notification, so polling is required.
> >  * Trigger a re-schedule of this request by returning
> >  * -ENOSPC ("hardware queue full") to the crypto engine.
> >  * To avoid immediately re-invocation of this callback,
> >  * tell scheduler to voluntarily give up the CPU here.
> >  */
> > 
> > (I would leave it up to Heiko to merge the comment in his series, or let
> > Harald/me do it in a separate patch)
> 
> Right, perhaps something like so, avoiding the endless copy/paste ?

I guess there won't be any disagreement. I'll merge your patch, and
add Holger's explanation to the commit message.

Thanks!
