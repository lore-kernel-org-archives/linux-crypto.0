Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7728EB64DC
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jun 2023 10:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjFZKUq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jun 2023 06:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjFZKUp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jun 2023 06:20:45 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C247F1A1;
        Mon, 26 Jun 2023 03:20:43 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qDjKb-007JR3-QB; Mon, 26 Jun 2023 18:20:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 26 Jun 2023 18:20:25 +0800
Date:   Mon, 26 Jun 2023 18:20:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     oe-lkp@lists.linux.dev, lkp@intel.com,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
Subject: [PATCH] crypto: akcipher - Set request tfm on sync path
Message-ID: <ZJlmaarLRYZcs+c3@gondor.apana.org.au>
References: <202306261421.2ac744fa-oliver.sang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202306261421.2ac744fa-oliver.sang@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 26, 2023 at 03:07:01PM +0800, kernel test robot wrote:
>
> [    7.727242][    T1] cfg80211: Loading compiled-in X.509 certificates for regulatory database
> [    7.737831][    T1] BUG: kernel NULL pointer dereference, address: 00000010
> [    7.739122][    T1] #PF: supervisor read access in kernel mode
> [    7.740125][    T1] #PF: error_code(0x0000) - not-present page
> [    7.741135][    T1] *pdpt = 0000000000000000 *pde = f000ff53f000ff53
> [    7.742337][    T1] Oops: 0000 [#1]
> [    7.742986][    T1] CPU: 0 PID: 1 Comm: swapper Tainted: G S                 6.4.0-rc1-00077-g63ba4d67594a #2
> [    7.744804][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> [    7.746660][    T1] EIP: crypto_sig_verify+0x82/0xa4

---8<---
The request tfm needs to be set.

Fixes: addde1f2c966 ("crypto: akcipher - Add sync interface without SG lists")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202306261421.2ac744fa-oliver.sang@intel.com

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 152cfba1346c..8ffd31c44cf6 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -207,6 +207,7 @@ int crypto_akcipher_sync_prep(struct crypto_akcipher_sync_data *data)
 		return -ENOMEM;
 
 	data->req = req;
+	akcipher_request_set_tfm(req, data->tfm);
 
 	buf = (u8 *)(req + 1) + reqsize;
 	data->buf = buf;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
