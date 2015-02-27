From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: Documentation - describe internal structure
Date: Fri, 27 Feb 2015 20:00 +0100
Message-ID: <2297850.WeljruoXUB@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The kernel crypto API has many indirections which warrant a description
as otherwise one can get easily lost. The description explains the
layers of the kernel crypto API based on examples.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/DocBook/crypto-API.tmpl | 264 ++++++++++++++++++++++++++++++++++
 1 file changed, 264 insertions(+)

diff --git a/Documentation/DocBook/crypto-API.tmpl b/Documentation/DocBook/crypto-API.tmpl
index c763d30..3492ac1 100644
--- a/Documentation/DocBook/crypto-API.tmpl
+++ b/Documentation/DocBook/crypto-API.tmpl
@@ -509,6 +509,270 @@
      select it due to the used type and mask field.
     </para>
    </sect1>
+
+   <sect1><title>Internal Structure of Kernel Crypto API</title>
+
+    <para>
+     The kernel crypto API has an internal structure where a cipher
+     implementation may use many layers and indirections. This section
+     shall help to clarify how the kernel crypto API uses
+     various components to implement the complete cipher.
+    </para>
+
+    <para>
+     The following subsections explain the internal structure based
+     on existing cipher implementations. The first section addresses
+     the most complex scenario where all other scenarios form a logical
+     subset.
+    </para>
+
+    <sect2><title>Generic AEAD Cipher Structure</title>
+
+     <para>
+      The following ASCII art decomposes the kernel crypto API layers
+      when using the AEAD cipher with the automated IV generation. The
+      shown example is used by the IPSEC layer.
+     </para>
+
+     <para>
+      For other use cases of AEAD ciphers, the ASCII art applies as
+      well, but the caller may not use the GIVCIPHER interface. In
+      this case, the caller must generate the IV.
+     </para>
+
+     <para>
+      The depicted example decomposes the AEAD cipher of GCM(AES) based
+      on the generic C implementations (gcm.c, aes-generic.c, ctr.c,
+      ghash-generic.c, seqiv.c). The generic implementation serves as an
+      example showing the complete logic of the kernel crypto API.
+     </para>
+
+     <para>
+      It is possible that some streamlined cipher implementations (like
+      AES-NI) provide implementations merging aspects which in the view
+      of the kernel crypto API cannot be decomposed into layers any more.
+      In case of the AES-NI implementation, the CTR mode, the GHASH
+      implementation and the AES cipher are all merged into one cipher
+      implementation registered with the kernel crypto API. In this case,
+      the concept described by the following ASCII art applies too. However,
+      the decomposition of GCM into the individual sub-components
+      by the kernel crypto API is not done any more.
+     </para>
+
+     <para>
+      Each block in the following ASCII art is an independent cipher
+      instance obtained from the kernel crypto API. Each block
+      is accessed by the caller or by other blocks using the API functions
+      defined by the kernel crypto API for the cipher implementation type.
+     </para>
+
+     <para>
+      The blocks below indicate the cipher type as well as the specific
+      logic implemented in the cipher.
+     </para>
+
+     <para>
+      The ASCII art picture also indicates the call structure, i.e. who
+      calls which component. The arrows point to the invoked block
+      where the caller uses the API applicable to the cipher type
+      specified for the block.
+     </para>
+
+     <programlisting>
+<![CDATA[
+kernel crypto API                                |   IPSEC Layer
+                                                 |
++-----------+                                    |
+|           |            (1)
+| givcipher | <-----------------------------------  esp_output
+|  (seqiv)  | ---+
++-----------+    |
+                 | (2)
++-----------+    |
+|           | <--+                (2)
+|   aead    | <-----------------------------------  esp_input
+|   (gcm)   | ------------+
++-----------+             |
+      | (3)               | (5)
+      v                   v
++-----------+       +-----------+
+|           |       |           |
+| ablkcipher|       |   ahash   |
+|   (ctr)   | ---+  |  (ghash)  |
++-----------+    |  +-----------+
+                 |
++-----------+    | (4)
+|           | <--+
+|   cipher  |
+|   (aes)   |
++-----------+
+]]>
+     </programlisting>
+
+     <para>
+      The following call sequence is applicable when the IPSEC layer
+      triggers an encryption operation with the esp_output function. During
+      configuration, the administrator set up the use of rfc4106(gcm(aes)) as
+      the cipher for ESP. The following call sequence is now depicted in the
+      ASCII art above:
+     </para>
+
+     <orderedlist>
+      <listitem>
+       <para>
+        esp_output() invokes crypto_aead_givencrypt() to trigger an encryption
+        operation of the GIVCIPHER implementation.
+       </para>
+
+       <para>
+        In case of GCM, the SEQIV implementation is registered as GIVCIPHER
+        in crypto_rfc4106_alloc().
+       </para>
+
+       <para>
+        The SEQIV performs its operation to generate an IV where the core
+        function is seqiv_geniv().
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        Now, SEQIV uses the AEAD API function calls to invoke the associated
+        AEAD cipher. In our case, during the instantiation of SEQIV, the
+        cipher handle for GCM is provided to SEQIV. This means that SEQIV
+        invokes AEAD cipher operations with the GCM cipher handle.
+       </para>
+
+       <para>
+        During instantiation of the GCM handle, the CTR(AES) and GHASH
+        ciphers are instantiated. The cipher handles for CTR(AES) and GHASH
+        are retained for later use.
+       </para>
+
+       <para>
+        The GCM implementation is responsible to invoke the CTR mode AES and
+        the GHASH cipher in the right manner to implement the GCM
+        specification.
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        The GCM AEAD cipher type implementation now invokes the ABLKCIPHER API
+        with the instantiated CTR(AES) cipher handle.
+       </para>
+
+       <para>
+	During instantiation of the CTR(AES) cipher, the CIPHER type
+	implementation of AES is instantiated. The cipher handle for AES is
+	retained.
+       </para>
+
+       <para>
+        That means that the ABLKCIPHER implementation of CTR(AES) only
+        implements the CTR block chaining mode. After performing the block
+        chaining operation, the CIPHER implementation of AES is invoked.
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        The ABLKCIPHER of CTR(AES) now invokes the CIPHER API with the AES
+        cipher handle to encrypt one block.
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        The GCM AEAD implementation also invokes the GHASH cipher
+        implementation via the AHASH API.
+       </para>
+      </listitem>
+     </orderedlist>
+
+     <para>
+      When the IPSEC layer triggers the esp_input() function, the same call
+      sequence is followed with the only difference that the operation starts
+      with step (2).
+     </para>
+    </sect2>
+
+    <sect2><title>Generic Block Cipher Structure</title>
+     <para>
+      Generic block ciphers follow the same concept as depicted with the ASCII
+      art picture above.
+     </para>
+
+     <para>
+      For example, CBC(AES) is implemented with cbc.c, and aes-generic.c. The
+      ASCII art picture above applies as well with the difference that only
+      step (4) is used and the ABLKCIPHER block chaining mode is CBC.
+     </para>
+    </sect2>
+
+    <sect2><title>Generic Keyed Message Digest Structure</title>
+     <para>
+      Keyed message digest implementations again follow the same concept as
+      depicted in the ASCII art picture above.
+     </para>
+
+     <para>
+      For example, HMAC(SHA256) is implemented with hmac.c and
+      sha256_generic.c. The following ASCII art illustrates the
+      implementation:
+     </para>
+
+     <programlisting>
+<![CDATA[
+kernel crypto API            |       Caller
+                             |
++-----------+         (1)    |
+|           | <------------------  some_function
+|   ahash   |
+|   (hmac)  | ---+
++-----------+    |
+                 | (2)
++-----------+    |
+|           | <--+
+|   shash   |
+|  (sha256) |
++-----------+
+]]>
+     </programlisting>
+
+     <para>
+      The following call sequence is applicable when a caller triggers
+      an HMAC operation:
+     </para>
+
+     <orderedlist>
+      <listitem>
+       <para>
+        The AHASH API functions are invoked by the caller. The HMAC
+        implementation performs its operation as needed.
+       </para>
+
+       <para>
+        During initialization of the HMAC cipher, the SHASH cipher type of
+        SHA256 is instantiated. The cipher handle for the SHA256 instance is
+        retained.
+       </para>
+
+       <para>
+        At one time, the HMAC implementation requires a SHA256 operation
+        where the SHA256 cipher handle is used.
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        The HMAC instance now invokes the SHASH API with the SHA256
+        cipher handle to calculate the message digest.
+       </para>
+      </listitem>
+     </orderedlist>
+    </sect2>
+   </sect1>
   </chapter>
 
   <chapter id="Development"><title>Developing Cipher Algorithms</title>
-- 
2.1.0
