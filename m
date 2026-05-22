Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C26379EC4
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 12:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779452444; cv=none; b=bvmzKzYJfk8R0BkESsvV05CwwmDJ0pdBF+vP3KXh/QyBTpHcUCPViyclLyUJh8vF0IDCScQo0gZScWcAB1fja4rOQW0EOFCryrbC1qQ5C6htSrBJNTYSd2i5D/fI5lbFYI3JpLrDu8sxGQcQMT1qRrFJJ22P2GLtxZq2eYxhRs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779452444; c=relaxed/simple;
	bh=bhfJYktqcLA186BQdpKCnz/FDnquz083vYJ7/H9ksvk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TUZdGHY4cq5tkt4KZfE4ZV2NDdxcsdFT3i/gczt/ileR+hlpQmmyk1LXHpLpFCuH2XY86mfaPdGxBpo+lYPHX9xxe7NtXoFUOYxCoVHuuuJUzTp4zmVaSOycSMObdu1BYNcIfvgIvGLlvYh+aqZbk+p7maFZT+yRL+H21EkF8kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nmY0gZbX; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nmY0gZbX"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8b7105dfb35so93631126d6.3
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 05:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779452442; x=1780057242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DMmEkAgbAbL0bknXE6VKXd/SNfsxV03AylxbVaw6hzs=;
        b=nmY0gZbXwgS54EoPEXgYVuBKpYHH6io3n5ehwg78xbZhHaK38dOB+Telxxx45Jp61X
         GGZcKzR414JW1sZAQg8+hXmbyeXSFSwHy4XMXwH/mgHvOYuNWc1enuyP/voeR4nRiLOu
         uGbNfZA7uLya1U3P55tAVoACav6qc9YSgtX655yA1BAx882fBQ7XSrvjveGChsPOIrO/
         d29pPkwrNOUhDdRp8iGHn7CXgRyZnNDi/Ob+K2YrMYjmIWL9+zhdQAUxmk5CJaU2G3DI
         FlValHSurbv0C71Z7jtpwRK+c1/3wlRfiBQ8JZULCT+nvX6OTidV6RzWtdNRI7mCRYzG
         +ZdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779452442; x=1780057242;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DMmEkAgbAbL0bknXE6VKXd/SNfsxV03AylxbVaw6hzs=;
        b=TlHjwOcJa/3paWUhSJr7eZ5xMXBq21H4f9u9eaRETKfeYumLThx/PejAh7ANdH92NP
         JHJrRBsdy8WJMbQOyul2q17d3FT0qoM+dLzqqXyhJhye4lJTVNrOlFNWPATMDbgbFm/7
         Of6Aug4XxsuJ6KVWr8UQ5wy4qw2OuBevGJI5sr0oRDJtjXOlyKoAKlpyDQ2BXN8vxN85
         dqcQZr1lNU8pCirsgqa+Y8su/1z5mQjLtxg4oBt0uHzKFTCr9PNZ0V210b3paOHBLZr9
         BDIjwWrIe+9lnkkDtlTH09JZb+h6AM9oEC3SF86Zv/LDUQA/LyL6iobe15NiyuubbLwu
         fVHQ==
X-Forwarded-Encrypted: i=1; AFNElJ9TpfHxTEFnvx0eKDMKrKxQ5N0eGPkqmx+Jhf6ZjPaSWsn64uvwVzVrldiw3EAfSVQPNDM3u9JOtPsZmis=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDO5zowHmKqQcau2DLp6takkpdH+FcNVzLCxo2Zg9zQM3vZbZX
	nf71rXrcbOStMWSBItvEl/1rhPdZXk2XovTHigeMDQ9kD8xWBpyCvF1b
X-Gm-Gg: Acq92OE82qgLoKLWZri1CLdtyO8YNuHjAneoicPZ4NXJP0N4VEcpVpSds29teMZcRZC
	Uv/ufNgtwh7gcHA/6ITgMG4H/Tj72n8i0TkKabfwBLQqPrbUGSyyatU6PVH7Hg6xX5TZtC7di71
	eSkgpP6o40fKqR9NRkQZG0jzlmGaPVoNRVmNoxqwljwrjq8+ozuhuv8eiuojUGVT2YS3SnOcyjw
	KSTuxnSCqSFWEDqUPAS0SFpHZPvNxCtVF/0t5MqMPCsJFyE7dmhT8iGHFB0cq+Js/73upGv8G0F
	axLbRnkzKZSptgNK+B11K5P74tgqvKPOAwtwj6bEOw/fQgm4AoLy5IIlxCJE89FAv1TD19ZiJXe
	LNdeEAz+Q2e2unHQeK15SFnlo7ljwX0N4Cys+gujLkwA2F7GnSqf4O/IU7OxYQc1PRFc1JlHd4D
	1RUJ7VukImBpY8XSYxsm7erhZhv7iSjdiow68L+gc18mkOtC04bMH41yUDc7tJT9AgVqAZngiUO
	4hoe+v1yv00V4mKwBlC
X-Received: by 2002:ad4:5d4c:0:b0:8a4:8b2c:428f with SMTP id 6a1803df08f44-8cc7b53d77amr58734616d6.2.1779452441618;
        Fri, 22 May 2026 05:20:41 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc80dcec8esm16656626d6.7.2026.05.22.05.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 05:20:41 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Kees Cook <kees@kernel.org>,
	Vivek Goyal <vgoyal@redhat.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: asymmetric_keys: validate PE section bounds before hashing
Date: Fri, 22 May 2026 08:20:25 -0400
Message-ID: <20260522122025.250646-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

pefile_digest_pe_contents() hashes each PE section using PointerToRawData
and SizeOfRawData from the section table. These fields are parsed from the
input image, but the per-section hashing path does not check that the
resulting range lies inside the supplied PE buffer before passing it to
crypto_shash_update().

A malformed image passed to kexec_file_load() can therefore make signature
verification read past the end of the PE buffer. Return -ELIBBAD for
out-of-range section data and guard hashed_bytes against unsigned wrap
before it is used by the trailing-data calculation.

Link: https://lore.kernel.org/keyrings/20260430173632.277436-3-bestswngs@gmail.com/
Fixes: af316fc442ef ("pefile: Digest the PE binary and compare to the PKCS#7 data")
Assisted-by: Codex:gpt-5-5-xhigh
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 crypto/asymmetric_keys/verify_pefile.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 1f3b227ba7f22..1405b76322cbd 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -292,6 +292,15 @@ static int pefile_digest_pe_contents(const void *pebuf, unsigned int pelen,
 		i = canon[loop];
 		if (ctx->secs[i].raw_data_size == 0)
 			continue;
+		if (ctx->secs[i].data_addr > pelen ||
+		    ctx->secs[i].raw_data_size > pelen - ctx->secs[i].data_addr) {
+			kfree(canon);
+			return -ELIBBAD;
+		}
+		if (ctx->secs[i].raw_data_size > UINT_MAX - hashed_bytes) {
+			kfree(canon);
+			return -ELIBBAD;
+		}
 		ret = crypto_shash_update(desc,
 					  pebuf + ctx->secs[i].data_addr,
 					  ctx->secs[i].raw_data_size);
-- 
2.53.0

