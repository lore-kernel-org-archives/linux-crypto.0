From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 6/8] crypto: qat - Convert to new AEAD interface
Date: Mon, 03 Aug 2015 10:01:02 -0700
Message-ID: <55BF9E4E.6020006@intel.com>
References: <20150730094138.GA15941@gondor.apana.org.au> <E1ZKkWe-0004C6-SN@gondolin.me.apana.org.au> <55BBDD1F.4020208@intel.com> <20150802012354.GB10055@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6636 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbbHCRBy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 13:01:54 -0400
In-Reply-To: <20150802012354.GB10055@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/01/2015 06:23 PM, Herbert Xu wrote:
> On Fri, Jul 31, 2015 at 01:39:59PM -0700, Tadeusz Struk wrote:
>> On 07/30/2015 02:53 AM, Herbert Xu wrote:
>>> -}, {
>>> +	.init = qat_alg_aead_sha512_init,
>>> +	.exit = qat_alg_aead_exit,
>>> +	.setkey = qat_alg_aead_setkey,
>>> +	.decrypt = qat_alg_aead_dec,
>>> +	.encrypt = qat_alg_aead_enc,
>>> +	.ivsize = AES_BLOCK_SIZE,
>>> +	.maxauthsize = SHA512_DIGEST_SIZE,
>>
>> Hi Herbert,
>> crypto_aead_encrypt() and crypto_aead_decrypt() work fine, but crypto_aead_givencrypt(),
>> which is still supported on the API causes a crash. Should we also disable all the
>> crypto_aead_giv* calls? I use it in my internal tests.
> 
> givencrypt will be removed once all drivers are converted across.
> So it must not be used.
Hi Herbert,
There is one problem that I missed before.
We can shutdown a qat device and bring it back up via ioct.
Before we shut the last device we also unregister the algorithms.
Then we can bring them up again, but it fails without resetting the flags.

--- 8< ---
QAT algorithms can be registered and unregistered without
removing the qat module via ioctl, therefore they need to
have their flags reset before each register.

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 45420a6..1411e4c 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -1183,16 +1183,22 @@ static struct crypto_alg qat_algs[] = { {
 
 int qat_algs_register(void)
 {
-	int ret = 0;
+	int ret = 0, i;
 
 	mutex_lock(&algs_lock);
 	if (++active_devs != 1)
 		goto unlock;
 
+	for (i = 0; i < ARRAY_SIZE(qat_algs); i++)
+		qat_algs[i].cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC;
+
 	ret = crypto_register_algs(qat_algs, ARRAY_SIZE(qat_algs));
 	if (ret)
 		goto unlock;
 
+	for (i = 0; i < ARRAY_SIZE(qat_aeads); i++)
+		qat_aeads[i].base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_AEAD_NEW;
+
 	ret = crypto_register_aeads(qat_aeads, ARRAY_SIZE(qat_aeads));
 	if (ret)
 		goto unreg_algs;
