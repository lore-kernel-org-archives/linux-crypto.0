Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ECF32AADD
	for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 22:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763592164; cv=none; b=rLbbsxor60oRQHEOnGlHadJsVeoEXwQ20uqzEYlhMAcKKrpzjKnc7tmgj8J72PVjDym04n8CfYiHnsn9iWsTTMA4SyvkMSnOs4Yq3ggVbgC5P3gKsRZh/HWCR+/8ROTDQMUt9l1X4P1XN06cRgMqL+nTLISrIZAh3GWUxc63D8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763592164; c=relaxed/simple;
	bh=Iuwlqj+cR4EIiZpVo8JQkyFnSzUomIc1WiA0HfIaGD4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=puGwIoKtTeEj7OiCuiz0S9ll7QQvXYv2lalHZA8icM7hApLd8Q2dYpBNHHdLJziAhZRiGv0+/4Gb+PT+Au+q0eEvJNkmfgyv/MmRNdLHPXuYXQmAhJtCWo/kTH/ZjBPlqt2ll93wOo6+eOAH5SU8Ixb411tLoKOy86r0BctDA6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=z9ELswja; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="z9ELswja"
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqsp-006ypF-As; Wed, 19 Nov 2025 23:42:39 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
	:Message-Id:Date:Subject:Cc:To:From;
	bh=paduOCJQk+DPYxit3GhnkX6dVmwwtH01YWvMrtzPP34=; b=z9ELswjazmYV72gtqHnTnudeeT
	+DT5cJ60Jh+Wtja5PwgyL9jMdTNCCdA6ufR6KKDHQruKKCGbTNLKD45REENWw5mt2KzbOscMr2Ycj
	VTNagf4jJmWNpBc9eGHR4iG+CKmzPHT/DcHdZzC+i0yVrKOdfJFfQLcJ7IlEtDgAfk3QaagGuBUfq
	0mmE1Ag215XC41fuALDJJKmPfwp9x6Zd7ysYgUchEWXVh64y7f2hdG/WvU4EU3XsEV6qDBG4aVREN
	aBYjAhEFvDvrtrMYEGn5jDOjwO7fFs86Sxq1GzKlBDJdvLGQ+fZl2tzbbYiWqcbNAORi7A+jww9GG
	eUgRhLvQ==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqso-00008Q-Dm; Wed, 19 Nov 2025 23:42:39 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vLqsZ-00Fos6-28; Wed, 19 Nov 2025 23:42:23 +0100
From: david.laight.linux@gmail.com
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	x86@kernel.org,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH 10/44] x86/crypto: ctr_crypt() use min() instead of min_t()
Date: Wed, 19 Nov 2025 22:41:06 +0000
Message-Id: <20251119224140.8616-11-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251119224140.8616-1-david.laight.linux@gmail.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
and so cannot discard significant bits.

In this case the 'unsigned long' value is small enough that the result
is ok.

Detected by an extra check added to min_t().

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index d953ac470aae..f71db4f1c99c 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -693,8 +693,7 @@ ctr_crypt(struct skcipher_request *req,
 			 * operation into two at the point where the overflow
 			 * will occur.  After the first part, add the carry bit.
 			 */
-			p1_nbytes = min_t(unsigned int, nbytes,
-					  (nblocks - ctr64) * AES_BLOCK_SIZE);
+			p1_nbytes = min(nbytes, (nblocks - ctr64) * AES_BLOCK_SIZE);
 			(*ctr64_func)(key, walk.src.virt.addr,
 				      walk.dst.virt.addr, p1_nbytes, le_ctr);
 			le_ctr[0] = 0;
-- 
2.39.5

