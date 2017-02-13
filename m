From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Qualcomm QCE driver: XTS setkey only allows 128 bit AES
Date: Mon, 13 Feb 2017 16:30:04 +0100
Message-ID: <1690729.u0Mf5VzSsv@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:56338 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752333AbdBMPaR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Feb 2017 10:30:17 -0500
Received: from tauon.atsec.com (mail.eperm.de [89.247.134.16])
        by mail.eperm.de (Postfix) with ESMTPSA id 59C62181CF33
        for <linux-crypto@vger.kernel.org>; Mon, 13 Feb 2017 16:30:05 +0100 (CET)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

The Qualcomm QCE driver implementation defines:

                .flags          = QCE_ALG_AES | QCE_MODE_XTS,
                .name           = "xts(aes)",
                .drv_name       = "xts-aes-qce",
                .blocksize      = AES_BLOCK_SIZE,
                .ivsize         = AES_BLOCK_SIZE,
                .min_keysize    = AES_MIN_KEY_SIZE,
                .max_keysize    = AES_MAX_KEY_SIZE,

and

        alg->cra_ablkcipher.min_keysize = def->min_keysize;
        alg->cra_ablkcipher.max_keysize = def->max_keysize;
        alg->cra_ablkcipher.setkey = qce_ablkcipher_setkey;

Thus, this driver has the limits of 128 to 256 bits for the key. Furthermore, 
the common setkey function is used.

May I ask how the key for AES XTS is supposed to be handled here considering 
that the kernel crypto API expects that the AES key and the tweak key is set 
via one setkey call. I.e. the setkey should expect 256 through 512 bits.

Thanks.

Ciao
Stephan
