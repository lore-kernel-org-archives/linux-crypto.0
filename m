From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: algif_hash: creating 0 sized array in hash_accept
Date: Mon, 25 Jan 2016 21:58:46 +0800
Message-ID: <20160125135846.GB8256@gondor.apana.org.au>
References: <56A6119C.1080203@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47305 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbcAYN6z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 08:58:55 -0500
Content-Disposition: inline
In-Reply-To: <56A6119C.1080203@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 25, 2016 at 07:14:20AM -0500, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next kernel
> I've hit:
> 
> [  828.386074] UBSAN: Undefined behaviour in crypto/algif_hash.c:185:7
> [  828.386811] variable length array bound value 0 <= 0
> [  828.387606] CPU: 1 PID: 17792 Comm: trinity-c313 Not tainted 4.4.0-next-20160122-sasha-00019-gd2a2eb4-dirty #2819
> [  828.388957]  1ffff10038e06f65 0000000087690421 ffff8801c7037ba8 ffffffffa34474f1
> [  828.394655]  0000000041b58ab3 ffffffffaf84c518 ffffffffa3447426 ffff8801c7037b70
> [  828.394684]  0000000087690421 ffffffffb329b1e0 ffff8801c7037c38 0000000000000000
> [  828.394708] Call Trace:
> [  828.394868] dump_stack (lib/dump_stack.c:52)
> [  828.395040] ? _atomic_dec_and_lock (lib/dump_stack.c:27)
> [  828.395079] ubsan_epilogue (lib/ubsan.c:165)
> [  828.395101] __ubsan_handle_vla_bound_not_positive (lib/ubsan.c:364)
> [  828.395118] ? __ubsan_handle_out_of_bounds (lib/ubsan.c:352)
> [  828.395179] ? sock_alloc_file (net/socket.c:388)
> [  828.395194] ? sock_splice_read (net/socket.c:356)
> [  828.395217] ? check_preemption_disabled (lib/smp_processor_id.c:52)
> [  828.395244] hash_accept (crypto/algif_hash.c:185 (discriminator 1))
> [  828.395264] SYSC_accept4 (net/socket.c:1476)
> [  828.395282] ? sockfd_lookup_light (net/socket.c:1427)
> [  828.395319] ? _raw_spin_unlock_bh (kernel/locking/spinlock.c:208)
> [  828.395339] ? release_sock (net/core/sock.c:2446)
> [  828.395645] ? hash_accept_parent_nokey (crypto/algif_hash.c:380)
> [  828.396457] ? map_id_down (kernel/user_namespace.c:201)
> [  828.396484] ? SyS_futex (kernel/futex.c:3099)
> [  828.396502] ? do_futex (kernel/futex.c:3099)
> [  828.396519] ? SyS_socket (net/socket.c:1213)
> [  828.396536] ? move_addr_to_kernel (net/socket.c:1213)
> [  828.396552] SyS_accept (net/socket.c:1506)
> [  828.396569] entry_SYSCALL_64_fastpath (arch/x86/entry/entry_64.S:186)
> [  828.396596] ? vm_mmap_pgoff (mm/util.c:325)
> 
> Which is this code snippet:
> 
> static int hash_accept(struct socket *sock, struct socket *newsock, int flags)
> {
>         struct sock *sk = sock->sk;
>         struct alg_sock *ask = alg_sk(sk);
>         struct hash_ctx *ctx = ask->private;
>         struct ahash_request *req = &ctx->req;
>         char state[crypto_ahash_statesize(crypto_ahash_reqtfm(req))];
> 
> 
> Where crypto_ahash_statesize(crypto_ahash_reqtfm(req)) == 0.

This should not be possible because we forbid any algorithm with
a zero statesize from being registered.  Please tell us what
algorithm you were using that led to this crash.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
