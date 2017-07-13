From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] Crypto_user: Make crypto user API available for all net ns
Date: Thu, 13 Jul 2017 16:51:10 +0200
Message-ID: <2290757.F5Nm8BLmaV@tauon.chronox.de>
References: <692d6ab1-d737-2683-5e55-b5f838f99b01@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Christian Langrock <christian.langrock@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60496 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751193AbdGMOvW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jul 2017 10:51:22 -0400
In-Reply-To: <692d6ab1-d737-2683-5e55-b5f838f99b01@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 13. Juli 2017, 16:22:32 CEST schrieb Christian Langrock:

Hi Christian,

> With this patch it's possible to use crypto user API form all
> network namespaces, not only form the initial net ns.

Is this wise?

The crypto_user interface allows root users to change settings in the kernel 
with a global scope. For example, you can deregister ciphers, change the prio 
of ciphers and so on. All of that is visible on a global scale and thus should 
not be possible from namespaces, IMHO.

Ciao
Stephan
