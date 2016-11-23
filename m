From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH] X.509: Fix double free in x509_cert_parse()
Date: Wed, 23 Nov 2016 19:16:59 +0300
Message-ID: <1479917819-31571-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        <stable@vger.kernel.org>
To: David Howells <dhowells@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We shouldn't free cert->pub->key in x509_cert_parse() because
x509_free_certificate() also does this:
	BUG: Double free or freeing an invalid pointer
	...
	Call Trace:
	 [<ffffffff81896c20>] dump_stack+0x63/0x83
	 [<ffffffff81356571>] kasan_object_err+0x21/0x70
	 [<ffffffff81356ed9>] kasan_report_double_free+0x49/0x60
	 [<ffffffff813561ad>] kasan_slab_free+0x9d/0xc0
	 [<ffffffff81350b7a>] kfree+0x8a/0x1a0
	 [<ffffffff81844fbf>] public_key_free+0x1f/0x30
	 [<ffffffff818455d4>] x509_free_certificate+0x24/0x90
	 [<ffffffff818460bc>] x509_cert_parse+0x2bc/0x300
	 [<ffffffff81846cae>] x509_key_preparse+0x3e/0x330
	 [<ffffffff818444cf>] asymmetric_key_preparse+0x6f/0x100
	 [<ffffffff8178bec0>] key_create_or_update+0x260/0x5f0
	 [<ffffffff8178e6d9>] SyS_add_key+0x199/0x2a0
	 [<ffffffff821d823b>] entry_SYSCALL_64_fastpath+0x1e/0xad
	Object at ffff880110bd1900, in cache kmalloc-512 size: 512
	....
	Freed:
	PID = 2579
	[<ffffffff8104283b>] save_stack_trace+0x1b/0x20
	[<ffffffff813558f6>] save_stack+0x46/0xd0
	[<ffffffff81356183>] kasan_slab_free+0x73/0xc0
	[<ffffffff81350b7a>] kfree+0x8a/0x1a0
	[<ffffffff818460a3>] x509_cert_parse+0x2a3/0x300
	[<ffffffff81846cae>] x509_key_preparse+0x3e/0x330
	[<ffffffff818444cf>] asymmetric_key_preparse+0x6f/0x100
	[<ffffffff8178bec0>] key_create_or_update+0x260/0x5f0
	[<ffffffff8178e6d9>] SyS_add_key+0x199/0x2a0
	[<ffffffff821d823b>] entry_SYSCALL_64_fastpath+0x1e/0xad

Fixes: db6c43bd2132 ("crypto: KEYS: convert public key and digsig asym to the akcipher api")
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: <stable@vger.kernel.org>
---
 crypto/asymmetric_keys/x509_cert_parser.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 865f46e..c80765b 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -133,7 +133,6 @@ struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
 	return cert;
 
 error_decode:
-	kfree(cert->pub->key);
 	kfree(ctx);
 error_no_ctx:
 	x509_free_certificate(cert);
-- 
2.7.3
