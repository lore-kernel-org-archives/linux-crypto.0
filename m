From: "Yang, Pingchao" <pingchao.yang@intel.com>
Subject: RE: crypto: qat - add support for new devices to FW loader
Date: Fri, 11 Dec 2015 02:00:30 +0000
Message-ID: <CCF907412D2569469812043FCFD0B6FB4A52617B@SHSMSX103.ccr.corp.intel.com>
References: <20151210220304.GB21797@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: qat-linux <qat-linux@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40363 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbbLKCAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Dec 2015 21:00:33 -0500
In-Reply-To: <20151210220304.GB21797@mwanda>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Dan,

Yes, you are right. It should be left shift to check the AE ctx enable. Thanks for your defect, I will send  a patch to fix this issue.

Best Regards,
Pingchao yang


-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Friday, December 11, 2015 6:03 AM
To: Yang, Pingchao
Cc: qat-linux; linux-crypto@vger.kernel.org
Subject: re: crypto: qat - add support for new devices to FW loader

Hello Pingchao Yang,

The patch b0272276d903: "crypto: qat - add support for new devices to FW loader" from Dec 4, 2015, leads to the following static checker
warning:

	drivers/crypto/qat/qat_common/qat_hal.c:421 qat_hal_check_ae_active()
	warn: bitwise AND condition is false here

drivers/crypto/qat/qat_common/qat_hal.c
   414  int qat_hal_check_ae_active(struct icp_qat_fw_loader_handle *handle,
   415                              unsigned int ae)
   416  {
   417          unsigned int enable = 0, active = 0;
   418  
   419          qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES, &enable);
   420          qat_hal_rd_ae_csr(handle, ae, ACTIVE_CTX_STATUS, &active);
   421          if ((enable & (0xff >> CE_ENABLE_BITPOS)) ||
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Never true.
CE_ENABLE_BITPOS is 8.
Perhaps the intention was to left shift like we do with ACS_ABO_BITPOS on the next line?

   422              (active & (1 << ACS_ABO_BITPOS)))
   423                  return 1;
   424          else
   425                  return 0;
   426  }

regards,
dan carpenter
