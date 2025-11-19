Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5065335577;
	Wed, 19 Nov 2025 22:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763592176; cv=none; b=VgEj+fO5FL4MQeL1yZPQuPa9peLDg9T6xD/LoVOxWJFlj0vesYJeCzj+2lqBnXs6E7aDUn5S8YX7aUfhokqdcKLka7kycjJYzjo9kTmH0Wh7PxBLrkOO1wQxgKEIjaNSbAWkoT/3J6x9MNKwVuBs3PL9uG2ysqAM8QCBJvxGvN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763592176; c=relaxed/simple;
	bh=qdE4Kv1xsIq6Zkr4stkOXuGHAdW3NyrDUH5efjxvnWY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ns+SkTW/oYyPHyZFmwhhK4AjzAuAzxJsjSNcZt2pwBHuM/XhaivqyaIpfmdplSD+51Xa5Gy96hN1mXgDgJPXSRRR+ryS8usseQbefwgZhQ0FpKzQIaANmoIkpQBgcGwgCWYAZJuxSycNfiNTt8yUgmXCzx5Do1T/hZX3Y3Py1SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=pSqPraMe; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="pSqPraMe"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqt1-006ywW-C7; Wed, 19 Nov 2025 23:42:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
	:Message-Id:Date:Subject:Cc:To:From;
	bh=pvh9Gkxe+eLMwgU/T06ROMFGxeBFanNKRkJDglfuPVs=; b=pSqPraMesu4cfWonbmnqMRYu1M
	BnbK3PvYVPh1Lyx3evnv4JpQSpgbZmorMtsOZjnYlr6AZ+kVBnZWubmL2XjnCSARwC1Aqr3E+skLH
	FF270+cNxDonTy4ECoWrJBXY2s+jV33XhDWB6xVPrNLzphpiEQYxHA7SlC3s839UbFJE/jIT8xQiB
	CdxKSjgsKEI9eFCIsKjqcOvD8/jO/QNjuGT8I3bs+O8wmT+e00d35RD2tsVbbF91IdtjSwFgZsxuO
	5jZuE7X2QCY5W0le2kZ6V/kI15wd5R6aFxTSBABMOX3xCS+LvHeNjkluPoH6lFYnHswSqyN2/kqO5
	XHHYKqXA==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqt1-00086S-1i; Wed, 19 Nov 2025 23:42:51 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vLqsm-00Fos6-3u; Wed, 19 Nov 2025 23:42:36 +0100
From: david.laight.linux@gmail.com
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH 37/44] lib/crypto/mpi: use min() instead of min_t()
Date: Wed, 19 Nov 2025 22:41:33 +0000
Message-Id: <20251119224140.8616-38-david.laight.linux@gmail.com>
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
 lib/crypto/mpi/mpicoder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/mpi/mpicoder.c b/lib/crypto/mpi/mpicoder.c
index 47f6939599b3..bf716a03c704 100644
--- a/lib/crypto/mpi/mpicoder.c
+++ b/lib/crypto/mpi/mpicoder.c
@@ -398,7 +398,7 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 
 	while (sg_miter_next(&miter)) {
 		buff = miter.addr;
-		len = min_t(unsigned, miter.length, nbytes);
+		len = min(miter.length, nbytes);
 		nbytes -= len;
 
 		for (x = 0; x < len; x++) {
-- 
2.39.5

