Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBF13A1D01;
	Mon,  2 Mar 2026 08:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438489; cv=none; b=mvj/rrFcMx4OJhwVUK8sDqmxNjaMHHb3jem5GNUzSDSzajj2HjH87b10TwuMN+AKQ1R9uR3u2F5TheME+Ttpq5vpp+GL3NyDBUXxSN1+ken6fXOweK2S3ODCPM2Z/s8QO1PKbLbpvC4nyDCzOt8FqhmQuq/Oj34lqfksJ+9Za9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438489; c=relaxed/simple;
	bh=Lp2OjfkVFaBG9FhdDQb2hnxI9JJpj41THxQ0Ey2WbFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4tEKijQWesGkd3xJJktHtSDtLjeMjxN9xjenEaFwDuKUQqLA86825wl6UiUfpi6ca+xWRIaJ6BA3sWfG0yEAC6ZmyxD4LIf+HDqCENZxrSUmtrwohndRgwiSfD2TNwvHzvvtrGM9Z6AxLskkApFovQphyUf0a/9xvWlccgwUh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pciav5Rm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pciav5Rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FA5C2BCC4;
	Mon,  2 Mar 2026 08:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438489;
	bh=Lp2OjfkVFaBG9FhdDQb2hnxI9JJpj41THxQ0Ey2WbFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pciav5Rmd8mXtmCpTVRHLS8dUSXgg85gvcGRF6qf+UWPuE5Xp+KtEkB8fnJhkC6lV
	 cdkUGFcIbB/drmszw4ZNefsIzfnkqTHbnlpz1xjQvnp5sGtUzqgP9qwIE/z12CfUZF
	 VlSmSlXY6FUshYqS9I4TA4x8sQUCCib4ep5DJCxg9gVPfbSSBi8t0qWd8Iyb7+3Tq6
	 eLbImORfeF37+S6mDTJZY8PKcmShD/JHGRbLo2hJqf7AkDz4PcR8Gx1ZFVRQVXcu3F
	 DHCj5JE38V3cSFQvxm1ZpVRGahJbvhV+Dn3f5bMVHtD3tDw2n7o1kUHfM24qH9aHqx
	 WCDt2pSfrHiMA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-nvme@lists.infradead.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 20/21] nvme-auth: common: remove selections of no-longer used crypto modules
Date: Sun,  1 Mar 2026 23:59:58 -0800
Message-ID: <20260302075959.338638-21-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302075959.338638-1-ebiggers@kernel.org>
References: <20260302075959.338638-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that nvme-auth uses the crypto library instead of crypto_shash,
remove obsolete selections from the NVME_AUTH kconfig option.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/nvme/common/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/nvme/common/Kconfig b/drivers/nvme/common/Kconfig
index 1ec507d1f9b5f..f1639db65fd38 100644
--- a/drivers/nvme/common/Kconfig
+++ b/drivers/nvme/common/Kconfig
@@ -5,16 +5,12 @@ config NVME_KEYRING
        select KEYS
 
 config NVME_AUTH
 	tristate
 	select CRYPTO
-	select CRYPTO_HMAC
-	select CRYPTO_SHA256
-	select CRYPTO_SHA512
 	select CRYPTO_DH
 	select CRYPTO_DH_RFC7919_GROUPS
-	select CRYPTO_HKDF
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
 
 config NVME_AUTH_KUNIT_TEST
 	tristate "KUnit tests for NVMe authentication" if !KUNIT_ALL_TESTS
-- 
2.53.0

