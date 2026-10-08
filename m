Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1AB430CD5;
	Thu,  8 Oct 2026 20:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791490814; cv=none; b=MjtJfDLmGSsNehJ7MMz6t73u4YjRUPmqddMfDM1l6VnJJkVUHuvLByQzFZcCnuh6/sdwmVpyWRIPnpFFd+SEgEBDrqbvAYvy/wfQUvBrz4815BS9GhO7Itt5/JVpx7f084gSrRjbRj4tdtXuoYj9Kyh3sW8tCXlLaWpp/iZPIZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791490814; c=relaxed/simple;
	bh=6gWNJeAYMN5jTK6l/Hc9el4e0HiEQAPczX5hsvFhppU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q6YcRlb55PcmhQg6tdCg+B0RnmAioleZd6SueEXyV9YF67u389DW6bj8ngk010joezBbXqIkjmaiP1LPcKE/soRgp1cs5wRzubM6sxNYQmb+LAs3kynBM3XnkkPZ/wUCYdmH1QqUV6JdEOJTfvq83lfRamE8xL13UxxbDwEKojo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=FnetZb3y; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="FnetZb3y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=VvHQUySArlyUy6XdBt7Tqo9y7tzCIS89p90zj8O806E=; b=FnetZb3ypu6U7vvyic15fZr3MT
	vAoQ80XtcfL2+3N8rl4uiJImvKVz/V3nEBjTB304qnA+3zKYYKJiZJTtHp6BFrVQxou2jNfApwuLF
	1a4eeZTouEWFjFdgWj8nehW7GakEoBCgLUiKVV34WpLIy57ejLaFAMEWIMIyxoZdnE7FH3arLFue+
	c5uL3D1Cwf8XOZE4xAnzaNJGrwGse3m4pLIqhwq2MyspAtCFTzGDH/mvu/luSZlzg+WrVVQqZziRV
	ErvTHW5lNKSuykAzVPd+mrd7efmpevxi67ak/suu1FjGal2XsWNX5icgBWSi5ui2LXTLC70D5nfgw
	jccLduwA==;
Received: from [151.115.150.205] (port=38102 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xEub2-00000002wY0-3HsA;
	Thu, 08 Oct 2026 22:20:08 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH v2 2/2] lib/crypto: tests: Add Poly1305 split-update carry regression test
Date: Thu,  8 Oct 2026 20:19:51 +0000
Message-ID: <20261008201949.561207-5-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261008201949.561207-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261008201949.561207-2-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

Add a Poly1305 KUnit test for a split-update sequence that forces an
implementation to resume from an intermediate accumulator state and still
produce the same final tag.

The witness uses r=1, s=0, a 304-byte message with block 5 equal to
2^128 - 6, and update lengths 128, 144, and 32.  On arm64 before the
preceding fix, the NEON backend emits 0e000000000000000000000000000000
instead of 13000000000000000000000000000000 because the odd-block resume
path drops a carry while converting a base 2^26 accumulator back to
base 2^64.

Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 lib/crypto/tests/poly1305_kunit.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/lib/crypto/tests/poly1305_kunit.c b/lib/crypto/tests/poly1305_kunit.c
index f3cb6245bc29..752b503d7a7b 100644
--- a/lib/crypto/tests/poly1305_kunit.c
+++ b/lib/crypto/tests/poly1305_kunit.c
@@ -141,10 +141,41 @@ static void test_poly1305_reduction_edge_cases(struct kunit *test)
 	}
 }
 
+/*
+ * Poly1305 test case which uses r_key=1, s_key=0 and a split update sequence
+ * that exercises a carry while resuming from a base 2^26 accumulator.
+ *
+ * The first update leaves the arm64 NEON implementation in base 2^26. The
+ * second update contains an odd number of blocks, so it converts that
+ * accumulator back to base 2^64 before processing the first block.
+ */
+static void test_poly1305_split_update_carry(struct kunit *test)
+{
+	static const u8 key[POLY1305_KEY_SIZE] = { 1 }; /* r_key=1, s_key=0 */
+	static const u8 expected_mac[POLY1305_DIGEST_SIZE] = { 0x13 };
+	u8 data[304] = {};
+	struct poly1305_desc_ctx ctx;
+	u8 actual_mac[POLY1305_DIGEST_SIZE];
+
+	/* Set the fifth data block to 2**128 - 6. */
+	data[64] = 0xfa;
+	memset(&data[65], 0xff, POLY1305_BLOCK_SIZE - 1);
+
+	poly1305_init(&ctx, key);
+	poly1305_update(&ctx, data, 128);
+	poly1305_update(&ctx, data + 128, 144);
+	poly1305_update(&ctx, data + 272, 32);
+	poly1305_final(&ctx, actual_mac);
+
+	KUNIT_ASSERT_MEMEQ(test, actual_mac, expected_mac,
+			   POLY1305_DIGEST_SIZE);
+}
+
 static struct kunit_case poly1305_test_cases[] = {
 	HASH_KUNIT_CASES,
 	KUNIT_CASE(test_poly1305_allones_keys_and_message),
 	KUNIT_CASE(test_poly1305_reduction_edge_cases),
+	KUNIT_CASE(test_poly1305_split_update_carry),
 	KUNIT_CASE(benchmark_hash),
 	{},
 };
-- 
2.47.3

