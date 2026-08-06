Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7026742377A;
	Thu,  6 Aug 2026 08:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006199; cv=none; b=ijLtcm296QUY/w9tE2lcaSKkuN48/te6Xe6sxZgimBDwgVGxsUlL6sEvVz8gfywn6tFPl54lwhSJIpwVKrPSzT0ByZMwGHrQA59E3Nvtxe7+cukOkhgrKIhVWSpZ7deozn2SV5nWoYYRK6h0GipdZKSbVNOJoTXKN45WQcpjMTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006199; c=relaxed/simple;
	bh=e+s7UGCru9Qj/6WxDgJrH3vQiaD7O6wl7J0KU+Fbs3E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ihe8xc2X5AyvXHZDtkDI5b/gd9w4XBPsumHdIs7hz7vJ03bFMZf1HcO95/+ANpmtaObLs2ST2G3+Vs7RMFoCGXiZN0ltPKmzkfVlqUNYUUaXsUNMkIDCMmHkaw4FbwGXlNwAO492L6d7NJj6JlFH0bEbP3w+6sQc9U/eVEuYGfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JapejCzR; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JapejCzR"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 675Nll4k1143324;
	Thu, 6 Aug 2026 08:49:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=//iM4vRpQi94/03Zfo8g9Szejqke72IXA2GWeCeeg
	gk=; b=JapejCzRKcwW9yEsBbTCBq3VfOnVe1K5i6JkBNI/9Hefs/Pivq/ARd0vI
	Br5n7OCa3rJ6qDNsQWBEtYLFrnjVY0nNrDKPxM6ZQkLgSbmMCKamr/jMn/XpyNvx
	HmVCmXP/09UPJDAsx+TjbtmJmjEA48RSFPRkiMdDgcvFRAaBflhi1XPSS3d3gpPu
	DdJYo+/kjbbJvn1+WXMpR68mQLTR0Cw4Q8uxUZjNupP51OBd8pQsXOX5DZwasodk
	8UVBoq8hY6ftkD3IJEoodzqD958cu9WVbgO6n+9lQe/CJ0Kp7llNqrBnAH6Fften
	mFBkT1iLGqMjAXnEMMbSmfiD6uTKQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8euxng5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 08:49:56 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6768fJFm018579;
	Thu, 6 Aug 2026 08:49:55 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsvmhjbg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Aug 2026 08:49:55 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6768no0x43778346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Aug 2026 08:49:50 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BFC642004B;
	Thu,  6 Aug 2026 08:49:50 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6017020040;
	Thu,  6 Aug 2026 08:49:50 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.145.185])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Aug 2026 08:49:50 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 0/2] Fix skcipher_walk return code handling in aes_s390
Date: Thu,  6 Aug 2026 10:49:48 +0200
Message-ID: <20260806084950.17679-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cJ2Y37L0aOWdpQT8E1VdvuSRrj0xY0yh
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA2OCBTYWx0ZWRfX7nsOBpVadhDm
 VyM9/uhJJDHlB24ojtLKg9s6ehi1Lu1mpktu//J/+o0+Uor1V0YGDSJmBxaRx1+qVvyMG/M9EZU
 ZwayuMxW2GuaCbcrA3dtQcRrO+8AdTg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA2OCBTYWx0ZWRfXwH/vTDts26VC
 BC9Q1NYFtiFjOv2ssOlcwJXv74ljqP480WBrbx5hhZg9zybIoS1iLxdEFP/J4Uv5kGOXLF3vY4T
 zSRGttI9I2T/oRJhy6Cjo286vE9RYbyjOhwljv3he9KP992JlGM3Q9XfVgU5565tI6DWxzow3Jf
 wQw+2eRi/3ltJzl4Te+hW/Q/5JFNZHH1fzPhEjnb/bF9TlVsUXhY7stk1skTElrbfGjBmLXqH5E
 GQ850/5Fs/NUIdd7kd8/Gh6dflt0CzsubwxEP73ZduDp97R1qkGYsA73EbnLtml8d6BsD4XSZOd
 jcxcXNDYQa881YrLOrW8mvUCxRwV6E7GTyCtCq3br1HX6A/bANg3ofbhmhVzeiAAlaoNRoNzxuA
 B0Q7hpYEh0ySv+johe5LmlpxoVCwJEZMR2yD+BXR3QaHH7vsJKF0E9g7tu+6BAENIkKDmH3KNJi
 KetM7frp2JCx0N9bCHg==
X-Proofpoint-GUID: cJ2Y37L0aOWdpQT8E1VdvuSRrj0xY0yh
X-Authority-Analysis: v=2.4 cv=KfzidwYD c=1 sm=1 tr=0 ts=6a744ab4 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=s5IaBbAnHO2ZuBJA9J8A:9 a=zgiPjhLxNE0A:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060068

The return codes from skcipher_walk_virt() were not properly checked
before entering the processing loops in ecb_aes_crypt() and ctr_aes_crypt().
If skcipher_walk_virt() fails, the walk structure may be in an undefined
state, and attempting to process data could lead to incorrect behavior
or accessing uninitialized memory.

Add proper return code checking to ensure correct handling of the walk
initialization and walk advance and eventually return to the caller
with that return code.

Patch #2 deals with a not scrubbed temp buffer.

Changelog:

v1: initial version
v2: Fix missing scrub on a temp buffer used to process left over bytes
    in CTR mode.

Harald Freudenberger (2):
  s390/crypto: Fix skcipher_walk return code handling in aes_s390
  s390/crypto: Explicit scrub temp buffer in AES ctr mode algorithm

 arch/s390/crypto/aes_s390.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--
2.43.0

