From: <gregkh@linuxfoundation.org>
Subject: Patch "crypto: gcm - Fix rfc4543 decryption crash" has been added to the 3.14-stable tree
Date: Sun, 01 May 2016 15:59:15 -0700
Message-ID: <146214355584167@kroah.com>
References: <20160318144240.GA20816@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
To: herbert@gondor.apana.org.au, gregkh@linuxfoundation.org,
	jussi.kivilinna@iki.fi, linux-crypto@vger.kernel.org,
	patrick.meyer@vasgard.com
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160318144240.GA20816@gondor.apana.org.au>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


This is a note to let you know that I've just added the patch titled

    crypto: gcm - Fix rfc4543 decryption crash

to the 3.14-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     crypto-gcm-fix-rfc4543-decryption-crash.patch
and it can be found in the queue-3.14 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From herbert@gondor.apana.org.au  Sun May  1 15:39:20 2016
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 18 Mar 2016 22:42:40 +0800
Subject: crypto: gcm - Fix rfc4543 decryption crash
To: stable@vger.kernel.org, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Jussi Kivilinna <jussi.kivilinna@iki.fi>, patrick.meyer@vasgard.com
Message-ID: <20160318144240.GA20816@gondor.apana.org.au>
Content-Disposition: inline

From: Herbert Xu <herbert@gondor.apana.org.au>

This bug has already bee fixed upstream since 4.2.  However, it
was fixed during the AEAD conversion so no fix was backported to
the older kernels.

When we do an RFC 4543 decryption, we will end up writing the
ICV beyond the end of the dst buffer.  This should lead to a
crash but for some reason it was never noticed.

This patch fixes it by only writing back the ICV for encryption.

Fixes: d733ac90f9fe ("crypto: gcm - fix rfc4543 to handle async...")
Reported-by: Patrick Meyer <patrick.meyer@vasgard.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/gcm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -1173,6 +1173,9 @@ static struct aead_request *crypto_rfc45
 	aead_request_set_tfm(subreq, ctx->child);
 	aead_request_set_callback(subreq, req->base.flags, crypto_rfc4543_done,
 				  req);
+	if (!enc)
+		aead_request_set_callback(subreq, req->base.flags,
+					  req->base.complete, req->base.data);
 	aead_request_set_crypt(subreq, cipher, cipher, enc ? 0 : authsize, iv);
 	aead_request_set_assoc(subreq, assoc, assoclen);
 


Patches currently in stable-queue which might be from herbert@gondor.apana.org.au are

queue-3.14/crypto-gcm-fix-rfc4543-decryption-crash.patch
queue-3.14/crypto-ccp-prevent-information-leakage-on-export.patch
