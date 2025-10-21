Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05231BFE00;
	Tue, 21 Oct 2025 06:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761027405; cv=none; b=utrxsK6QEsZlM5mFPcoaJL0vPHHSetWTe9sWOm/YytucDUgK2AqZSG2vYPfeTJ9/sXYV92SZ6K1xaHwzPcHG2DE9mjoX74cRXZWOo5BHKjizjaRNSSKpztxjikAcLlueGuR7O9kNS8DR57gGlnCH5akkD2+wAn+tNYYBgeLeHTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761027405; c=relaxed/simple;
	bh=sHVDezBW/0XeR+MuiIcfO2lFWrFm8vlJ9rDoT6rXIx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=En5ZcM2VnPecuqTXT6ks3ZGb6SdOUq0/YJc/PyM9ikNwaajhvNLU+tSW2iN2aPto0iE8FEoc7qbL1ZkfTjkoA9/BMS2RkuuBrrbz45svm1QS2VYlj7+gYlGO7jiD398Sa91iNyLR3nk1/sLumlIojmswIHiCTzgcyUrXXw4E3fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nkChOBJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nkChOBJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A8BC4CEF5;
	Tue, 21 Oct 2025 06:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761027404;
	bh=sHVDezBW/0XeR+MuiIcfO2lFWrFm8vlJ9rDoT6rXIx0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nkChOBJJ34v9yCZhDABPQ2Exco6ONGqtlS7vuEPsxKuaokFLY50PQrKGB01bK1lk0
	 1PROc0X8u2UCCPookYv3I/21RFZWhprJDabYxnDLkweRzhZLkAx54S7qleHTCQH2l9
	 1MNLnO41akdFH5JCjaPbF1T3rCgRadZrliL6/fkF/ytvM2y9as5lJg1oY5FfUugYlp
	 yF88z7Kq5oQ/4s7diEO2DIpN5cCf8xfMci4ni9aHlFt3phiojC4tdwgs6KYzAIlCuS
	 sY8WwZPEDZdWtBFb4PiPgvGZcB3foVSoFnMlrYS1hFVYkrCR/H09KP1sPIBAqHkrHW
	 nfFRaUo6tEosA==
Date: Mon, 20 Oct 2025 23:15:11 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Pei Xiao <xiaopei01@kylinos.cn>
Cc: Jason@zx2c4.com, ardb@kernel.org, ubizjak@gmail.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
Subject: Re: [PATCH] lib/crypto: poly1305: fix uninit-value in poly1305_blocks
Message-ID: <20251021061511.GA2385@sol>
References: <751b3d80293a6f599bb07770afcef24f623c7da0.1761026343.git.xiaopei01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <751b3d80293a6f599bb07770afcef24f623c7da0.1761026343.git.xiaopei01@kylinos.cn>

On Tue, Oct 21, 2025 at 02:01:20PM +0800, Pei Xiao wrote:
> syzbot reports uninit-value in poly1305_blocks:
> 
> BUG: KMSAN: uninit-value in poly1305_blocks+0x1a9/0x5f0 lib/crypto/x86/poly1305.h:110
>  poly1305_blocks+0x1a9/0x5f0 lib/crypto/x86/poly1305.h:110
>  poly1305_update+0x169/0x400 lib/crypto/poly1305.c:50
>  poly_hash+0x9f3/0x1a00 crypto/chacha20poly1305.c:168
>  poly_genkey+0x3b6/0x450 crypto/chacha20poly1305.c:233
>  chacha_encrypt crypto/chacha20poly1305.c:269 [inline]
>  chachapoly_encrypt+0x48a/0x5c0 crypto/chacha20poly1305.c:284
>  crypto_aead_encrypt+0xe2/0x160 crypto/aead.c:91
>  tls_do_encryption net/tls/tls_sw.c:582 [inline]
>  tls_push_record+0x38c7/0x5810 net/tls/tls_sw.c:819
>  bpf_exec_tx_verdict+0x1a0c/0x26a0 net/tls/tls_sw.c:859
>  tls_sw_sendmsg_locked net/tls/tls_sw.c:1138 [inline]
>  tls_sw_sendmsg+0x3401/0x4560 net/tls/tls_sw.c:1281
>  inet6_sendmsg+0x26c/0x2a0 net/ipv6/af_inet6.c:659
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x145/0x3d0 net/socket.c:742
>  sock_write_iter+0x3a6/0x420 net/socket.c:1195
>  do_iter_readv_writev+0x9e1/0xc20 fs/read_write.c:-1
>  vfs_writev+0x52a/0x1500 fs/read_write.c:1057
>  do_writev+0x1b5/0x580 fs/read_write.c:1103
>  __do_sys_writev fs/read_write.c:1171 [inline]
>  __se_sys_writev fs/read_write.c:1168 [inline]
>  __x64_sys_writev+0x99/0xf0 fs/read_write.c:1168
>  x64_sys_call+0x24b1/0x3e30 arch/x86/include/generated/asm/syscalls_64.h:21
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xd9/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> in poly1305_blocks, ctx->is_base2_26 is uninit-value, ctx init in：
> poly1305_init ->
>      poly1305_block_init
> 
> so add memset in poly1305_block_init, then use poly1305_init_x86_64 to init
> by asm.
> 
> Reported-by: syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
> Tested-by: syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
> Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
> ---

Thanks for the bug report.  It will first need to be confirmed that this
is actually an issue in lib/crypto/ rather than the calling code, and if
so, why poly1305_kunit doesn't catch it (even when run on an KMSAN
enabled kernel, which I've done).  And which commit it fixes.  I'm
guessing it's most likely a KMSAN false positive that was exposed by
commit b646b782e522 dropping the dependency of the
architecture-optimized Poly1305 code on !KMSAN.  KMSAN doesn't know
about memory initialization done by assembly code.  But I'll double
check this, if you don't get around to it first.

The hash algorithms generally don't need a dependency on !KMSAN, as
their assembly code doesn't initialize memory.  It looks like the
Poly1305 code is an exception to that though, and I missed it.  If so,
the proper solution (IMO) is to use kmsan_unpoison_memory() right after
the assembly function that initializes the memory is called.  See
sha256_finup_2x_arch() for an example of that.  Note that more than one
architecture may need this.  If it ends up being too inconvenient, we
can make the architecture-optimized Poly1305 code depend on !KMSAN
again.  But preserving KMSAN coverage is preferable.

- Eric
