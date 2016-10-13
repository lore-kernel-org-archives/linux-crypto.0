From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] crypto: omap-sham - add support functions for sg based
 data handling
Date: Thu, 13 Oct 2016 12:31:47 +0300
Message-ID: <20161013093147.GA25189@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: t-kristo@ti.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19981 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753077AbcJMJcB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2016 05:32:01 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Tero Kristo,

This is a semi-automatic email about new static checker warnings.

The patch f19de1bc67a0: "crypto: omap-sham - add support functions 
for sg based data handling" from Sep 19, 2016, leads to the following 
Smatch complaint:

drivers/crypto/omap-sham.c:808 omap_sham_prepare_request()
	 warn: variable dereferenced before check 'req' (see line 801)

drivers/crypto/omap-sham.c
   800	{
   801		struct omap_sham_reqctx *rctx = ahash_request_ctx(req);
                                                                  ^^^
New dereference inside function.

   802		int bs;
   803		int ret;
   804		int nbytes;
   805		bool final = rctx->flags & BIT(FLAGS_FINUP);
   806		int xmit_len, hash_later;
   807	
   808		if (!req)
                    ^^^^
New check is too late.

   809			return 0;
   810	

regards,
dan carpenter
