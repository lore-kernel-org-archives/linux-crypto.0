From: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 1/6] Documentation: crypto: document crypto
 engine API
Date: Fri, 26 Jan 2018 20:15:29 +0100
Message-ID: <20180126191534.17569-2-clabbe.montjoie@gmail.com>
References: <20180126191534.17569-1-clabbe.montjoie@gmail.com>
Reply-To: clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org,
	linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: alexandre.torgue-qxv4g6HH51o@public.gmane.org,
	arei.gonglei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
	corbet-T1hC0tSOHrs@public.gmane.org,
	davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	fabien.dessenne-qxv4g6HH51o@public.gmane.org
Return-path: <linux-sunxi+bncBD7YLCN32UNBB275VXJQKGQEOLHIOOI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20180126191534.17569-1-clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/crypto/crypto_engine.rst | 48 ++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 Documentation/crypto/crypto_engine.rst

diff --git a/Documentation/crypto/crypto_engine.rst b/Documentation/crypto/crypto_engine.rst
new file mode 100644
index 000000000000..8272ac92a14f
--- /dev/null
+++ b/Documentation/crypto/crypto_engine.rst
@@ -0,0 +1,48 @@
+=============
+CRYPTO ENGINE
+=============
+
+Overview
+--------
+The crypto engine API (CE), is a crypto queue manager.
+
+Requirement
+-----------
+You have to put at start of your tfm_ctx the struct crypto_engine_ctx
+struct your_tfm_ctx {
+        struct crypto_engine_ctx enginectx;
+        ...
+};
+Why: Since CE manage only crypto_async_request, it cannot know the underlying
+request_type and so have access only on the TFM.
+So using container_of for accessing __ctx is impossible.
+Furthermore, the crypto engine cannot know the "struct your_tfm_ctx",
+so it must assume that crypto_engine_ctx is at start of it.
+
+Order of operations
+-------------------
+You have to obtain a struct crypto_engine via crypto_engine_alloc_init().
+And start it via crypto_engine_start().
+
+Before transferring any request, you have to fill the enginectx.
+- prepare_request: (taking a function pointer) If you need to do some processing before doing the request
+- unprepare_request: (taking a function pointer) Undoing what's done in prepare_request
+- do_one_request: (taking a function pointer) Do encryption for current request
+
+Note: that those three functions get the crypto_async_request associated with the received request.
+So your need to get the original request via container_of(areq, struct yourrequesttype_request, base);
+
+When your driver receive a crypto_request, you have to transfer it to
+the cryptoengine via one of:
+- crypto_transfer_ablkcipher_request_to_engine()
+- crypto_transfer_aead_request_to_engine()
+- crypto_transfer_akcipher_request_to_engine()
+- crypto_transfer_hash_request_to_engine()
+- crypto_transfer_skcipher_request_to_engine()
+
+At the end of the request process, a call to one of the following function is needed:
+- crypto_finalize_ablkcipher_request
+- crypto_finalize_aead_request
+- crypto_finalize_akcipher_request
+- crypto_finalize_hash_request
+- crypto_finalize_skcipher_request
-- 
2.13.6
