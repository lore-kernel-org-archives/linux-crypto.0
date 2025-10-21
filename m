Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72385224B04;
	Tue, 21 Oct 2025 15:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761059707; cv=none; b=W1Cn2xFsJcbtBLkJSBFmtkwdW/d+jg8UYc2B4QTelKbWDpHExfCXxw1+qqrIolsHn/WL72Ss2o58Vtn05yyk5pBTJ8XHMOrMT3nTNmk23KYcZdjLXxgKt90XOobR781dpXYWrAcauH/WzYrLHO7XhoCvyIUuxXOJ0phma31pca4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761059707; c=relaxed/simple;
	bh=FkggGhjBM3Wf31NTL63CL0AZAUsTipg1tYg1f7Y++9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xy/WoMSS47+bnRsoTOK8Mg82NzRNfC+r/0DlT8lbvllTQ2NRGNnMQXYqBEbMiFIlsd3zIh4z1bKI9S9B4UBt3OVmz1ybxmVZ68wbWE1e57yTR2C/tN8pdf2afI2xNBN3pOTISfRNCtvC+HGasSW/ZFfW26JALH+Tc4hEZuhuvjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nI7b+1ka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nI7b+1ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE6AC4CEF1;
	Tue, 21 Oct 2025 15:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761059706;
	bh=FkggGhjBM3Wf31NTL63CL0AZAUsTipg1tYg1f7Y++9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nI7b+1ka/rCb8YKV80aMeD9WzjHSLFqEhsVgQjCmUna9sDkzQTcMmqG5yLUgcgNYO
	 p7h4bg6abmWe4uRtIA2I36AUoU62VHX2U9S+oQgP1gDKiVwhRbSupYxXvU4XkSepRi
	 EdY3LsNevqcvf8txb0zcrp1WzMc6BSiQFQpBWSq10qDy5qQhcPurqzMqMbTjP4ZEj3
	 ChKnkHREXAwOJMKydyNmhT27xiuOwGPjXh/GtUPBD68FPGkKjhoEbrNKrjJjlHs3sz
	 opHwMpEvw7w1hlfu4verVIstd/EO5xtThUXz4B5r+jCJGnuFDkBe9IVfhUP1N+Hz6l
	 P1cD21NGxW5Ug==
Date: Tue, 21 Oct 2025 08:14:55 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Pei Xiao <xiaopei01@kylinos.cn>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
Subject: Re: [PATCH] lib/crypto: poly1305: fix uninit-value in poly1305_blocks
Message-ID: <20251021151455.GB1644@quark>
References: <751b3d80293a6f599bb07770afcef24f623c7da0.1761026343.git.xiaopei01@kylinos.cn>
 <20251021061511.GA2385@sol>
 <e1b1df10-ce40-4135-93fc-69a1c6d9f32f@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e1b1df10-ce40-4135-93fc-69a1c6d9f32f@kylinos.cn>

On Tue, Oct 21, 2025 at 04:40:47PM +0800, Pei Xiao wrote:
> 
> 在 2025/10/21 14:15, Eric Biggers 写道:
> > On Tue, Oct 21, 2025 at 02:01:20PM +0800, Pei Xiao wrote:
> >> syzbot reports uninit-value in poly1305_blocks:
> >>
> >> BUG: KMSAN: uninit-value in poly1305_blocks+0x1a9/0x5f0 lib/crypto/x86/poly1305.h:110
> >>  poly1305_blocks+0x1a9/0x5f0 lib/crypto/x86/poly1305.h:110
> >>  poly1305_update+0x169/0x400 lib/crypto/poly1305.c:50
> >>  poly_hash+0x9f3/0x1a00 crypto/chacha20poly1305.c:168
> >>  poly_genkey+0x3b6/0x450 crypto/chacha20poly1305.c:233
> >>  chacha_encrypt crypto/chacha20poly1305.c:269 [inline]
> >>  chachapoly_encrypt+0x48a/0x5c0 crypto/chacha20poly1305.c:284
> >>  crypto_aead_encrypt+0xe2/0x160 crypto/aead.c:91
> >>  tls_do_encryption net/tls/tls_sw.c:582 [inline]
> >>  tls_push_record+0x38c7/0x5810 net/tls/tls_sw.c:819
> >>  bpf_exec_tx_verdict+0x1a0c/0x26a0 net/tls/tls_sw.c:859
> >>  tls_sw_sendmsg_locked net/tls/tls_sw.c:1138 [inline]
> >>  tls_sw_sendmsg+0x3401/0x4560 net/tls/tls_sw.c:1281
> >>  inet6_sendmsg+0x26c/0x2a0 net/ipv6/af_inet6.c:659
> >>  sock_sendmsg_nosec net/socket.c:727 [inline]
> >>  __sock_sendmsg+0x145/0x3d0 net/socket.c:742
> >>  sock_write_iter+0x3a6/0x420 net/socket.c:1195
> >>  do_iter_readv_writev+0x9e1/0xc20 fs/read_write.c:-1
> >>  vfs_writev+0x52a/0x1500 fs/read_write.c:1057
> >>  do_writev+0x1b5/0x580 fs/read_write.c:1103
> >>  __do_sys_writev fs/read_write.c:1171 [inline]
> >>  __se_sys_writev fs/read_write.c:1168 [inline]
> >>  __x64_sys_writev+0x99/0xf0 fs/read_write.c:1168
> >>  x64_sys_call+0x24b1/0x3e30 arch/x86/include/generated/asm/syscalls_64.h:21
> >>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >>  do_syscall_64+0xd9/0xfa0 arch/x86/entry/syscall_64.c:94
> >>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >>
> >> in poly1305_blocks, ctx->is_base2_26 is uninit-value, ctx init in：
> >> poly1305_init ->
> >>      poly1305_block_init
> >>
> >> so add memset in poly1305_block_init, then use poly1305_init_x86_64 to init
> >> by asm.
> >>
> >> Reported-by: syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
> >> Tested-by: syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
> >> Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
> >> ---
> 
> hi Eric,
> 
>     thanks for your responce.
> 
> > Thanks for the bug report.  It will first need to be confirmed that this
> > is actually an issue in lib/crypto/ rather than the calling code, and if
> > so, why poly1305_kunit doesn't catch it (even when run on an KMSAN
> > enabled kernel, which I've done).  And which commit it fixes.  I'm
> > guessing it's most likely a KMSAN false positive that was exposed by
> > commit b646b782e522 dropping the dependency of the
> > architecture-optimized Poly1305 code on !KMSAN.  KMSAN doesn't know
> > about memory initialization done by assembly code.  But I'll double
> > check this, if you don't get around to it first.
> >
> > The hash algorithms generally don't need a dependency on !KMSAN, as
> > their assembly code doesn't initialize memory.  It looks like the
> > Poly1305 code is an exception to that though, and I missed it.  If so,
> > the proper solution (IMO) is to use kmsan_unpoison_memory() right after
> > the assembly function that initializes the memory is called.  See
> > sha256_finup_2x_arch() for an example of that.  Note that more than one
> > architecture may need this. 
> 
> --- a/lib/crypto/poly1305.c
> +++ b/lib/crypto/poly1305.c
> @@ -13,6 +13,7 @@
>  #include <linux/module.h>
>  #include <linux/string.h>
>  #include <linux/unaligned.h>
> +#include <linux/kmsan.h>
> 
>  #ifdef CONFIG_CRYPTO_LIB_POLY1305_ARCH
>  #include "poly1305.h" /* $(SRCARCH)/poly1305.h */
> @@ -31,6 +32,7 @@ void poly1305_init(struct poly1305_desc_ctx *desc,
>         desc->s[3] = get_unaligned_le32(key + 28);
>         desc->buflen = 0;
>         poly1305_block_init(&desc->state, key);
> +       kmsan_unpoison_memory(desc, sizeof(struct poly1305_desc_ctx));
>  }
>  EXPORT_SYMBOL(poly1305_init)
> 
> how about this ? 
> 

It should only be after the specific assembly functions that need it.
I haven't had a chance to look into this since your first email, but
again, I would like to confirm that (a) this is actually the issue, (b)
before we suppress the warnings, that all the assembly functions
actually initialize all the memory they're supposed to, and (c) which
places in the Poly1305 code actually need this.  If (c) ends up being
too many places (I think it might), we probably should just make
CRYPTO_LIB_POLY1305_ARCH depend on !KMSAN again.

- Eric
