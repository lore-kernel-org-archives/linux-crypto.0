From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] chcr: Support for Chelsio's Crypto Hardware
Date: Wed, 12 Oct 2016 09:13:01 +0300
Message-ID: <20161012061301.GL12841@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: hariprasad@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:30463 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753959AbcJLHAj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Oct 2016 03:00:39 -0400
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u9C6ENXK024782
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-crypto@vger.kernel.org>; Wed, 12 Oct 2016 06:14:23 GMT
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Hariprasad Shenai,

This is a semi-automatic email about new static checker warnings.

The patch 324429d74127: "chcr: Support for Chelsio's Crypto Hardware" 
from Aug 17, 2016, leads to the following Smatch complaint:

drivers/crypto/chelsio/chcr_algo.c:378 write_sg_data_page_desc()
	 error: we previously assumed 'sg' could be null (see line 376)

drivers/crypto/chelsio/chcr_algo.c
   375		while (count > 0) {
   376			if (sg && (!(sg->length)))
                            ^^
Check.

   377				break;
   378			spage = sg_page(sg);
                                ^^^^^^^^^^^
Unchecked dereference inside function.

   379			get_page(spage);
   380			page_len = min(sg->length, count);

regards,
dan carpenter
