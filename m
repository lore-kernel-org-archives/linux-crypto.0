From: Junaid Shahid <junaids@google.com>
Subject: [PATCH v3 0/2] Fix out-of-bounds memory accesses in generic-gcm-aesni
Date: Wed, 20 Dec 2017 17:08:36 -0800
Message-ID: <20171221010838.54243-1-junaids@google.com>
Cc: linux-crypto@vger.kernel.org, andreslc@google.com,
        davem@davemloft.net, gthelen@google.com, ebiggers3@gmail.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:45150 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757120AbdLUBIn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 20:08:43 -0500
Received: by mail-io0-f193.google.com with SMTP id e204so19282130iof.12
        for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2017 17:08:43 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changelog:
v3:
- Fixed a bug in READ_PARTIAL_BLOCK when used for reading the AAD
- Some refactoring per CR feedback
v2:
- Also fixed issue 2 described below
v1:
- Fixed issue 1 described below        

The aesni_gcm_enc/dec functions can access memory before the start or end of
the supplied src buffer. This can happen if either:

1. The data length is less than 16 bytes and there is no AAD or the AAD
   length is not enough to cover the underrun. In this case, memory before
   the start of the buffer would be accessed.
2. The AAD length is not a multiple of 4 bytes and the data length is too
   small to cover the overrun. In this case, memory after the end of the
   buffer would be accessed.

This was not a problem when rfc4106-gcm-aesni was the only mode supported by
the aesni module, as in that case there is always enough AAD and IV bytes to
cover the out-of-bounds accesses. However, that is no longer the case with
the generic-gcm-aesni mode. This could potentially result in accessing pages
that are not mapped, thus causing a crash.


Junaid Shahid (2):
  crypto: Fix out-of-bounds access of the data buffer in
    generic-gcm-aesni
  crypto: Fix out-of-bounds access of the AAD buffer in
    generic-gcm-aesni

 arch/x86/crypto/aesni-intel_asm.S | 199 +++++++++++---------------------------
 1 file changed, 57 insertions(+), 142 deletions(-)

-- 
2.15.1.620.gb9897f4670-goog
