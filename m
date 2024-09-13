Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725531DA62E;
	Fri, 13 Sep 2024 13:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726232753; cv=none; b=NhhJRYWRM5ObHwzDm395DjpSzh33ESK07Nm4zimhGsFvMrVKKOoVucAOAOJTR5mDJqCFpe/ecKjrXaaxT0Mkc92bBU+TZKwWSUDcRqpTythtHJ37ScCxJFQsBmM1iKoX7vgcpLHPw7fn2X1WgFFPaLzrT1MufTb3UbsqPvQtVO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726232753; c=relaxed/simple;
	bh=ka0rqxcS2NBCAjK5Qw+iwYfxA/+ZTEiCWcrpXvkpRxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XFNAXT7+MpSnL/yA8CH3YpjJhbnq1/x9XUjdIYDTVjC4S4B1kmdtCtIQ0MfK0fsLMaP59yHebvZ0RgVD3nKNi5dlFLGJfqm1WOOsrYaZIakzdi5XKvCn2tA62o2kaS4ulvW6UVxlUJHh3WbENKubIvX3ITAmbriavsqvbZ0Weow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DGMmQmi1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DGMmQmi1"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48DBLjw5005775;
	Fri, 13 Sep 2024 13:05:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=HjynV7dZyRjGp2iCQjnPneTVJO
	QAyBkiMk81rcoRE/E=; b=DGMmQmi1Vfoufw4Bkyr9BhJ5UvasSANmchFje9Hi+T
	1on6iibAPZdfSJ29vPekwDYcOku7JPcwZP5JZBWf260xtVTgV/zDtDUksoBpcjYb
	t4bbUGIs3V9ixStWCPmyCytLhlzsiWSb8bAvPQXkwNohuPUI9AKlN8u+U/M4XpSZ
	lBdYCktaPjhjDCWq4frmqfeGXfq+lSj9bU+ftMHf36MiCBkL4d+K/DE7D4VtsmwF
	x3uCTV7b/8DERz2LkugrWrE0PB/wycvF+JSI2+I1GaJsnI8eJ/sNL1vCz8Fo1anS
	Tl2ncdHrZkbb1YqZRrS4MZj30zjs7is34Y2k8+GBDHDw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41gc8qtamh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 13:05:49 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48DCFWEG010793;
	Fri, 13 Sep 2024 13:05:48 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41kmb71vhv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 13:05:48 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48DD5iD343778534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Sep 2024 13:05:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F36320043;
	Fri, 13 Sep 2024 13:05:44 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3762A20040;
	Fri, 13 Sep 2024 13:05:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 13 Sep 2024 13:05:44 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Stefan Liebler <stli@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 0/7] s390/vdso: getrandom() vdso implementation
Date: Fri, 13 Sep 2024 15:05:36 +0200
Message-ID: <20240913130544.2398678-1-hca@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _YpvvZE8HFa6yQq9mWMFb-nqqhS-vLwV
X-Proofpoint-ORIG-GUID: _YpvvZE8HFa6yQq9mWMFb-nqqhS-vLwV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_09,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 clxscore=1015 mlxlogscore=295 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409130087

Hi Jason,

quite late but finally the s390 vdso getrandom implementation which applies
on top of your random git tree.

As a prerequisite this requires some changes to s390 core code to allow
alternatives in vdso code. It is fine when all of this gets routed via your
tree.

Please note that the first patch of this series is already in linux-next
[1], but given that it is so small it seems to be the easiest to apply it
also on your tree; but I'm sure somebody will complain :)

Thanks,
Heiko

[1] 0147addc4fb7 ("s390/facility: Disable compile time optimization for decompressor code")

Heiko Carstens (7):
  s390/facility: Disable compile time optimization for decompressor code
  s390/alternatives: Remove ALT_FACILITY_EARLY
  s390/facility: Let test_facility() generate static branch if possible
  s390/module: Provide find_section() helper
  s390/vdso: Allow alternatives in vdso code
  s390/vdso: Move vdso symbol handling to separate header file
  s390/vdso: Wire up getrandom() vdso implementation

 arch/s390/Kconfig                           |   1 +
 arch/s390/include/asm/alternative.h         |   6 +-
 arch/s390/include/asm/facility.h            |  37 +++-
 arch/s390/include/asm/fpu-insn-asm.h        |  22 +++
 arch/s390/include/asm/module.h              |  14 ++
 arch/s390/include/asm/vdso-symbols.h        |  17 ++
 arch/s390/include/asm/vdso.h                |  12 --
 arch/s390/include/asm/vdso/getrandom.h      |  40 +++++
 arch/s390/include/asm/vdso/vsyscall.h       |  15 ++
 arch/s390/kernel/compat_signal.c            |   2 +-
 arch/s390/kernel/entry.S                    |   2 +-
 arch/s390/kernel/signal.c                   |   2 +-
 arch/s390/kernel/vdso.c                     |  26 ++-
 arch/s390/kernel/vdso64/Makefile            |   9 +-
 arch/s390/kernel/vdso64/vdso.h              |   1 +
 arch/s390/kernel/vdso64/vdso64.lds.S        |   7 +
 arch/s390/kernel/vdso64/vgetrandom-chacha.S | 184 ++++++++++++++++++++
 arch/s390/kernel/vdso64/vgetrandom.c        |  14 ++
 tools/arch/s390/vdso                        |   1 +
 tools/testing/selftests/vDSO/Makefile       |   2 +-
 20 files changed, 378 insertions(+), 36 deletions(-)
 create mode 100644 arch/s390/include/asm/vdso-symbols.h
 create mode 100644 arch/s390/include/asm/vdso/getrandom.h
 create mode 100644 arch/s390/kernel/vdso64/vgetrandom-chacha.S
 create mode 100644 arch/s390/kernel/vdso64/vgetrandom.c
 create mode 120000 tools/arch/s390/vdso

-- 
2.43.0

