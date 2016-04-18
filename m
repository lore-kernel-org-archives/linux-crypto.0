From: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Subject: Re: ppc/talitos oops on call to crypto_alloc_aead
Date: Mon, 18 Apr 2016 12:55:29 +0000
Message-ID: <AM2PR04MB067377F55DDE5D5EE126EBF3986B0@AM2PR04MB0673.eurprd04.prod.outlook.com>
References: <trinity-775586e1-fc1a-4b40-97c7-bdf9f609c0cd-1460122812303@3capp-gmx-bs64>
 <20160415140221.GA477@gondor.apana.org.au>
 <20160418093617.GA18810@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Jonas Eymann <J.Eymann@gmx.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0067.outbound.protection.outlook.com ([157.56.112.67]:51351
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751920AbcDRN2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Apr 2016 09:28:11 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4/18/2016 12:36 PM, Herbert Xu wrote:
> On Fri, Apr 15, 2016 at 10:02:21PM +0800, Herbert Xu wrote:
>> Jonas Eymann <J.Eymann@gmx.net> wrote:
>>>
>>> running a current 4.4.6 kernel on a board using a Freescale P1020, I ran into an oops when calling crypto_alloc_aead using the talitos driver. I could also reproduce this using the run-time self tests:
>>
>> Thanks for the patch.  Could you please add a Signed-off-by?
>>  
Thanks Jonas.

It looks there's a typo, please consider this incremental patch:

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 4f09395dd5f2..7c16051599fd 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2657,7 +2657,7 @@ static int talitos_cra_init(struct crypto_tfm *tfm)
        struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);

        if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
CRYPTO_ALG_TYPE_AHASH)
-               talitos_alg = container_of(__crypto_ahash_alg(tfm),
+               talitos_alg = container_of(__crypto_ahash_alg(alg),
                                           struct talitos_crypto_alg,
                                           algt.alg.hash);
        else


>>> In a first attempt to fix this problem using the patch further below, I could prevent the oops, though the self tests still fail:
>>>
>>> [...]
>>> [    1.145414] alg: aead: Test 1 failed on encryption for authenc-hmac-sha1-cbc-aes-talitos
>>> [    1.153564] 00000000: 53 69 6e 67 6c 65 20 62 6c 6f 63 6b 20 6d 73 67
>>> [    1.160041] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>> [    1.166509] 00000020: 00 00 00 00
>>> [    1.170041] alg: aead: Test 1 failed on encryption for authenc-hmac-sha1-cbc-3des-talitos
>>> [    1.178276] 00000000: 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72 73 74
>>> [    1.184751] 00000010: 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63 74 65
>>> [    1.191220] 00000020: 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65 65 72
>>> [    1.197689] 00000030: 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53 72 63
>>> [    1.204158] 00000040: 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20 63 65
>>> [    1.210626] 00000050: 65 72 73 74 54 20 6f 6f 4d 20 6e 61 20 79 65 53
>>> [    1.217095] 00000060: 72 63 74 65 20 73 6f 54 20 6f 61 4d 79 6e 53 20
>>> [    1.223563] 00000070: 63 65 65 72 73 74 54 20 6f 6f 4d 20 6e 61 0a 79
>>> [    1.230038] 00000080: de ad be ef de ad be ef de ad be ef de ad be ef
>>> [    1.236515] 00000090: de ad be ef
> 
> Any chance you can let me know whether 4.2 works on this machine?
> 
4.2 works fine. 4.3+ have issues.

This might be related to:
aeb4c132f33d crypto: talitos - Convert to new AEAD interface
Before this commit, self-tests pass.

Wrt. hash algorithms registration failure, indeed the problem is due to
lack of import/export functionality.

Regards,
Horia
