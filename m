Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1631C695
	for <linux-crypto@vger.kernel.org>; Mon,  5 Jan 2026 07:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767599254; cv=none; b=JlEU+mNiRWjHGFI0fxARaA8MaoytMWp2ILqhm8DZ89jaavTdtB3PArqZuKH/gcOaIZAu8P5QnGg8o6i4Lq7WcnOCoWmqdH8e2dI9YhGO4+BK6xLRJUHBXydLRRqGIHB79U+TQeyCAYV+jCzMJHt0pTpjeDa+wg/yy1nBQFiDDxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767599254; c=relaxed/simple;
	bh=nZVAqheaPq5rGRSWmaOVnJe8g46n6sKwiOrt8BkPTmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ss4e+Ugx9DwmJ/c5eBHO1LjjKyXeOUNelB9ok87wbGNj+r9dp3F6ZnGZZDbtdBzhnNDy0I03vHqCRrH3I3dyFtRIz58m99tLV/Ck3LHI2cukPNwnpQNXfZsSHHOnu7/4MSpRTjZkp5SnN0Nqj8tSWo4ADVXo65q+SclO1aWZs5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XDKMJWyr; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XDKMJWyr"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-bc274b8b15bso14822975a12.1
        for <linux-crypto@vger.kernel.org>; Sun, 04 Jan 2026 23:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767599252; x=1768204052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Smn7G9NNF4TKpSBrLZt6/rkru/ozPf2jYkxgsCOt/U=;
        b=XDKMJWyrvDbiwDOfmQKLltH6IiyxEaweMnOAZFBZVGTYC2GOqTfKh3n04lf5GJ84qu
         5s0gbg4aU+QvgUmtV7ytpI0dXCqPB+akAz5slCfWkIk9tIcmZWrmUxBoEwmp6kRQeVdB
         mWGTurcze4OqqRw5CUYJ8rQ8v9uWuLvqfyqXF/tOyXXg/195fsYvebVWZJ6Ki+oIuXZa
         lq8f2FsrXZaPRS0o17VkIPhBt2cfSseITAlkOoe59bKGSK7ub90fst0TVAjIauffDcOP
         3+BOPMFIVMQjTL+v2cHEnTNRAFpbbJ/cCITAJrPSRtrSDdpNrBJvN+U/6tGxmjdBBmBl
         8Xvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767599252; x=1768204052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2Smn7G9NNF4TKpSBrLZt6/rkru/ozPf2jYkxgsCOt/U=;
        b=aTopJ4qyADXFN+WIoq+JdbrwA9dOLRosylGC8zK7A/LppzeLGw/YIuA/1VmJ43RtvU
         AIlbLsP3oEV5JMxG36Xf5gL5U/Tw6+06cHflx8OMXLRElsAfO/TzwmF1pqB22f3YbU5Q
         +kwMcnPz6skZOfGYla5v9zxM93BusXRzfwfxCBrzkaU5BeO6RPCto5qezlSqEqhyBmGV
         gbIJ5++JfZS6E5XMQI1uaJag0WxSwa7KUNUg8GKYCQ3/wmbZ4ygJGiBeuqualLTWdZZh
         hfaOr9C0Q4aWWG72u8gubC099sU1+qbjKhXhkevXl1UQ6qkC4LOXnZdHoGw8HvTrasAA
         VwQQ==
X-Gm-Message-State: AOJu0Yxo+6kEwjtdEmtwcfjtdZCeHmMTyMo1xBDE2lk0FWVymjKhDHY6
	dNpX4vP7CwsP0AGChDa/5klsEN5dexIHaJD60DmYXfGJxmLy1faF0S8W
X-Gm-Gg: AY/fxX484xu+Y2GmW4C0pQCSbUS2OsNBbKX4j7nyD5B8aZJtU2AbxJqodwRwPdy8Kvh
	d8OLZ0K/qlibfZNrKYUutROyRWG8xRuhWIF0SnRe98LDeO0HBElEroksbTI5Rngl0VrSDPvWnMz
	HNIwCp0ekC89uSXLtKwKrIzizYf0rMYxos83bYniivIQGRVTesCgOlfjVQZ61a2PfQbUbOmVymu
	fG4zVqawt+CmtepZ6eIy20JgnyP1IOisBAwKqB3IARDqwujEuHU0MWPC7qCattWsFXBYlKXltTP
	UPBrgkBwMF2fhZkHopGVezES1AVUrlZtDtBpa2Tlt6Su3fewN0XiC/hDHQR5XvyQvsiQNiIwEp2
	Xz0yQNDkKCM6vshqTHok96hM0bADyhniW7UOfYQybYPhP2IxnHLEmR4qNxPHD8cYVSRDqqOI46A
	==
X-Google-Smtp-Source: AGHT+IHVaBHzL3ldcoq10mQ0DvSoQNAzO29+h1IBrSy2gZY7Qh6quSoh5XWNmgIvhDzcT+gz+HyNHQ==
X-Received: by 2002:a05:693c:8008:b0:2b0:4f8e:3273 with SMTP id 5a478bee46e88-2b05ebd7223mr36936529eec.6.1767599252090;
        Sun, 04 Jan 2026 23:47:32 -0800 (PST)
Received: from gmail.com ([2a09:bac5:1f0f:28::4:33f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b05ffad66fsm101610210eec.4.2026.01.04.23.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 23:47:31 -0800 (PST)
From: Qingfang Deng <dqfext@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>
Subject: Re: [PATCH 02/36] lib/crypto: aes: Introduce improved AES library
Date: Mon,  5 Jan 2026 15:47:12 +0800
Message-ID: <20260105074712.498-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260105051311.1607207-3-ebiggers@kernel.org>
References: <20260105051311.1607207-1-ebiggers@kernel.org> <20260105051311.1607207-3-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 4 Jan 2026 21:12:35 -0800, Eric Biggers wrote:
>  extern const u8 crypto_aes_sbox[];
>  extern const u8 crypto_aes_inv_sbox[];
> +extern const u32 __cacheline_aligned aes_enc_tab[256];
> +extern const u32 __cacheline_aligned aes_dec_tab[256];
 
__cacheline_aligned puts the array in ".data..cacheline_aligned"
section. As a const array, it should be in ".rodata" section, so
____cacheline_aligned (note the extra underscores) should be used
instead.
You can also apply the same to crypto_aes_sbox and crypto_aes_inv_sbox
while at it.

Regards,
Qingfang
