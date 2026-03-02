Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D56201004;
	Mon,  2 Mar 2026 08:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438482; cv=none; b=RbzQQUNxQjhjzopcjOqo0Jo45J/uS71kSHEBnqEZEq6E/ibvVxei3YTWhPkmMLr+DJkuLB7B41ZGQFhbiu2Rx+SYJoqR3JPZBgAnAa9jr/f51Boolbr81Ulpl0M2sfijZjBRY0tJeZodjyBsL/J6cp4abuRFGW3/qtMXQW4/TWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438482; c=relaxed/simple;
	bh=AGZvoiScBe2bk7FU/2hUSFngb0WCvg6z4AjAzwuuyiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahsneatumCXlcki7hBlDx//LrdydaxfxDL7aFXQH1CenTPCTfMGs9mYRObnff4GehTl0XYnwucX6OL+pygmAO0K/WENm3ILUESWXrWv6WgPXhPdnPzBB0DA7+QC7ZJC+NlEEVV+t2GF5K6N9Cb1UpUcH5VUd7m8y6YB3djKI9As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1T+bIQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1T+bIQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED811C2BCB5;
	Mon,  2 Mar 2026 08:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438482;
	bh=AGZvoiScBe2bk7FU/2hUSFngb0WCvg6z4AjAzwuuyiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1T+bIQ1hGo3FHaOn2rrJphI8JkDXzpzDK/OpjXvBmDETTlD93XJ3fzET8yg98ayR
	 V6ABZs1+/+I+I++brACHJZw7bZdKEfAqkJJeNKis0n230egTymnMYagsjAGGAggNOj
	 8hMrNFOkx55X5FaMfsgTulGdz9A7kXC4sqMChkF0Q2dm5tMMo4jGtwmS64PRkaoNqx
	 u97o8gSYMdRbBI103Nc50XyLq0wg5JGiMQpnv1wE5GUCQRSh/ChjPc9ZbEzPV0/SA+
	 Z3wtBNNHjoaElNBy6/ewvzSnYw6fHUolnifswTtDEGF3OaL9O13xpYwjbq9Sv17frJ
	 mBmsXk3R9EymA==
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
Subject: [PATCH 06/21] nvme-auth: common: explicitly verify psk_len == hash_len
Date: Sun,  1 Mar 2026 23:59:44 -0800
Message-ID: <20260302075959.338638-7-ebiggers@kernel.org>
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

nvme_auth_derive_tls_psk() is always called with psk_len == hash_len.
And based on the comments above nvme_auth_generate_psk() and
nvme_auth_derive_tls_psk(), this isn't an implementation choice but
rather just the length the spec uses.  Add a check which makes this
explicit, so that when cleaning up nvme_auth_derive_tls_psk() we don't
have to retain support for arbitrary values of psk_len.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/nvme/common/auth.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 2f83c9ddea5ec..9e33fc02cf51a 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -786,10 +786,15 @@ int nvme_auth_derive_tls_psk(int hmac_id, const u8 *psk, size_t psk_len,
 		pr_warn("%s: unsupported hash algorithm %s\n",
 			__func__, hmac_name);
 		return -EINVAL;
 	}
 
+	if (psk_len != nvme_auth_hmac_hash_len(hmac_id)) {
+		pr_warn("%s: unexpected psk_len %zu\n", __func__, psk_len);
+		return -EINVAL;
+	}
+
 	hmac_tfm = crypto_alloc_shash(hmac_name, 0, 0);
 	if (IS_ERR(hmac_tfm))
 		return PTR_ERR(hmac_tfm);
 
 	prk_len = crypto_shash_digestsize(hmac_tfm);
-- 
2.53.0

