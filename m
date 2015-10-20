From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 8/8] crypto: testmgr: Use the xxx_zero_message_hash from headers
Date: Tue, 20 Oct 2015 09:34:04 +0200
Message-ID: <1445326444-11019-9-git-send-email-clabbe.montjoie@gmail.com>
References: <1445326444-11019-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445326444-11019-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Since md5/shaxxx headers have hash for zero message length, just use them.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 crypto/testmgr.h | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 03b2f19..7a8f51e 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -28,6 +28,8 @@
 #include <linux/zlib.h>
 
 #include <crypto/compress.h>
+#include <crypto/md5.h>
+#include <crypto/sha.h>
 
 #define MAX_DIGEST_SIZE		64
 #define MAX_TAP			8
@@ -367,8 +369,7 @@ static struct hash_testvec md4_tv_template [] = {
 
 static struct hash_testvec md5_tv_template[] = {
 	{
-		.digest	= "\xd4\x1d\x8c\xd9\x8f\x00\xb2\x04"
-			  "\xe9\x80\x09\x98\xec\xf8\x42\x7e",
+		.digest	= md5_zero_message_hash,
 	}, {
 		.plaintext = "a",
 		.psize	= 1,
@@ -713,8 +714,7 @@ static struct hash_testvec sha1_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
-		.digest	= "\xda\x39\xa3\xee\x5e\x6b\x4b\x0d\x32\x55"
-			  "\xbf\xef\x95\x60\x18\x90\xaf\xd8\x07\x09",
+		.digest	= sha1_zero_message_hash,
 	}, {
 		.plaintext = "abc",
 		.psize	= 3,
@@ -905,10 +905,7 @@ static struct hash_testvec sha224_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
-		.digest	= "\xd1\x4a\x02\x8c\x2a\x3a\x2b\xc9"
-			  "\x47\x61\x02\xbb\x28\x82\x34\xc4"
-			  "\x15\xa2\xb0\x1f\x82\x8e\xa6\x2a"
-			  "\xc5\xb3\xe4\x2f",
+		.digest	= sha224_zero_message_hash,
 	}, {
 		.plaintext = "abc",
 		.psize  = 3,
@@ -1079,10 +1076,7 @@ static struct hash_testvec sha256_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
-		.digest	= "\xe3\xb0\xc4\x42\x98\xfc\x1c\x14"
-			  "\x9a\xfb\xf4\xc8\x99\x6f\xb9\x24"
-			  "\x27\xae\x41\xe4\x64\x9b\x93\x4c"
-			  "\xa4\x95\x99\x1b\x78\x52\xb8\x55",
+		.digest	= sha256_zero_message_hash,
 	}, {
 		.plaintext = "abc",
 		.psize	= 3,
-- 
2.4.10
