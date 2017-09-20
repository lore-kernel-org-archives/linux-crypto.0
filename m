From: christophe leroy <christophe.leroy@c-s.fr>
Subject: Re: [PATCH 0/6] crypto: talitos - various fixes
Date: Wed, 20 Sep 2017 21:21:46 +0200
Message-ID: <b708d7a7-1ee2-db0a-70ff-f5e36901a230@c-s.fr>
References: <cover.1505825623.git.christophe.leroy@c-s.fr>
 <d1a928d5-d5cd-baf6-a6bf-2375cce4b4a4@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:36385 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbdITTVz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2017 15:21:55 -0400
In-Reply-To: <d1a928d5-d5cd-baf6-a6bf-2375cce4b4a4@c-s.fr>
Content-Language: fr
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

What's going wrong ? I have resent it and it the same again, the serie 
is not dispatched on the linux-crypto list, but when I answer to a mail 
of the serie, the answer shows up.

What could be the issue ?

Christophe

Le 20/09/2017 à 10:35, Christophe LEROY a écrit :
> Looks like the linux-crypto list and patchwork was out of order when I 
> sent this. I will send again, sorry for the noise on the other lists.
> 
> Le 19/09/2017 à 14:58, Christophe Leroy a écrit :
>> This serie provide various fixes on the talitos driver.
>>
>> Christophe Leroy (6):
>>    crypto: talitos - Don't provide setkey for non hmac hashing algs.
>>    crypto: talitos - fix hashing
>>    crypto: talitos - fix sha224
>>    crypto: talitos - fix AEAD test failures
>>    crypto: talitos - use kzalloc instead of kmalloc
>>    crypto: talitos - fix memory corruption on SEC2
>>
>>   drivers/crypto/talitos.c | 81 
>> +++++++++++++++++++++---------------------------
>>   drivers/crypto/talitos.h |  2 --
>>   2 files changed, 36 insertions(+), 47 deletions(-)
>>

---
L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
https://www.avast.com/antivirus
