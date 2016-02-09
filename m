From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: fips: allow more ipsec related methods
Date: Tue, 09 Feb 2016 14:44:59 +0100
Message-ID: <2476935.g0THXc6DOC@tauon.atsec.com>
References: <1455010357-1295-1-git-send-email-meissner@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Marcus Meissner <meissner@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33002 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756748AbcBINpI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2016 08:45:08 -0500
In-Reply-To: <1455010357-1295-1-git-send-email-meissner@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 9. Februar 2016, 10:32:37 schrieb Marcus Meissner:

Hi Marcus,

>IPSEC for aes-ctr requests:
>
>	authenc(digest_null,rfc3686(ctr(aes)))
>
>which can be used in FIPS mode.
>
>rfc3686(ctr(aes)) is already allowed for FIPS usage.
>
>I also allowed "digest_null" for FIPS usage.
>
>Signed-off-by: Marcus Meissner <meissner@suse.de>

I am sorry, but I would say NACK here.

The reason is that the authenc() ciphers are AEAD ciphers. Such ciphers are 
defined to be allowed for FIPS 140-2 usage in SP800-38F. But that SP only 
allows ciphers if there is an authentication (i.e. a MAC) involved. With the 
added authenc() algo, there seems to be no MAC.

In addition, the NULL cipher definitely cannot be considered allowed in FIPS 
mode.
>---
> crypto/testmgr.c | 5 +++++
> 1 file changed, 5 insertions(+)
>
>diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>index 190a290..6ad8ba2 100644
>--- a/crypto/testmgr.c
>+++ b/crypto/testmgr.c
>@@ -2089,6 +2089,10 @@ static const struct alg_test_desc alg_test_descs[] = {
>}
> 		}
> 	}, {
>+		.alg = "authenc(digest_null,rfc3686(ctr(aes)))",
>+		.test = alg_test_null,
>+		.fips_allowed = 1,
>+	}, {
> 		.alg = "authenc(hmac(md5),ecb(cipher_null))",
> 		.test = alg_test_aead,
> 		.suite = {
>@@ -2768,6 +2772,7 @@ static const struct alg_test_desc alg_test_descs[] = {
> 	}, {
> 		.alg = "digest_null",
> 		.test = alg_test_null,
>+		.fips_allowed = 1,
> 	}, {
> 		.alg = "drbg_nopr_ctr_aes128",
> 		.test = alg_test_drbg,


Ciao
Stephan
