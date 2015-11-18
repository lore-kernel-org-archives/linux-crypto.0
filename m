From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: crypto: sahara - check return value of sg_nents_for_len
Date: Thu, 19 Nov 2015 02:06:42 +0300
Message-ID: <20151118230642.GA29804@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: clabbe.montjoie@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40200 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbbKRXGu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Nov 2015 18:06:50 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello LABBE Corentin,

The patch 6c2b74d4774f: "crypto: sahara - check return value of
sg_nents_for_len" from Nov 4, 2015, leads to the following static
checker warning:

	drivers/crypto/sahara.c:480 sahara_hw_descriptor_create()
	warn: unsigned 'dev->nb_in_sg' is never less than zero.

drivers/crypto/sahara.c
   479          dev->nb_in_sg = sg_nents_for_len(dev->in_sg, dev->total);
   480          if (dev->nb_in_sg < 0) {
                    ^^^^^^^^^^^^^^^^^
Unsigned is never less than zero.

   481                  dev_err(dev->device, "Invalid numbers of src SG.\n");
   482                  return dev->nb_in_sg;
   483          }

There are several other similar bugs as well:

drivers/crypto/sahara.c:485 sahara_hw_descriptor_create() warn: unsigned 'dev->nb_out_sg' is never less than zero.
drivers/crypto/sahara.c:804 sahara_sha_hw_links_create() warn: unsigned 'dev->nb_in_sg' is never less than zero.
drivers/crypto/picoxcell_crypto.c:298 spacc_sg_to_ddt() warn: unsigned 'nents' is never less than zero.
drivers/crypto/picoxcell_crypto.c:338 spacc_aead_make_ddts() warn: unsigned 'src_nents' is never less than zero.
drivers/crypto/picoxcell_crypto.c:348 spacc_aead_make_ddts() warn: unsigned 'dst_nents' is never less than zero.

regards,
dan carpenter
