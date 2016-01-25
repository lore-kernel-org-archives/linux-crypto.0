From: Sasha Levin <sasha.levin@oracle.com>
Subject: crypto: algif_hash: creating 0 sized array in hash_accept
Date: Mon, 25 Jan 2016 07:14:20 -0500
Message-ID: <56A6119C.1080203@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16474 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbcAYMOe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 07:14:34 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next kernel
I've hit:

[  828.386074] UBSAN: Undefined behaviour in crypto/algif_hash.c:185:7
[  828.386811] variable length array bound value 0 <= 0
[  828.387606] CPU: 1 PID: 17792 Comm: trinity-c313 Not tainted 4.4.0-next-20160122-sasha-00019-gd2a2eb4-dirty #2819
[  828.388957]  1ffff10038e06f65 0000000087690421 ffff8801c7037ba8 ffffffffa34474f1
[  828.394655]  0000000041b58ab3 ffffffffaf84c518 ffffffffa3447426 ffff8801c7037b70
[  828.394684]  0000000087690421 ffffffffb329b1e0 ffff8801c7037c38 0000000000000000
[  828.394708] Call Trace:
[  828.394868] dump_stack (lib/dump_stack.c:52)
[  828.395040] ? _atomic_dec_and_lock (lib/dump_stack.c:27)
[  828.395079] ubsan_epilogue (lib/ubsan.c:165)
[  828.395101] __ubsan_handle_vla_bound_not_positive (lib/ubsan.c:364)
[  828.395118] ? __ubsan_handle_out_of_bounds (lib/ubsan.c:352)
[  828.395179] ? sock_alloc_file (net/socket.c:388)
[  828.395194] ? sock_splice_read (net/socket.c:356)
[  828.395217] ? check_preemption_disabled (lib/smp_processor_id.c:52)
[  828.395244] hash_accept (crypto/algif_hash.c:185 (discriminator 1))
[  828.395264] SYSC_accept4 (net/socket.c:1476)
[  828.395282] ? sockfd_lookup_light (net/socket.c:1427)
[  828.395319] ? _raw_spin_unlock_bh (kernel/locking/spinlock.c:208)
[  828.395339] ? release_sock (net/core/sock.c:2446)
[  828.395645] ? hash_accept_parent_nokey (crypto/algif_hash.c:380)
[  828.396457] ? map_id_down (kernel/user_namespace.c:201)
[  828.396484] ? SyS_futex (kernel/futex.c:3099)
[  828.396502] ? do_futex (kernel/futex.c:3099)
[  828.396519] ? SyS_socket (net/socket.c:1213)
[  828.396536] ? move_addr_to_kernel (net/socket.c:1213)
[  828.396552] SyS_accept (net/socket.c:1506)
[  828.396569] entry_SYSCALL_64_fastpath (arch/x86/entry/entry_64.S:186)
[  828.396596] ? vm_mmap_pgoff (mm/util.c:325)

Which is this code snippet:

static int hash_accept(struct socket *sock, struct socket *newsock, int flags)
{
        struct sock *sk = sock->sk;
        struct alg_sock *ask = alg_sk(sk);
        struct hash_ctx *ctx = ask->private;
        struct ahash_request *req = &ctx->req;
        char state[crypto_ahash_statesize(crypto_ahash_reqtfm(req))];


Where crypto_ahash_statesize(crypto_ahash_reqtfm(req)) == 0.


Thanks,
Sasha
