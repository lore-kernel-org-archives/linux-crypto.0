From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] crypto: ccp - Let a v5 CCP provide the same function as
 v3
Date: Wed, 12 Oct 2016 11:19:43 +0300
Message-ID: <20161012081942.GA4766@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: gary.hook@amd.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19183 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754680AbcJLIUB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Oct 2016 04:20:01 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Gary R Hook,

The patch 4b394a232df7: "crypto: ccp - Let a v5 CCP provide the same
function as v3" from Jul 26, 2016, leads to the following static
checker warning:

	drivers/crypto/ccp/ccp-dev-v5.c:30 ccp_lsb_alloc()
	warn: always true condition '(cmd_q->lsb >= 0) => (0-u32max >= 0)'

drivers/crypto/ccp/ccp-dev-v5.c
    24  static u32 ccp_lsb_alloc(struct ccp_cmd_queue *cmd_q, unsigned int count)
    25  {
    26          struct ccp_device *ccp;
    27          int start;
    28  
    29          /* First look at the map for the queue */
    30          if (cmd_q->lsb >= 0) {
                    ^^^^^^^^^^^^^^^

->lsb is a u32 so this is always true.

    31                  start = (u32)bitmap_find_next_zero_area(cmd_q->lsbmap,
    32                                                          LSB_SIZE,
    33                                                          0, count, 0);
    34                  if (start < LSB_SIZE) {
    35                          bitmap_set(cmd_q->lsbmap, start, count);
    36                          return start + cmd_q->lsb * LSB_SIZE;
    37                  }
    38          }
    39  
    40          /* No joy; try to get an entry from the shared blocks */
    41          ccp = cmd_q->ccp;
    42          for (;;) {
    43                  mutex_lock(&ccp->sb_mutex);
    44  
    45                  start = (u32)bitmap_find_next_zero_area(ccp->lsbmap,
    46                                                          MAX_LSB_CNT * LSB_SIZE,
    47                                                          0,
    48                                                          count, 0);
    49                  if (start <= MAX_LSB_CNT * LSB_SIZE) {
    50                          bitmap_set(ccp->lsbmap, start, count);
    51  
    52                          mutex_unlock(&ccp->sb_mutex);
    53                          return start * LSB_ITEM_SIZE;
    54                  }
    55  
    56                  ccp->sb_avail = 0;
    57  
    58                  mutex_unlock(&ccp->sb_mutex);
    59  
    60                  /* Wait for KSB entries to become available */
    61                  if (wait_event_interruptible(ccp->sb_queue, ccp->sb_avail))
    62                          return 0;
    63          }
    64  }


regards,
dan carpenter
