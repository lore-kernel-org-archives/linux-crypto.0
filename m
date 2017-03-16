From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: Re: CRYPTO_MAX_ALG_NAME is too low
Date: Thu, 16 Mar 2017 15:16:29 +0100
Message-ID: <367298c5-aa5d-3708-72d0-8a44702d0caa@nokia.com>
References: <e96825bd-4e1d-c6c1-160e-0dc10f7f3981@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0104.outbound.protection.outlook.com ([104.47.2.104]:23739
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752456AbdCPOQh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 10:16:37 -0400
In-Reply-To: <e96825bd-4e1d-c6c1-160e-0dc10f7f3981@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello!

On 10/03/17 12:55, Alexander Sverdlin wrote:
> Hello crypto maintainers!
> 
> We've found and example of the ipsec algorithm combination, which doesn't fit
> into CRYPTO_MAX_ALG_NAME long buffers:
> 
> ip x s add src 1.1.1.1 dst 1.1.1.2 proto esp spi 0 mode tunnel enc des3_ede 0x0 auth sha256 0x0 flag esn replay-window 256
> 
> produces "echainiv(authencesn(hmac(sha256-generic),cbc(des3_ede-generic)))"
> on the machines without optimized crypto drivers, which doesn't fit into current
> 64-bytes buffers.
> 
> I see two possible options:
> 
> a) split CRYPTO_MAX_ALG_NAME into CRYPTO_MAX_ALG_NAME + CRYPTO_MAX_DRV_NAME pair
> and make later, say, 96, because the former probably cannot be changed because of
> numerous user-space exports. And change half of the code to use new define.
> 
> b) rename *-generic algorithms to *-gen, so that cra_driver_name will be shortened,
> while MODULE_ALIAS_CRYPTO() could still be maintained in old and new form.
> 
> What are your thoughts?

Any?

This is a regression caused by 856e3f4092
("crypto: seqiv - Add support for new AEAD interface")

As I've said above, I can offer one of the two solutions, which patch should I send?
Or do you see any better alternatives?

-- 
Best regards,
Alexander Sverdlin.
