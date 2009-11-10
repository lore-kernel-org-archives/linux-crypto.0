From: Sergey Mironov <ierton@gmail.com>
Subject: Bug in geode-aes.c ?
Date: Tue, 10 Nov 2009 17:00:31 +0300
Message-ID: <aa09d86e0911100600x79617b85je8e4bd52df37b0a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:59510 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbZKJOA1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Nov 2009 09:00:27 -0500
Received: by fxm21 with SMTP id 21so37223fxm.21
        for <linux-crypto@vger.kernel.org>; Tue, 10 Nov 2009 06:00:32 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello. I noticed strange thing in drivers/crypto/geode-aes.c (
function geode_setkey_cip() )

This code still the same in git://linux-arm.org/linux-2.6-stable.git
(tag v2.6.28-arm2)

Please, check.


 116 static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *key,
 117                 unsigned int len)
 118 {
...

/** BUG? Should it be 'op->fallback.cip' instead of 'op->fallback.blk' ?  **/

 138         op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
 139         op->fallback.blk->base.crt_flags |= (tfm->crt_flags &
CRYPTO_TFM_REQ_MASK);

...

 144                 tfm->crt_flags |=
(op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
 145         }
 146         return ret;

-- 
Thanks,
Sergey
