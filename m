From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/3] crypto: scompress - defer allocation of percpu scratch buffers
Date: Fri, 21 Jul 2017 16:42:35 +0100
Message-ID: <20170721154238.21697-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        giovanni.cabiddu@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34188 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbdGUPmy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 11:42:54 -0400
Received: by mail-wm0-f44.google.com with SMTP id l81so4489897wmg.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jul 2017 08:42:53 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a followup to 'crypto: scompress - eliminate percpu scratch buffers',
which attempted to replace the scompress per-CPU buffer entirely, but as
Herbert pointed out, this is not going to fly in the targeted use cases.

Instead, move the alloc/free of the buffers into the tfm init/exit hooks,
so that we only have the per-CPU buffers allocated if their are any
acomp ciphers of the right kind (i.e, ones that encapsulate a synchronous
implementation) in use (#3)

Patches #1 and #2 are fixes for issues I spotted when working on this code.

Ard Biesheuvel (3):
  crypto: scompress - don't sleep with preemption disabled
  crypto: scompress - free partially allocated scratch buffers on
    failure
  crypto: scompress - defer allocation of scratch buffer to first use

 crypto/scompress.c | 55 ++++++++------------
 1 file changed, 22 insertions(+), 33 deletions(-)

-- 
2.11.0
