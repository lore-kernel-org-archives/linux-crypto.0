From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/6] Documentation: crypto: document crypto engine API
Date: Wed,  3 Jan 2018 21:11:04 +0100
Message-ID: <20180103201109.16077-2-clabbe.montjoie@gmail.com>
References: <20180103201109.16077-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	fabien.dessenne@st.com, virtualization@lists.linux-foundation.org,
	Corentin Labbe <clabbe.montjoie@gmail.com>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: alexandre.torgue@st.com, arei.gonglei@huawei.com, corbet@lwn.net,
	davem@davemloft.net, herbert@gondor.apana.org.au, jasowang@redhat.com,
	mcoquelin.stm32@gmail.com, mst@redhat.com
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180103201109.16077-1-clabbe.montjoie@gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 Documentation/crypto/crypto_engine.rst | 46 ++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/crypto/crypto_engine.rst

diff --git a/Documentation/crypto/crypto_engine.rst b/Documentation/crypto/crypto_engine.rst
new file mode 100644
index 000000000000..b0ed37f9fb0c
--- /dev/null
+++ b/Documentation/crypto/crypto_engine.rst
@@ -0,0 +1,46 @@
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
+You have to put at start of your tfm_ctx the struct crypto_engine_reqctx
+struct your_tfm_ctx {
+        struct crypto_engine_reqctx enginectx;
+        ...
+};
+Why: Since CE manage only crypto_async_request, it cannot know the underlying
+request_type and so have access only on the TFM.
+So using container_of for accessing __ctx is impossible.
+Furthermore, the crypto engine cannot know the "struct your_tfm_ctx",
+so it must assume that crypto_engine_reqctx is at start of it.
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
+- crypto_transfer_cipher_request_to_engine()
+- crypto_transfer_skcipher_request_to_engine()
+- crypto_transfer_akcipher_request_to_engine()
+- crypto_transfer_hash_request_to_engine()
+
+At the end of the request process, a call to one of the following function is needed:
+- crypto_finalize_cipher_request
+- crypto_finalize_skcipher_request
+- crypto_finalize_akcipher_request
+- crypto_finalize_hash_request
-- 
2.13.6
