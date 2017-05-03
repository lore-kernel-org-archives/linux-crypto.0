From: Harsh Jain <harshjain.prof@gmail.com>
Subject: BUG: drbg: Added nodes from Stack Memory in link list
Date: Wed, 3 May 2017 18:17:24 +0530
Message-ID: <CAFXBA=kDqH_32bX8XpUes9bdPP-3Gq5KRGBxu_FXKD3jwgzVdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36695 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752280AbdECMrb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 May 2017 08:47:31 -0400
Received: by mail-wm0-f54.google.com with SMTP id u65so145449659wmu.1
        for <linux-crypto@vger.kernel.org>; Wed, 03 May 2017 05:47:25 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephen,

In drbg driver local variable of function are added as list nodes. one
instance is given below.


static inline int __init drbg_healthcheck_sanity(void)



---
---

max_addtllen = drbg_max_addtl(drbg);
max_request_bytes = drbg_max_request_bytes(drbg);
drbg_string_fill(&addtl, buf, max_addtllen + 1);
/* overflow addtllen with additonal info string */
len = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);

===> Added "addtllist"  to the tail. which local variable.


BUG_ON(0 < len);
/* overflow max_bits */
len = drbg_generate(drbg, buf, (max_request_bytes + 1), NULL);
BUG_ON(0 < len);

/* overflow max addtllen with personalization string */
ret = drbg_seed(drbg, &addtl, false);

====> Added "seedlist" to the tail of same list. Previous
node(addtllist) already invalid(Out of scope when function returns)


BUG_ON(0 == ret);
/* all tests passed */
rc = 0;



Is't a BUG? or I missed something.


Regards
Harsh Jain
