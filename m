Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10620C433ED
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Apr 2021 00:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB12D610D1
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Apr 2021 00:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbhDKA1o (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 10 Apr 2021 20:27:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48330 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234680AbhDKA1o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Apr 2021 20:27:44 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13B032Zx055868;
        Sat, 10 Apr 2021 20:27:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=ZVicdkFmKIjociamzdDcYungBNJAxkLfmmwLsu3SCUo=;
 b=FHjtAPT0NINNlBn8dP8HpHxVZjGxgPmuUpeo5uIPvR/WA5Ae8b6PUL4hUkVG4l/GE3le
 f7zjPldNXJZWjumrs9i1QrxvFv4qXBD6+wg9dcOxTYOc1fuvhLJ/bXNNchSqQWj4Ny5J
 a2WQ7hj5VZfxjPnsm4HoI2ay6nHzYOoCgmdlqgQXVvXhokkjZEtRHydWrcGgJWyH1u3u
 4CrKZguPJblaW39Nrp5HJDDt8PMdjIrcZNfTrz7svrjtuaOUZCr7px03ftH2m5eoIsnI
 grs+MqTEkE4O9dOSkQ7p54Lt3IKy16iVWblqUMaF5/s+LqcbhcrVRSrmpeJsjO5rMEW8 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ujq4txwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 10 Apr 2021 20:27:16 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13B0RFwX153674;
        Sat, 10 Apr 2021 20:27:15 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37ujq4txwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 10 Apr 2021 20:27:15 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13B0Bms7000926;
        Sun, 11 Apr 2021 00:27:14 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04wdc.us.ibm.com with ESMTP id 37u3n9d36f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 11 Apr 2021 00:27:14 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13B0RDe313632196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 00:27:13 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 319E1136051;
        Sun, 11 Apr 2021 00:27:13 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2F6013604F;
        Sun, 11 Apr 2021 00:27:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.232.48])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 11 Apr 2021 00:27:11 +0000 (GMT)
Message-ID: <b4631127bd025d9585246606c350ec88dbe1e99a.camel@linux.ibm.com>
Subject: [PATCH 00/16] Enable VAS and NX-GZIP support on powerVM
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     haren@linux.ibm.com, hbabu@us.ibm.com
Date:   Sat, 10 Apr 2021 17:27:09 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iYWixs0s8LrrSean84pfrO13SSvQSRaF
X-Proofpoint-GUID: mzFfs_yr4tweJw-FqNTI5vKp8arQoeld
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-10_07:2021-04-09,2021-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 clxscore=1011 impostorscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104100182
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


This patch series enables VAS / NX-GZIP on powerVM which allows
the user space to do copy/paste with the same existing interface
that is available on powerNV.

VAS Enablement:
- Get all VAS capabilities using H_QUERY_VAS_CAPABILITIES that are
  available in the hypervisor. These capabilities tells OS which
  type of features (credit types such as Default and Quality of
  Service (QoS)). Also gives specific capabilities for each credit
  type: Maximum window credits, Maximum LPAR credits, Target credits
  in that parition (varies from max LPAR credits based DLPAR
  operation), whether supports user mode COPY/PASTE and etc.
- Register LPAR VAS operations such as open window. get paste
  address and close window with the current VAS user space API.
- Open window operation - Use H_ALLOCATE_VAS_WINDOW HCALL to open
  window and H_MODIFY_VAS_WINDOW HCALL to setup the window with LPAR
  PID and etc.
- mmap to paste address returned in H_ALLOCATE_VAS_WINDOW HCALL
- To close window, H_DEALLOCATE_VAS_WINDOW HCALL is used to close in
  the hypervisor.

NX Enablement:
- Get NX capabilities from the the hypervisor which provides Maximum
  buffer length in a single GZIP request, recommended minimum
  compression / decompression lengths.
- Register to VAS to enable user space VAS API

Main feature differences with powerNV implementation:
- Each VAS window will be configured with a number of credits which
  means that many requests can be issues simultaniously on that
  window. On powerNV, 1K credits are configured per window.
  Whereas on powerVM, the hypervisor allows 1 credit per window
  at present.
- The hypervisor introduced 2 different types of credits: Default -
  Uses normal priority FIFO and Quality of Service (QoS) - Uses high
  priority FIFO. On powerVM, VAS/NX HW resources are shared across
  LPARs. The total number of credits available on a system depends
  on cores configured. We may see more credits are assigned across
  the system than the NX HW resources can handle. So to avoid NX HW
  contention, pHyp introduced QoS credits which can be configured
  by system administration with HMC API. Then the total number of
  available default credits on LPAR varies based on QoS credits
  configured.
- On powerNV, windows are allocated on a specific VAS instance
  and the user space can select VAS instance with the open window
  ioctl. Since VAS instances can be shared across partitions on
  powerVM, the hypervisor manages window allocations on different
  VAS instances. So H_ALLOCATE_VAS_WINDOW allows to select by domain
  indentifiers (H_HOME_NODE_ASSOCIATIVITY values by cpu). By default
  the hypervisor selects VAS instance closer to CPU resources that the
  parition uses. So vas_id in ioctl interface is ignored on powerVM
  except vas_id=-1 which is used to allocate window based on CPU that
  the process is executing. This option is needed for process affinity
  to NUMA node.

  The existing applications that linked with libnxz should work as
  long as the job request length is restricted to
  req_max_processed_len.

  Tested the following patches on P10 successfully with test cases
  given: https://github.com/libnxz/power-gzip

  Note: The hypervisor supports user mode NX from p10 onwards. Linux
	supports user mode VAS/NX on P10 only with radix page tables.

Patches 1- 4:   Make the code that is needed for both powerNV and
                powerVM to powerpc platform independent.
Patch5:         Modify vas-window struct to support both and the
                related changes.
Patch 6:        Define HCALL and the related VAS/NXGZIP specific
                structs.
Patch 7:        Define QoS credit flag in window open ioctl
Patch 8:        Implement Allocate, Modify and Deallocate HCALLs
Patch 9:        Retrieve VAS capabilities from the hypervisor
Patch 10;       Implement window operations and integrate with API
Patch 11:       Setup IRQ and NX fault handling
Patch 12;       Add sysfs interface to expose VAS capabilities
Patch 13 - 14:  Make the code common to add NX-GZIP enablement
Patch 15:       Get NX capabilities from the hypervisor
patch 16;       Add sysfs interface to expose NX capabilities

Haren Myneni (16):
  powerpc/powernv/vas: Rename register/unregister functions
  powerpc/vas: Make VAS API powerpc platform independent
  powerpc/vas: Create take/drop task reference functions
  powerpc/vas: Move update_csb/dump_crb to platform independent
  powerpc/vas:  Define and use common vas_window struct
  powerpc/pseries/vas: Define VAS/NXGZIP HCALLs and structs
  powerpc/vas: Define QoS credit flag to allocate window
  powerpc/pseries/vas: Implement allocate/modify/deallocate HCALLS
  powerpc/pseries/vas: Implement to get all capabilities
  powerpc/pseries/vas: Integrate API with open/close windows
  powerpc/pseries/vas: Setup IRQ and fault handling
  powerpc/pseries/vas: sysfs interface to export capabilities
  crypto/nx: Rename nx-842-pseries file name to nx-common-pseries
  crypto/nx: Register and unregister VAS interface
  crypto/nx: Get NX capabilities for GZIP coprocessor type
  crypto/nx: sysfs interface to export NX capabilities

 arch/powerpc/Kconfig                          |  15 +
 arch/powerpc/include/asm/hvcall.h             |   7 +
 arch/powerpc/include/asm/vas.h                | 122 +++-
 arch/powerpc/include/uapi/asm/vas-api.h       |   6 +-
 arch/powerpc/kernel/Makefile                  |   1 +
 arch/powerpc/kernel/vas-api.c                 | 485 +++++++++++++
 arch/powerpc/platforms/powernv/Kconfig        |  14 -
 arch/powerpc/platforms/powernv/Makefile       |   2 +-
 arch/powerpc/platforms/powernv/vas-api.c      | 278 --------
 arch/powerpc/platforms/powernv/vas-debug.c    |  12 +-
 arch/powerpc/platforms/powernv/vas-fault.c    | 155 +---
 arch/powerpc/platforms/powernv/vas-trace.h    |   6 +-
 arch/powerpc/platforms/powernv/vas-window.c   | 250 ++++---
 arch/powerpc/platforms/powernv/vas.h          |  42 +-
 arch/powerpc/platforms/pseries/Makefile       |   1 +
 arch/powerpc/platforms/pseries/vas-sysfs.c    | 173 +++++
 arch/powerpc/platforms/pseries/vas.c          | 674 ++++++++++++++++++
 arch/powerpc/platforms/pseries/vas.h          |  98 +++
 drivers/crypto/nx/Makefile                    |   2 +-
 drivers/crypto/nx/nx-common-powernv.c         |   6 +-
 .../{nx-842-pseries.c => nx-common-pseries.c} | 135 ++++
 21 files changed, 1885 insertions(+), 599 deletions(-)
 create mode 100644 arch/powerpc/kernel/vas-api.c
 delete mode 100644 arch/powerpc/platforms/powernv/vas-api.c
 create mode 100644 arch/powerpc/platforms/pseries/vas-sysfs.c
 create mode 100644 arch/powerpc/platforms/pseries/vas.c
 create mode 100644 arch/powerpc/platforms/pseries/vas.h
 rename drivers/crypto/nx/{nx-842-pseries.c => nx-common-pseries.c} (90%)

-- 
2.18.2


