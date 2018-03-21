From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [RFC] SHASH_DESC_ON_STACK macro
Date: Wed, 21 Mar 2018 10:07:05 -0500
Message-ID: <f662fa16-2cbb-a484-4efb-68bb3b39a792@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

There is an ongoing effort to remove all VLAs from the code base [1] and 
while working on that I came across the following macro at 
include/crypto/hash.h:154:

#define SHASH_DESC_ON_STACK(shash, ctx)                           \
         char __##shash##_desc[sizeof(struct shash_desc) +         \
                 crypto_shash_descsize(ctx)] CRYPTO_MINALIGN_ATTR; \
         struct shash_desc *shash = (struct shash_desc *)__##shash##_desc


Currently, this macro is being used in 46 different places.

I wonder how big can tfm->descsize can get?

Do you think it is feasible to replace the call to crypto_shash_descsize 
with a constant value and get rid of 46 VLA warnings?

I have sent some patches to replace the use of this macro with dynamic 
memory allocation instead, but it seems that this is not a suitable 
solution for all cases due to performance issues.

[1] https://lkml.org/lkml/2018/3/7/621

I'd really appreciate any feedback.
Thanks
--
Gustavo
