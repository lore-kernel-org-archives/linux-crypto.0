Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E063D47B1;
	Wed,  8 Apr 2026 14:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775658848; cv=none; b=nUKRMAF3O4cL9+aKHoLVx84uAxZCH4ZWpEj6dmoMKARFgB/UkfzBkieeYzmWHD8J47Kp2h0TgPZdcG5Q/Q2d+EkjQgxCWyDChWebFVQNWMuGdWIv/hfiWAd1qCUxsC3pRIkmyJJt5sb0lzO2xY4fnMywxevHErCJxv7EMZpQI30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775658848; c=relaxed/simple;
	bh=HlbJlPHaIqGCg+7KyVe8KtzjmCdZxRsgKdRGK1QZLxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E88aSGJDqUnD7la4lvfE/FpEyQO9liHNtajYFYq/8LwKVAHStp7JYV4uvRWYyGJKk35zl3PhtEmyrX/YoahlxD0SBXaRKodKhrf4jxBNrvLGDsGBf309pcqUFk54x/HCjmkYl+Zq5iosQgTjhk5aX1nhIkHHPpSlYRVAWcufiWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BSSZrGLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BSSZrGLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0204AC19424;
	Wed,  8 Apr 2026 14:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775658848;
	bh=HlbJlPHaIqGCg+7KyVe8KtzjmCdZxRsgKdRGK1QZLxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSSZrGLM352kFRI7kNegSvnCR+mKenmeoIKbP9CtVkz8xOMItrHmQn8az3eAu/FE7
	 2Wqf+J75X6VPwBNaCgidTzH4d7Cgnkk2iaISEQaUINVRdkDYfUcCKEC3MSuW4WkWof
	 lTj8s8yUwxM7lih5HAz9oY07VHpNBJ9p/7yUQ9IWx4S2YinkQ2pKcnoKGcEHMtBrF3
	 gXQuAijpGpg2yg7fyQspMd2J7t8gfX1CetT7xdONPaA6+k44TMm+kHu2MF87uC1yhC
	 kUQplrzYtM+Hhv73kdvEm7E7Ydj9qiog80Sm7eTN1BrrbOHdoQMQWCySG7Hc51skjg
	 nbKM4WIAz2yKg==
From: Tycho Andersen <tycho@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ashish Kalra <ashish.kalra@amd.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Brijesh Singh <brijesh.singh@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>
Subject: [PATCH v1 3/4] crypto/ccp: Check for page allocation failure correctly in TIO
Date: Wed,  8 Apr 2026 08:32:58 -0600
Message-ID: <20260408143259.602767-4-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408143259.602767-1-tycho@kernel.org>
References: <20260408143259.602767-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Sashiko notes:

> if __snp_alloc_firmware_pages() returns NULL under memory pressure, is it
> safe to pass it directly to page_address()?
>
> On architectures without HASHED_PAGE_VIRTUAL, page_address(NULL) might
> compute a deterministic but invalid, non-zero virtual address. The
> subsequent if (tio_status) check would then evaluate to true, and
> sev_tsm_init_locked() would dereference the invalid pointer.

Indeed, page_address(NULL) will return non-NULL garbage here. Fix this by
checking the page allocation itself for NULL, not the resulting virtual
address.

Fixes: 4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
Reported-by: Sashiko
Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e87efcff8df2..11e2c667c0ad 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1488,6 +1488,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 				       &snp_panic_notifier);
 
 	if (data.tio_en) {
+		struct page *page;
+
 		/*
 		 * This executes with the sev_cmd_mutex held so down the stack
 		 * snp_reclaim_pages(locked=false) might be needed (which is extremely
@@ -1495,12 +1497,14 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		 * Instead of exporting __snp_alloc_firmware_pages(), allocate a page
 		 * for this one call here.
 		 */
-		void *tio_status = page_address(__snp_alloc_firmware_pages(
-			GFP_KERNEL_ACCOUNT | __GFP_ZERO, 0, true));
+		page = __snp_alloc_firmware_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
+						  0, true);
+		if (page) {
+			void *tio_status = page_address(page);
 
-		if (tio_status) {
 			sev_tsm_init_locked(sev, tio_status);
-			__snp_free_firmware_pages(virt_to_page(tio_status), 0, true);
+
+			__snp_free_firmware_pages(page, 0, true);
 		}
 	}
 
-- 
2.53.0

