From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: CRYPTO_MAX_ALG_NAME is too low
Date: Fri, 10 Mar 2017 12:55:11 +0100
Message-ID: <e96825bd-4e1d-c6c1-160e-0dc10f7f3981@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0101.outbound.protection.outlook.com ([104.47.2.101]:20512
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933104AbdCJLzS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Mar 2017 06:55:18 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello crypto maintainers!

We've found and example of the ipsec algorithm combination, which doesn't fit
into CRYPTO_MAX_ALG_NAME long buffers:

ip x s add src 1.1.1.1 dst 1.1.1.2 proto esp spi 0 mode tunnel enc des3_ede 0x0 auth sha256 0x0 flag esn replay-window 256

produces "echainiv(authencesn(hmac(sha256-generic),cbc(des3_ede-generic)))"
on the machines without optimized crypto drivers, which doesn't fit into current
64-bytes buffers.

I see two possible options:

a) split CRYPTO_MAX_ALG_NAME into CRYPTO_MAX_ALG_NAME + CRYPTO_MAX_DRV_NAME pair
and make later, say, 96, because the former probably cannot be changed because of
numerous user-space exports. And change half of the code to use new define.

b) rename *-generic algorithms to *-gen, so that cra_driver_name will be shortened,
while MODULE_ALIAS_CRYPTO() could still be maintained in old and new form.

What are your thoughts?

-- 
Best regards,
Alexander Sverdlin.
