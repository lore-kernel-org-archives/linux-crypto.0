From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] crypto: ccp: Add Secure Encrypted Virtualization (SEV)
 command support
Date: Tue, 16 Jan 2018 13:57:23 +0300
Message-ID: <20180116105723.GA4755@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: brijesh.singh@amd.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:39540 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbeAPK5c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jan 2018 05:57:32 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Brijesh Singh,

The patch 200664d5237f: "crypto: ccp: Add Secure Encrypted
Virtualization (SEV) command support" from Dec 4, 2017, leads to the
following static checker warning:

	drivers/crypto/ccp/psp-dev.c:779 psp_pci_init()
	error: uninitialized symbol 'error'.

drivers/crypto/ccp/psp-dev.c
   764  void psp_pci_init(void)
   765  {
   766          struct sev_user_data_status *status;
   767          struct sp_device *sp;
   768          int error, rc;
   769  
   770          sp = sp_get_psp_master_device();
   771          if (!sp)
   772                  return;
   773  
   774          psp_master = sp->psp_data;
   775  
   776          /* Initialize the platform */
   777          rc = sev_platform_init(&error);
   778          if (rc) {
   779                  dev_err(sp->dev, "SEV: failed to INIT error %#x\n", error);
                                                                            ^^^^^
Generally not set on the error paths.

   780                  goto err;
   781          }
   782  
   783          /* Display SEV firmware version */

regards,
dan carpenter
