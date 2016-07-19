From: alastair@au1.ibm.com
Subject: [PATCH V2 0/2] Automatically load the vmx_crypto module if supported
Date: Tue, 19 Jul 2016 14:03:51 +1000
Message-ID: <1468901033-28996-1-git-send-email-alastair@au1.ibm.com>
Cc: benh@kernel.crashing.org, paulus@samba.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Alastair D'Silva" <alastair@d-silva.org>
To: mpe@ellerman.id.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41202 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750722AbcGSEEx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jul 2016 00:04:53 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6J43lqh063231
	for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2016 00:04:52 -0400
Received: from e23smtp03.au.ibm.com (e23smtp03.au.ibm.com [202.81.31.145])
	by mx0b-001b2d01.pphosted.com with ESMTP id 2496h5s562-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2016 00:04:51 -0400
Received: from localhost
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <alastair@au1.ibm.com>;
	Tue, 19 Jul 2016 14:04:48 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Alastair D'Silva <alastair@d-silva.org>

This series allows the vmx_crypto module to be detected and automatically
loaded via UDEV if the CPU supports the vector crypto feature.

Alastair D'Silva (2):
  powerpc: Add module autoloading based on CPU features
  crypto: vmx - Convert to CPU feature based module autoloading

 arch/powerpc/Kconfig                  |  1 +
 arch/powerpc/include/asm/cpufeature.h | 70 +++++++++++++++++++++++++++++++++++
 drivers/crypto/vmx/Kconfig            |  2 +-
 drivers/crypto/vmx/vmx.c              |  6 +--
 4 files changed, 74 insertions(+), 5 deletions(-)
 create mode 100644 arch/powerpc/include/asm/cpufeature.h

-- 
2.7.4
