From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: XTS Crypto Not Found In /proc/crypto Even After Compiled for
 4.10.1.
Date: Sun, 5 Mar 2017 19:16:33 +0200
Message-ID: <20170305171633.fxrvxwy2ai5h5igv@kozik-lap>
References: <CALaQ_hoZ6wh-H_NNoT80r6kthvFpL05zNWr7upVqispknXMEvg@mail.gmail.com>
 <20170303040210.GA24737@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Nathan Royce <nroycea+kernel@gmail.com>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:33659 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751573AbdCERQj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Mar 2017 12:16:39 -0500
Content-Disposition: inline
In-Reply-To: <20170303040210.GA24737@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 03, 2017 at 12:02:10PM +0800, Herbert Xu wrote:
> On Thu, Mar 02, 2017 at 05:35:30PM -0600, Nathan Royce wrote:
> > ARM ODroid XU4
> > 
> > $ cat /proc/config.gz | gunzip | grep XTS
> > CONFIG_CRYPTO_XTS=y
> > 
> > $ grep xts /proc/crypto
> > //4.9.13
> > name         : xts(aes)
> > driver       : xts(aes-generic)
> > //4.10.1
> > <blank>
> > //cbc can be found though
> > 
> > CRYPTTAB:
> > cryptswap1 UUID=<sanitized> /dev/urandom
> > swap,offset=2048,cipher=aes-xts-plain64:sha512,size=512,nofail
> > 
> > FSTAB:
> > /dev/mapper/cryptswap1 none swap sw 0 0
> > 
> > Boot Log:
> > [   10.535985] ------------[ cut here ]------------
> > [   10.539252] WARNING: CPU: 0 PID: 0 at crypto/skcipher.c:430
> > skcipher_walk_first+0x13c/0x14c
> > [   10.547542] Modules linked in: xor xor_neon aes_arm zlib_deflate
> > dm_crypt raid6_pq nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
> > ip_tables x_tables
> > [   10.561716] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.10.1-dirty #1
> > [   10.568049] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
> > [   10.574171] [<c010eb54>] (unwind_backtrace) from [<c010b408>]
> > (show_stack+0x10/0x14)
> > [   10.581893] [<c010b408>] (show_stack) from [<c036772c>]
> > (dump_stack+0x84/0x98)
> > [   10.589073] [<c036772c>] (dump_stack) from [<c011bb20>]
> > (__warn+0xe8/0x100)
> > [   10.595975] [<c011bb20>] (__warn) from [<c011bc30>]
> > (warn_slowpath_null+0x20/0x28)
> > [   10.603546] [<c011bc30>] (warn_slowpath_null) from [<c0329a48>]
> > (skcipher_walk_first+0x13c/0x14c)
> > [   10.612390] [<c0329a48>] (skcipher_walk_first) from [<c0329b30>]
> > (skcipher_walk_virt+0x1c/0x38)
> > [   10.621056] [<c0329b30>] (skcipher_walk_virt) from [<c0330ed0>]
> > (post_crypt+0x38/0x1c4)
> > [   10.629022] [<c0330ed0>] (post_crypt) from [<c0331470>]
> > (decrypt_done+0x4c/0x54)
> > [   10.636389] [<c0331470>] (decrypt_done) from [<c05a03f0>]
> > (s5p_aes_complete+0x70/0xfc)
> > [   10.644274] [<c05a03f0>] (s5p_aes_complete) from [<c05a05b0>]
> > (s5p_aes_interrupt+0x134/0x1a0)
> > [   10.652771] [<c05a05b0>] (s5p_aes_interrupt) from [<c016dc3c>]
> > (__handle_irq_event_percpu+0x9c/0x124)
> 
> This looks like a bug in the s5p driver.  It's calling the completion
> function straight from the IRQ handler, which is triggering the
> sanity check in skcipher_walk_first.
> 
> The s5p driver needs to schedule a tasklet to call the completion
> function.

Tasklet... or threaded IRQ handler maybe? I sent a fix.

BTW, I subscribe the crypto list but I could not find the original email
there.

Best regards,
Krzysztof
