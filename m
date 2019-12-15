Return-Path: <SRS0=cN8K=2F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2BFC43603
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Dec 2019 12:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 793292054F
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Dec 2019 12:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbfLOMxA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Dec 2019 07:53:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47170 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726135AbfLOMw7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Dec 2019 07:52:59 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBFCqAlZ095443;
        Sun, 15 Dec 2019 07:52:32 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wwdpx38pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 07:52:31 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xBFCqVQ4096177;
        Sun, 15 Dec 2019 07:52:31 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wwdpx38pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 07:52:31 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBFCoXdE009159;
        Sun, 15 Dec 2019 12:52:30 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04dal.us.ibm.com with ESMTP id 2wvqc5x5y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 12:52:30 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBFCqTrd52560196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Dec 2019 12:52:29 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBF52AC059;
        Sun, 15 Dec 2019 12:52:29 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D90CAC062;
        Sun, 15 Dec 2019 12:52:29 +0000 (GMT)
Received: from [9.70.82.143] (unknown [9.70.82.143])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 15 Dec 2019 12:52:28 +0000 (GMT)
Subject: [PATCH 00/10] crypto/nx: Enable GZIP engine and provide userpace
 API
From:   Haren Myneni <haren@linux.ibm.com>
To:     herbert@gondor.apana.org.au, mpe@ellerman.id.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        hch@infradead.org, npiggin@gmail.com, mikey@neuling.org
Cc:     sukadev@linux.vnet.ibm.com, hbabu@us.ibm.com
Content-Type: text/plain; charset="UTF-8"
Date:   Sun, 15 Dec 2019 04:50:39 -0800
Message-ID: <1576414240.16318.4066.camel@hbabu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-15_03:2019-12-13,2019-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 spamscore=0 clxscore=1011
 impostorscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912150123
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Power9 processor supports Virtual Accelerator Switchboard (VAS) which
allows kernel and userspace to send compression requests to Nest
Accelerator (NX) directly. The NX unit comprises of 2 842 compression
engines and 1 GZIP engine. Linux kernel already has 842 compression
support on kernel. This patch series adds GZIP compression support
from user space. The GZIP Compression engine implements the ZLIB and
GZIP compression algorithms. No plans of adding NX-GZIP compression
support in kernel right now.

Applications can send requests to NX directly with COPY/PASTE
instructions. But kernel has to establish channel / window on NX-GZIP
device for the userspace. So userspace access to the GZIP engine is
provided through /dev/crypto/nx-gzip device with several several
operations.

An application must open the this device to obtain a file descriptor (fd).
Using the fd, application should issue the VAS_TX_WIN_OPEN ioctl to
establish a connection to the engine. Once window is opened, should use
mmap() system call to map the hardware address of engine's request queue
into the application's virtual address space. Then user space forms the
request as co-processor Request Block (CRB) and paste this CRB on the
mapped HW address using COPY/PASTE instructions. Application can poll
on status flags (part of CRB) with timeout for request completion.

For VAS_TX_WIN_OPEN ioctl, if user space passes vas_id = -1 (struct
vas_tx_win_open_attr), kernel determins the VAS instance on the
corresponding chip based on the CPU on which the process is executing.
Otherwise, the specified VAS instance is used if application passes the
proper VAS instance (vas_id listed in /proc/device-tree/vas@*/ibm,vas_id).

Process can open multiple windows with different FDs or can send several
requests to NX on the same window at the same time.

A userspace library libnxz is available:
        https://github.com/abalib/power-gzip

Applications that use inflate/deflate calls can link with libNXz and use
NX GZIP compression without any modification.

Tested the available 842 compression on power8 and power9 system to make
sure no regression and tested GZIP compression on power9 with tests
available in the above link.

Thanks to Bulent Abali for nxz library and tests development.

Haren Myneni (10):
  powerpc/vas: Define vas_win_paste_addr()
  powerpc/vas: Initialize window attributes for GZIP coprocessor type
  powerpc/vas: Define VAS_TX_WIN_OPEN ioctl API
  crypto/nx: Initialize coproc entry with kzalloc
  crypto/nx: Organize powernv 842 code to add new GZIP compression type
  crypto/NX: Make code generic to add new GZIP compression type
  crypto/nx: Enable and setup GZIP compresstion type
  crypto/NX: Add NX GZIP user space API
  powerpc/vas: Remove 'pid' in vas_tx_win_attr struct
  Documentation/powerpc: VAS API

 Documentation/ioctl/ioctl-number.rst        |   1 +
 Documentation/powerpc/index.rst             |   1 +
 Documentation/powerpc/vas-api.rst           | 246 +++++++++++++++
 arch/powerpc/include/asm/vas.h              |   6 +-
 arch/powerpc/include/uapi/asm/vas-api.h     |  22 ++
 arch/powerpc/platforms/powernv/vas-window.c |  27 +-
 drivers/crypto/nx/Makefile                  |   2 +-
 drivers/crypto/nx/nx-842-powernv.c          | 412 +-----------------------
 drivers/crypto/nx/nx-842-powernv.h          |  31 ++
 drivers/crypto/nx/nx-commom-powernv.c       | 474 ++++++++++++++++++++++++++++
 drivers/crypto/nx/nx-gzip-powernv.c         | 282 +++++++++++++++++
 11 files changed, 1094 insertions(+), 410 deletions(-)
 create mode 100644 Documentation/powerpc/vas-api.rst
 create mode 100644 arch/powerpc/include/uapi/asm/vas-api.h
 create mode 100644 drivers/crypto/nx/nx-842-powernv.h
 create mode 100644 drivers/crypto/nx/nx-commom-powernv.c
 create mode 100644 drivers/crypto/nx/nx-gzip-powernv.c

-- 
1.8.3.1



