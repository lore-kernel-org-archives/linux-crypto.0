From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Who will copy the AAD data to dest. buffer
Date: Fri, 2 Sep 2016 20:05:04 +0530
Message-ID: <CAFXBA=m-Ued+9EGmfwa210cm6HZGxN3P-g_Fsapzcw+a3FKdZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35623 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753332AbcIBOfF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Sep 2016 10:35:05 -0400
Received: by mail-oi0-f43.google.com with SMTP id p186so128450316oia.2
        for <linux-crypto@vger.kernel.org>; Fri, 02 Sep 2016 07:35:05 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Is copy of AAD data to destination buffer when dst != src is mandatory
requirements for crypto drivers or we can skip this copy. Actually I
am bit confused, In following link Stephen had mentioned caller will
memcpy the AAD to destination buffer but authenc.c also copies the AAD
to dest. buffer.

http://www.chronox.de/libkcapi/html/ch02s02.html

Secondly When AAD data remains unchanged in AEAD encryption/decryption
operations. Why we copy the same data to destination buffer?

Thanks & Regards
Harsh Jain
