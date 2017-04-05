From: Rick Altherr <raltherr@google.com>
Subject: [PATCH v2 0/3] hw_random: timeriomem_rng: Migrate to new API and improve performance
Date: Wed,  5 Apr 2017 16:20:57 -0700
Message-ID: <20170405232100.2023-1-raltherr@google.com>
Cc: openbmc@lists.ozlabs.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: alex@digriz.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:33264 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752635AbdDEXVF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 19:21:05 -0400
Received: by mail-pg0-f47.google.com with SMTP id x125so18158583pgb.0
        for <linux-crypto@vger.kernel.org>; Wed, 05 Apr 2017 16:21:04 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

AST2400 can generate 32-bits of random data every 1us.  Original driver
was limited to one 32-bit read every jiffie due to deprecated API and use
of timers.  Migrating to new hwrng API and switching to hrtimers
improves read performance of /dev/hwrng to 13Mb/s.

Changes in v2:
- Split API migration into separate patch
- Split type and variable renames into separate patch
- Split performance improvements into separate patch

Rick Altherr (3):
  hw_random: Migrate timeriomem_rng to new API
  hw_random: timeriomem_rng: Shorten verbose type and variable names
  hw_random: timeriomem_rng: Improve performance for sub-jiffie update
    periods

 drivers/char/hw_random/timeriomem-rng.c | 157 ++++++++++++++++----------------
 1 file changed, 80 insertions(+), 77 deletions(-)

-- 
2.12.2.715.g7642488e1d-goog
