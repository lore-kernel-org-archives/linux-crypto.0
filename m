From: Abed Kamaluddin <abedamu@gmail.com>
Subject: [RFC PATCH v1 0/1] *** crypto: AF_ALG: add compression support ***
Date: Fri, 14 Apr 2017 00:04:53 +0530
Message-ID: <1492108494-10694-1-git-send-email-akamaluddin@cavium.com>
Cc: akamaluddin@cavium.com, pathreya@cavium.com, machalla@cavium.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:32875 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755716AbdDMSfN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Apr 2017 14:35:13 -0400
Received: by mail-pf0-f193.google.com with SMTP id c198so12189791pfc.0
        for <linux-crypto@vger.kernel.org>; Thu, 13 Apr 2017 11:35:13 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

This patch adds compression support to the AF_ALG interface exported by the 
kernel crypto API. By extending AF_ALG, all compression algorithms of types 
scomp and acomp, which the kernel crypto API allows access to, are now also
accessible from userspace.

The new compression interface has been tested with both kernel software
deflate(scomp) and HW accelerated ThunderX deflate(scomp) using the zpipe
example application provided by zlib.

The user-space side would look similar to hash/cipher implementations.

struct sockaddr_alg sa = {
    .salg_family = AF_ALG,
    .salg_type = "compression",
    .salg_name = "deflate"
};

The operations supported are ALG_OP_DECOMPRESS and ALG_OP_COMPRESS. This
interface is synchronous and handles one request at a time. The data for
compression/decompression is read in sendmsg and all operations are carried
out and completed in recvmsg.

This interface can utilize full deflate functionality provided by kernel.
However to achieve complete zlib functionality in user space, the acomp
interface needs to be modified and provide api's to pass context and additional
data between the kernel user and algorithm as has been pointed on a different
thread.

Patches have been generated on top of "kernel/git/herbert/crypto-2.6.git" repo.

Abed Kamaluddin (1):
  crypto: algif_compression - User-space interface for compression

 crypto/Kconfig              |  11 ++
 crypto/Makefile             |   1 +
 crypto/algif_compression.c  | 272 ++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/if_alg.h |   2 +
 4 files changed, 286 insertions(+)
 create mode 100644 crypto/algif_compression.c

-- 
2.7.4
