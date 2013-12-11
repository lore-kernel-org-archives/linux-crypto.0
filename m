From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: crypto: ccp - CCP SHA crypto API support
Date: Wed, 11 Dec 2013 13:51:50 +0300
Message-ID: <20131211105150.GA422@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: thomas.lendacky@amd.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37656 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3LKKvv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Dec 2013 05:51:51 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Tom Lendacky,

The patch 0ab0a1d505ab: "crypto: ccp - CCP SHA crypto API support"
from Nov 12, 2013, leads to the following static checker warning:
	drivers/crypto/ccp/ccp-crypto-sha.c:182 ccp_do_sha_update()
	warn: should 'rctx->hash_cnt << 3' be a 64 bit type?

drivers/crypto/ccp/ccp-crypto-sha.c
   180                  sg_mark_end(sg);
   181  
   182          rctx->msg_bits += (rctx->hash_cnt << 3);        /* Total in bits */
                                   ^^^^^^^^^^^^^^^^^^^
This operation wraps if the msg is over 500MB.  I'm not sure if that's
possible, but ->msg_bits is declared as a u64 here and in
rctx->cmd.u.sha.msg_bits as well.

   183  
   184          memset(&rctx->cmd, 0, sizeof(rctx->cmd));


regards,
dan carpenter
