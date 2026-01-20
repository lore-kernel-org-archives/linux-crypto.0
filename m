Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A95C33B97B;
	Tue, 20 Jan 2026 18:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768934849; cv=none; b=avjTlxFMwBJoPKXoFuM5qkYFdZreR5Fd3X9H0NpuKGKaWv5G+JUxfsek0vC1IjrqWmiQ0xRqt/TZzoZlx4W0+kWGRP40x+H9MUO8bgvo2FHWlTHRTZxwpsE2w4+SuBKY9QzwKtLwVkfHmZgcTQf/EJXFPf1aJo8x40of3/ES21c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768934849; c=relaxed/simple;
	bh=zZzTjp8LW50c+/PnLAP9MFCT5Uee5ZryuglRW6uFUVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krKqFckSdO4YaZ6MH3RMv4c/zJWCEz1FJmMk28+ANeK64vEq5hMiLYT96K2V4BGEr5E2xJsEb73fF1pLaYW67P753dly+RR0L2RtMbWgQIMxgtmcHuOI+eaX2AQgc9v9uP7K0eLFwqLVu8YmQYMZW3vuxC2banG3qmoZoLm7Jck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=aBWVSTxo; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=5lQNuHF8; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="aBWVSTxo";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="5lQNuHF8"
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1768934822; bh=HXNKsof97IrzFxv0lebEahi
	VFImS2I8SH2sejmJkd2w=; b=aBWVSTxoBmbuFe6EQ14OP2WCtT0w4NeuVplhEK6YaskDr5igZF
	1TYqQnMgbSvINMDO+4B6mpf6gi+5Is0hPmE6jrZe/HqhdgBA8aVlTlmNRpURBu/5THFrLtj7wD4
	k0K2R6skViTyb3UrO7a9JJG14e9azlz3His9XdYqbEijJHgw1t6Bh1ua9sxcNlXpTxCoajcBSgm
	IUKVyhUwvexsxb2h9O1L5+IJ/lVjv4LXmd4wcJ512RjcNRRhMEcsL8FQzss8sqgSxnp0qpOFZ46
	LDAAg3HWRz70m6IhILVhv3msSzCBEfYEL2u7/0zk1F9EDLNXqbqNUpLSyubov65ErIg==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1768934822; bh=HXNKsof97IrzFxv0lebEahi
	VFImS2I8SH2sejmJkd2w=; b=5lQNuHF80xO4fX4dJ2MAg7EoYbqQRYH8ApMOhBrHdSMTwxiLEc
	NH66vtJ7Cro/BLzE9xlK6HZraUi5zN5uG4BQ==;
From: Daniel Hodges <git@danielhodges.dev>
To: bpf@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Song Liu <song@kernel.org>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Yonghong Song <yonghong.song@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Daniel Hodges <git@danielhodges.dev>
Subject: [PATCH bpf-next v5 1/7] bpf: Extend bpf_crypto_type with hash operations
Date: Tue, 20 Jan 2026 13:46:55 -0500
Message-ID: <20260120184701.23082-2-git@danielhodges.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260120184701.23082-1-git@danielhodges.dev>
References: <20260120184701.23082-1-git@danielhodges.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add hash operation callbacks to bpf_crypto_type structure:
 - hash(): Performs hashing operation on input data
 - digestsize(): Returns the output size for the hash algorithm

These additions enable BPF programs to use cryptographic hash functions
through the unified bpf_crypto_type interface, supporting use cases such
as content verification, integrity checking, and data authentication.

Signed-off-by: Daniel Hodges <git@danielhodges.dev>
---
 include/linux/bpf_crypto.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/bpf_crypto.h b/include/linux/bpf_crypto.h
index a41e71d4e2d9..c84371cc4e47 100644
--- a/include/linux/bpf_crypto.h
+++ b/include/linux/bpf_crypto.h
@@ -11,8 +11,10 @@ struct bpf_crypto_type {
 	int (*setauthsize)(void *tfm, unsigned int authsize);
 	int (*encrypt)(void *tfm, const u8 *src, u8 *dst, unsigned int len, u8 *iv);
 	int (*decrypt)(void *tfm, const u8 *src, u8 *dst, unsigned int len, u8 *iv);
+	int (*hash)(void *tfm, const u8 *data, u8 *out, unsigned int len);
 	unsigned int (*ivsize)(void *tfm);
 	unsigned int (*statesize)(void *tfm);
+	unsigned int (*digestsize)(void *tfm);
 	u32 (*get_flags)(void *tfm);
 	struct module *owner;
 	char name[14];
-- 
2.52.0

