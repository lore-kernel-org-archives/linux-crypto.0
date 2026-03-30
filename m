Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0723254B3
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882003; cv=none; b=QAefJkTTBOWvxg6KEUJswEOXa0M6IXZuXG6ORT1uXDQH/C4xjCyRQVTRyVuRtS0dLfEvIKeH3UuCVkHKHmib4yOyBVspJlC1dkOboOIgQhR7JwefHL1OoITcaEPnn5LbFDtgWTG9j+MZQXnzJSAaGMymoYnN/gCGhynvPHF2te4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882003; c=relaxed/simple;
	bh=5V9bXxWmYXvrmutVJY6nsrGoOdvZArmahKRGSQilrU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YT3h+1ii7Z794Eai5LHdXY8XEpRY0qGF5bO9ZCBNzwjk03n6T33q+BSqkirboqv9K0dxCchQ4w1G6/EefxyI3PivdzhWNm4Zx0hPS+djO46gxhJnCB9J5zZu4AAkbsEvO45Dfw1kDjoPB20JIc+EPB6EoDA6ocI0BFrDXnOIqCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spme1y9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spme1y9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AA9C4CEF7;
	Mon, 30 Mar 2026 14:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882002;
	bh=5V9bXxWmYXvrmutVJY6nsrGoOdvZArmahKRGSQilrU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spme1y9S3UqclPAT4pHAj/Gm6PPg0wyYqc3gZigumyeUc/d4esllbb7n5apOSz0W7
	 P2A9/zuvpLw8qdiuoxBBkOWIxwYMBsu5n2JN0ymE6W2bHN8sm4darlB8MZcaYCGqAD
	 f/jpBy/WQoLNNHNUqsZ1Zafq8YiD1EUd11vTkPQh1Cnvi9ILe1jHz84Og4T8Zd+sdp
	 W8Kt1Gi5p43sia9HH64hJSZ+ycs7Til0AcqfotW07GWdGDFbiEr6jDbu5BZYEU2PJT
	 LQHCKnBRz2yIFU4/EjF7S6NcbuWj5IxISApwEmiXM7tpHQn7+eGq0XU8dlwA9/iinB
	 MIFNzSq+vaGgQ==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Demian Shulhan <demyansh@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/5] lib/crc: arm64: Drop unnecessary chunking logic from crc64
Date: Mon, 30 Mar 2026 16:46:32 +0200
Message-ID: <20260330144630.33026-8-ardb@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330144630.33026-7-ardb@kernel.org>
References: <20260330144630.33026-7-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1010; i=ardb@kernel.org; h=from:subject; bh=5V9bXxWmYXvrmutVJY6nsrGoOdvZArmahKRGSQilrU0=; b=owGbwMvMwCn83sBh/rljoYmMp9WSGDJP9RyXXunSke/JOvfT9e+75tWpXl72fMMKB+XX5+aly gXNEl29sWMqC4MwJ4OsmCLLTuWc7tcuou/0FSpzYOawMoEMYeDiFICJ7M1lrHfW6Gd5Wv+XK//2 jVx/ttKZC0q3JL9/+m7HP5kLy+WvKX+5wZ+844jHGdWc1XraEyOrJjDWZwmubvoim1h3Sv6OTbP AkQkVe2y2fDv8WD769aTzEZckg7N0RKue35nbpp2wMUM1a+d9AA==
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

On arm64, kernel mode NEON executes with preemption enabled, so there is
no need to chunk the input by hand.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/crc/arm64/crc64.h | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/lib/crc/arm64/crc64.h b/lib/crc/arm64/crc64.h
index cc65abeee24c..ab052a782c07 100644
--- a/lib/crc/arm64/crc64.h
+++ b/lib/crc/arm64/crc64.h
@@ -16,15 +16,13 @@ static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
 {
 	if (len >= 128 && cpu_have_named_feature(PMULL) &&
 	    likely(may_use_simd())) {
-		do {
-			size_t chunk = min_t(size_t, len & ~15, SZ_4K);
+		size_t chunk = len & ~15;
 
-			scoped_ksimd()
-				crc = crc64_nvme_arm64_c(crc, p, chunk);
+		scoped_ksimd()
+			crc = crc64_nvme_arm64_c(crc, p, chunk);
 
-			p += chunk;
-			len -= chunk;
-		} while (len >= 128);
+		p += chunk;
+		len &= 15;
 	}
 	return crc64_nvme_generic(crc, p, len);
 }
-- 
2.53.0.1018.g2bb0e51243-goog

