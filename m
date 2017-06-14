From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: pkcs1pad and RSA e
Date: Wed, 14 Jun 2017 05:57:47 +0200
Message-ID: <68084916.If5LWl0jeS@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:61038 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750861AbdFOHt1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 03:49:27 -0400
Received: from positron.chronox.de (mail.eperm.de [89.247.134.16])
        by mail.eperm.de (Postfix) with ESMTPA id 00B33181607D
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jun 2017 09:49:24 +0200 (CEST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

during the preparation of the self-test patch for pkcs1pad, I noticed the 
following strange behavior:

I set an RSA private key with e=0x10001 to generate a signature. This 
generation process was successful and the expected signature was generated. 
Now, when using the very same TFM with the already set private key and perform 
a signature verification on the previously generated signature failed.

After some experiments, I found that I had to set e=0x0000000 ... 10001 where 
the size of e is equal to the size of n. Still, signature generation passed. 
And now, using the same TFM with the set private key, the signature 
verification passed too.

How come that there is a dissimilar handling of e regarding signature 
generation and verification?

Ciao
Stephan
