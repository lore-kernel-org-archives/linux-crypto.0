Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68133E3D9E;
	Mon, 27 Apr 2026 17:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777310868; cv=none; b=bHGww4K5SnqzQQALvsOFI/h7qo42OkX8mc30FzjXSWSKWzQ5TD2O92CrjW92y6ilTgdZDWX/7jlHs3p72LN6AE7/ScrxdVlZRdcQXtn6WB6FHutjC4p3Qpuu3nUs8/lTvwxDAnmQqM+4lRflEAaKh1kDSszEKj63hqAI+GRhbr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777310868; c=relaxed/simple;
	bh=NowSzIkajZVB4CAlNLelZV9Eiq/85JAIX736v3Hk6O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEhcx5Z4k2eKfxdkOEcO+ZMzehCA2PFzwa7WJKO8xyNLvxqtln2Z0vG4IzpjTUHLx+iUlcumciKVFnJa+sJpB/N+b2zVpErY2ngErD+xWCVbygJM97B7t+kQNigp144+Nsw001/u4JKnNp3G+UzF3d37k3GRxizhBFmRtQ6hhrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5iLeF0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5iLeF0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD133C2BCB9;
	Mon, 27 Apr 2026 17:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777310868;
	bh=NowSzIkajZVB4CAlNLelZV9Eiq/85JAIX736v3Hk6O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5iLeF0n1teydM2x+7eRLXZBMCKEzAj7V6ZbqXPETRG1h3DWev3DijIQLUCB8CbIy
	 S+BhaBLFm//Zrm1iRc2NaKDHqQGxJ96QXknE4QgPFV9Aay2bRvZiQYSSFDuFyqZ+G9
	 +vNGLwUobrZ+03rtSIh+JT5yh0qrDucNggUk1aL+y6TOAfOYY+Xq4QkMrjwMSjyk8T
	 m/HLqUp9lBbOz6MlfBobLzTCxUpGHnccYx0PO0dGcElioKml4FQdyzD08YT6wF66BX
	 gmBitpzaW7FxjpJV/fsqmF+QPUMJqkdJh/OimU78lNOu9Yr1qzLxuxozZjbcsPxO1i
	 zxv7LI8HhqZIg==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net-next v2 1/5] net/tcp-ao: Drop support for most non-RFC-specified algorithms
Date: Mon, 27 Apr 2026 10:27:23 -0700
Message-ID: <20260427172727.9310-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260427172727.9310-1-ebiggers@kernel.org>
References: <20260427172727.9310-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RFC 5926 (https://datatracker.ietf.org/doc/html/rfc5926) specifies the
use of AES-128-CMAC and HMAC-SHA1 with TCP-AO.  This includes a
specification for how traffic keys shall be derived for each algorithm.

Support for any other algorithms with TCP-AO isn't standardized, though
an expired Internet Draft (a work-in-progress document, not a standard)
from 2019 does propose adding HMAC-SHA256 support:
https://datatracker.ietf.org/doc/html/draft-nayak-tcp-sha2-03

Since both documents specify the KDF for each algorithm individually, it
isn't necessarily clear how any other algorithm should be integrated.

Nevertheless, the Linux implementation of TCP-AO allows userspace to
specify the MAC algorithm as a string tcp_ao_add::alg_name naming either
"cmac(aes128)" or an arbitrary algorithm in the crypto_ahash API.  The
set of valid strings is undocumented.  The implementation assumes that
"cmac(aes128)" is the only algorithm that requires an entropy extraction
step and that all algorithms accept keys with length equal to the
untruncated MAC; thus, arbitrary HMAC algorithms probably do work, but
some other MAC algorithms like AES-256-CMAC have never actually worked.

Unfortunately, this undocumented string allows many obsolete, insecure,
or redundant algorithms.  For example, "hmac(md5)" and the
non-cryptographic "crc32" are accepted.  It also ties the implementation
to crypto_ahash and requires that most memory be dynamically allocated,
making the implementation unnecessarily complex and inefficient.  Still
furthermore, this implementation requires the crypto API to support
"transformation cloning", whose only user is this feature.

Fortunately, it's very likely that only a few algorithms are actually
used in practice.  Let's restrict the set of allowed algorithms to
"cmac(aes128)" (or "cmac(aes)" with keylen=16), "hmac(sha1)", and
"hmac(sha256)".  The first two are the actually standard ones, while
HMAC-SHA256 seems like a reasonable algorithm to continue supporting as
a Linux extension, considering the Internet Draft for it and the fact
that SHA-256 is the usual choice of upgrade from the outdated SHA-1.

If any other algorithm ever turns out to be needed, e.g. HMAC-SHA512, it
can of course be (re-)added in library form.  However, note that the TCP
options space limits TCP-AO MACs to 20 bytes (160 bits) anyway, which
limits the potential benefit of any further upgrade to the algorithm.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/ipv4/tcp_ao.c                             |  4 ++
 tools/testing/selftests/net/tcp_ao/config     |  1 -
 .../selftests/net/tcp_ao/key-management.c     | 41 ++-----------------
 3 files changed, 7 insertions(+), 39 deletions(-)

diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index a97cdf3e6af4..b21bd69b4e82 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1561,10 +1561,14 @@ static struct tcp_ao_key *tcp_ao_key_alloc(struct sock *sk,
 	cmd->alg_name[ARRAY_SIZE(cmd->alg_name) - 1] = '\0';
 
 	/* RFC5926, 3.1.1.2. KDF_AES_128_CMAC */
 	if (!strcmp("cmac(aes128)", algo))
 		algo = "cmac(aes)";
+	else if (strcmp("hmac(sha1)", algo) &&
+		 strcmp("hmac(sha256)", algo) &&
+		 (strcmp("cmac(aes)", algo) || cmd->keylen != 16))
+		return ERR_PTR(-ENOENT);
 
 	/* Full TCP header (th->doff << 2) should fit into scratch area,
 	 * see tcp_ao_hash_header().
 	 */
 	pool_id = tcp_sigpool_alloc_ahash(algo, 60);
diff --git a/tools/testing/selftests/net/tcp_ao/config b/tools/testing/selftests/net/tcp_ao/config
index f22148512365..47228a7d0b90 100644
--- a/tools/testing/selftests/net/tcp_ao/config
+++ b/tools/testing/selftests/net/tcp_ao/config
@@ -1,8 +1,7 @@
 CONFIG_CRYPTO_CMAC=y
 CONFIG_CRYPTO_HMAC=y
-CONFIG_CRYPTO_RMD160=y
 CONFIG_CRYPTO_SHA1=y
 CONFIG_IPV6=y
 CONFIG_IPV6_MULTIPLE_TABLES=y
 CONFIG_NET_L3_MASTER_DEV=y
 CONFIG_NET_VRF=y
diff --git a/tools/testing/selftests/net/tcp_ao/key-management.c b/tools/testing/selftests/net/tcp_ao/key-management.c
index 69d9a7a05d5c..d86bb380b79f 100644
--- a/tools/testing/selftests/net/tcp_ao/key-management.c
+++ b/tools/testing/selftests/net/tcp_ao/key-management.c
@@ -378,35 +378,10 @@ static void check_listen_socket(void)
 				  this_ip_dest, DEFAULT_TEST_PREFIX,
 				  false, true, 20, 10, FAULT_CURRNEXT);
 	close(sk);
 }
 
-static const char *fips_fpath = "/proc/sys/crypto/fips_enabled";
-static bool is_fips_enabled(void)
-{
-	static int fips_checked = -1;
-	FILE *fenabled;
-	int enabled;
-
-	if (fips_checked >= 0)
-		return !!fips_checked;
-	if (access(fips_fpath, R_OK)) {
-		if (errno != ENOENT)
-			test_error("Can't open %s", fips_fpath);
-		fips_checked = 0;
-		return false;
-	}
-	fenabled = fopen(fips_fpath, "r");
-	if (!fenabled)
-		test_error("Can't open %s", fips_fpath);
-	if (fscanf(fenabled, "%d", &enabled) != 1)
-		test_error("Can't read from %s", fips_fpath);
-	fclose(fenabled);
-	fips_checked = !!enabled;
-	return !!fips_checked;
-}
-
 struct test_key {
 	char password[TCP_AO_MAXKEYLEN];
 	const char *alg;
 	unsigned int len;
 	uint8_t client_keyid;
@@ -428,18 +403,11 @@ struct key_collection {
 };
 
 static struct key_collection collection;
 
 #define TEST_MAX_MACLEN		16
-const char *test_algos[] = {
-	"cmac(aes128)",
-	"hmac(sha1)", "hmac(sha512)", "hmac(sha384)", "hmac(sha256)",
-	"hmac(sha224)", "hmac(sha3-512)",
-	/* only if !CONFIG_FIPS */
-#define TEST_NON_FIPS_ALGOS	2
-	"hmac(rmd160)", "hmac(md5)"
-};
+const char *test_algos[] = { "cmac(aes128)", "hmac(sha1)", "hmac(sha256)" };
 const unsigned int test_maclens[] = { 1, 4, 12, 16 };
 #define MACLEN_SHIFT		2
 #define ALGOS_SHIFT		4
 
 static unsigned int make_mask(unsigned int shift, unsigned int prev_shift)
@@ -450,11 +418,11 @@ static unsigned int make_mask(unsigned int shift, unsigned int prev_shift)
 }
 
 static void init_key_in_collection(unsigned int index, bool randomized)
 {
 	struct test_key *key = &collection.keys[index];
-	unsigned int algos_nr, algos_index;
+	unsigned int algos_index;
 
 	/* Same for randomized and non-randomized test flows */
 	key->client_keyid = index;
 	key->server_keyid = 127 + index;
 	key->matches_client = 1;
@@ -472,14 +440,11 @@ static void init_key_in_collection(unsigned int index, bool randomized)
 		unsigned int shift = MACLEN_SHIFT;
 
 		key->maclen = test_maclens[index & make_mask(shift, 0)];
 		algos_index = index & make_mask(ALGOS_SHIFT, shift);
 	}
-	algos_nr = ARRAY_SIZE(test_algos);
-	if (is_fips_enabled())
-		algos_nr -= TEST_NON_FIPS_ALGOS;
-	key->alg = test_algos[algos_index % algos_nr];
+	key->alg = test_algos[algos_index % ARRAY_SIZE(test_algos)];
 }
 
 static int init_default_key_collection(unsigned int nr_keys, bool randomized)
 {
 	size_t key_sz = sizeof(collection.keys[0]);
-- 
2.54.0

