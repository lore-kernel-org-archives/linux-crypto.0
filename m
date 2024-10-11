Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1EE207A0C;
	Fri, 11 Oct 2024 08:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728635774; cv=none; b=SasrxZt5UBPFfyoKdTihyZwu7VFachJdyKoY+5K4IpUV+NiXxf9vMjhLd/EyPkSeqL0CyUVu/GnBdYPZXJbOSECEaRbj0YSAE03SCBV4YjJa0n2fzEqeRF7QKxC8eUhnHLQx1qRZNmM53Ggjb7riMExsdqK91MsZznH3cKyC/Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728635774; c=relaxed/simple;
	bh=I6FRCuV7Vnu0EvQ+TRa/KiQ5GgLAW5QMGmhXXROBoPw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=feoGX4ihUMXLoTP4F+nx6iiEKgEwMz386svk1lWjhXp1tkmQ//zUORR3L3Vp7bjF0VSx8Xh79M6g3lCByWBPcI6JMUKOmly1lIU0MivLDuaWtRR1l9S6b8EZfKTpeVzkicwIHSxYHQy/e1D96lF+xnzTpYL6mA8MoluIotG4tDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XidGh6YD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XidGh6YD"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49B89dvI031301;
	Fri, 11 Oct 2024 08:35:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:subject:message-id:mime-version:content-type; s=pp1;
	 bh=IVWnUqBc7KoYC8Ep0cjezeb2FP0REpJ9XdOmTQCedXM=; b=XidGh6YDhJPF
	l6L2PBlK/7/XEojtoEsCWGzhQOI9IRMe0f9f4jxVa7ewUVxniKPj0DsFLYWIhUCm
	z0/LEM2k3fSw/zxl147+c2jWmbBpy0Fx8JxSblI39+Xd6LTm+cFUyeS0zRXZiOr1
	iIpfa4wsDOoTrSLWbjJVcPgYXNId6njOmpe6PIRIlssxzwg5NBF9PLRYo1XkyQWX
	RiJ0TjogjOzBShENXpjXcqUxZzpXlRKD6ce3q+gvGYJ0/jw4jJ93H3FoTwE5URyO
	iAcMTZVCXWOSwCGwCHtxxP3PhhTQljg9nAjB5Fon/5NT7CpshPfQdFpIJoVqqFvZ
	ciHGMM+MNQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42708qr3t7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 08:35:49 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49B8Zm6u019371;
	Fri, 11 Oct 2024 08:35:48 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42708qr3t4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 08:35:48 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49B4xjXT022678;
	Fri, 11 Oct 2024 08:35:47 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 423h9kc6c2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 08:35:47 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49B8ZjeZ43712842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Oct 2024 08:35:45 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C7B2B20043;
	Fri, 11 Oct 2024 08:35:45 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F3C020040;
	Fri, 11 Oct 2024 08:35:43 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.124.219.55])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 11 Oct 2024 08:35:43 +0000 (GMT)
Date: Fri, 11 Oct 2024 14:05:40 +0530
From: Vishal Chourasia <vishalc@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Naveen N Rao <naveen@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: drivers/nx: Invalid wait context issue when rebooting
Message-ID: <ZwjjXJ5UtZ28FH6s@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vxZHi6rthh7m2OtbHS_khjM-cTfgkE0e
X-Proofpoint-ORIG-GUID: d2J60pvt6eaUPdm-uwTvgx7YbKmz78WZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-11_06,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=235 lowpriorityscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410110055

Hi,
I am getting Invalid wait context warning printed when rebooting lpar

kexec/61926 is trying to acquire `of_reconfig_chain.rwsem` while holding
spinlock `devdata_mutex`

Note: Name of the spinlock is misleading.

In my case, I compiled a new vmlinux file and loaded it into the running
kernel using `kexec -l` and then hit `reboot`

dmesg:
------

[ BUG: Invalid wait context ]
6.11.0-test2-10547-g684a64bf32b6-dirty #79 Not tainted
-----------------------------
kexec/61926 is trying to lock:
c000000002d8b590 ((of_reconfig_chain).rwsem){++++}-{4:4}, at: blocking_notifier_chain_unregister+0x44/0xa0
other info that might help us debug this:
context-{5:5}
4 locks held by kexec/61926:
 #0: c000000002926c70 (system_transition_mutex){+.+.}-{4:4}, at: __do_sys_reboot+0xf8/0x2e0
 #1: c00000000291af30 (&dev->mutex){....}-{4:4}, at: device_shutdown+0x160/0x310
 #2: c000000051011938 (&dev->mutex){....}-{4:4}, at: device_shutdown+0x174/0x310
 #3: c000000002d88070 (devdata_mutex){....}-{3:3}, at: nx842_remove+0xac/0x1bc
stack backtrace:
CPU: 2 UID: 0 PID: 61926 Comm: kexec Not tainted 6.11.0-test2-10547-g684a64bf32b6-dirty #79
Hardware name: IBM,9080-HEX POWER10 (architected) 0x800200 0xf000006 of:IBM,FW1060.00 (NH1060_012) hv:phyp pSeries
Call Trace:
[c0000000bb577400] [c000000001239704] dump_stack_lvl+0xc8/0x130 (unreliable)
[c0000000bb577440] [c000000000248398] __lock_acquire+0xb68/0xf00
[c0000000bb577550] [c000000000248820] lock_acquire.part.0+0xf0/0x2a0
[c0000000bb577670] [c00000000127faa0] down_write+0x70/0x1e0
[c0000000bb5776b0] [c0000000001acea4] blocking_notifier_chain_unregister+0x44/0xa0
[c0000000bb5776e0] [c000000000e2312c] of_reconfig_notifier_unregister+0x2c/0x40
[c0000000bb577700] [c000000000ded24c] nx842_remove+0x148/0x1bc
[c0000000bb577790] [c00000000011a114] vio_bus_remove+0x54/0xc0
[c0000000bb5777c0] [c000000000c1a44c] device_shutdown+0x20c/0x310
[c0000000bb577850] [c0000000001b0ab4] kernel_restart_prepare+0x54/0x70
[c0000000bb577870] [c000000000308718] kernel_kexec+0xa8/0x110
[c0000000bb5778e0] [c0000000001b1144] __do_sys_reboot+0x214/0x2e0
[c0000000bb577a40] [c000000000032f98] system_call_exception+0x148/0x310
[c0000000bb577e50] [c00000000000cedc] system_call_vectored_common+0x15c/0x2ec
--- interrupt: 3000 at 0x7fffa07e7df8
NIP:  00007fffa07e7df8 LR: 00007fffa07e7df8 CTR: 0000000000000000
REGS: c0000000bb577e80 TRAP: 3000   Not tainted  (6.11.0-test2-10547-g684a64bf32b6-dirty)
MSR:  800000000280f033   CR: 48022484  XER: 00000000
IRQMASK: 0
GPR00: 0000000000000058 00007ffff961f1e0 00007fffa08f7100 fffffffffee1dead
GPR04: 0000000028121969 0000000045584543 0000000000000000 0000000000000003
GPR08: 0000000000000003 0000000000000000 0000000000000000 0000000000000000
GPR12: 0000000000000000 00007fffa0a9b360 ffffffffffffffff 0000000000000000
GPR16: 0000000000000001 0000000000000002 0000000000000001 0000000000000001
GPR20: 000000011710f520 0000000000000000 0000000000000000 0000000000000001
GPR24: 0000000129be0480 0000000000000003 0000000000000003 00007ffff961f2b0
GPR28: 00000001170f2d30 00000001170f2d28 00007fffa08f18d0 0000000129be04a0
NIP [00007fffa07e7df8] 0x7fffa07e7df8
LR [00007fffa07e7df8] 0x7fffa07e7df8
--- interrupt: 3000


