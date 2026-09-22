Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA70D490C0C
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 05:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790055850; cv=none; b=Hd9aWEFXrWLhEabsrj+LnmZQoZ1RpQyvQqxX8UYH9bNs0QJmUU+D83gisRm3CQs64D+rztK1DgwIloeUrWqQtwMFD7AM8DOPfDjfw7BwA9p2h+pt0QUA6hKosSmMljb2r5BB/BgiO4aV05mf4Pg0nnEgf61LDApu55tTmMZ/uDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790055850; c=relaxed/simple;
	bh=VJcogttpnzmzRq+dZ9JiW+yKGA10LOl2AIc4TKpIVUo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fju8YAB4hKzVfmLUm5TeX3l0R06BH8S6pIM/RI8MumzENXE1mNjL9S0RkC9XMGDqY0inmEg0ZTortL0y0kHdadN9UvWtNUiTAI+NLaf/nuZkNtQ7k/jaH3em7yHi3xZxhiGQ+zjL4j31OIEb6iRV2KG7zUqK796dkpPnLocWgMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TbGJvfPk; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TbGJvfPk"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e69b9e16aso37625125e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 22:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790055847; x=1790660647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d4/LQ+6F9fJ/cjcJrUOPJx6DRMexHTJtKczEX1e75B0=;
        b=TbGJvfPkvAZRo+LXDcLV+l5pniWtNlBS654EvABd+F3nV86+Z8qz99YCO0T8HIMDB3
         p6AeTXRjx8Aw0QXeHtgutrtPy/o+ur6Nv0suElnopeNjBhs5IgMeuQuhKK0/CPM2JaQT
         GgSRntQZkDZQ6s3AJQJtvN0aJPuJOgGxixUPcRIgJXWYZ3k31zALrwwcrbvS1QqkTO4+
         85H1uTrVHhSarB1f3OyUKmemfeieGICLetaFog5iBq8Zx2AA7Mi4UY4JnL+TrfrF2zg1
         i+v0ihWMd3eThlOlci+Q1ZGnR08cBp4/N6bhT1Q6fNouo85BCiwSNBiyazKMGKy8c/DY
         eJRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055847; x=1790660647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d4/LQ+6F9fJ/cjcJrUOPJx6DRMexHTJtKczEX1e75B0=;
        b=CuH+iENf3YRDFQa2tw5R4e6kg6m2ygc/fyN9vU4PkwcAZPS0F+hpMi6RxJe6+XNXrj
         wRKjwfVe/s7c9HoYt1LriwKqyYz7JWxyQDG4gZtFOpUPT9h/uYFKjRG1gU1kAkxLzwB8
         dYTeKH9UdRlgm2ZSMg4Y40kM457lR/KCxG3vrFX99wtHmzyKzPFS2n3pGRMxerY4OleZ
         oXwjVRCzbJcTygn5SJ78y/bbyCzWafJDY5uJmLjKequsahul8xfTsDlYdXk7bhjMF5ar
         mWGIaF43huey3OrbThOZGl04etgaP9702XcRG2gqI3w7swPJ93femEiZslJIEIt/bsA+
         48Rw==
X-Gm-Message-State: AFuF++kxx9JpzcvsX7OqNc2vv8yHYyx8zMTv3EIokXYrahxARwrySkBY
	7jb677XWP4zi9mUH6jj8pRhQ62l/aSA/N9YMqNjXXUpUKKr3Ncvu+pNR
X-Gm-Gg: AYBFou0VBzCoFOmVKYrD5rJKvMM6/kNorelb75G0+RRnsnsvdSnRbzGnI2uUlMBfxHQ
	39ph8toSKkjVy8KJdHtOatBYcveXic/myJzKEc7qO/CQhNqLkE2XfewclOLmjmj38txl3wGwEIV
	cB686zwHeQUN+aE1PrFhpLtPXZsvzWF8xmsyF3Y4H9dQ0a4sFJuEX1vdO7QpUrmNQxvZDPO2dbl
	m8CsYF67KC8YUzdMoOOs3B/GldB/3S6sF5L2or6bcBszB7bHVq5qZMq3YIiKMMM0yWHBPXPiqPg
	66QRmONJ0Rz5bbMEQucn4wtdzhNBk10z9e+TL+jYxnIk0E1c4+Orz13V3mulaivFPL1HpqMttkK
	tDde3g9ydLqCwtQ6wvAbnC0kIQJiOJe6dugrablZxhkeDmhVZiZNO31QA9Pp5CluLQr+VPY9/5n
	Cyq1y6Ue9feiKekbYjD73pBiv7GY03uKk6KPWbCpNFHhH/ZNtzpSZ2r0OOk5kPTPeUwjStILBA1
	e36zPqz5LaYavepfIftJdyU4iut+zvHt1iaUPUSAlCuTD2W/szVjYVVMS774VkvfkdG3e7/s5q6
	MXj2sgX7VJZ+sAL00HjShQHvZSTqka7LpMsMmPQ6gKz0NrAyhV5w/tKTBczKk35h1cfZzfUsdrh
	F
X-Received: by 2002:a05:600d:848f:10b0:49d:827:e5b6 with SMTP id 5b1f17b1804b1-49fc5735351mr124626255e9.20.1790055846765;
        Mon, 21 Sep 2026 22:44:06 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a5e6-3401-ecdc-1e24-2e52-02d6.310.pool.telefonica.de. [2a02:3100:a5e6:3401:ecdc:1e24:2e52:2d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fd8a638fcsm47621575e9.0.2026.09.21.22.44.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 21 Sep 2026 22:44:06 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH 19/20] lib/crypto: riscv/aes-ctr: Migrate optimized code into library
Date: Tue, 22 Sep 2026 07:44:01 +0200
Message-Id: <20260922054401.19194-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260921050910.296144-20-ebiggers@kernel.org>
References: <20260921050910.296144-1-ebiggers@kernel.org> <20260921050910.296144-20-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 20 Sep 2026 22:09:05 -0700 Eric Biggers <ebiggers@kernel.org> wrote:
> -// void aes_ctr32_crypt_zvkned_zvkb(const struct crypto_aes_ctx *key,
> -//				    const u8 *in, u8 *out, size_t len,
> -//				    u8 iv[16]);
> +// void aes_ctr32_crypt_zvkned_zvkb(u8 *dst, const u8 *src, u32 len, u8 iv[16],
> +//				    const struct aes_enckey *key);
>  SYM_FUNC_START(aes_ctr32_crypt_zvkned_zvkb)

isn't this a sign extension problem on rv64? The psABI sign-extends
32-bit args, so for len >= 2G a2 comes in as 0xffffffff8xxxxxxx, and
the asm uses it as a 64-bit length as is.

That would run off the end of both buffers.

Nothing passes that much in one call today, but aes_ctr_arch() only
chunks down to 0xfffffff0 and aes_ctr() takes a size_t, so it is
allowed. The old prototype was size_t and the caller zero-extended.

Thanks,
Karl
