Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287E71ABEC2;
	Mon, 14 Oct 2024 11:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728903630; cv=none; b=j3FKzySwP5OqhrBzYg88erNZyfyDkrRAubHBgI0FwOCvC1ErYOU9jAzltDlfljc4iwOS6kIsyvKaiwSSkHtRLzFJUYLC7qXZwake0H96C0O0DA+jxik+BrfPX8VGh3xCxpmjPHsElV9APniINFKYMSbWdkyaExCu6O8fRutOq58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728903630; c=relaxed/simple;
	bh=okh2xOh5wgCtK9kRDqrLV21h53I8WCAc98ujORU0NRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UntcL54c4UNhHx+Nibc5dOHGPpczYPsTVe7MV87PH4ZADklAe3BUteHBijenE2xqS3XbPOw0jpkVM8+xKGlTj68lHD2j6HQWgi+VqFasvxCgUDvy4duffmwmbvY/mGG6rvjYBs5mgDKMj9uThUAbLUR/AyvTBpnBnvfzwgCpiGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61C921688;
	Mon, 14 Oct 2024 04:00:58 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0597C3F51B;
	Mon, 14 Oct 2024 04:00:25 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: "David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Greg Marsden <greg.marsden@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ivan Ivanov <ivan.ivanov@suse.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Matthias Brugger <mbrugger@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1 20/57] crypto: Remove PAGE_SIZE compile-time constant assumption
Date: Mon, 14 Oct 2024 11:58:27 +0100
Message-ID: <20241014105912.3207374-20-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241014105912.3207374-1-ryan.roberts@arm.com>
References: <20241014105514.3206191-1-ryan.roberts@arm.com>
 <20241014105912.3207374-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prepare for supporting boot-time page size selection, refactor code
to remove assumptions about PAGE_SIZE being compile-time constant. Code
intended to be equivalent when compile-time page size is active.

Updated BUILD_BUG_ON() to test against limit.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---

***NOTE***
Any confused maintainers may want to read the cover note here for context:
https://lore.kernel.org/all/20241014105514.3206191-1-ryan.roberts@arm.com/

 crypto/lskcipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index cdb4897c63e6f..2b84cefba7cd1 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -79,8 +79,8 @@ static int crypto_lskcipher_crypt_unaligned(
 	u8 *tiv;
 	u8 *p;
 
-	BUILD_BUG_ON(MAX_CIPHER_BLOCKSIZE > PAGE_SIZE ||
-		     MAX_CIPHER_ALIGNMASK >= PAGE_SIZE);
+	BUILD_BUG_ON(MAX_CIPHER_BLOCKSIZE > PAGE_SIZE_MIN ||
+		     MAX_CIPHER_ALIGNMASK >= PAGE_SIZE_MIN);
 
 	tiv = kmalloc(PAGE_SIZE, GFP_ATOMIC);
 	if (!tiv)
-- 
2.43.0

