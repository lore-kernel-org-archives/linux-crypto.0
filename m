From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] crypto: cavium - Add the Virtual Function driver for CPT
Date: Thu, 16 Feb 2017 23:18:11 +0300
Message-ID: <20170216201811.GA4898@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: george.cherian@cavium.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48789 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932740AbdBPUS7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2017 15:18:59 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello George Cherian,

This is a semi-automatic email about new static checker warnings.

The patch c694b233295b: "crypto: cavium - Add the Virtual Function
driver for CPT" from Feb 7, 2017, leads to the following Smatch
complaint:

drivers/crypto/cavium/cpt/cptvf_main.c:899 cptvf_remove()
	 error: we previously assumed 'cptvf' could be null (see line 895)

drivers/crypto/cavium/cpt/cptvf_main.c
   894	
   895		if (!cptvf)
                     ^^^^^
Check for NULL.

   896			dev_err(&pdev->dev, "Invalid CPT-VF device\n");
   897	
   898		/* Convey DOWN to PF */
   899		if (cptvf_send_vf_down(cptvf)) {
                                       ^^^^^
Oops inside function.

   900			dev_err(&pdev->dev, "PF not responding to DOWN msg");
   901		} else {

regards,
dan carpenter
