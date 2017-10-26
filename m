From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 0/4] Rearrange functions to remove forward declarations
Date: Thu, 26 Oct 2017 21:04:23 +0530
Message-ID: <20171026153427.22334-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, freude@linux.vnet.ibm.com,
        david.daney@cavium.com, clabbe.montjoie@gmail.com,
        linux-crypto@vger.kernel.org, mpm@selenic.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:44411 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932255AbdJZPfd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Oct 2017 11:35:33 -0400
Received: by mail-pf0-f196.google.com with SMTP id x7so2782503pfa.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Oct 2017 08:35:33 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series rearranges functions such that forward declarations
becomes unnecessary. Remove those forward declaration.

This patch series is boot tested without user space in qemu with
CONFIG_HW_RANDOM=y.

PrasannaKumar Muralidharan (4):
  hw_random: core: Remove forward declaration by rearranging code
  hw_random: core: Rearranging rng_get_data to remove forward
    declaration
  hw_random: core: Rearranging start_khwrngd to remove forward
    declaration
  hw_random: core: Remove forward declaration of hwrng_init

 drivers/char/hw_random/core.c | 151 ++++++++++++++++++++----------------------
 1 file changed, 72 insertions(+), 79 deletions(-)

-- 
2.10.0
