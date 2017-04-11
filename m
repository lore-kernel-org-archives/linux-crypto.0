From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] padata: simplify serialization mechanism
Date: Tue, 11 Apr 2017 12:16:01 +0300
Message-ID: <20170411091601.GA24844@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: steffen.klassert@secunet.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21931 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754211AbdDKJQO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Apr 2017 05:16:14 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Steffen Klassert,

The patch 5f1a8c1bc724: "padata: simplify serialization mechanism"
from Jul 7, 2010, leads to the following static checker warning:

	kernel/padata.c:243 padata_reorder()
	warn: 'padata' is an error pointer or valid

kernel/padata.c
   231          if (!spin_trylock_bh(&pd->lock))
   232                  return;
   233  
   234          while (1) {
   235                  padata = padata_get_next(pd);
   236  
   237                  /*
   238                   * All reorder queues are empty, or the next object that needs
   239                   * serialization is parallel processed by another cpu and is
   240                   * still on it's way to the cpu's reorder queue, nothing to
   241                   * do for now.
   242                   */
   243                  if (!padata || PTR_ERR(padata) == -EINPROGRESS)
                             ^^^^^^
The comments still say that we sometimes return NULL but we removed that
in 2010.

   244                          break;
   245  
   246                  /*
   247                   * This cpu has to do the parallel processing of the next
   248                   * object. It's waiting in the cpu's parallelization queue,
   249                   * so exit immediately.
   250                   */
   251                  if (PTR_ERR(padata) == -ENODATA) {
   252                          del_timer(&pd->timer);
   253                          spin_unlock_bh(&pd->lock);
   254                          return;
   255                  }

regards,
dan carpenter
