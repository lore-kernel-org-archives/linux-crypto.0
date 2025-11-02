Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A7A60B8A;
	Sun,  2 Nov 2025 04:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762057221; cv=none; b=JmgdexFS3tznrWmkdw58JhE3jh5q6rgAl4z+mkc+OeSgguWoOL5pGFSgcOPElOnXM4zQs0ON0I355sM9c4KQcU+9FM3wYhR2LrwU0OhB/8afb1X0e7SBven+DN/oOImIMoSht5q657l8CoPJotxvOS01kmVmQ03ZF3GBnm15wYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762057221; c=relaxed/simple;
	bh=y5TVxKAyOCgMFvGo0rlHMg0W+6136/YlZOdBdVBVzes=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g+sLYMriXRVu7W4jYQlNeVlYKvBT77HieWBBXSQaSx5+QzgFii8eh1aUQyrFTRRe5HJwhaqpq6gtRk/lxqatT45AGAA7Fd/Cto/2ej4h5YOKOhIY5pez6hTMfgmHhfAi2+e12Gh1tmOrtg6ycNy9lC0r2D9AW6Bu5iWnu8sxKvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GnqVasat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnqVasat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669D9C4CEFB;
	Sun,  2 Nov 2025 04:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762057220;
	bh=y5TVxKAyOCgMFvGo0rlHMg0W+6136/YlZOdBdVBVzes=;
	h=From:To:Cc:Subject:Date:From;
	b=GnqVasatwpBHetXBEchw/OTJEe3fRKD7SUPVTBZFySb/AdIqUF90X7OXvSf0EZJ7k
	 203o6tq9E1btrtC/CkmxasNmEXPosY9TV0zvkH/J1U/EKlt5b+GKAZ1yBawhS034iK
	 Qyu4tBYWOModqcxt2H0On5tXwjIAaDhxtH7wzbQdTDRdQNByaLDqcu0P+dC+KMX4hB
	 k8V5GNG7SY407fi8+zpsl86p46ofPSgC3rGa/CQkudKNd6W8Gt/PDJQbs4MLTj2ejU
	 Y5uQX2aiVk5B8BsnPB+0meJKR0NW5IO5fXuON3yQacnpyL+bACB4KbIvGFpUtejOam
	 3kJ20Yijn8lzQ==
From: Eric Biggers <ebiggers@kernel.org>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Theodore Ts'o <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] random: remove unused get_random_var_wait functions
Date: Sat,  1 Nov 2025 21:19:41 -0700
Message-ID: <20251102041941.74095-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

None of these functions are used, so remove them.

This renders the two bugs moot:

- get_random_u64_wait() used the wrong pointer type, making it provide
  only 32 bits.

- The '#undef' directive used the wrong identifier, leaving the helper
  macro defined.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/linux/random.h | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/include/linux/random.h b/include/linux/random.h
index 333cecfca93f..8a8064dc3970 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -128,25 +128,10 @@ static inline int get_random_bytes_wait(void *buf, size_t nbytes)
 	int ret = wait_for_random_bytes();
 	get_random_bytes(buf, nbytes);
 	return ret;
 }
 
-#define declare_get_random_var_wait(name, ret_type) \
-	static inline int get_random_ ## name ## _wait(ret_type *out) { \
-		int ret = wait_for_random_bytes(); \
-		if (unlikely(ret)) \
-			return ret; \
-		*out = get_random_ ## name(); \
-		return 0; \
-	}
-declare_get_random_var_wait(u8, u8)
-declare_get_random_var_wait(u16, u16)
-declare_get_random_var_wait(u32, u32)
-declare_get_random_var_wait(u64, u32)
-declare_get_random_var_wait(long, unsigned long)
-#undef declare_get_random_var
-
 #ifdef CONFIG_SMP
 int random_prepare_cpu(unsigned int cpu);
 int random_online_cpu(unsigned int cpu);
 #endif
 

base-commit: 691d401c7e0e5ea34ac6f8151bc0696db1b2500a
-- 
2.51.2

