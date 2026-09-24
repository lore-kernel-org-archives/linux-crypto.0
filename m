Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1878F414A15;
	Thu, 24 Sep 2026 21:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790284915; cv=none; b=LZU1Vq1SiPY3aHa3w7cLYdnwMuiTeDVJX0fV7Vd1qb8FUloOwVXQh4FBsy62X/4r6UdAhsvW8QzbHhDVx5uKTFajr8YJ04nE9gxoi2BTWiJ7qEpDadmYrJNm1TudTgoVfm5DFfiAIp16Ow2brwB7qR75ycQ9JmMiHHPvonyfEcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790284915; c=relaxed/simple;
	bh=istQY0e4FiBex8lI80G+ApBgOLojyZfR85ev73eCAlo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z103CD0+XcnGnGqYPdCFqJ4IVEJIHIJt8G/7jXGGA/OMM/WA7NZ63eIkEDhbSEiSWu3ZqmtUuicIzv6pNRToQ2ZNCMFAL1S3YGfWFw9W2yt50Synouj5leinDM7nc+EV3vzejYBvOlHh4NA2wowHjW428wQgZT265jUwDTjN4Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bk1vIny/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bk1vIny/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235F11F000FF;
	Thu, 24 Sep 2026 21:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790284913;
	bh=x/UWJcNfekDF+GWo/zE1uFjVcugYvK5muHDuidy/TbI=;
	h=From:To:Cc:Subject:Date;
	b=bk1vIny/CbAJNomB5LibjJbFym7OSzf/bE6YSA0Pv3+qbpOGt5fAQEF5XjyowNy5k
	 hnGixu+r84k8quz+LRw3s1gUcEdxiUKWQf/tmhFGP0tc2RvjBvYmt6on2GA1qv65CF
	 30gC3NR7Q8oeIeNnTsI0mpiMg9y6hwCD/VaHZkY/04UcFd18DBFyZ0I2Fvvca7DVvB
	 Em0VQTN57km8KKQQM03WG2jF9yD0gqFhx1bqv+1ATgyP0LRz8lbtctRsA1DskQL4Ot
	 32xgn54nzEXThFKwpSKYkiRDxxm3nBBTik+AVg0iY5GsMC4W/i6Mwhz/uhLW6fUzaW
	 CW/KmelZxmgxA==
From: Thorsten Blum <blum@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thorsten Blum <blum@kernel.org>,
	Manos Pitsidianakis <manos@pitsidianak.is>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	David Laight <david.laight.linux@gmail.com>,
	Jonathan McDowell <noodles@meta.com>,
	Lianjie Wang <karin0.zst@gmail.com>,
	"Thomas Richard (TI)" <thomas.richard@bootlin.com>,
	PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: core - reject unknown RNG names
Date: Thu, 24 Sep 2026 23:21:13 +0200
Message-ID: <20260924212114.120633-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=990; i=blum@kernel.org; h=from:subject; bh=istQY0e4FiBex8lI80G+ApBgOLojyZfR85ev73eCAlo=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlbp3hppW1o7D3128go7faLSw6KXxmEt4VeMnf7vvbv7 7mz25y+d5SyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEXgUxMpxb1DE7PmD9zoJL l6WPVx0z33okKPm2S+HsRbLtLxTrFGsYGY4757Qs/brxEP/WrjcCR16vsey8LDWxt/8ma5bnz8t R+1gA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

In rng_current_store(), err is 0 after successfully locking rng_mutex,
and if the requested RNG name cannot be found, the function reports
success even though the current RNG was not changed.

Set err = -ENODEV before searching the RNG list to reject unknown names.

Fixes: 142a27f0a731 ("hwrng: core - Reset user selected rng by writing "" to rng_current")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/char/hw_random/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 57eeefe90da9..1f9e31cdc7f0 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -376,6 +376,7 @@ static ssize_t rng_current_store(struct device *dev,
 		cur_rng_set_by_user = 1;
 		drop_current_rng();
 	} else {
+		err = -ENODEV;
 		list_for_each_entry(rng, &rng_list, list) {
 			if (sysfs_streq(rng->name, buf)) {
 				err = set_current_rng(rng);
