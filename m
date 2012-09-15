From: David Miller <davem@davemloft.net>
Subject: [PATCH] sparc64: Adjust crypto priorities.
Date: Sat, 15 Sep 2012 12:17:31 -0400 (EDT)
Message-ID: <20120915.121731.988543569495639807.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: sparclinux@vger.kernel.org
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Make the crypto opcode implementations have a higher priority than
those provides by the ring buffer based Niagara crypto device.

Also, several crypto opcode hashes were not setting the priority value
at all.

Signed-off-by: David S. Miller <davem@davemloft.net>
---

These two implementations currently don't appear at the same time on
real systems, but it's better to set this stuff accurately anyways.

 arch/sparc/crypto/aes_glue.c      |   10 ++++++----
 arch/sparc/crypto/camellia_glue.c |    8 +++++---
 arch/sparc/crypto/crc32c_glue.c   |    4 +++-
 arch/sparc/crypto/des_glue.c      |   14 ++++++++------
 arch/sparc/crypto/md5_glue.c      |    4 +++-
 arch/sparc/crypto/opcodes.h       |    2 ++
 arch/sparc/crypto/sha1_glue.c     |    4 +++-
 arch/sparc/crypto/sha256_glue.c   |    4 ++++
 arch/sparc/crypto/sha512_glue.c   |    4 ++++
 drivers/crypto/n2_core.c          |    2 +-
 10 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/arch/sparc/crypto/aes_glue.c b/arch/sparc/crypto/aes_glue.c
index f457fc6..180bed4 100644
--- a/arch/sparc/crypto/aes_glue.c
+++ b/arch/sparc/crypto/aes_glue.c
@@ -26,6 +26,8 @@
 #include <asm/pstate.h>
 #include <asm/elf.h>
 
+#include "opcodes.h"
+
 struct aes_ops {
 	void (*encrypt)(const u64 *key, const u32 *input, u32 *output);
 	void (*decrypt)(const u64 *key, const u32 *input, u32 *output);
@@ -356,7 +358,7 @@ static int ctr_crypt(struct blkcipher_desc *desc,
 static struct crypto_alg algs[] = { {
 	.cra_name		= "aes",
 	.cra_driver_name	= "aes-sparc64",
-	.cra_priority		= 150,
+	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_sparc64_aes_ctx),
@@ -374,7 +376,7 @@ static struct crypto_alg algs[] = { {
 }, {
 	.cra_name		= "ecb(aes)",
 	.cra_driver_name	= "ecb-aes-sparc64",
-	.cra_priority		= 150,
+	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_sparc64_aes_ctx),
@@ -393,7 +395,7 @@ static struct crypto_alg algs[] = { {
 }, {
 	.cra_name		= "cbc(aes)",
 	.cra_driver_name	= "cbc-aes-sparc64",
-	.cra_priority		= 150,
+	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_sparc64_aes_ctx),
@@ -412,7 +414,7 @@ static struct crypto_alg algs[] = { {
 }, {
 	.cra_name		= "ctr(aes)",
 	.cra_driver_name	= "ctr-aes-sparc64",
-	.cra_priority		= 150,
+	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct crypto_sparc64_aes_ctx),
diff --git a/arch/sparc/crypto/camellia_glue.c b/arch/sparc/crypto/camellia_glue.c
index c258cc5..f45ae69 100644
--- a/arch/sparc/crypto/camellia_glue.c
+++ b/arch/sparc/crypto/camellia_glue.c
@@ -14,6 +14,8 @@
 #include <asm/pstate.h>
 #include <asm/elf.h>
 
+#include "opcodes.h"
+
 #define CAMELLIA_MIN_KEY_SIZE        16
 #define CAMELLIA_MAX_KEY_SIZE        32
 #define CAMELLIA_BLOCK_SIZE          16
@@ -219,7 +221,7 @@ static int cbc_decrypt(struct blkcipher_desc *desc,
 static struct crypto_alg algs[] = { {
 	.cra_name		= "camellia",
 	.cra_driver_name	= "camellia-sparc64",
-	.cra_priority		= 150,
+	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		= CAMELLIA_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct camellia_sparc64_ctx),
@@ -237,7 +239,7 @@ static struct crypto_alg algs[] = { {
 }, {
 	.cra_name		= "ecb(camellia)",
 	.cra_driver_name	= "ecb-camellia-sparc64",
-	.cra_priority		= 150,
+	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize		= CAMELLIA_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct camellia_sparc64_ctx),
@@ -256,7 +258,7 @@ static struct crypto_alg algs[] = { {
 }, {
 	.cra_name		= "cbc(camellia)",
 	.cra_driver_name	= "cbc-camellia-sparc64",
-	.cra_priority		= 150,
+	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize		= CAMELLIA_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct camellia_sparc64_ctx),
diff --git a/arch/sparc/crypto/crc32c_glue.c b/arch/sparc/crypto/crc32c_glue.c
index ec31cdb..0bd89ce 100644
--- a/arch/sparc/crypto/crc32c_glue.c
+++ b/arch/sparc/crypto/crc32c_glue.c
@@ -20,6 +20,8 @@
 #include <asm/pstate.h>
 #include <asm/elf.h>
 
+#include "opcodes.h"
+
 /*
  * Setting the seed allows arbitrary accumulators and flexible XOR policy
  * If your algorithm starts with ~0, then XOR with ~0 before you set
@@ -130,7 +132,7 @@ static struct shash_alg alg = {
 	.base			=	{
 		.cra_name		=	"crc32c",
 		.cra_driver_name	=	"crc32c-sparc64",
-		.cra_priority		=	150,
+		.cra_priority		=	SPARC_CR_OPCODE_PRIORITY,
 		.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
 		.cra_ctxsize		=	sizeof(u32),
 		.cra_alignmask		=	7,
diff --git a/arch/sparc/crypto/des_glue.c b/arch/sparc/crypto/des_glue.c
index 5ec0309..77d2ad6 100644
--- a/arch/sparc/crypto/des_glue.c
+++ b/arch/sparc/crypto/des_glue.c
@@ -15,6 +15,8 @@
 #include <asm/pstate.h>
 #include <asm/elf.h>
 
+#include "opcodes.h"
+
 struct des_sparc64_ctx {
 	u64 encrypt_expkey[DES_EXPKEY_WORDS / 2];
 	u64 decrypt_expkey[DES_EXPKEY_WORDS / 2];
@@ -371,7 +373,7 @@ static int cbc3_decrypt(struct blkcipher_desc *desc,
 static struct crypto_alg algs[] = { {
 	.cra_name		= "des",
 	.cra_driver_name	= "des-sparc64",
-	.cra_priority		= 150,
+	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		= DES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct des_sparc64_ctx),
@@ -389,7 +391,7 @@ static struct crypto_alg algs[] = { {
 }, {
 	.cra_name		= "ecb(des)",
 	.cra_driver_name	= "ecb-des-sparc64",
-	.cra_priority		= 150,
+	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize		= DES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct des_sparc64_ctx),
@@ -408,7 +410,7 @@ static struct crypto_alg algs[] = { {
 }, {
 	.cra_name		= "cbc(des)",
 	.cra_driver_name	= "cbc-des-sparc64",
-	.cra_priority		= 150,
+	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize		= DES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct des_sparc64_ctx),
@@ -427,7 +429,7 @@ static struct crypto_alg algs[] = { {
 }, {
 	.cra_name		= "des3_ede",
 	.cra_driver_name	= "des3_ede-sparc64",
-	.cra_priority		= 150,
+	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		= DES3_EDE_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct des3_ede_sparc64_ctx),
@@ -445,7 +447,7 @@ static struct crypto_alg algs[] = { {
 }, {
 	.cra_name		= "ecb(des3_ede)",
 	.cra_driver_name	= "ecb-des3_ede-sparc64",
-	.cra_priority		= 150,
+	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize		= DES3_EDE_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct des3_ede_sparc64_ctx),
@@ -464,7 +466,7 @@ static struct crypto_alg algs[] = { {
 }, {
 	.cra_name		= "cbc(des3_ede)",
 	.cra_driver_name	= "cbc-des3_ede-sparc64",
-	.cra_priority		= 150,
+	.cra_priority		= SPARC_CR_OPCODE_PRIORITY,
 	.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize		= DES3_EDE_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct des3_ede_sparc64_ctx),
diff --git a/arch/sparc/crypto/md5_glue.c b/arch/sparc/crypto/md5_glue.c
index bdfcfef..603d723 100644
--- a/arch/sparc/crypto/md5_glue.c
+++ b/arch/sparc/crypto/md5_glue.c
@@ -24,6 +24,8 @@
 #include <asm/pstate.h>
 #include <asm/elf.h>
 
+#include "opcodes.h"
+
 asmlinkage void md5_sparc64_transform(u32 *digest, const char *data,
 				      unsigned int rounds);
 
@@ -141,7 +143,7 @@ static struct shash_alg alg = {
 	.base		=	{
 		.cra_name	=	"md5",
 		.cra_driver_name=	"md5-sparc64",
-		.cra_priority	=	150,
+		.cra_priority	=	SPARC_CR_OPCODE_PRIORITY,
 		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
 		.cra_blocksize	=	MD5_HMAC_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
diff --git a/arch/sparc/crypto/opcodes.h b/arch/sparc/crypto/opcodes.h
index b6c4a15..19cbaea 100644
--- a/arch/sparc/crypto/opcodes.h
+++ b/arch/sparc/crypto/opcodes.h
@@ -1,6 +1,8 @@
 #ifndef _OPCODES_H
 #define _OPCODES_H
 
+#define SPARC_CR_OPCODE_PRIORITY	300
+
 #define F3F(x,y,z)	(((x)<<30)|((y)<<19)|((z)<<5))
 
 #define FPD_ENCODE(x)	(((x) >> 5) | ((x) & ~(0x20)))
diff --git a/arch/sparc/crypto/sha1_glue.c b/arch/sparc/crypto/sha1_glue.c
index 6bd1abc..2bbb20b 100644
--- a/arch/sparc/crypto/sha1_glue.c
+++ b/arch/sparc/crypto/sha1_glue.c
@@ -21,6 +21,8 @@
 #include <asm/pstate.h>
 #include <asm/elf.h>
 
+#include "opcodes.h"
+
 asmlinkage void sha1_sparc64_transform(u32 *digest, const char *data,
 				       unsigned int rounds);
 
@@ -136,7 +138,7 @@ static struct shash_alg alg = {
 	.base		=	{
 		.cra_name	=	"sha1",
 		.cra_driver_name=	"sha1-sparc64",
-		.cra_priority	=	150,
+		.cra_priority	=	SPARC_CR_OPCODE_PRIORITY,
 		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
 		.cra_blocksize	=	SHA1_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
diff --git a/arch/sparc/crypto/sha256_glue.c b/arch/sparc/crypto/sha256_glue.c
index 75e1ade..591e656 100644
--- a/arch/sparc/crypto/sha256_glue.c
+++ b/arch/sparc/crypto/sha256_glue.c
@@ -21,6 +21,8 @@
 #include <asm/pstate.h>
 #include <asm/elf.h>
 
+#include "opcodes.h"
+
 asmlinkage void sha256_sparc64_transform(u32 *digest, const char *data,
 					 unsigned int rounds);
 
@@ -166,6 +168,7 @@ static struct shash_alg sha256 = {
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name=	"sha256-sparc64",
+		.cra_priority	=	SPARC_CR_OPCODE_PRIORITY,
 		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
 		.cra_blocksize	=	SHA256_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
@@ -181,6 +184,7 @@ static struct shash_alg sha224 = {
 	.base		=	{
 		.cra_name	=	"sha224",
 		.cra_driver_name=	"sha224-sparc64",
+		.cra_priority	=	SPARC_CR_OPCODE_PRIORITY,
 		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
 		.cra_blocksize	=	SHA224_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
diff --git a/arch/sparc/crypto/sha512_glue.c b/arch/sparc/crypto/sha512_glue.c
index 4d960be..486f0a2 100644
--- a/arch/sparc/crypto/sha512_glue.c
+++ b/arch/sparc/crypto/sha512_glue.c
@@ -20,6 +20,8 @@
 #include <asm/pstate.h>
 #include <asm/elf.h>
 
+#include "opcodes.h"
+
 asmlinkage void sha512_sparc64_transform(u64 *digest, const char *data,
 					 unsigned int rounds);
 
@@ -151,6 +153,7 @@ static struct shash_alg sha512 = {
 	.base		=	{
 		.cra_name	=	"sha512",
 		.cra_driver_name=	"sha512-sparc64",
+		.cra_priority	=	SPARC_CR_OPCODE_PRIORITY,
 		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
 		.cra_blocksize	=	SHA512_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
@@ -166,6 +169,7 @@ static struct shash_alg sha384 = {
 	.base		=	{
 		.cra_name	=	"sha384",
 		.cra_driver_name=	"sha384-sparc64",
+		.cra_priority	=	SPARC_CR_OPCODE_PRIORITY,
 		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
 		.cra_blocksize	=	SHA384_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index a8bd031..aab2574 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -42,7 +42,7 @@ MODULE_DESCRIPTION("Niagara2 Crypto driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
 
-#define N2_CRA_PRIORITY		300
+#define N2_CRA_PRIORITY		200
 
 static DEFINE_MUTEX(spu_lock);
 
-- 
1.7.10.4

