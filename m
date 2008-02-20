From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Wed, 20 Feb 2008 16:19:03 +0300
Message-ID: <20080220131903.GA1965@2ka.mipt.ru>
References: <E1JRLsx-0003Yz-00@gondolin.me.apana.org.au> <47BB036D.7090701@trash.net> <20080220005329.GA21565@gondor.apana.org.au> <47BC1E12.9050201@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:54341 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbYBTNTu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Feb 2008 08:19:50 -0500
Content-Disposition: inline
In-Reply-To: <47BC1E12.9050201@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Patrick.

On Wed, Feb 20, 2008 at 01:33:22PM +0100, Patrick McHardy (kaber@trash.net) wrote:
> I saw the discrepancy between the elen value used
> for aead_request_set_crypt() in esp_input() and the
> req->nbytes value seen in hifn_setup_session().

What iv generation scheme do you use? It looks like only gcm and ccm add
16 bytes to cryptlen and set nbytes to them. Although they both install
two scatterlists for crypto operation: one for data and one for above
addition block of 16 bytes.

Btw, Herbert, I've found a tiny typo in both ccm and gcm modules, which
do not set correct cra_aead.geniv name.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 7cf7e5a..118b6f5 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -821,7 +821,7 @@ static struct crypto_instance *crypto_rfc4309_alloc(struct rtattr **tb)
 	inst->alg.cra_aead.encrypt = crypto_rfc4309_encrypt;
 	inst->alg.cra_aead.decrypt = crypto_rfc4309_decrypt;
 
-	inst->alg.cra_aead.geniv = "seqiv";
+	inst->alg.cra_aead.geniv = "ccm";
 
 out:
 	return inst;
diff --git a/crypto/gcm.c b/crypto/gcm.c
index e70afd0..058de64 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -754,7 +754,7 @@ static struct crypto_instance *crypto_rfc4106_alloc(struct rtattr **tb)
 	inst->alg.cra_aead.encrypt = crypto_rfc4106_encrypt;
 	inst->alg.cra_aead.decrypt = crypto_rfc4106_decrypt;
 
-	inst->alg.cra_aead.geniv = "seqiv";
+	inst->alg.cra_aead.geniv = "gcm";
 
 out:
 	return inst;


-- 
	Evgeniy Polyakov
