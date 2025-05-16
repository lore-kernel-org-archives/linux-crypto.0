Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8222405E8;
	Fri, 16 May 2025 12:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747399269; cv=none; b=kRoFajmaJ2D1ZZRLeR4DKp82aTn7KGv99GGXZAGm+bV1y8h6LixCgiq0WOZBOuLfsuOXTHW2U/Q/yYtbaU14e8HPnvlS8vPta3vsV6QR4qkj9AlbnAGJcDhmiBDg/1R0Xd5ofZRJ7giJwDbiBTGbeDlLjmdygZbjfoPtIggYXkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747399269; c=relaxed/simple;
	bh=yY+PXoQlRqt4aQl6eeVaUN2CtAqQFLx1iqaNPe16VTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G5Vk1ez5NfB7J9zGuYfBDG8M5Gtv2V2aVe0S4JCPQrZPKCU4TwiBSa6InigFfH0ihkvhx2mqCtEfLoedarwaO36jihmatS2UdgrXy6ZuM25yfDwJ5rvXaFnCeWdkI8ENXcqeNTTnizRmS0fiXa6mwDGlVLZr1vShLFR3+IMguWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RaBdgvZO; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RaBdgvZO"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a363d15c64so151609f8f.3;
        Fri, 16 May 2025 05:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747399266; x=1748004066; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bJjLBJ0gcyhMb5FtEYraV2c+fUpvRvPo83EthVpdapg=;
        b=RaBdgvZOuaI7dhZZN3XJDc6f22LgBg887sWmeUMjMddyERsm1+ddGUlola4od/T/No
         h9lej4Pgw6Dso1n1Re5CM7+a7r4IGiJulWh7qVw5W+J8RJIiV8/x8AXIiiKXs69cPpS0
         Qm+As8RyDcJFDO0S/XVd9mxExGLfgPLCCNYTVhAbC6L9XQSU8r13zqw/8C51CowxVGCs
         U7POTPF0mQbFHk+K2c6kmh7NbS35nHjJETSogGhiHCb7/Y6ufuz9tPAB8gyMHKjmnIOE
         BwXLUxfjRZWLOmEjxmacukyaCCBL3F61ZKyTFgMrRxFqWOeHmTQy3JtMUYGy+nrM5ui1
         gk8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747399266; x=1748004066;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bJjLBJ0gcyhMb5FtEYraV2c+fUpvRvPo83EthVpdapg=;
        b=fh9sTmypaPZw3JSbasg+WMP0wPUOx2tOzMrt8G/r4ucQnlM37PuS1Os9n/3r2UOccu
         /v/ZfxwEp8Q4q5+8iCyzlU30xcQD2G0Z7viHUX7M38fO666oJKiio2uWBWlcDdCfXIZN
         5pLgF6Qome9j901hxN57ckatN6vvaQ42W1S4sst8ouPRX4qrr15ltihfx0oIJlrdh+GS
         1YFEQ2M88PC2hj58DC5jcAYwTJOSAeMMUNt0B2j06nTvQtlFjtJzB9Od5nBxVypbaOY5
         WEcRc/ayWlQ7OSRyu24zIKRy0AOylG4YW9BaA9lsH7VvRviEcWV6vxkz464gQLfp5ISF
         L+Ig==
X-Forwarded-Encrypted: i=1; AJvYcCX2NysEp5fGLa2yOZzM3ntKXjglBgfSQjkF0zHMpSBvy7giNkXeNleymXRW31bE/mxJ8Fk6xKQ5SKNqlzs=@vger.kernel.org, AJvYcCXG350hENXMY4m2346BOPhnK+SN9BFJvCObYGUa5eJke0wFb394SU6dZSFVgLFJRMMnUqMPQ35/QBgGAgS5@vger.kernel.org
X-Gm-Message-State: AOJu0YyGLgx1buhHZGEGts7/HmGIC5kmmV9nrnEWmRglqikHGVk5iPfu
	Wlfh6vi/ZR2ghyiBwKNU9UV1lYkj7jHcDwFjTkNEyMk9H6znZC/YaQMf
X-Gm-Gg: ASbGncv0N9qKlMGAT9bO9ovgHx271ykmDUhBif3n+IRAaqlL6ZzICShuvNimkWeCvCz
	kjtBpPyHtwtlyOGp6xUrhzPCFDVkfj8aiwXQYaKxLRnNfv2MDepUVVtZjyXHvC51whyGp/xO4b8
	GAnm2ZuZ2F37JAr9hVMV7B5SoTin4Y7pEIyjNOA0Zg7ZIBiFcBXQsopDo8e58OIwyF/Sw9ziGpD
	0UtHHDyNCYzdOmQJUg+TfKrNrks85SS+6eGFABqDuBR9+/Rz9hDkT7IeyD7Zd9qWGrh/3mJp2cb
	/E27VGC75fBfZLIWYLC3ezxV09MU2owpUHp6Pjk2G6t0drQYmbDhuDUV2HpTot8=
X-Google-Smtp-Source: AGHT+IHtiqkS5DvdJ07HW0cFniidaIzsuY62UfQL4qiNRCcUAw81eCFr2QPUJAp0XycxXMHQ7noImw==
X-Received: by 2002:a05:6000:188e:b0:3a2:45f:7c3 with SMTP id ffacd0b85a97d-3a35c84654amr3402315f8f.57.1747399265406;
        Fri, 16 May 2025 05:41:05 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a35ca9417dsm2675296f8f.101.2025.05.16.05.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 05:41:04 -0700 (PDT)
Date: Fri, 16 May 2025 14:41:02 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aCcyXkeBvHQYvf2d@Red>
References: <dcb0b04e479d6f3cfed87795d100ea09e4fbcf53.camel@gmail.com>
 <aCAX8rj2ie4QMnTo@gondor.apana.org.au>
 <28184fb96e2de8a0af32816f5ff1b3d776b57217.camel@gmail.com>
 <aCMOyWVte4tw85_F@gondor.apana.org.au>
 <8e9b45bdafe6ac3f12bcbb5fce5bc9949566344f.camel@gmail.com>
 <aCQm0aHYnI6ciyPz@gondor.apana.org.au>
 <20dde00750d803a9a364ded99dab1e3e22daec77.camel@gmail.com>
 <20250515182131.GC1411@quark>
 <f0dc235e3d7bfa1f60cc01fd527da52024af54e0.camel@gmail.com>
 <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au>

Le Fri, May 16, 2025 at 07:25:49AM +0800, Herbert Xu a écrit :
> On Thu, May 15, 2025 at 08:45:39PM +0200, Klaus Kudielka wrote:
> >
> > ...and the failing marvell-cesa self-tests seem to have magically disappeared.
> > I now had five successful reboot / modprobe marvell-cesa in a row.
> 
> It's always unfortunate when a printk patch makes the problem
> go away :)
> 
> Correntin, can you still reproduce the failures with the latest
> cryptodev tree?

Yes I have still errors:
[   12.798454] marvell-cesa f1090000.crypto: CESA device successfully registered
[   13.282357] alg: ahash: mv-sha256 test failed (wrong result) on test vector 1, cfg="random: inplace_one_sglist use_final src_divs=[<flush>42.5%@+4054, 57.95%@+4074]"
[   13.286675] alg: ahash: mv-sha1 test failed (wrong result) on test vector "random: psize=47 ksize=0", cfg="random: inplace_one_sglist use_final src_divs=[<reimport,nosimd>8.86%@+4058, 91.14%@+164] iv_offset=91 key_offset=58"
[   13.297245] alg: self-tests for sha256 using mv-sha256 failed (rc=-22)
Setting prompt string to ['-+\\[ end trace \\w* \\]-+[^\\n]*\\r', '/ #', '~ #', 'sh-5.1#', 'Login timed out', 'Login incorrect']
[   13.317153] ------------[ cut here ]------------
[   13.317157] alg: self-tests for sha1 using mv-sha1 failed (rc=-22)
[   13.323696] WARNING: CPU: 1 PID: 149 at crypto/testmgr.c:5808 alg_test+0x42c/0x654
[   13.328333] ------------[ cut here ]------------
[   13.334524] alg: self-tests for sha256 using mv-sha256 failed (rc=-22)
[   13.342146] WARNING: CPU: 0 PID: 148 at crypto/testmgr.c:5808 alg_test+0x42c/0x654
[   13.346745] Modules linked in: md5 marvell_cesa
[   13.353288] alg: self-tests for sha1 using mv-sha1 failed (rc=-22)
[   13.360875]  libdes sfp
[   13.365414] Modules linked in:
[   13.371609]  mdio_i2c
[   13.374059]  md5
[   13.377121] CPU: 1 UID: 0 PID: 149 Comm: cryptomgr_test Not tainted 6.15.0-rc5-g1bafd82d9a40 #105 NONE 
[   13.377130] Hardware name: Marvell Armada 380/385 (Device Tree)
[   13.377133] Call trace: 
[   13.377139]  unwind_backtrace from show_stack+0x10/0x14
[   13.377153]  show_stack from dump_stack_lvl+0x54/0x68
[   13.377164]  dump_stack_lvl from __warn+0x80/0x124
[   13.377177]  __warn from warn_slowpath_fmt+0x124/0x18c
[   13.377190]  warn_slowpath_fmt from alg_test+0x42c/0x654
[   13.377201]  alg_test from cryptomgr_test+0x18/0x38
[   13.377208]  cryptomgr_test from kthread+0x108/0x234
[   13.377221]  kthread from ret_from_fork+0x14/0x28
[   13.377231] Exception stack(0xf0b11fb0 to 0xf0b11ff8)
[   13.377236] 1fa0:                                     00000000 00000000 00000000 00000000
[   13.377241] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   13.377246] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   13.377249] ---[ end trace 0000000000000000 ]---

