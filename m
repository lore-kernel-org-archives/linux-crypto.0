From: <BrillyWu@viatech.com.cn>
Subject: [PATCH] crypto: padlock - Add SHA-1/256 module for VIA Nano
Date: Tue, 22 Mar 2011 14:10:13 +0800
Message-ID: <C4F7CD9A92DBFF48AD8779355CD4D7890A02F3@exchsg04.s3graphics.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from exchtp08.via.com.tw ([61.66.243.7]:52311 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab1CVGZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2011 02:25:27 -0400
Content-class: urn:content-classes:message
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add new SHA-1/256 module that never needs any fallback and just calls
the
PadLock hardware instruction supported from VIA Nano processors to
implement
the "update" and "final" function. 
They are respectively named "sha1_alg_nano" and "sha256_alg_nano", and
will
be used on any VIA Nano processor or the later ones. On VIA C7 CPU, the
"sha1_alg"
and "sha256_alg" modules will still be used as before.
 
Signed-off-by: BrillyWu<brillywu@viatech.com.cn>
Signed-off-by: KaryJin<karyjin@viatech.com.cn>
---
drivers/crypto/padlock-sha.c | 269
++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
1 file changed, 264 insertions(+), 5 deletions(-)

--- a/drivers/crypto/padlock-sha.c	2011-03-22 22:20:16.547343999
+0800
+++ b/drivers/crypto/padlock-sha.c	2011-03-15 09:05:40.049188018
+0800
@@ -288,9 +288,250 @@ static struct shash_alg sha256_alg = {
 	}
 };
 
+/* Add two shash_alg instance for hardware-implemented *
+* multiple-parts hash supported by VIA Nano Processor.*/
+static int padlock_sha1_init_nano(struct shash_desc *desc)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+
+	*sctx = (struct sha1_state){
+		.state = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4
},
+	};
+
+	return 0;
+}
+
+static int padlock_sha1_update_nano(struct shash_desc *desc,
+			const u8 *data,	unsigned int len)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	unsigned int partial, done;
+	const u8 *src;
+	/*The PHE require the out buffer must 128 bytes and 16-bytes
aligned*/
+	u8 buf[128 + PADLOCK_ALIGNMENT - STACK_ALIGN] __attribute__
+		((aligned(STACK_ALIGN)));
+	u8 *dst = PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
+	int ts_state;
+
+	partial = sctx->count & 0x3f;
+	sctx->count += len;
+	done = 0;
+	src = data;
+	memcpy(dst, (u8 *)(sctx->state), SHA1_DIGEST_SIZE);
+
+	if ((partial + len) >= SHA1_BLOCK_SIZE) {
+
+		/* Append the bytes in state's buffer to a block to
handle */
+		if (partial) {
+			done = -partial;
+			memcpy(sctx->buffer + partial, data,
+				done + SHA1_BLOCK_SIZE);
+			src = sctx->buffer;
+			ts_state = irq_ts_save();
+			asm volatile (".byte 0xf3,0x0f,0xa6,0xc8"
+			: "+S"(src), "+D"(dst) \
+			: "a"((long)-1), "c"((unsigned long)1));
+			irq_ts_restore(ts_state);
+			done += SHA1_BLOCK_SIZE;
+			src = data + done;
+		}
+
+		/* Process the left bytes from the input data */
+		if (len - done >= SHA1_BLOCK_SIZE) {
+			ts_state = irq_ts_save();
+			asm volatile (".byte 0xf3,0x0f,0xa6,0xc8"
+			: "+S"(src), "+D"(dst)
+			: "a"((long)-1),
+			"c"((unsigned long)((len - done) /
SHA1_BLOCK_SIZE)));
+			irq_ts_restore(ts_state);
+			done += ((len - done) - (len - done) %
SHA1_BLOCK_SIZE);
+			src = data + done;
+		}
+		partial = 0;
+	}
+	memcpy((u8 *)(sctx->state), dst, SHA1_DIGEST_SIZE);
+	memcpy(sctx->buffer + partial, src, len - done);
+
+	return 0;
+}
+
+static int padlock_sha1_final_nano(struct shash_desc *desc, u8 *out)
+{
+	struct sha1_state *state = (struct sha1_state
*)shash_desc_ctx(desc);
+	unsigned int partial, padlen;
+	__be64 bits;
+	static const u8 padding[64] = { 0x80, };
+
+	bits = cpu_to_be64(state->count << 3);
+
+	/* Pad out to 56 mod 64 */
+	partial = state->count & 0x3f;
+	padlen = (partial < 56) ? (56 - partial) : ((64+56) - partial);
+	padlock_sha1_update_nano(desc, padding, padlen);
+
+	/* Append length field bytes */
+	padlock_sha1_update_nano(desc, (const u8 *)&bits, sizeof(bits));
+
+	/* Swap to output */
+	padlock_output_block((uint32_t *)(state->state), (uint32_t
*)out, 5);
+
+	return 0;
+}
+
+static int padlock_sha256_init_nano(struct shash_desc *desc)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	*sctx = (struct sha256_state){
+		.state = { SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3, \
+				SHA256_H4, SHA256_H5, SHA256_H6,
SHA256_H7},
+	};
+
+	return 0;
+}
+
+static int padlock_sha256_update_nano(struct shash_desc *desc, const u8
*data,
+			  unsigned int len)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	unsigned int partial, done;
+	const u8 *src;
+	/*The PHE require the out buffer must 128 bytes and 16-bytes
aligned*/
+	u8 buf[128 + PADLOCK_ALIGNMENT - STACK_ALIGN] __attribute__
+		((aligned(STACK_ALIGN)));
+	u8 *dst = PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
+	int ts_state;
+
+	partial = sctx->count & 0x3f;
+	sctx->count += len;
+	done = 0;
+	src = data;
+	memcpy(dst, (u8 *)(sctx->state), SHA256_DIGEST_SIZE);
+
+	if ((partial + len) >= SHA256_BLOCK_SIZE) {
+
+		/* Append the bytes in state's buffer to a block to
handle */
+		if (partial) {
+			done = -partial;
+			memcpy(sctx->buf + partial, data,
+				done + SHA256_BLOCK_SIZE);
+			src = sctx->buf;
+			ts_state = irq_ts_save();
+			asm volatile (".byte 0xf3,0x0f,0xa6,0xd0"
+			: "+S"(src), "+D"(dst)
+			: "a"((long)-1), "c"((unsigned long)1));
+			irq_ts_restore(ts_state);
+			done += SHA256_BLOCK_SIZE;
+			src = data + done;
+		}
+
+		/* Process the left bytes from input data*/
+		if (len - done >= SHA256_BLOCK_SIZE) {
+			ts_state = irq_ts_save();
+			asm volatile (".byte 0xf3,0x0f,0xa6,0xd0"
+			: "+S"(src), "+D"(dst)
+			: "a"((long)-1),
+			"c"((unsigned long)((len - done) / 64)));
+			irq_ts_restore(ts_state);
+			done += ((len - done) - (len - done) % 64);
+			src = data + done;
+		}
+		partial = 0;
+	}
+	memcpy((u8 *)(sctx->state), dst, SHA256_DIGEST_SIZE);
+	memcpy(sctx->buf + partial, src, len - done);
+
+	return 0;
+}
+
+static int padlock_sha256_final_nano(struct shash_desc *desc, u8 *out)
+{
+	struct sha256_state *state =
+		(struct sha256_state *)shash_desc_ctx(desc);
+	unsigned int partial, padlen;
+	__be64 bits;
+	static const u8 padding[64] = { 0x80, };
+
+	bits = cpu_to_be64(state->count << 3);
+
+	/* Pad out to 56 mod 64 */
+	partial = state->count & 0x3f;
+	padlen = (partial < 56) ? (56 - partial) : ((64+56) - partial);
+	padlock_sha256_update_nano(desc, padding, padlen);
+
+	/* Append length field bytes */
+	padlock_sha256_update_nano(desc, (const u8 *)&bits,
sizeof(bits));
+
+	/* Swap to output */
+	padlock_output_block((uint32_t *)(state->state), (uint32_t
*)out, 8);
+
+	return 0;
+}
+
+static int padlock_sha_export_nano(struct shash_desc *desc,
+				void *out)
+{
+	int statesize = crypto_shash_statesize(desc->tfm);
+	void *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, sctx, statesize);
+	return 0;
+}
+
+static int padlock_sha_import_nano(struct shash_desc *desc,
+				const void *in)
+{
+	int statesize = crypto_shash_statesize(desc->tfm);
+	void *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx, in, statesize);
+	return 0;
+}
+
+static struct shash_alg sha1_alg_nano = {
+	.digestsize	=	SHA1_DIGEST_SIZE,
+	.init		=	padlock_sha1_init_nano,
+	.update		=	padlock_sha1_update_nano,
+	.final		=	padlock_sha1_final_nano,
+	.export		=	padlock_sha_export_nano,
+	.import		=	padlock_sha_import_nano,
+	.descsize	=	sizeof(struct sha1_state),
+	.statesize	=	sizeof(struct sha1_state),
+	.base		=	{
+		.cra_name		=	"sha1",
+		.cra_driver_name	=	"sha1-padlock-nano",
+		.cra_priority		=	PADLOCK_CRA_PRIORITY,
+		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		=	SHA1_BLOCK_SIZE,
+		.cra_module		=	THIS_MODULE,
+	}
+};
+
+static struct shash_alg sha256_alg_nano = {
+	.digestsize	=	SHA256_DIGEST_SIZE,
+	.init		=	padlock_sha256_init_nano,
+	.update		=	padlock_sha256_update_nano,
+	.final		=	padlock_sha256_final_nano,
+	.export		=	padlock_sha_export_nano,
+	.import		=	padlock_sha_import_nano,
+	.descsize	=	sizeof(struct sha256_state),
+	.statesize	=	sizeof(struct sha256_state),
+	.base		=	{
+		.cra_name		=	"sha256",
+		.cra_driver_name	=	"sha256-padlock-nano",
+		.cra_priority		=	PADLOCK_CRA_PRIORITY,
+		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		=	SHA256_BLOCK_SIZE,
+		.cra_module		=	THIS_MODULE,
+	}
+};
+
 static int __init padlock_init(void)
 {
 	int rc = -ENODEV;
+	struct cpuinfo_x86 *c = &cpu_data(0);
+	struct shash_alg *sha1;
+	struct shash_alg *sha256;
 
 	if (!cpu_has_phe) {
 		printk(KERN_NOTICE PFX "VIA PadLock Hash Engine not
detected.\n");
@@ -302,11 +543,21 @@ static int __init padlock_init(void)
 		return -ENODEV;
 	}
 
-	rc = crypto_register_shash(&sha1_alg);
+	/* Register the newly added algorithm module if on *
+	* VIA Nano processor, or else just do as before */
+	if (c->x86_model < 0x0f) {
+		sha1 = &sha1_alg;
+		sha256 = &sha256_alg;
+	} else {
+		sha1 = &sha1_alg_nano;
+		sha256 = &sha256_alg_nano;
+	}
+
+	rc = crypto_register_shash(sha1);
 	if (rc)
 		goto out;
 
-	rc = crypto_register_shash(&sha256_alg);
+	rc = crypto_register_shash(sha256);
 	if (rc)
 		goto out_unreg1;
 
@@ -315,7 +566,8 @@ static int __init padlock_init(void)
 	return 0;
 
 out_unreg1:
-	crypto_unregister_shash(&sha1_alg);
+	crypto_unregister_shash(sha1);
+
 out:
 	printk(KERN_ERR PFX "VIA PadLock SHA1/SHA256 initialization
failed.\n");
 	return rc;
@@ -323,8 +575,15 @@ out:
 
 static void __exit padlock_fini(void)
 {
-	crypto_unregister_shash(&sha1_alg);
-	crypto_unregister_shash(&sha256_alg);
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	if (c->x86_model >= 0x0f) {
+		crypto_unregister_shash(&sha1_alg_nano);
+		crypto_unregister_shash(&sha256_alg_nano);
+	} else {
+		crypto_unregister_shash(&sha1_alg);
+		crypto_unregister_shash(&sha256_alg);
+	}
 }
 
 module_init(padlock_init);
