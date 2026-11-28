Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795840858;
	b=ACjAqh6tbjat5HzAkPGDebUDawmjykNhT22CiCovKews5GBtA7oJ2kKGQ+c6VekWuROX
	 lwzdx7Cb+ItHPRJuoRFmZN6CXBC5/HQC/7dmHO3qlgJ4Z6z1nN87RskUgv/wlCsDOzspR
	 7ToNerQLrEAjoq4ZS2XnZz6gYWJmmHOiFuJzGrNkbN0I461ZdKgxLJbtXGu6EimoPdwcS
	 T4p+VJi7pJqgXf7fc2roYY2vy4d8oxbSWeWQNucfrFkBDw2dXGsEjOxivjnYUe50jlR2f
	 p4uTzWmNgVi/V1xcppkYSD9BKf8Opdr9dznwda3sv0Tlxyo2AEvuPmTvr5/NEhl9nRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795840858;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0IEWdqpi7iJ/opemLt0tqH7v//3wrpWUTqWyICITBTI=;
	b=Mrb8j+kxyEO/ZOhtwuomvmoFp80mRqBFzDcNamyN/dMdwGYOO+dFMEBgLNB8aWc3WGxO
	 eyZy8K8xS7GOYgfwnLC8ZyOfnRCGyVAlg5Ihi2xqZStT3sWJf+JumwiWpednRo3QHCecp
	 Nx/tR4QMWaOOCfk8c8YoBwcmGACcoDBN6BMKx3G7E5PFB3npPMWJdEBl19uEdBjnm60r9
	 4KfEmE/zLsxVzN5BWPY0eVdQ3DFyJ0REZcwuGt30JWIHkPIlfn2CT7BHioweyHmYA1NJM
	 uXyUMRMILyr8y/iSAP4fDgysMxoe0xDYMK17xy08ckW5P8BQiMRh6xf6y7K63VJEYoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BurW4gAA;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BD7606A31C
	for <linux-crypto@vger.kernel.org>; Sat, 28 Nov 2026 04:40:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60BD7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BurW4gAA
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ae1da332bcso4368121a91.2
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 20:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795840858; x=1796445658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0IEWdqpi7iJ/opemLt0tqH7v//3wrpWUTqWyICITBTI=;
        b=BurW4gAAs5V0VVqQR0MBAYP0UcBDw/iLFm/nwWCVp3Es/jYaHFJgEIWo8FyKRvoXTU
         ipVcf2J1ToOVkb9hueYbMgnaFokZqOZYnhJKVYHC9MoAraVSYoV+pkURVxWyZJ5papb3
         l8gfWnfCva41N9Vg0fg+EUNKxv3bEbwwuAHVkO1M+1QMcdnDN7kDe/RdGZn1NmoL9iVV
         XkD/90jPg6Sz/5T/3l0RB/il5RHZuiz3oxtp6C/C2i4euPJQpivwCmy649bfk4srIaxv
         PR1G9pKcarPts8E4NO8xTgNyOHrW9Vu+GX7O1f+Iefma5MHQLk1r0pmF1EzHfY3j+sYc
         /Slg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795840858; x=1796445658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0IEWdqpi7iJ/opemLt0tqH7v//3wrpWUTqWyICITBTI=;
        b=qY2RPocWqAsL54qotaNwpS5jeXgKxa88DtDLdlR4Tp73L7ZC7AZwvz4wXxV4t0/jfy
         8jCqbKZrhaazlhIWFEgP2s960OiTwrMMMNinWmSSop6D/w1KU+priGgP8t4E9QqqSx4S
         vkiHZhROC9Ij8wBNt2ZnfGj43QnnXqhdFYpVwCh6xVe+qmyA3oU+vIKouoQgirA5JARA
         nB9ioWJSnQwXFwuT8SWm9YjSzQ5QXi4tDTjyeN/M4KpCjmsdMBhzXRR3mP463FdKwZxT
         kh+NOBjB9sEyip2ZPTXJCpLlrN+n6tWbgpVbqQt5BCzC1SC/kDEc0zzwOlb8HT4u9wUc
         252w==
X-Gm-Message-State: APuU4Z+Xxb74oQ4It9FKIpyeHxFLN/7+p5Su+680W+5vgAD0AeiO9a50
	3afZx2lThBtP49P0pLFLK30fOHT/4tXk/b/oRgoSNeYOHgTZ4XeL7JPzQnPhbA==
X-Gm-Gg: AZFdTZcU+xkw6GQ706NRWJ8wkK2lPOl/Rh4+x1/CjLhTmuIVdZ9KlUcXDgUAHPtH03+
	gt70xDZVoKTglSpHfrI56uijH8Css+JBzkIV3atnAmdssAP1VjNA+ie4Fh7s4FUANlW/y4DZrSx
	HZ1ZAru762yLXOci5pe4BH+45XQQT+F6fkoEKsHpul9sLtYi2TwklOE6ZhXlSJdxpQffC5VfAWX
	KrrZYey0rGJ9IOFHjrNY1ZlctqXTD1B/EOVxQKvNz2YigSMSTS+Tus9/yFO9vJNYmPF2wpyyc0P
	R/e/28P0j3mUK2QV2YaDQ5duRMhMFuVkiOFAey/n7r7QFrMsm9IalpCpA0xp1G/Bnc63VsxVxzg
	vF3KOMNuGUBRH3WUccCCABAOQaz8aVd8YIqNuKjnnEkBSuFZ6GMPA94ct5+tl8kJMjPy6Z1DnsV
	sOCkvb6pvmgELsKL/ounyYFJ/Xs4CkSeLcqFukXBl5n15tO2BcWxeizsL9EErUXudS/QufhJAu/
	/5rjESGNhyiAKdMUS+7MiyTuTiVWwEgYxT7qESKuMwlEBwnAgb0JSvLPeULwMxEEjdL0lwIgGP2
	P1WeGa5FvKNba3dxhJxqYdEii9h/r/lv89i1w6cFIhzNoMUrP98H1w24Z+gMgNvvyBUfCGsFmwa
	+pe3Jgtt8C32ULQw5snVetqt/sUaLreSKF1cqadV3DxAdoGsaTRenAH8UGuiPumcL5fe7S7Y7CY
	gUQQ==
X-Received: by 2002:a17:90b:2f8c:b0:39e:4c81:6c5f with SMTP id 98e67ed59e1d1-3b41c92c175mr24780300a91.26.1795840857655;
        Fri, 27 Nov 2026 20:40:57 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41abb1b66sm42716729a91.1.2026.11.27.20.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 20:40:56 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Romain Perier <romain.perier@free-electrons.com>,
	stable@vger.kernel.org
Subject: [PATCH 3/8] crypto: cesa - hash the last full SRAM chunk before the padding
Date: Fri, 27 Nov 2026 20:40:45 -0800
Message-ID: <20261128044050.722617-4-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261128044050.722617-1-rosenp@gmail.com>
References: <20261128044050.722617-1-rosenp@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a hash is longer than the engine's total length field (0xffff),
mv_cesa_ahash_dma_last_req() pads it by hand. The padding is placed in
SRAM right behind the outstanding data and the two are hashed by one
operation, or, if only part of the padding fits, in two.

If the outstanding data fills the SRAM payload exactly, none of the
padding fits behind it. That case adds no operation for the outstanding
data at all and transfers the padding to the start of the SRAM data
area, overwriting the last payload-sized chunk of the message before it
was hashed. Every message longer than 0xffff bytes whose last chunk ends
exactly at the payload size (1920 bytes with the default 2 KiB SRAM),
for example any one-shot digest of a multiple of 1920 bytes, gets a
wrong digest.

Hash the outstanding data with its own operation first, as was done
before the padding handling was rearranged.

Verified on an Armada 385 (WRT3200ACM) against the software hashes,
with random lengths up to 140000 bytes: about 10 of 40000 SHA1,
SHA256, HMAC-SHA1 and HMAC-SHA256 digests were wrong before, all of
them of that shape, and none of 60000 after.

Fixes: ab270e7055e0 ("crypto: marvell/cesa - rearrange handling for sw padded hashes")
Cc: stable@vger.kernel.org
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/hash.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index d2fe96d865bd..9fd3d5c32312 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -607,6 +607,16 @@ mv_cesa_ahash_dma_last_req(struct mv_cesa_tdma_chain *chain,
 			return op;
 
 		padoff += len;
+	} else if (frag_len) {
+		/*
+		 * The outstanding data fills the SRAM payload, so none of the
+		 * padding fits behind it. Hash that data on its own before the
+		 * padding transfer below overwrites it.
+		 */
+		op = mv_cesa_dma_add_frag(chain, &creq->op_tmpl, frag_len,
+					  flags);
+		if (IS_ERR(op))
+			return op;
 	}
 
 	ret = mv_cesa_dma_add_data_transfer(chain,
-- 
2.56.1

