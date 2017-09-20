From: Christophe LEROY <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 0/6] crypto: talitos - various fixes
Date: Wed, 20 Sep 2017 10:35:41 +0200
Message-ID: <d1a928d5-d5cd-baf6-a6bf-2375cce4b4a4@c-s.fr>
References: <cover.1505825623.git.christophe.leroy@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:12248 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751575AbdITIfn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2017 04:35:43 -0400
In-Reply-To: <cover.1505825623.git.christophe.leroy@c-s.fr>
Content-Language: fr
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Looks like the linux-crypto list and patchwork was out of order when I 
sent this. I will send again, sorry for the noise on the other lists.

Le 19/09/2017 à 14:58, Christophe Leroy a écrit :
> This serie provide various fixes on the talitos driver.
> 
> Christophe Leroy (6):
>    crypto: talitos - Don't provide setkey for non hmac hashing algs.
>    crypto: talitos - fix hashing
>    crypto: talitos - fix sha224
>    crypto: talitos - fix AEAD test failures
>    crypto: talitos - use kzalloc instead of kmalloc
>    crypto: talitos - fix memory corruption on SEC2
> 
>   drivers/crypto/talitos.c | 81 +++++++++++++++++++++---------------------------
>   drivers/crypto/talitos.h |  2 --
>   2 files changed, 36 insertions(+), 47 deletions(-)
> 
