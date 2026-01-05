Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5288F32695B;
	Mon,  5 Jan 2026 05:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767590093; cv=none; b=cRFUe79fF+kc2LP8Hw4wYmeMVWgpQZvy+d112yszRZFbF1FHGbZvgbmRbbCmLhXf+cLhLba7/cu16wEQJlHu27gdkSuQxsPoDas6TbmKKICIIJptK6bkGRjbr6pqkCYWGg1V/HsxXNhbIVJyzIEDnXRklakokY0QNcgTfzBmM+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767590093; c=relaxed/simple;
	bh=geRxBzAl7TSK/fpIj/XhC82GQN0xlq7+PsYx1FYDX+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAqCjmFJBfth6Krm+qWa97j8A2aLLMVymP303IbTkfQqXcPP3vQ3VCF1E7g0ay4TaYex9tSvuofUskW3jh7JJmzr4YrkeOQ9YWZTBFhNWylEdbjZm5xzEjfjBarvM8VxACl5Dg3iZs1nN3sYf9X1DANaZ85J3P5VRZiLNATBaP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bPdsZ+s0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bPdsZ+s0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70058C19424;
	Mon,  5 Jan 2026 05:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767590092;
	bh=geRxBzAl7TSK/fpIj/XhC82GQN0xlq7+PsYx1FYDX+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPdsZ+s0sKbOH+q/HMC9eucNVcRcMkg4SpEX+JFQUtRNw0vpcM4NbiZQo7VwMIFYb
	 QoFHYPT3uO4dy4nwQokeG2xosTkHn3S6Pk9QENxE2PaAMH5xMsXBFTn6j8vvgHcksb
	 cq4JxtSumUfF6KDVcwFwPr1fOnVTEEmgCBvBW5VXMMbJNZNIEFjt/DXqYWSIaLJDVe
	 2gdc64O4GtBdDXQev62Mr/HheY8hU1HTC0C0Tzf+PLGhwqJ56g9vqz32+xMdDug2YU
	 eWB7MzcFhYsp38MUZUwGbZU9rTkXEMwVGICNdAQC4K9MoI3joH7JpXGAfAaCr65aiY
	 wVCoGj70WNX1Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 04/36] crypto: arm/aes - Switch to aes_enc_tab[] and aes_dec_tab[]
Date: Sun,  4 Jan 2026 21:12:37 -0800
Message-ID: <20260105051311.1607207-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260105051311.1607207-1-ebiggers@kernel.org>
References: <20260105051311.1607207-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of crypto_ft_tab and crypto_it_tab from aes_generic.c, use
aes_enc_tab and aes_dec_tab from lib/crypto/aes.c.  These contain the
same data in the first 1024 bytes (which is the part that this code
uses), so the result is the same.  This will allow aes_generic.c to
eventually be removed.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm/crypto/aes-cipher-core.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/crypto/aes-cipher-core.S b/arch/arm/crypto/aes-cipher-core.S
index 1da3f41359aa..87567d6822ba 100644
--- a/arch/arm/crypto/aes-cipher-core.S
+++ b/arch/arm/crypto/aes-cipher-core.S
@@ -190,12 +190,12 @@
 	.align		3
 	.ltorg
 	.endm
 
 ENTRY(__aes_arm_encrypt)
-	do_crypt	fround, crypto_ft_tab,, 2
+	do_crypt	fround, aes_enc_tab,, 2
 ENDPROC(__aes_arm_encrypt)
 
 	.align		5
 ENTRY(__aes_arm_decrypt)
-	do_crypt	iround, crypto_it_tab, crypto_aes_inv_sbox, 0
+	do_crypt	iround, aes_dec_tab, crypto_aes_inv_sbox, 0
 ENDPROC(__aes_arm_decrypt)
-- 
2.52.0

