From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: RE: [PATCH 2/2] Crypto: Add support for 192 & 256 bit keys to
 AESNI RFC4106 - fixed whitespace
Date: Fri, 07 Mar 2014 16:41:55 -0800
Message-ID: <1394239315.27116.142.camel@schen9-DESK>
References: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA6F5222@USEA-EXCH7.na.uis.unisys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	James Guilford <james.guilford@intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>
To: "McCaffrey, Timothy M" <Timothy.McCaffrey@unisys.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52865 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbaCHAl7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Mar 2014 19:41:59 -0500
In-Reply-To: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA6F5222@USEA-EXCH7.na.uis.unisys.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Mon, 2014-03-03 at 16:59 -0600, McCaffrey, Timothy M wrote:
> I think this should work.
> 

Tim,

I got a kernel panic when I tried your new aes gcm code.
The panic occurs around this code:

> +
> +aes_loop_pre_enc\num_initial_blocks:
> +       MOVADQ     (%r10),\TMP2              <--------panic
> +.irpc  index, 1234
> +       AESENC     \TMP2, %xmm\index
> +.endr
> +       add        $16,%r10
> +       sub        $1,%eax
> +       jnz        aes_loop_pre_enc\num_initial_blocks
> +
> +aes_loop_pre_enc_done\num_initial_blocks:
> +       MOVADQ     (%r10), \TMP2
>         AESENCLAST \TMP2, \XMM1
>         AESENCLAST \TMP2, \XMM2
>         AESENCLAST \TMP2, \XMM3
> @@ -655,15 +642,11 @@ _get_AAD_loop2_done\num_initial_blocks\operation:
>         movdqu     \XMM4, 16*3(%arg2 , %r11 , 1)
> 
>  

I was doing aes_gcm_enc, with 128 bit key.
aadLen = 8
tagLen = 16
plaintext_len = 78

An equivalent test code that I hacked together which
you can try is included below.

Thanks.

Tim Chen

---

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 948ad0e..8fced02 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1467,12 +1467,98 @@ static const struct x86_cpu_id aesni_cpu_id[] = {
 };
 MODULE_DEVICE_TABLE(x86cpu, aesni_cpu_id);
 
+u8 test_iv[16] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01}; 
+u8 test_hash_key[16] = {0xc6, 0xa1, 0x3b, 0x37, 0x87, 0x8f, 0x5b, 0x82, 0x6f, 0x4f, 0x81, 0x62, 0xa1, 0xc8, 0xd8, 0x79}; 
+u8 test_aad[16] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01}; 
+u8 test_auth_tag[16];
+u8 test_auth_tag2[16];
+u8 test_in[9000];
+u8 test_in2[9000];
+u8 test_out[9000];
+u8 test_out2[9000];
+unsigned long test_aadLen;
+unsigned long test_tagLen;
+struct aesni_rfc4106_gcm_ctx test_ctx;
+
+void set_in(unsigned len)
+{
+	int i;
+
+	for (i=0; i<len; ++i) {
+		test_in[i] = 0x1f; 	
+		test_in2[i] = 0x1f; 	
+	}
+	for (i=0; i<16; ++i) {
+		test_auth_tag[i] = 0;
+		test_auth_tag2[i] = 0;
+	}
+}
+
+void clear_out(unsigned len)
+{
+	int i;
+
+	for (i=0; i<len; ++i) {
+		test_out[i] = 0x00; 	
+		test_out2[i] = 0x00; 	
+	}
+}
+
+static void test_fn(void)
+{
+	u64 i,j;
+	struct aesni_rfc4106_gcm_ctx *ctx = &test_ctx;
+	void *aes_ctx = &(ctx->aes_key_expanded);
+
+	memset(ctx, 0, sizeof(struct aesni_rfc4106_gcm_ctx));
+	test_aadLen = 8;
+	test_tagLen = 16;
+
+	pr_info("test aes-gcm\n");
+	for (i = 10; i < 8400; i += 17) {
+		set_in((unsigned) i);
+		clear_out((unsigned) i);
+		aesni_gcm_enc(aes_ctx, test_out, test_in, (unsigned long)i, test_iv,
+			test_hash_key, test_aad, (unsigned long)test_aadLen, test_auth_tag,
+			test_tagLen);
+		aesni_gcm_enc_avx(aes_ctx, test_out2, test_in2, (unsigned long)i, test_iv,
+			test_hash_key, test_aad, (unsigned long)test_aadLen, test_auth_tag2,
+			test_tagLen);
+		for (j = 0; j < i; ++j) {
+			if (test_out[j] != test_out2[j]) {
+				pr_info("test vector length %d failed\n", (int) i);
+				break;
+			}
+		}
+		if (j != i) {
+			pr_info("test aesni-gcm failed\n");
+			break;
+		}
+		for (j = 0; j < test_tagLen; ++j) {
+			if (test_auth_tag[j] != test_auth_tag2[j]) {
+				pr_info("test tag of vector length %d failed\n", (int) i);
+				break;
+			}
+		}
+		if (j != test_tagLen) {
+			pr_info("test aesni-gcm failed\n");
+			break;
+		}
+		printk("%d. ", (int) i);
+	}
+	if (i >= 8400)
+		pr_info("test aes_gcm completed successfully\n");
+	else
+		pr_info("test aes_gcm failed for length %d\n", i);
+}
+
 static int __init aesni_init(void)
 {
 	int err;
 
 	if (!x86_match_cpu(aesni_cpu_id))
 		return -ENODEV;
+#if 0
 #ifdef CONFIG_X86_64
 #ifdef CONFIG_AS_AVX2
 	if (boot_cpu_has(X86_FEATURE_AVX2)) {
@@ -1494,11 +1580,17 @@ static int __init aesni_init(void)
 		aesni_gcm_dec_tfm = aesni_gcm_dec;
 	}
 #endif
+#else
+		pr_info("SSE version of gcm_enc/dec engaged.\n");
+		aesni_gcm_enc_tfm = aesni_gcm_enc;
+		aesni_gcm_dec_tfm = aesni_gcm_dec;
+#endif
 
 	err = crypto_fpu_init();
 	if (err)
 		return err;
 
+	test_fn();
 	return crypto_register_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
 }
 
