Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7711DB924;
	Thu, 29 May 2025 19:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748545200; cv=none; b=Dlm0M4OEQDykOTCjI175vpzjfEm9L66bGBsXbfwVw95zRAfRTIbtRMfFyu7KJ+y2ZvFea9oB/L5ptBU1tfgbWep8tbvGq9XOyeNZm3up7x6V18UDye1zn9d0EwULb7pqmIlfvbTIY+nqjxHj+XKd3QoyNT47F7A/5h3UYt8Da4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748545200; c=relaxed/simple;
	bh=kzoOHmSCbetRjqTbWYEjpkgxTuPu5WCFrz5b4OpnueA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lgDBJJvpAtOs9ZpVwmwypEWntYYq+peeJXCjCjUEr8LlpfFbXfuI0cWbQb1wWxQKP+kMRgGG7oNwprNwF/5BMwZwuUFoX4xMjn3xpqiBe/QeQZIyaJ5P8mavUwygz5wkFkOOG+9bs6qu4Q55OwH8pNKbUT77YPL8kGtgVj5KL30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CWV5ngDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CWV5ngDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76EBC4CEE7;
	Thu, 29 May 2025 18:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748545199;
	bh=kzoOHmSCbetRjqTbWYEjpkgxTuPu5WCFrz5b4OpnueA=;
	h=From:To:Cc:Subject:Date:From;
	b=CWV5ngDwlNoxmhVN1kYC4/uGDN7WFMxOS/T/LTF7e3If8YDHgJ6oaCvyT6H1j2oW0
	 iAlOxObtQldtG4YcnZQ+cx/LMNtWde0LsghDWG1FMS3hW+g7WrRrZs1MDgDc4+P4Dc
	 GoDK94T5i7+28EO1lfvM5LRUyB46Q+phJrICSaqnX1b33EEY0v+wnGD8/SH2BjC4mQ
	 4Gt1+AE37dQws11uIlfZFYIpBbSmTyDuPYMBqMeIJZFYenuza5/O6N7v+trRnRbxa5
	 uRqjMmZuXYv14n4u9JOrSPfKEMRtEOcr1ci9jSrjhL3cMlJXFX0a+c6qU1wsM/HOSd
	 PsHUfbKjIq/OQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] crypto: s390/sha256 - rename module to sha256-s390
Date: Thu, 29 May 2025 11:59:13 -0700
Message-ID: <20250529185913.25091-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

When the s390 SHA-256 code is built as a loadable module, name it
sha256-s390.ko instead of sha256.ko.  This avoids a module name
collision with crypto/sha256.ko and makes it consistent with the other
architectures.

We should consider making a single module provide all the SHA-256
library code, which would prevent issues like this.  But for now this is
the fix that's needed.

Fixes: b9eac03edcf8 ("crypto: s390/sha256 - implement library instead of shash")
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Closes: https://lore.kernel.org/r/20250529110526.6d2959a9.alex.williamson@redhat.com/
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/s390/lib/crypto/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/s390/lib/crypto/Makefile b/arch/s390/lib/crypto/Makefile
index 920197967f463..5df30f1e79307 100644
--- a/arch/s390/lib/crypto/Makefile
+++ b/arch/s390/lib/crypto/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 obj-$(CONFIG_CRYPTO_CHACHA_S390) += chacha_s390.o
 chacha_s390-y := chacha-glue.o chacha-s390.o
 
-obj-$(CONFIG_CRYPTO_SHA256_S390) += sha256.o
+obj-$(CONFIG_CRYPTO_SHA256_S390) += sha256-s390.o
+sha256-s390-y := sha256.o

base-commit: e0797d3b91de75b6c95b4a0e0649ebd4aac1d9d1
-- 
2.49.0

