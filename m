From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] chcr: Add support for Inline IPSec
Date: Mon, 4 Dec 2017 14:44:24 +0300
Message-ID: <20171204114424.uibic3nesyzdp3zc@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: atul.gupta@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53134 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752963AbdLDLod (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Dec 2017 06:44:33 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Atul Gupta,

The patch 6dad4e8ab3ec: "chcr: Add support for Inline IPSec" from Nov
16, 2017, leads to the following static checker warning:

	drivers/crypto/chelsio/chcr_ipsec.c:431 copy_key_cpltx_pktxt()
	warn: potential pointer math issue ('q->q.desc' is a 512 bit pointer)

drivers/crypto/chelsio/chcr_ipsec.c
   419  
   420          if (likely(len <= left)) {
   421                  memcpy(key_ctx->key, sa_entry->key, key_len);
   422                  pos += key_len;
   423          } else {
   424                  if (key_len <= left) {
   425                          memcpy(pos, sa_entry->key, key_len);
   426                          pos += key_len;
   427                  } else {
   428                          memcpy(pos, sa_entry->key, left);
   429                          memcpy(q->q.desc, sa_entry->key + left,
   430                                 key_len - left);
   431                          pos = q->q.desc + (key_len - left);
                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This does look like a pointer math issue.  It should probably be:

				pos = (u8 *)q->q.desc + (key_len - left);

But I can't test this.

   432                  }
   433          }
   434          /* Copy CPL TX PKT XT */
   435          pos = copy_cpltx_pktxt(skb, dev, pos);

regards,
dan carpenter
