Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8E1311C33;
	Mon, 12 Jan 2026 19:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768246769; cv=none; b=EexXb8PT+857TPNsTgZbQ/FefPj3rDbTewiRSTzG/oc26UFBJ2XifWxQmjfzBPEXoNGv9Ca3sk98wftTirJCYE6NwEOZP8u0JWyQ3J3EimMxUcM0TvKJqHUz2PfLigI364VdF3CFl9D9cCPTcAO9FuIlUUD9SWHHNrxAaYJEMek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768246769; c=relaxed/simple;
	bh=LURN05d3CU/QZ1spSz5FkUTEj3L7mOXS6iR5PRWHVqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6RJ/+qUGeXzX0WJqG0MYsVJ5hu0paVdjZAIynKzlIlt19P6GjWI5tVZQcpcen4wlrSzaVuGTnn0JeLUPepV6UMl/yU95HKkylCx4+WO1LeffafjMT1INguHLo9nIyPa99iaqPAmFhYd9Z+IAO7tO7X5ToEXwv4hICXvrBhRfyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mFWTTgxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mFWTTgxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95302C116D0;
	Mon, 12 Jan 2026 19:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768246768;
	bh=LURN05d3CU/QZ1spSz5FkUTEj3L7mOXS6iR5PRWHVqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mFWTTgxXkotZ0ofJBiqS9DXmNvTtyl0BeMYinX7moA67NgrridSjzZbnGlBxWPdyE
	 uSDZEOxvYm1eZRbWVg1f2Np2vPLq7nYsOMo/dAqF+Ds8ESMKz7BriQRSH1in7oSjPN
	 zKNFc523lkucWU0u+RvReEJBDhM+3DTBuopWzGhRnfeKmShnLGlAiT/WFHWvo96OiA
	 b0lgRuDJnFT8AFhNxcDqeqnpUSpwJ32ZqR0AarD0GCVKFoSAQ59kZaiVaqrh20ZzmL
	 wSlnSkhMdf0qyqw6aM1vixZIDGYaT9C6sjI/i4LCYjtibD148IxieB7Liy1e7AIM+j
	 RqeO9eD9MTHEA==
Date: Mon, 12 Jan 2026 11:39:02 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: syzbot <syzbot+703d8a2cd20971854b06@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in adiantum_crypt
Message-ID: <20260112193902.GB1952@sol>
References: <692f9906.a70a0220.d98e3.01ae.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <692f9906.a70a0220.d98e3.01ae.GAE@google.com>

On Tue, Dec 02, 2025 at 05:57:26PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    6cf62f0174de Merge tag 'char-misc-6.18-rc8' of git://git.k..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1727df42580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=61a9bf3cc5d17a01
> dashboard link: https://syzkaller.appspot.com/bug?extid=703d8a2cd20971854b06
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13bfa112580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=169e422c580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/fb216361ff9c/disk-6cf62f01.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/eb55e25eb970/vmlinux-6cf62f01.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/5110f00a1a4e/bzImage-6cf62f01.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/7a62729c5268/mount_0.gz
>   fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=16dd8112580000)
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+703d8a2cd20971854b06@syzkaller.appspotmail.com
> 
> =====================================================
> BUG: KMSAN: uninit-value in subshift lib/crypto/aes.c:150 [inline]
> BUG: KMSAN: uninit-value in aes_encrypt+0x1239/0x1960 lib/crypto/aes.c:283
>  subshift lib/crypto/aes.c:150 [inline]
>  aes_encrypt+0x1239/0x1960 lib/crypto/aes.c:283
>  aesti_encrypt+0x7d/0xf0 crypto/aes_ti.c:31
>  cipher_crypt_one+0x120/0x2e0 crypto/cipher.c:75
>  crypto_cipher_encrypt_one+0x33/0x40 crypto/cipher.c:82
>  adiantum_crypt+0x939/0xe60 crypto/adiantum.c:383
>  adiantum_encrypt+0x33/0x40 crypto/adiantum.c:419
>  crypto_skcipher_encrypt+0x18a/0x1e0 crypto/skcipher.c:195
>  fscrypt_crypt_data_unit+0x38e/0x590 fs/crypto/crypto.c:139
>  fscrypt_encrypt_pagecache_blocks+0x430/0x900 fs/crypto/crypto.c:197

ext4 sometimes encrypts uninitialized memory.  Duplicate of already-
reported bug, see https://lore.kernel.org/r/20251210022202.GB4128@sol/

#syz dup: KMSAN: uninit-value in fscrypt_crypt_data_unit

- Eric
