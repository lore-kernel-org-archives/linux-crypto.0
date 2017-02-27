From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH 0/2] Propagate fallback bit for cbc and ctr
Date: Sun, 26 Feb 2017 22:03:17 -0300
Message-ID: <1488157399-3587-1-git-send-email-marcelo.cerri@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:34637 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbdB0BDn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Feb 2017 20:03:43 -0500
Received: by mail-qk0-f173.google.com with SMTP id s186so75959129qkb.1
        for <linux-crypto@vger.kernel.org>; Sun, 26 Feb 2017 17:03:42 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

These are similar changes for cbc and ctr as the one you did for xts. They
rely on the helper function you created.

I confirmed that for vmx-crypto those changes cause the driver to allocate
"cbc(aes-generic)" and "ctr(aes-generic)" as fallbacks instead of
"cbc(p8_aes)" and "ctr(p8_aes)".

If you are ok with those changes, I can convert the remaining templates.

Marcelo Henrique Cerri (2):
  crypto: cbc - Propagate NEED_FALLBACK bit
  crypto: ctr - Propagate NEED_FALLBACK bit

 crypto/cbc.c | 20 ++++++++++++++------
 crypto/ctr.c | 13 +++++++++++--
 2 files changed, 25 insertions(+), 8 deletions(-)

-- 
2.7.4
