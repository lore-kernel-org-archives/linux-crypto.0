From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 00/16] crypto: AF_ALG - consolidation
Date: Mon, 31 Jul 2017 14:04:58 +0200
Message-ID: <4570630.RBIQc1aA22@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60884 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752198AbdGaMLk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 08:11:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

with the update of the algif_aead and algif_skcipher memory management,
a lot of code duplication has been introduced deliberately.

This patch set cleans up the low-hanging fruits. The cleanup of the
recvmsg RX SGL copy will come separately as this is not a simple copy
and paste operation.

Each patch was tested individually with libkcapi's test suite.

The patch set goes on top of patches "crypto: AF_ALG - return error code when
no data was processed" and "crypto: algif_aead - copy AAD from src to dst".

Stephan Mueller (16):
  crypto: AF_ALG - consolidation of common data structures
  crypto: AF_ALG - consolidation of context data structure
  crypto: AF_ALG - consolidate send buffer service functions
  crypto: AF_ALG - consolidate RX buffer service functions
  crypto: AF_ALG - consolidate TX SGL allocation
  crypto: AF_ALG - consolidate counting TX SG entries
  crypto: AF_ALG - consolidate counting TX SG entries
  crypto: AF_ALG - consolidate freeing TX/RX SGLs
  crypto: AF_ALG - consolidate waiting for wmem
  crypto: AF_ALG - consolidate waking up on writable memory
  crypto: AF_ALG - consolidate waiting for TX data
  crypto: AF_ALG - consolidate waking up caller for TX data
  crypto: AF_ALG - consolidate sendmsg implementation
  crypto: AF_ALG - consolidate sendpage implementation
  crypto: AF_ALG - consolidate AIO callback handler
  crypto: AF_ALG - consolidate poll syscall handler

 crypto/af_alg.c         | 597 ++++++++++++++++++++++++++++++++++++++++++++
 crypto/algif_aead.c     | 641 +++---------------------------------------------
 crypto/algif_skcipher.c | 585 +++----------------------------------------
 include/crypto/if_alg.h | 163 ++++++++++++
 4 files changed, 830 insertions(+), 1156 deletions(-)

-- 
2.13.3
