From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto: sha1-mb - remove HASH_FIRST flag
Date: Mon, 29 Jan 2018 17:09:08 -0800
Message-ID: <edd01e7e-3778-8b83-c81e-c7ce914828dd@linux.intel.com>
References: <20180125031008.778-1-ebiggers3@gmail.com>
 <b5918f68-e4d3-e98c-00eb-d54c2d6e3329@linux.intel.com>
 <20180125220340.l2t2v7jjc5dwoe43@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Megha Dey <megha.dey@linux.intel.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41231 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752316AbeA3BJJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jan 2018 20:09:09 -0500
In-Reply-To: <20180125220340.l2t2v7jjc5dwoe43@gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


>>
>> I suppose this will be okay as we are really doing the initialization in
>> sha1_mb_init.  Megha is now maintaining this code.  Copying her
>> so she can do some verification of this change.
>>
> 
> Please update the MAINTAINERS file so that people know who to Cc on patches.
> 
> Eric
> 

Herbert,

Can you pull in the patch below to update MAINTAINERS for sha multibuffer?

Tim

>From 884095fccd36d2de8c6edfe6f4d60ab4a1b9339b Mon Sep 17 00:00:00 2001
From: Tim Chen <tim.c.chen@linux.intel.com>
Date: Mon, 29 Jan 2018 09:22:41 -0800
Subject: [PATCH] x86/crypto: Designate maintainer for SHA-1/256/512
 multibuffer driver

Even though I created the original implementation of SHA1 multibuffer
driver, Megha extended it to SHA256 and SHA512 and she is now maintaining
the code for SHA1/SHA256/SHA512 multi-buffer driver.

Add the entry in the MAINTAINERS file so any update patch can find
its way properly to Megha.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2811a21..2085171 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7064,6 +7064,14 @@ L:	linux-rdma@vger.kernel.org
 S:	Supported
 F:	drivers/infiniband/hw/i40iw/
 
+INTEL SHA MULTIBUFFER DRIVER
+M:	Megha Dey <megha.dey@linux.intel.com>
+R:	Tim Chen <tim.c.chen@linux.intel.com>
+L:	linux-crypto@vger.kernel.org
+S:	Supported
+F:	arch/x86/crypto/sha*-mb
+F:	crypto/mcryptd.c
+
 INTEL TELEMETRY DRIVER
 M:	Souvik Kumar Chakravarty <souvik.k.chakravarty@intel.com>
 L:	platform-driver-x86@vger.kernel.org
-- 
2.7.4
