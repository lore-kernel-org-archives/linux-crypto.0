From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: implement DH primitives under akcipher API
Date: Mon, 7 Mar 2016 13:45:38 -0800
Message-ID: <56DDF682.5070008@intel.com>
References: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com>
 <3E4EC1AA-9696-4DBF-9C0A-18EF94300FDC@holtmann.org>
 <20160302093831.GA2384@sbenedet-virtual-machine>
 <F79358BD-CFB3-4B7B-A609-F050038A3D91@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: Salvatore Benedetto <salvatore.benedetto@intel.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	David Howells <dhowells@redhat.com>
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:65364 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbcCGVuM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Mar 2016 16:50:12 -0500
In-Reply-To: <F79358BD-CFB3-4B7B-A609-F050038A3D91@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Marcel,
On 03/02/2016 05:46 AM, Marcel Holtmann wrote:
> And I have the feeling that akcipher is not the best approach for adding a key exchange method. I think we need a new method for doing exactly that. At the base of it, the key exchange is fundamentally different.

It is unfortunate that, unlike the symmetric ciphers, not all the
asymmetric ciphers have the same simple encrypt/decrypt interface.
As you said key exchange algorithms are different. To solve that we should
define new methods in akcipher.h for key exchange as follows:

diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index c37cc59..d50d834 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -383,4 +383,41 @@ static inline int crypto_akcipher_set_priv_key(struct crypto_akcipher *tfm,
 
 	return alg->set_priv_key(tfm, key, keylen);
 }
+
+/**
+ * crypto_akcipher_gen_public() - Invoke appropriate key exchange function
+ *
+ * Function invokes the specific key exchange function, which calculates
+ * the public component.
+ *
+ * @req:	asymmetric key request
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_akcipher_gen_public(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+
+	return alg->encrypt(req);
+}
+
+/**
+ * crypto_akcipher_gen_shared() - Invoke appropriate key exchange function
+ *
+ * Function invokes the specific key exchange function, which calculates
+ * the shared secret component.
+ *
+ * @req:	asymmetric key request
+ *
+ * Return: zero on success; error code in case of error
+ */
+static inline int crypto_akcipher_gen_shared(struct akcipher_request *req)
+{
+	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
+	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
+
+	return alg->decrypt(req);
+}
+
 #endif

In this way we can define a generic user side of the key exchange interface,
and on the the driver side of the akcipher, the implementations would overload
the existing akcipher encrypt(), decrypt(), set_pub_key(), set_priv_key() methods
and do what should be done for a given algorithm. We just need to agree on the
format of the input parameters to these operations.

> 
> From an API point of view, I am also not convinced that it is a good idea to generate the private keys used on the fly. I think this all needs to be a lot more deterministic and flexible. In addition there are cases where you want to point to specific private / public key pair that you locally have. There are even protocols like Bluetooth that have defined fixed debug key pairs. If we can not support that, then this approach is not generic enough.

Agree, we need to support all the cases, but dealing with different type of keys
needs to happen above this API. This API should solely be an interface to math
primitives of certain operations, which can be implemented in SW or can be HW
accelerated. Modules like public_key or afalg_akcipher need to be smart enough
and know what key types they deal with and do the right thing depending on that
knowledge.

> 
> So my thinking actually is that we need a new key exchange abstraction in the crypto stack. However I am not sure that an userspace facing API should be done via AF_ALG. I think that does not fit. I think that doing it via keyctl is a lot more logical place.

The advantage of exposing akcipher via AF_ALG is that we can support generic
applications like OpenSSL or web server. I agree that for some use cases keyctl
will make more sense, but this shouldn't prevent us from allowing the mentioned
applications using hardware crypto accelerators that implement e.g. RSA, and can
work with SW keys. The two interfaces should coexist, and they should work together.
Keyctl should internally use akcipher for SW keys instead of introducing its own
implementation, and algif_akcipher should use keyring to deal with HW keys.
I'm working with David Howells to try to find out how exactly this will work together.

Also please note that there already exists an af_alg engine for openSSL for
symmetric ciphers. It would be more logical to add support for asymmetric ciphers
to the existing engine, than to create a new one, which uses keyctl.

> 
> It also means that we need a separate keyctl to actually generate the local private / public key pairs first. I think that makes sense no matter what. You can generate the keys, the private key stays in kernel memory forever and you can read out the public key. Some protocols will throw away the keys after single use, but others might actually reuse them. Or as mentioned above has fixed keys for debugging purposes. Using keyctl should then also make it easy to handle RSA vs ECC for the key generation since we need to be able to store both types at some point anyway. Also in cases where keys are RSA keys in ASN.1 format in the first place or are learned from certificates are already present and uniquely presented in the kernel. No need to invent yet another format for keys.
> 
> Especially in the case where you create a session key based out of certificates and existing public / private key pairs, it makes sense that keyctl can turn them directly into a new key. In most cases these are symmetric keys that can then be easily referenced by skcipher for ease of use.
> 
> And I did mention this before, this would also solve the problem where you might have to use a private key that is part of a TPM or secure enclave. The case where the kernel does not even know the key, just its existence. Use it to generate the session key and keep the session key in the kernel.

Agree, and to make this work with afalg_akcipher, I have proposed new
ALG_SET_KEY_ID and ALG_SET_KEY_ID operations. See here: https://lkml.org/lkml/2015/12/26/65
The plan is that in this case the afalg_akcipher will not use akcipher api at all.
In this case the algif_akcipher will use the request_key() interface to retrieve
the key type info and will use the operations that the new TPM interface will define.
Thanks,
-- 
TS
