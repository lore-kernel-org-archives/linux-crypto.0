From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] crypto: cavium - Add the Virtual Function driver for CPT
Date: Wed, 15 Feb 2017 11:39:09 +0300
Message-ID: <20170215083909.GA12892@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: george.cherian@cavium.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23040 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750817AbdBOIj0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Feb 2017 03:39:26 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello George Cherian,

This is a semi-automatic email about new static checker warnings.

The patch c694b233295b: "crypto: cavium - Add the Virtual Function 
driver for CPT" from Feb 7, 2017, leads to the following Smatch 
complaint:

drivers/crypto/cavium/cpt/cptvf_reqmanager.c:333 do_post_process()
	 warn: variable dereferenced before check 'cptvf' (see line 331)

drivers/crypto/cavium/cpt/cptvf_reqmanager.c
   330	{
   331		struct pci_dev *pdev = cptvf->pdev;
                                       ^^^^^^^^^^^
Dereference.

   332	
   333		if (!info || !cptvf) {
                              ^^^^^
Check is too late.

   334			dev_err(&pdev->dev, "Input params are incorrect for post processing\n");
   335			return;

regards,
dan carpenter
