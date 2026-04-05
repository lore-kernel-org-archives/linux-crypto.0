Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03948F49;
	Sun,  5 Apr 2026 01:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775351771; cv=none; b=MlT2LWmfL9F2ST2UTiIOObP6q0Ev2hc9JscsGTSJeeOGJlOHk63nxuEkmki1Kja38mXVqdtceacXtlobFCCQLqdDzgdmoCiO6h6fXEM2XDwxC3eVFYZm26RtiW7DEcDkO2ET48uavaOKQ8zNsz7aivDhi9olgBLxAxbpNV4SDJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775351771; c=relaxed/simple;
	bh=wUgAW77gLesDjJ7akGuuOi0lJVwMR3VmDH0R9wN+Zqc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SodeKMBIuMKFIj3uZrrXWop61ZixRAcWVYW66Ikpsn9wGmos0Nuc5A/PYmY//LmiXItMFWWoNi5NkOhuMREfV7mGjfS4Xv9YJTq0PwLAzswRCtT5FkcXeTio1o/p2yL5G++w16ahtXqkCnuSDHJ1+zUfPF8cY+kWD14Sd1h2ZZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=efXHlYEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efXHlYEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F63C19421;
	Sun,  5 Apr 2026 01:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775351770;
	bh=wUgAW77gLesDjJ7akGuuOi0lJVwMR3VmDH0R9wN+Zqc=;
	h=From:To:Cc:Subject:Date:From;
	b=efXHlYEja0pThEY2fOHOyN/swby0n6ciyBLloFawRc51FOtUFPvmsiFI7hTO/TeIa
	 IG8a34tByjKDnkVGYkI7T0N1KQ1QIPw9zERC5DYReQvNvKktwG+FYVr4scTWUfZxuw
	 vDKp3U492MeGimClOFRSeQYZRrz5I54VerJbdlgWVxUHQNP7HvTP0ms9Sh1X9bUN/l
	 sajcqgjmE8c8t2oc9ICQimbOx0AkrTYc/5lVZHIBlTNjbDdsxvi1speai5C/SXuPQg
	 w9+XDGMk7MFmffsoI5fcT9uK4ISuw0gtH3RiYtRYoFWs5qhNShY2H4mNMye3hvkSdp
	 j5mYlEf1r+LdA==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH ipsec-next] xfrm: Drop support for HMAC-RIPEMD-160
Date: Sat,  4 Apr 2026 18:15:13 -0700
Message-ID: <20260405011513.64909-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop support for HMAC-RIPEMD-160 from IPsec to reduce the UAPI surface
and simplify future maintenance.  It's almost certainly unused.

RIPEMD-160 received some attention in the early 2000s when SHA-* weren't
quite as well established.  But it never received much adoption outside
of certain niches such as Bitcoin.

It's actually unclear that Linux + IPsec + HMAC-RIPEMD-160 has *ever*
been used, even historically.  When support for it was added in 2003, it
was done so in a "cleanup" commit without any justification [1].  It
didn't actually work until someone happened to fix it 5 years later [2].
That person didn't use or test it either [3].  Finally, also note that
"hmac(rmd160)" is by far the slowest of the algorithms in aalg_list[].

Of course, today IPsec is usually used with an AEAD, such as AES-GCM.
But even for IPsec users still using a dedicated auth algorithm, they
almost certainly aren't using, and shouldn't use, HMAC-RIPEMD-160.

Thus, let's just drop support for it.  Note: no kconfig update is
needed, since CRYPTO_RMD160 wasn't actually being selected anyway.

References:
  [1] linux-history commit d462985fc1941a47
      ("[IPSEC]: Clean up key manager algorithm handling.")
  [2] linux commit a13366c632132bb9
      ("xfrm: xfrm_algo: correct usage of RIPEMD-160")
  [3] https://lore.kernel.org/all/1212340578-15574-1-git-send-email-rueegsegger@swiss-it.ch

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/xfrm/xfrm_algo.c                | 20 --------------------
 tools/testing/selftests/net/ipsec.c |  8 ++------
 2 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 749011e031c0a..70434495f23f5 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -288,30 +288,10 @@ static struct xfrm_algo_desc aalg_list[] = {
 		.sadb_alg_ivlen = 0,
 		.sadb_alg_minbits = 512,
 		.sadb_alg_maxbits = 512
 	}
 },
-{
-	.name = "hmac(rmd160)",
-	.compat = "rmd160",
-
-	.uinfo = {
-		.auth = {
-			.icv_truncbits = 96,
-			.icv_fullbits = 160,
-		}
-	},
-
-	.pfkey_supported = 1,
-
-	.desc = {
-		.sadb_alg_id = SADB_X_AALG_RIPEMD160HMAC,
-		.sadb_alg_ivlen = 0,
-		.sadb_alg_minbits = 160,
-		.sadb_alg_maxbits = 160
-	}
-},
 {
 	.name = "xcbc(aes)",
 
 	.uinfo = {
 		.auth = {
diff --git a/tools/testing/selftests/net/ipsec.c b/tools/testing/selftests/net/ipsec.c
index f4afef51b9307..89c32c354c008 100644
--- a/tools/testing/selftests/net/ipsec.c
+++ b/tools/testing/selftests/net/ipsec.c
@@ -60,12 +60,10 @@
 #define grchild_ip(nr)	(4*nr + 2)
 
 #define VETH_FMT	"ktst-%d"
 #define VETH_LEN	12
 
-#define XFRM_ALGO_NR_KEYS 29
-
 static int nsfd_parent	= -1;
 static int nsfd_childa	= -1;
 static int nsfd_childb	= -1;
 static long page_size;
 
@@ -94,11 +92,10 @@ struct xfrm_key_entry xfrm_key_entries[] = {
 	{"cmac(aes)", 128},
 	{"xcbc(aes)", 128},
 	{"cbc(cast5)", 128},
 	{"cbc(serpent)", 128},
 	{"hmac(sha1)", 160},
-	{"hmac(rmd160)", 160},
 	{"cbc(des3_ede)", 192},
 	{"hmac(sha256)", 256},
 	{"cbc(aes)", 256},
 	{"cbc(camellia)", 256},
 	{"cbc(twofish)", 256},
@@ -811,11 +808,11 @@ static int do_ping(int cmd_fd, char *buf, size_t buf_len, struct in_addr from,
 static int xfrm_fill_key(char *name, char *buf,
 		size_t buf_len, unsigned int *key_len)
 {
 	int i;
 
-	for (i = 0; i < XFRM_ALGO_NR_KEYS; i++) {
+	for (i = 0; i < ARRAY_SIZE(xfrm_key_entries); i++) {
 		if (strncmp(name, xfrm_key_entries[i].algo_name, ALGO_LEN) == 0)
 			*key_len = xfrm_key_entries[i].key_len;
 	}
 
 	if (*key_len > buf_len) {
@@ -2059,12 +2056,11 @@ static int write_desc(int proto, int test_desc_fd,
 }
 
 int proto_list[] = { IPPROTO_AH, IPPROTO_COMP, IPPROTO_ESP };
 char *ah_list[] = {
 	"digest_null", "hmac(md5)", "hmac(sha1)", "hmac(sha256)",
-	"hmac(sha384)", "hmac(sha512)", "hmac(rmd160)",
-	"xcbc(aes)", "cmac(aes)"
+	"hmac(sha384)", "hmac(sha512)", "xcbc(aes)", "cmac(aes)"
 };
 char *comp_list[] = {
 	"deflate",
 #if 0
 	/* No compression backend realization */

base-commit: be14d13625c9b070c33c423026b598ed65695225
-- 
2.53.0

