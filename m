Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBA2216A19;
	Fri, 11 Oct 2024 11:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728647026; cv=none; b=a5XqNf7IsLj2ZyehznsYsz1ygKUv4XWiXIpg2muA6EPReutOOqfh5fkYS5MObbwSjCAF/tsuKwdlg8mlL+yuhrbaQQmfJHr38z10JAEMX49XGayUCVOQURB6TmUOmR41Eu0kiFWWrzZLMHiRu2KTcCHbJQTGTy+EGRfFjewfpfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728647026; c=relaxed/simple;
	bh=e9JjOESwlcWDP1qpCkA/TT+guVU7ucugvsmUfXTVMWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSVr7H5FVcSNkIXj2zxYZ+raX+zeXwa+uXCIt1WIQT5G4AshZU2dzB0x1MbTCHK1gk3AvvuD4RLK5z87i0BTXDkAez59b2xL2dnUNWllQ2Yig+xNuC6WrmEfhCPkyiE8h6ZTnaHhF5gQK+x8fl03isb8eeKB9WNrx0rSHmbd6EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aHXkdRoM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aHXkdRoM"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49BBf4RA006987;
	Fri, 11 Oct 2024 11:43:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=ckinwTeZFBmiUd3mxD6hrM8Uo0j
	5hKS4JaTjoXbkxY4=; b=aHXkdRoMBPwZlpL8nMmLkZL/YdWHa3y7x3oCu2ke3g8
	RaST7PF7jGe5mpKubZLCtDgQLJiHfbhfbBqsh2yaIQL5P17mtFrC0pvuDuDEy8S1
	IW3VVtby3VOlaSQItJyRHJHDCEdWliEhrWsMckp5rfSG+KJ3xcMwXugYwNulRR6A
	u6K6dNopCFD8rN4lkzg6V2m3B0UaIS9yTJHYQ6FwiRpfphzmmpPRtUo6TRkg3nq5
	4fxgaMnWA5SXmtE214EH8vloiTUZslK/c1wm22oMydB5Da5yl342dUDczUXDF4Aa
	cs+W3Nl5cNpK75hsXgOZvbQCTDhEnFxHSzglU5dEgcg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4273bv006e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 11:43:20 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49BBgGrR009337;
	Fri, 11 Oct 2024 11:43:19 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4273bv006c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 11:43:19 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49BBNLda022678;
	Fri, 11 Oct 2024 11:43:18 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 423h9kd50a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 11:43:18 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49BBhG3355902658
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Oct 2024 11:43:16 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF5122004B;
	Fri, 11 Oct 2024 11:43:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 27DDC20049;
	Fri, 11 Oct 2024 11:43:14 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.124.219.55])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 11 Oct 2024 11:43:13 +0000 (GMT)
Date: Fri, 11 Oct 2024 17:13:11 +0530
From: Vishal Chourasia <vishalc@linux.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Naveen N Rao <naveen@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: drivers/nx: Invalid wait context issue when rebooting
Message-ID: <ZwkPT3H_WVd5KyZQ@linux.ibm.com>
References: <ZwjjXJ5UtZ28FH6s@linux.ibm.com>
 <87wmif53iw.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wmif53iw.fsf@mail.lhotse>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OiLWvBvcBqijx_Uof_jqARTolV4kGND7
X-Proofpoint-GUID: PZ4mSYovNXa7Ivc6ZDFVEUDb98JcSOhx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-11_09,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410110080

On Fri, Oct 11, 2024 at 09:37:27PM +1100, Michael Ellerman wrote:
> Vishal Chourasia <vishalc@linux.ibm.com> writes:
> > Hi,
> > I am getting Invalid wait context warning printed when rebooting lpar
> >
> > kexec/61926 is trying to acquire `of_reconfig_chain.rwsem` while holding
> > spinlock `devdata_mutex`
> >
> > Note: Name of the spinlock is misleading.
> 
> Oof, yeah let's rename that to devdata_spinlock at least.
> 
> > In my case, I compiled a new vmlinux file and loaded it into the running
> > kernel using `kexec -l` and then hit `reboot`
> >
> > dmesg:
> > ------
> >
> > [ BUG: Invalid wait context ]
> > 6.11.0-test2-10547-g684a64bf32b6-dirty #79 Not tainted
> 
> Is that v6.11 plus ~10,000 patches? O_o
> 
> Ah no, 684a64bf32b6 is roughly v6.12-rc1. Maybe if you fetch tags into
> your tree you will get a more sensible version string?
> 
> Could also be good to try v6.12-rc2.
Sure.
> 
> > -----------------------------
> > kexec/61926 is trying to lock:
> > c000000002d8b590 ((of_reconfig_chain).rwsem){++++}-{4:4}, at: blocking_notifier_chain_unregister+0x44/0xa0
> > other info that might help us debug this:
> > context-{5:5}
> > 4 locks held by kexec/61926:
> >  #0: c000000002926c70 (system_transition_mutex){+.+.}-{4:4}, at: __do_sys_reboot+0xf8/0x2e0
> >  #1: c00000000291af30 (&dev->mutex){....}-{4:4}, at: device_shutdown+0x160/0x310
> >  #2: c000000051011938 (&dev->mutex){....}-{4:4}, at: device_shutdown+0x174/0x310
> >  #3: c000000002d88070 (devdata_mutex){....}-{3:3}, at: nx842_remove+0xac/0x1bc
>   
> That's pretty conclusive.
> 
> I don't understand why you're the first person to see this. I can't see
> that any of the relevant code has changed recently. Unless something in
> lockdep itself changed?
> 
> Did you just start seeing this on recent kernels? Can you bisect?
Yes. Sure, I will try bisecting, and get back.
> 
> > stack backtrace:
> > CPU: 2 UID: 0 PID: 61926 Comm: kexec Not tainted 6.11.0-test2-10547-g684a64bf32b6-dirty #79
> > Hardware name: IBM,9080-HEX POWER10 (architected) 0x800200 0xf000006 of:IBM,FW1060.00 (NH1060_012) hv:phyp pSeries
> > Call Trace:
> > [c0000000bb577400] [c000000001239704] dump_stack_lvl+0xc8/0x130 (unreliable)
> > [c0000000bb577440] [c000000000248398] __lock_acquire+0xb68/0xf00
> > [c0000000bb577550] [c000000000248820] lock_acquire.part.0+0xf0/0x2a0
> > [c0000000bb577670] [c00000000127faa0] down_write+0x70/0x1e0
> > [c0000000bb5776b0] [c0000000001acea4] blocking_notifier_chain_unregister+0x44/0xa0
> > [c0000000bb5776e0] [c000000000e2312c] of_reconfig_notifier_unregister+0x2c/0x40
> > [c0000000bb577700] [c000000000ded24c] nx842_remove+0x148/0x1bc
> > [c0000000bb577790] [c00000000011a114] vio_bus_remove+0x54/0xc0
> > [c0000000bb5777c0] [c000000000c1a44c] device_shutdown+0x20c/0x310
> > [c0000000bb577850] [c0000000001b0ab4] kernel_restart_prepare+0x54/0x70
> > [c0000000bb577870] [c000000000308718] kernel_kexec+0xa8/0x110
> > [c0000000bb5778e0] [c0000000001b1144] __do_sys_reboot+0x214/0x2e0
> > [c0000000bb577a40] [c000000000032f98] system_call_exception+0x148/0x310
> > [c0000000bb577e50] [c00000000000cedc] system_call_vectored_common+0x15c/0x2ec
> 
> I don't see why of_reconfig_notifier_unregister() needs to be called
> with the devdata_mutext held, but I haven't looked that closely at it.
> 
> So the change below might work.
> 
> cheers
> 
> diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
> index 35f2d0d8507e..a2050c5fb11d 100644
> --- a/drivers/crypto/nx/nx-common-pseries.c
> +++ b/drivers/crypto/nx/nx-common-pseries.c
> @@ -1122,10 +1122,11 @@ static void nx842_remove(struct vio_dev *viodev)
>  
>  	crypto_unregister_alg(&nx842_pseries_alg);
>  
> +	of_reconfig_notifier_unregister(&nx842_of_nb);
> +
>  	spin_lock_irqsave(&devdata_mutex, flags);
>  	old_devdata = rcu_dereference_check(devdata,
>  			lockdep_is_held(&devdata_mutex));
> -	of_reconfig_notifier_unregister(&nx842_of_nb);
>  	RCU_INIT_POINTER(devdata, NULL);
>  	spin_unlock_irqrestore(&devdata_mutex, flags);
>  	synchronize_rcu();
> 
