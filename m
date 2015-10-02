From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: unaligned access in pkcs7_verify
Date: Fri, 2 Oct 2015 10:00:14 -0400
Message-ID: <20151002140014.GI18263@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sowmini.varadhan@oracle.com
To: dhowells@redhat.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33443 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbbJBOAh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Oct 2015 10:00:37 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hi,

I'm getting a lot of unaligned access messages each time I 
do "modprobe [-r] <module>" on sparc:

Kernel unaligned access at TPC[6ad9b4] pkcs7_verify+0x1ec/0x5e0
Kernel unaligned access at TPC[6a5484] crypto_shash_finup+0xc/0x5c
Kernel unaligned access at TPC[6a5390] crypto_shash_update+0xc/0x54
Kernel unaligned access at TPC[10150308] sha1_sparc64_update+0x14/0x5c [sha1_sparc64]
Kernel unaligned access at TPC[101501ac] __sha1_sparc64_update+0xc/0x98 [sha1_sparc64]

Looks like these are being caused by an unaligned desc at

        desc = digest + digest_size;

Doing this:

--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -46,7 +46,8 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
                return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
 
        desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
-       sinfo->sig.digest_size = digest_size = crypto_shash_digestsize(tfm);
+       sinfo->sig.digest_size = digest_size = 
+               ALIGN(crypto_shash_digestsize(tfm), sizeof (*desc));
 
        ret = -ENOMEM;
        digest = kzalloc(digest_size + desc_size, GFP_KERNEL);

makes the unaliagned message go away, but I dont know if
sinfo->sig.digest_size needs to be set to the (unaligned) raw 
value of crypto_shash_digestsize() itself, and how to verify that
this doesnt break something else in crypto

--Sowmini
