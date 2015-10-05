From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH] sparc/crypto: initialize blkcipher.ivsize
Date: Mon, 5 Oct 2015 10:08:51 -0500
Message-ID: <56129283.1090804@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, sparclinux@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Some of the crypto algorithms write to the initialization vector,
but no space has been allocated for it. This clobbers adjacent memory.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 arch/sparc/crypto/aes_glue.c      | 2 ++
 arch/sparc/crypto/camellia_glue.c | 1 +
 arch/sparc/crypto/des_glue.c      | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/arch/sparc/crypto/aes_glue.c b/arch/sparc/crypto/aes_glue.c
index 2e48eb8..c90930d 100644
--- a/arch/sparc/crypto/aes_glue.c
+++ b/arch/sparc/crypto/aes_glue.c
@@ -433,6 +433,7 @@ static struct crypto_alg algs[] = { {
 		.blkcipher = {
 			.min_keysize	= AES_MIN_KEY_SIZE,
 			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
 			.setkey		= aes_set_key,
 			.encrypt	= cbc_encrypt,
 			.decrypt	= cbc_decrypt,
@@ -452,6 +453,7 @@ static struct crypto_alg algs[] = { {
 		.blkcipher = {
 			.min_keysize	= AES_MIN_KEY_SIZE,
 			.max_keysize	= AES_MAX_KEY_SIZE,
+			.ivsize		= AES_BLOCK_SIZE,
 			.setkey		= aes_set_key,
 			.encrypt	= ctr_crypt,
 			.decrypt	= ctr_crypt,
diff --git a/arch/sparc/crypto/camellia_glue.c b/arch/sparc/crypto/camellia_glue.c
index 6bf2479..561a84d 100644
--- a/arch/sparc/crypto/camellia_glue.c
+++ b/arch/sparc/crypto/camellia_glue.c
@@ -274,6 +274,7 @@ static struct crypto_alg algs[] = { {
 		.blkcipher = {
 			.min_keysize	= CAMELLIA_MIN_KEY_SIZE,
 			.max_keysize	= CAMELLIA_MAX_KEY_SIZE,
+			.ivsize		= CAMELLIA_BLOCK_SIZE,
 			.setkey		= camellia_set_key,
 			.encrypt	= cbc_encrypt,
 			.decrypt	= cbc_decrypt,
diff --git a/arch/sparc/crypto/des_glue.c b/arch/sparc/crypto/des_glue.c
index dd6a34f..61af794 100644
--- a/arch/sparc/crypto/des_glue.c
+++ b/arch/sparc/crypto/des_glue.c
@@ -429,6 +429,7 @@ static struct crypto_alg algs[] = { {
 		.blkcipher = {
 			.min_keysize	= DES_KEY_SIZE,
 			.max_keysize	= DES_KEY_SIZE,
+			.ivsize		= DES_BLOCK_SIZE,
 			.setkey		= des_set_key,
 			.encrypt	= cbc_encrypt,
 			.decrypt	= cbc_decrypt,
@@ -485,6 +486,7 @@ static struct crypto_alg algs[] = { {
 		.blkcipher = {
 			.min_keysize	= DES3_EDE_KEY_SIZE,
 			.max_keysize	= DES3_EDE_KEY_SIZE,
+			.ivsize		= DES3_EDE_BLOCK_SIZE,
 			.setkey		= des3_ede_set_key,
 			.encrypt	= cbc3_encrypt,
 			.decrypt	= cbc3_decrypt,
-- 
2.6.0

