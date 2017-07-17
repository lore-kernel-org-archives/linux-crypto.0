From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH V2 0/6] Enable NX 842 compression engine on Power9
Date: Mon, 17 Jul 2017 16:43:19 -0700
Message-ID: <1500334999.995.6.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: ddstreet@ieee.org, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, benh@kernel.crashing.org,
        mikey@neuling.org, suka@us.ibm.com, hbabu@us.ibm.com
To: mpe@ellerman.id.au, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60031 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751427AbdGQXn3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 19:43:29 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6HNdZ37082864
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jul 2017 19:43:29 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bs1svmtpv-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jul 2017 19:43:29 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Mon, 17 Jul 2017 19:43:27 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


[PATCH V2 0/6] Enable NX 842 compression engine on Power9

P9 introduces Virtual Accelerator Switchboard (VAS) to communicate
with NX 842 engine. icswx function is used to access NX before.
On powerNV systems, NX-842 driver invokes VAS functions for
configuring RxFIFO (receive window) per each NX engine. VAS uses
this FIFO to communicate the request to NX. The kernel opens send
window which is used to transfer compression/decompression requests
to VAS. It maps the send window to the corresponding RxFIFO.
copy/paste instructions are used to pass the CRB to VAS.

This patch series adds P9 NX support for 842 compression engine.
First 4 patches reorganize the current code so that VAS function
can be added.
- nx842_powernv_function points to VAS function if VAS feature is
  available. Otherwise icswx function is used.
- Move configure CRB code nx842_cfg_crb() 
- In addition to freeing co-processor structs for initialization 
  failures and exit, both send and receive windows have to closed
  for VAS.
- Move updating coprocessor info list to nx842_add_coprocs_list().

The last 2 patches adds configuring and invoking VAS, and also
checking P9 NX specific errors that are provided in co-processor
status block (CSB) for failures.

Patches have been tested on P9 DD1 system using VAS changes and
on P8 HW to make sure no regression.

This patchset depends on VAS kernel changes:
https://lists.ozlabs.org/pipermail/linuxppc-dev/2017-May/158178.html

Thanks to Sukadev Bhattiprolu for his review, input and testing with
VAS changes. Also thanks to Michael Ellerman and Benjamin Herrenschmidt
for their valuable guidance and comments.

Changelog[v2]
	- Open/close send windows in nx842_poernv_crypto_init/exit_vas().
	- Changes for the new device-tree NX properties such as priority
	  and compatible properties.
	- Incorporate review comments from Michael Ellerman.
	- Other minor issues found during HW testing.

Haren Myneni (6):
  crypto/nx842: Rename nx842_powernv_function as icswx function
  crypto/nx: Create nx842_configure_crb function
  crypto/nx: Create nx842_delete_coprocs function
  crypto/nx: Add nx842_add_coprocs_list function
  crypto/nx: Add P9 NX specific error codes for 842 engine
  crypto/nx: Add P9 NX support for 842 compression engine.

 arch/powerpc/include/asm/icswx.h   |   3 +
 drivers/crypto/nx/Kconfig          |   1 +
 drivers/crypto/nx/nx-842-powernv.c | 499 +++++++++++++++++++++++++++++++++----
 drivers/crypto/nx/nx-842.c         |   2 +-
 drivers/crypto/nx/nx-842.h         |   8 +
 5 files changed, 465 insertions(+), 48 deletions(-)

-- 
2.11.0
