Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00776288537;
	Sun,  6 Jul 2025 23:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751843503; cv=none; b=jxoweCsD2r01uSQ0KfoD+AnjJqDv1ihT9RKAw6dNSRogmSNGsGsOouryGCouLUAw01QY/vX5xvvmcX0wIF+Duijlz4heKgEZtc2fN+LjET0V6WvnJuuls8dy7s4sY3Qg0rid/2bSpL9Zisq+Pu2SatZBsOsAq7gHW0fT0qse4NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751843503; c=relaxed/simple;
	bh=b9yTjrbNlpjbYFfN/2AHdX2leYa4WC4arSWKY1vadb0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vB/F6hILEDTzMSXqOoKf3ZoEa1IJpMlwebMjGjaLKbKXnCDQg/lyJT4Q1ym5omzQnRptFzDY6/VKDj0ExtZD5vy1p2UlgJd8KVk7DSC7YTjp/uwXV04Eto1STe2uRLeL1qdYYchAHZrSHyryoSo6WCD+zHHYfSgwnRtPvWYQHy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OcgXL7h3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OcgXL7h3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD73BC4CEED;
	Sun,  6 Jul 2025 23:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751843502;
	bh=b9yTjrbNlpjbYFfN/2AHdX2leYa4WC4arSWKY1vadb0=;
	h=From:To:Cc:Subject:Date:From;
	b=OcgXL7h3194Y0aIv2wQH6apRZAwSf0HabeYzKqhbhihK0xoL0941lDRb7Xe+jGttT
	 O/6lnzi8nfPVP2Loj7p7VmRPkips9NbcR0gZPfo0CA2BFqAVqr7TIc1oK8IXAIbsmQ
	 21VsPhleA6+028Qpb74BJUyUpWI872u39X5pOKYysujb7DRHhf0OML7q7e8j7JnMjE
	 rDqDs9hv1EybN+ia1p8fco/GX2BiC5VY8eej8Pj7fU3pEa0rwLIuBhdZ79aXwueVgn
	 EU2K2O7l1FgAvS4AufDsNoJY+wxXJRoleedNRRDlkXcE/3CzgZb9j3MfVaLHmLF5/+
	 dh5v2Zm3FhIHQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/5] lib/crypto: Poly1305 fixes
Date: Sun,  6 Jul 2025 16:10:55 -0700
Message-ID: <20250706231100.176113-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is also available at:                                                                        
                                                                        
    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git poly1305-fixes

This series fixes the arm, arm64, and x86 Poly1305 functions to not
corrupt random tasks' registers when called in the "wrong" context.  It
also fixes a performance regression on x86 with short messages.

This series is needed for my upcoming poly1305_kunit test to pass.

Eric Biggers (5):
  lib/crypto: arm/poly1305: Remove unneeded empty weak function
  lib/crypto: arm/poly1305: Fix register corruption in no-SIMD contexts
  lib/crypto: arm64/poly1305: Fix register corruption in no-SIMD
    contexts
  lib/crypto: x86/poly1305: Fix register corruption in no-SIMD contexts
  lib/crypto: x86/poly1305: Fix performance regression on short messages

 lib/crypto/arm/poly1305-glue.c   |  8 ++----
 lib/crypto/arm64/poly1305-glue.c |  3 +-
 lib/crypto/x86/poly1305_glue.c   | 48 +++++++++++++++++++++++++++++++-
 3 files changed, 51 insertions(+), 8 deletions(-)


base-commit: f1da28dfadd26ef95bbd0b1ddf066e7ffe1505ff
-- 
2.50.0

