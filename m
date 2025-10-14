Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84F63009E2;
	Tue, 14 Oct 2025 21:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760476627; cv=none; b=t9+/tiWEMM7GMcamMxSygqsq9zKz1iOM4WDJua1PuZTKta4HaN2XZXWCmLoh+v65Ja3aCMEiqTR0upw9JnfqKYU0VFqSsWUxIDXrfa6dcTS44UIedEXB7DUtBiUEgRn1ihMnpnfsYlBPcFArIhjLni5wyp3h70j/VjId45e1aMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760476627; c=relaxed/simple;
	bh=/i7aSqN4aWWRt6aoz8xnAbh6lHeBAxTQgGxD3x2T3Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBFpQWK/DUtUSKnTw1yL5+yonS46fF1qmJfT+THu7OjxwYmNqQmC+C70BnApOUYEGSykR8afqvz/eCVULaosl5SWzu8LKkPDdda9vKqfbTfSFuovAvtFcr03KWtXQBSbs7cILRhLKXuS3MpJbf2MM8JUhMjgby7bKi0vvGqRHLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DRpmXK4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DRpmXK4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D84C4CEF9;
	Tue, 14 Oct 2025 21:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760476626;
	bh=/i7aSqN4aWWRt6aoz8xnAbh6lHeBAxTQgGxD3x2T3Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRpmXK4vYJ6PD4sPnjY3u5+vFc0x3g6Lh8TdAGalSovPaLf/qm3L1YfHTZQXk1iR0
	 R5kLu+1MJXJH/FoaT3TtuXTHXisAcvDQwIsIZsd8uOAq2HTuyAUxbFs/X9OWtYtv4p
	 /FBLNUZ45sdQz/9mUk474MTiiXMPYwK9skqY3QZdV0TTrmswAWe3HNabZ06WjKxixZ
	 75Ig9aHaw2VGfH3vlxGMfF5JFrYlpKYWDW8tLmZofjbB7tClXUN8hCz+3nbCqcCUXs
	 I5DFupsBW7rgUfdGqIUkbttyq9+D8fe+HHvIH1mm8Ks1eONYzL5sudoky+/9B4D4M7
	 8Qcc1F+UO4WdQ==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/4] dm-verity: remove log message with shash driver name
Date: Tue, 14 Oct 2025 14:16:54 -0700
Message-ID: <20251014211657.113603-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251014211657.113603-1-ebiggers@kernel.org>
References: <20251014211657.113603-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I added this log message in commit bbf6a566920e ("dm verity: log the
hash algorithm implementation"), to help people debug issues where they
forgot to enable the architecture-optimized SHA-256 code in their
kconfig or accidentally enabled a slow hardware offload driver (such as
QCE) that overrode the faster CPU-accelerated code.  However:

- The crypto layer now always enables the architecture-optimized SHA-1,
  SHA-256, and SHA-512 code.  Moreover, for simplicity the driver name
  is now fixed at "sha1-lib", "sha256-lib", etc.

- dm-verity now uses crypto_shash instead of crypto_ahash, preventing
  the mistake of accidentally using a slow driver such as QCE.

Therefore, this log message generally no longer provides useful
information.  Remove it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-target.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 66a00a8ccb398..20ddf560d22e3 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1250,11 +1250,10 @@ static int verity_setup_hash_alg(struct dm_verity *v, const char *alg_name)
 		ti->error = "Cannot initialize hash function";
 		return PTR_ERR(shash);
 	}
 	v->shash_tfm = shash;
 	v->digest_size = crypto_shash_digestsize(shash);
-	DMINFO("%s using \"%s\"", alg_name, crypto_shash_driver_name(shash));
 	if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
 		ti->error = "Digest size too big";
 		return -EINVAL;
 	}
 	return 0;
-- 
2.51.0

