Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9098F16A396;
	Fri, 21 Jun 2024 17:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718989219; cv=none; b=b/9jqbmcCPqwL2PZ/Hnezu0weP59W7QNnX9psim8r+L95ggnFxyVMVjVjCC9h9U5fmpIBFCU2rjgNjYak48msn1jC481apFZJMn0K21jxXYOkMDAQHF0d+chD8omqHAP0VKk8J+2Hlrnc76xBuTBAHo+VVY1ZpQlCsObrAAG8QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718989219; c=relaxed/simple;
	bh=ypS3wDjrki602PRpZAix8qK+2Aw3HThVdjAOH9xqvE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U40rAnv+SilyYob/dNk8OUbPkc+uPQ2zYHcj89xNVkNmXRqKb7DNQDxpE4JrEPtuzVlSS+i0VmMkJYV8wJKMA8ETpkHttmZYhBit+noVASBlYLW1x/y4zkZJy3IlZy1ljJNuuMAiD9151ty2fCTIp50xpaLghmyZJab+VBbIp9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s0qyhFij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s0qyhFij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174F4C3277B;
	Fri, 21 Jun 2024 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718989219;
	bh=ypS3wDjrki602PRpZAix8qK+2Aw3HThVdjAOH9xqvE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0qyhFijQyiGvRe1i3Husc3d43tP6AUy3GN22wuCtRmhMwDbr7uCpjEqBcvJJAzyv
	 icqD39KaL9IYIj2jozTEbbeya9NZO5os4ONh4R1WuwIZngQ+5JDNGdjJwRLl/mhvhp
	 pekZInU35oP3gTqX4KnPe1RgKa1SF9pVR3vehFY89WHzHsex0Cw/Re+Gli99HFMWoE
	 Y7OOu8fWgtd1PpG/3AXiftn5jXgAHlOc5RJ2AM5nwQbN3KUq8WMXcGRzoKFk3Bef1P
	 gS6XpDu4A69+vLNCmC1gTue8+Sx1bIJr3lD+u/a4vJXz6b2ZnqWlEjbLBB8gMQwoYO
	 SfHtzxP9W8ThQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v6 07/15] dm-verity: move hash algorithm setup into its own function
Date: Fri, 21 Jun 2024 09:59:14 -0700
Message-ID: <20240621165922.77672-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240621165922.77672-1-ebiggers@kernel.org>
References: <20240621165922.77672-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Move the code that sets up the hash transformation into its own
function.  No change in behavior.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-target.c | 70 +++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 31 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index bb5da66da4c1..88d2a49dca43 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1224,10 +1224,47 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 	} while (argc && !r);
 
 	return r;
 }
 
+static int verity_setup_hash_alg(struct dm_verity *v, const char *alg_name)
+{
+	struct dm_target *ti = v->ti;
+	struct crypto_ahash *ahash;
+
+	v->alg_name = kstrdup(alg_name, GFP_KERNEL);
+	if (!v->alg_name) {
+		ti->error = "Cannot allocate algorithm name";
+		return -ENOMEM;
+	}
+
+	ahash = crypto_alloc_ahash(alg_name, 0,
+				   v->use_bh_wq ? CRYPTO_ALG_ASYNC : 0);
+	if (IS_ERR(ahash)) {
+		ti->error = "Cannot initialize hash function";
+		return PTR_ERR(ahash);
+	}
+	v->tfm = ahash;
+
+	/*
+	 * dm-verity performance can vary greatly depending on which hash
+	 * algorithm implementation is used.  Help people debug performance
+	 * problems by logging the ->cra_driver_name.
+	 */
+	DMINFO("%s using implementation \"%s\"", alg_name,
+	       crypto_hash_alg_common(ahash)->base.cra_driver_name);
+
+	v->digest_size = crypto_ahash_digestsize(ahash);
+	if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
+		ti->error = "Digest size too big";
+		return -EINVAL;
+	}
+	v->ahash_reqsize = sizeof(struct ahash_request) +
+			   crypto_ahash_reqsize(ahash);
+	return 0;
+}
+
 /*
  * Target parameters:
  *	<version>	The current format is version 1.
  *			Vsn 0 is compatible with original Chromium OS releases.
  *	<data device>
@@ -1348,42 +1385,13 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		r = -EINVAL;
 		goto bad;
 	}
 	v->hash_start = num_ll;
 
-	v->alg_name = kstrdup(argv[7], GFP_KERNEL);
-	if (!v->alg_name) {
-		ti->error = "Cannot allocate algorithm name";
-		r = -ENOMEM;
-		goto bad;
-	}
-
-	v->tfm = crypto_alloc_ahash(v->alg_name, 0,
-				    v->use_bh_wq ? CRYPTO_ALG_ASYNC : 0);
-	if (IS_ERR(v->tfm)) {
-		ti->error = "Cannot initialize hash function";
-		r = PTR_ERR(v->tfm);
-		v->tfm = NULL;
-		goto bad;
-	}
-
-	/*
-	 * dm-verity performance can vary greatly depending on which hash
-	 * algorithm implementation is used.  Help people debug performance
-	 * problems by logging the ->cra_driver_name.
-	 */
-	DMINFO("%s using implementation \"%s\"", v->alg_name,
-	       crypto_hash_alg_common(v->tfm)->base.cra_driver_name);
-
-	v->digest_size = crypto_ahash_digestsize(v->tfm);
-	if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
-		ti->error = "Digest size too big";
-		r = -EINVAL;
+	r = verity_setup_hash_alg(v, argv[7]);
+	if (r)
 		goto bad;
-	}
-	v->ahash_reqsize = sizeof(struct ahash_request) +
-		crypto_ahash_reqsize(v->tfm);
 
 	v->root_digest = kmalloc(v->digest_size, GFP_KERNEL);
 	if (!v->root_digest) {
 		ti->error = "Cannot allocate root digest";
 		r = -ENOMEM;
-- 
2.45.2

