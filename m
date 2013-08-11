From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] crypto: make tables used from assembler __visible
Date: Sat, 10 Aug 2013 18:01:11 -0700
Message-ID: <1376182871-17690-1-git-send-email-andi@firstfloor.org>
Cc: linux-crypto@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:10018 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab3HKBBU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Aug 2013 21:01:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Andi Kleen <ak@linux.intel.com>

Tables used from assembler should be marked __visible to let
the compiler know.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/crypto/camellia_glue.c | 16 ++++++++--------
 crypto/aes_generic.c            |  8 ++++----
 crypto/cast_common.c            |  8 ++++----
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index 5cb86cc..fa4c1b9 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -62,7 +62,7 @@ static void camellia_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 }
 
 /* camellia sboxes */
-const u64 camellia_sp10011110[256] = {
+__visible const u64 camellia_sp10011110[256] = {
 	0x7000007070707000ULL, 0x8200008282828200ULL, 0x2c00002c2c2c2c00ULL,
 	0xec0000ecececec00ULL, 0xb30000b3b3b3b300ULL, 0x2700002727272700ULL,
 	0xc00000c0c0c0c000ULL, 0xe50000e5e5e5e500ULL, 0xe40000e4e4e4e400ULL,
@@ -151,7 +151,7 @@ const u64 camellia_sp10011110[256] = {
 	0x9e00009e9e9e9e00ULL,
 };
 
-const u64 camellia_sp22000222[256] = {
+__visible const u64 camellia_sp22000222[256] = {
 	0xe0e0000000e0e0e0ULL, 0x0505000000050505ULL, 0x5858000000585858ULL,
 	0xd9d9000000d9d9d9ULL, 0x6767000000676767ULL, 0x4e4e0000004e4e4eULL,
 	0x8181000000818181ULL, 0xcbcb000000cbcbcbULL, 0xc9c9000000c9c9c9ULL,
@@ -240,7 +240,7 @@ const u64 camellia_sp22000222[256] = {
 	0x3d3d0000003d3d3dULL,
 };
 
-const u64 camellia_sp03303033[256] = {
+__visible const u64 camellia_sp03303033[256] = {
 	0x0038380038003838ULL, 0x0041410041004141ULL, 0x0016160016001616ULL,
 	0x0076760076007676ULL, 0x00d9d900d900d9d9ULL, 0x0093930093009393ULL,
 	0x0060600060006060ULL, 0x00f2f200f200f2f2ULL, 0x0072720072007272ULL,
@@ -329,7 +329,7 @@ const u64 camellia_sp03303033[256] = {
 	0x004f4f004f004f4fULL,
 };
 
-const u64 camellia_sp00444404[256] = {
+__visible const u64 camellia_sp00444404[256] = {
 	0x0000707070700070ULL, 0x00002c2c2c2c002cULL, 0x0000b3b3b3b300b3ULL,
 	0x0000c0c0c0c000c0ULL, 0x0000e4e4e4e400e4ULL, 0x0000575757570057ULL,
 	0x0000eaeaeaea00eaULL, 0x0000aeaeaeae00aeULL, 0x0000232323230023ULL,
@@ -418,7 +418,7 @@ const u64 camellia_sp00444404[256] = {
 	0x00009e9e9e9e009eULL,
 };
 
-const u64 camellia_sp02220222[256] = {
+__visible const u64 camellia_sp02220222[256] = {
 	0x00e0e0e000e0e0e0ULL, 0x0005050500050505ULL, 0x0058585800585858ULL,
 	0x00d9d9d900d9d9d9ULL, 0x0067676700676767ULL, 0x004e4e4e004e4e4eULL,
 	0x0081818100818181ULL, 0x00cbcbcb00cbcbcbULL, 0x00c9c9c900c9c9c9ULL,
@@ -507,7 +507,7 @@ const u64 camellia_sp02220222[256] = {
 	0x003d3d3d003d3d3dULL,
 };
 
-const u64 camellia_sp30333033[256] = {
+__visible const u64 camellia_sp30333033[256] = {
 	0x3800383838003838ULL, 0x4100414141004141ULL, 0x1600161616001616ULL,
 	0x7600767676007676ULL, 0xd900d9d9d900d9d9ULL, 0x9300939393009393ULL,
 	0x6000606060006060ULL, 0xf200f2f2f200f2f2ULL, 0x7200727272007272ULL,
@@ -596,7 +596,7 @@ const u64 camellia_sp30333033[256] = {
 	0x4f004f4f4f004f4fULL,
 };
 
-const u64 camellia_sp44044404[256] = {
+__visible const u64 camellia_sp44044404[256] = {
 	0x7070007070700070ULL, 0x2c2c002c2c2c002cULL, 0xb3b300b3b3b300b3ULL,
 	0xc0c000c0c0c000c0ULL, 0xe4e400e4e4e400e4ULL, 0x5757005757570057ULL,
 	0xeaea00eaeaea00eaULL, 0xaeae00aeaeae00aeULL, 0x2323002323230023ULL,
@@ -685,7 +685,7 @@ const u64 camellia_sp44044404[256] = {
 	0x9e9e009e9e9e009eULL,
 };
 
-const u64 camellia_sp11101110[256] = {
+__visible const u64 camellia_sp11101110[256] = {
 	0x7070700070707000ULL, 0x8282820082828200ULL, 0x2c2c2c002c2c2c00ULL,
 	0xececec00ececec00ULL, 0xb3b3b300b3b3b300ULL, 0x2727270027272700ULL,
 	0xc0c0c000c0c0c000ULL, 0xe5e5e500e5e5e500ULL, 0xe4e4e400e4e4e400ULL,
diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index 47f2e5c..fd0d6b4 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -62,7 +62,7 @@ static inline u8 byte(const u32 x, const unsigned n)
 
 static const u32 rco_tab[10] = { 1, 2, 4, 8, 16, 32, 64, 128, 27, 54 };
 
-const u32 crypto_ft_tab[4][256] = {
+__visible const u32 crypto_ft_tab[4][256] = {
 	{
 		0xa56363c6, 0x847c7cf8, 0x997777ee, 0x8d7b7bf6,
 		0x0df2f2ff, 0xbd6b6bd6, 0xb16f6fde, 0x54c5c591,
@@ -326,7 +326,7 @@ const u32 crypto_ft_tab[4][256] = {
 	}
 };
 
-const u32 crypto_fl_tab[4][256] = {
+__visible const u32 crypto_fl_tab[4][256] = {
 	{
 		0x00000063, 0x0000007c, 0x00000077, 0x0000007b,
 		0x000000f2, 0x0000006b, 0x0000006f, 0x000000c5,
@@ -590,7 +590,7 @@ const u32 crypto_fl_tab[4][256] = {
 	}
 };
 
-const u32 crypto_it_tab[4][256] = {
+__visible const u32 crypto_it_tab[4][256] = {
 	{
 		0x50a7f451, 0x5365417e, 0xc3a4171a, 0x965e273a,
 		0xcb6bab3b, 0xf1459d1f, 0xab58faac, 0x9303e34b,
@@ -854,7 +854,7 @@ const u32 crypto_it_tab[4][256] = {
 	}
 };
 
-const u32 crypto_il_tab[4][256] = {
+__visible const u32 crypto_il_tab[4][256] = {
 	{
 		0x00000052, 0x00000009, 0x0000006a, 0x000000d5,
 		0x00000030, 0x00000036, 0x000000a5, 0x00000038,
diff --git a/crypto/cast_common.c b/crypto/cast_common.c
index a15f523..117dd82 100644
--- a/crypto/cast_common.c
+++ b/crypto/cast_common.c
@@ -15,7 +15,7 @@
 #include <linux/module.h>
 #include <crypto/cast_common.h>
 
-const u32 cast_s1[256] = {
+__visible const u32 cast_s1[256] = {
 	0x30fb40d4, 0x9fa0ff0b, 0x6beccd2f, 0x3f258c7a, 0x1e213f2f,
 	0x9c004dd3, 0x6003e540, 0xcf9fc949,
 	0xbfd4af27, 0x88bbbdb5, 0xe2034090, 0x98d09675, 0x6e63a0e0,
@@ -83,7 +83,7 @@ const u32 cast_s1[256] = {
 };
 EXPORT_SYMBOL_GPL(cast_s1);
 
-const u32 cast_s2[256] = {
+__visible const u32 cast_s2[256] = {
 	0x1f201094, 0xef0ba75b, 0x69e3cf7e, 0x393f4380, 0xfe61cf7a,
 	0xeec5207a, 0x55889c94, 0x72fc0651,
 	0xada7ef79, 0x4e1d7235, 0xd55a63ce, 0xde0436ba, 0x99c430ef,
@@ -151,7 +151,7 @@ const u32 cast_s2[256] = {
 };
 EXPORT_SYMBOL_GPL(cast_s2);
 
-const u32 cast_s3[256] = {
+__visible const u32 cast_s3[256] = {
 	0x8defc240, 0x25fa5d9f, 0xeb903dbf, 0xe810c907, 0x47607fff,
 	0x369fe44b, 0x8c1fc644, 0xaececa90,
 	0xbeb1f9bf, 0xeefbcaea, 0xe8cf1950, 0x51df07ae, 0x920e8806,
@@ -219,7 +219,7 @@ const u32 cast_s3[256] = {
 };
 EXPORT_SYMBOL_GPL(cast_s3);
 
-const u32 cast_s4[256] = {
+__visible const u32 cast_s4[256] = {
 	0x9db30420, 0x1fb6e9de, 0xa7be7bef, 0xd273a298, 0x4a4f7bdb,
 	0x64ad8c57, 0x85510443, 0xfa020ed1,
 	0x7e287aff, 0xe60fb663, 0x095f35a1, 0x79ebf120, 0xfd059d43,
-- 
1.8.3.1
