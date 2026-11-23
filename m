Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446672;
	b=lPHrunzUYbDRtN5Hizxg0HvmOuD3ixAza8txpd0axhxuY/bKhouzv6QT7lbCbNFmAwPo
	 DkK13gndShlC2iL6D2ujDisXtmXrZUmSrDXoDK8RKI519fW4lWbCzy8ztpZ+X2mx3jo3X
	 SCT3LNxjJ1u3HJqfkahfRPL+BXOpoFoMhAGpT1AvfWbwavoO7gMOj5XHAoUZRIbGMN9L6
	 R0VT2CNTgQFlEBKJFraVocmRWsNPD9373bWpa8VL9e8P58phLB/NHgd/MGJPZ2F92k4vQ
	 hdcNwQ8qezYA0Ya8SFSu3RCYJ1+8Jc77+T6Q/wXiMVQJY+SLC8IaWlV7fHtbkptYuMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=kfgJmV+pVAEQVJp9ltaL3JbqH5exKDQIhWk/uwdJAnI=;
	b=UtxxeP5Po85fKGQwuaEjXppUSCnXTmeUdyLb8npK7RfPAPZ/hhMQV1g0GWtXI7euAx49
	 VIYTmy06xC4MHZd5mypW4zfWyth21HpW+KL7UiljVxJs4oAh/YrbNGs/go1vFwFn9a+Kg
	 r6iYxcTILeTgIeKEBGKXDa74lxiLXS1SC87zKfOjt3EtGuN2u4l9/v5RZPOS8D6bvL7xE
	 9ZCEX3lRhx4ngIo6Zf0IG/4/j6pQFjGHkXVsylpNY9zN/Onix8XPpqPCEBkfTl+vuVqdJ
	 VH3P1i0W6gosZ8SvcfqD93lIErG4I/vxfzWVjGYdeKUqQxH+pA33EX14an3az5ss+2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jip5JmIL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120D0606A31F;
	Mon, 23 Nov 2026 15:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jip5JmIL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8731F000EB;
	Mon, 23 Nov 2026 15:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446671;
	bh=kfgJmV+pVAEQVJp9ltaL3JbqH5exKDQIhWk/uwdJAnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jip5JmILioBfr5ZBHB9KzDeKzA4lb6jFEFkVlSulY9ZNNME113rOecjtLmI684k4q
	 fyzqCYsYE/MXPCwIdXGyoeJ5t1HmzAB0I6GrA7DvlhJ2jvxX8cs/MdYOzO/LwcpRDm
	 kOQyd+P/1WyjovTtUtiv9+YdQajCEpc5K7UaCljeITmwdRd941kMzi/sDjewfkBIdy
	 YK5Z0DQBRXBq+UenMEn8fX1ysw1m4yuuziYjhU2urb/mtBClqX8+JDz1eggngwR63s
	 LIcKVzyUhgg9QjioBERF9gQZ1CL5jQEyFkoJV9pvwzBnEEBY+Y/iRkw31ydWFcas0Q
	 uys/Wmi1pEkWg==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Steffen Trumtrar <kernel@pengutronix.de>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 01/10] crypto: caam - Fix descriptor buffer overflow in caam_process_blob()
Date: Mon, 23 Nov 2026 15:09:52 +0000
Message-ID: <20261123151055.2533735-2-lee@kernel.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <20261123151055.2533735-1-lee@kernel.org>
References: <20261123151055.2533735-1-lee@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit a703a4c2a328 ("KEYS: trusted: caam based protected key") switched
caam_process_blob() from append_seq_in_ptr_intlen() and
append_seq_out_ptr_intlen() to append_seq_in_ptr() and
append_seq_out_ptr(), each of which emits an extra 32-bit extended
length word, and added append_key(), append_fifo_store(), and
append_jump() when encapsulating a protected key.

However, CAAM_BLOB_DESC_BYTES_MAX was not updated and still reserves
only 44 or 52 bytes (for 32-bit or 64-bit DMA addresses), whereas
caam_process_blob() now writes up to 60 bytes for standard blobs on
64-bit DMA platforms and up to 72 or 88 bytes when encapsulating a
protected key, overflowing the kzalloc()-allocated job descriptor
buffer into adjacent slab memory.

Update CAAM_BLOB_DESC_BYTES_MAX to account for the protected-key
commands and the extended sequence pointer length words.

Fixes: a703a4c2a328 ("KEYS: trusted: caam based protected key")
Closes: https://sashiko.dev/#/bug/linux-fd968875-61a8-4100-ba0c-b9cd164d86e8
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/crypto/caam/blob_gen.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/blob_gen.c b/drivers/crypto/caam/blob_gen.c
index c18dbac56493..b4fdc15dd0b6 100644
--- a/drivers/crypto/caam/blob_gen.c
+++ b/drivers/crypto/caam/blob_gen.c
@@ -23,12 +23,16 @@
 #define CAAM_BLOB_DESC_BYTES_MAX					\
 	/* Command to initialize & stating length of descriptor */	\
 	(CAAM_CMD_SZ +							\
+	/* Commands to load plain key, store protected key and jump */	\
+	 CAAM_CMD_SZ + CAAM_PTR_SZ_MAX +				\
+	 CAAM_CMD_SZ + CAAM_PTR_SZ_MAX +				\
+	 CAAM_CMD_SZ +							\
 	/* Command to append the key-modifier + key-modifier data */	\
 	 CAAM_CMD_SZ + CAAM_BLOB_KEYMOD_LENGTH +			\
-	/* Command to include input key + pointer to the input key */	\
-	 CAAM_CMD_SZ + CAAM_PTR_SZ_MAX +				\
-	/* Command to include output key + pointer to the output key */	\
-	 CAAM_CMD_SZ + CAAM_PTR_SZ_MAX +				\
+	/* Command to include input key + pointer and length */		\
+	 2 * CAAM_CMD_SZ + CAAM_PTR_SZ_MAX +				\
+	/* Command to include output key + pointer and length */	\
+	 2 * CAAM_CMD_SZ + CAAM_PTR_SZ_MAX +				\
 	/* Command describing the operation to perform */		\
 	 CAAM_CMD_SZ)
 
-- 
2.56.1.750.gf70dc682cf-goog

