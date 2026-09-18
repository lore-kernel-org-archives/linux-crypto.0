Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09BA3093B2;
	Fri, 18 Sep 2026 01:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789695596; cv=none; b=kLSTDSQ+pUXoho4ZP07D+mh5kZJPslflGBFD/W74SDJgmRD08GHyXMJ9vC4Nawwz5MvS3dgcvcjwyN63o3gAGneValNvu7o2dnscyM+RWWKTpMcmLjOCFNZ3GjfcZEjJeXZo+9RFJMUBQDFYFi44GeZoaqKeILZdihq2p2BlqLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789695596; c=relaxed/simple;
	bh=UvW58gsM+QnjmrmwsxUFL2LWG/os7ZcV4Ywp8YYB8yI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n35B6n1YotWa6Fvqy5TBQv+BhpkAYaZpuMUalQfvKQ5V/L2yZ3gCn5mIcvDl+h71g+30Rup6EVBcroUuWJCTiyTel7ldcjVC6fRO5lbH0smi8qtQ3owMPu4hnE5V5Z7MjFmQQ+tzn/0oTQ4fsexqcNgSLOoJqXTsl7J9HJV/gYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZWYezoUF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWYezoUF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 068EA1F000FF;
	Fri, 18 Sep 2026 01:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789695588;
	bh=gM8lZsg0mYS3qU0HtdBPg1nfieBe3LIWvGiRY7u4Bo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZWYezoUFV/4x4XEIe9A39CVjJODM0cLud40YE5OFNK+mmMlZ4PfLGqy+QmmVsAm+8
	 AP6TpIy4T2zSDf5S6gEXwIr0zhLuCK1W6V8vzzzzWcNmfItVnhHDBIBAVA/IN2tR20
	 Sk4eBt6UAIrT/D7jdUPVFWZpIgvjyUvRutgKrh7Y2r3fTfmU8t8Q8W+E61cvGXSblM
	 sEVIOKDsx29kdt8IsHKx8x0//VncBQB1Ytx+Gai1c93IykNPBMU5yEGFCO/PeP22pv
	 OvxmA/mC7yo+ZR+EzHLmnuY8vsR0mIBT1iuEJcj0D3WA4X0btACdXlah4W+EvJB7u0
	 ef/Wcws7MtXoQ==
Date: Fri, 18 Sep 2026 04:39:44 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	io-uring <io-uring@vger.kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>, bpf <bpf@vger.kernel.org>
Subject: Re: [BUG] lookup_user_key() calls commit_creds() (hitting BUG_ON()
 when called from io_uring through AF_ALG setsockopt; BPF probably also
 affected)
Message-ID: <aqyWYIoh-JONhsjN@kernel.org>
References: <CAG48ez0XjVSR=M--UBauTm8sJuc+ZbhKzaPa3a6wrSVHyoKevw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0XjVSR=M--UBauTm8sJuc+ZbhKzaPa3a6wrSVHyoKevw@mail.gmail.com>

On Fri, Sep 11, 2026 at 07:42:50PM +0200, Jann Horn wrote:
> When lookup_user_key() is called on a special keyring ID
> (KEY_SPEC_*_KEYRING), it can end up calling commit_creds() on several
> codepaths:
> 
> lookup_user_key
>   install_thread_keyring [KEY_SPEC_THREAD_KEYRING + KEY_LOOKUP_CREATE]
>     commit_creds
>   install_process_keyring [KEY_SPEC_PROCESS_KEYRING + KEY_LOOKUP_CREATE]
>     commit_creds
>   join_session_keyring [KEY_SPEC_SESSION_KEYRING + KEY_LOOKUP_CREATE]
>     commit_creds
>   install_session_keyring [KEY_SPEC_SESSION_KEYRING]
>     commit_creds
> 
> commit_creds() is only allowed when the process does not have
> overridden credentials. commit_creds() also requires that no
> non-refcounted pointers obtained from current_cred() are live in any
> callers.
> 
> lookup_user_key() is used by lots of keyctl operations, where it can
> make sense to refer to special keyring IDs; but it is also used by
> other subsystems (such as AF_ALG, nvdimm, fscrypt, BPF, ...) to look
> up user-specified key IDs. In that case, special keyring IDs don't
> make sense (because they refer to keyrings, not individual
> cryptographic keys), and calling commit_creds() is unsafe.
> 
> It would be nice if we could ensure that commit_creds() can only be
> called when KEY_LOOKUP_CREATE is set (which is only used for special
> key IDs); maybe we could replace the
> install_session_keyring(user_session) call with something that just
> grabs a reference to the session keyring and returns it?
> 
> I made a reproducer for the lookup_user_key() call in AF_ALG, but I
> think several other callers of lookup_user_key() are probably also
> affected, like bpf_lookup_user_key() and nvdimm_lookup_user_key().
> 
> bpf_lookup_user_key() will probably require separate fixing; it seems
> to be intentionally designed to be able to look up and create special
> key IDs, but is part of the generic_kfunc_set kfunc set, which can
> probably run in some contexts with overridden creds, like in arbitrary
> LSM hooks. That seems inherently broken.
> 
> Reproducer
> ==========
> As an example, when I use io_uring with ->personality to indirectly
> call setsockopt(af_alg_sock, SOL_ALG, ALG_SET_KEY_BY_KEY_SERIAL,
> &KEY_SPEC_SESSION_KEYRING, sizeof(int)), the kernel will go down the
> following call graph.
> 
> sys_io_uring_enter
>   io_submit_sqes
>     io_submit_sqe
>       io_init_req
>         [set REQ_F_CREDS if sqe->personality is set]
>       io_queue_sqe
>         io_issue_sqe
>           __io_issue_sqe
>             override_creds [if REQ_F_CREDS is set and creds differ]
>             io_uring_cmd
>               io_uring_cmd_sock
>                 io_uring_cmd_setsockopt
>                   do_sock_setsockopt
>                     alg_setsockopt
>                       alg_setkey_by_key_serial
>                         lookup_key
>                           lookup_user_key
>                             install_session_keyring
>                               commit_creds
>                                 BUG_ON(task->cred != old)
>             revert_creds
> 
> Running this reproducer:
> 
> #define _GNU_SOURCE
> #include <err.h>
> #include <stdio.h>
> #include <unistd.h>
> #include <sys/mman.h>
> #include <sys/socket.h>
> #include <sys/syscall.h>
> #include <linux/if_alg.h>
> #include <linux/io_uring.h>
> #include <linux/keyctl.h>
> 
> #define SYSCHK(x) ({          \
>   typeof(x) __res = (x);      \
>   if (__res == (typeof(x))-1) \
>     err(1, "SYSCHK(" #x ")"); \
>   __res;                      \
> })
> 
> int main(void) {
>   int alg_sock = SYSCHK(socket(AF_ALG, SOCK_SEQPACKET, 0));
>   struct sockaddr_alg addr = {
>     .salg_family = AF_ALG,
>     .salg_type = "hash",
>     .salg_name = "sha1"
>   };
>   SYSCHK(bind(alg_sock, (struct sockaddr *)&addr, sizeof(addr)));
> 
>   struct io_uring_params params = { .flags = IORING_SETUP_NO_SQARRAY };
>   int uring_fd = SYSCHK(syscall(__NR_io_uring_setup, /*entries=*/4, &params));
> 
>   // let io_uring grab a reference to the current creds
>   int personality = SYSCHK(syscall(__NR_io_uring_register, uring_fd,
> IORING_REGISTER_PERSONALITY, NULL, 0));
>   // change our creds so that the io_uring personality is different
> from current creds
>   SYSCHK(syscall(__NR_keyctl, KEYCTL_GET_KEYRING_ID,
> KEY_SPEC_SESSION_KEYRING, 0, 0, 0));
> 
>   char *ring_region = SYSCHK(mmap(NULL, 0x1000, PROT_READ|PROT_WRITE,
> MAP_SHARED, uring_fd, IORING_OFF_CQ_RING));
>   struct io_uring_sqe *sqes = SYSCHK(mmap(NULL, 0x1000,
> PROT_READ|PROT_WRITE, MAP_SHARED, uring_fd, IORING_OFF_SQES));
> 
>   int key_serial = KEY_SPEC_SESSION_KEYRING;
>   sqes[0] = (struct io_uring_sqe) {
>     .opcode = IORING_OP_URING_CMD,
>     .fd = alg_sock,
>     .personality = personality,
> 
>     /* specific to uring_cmd */
>     .cmd_op = SOCKET_URING_OP_SETSOCKOPT,
>     .optname = ALG_SET_KEY_BY_KEY_SERIAL,
>     .optval = (unsigned long)&key_serial,
>     .optlen = sizeof(key_serial),
>     .level = SOL_ALG,
>   };
>   (*(unsigned int *)(ring_region + params.sq_off.tail))++;
> 
>   int submitted = SYSCHK(syscall(__NR_io_uring_enter, uring_fd,
>                                    /*to_submit=*/1, /*min_complete=*/1,
>                                    /*flags=*/0, /*sig=*/NULL, /*sigsz=*/0));
>   printf("submitted %d and completed\n", submitted);
> }
> 
> 
> I get this splat:
> 
> [  543.190354][  T111] kernel BUG at kernel/cred.c:376!
> [...]
> [  543.196705][  T111] Call Trace:
> [...]
> [  543.197319][  T111]  lookup_user_key+0x261/0xbe0
> [...]
> [  543.197869][  T111]  alg_setkey_by_key_serial+0xbc/0x300
> [  543.198153][  T111]  alg_setsockopt+0x1a2/0x2a0
> [...]
> [  543.198610][  T111]  do_sock_setsockopt+0x103/0x130
> [  543.198863][  T111]  io_uring_cmd_sock+0x257/0x8b0
> [...]
> [  543.199608][  T111]  io_uring_cmd+0x1f3/0x2a0
> [...]
> [  543.200103][  T111]  __io_issue_sqe+0xd8/0x2a0
> [  543.200335][  T111]  io_issue_sqe+0xde/0x8c0
> [...]
> [  543.201100][  T111]  io_submit_sqes+0x7a6/0x1060
> [  543.201380][  T111]  __se_sys_io_uring_enter+0x218/0xf40
> [...]
> [  543.202158][  T111]  __x64_sys_io_uring_enter+0x82/0xa0
> [...]
> [  543.202780][  T111]  x64_sys_call+0x175f/0x2600
> [  543.203086][  T111]  do_syscall_64+0xbe/0x360
> [  543.203348][  T111]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Just got this while going through inbox.

I'll run the reproducer with a test environment and respond properly
later.

BR, Jarkko
