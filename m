From: Junaid Shahid <junaids@google.com>
Subject: [PATCH v3 0/4] crypto: aesni - Use zero-copy for gcm(aes) buffers that are partially contiguous
Date: Wed, 31 Jan 2018 12:27:18 -0800
Message-ID: <20180131202722.212273-1-junaids@google.com>
Cc: linux-crypto@vger.kernel.org, andreslc@google.com,
        davem@davemloft.net, gthelen@google.com, ebiggers3@gmail.com,
        smueller@chronox.de
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:46306 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751812AbeAaU10 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 15:27:26 -0500
Received: by mail-pf0-f194.google.com with SMTP id w69so354723pfd.13
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jan 2018 12:27:26 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changes in v3:
- Rebased on top of the latest linux-next
Changes in v2:
- Integrated https://patchwork.kernel.org/patch/10173981

Currently, the AESNI gcm(aes) implementation uses zero-copy only when the
entire src and dest request buffers, including the AAD, the data and the
Auth Tag are contiguous. This series enables the use of zero-copy even if the
AAD and/or Auth Tag are in different buffers than the actual data, as long as
each of them individually satisfies the zero-copy conditions (i.e. the entire
buffer is either in low-mem or within a single high-mem page). Furthermore,
it also enables the use of zero-copy even if only one of src and dest satisfies
these conditions rather than only when both of them do.

Junaid Shahid (4):
  crypto: aesni - Fix out-of-bounds access of the AAD buffer in AVX
    gcm-aesni
  crypto: aesni - Enable one-sided zero copy for gcm(aes) request
    buffers
  crypto: aesni - Directly use kmap_atomic instead of scatter_walk
    object in gcm(aes)
  crypto: aesni - Use zero-copy for gcm(aes) even if the
    AAD/Data/AuthTag are separate

 arch/x86/crypto/aesni-intel_avx-x86_64.S | 154 +++++-----------
 arch/x86/crypto/aesni-intel_glue.c       | 307 +++++++++++++++++++------------
 2 files changed, 227 insertions(+), 234 deletions(-)

-- 
2.16.0.rc1.238.g530d649a79-goog
