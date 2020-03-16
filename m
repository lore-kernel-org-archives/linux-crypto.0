Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A211C0044D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 23:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3856A20679
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 23:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732855AbgCPXcR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 19:32:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732842AbgCPXcR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 19:32:17 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02GNL9S5073560;
        Mon, 16 Mar 2020 19:32:02 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yrtwu94kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Mar 2020 19:32:02 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02GNLFNL074028;
        Mon, 16 Mar 2020 19:32:01 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yrtwu94kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Mar 2020 19:32:01 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02GNUQYO014878;
        Mon, 16 Mar 2020 23:32:01 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 2yrpw68pe6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Mar 2020 23:32:01 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02GNVxGF27853172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 23:31:59 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 905756A051;
        Mon, 16 Mar 2020 23:31:59 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 191DE6A047;
        Mon, 16 Mar 2020 23:31:59 +0000 (GMT)
Received: from [9.70.82.143] (unknown [9.70.82.143])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 16 Mar 2020 23:31:58 +0000 (GMT)
Subject: Re: [PATCH v3 0/9] crypto/nx: Enable GZIP engine and provide
 userpace API
From:   Haren Myneni <haren@linux.ibm.com>
To:     Daniel Axtens <dja@axtens.net>
Cc:     herbert@gondor.apana.org.au, mpe@ellerman.id.au, mikey@neuling.org,
        sukadev@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, npiggin@gmail.com
In-Reply-To: <87y2s0o3i5.fsf@dja-thinkpad.axtens.net>
References: <1583540877.9256.24.camel@hbabu-laptop>
         <87y2s0o3i5.fsf@dja-thinkpad.axtens.net>
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 16 Mar 2020 16:31:39 -0700
Message-ID: <1584401499.9256.14460.camel@hbabu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-16_10:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003160094
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2020-03-17 at 00:04 +1100, Daniel Axtens wrote:
> Hi Haren,
> 
> If I understand correctly, to test these, I need to apply both this
> series and your VAS userspace page fault handling series - is that
> right?

Daniel, 

Yes, This patch series enables GZIP engine and provides user space API.
Whereas VAS fault handling series process faults if NX sees fault on
request buffer.  

selftest -
https://lists.ozlabs.org/pipermail/linuxppc-dev/2020-March/206035.html

or https://github.com/abalib/power-gzip/tree/develop/selftest

More tests are available - https://github.com/abalib/power-gzip

libnxz - https://github.com/libnxz/power-gzip  

Thanks
Haren

> 
> Kind regards,
> Daniel
> 
> > Power9 processor supports Virtual Accelerator Switchboard (VAS) which
> > allows kernel and userspace to send compression requests to Nest
> > Accelerator (NX) directly. The NX unit comprises of 2 842 compression
> > engines and 1 GZIP engine. Linux kernel already has 842 compression
> > support on kernel. This patch series adds GZIP compression support
> > from user space. The GZIP Compression engine implements the ZLIB and
> > GZIP compression algorithms. No plans of adding NX-GZIP compression
> > support in kernel right now.
> >
> > Applications can send requests to NX directly with COPY/PASTE
> > instructions. But kernel has to establish channel / window on NX-GZIP
> > device for the userspace. So userspace access to the GZIP engine is
> > provided through /dev/crypto/nx-gzip device with several operations.
> >
> > An application must open the this device to obtain a file descriptor (fd).
> > Using the fd, application should issue the VAS_TX_WIN_OPEN ioctl to
> > establish a connection to the engine. Once window is opened, should use
> > mmap() system call to map the hardware address of engine's request queue
> > into the application's virtual address space. Then user space forms the
> > request as co-processor Request Block (CRB) and paste this CRB on the
> > mapped HW address using COPY/PASTE instructions. Application can poll
> > on status flags (part of CRB) with timeout for request completion.
> >
> > For VAS_TX_WIN_OPEN ioctl, if user space passes vas_id = -1 (struct
> > vas_tx_win_open_attr), kernel determines the VAS instance on the
> > corresponding chip based on the CPU on which the process is executing.
> > Otherwise, the specified VAS instance is used if application passes the
> > proper VAS instance (vas_id listed in /proc/device-tree/vas@*/ibm,vas_id).
> >
> > Process can open multiple windows with different FDs or can send several
> > requests to NX on the same window at the same time.
> >
> > A userspace library libnxz is available:
> >         https://github.com/abalib/power-gzip
> >
> > Applications that use inflate/deflate calls can link with libNXz and use
> > NX GZIP compression without any modification.
> >
> > Tested the available 842 compression on power8 and power9 system to make
> > sure no regression and tested GZIP compression on power9 with tests
> > available in the above link.
> >
> > Thanks to Bulent Abali for nxz library and tests development.
> >
> > Changelog:
> > V2:
> >   - Move user space API code to powerpc as suggested. Also this API
> >     can be extended to any other coprocessor type that VAS can support
> >     in future. Example: Fast thread wakeup feature from VAS
> >   - Rebased to 5.6-rc3
> >
> > V3:
> >   - Fix sparse warnings (patches 3&6)
> >
> > Haren Myneni (9):
> >   powerpc/vas: Initialize window attributes for GZIP coprocessor type
> >   powerpc/vas: Define VAS_TX_WIN_OPEN ioctl API
> >   powerpc/vas: Add VAS user space API
> >   crypto/nx: Initialize coproc entry with kzalloc
> >   crypto/nx: Rename nx-842-powernv file name to nx-common-powernv
> >   crypto/NX: Make enable code generic to add new GZIP compression type
> >   crypto/nx: Enable and setup GZIP compresstion type
> >   crypto/nx: Remove 'pid' in vas_tx_win_attr struct
> >   Documentation/powerpc: VAS API
> >
> >  Documentation/powerpc/index.rst                    |    1 +
> >  Documentation/powerpc/vas-api.rst                  |  246 +++++
> >  Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
> >  arch/powerpc/include/asm/vas.h                     |   12 +-
> >  arch/powerpc/include/uapi/asm/vas-api.h            |   22 +
> >  arch/powerpc/platforms/powernv/Makefile            |    2 +-
> >  arch/powerpc/platforms/powernv/vas-api.c           |  290 +++++
> >  arch/powerpc/platforms/powernv/vas-window.c        |   23 +-
> >  arch/powerpc/platforms/powernv/vas.h               |    2 +
> >  drivers/crypto/nx/Makefile                         |    2 +-
> >  drivers/crypto/nx/nx-842-powernv.c                 | 1062 ------------------
> >  drivers/crypto/nx/nx-common-powernv.c              | 1133 ++++++++++++++++++++
> >  12 files changed, 1723 insertions(+), 1073 deletions(-)
> >  create mode 100644 Documentation/powerpc/vas-api.rst
> >  create mode 100644 arch/powerpc/include/uapi/asm/vas-api.h
> >  create mode 100644 arch/powerpc/platforms/powernv/vas-api.c
> >  delete mode 100644 drivers/crypto/nx/nx-842-powernv.c
> >  create mode 100644 drivers/crypto/nx/nx-common-powernv.c
> >
> > -- 
> > 1.8.3.1


