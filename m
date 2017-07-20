From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] crypto: atmel-ecc - introduce Microchip / Atmel ECC
 driver
Date: Thu, 20 Jul 2017 12:41:40 +0300
Message-ID: <20170720094140.3y36xergecw6eysj@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: tudor.ambarus@microchip.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27435 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934105AbdGTJlt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jul 2017 05:41:49 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Tudor-Dan Ambarus,

The patch 11105693fa05: "crypto: atmel-ecc - introduce Microchip /
Atmel ECC driver" from Jul 5, 2017, leads to the following static
checker warning:

	drivers/crypto/atmel-ecc.c:281 atmel_ecdh_done()
	warn: assigning (-22) to unsigned variable 'status'

drivers/crypto/atmel-ecc.c
   265  static void atmel_ecdh_done(struct atmel_ecc_work_data *work_data, void *areq,
   266                              u8 status)
   267  {
   268          struct kpp_request *req = areq;
   269          struct atmel_ecdh_ctx *ctx = work_data->ctx;
   270          struct atmel_ecc_cmd *cmd = &work_data->cmd;
   271          size_t copied;
   272          size_t n_sz = ctx->n_sz;
   273  
   274          if (status)
   275                  goto free_work_data;
   276  
   277          /* copy the shared secret */
   278          copied = sg_copy_from_buffer(req->dst, 1, &cmd->data[RSP_DATA_IDX],
   279                                       n_sz);
   280          if (copied != n_sz)
   281                  status = -EINVAL;
                        ^^^^^^^^^^^^^^^^
status is a u8.

   282  
   283          /* fall through */
   284  free_work_data:
   285          kzfree(work_data);
   286          kpp_request_complete(req, status);
   287  }

regards,
dan carpenter
