From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] crypto: brcm - Add Broadcom SPU driver
Date: Tue, 14 Feb 2017 10:55:52 +0300
Message-ID: <20170214075552.GA27050@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: rob.rice@broadcom.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39783 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751830AbdBNH4S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 02:56:18 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Rob Rice,

The patch 9d12ba86f818: "crypto: brcm - Add Broadcom SPU driver" from
Feb 3, 2017, leads to the following static checker warning:

	drivers/crypto/bcm/cipher.c:2340 ahash_finup()
	warn: 'tmpbuf' was already freed.

drivers/crypto/bcm/cipher.c
  2316                  /* Copy data from req scatterlist to tmp buffer */
  2317                  gfp = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
  2318                         CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
  2319                  tmpbuf = kmalloc(req->nbytes, gfp);
  2320                  if (!tmpbuf) {
  2321                          ret = -ENOMEM;
  2322                          goto ahash_finup_exit;
  2323                  }
  2324  
  2325                  if (sg_copy_to_buffer(req->src, nents, tmpbuf, req->nbytes) !=
  2326                                  req->nbytes) {
  2327                          ret = -EINVAL;
  2328                          goto ahash_finup_free;
  2329                  }
  2330  
  2331                  /* Call synchronous update */
  2332                  ret = crypto_shash_finup(ctx->shash, tmpbuf, req->nbytes,
  2333                                           req->result);
  2334                  kfree(tmpbuf);
                        ^^^^^^^^^^^^^
  2335          } else {
  2336                  /* Otherwise call the internal function which uses SPU hw */
  2337                  return __ahash_finup(req);
  2338          }
  2339  ahash_finup_free:
  2340          kfree(tmpbuf);
                ^^^^^^^^^^^^^
I'm only working a 30 minutes per day to keep a hand in.  I'm not
sending patches this month.

  2341  
  2342  ahash_finup_exit:
  2343          /* Done with hash, can deallocate it now */
  2344          crypto_free_shash(ctx->shash->tfm);
  2345          kfree(ctx->shash);
  2346          return ret;
  2347  }

regards,
dan carpenter
