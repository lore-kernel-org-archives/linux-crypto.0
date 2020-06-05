Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6A9C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 16:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B290206DB
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 16:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgFEQRI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 12:17:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57697 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgFEQRH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 12:17:07 -0400
Received: from mail-qk1-f200.google.com ([209.85.222.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <mfo@canonical.com>)
        id 1jhF1j-0001GI-8M
        for linux-crypto@vger.kernel.org; Fri, 05 Jun 2020 16:17:03 +0000
Received: by mail-qk1-f200.google.com with SMTP id h18so8091930qkj.13
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jun 2020 09:17:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=39fAB/TuHegYE0tdf2ZzfPVo6Vbx/jAOSLcGvlkQk2M=;
        b=D6TNAB9x3arVynk4uiUVrhbN7Jt7Nq0uOrREKTlJ3LRl83yHuHdIHe/2kbTL1vsh2D
         QDVlCXtc64zsFmOjYfLVjoF03y96iDxvxXE92+bhqtT+cvR2A2nMf+zC0Cn2Y9tzrofz
         92o058TI6LMHEbni1tadifrCv1l69M7S45hDQkeeoOiDeAoNxVOQJqQavuK3rEyXiiJr
         L7AR62kIv3oDoc3WfnFAAPprXLUg2uKnFXfQ6LAHcoL400lX5wvDNjULYdPxf/guwq5J
         2KTFbWQBxTCYANbNMNa9m1DeYFxrRYYzix++FkoZ55t1vaS6qUgvGv9PKRA7g1G0eJZ6
         Zdfw==
X-Gm-Message-State: AOAM533YECftl7KFBCpIBwbiqB1RW63GoC9QL+aqgdxrxFT1shmf4XPk
        4WzRf5roA7mq2vAL5AbonRVSxMMBmopk4r1fiEp2Ay3Kl1NyZJ369QVNtg1r82kLmUJJ12vGN1K
        bjEKPwP6V5uOoV3e8X6qdnokmWcuXzK6VzoyEDq6xNw==
X-Received: by 2002:ac8:198e:: with SMTP id u14mr11046412qtj.290.1591373821957;
        Fri, 05 Jun 2020 09:17:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiTi7tBZuhEMP/XXCngAxngu0qLwfWdYnxl8MYVmqAyeKJXSWsZwIrVt3HUNi8fSp/Iyzj6w==
X-Received: by 2002:ac8:198e:: with SMTP id u14mr11046375qtj.290.1591373821527;
        Fri, 05 Jun 2020 09:17:01 -0700 (PDT)
Received: from localhost.localdomain ([179.159.56.229])
        by smtp.gmail.com with ESMTPSA id a27sm139393qtc.92.2020.06.05.09.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:17:01 -0700 (PDT)
From:   Mauricio Faria de Oliveira <mfo@canonical.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: af_alg - fix use-after-free in af_alg_accept() due to bh_lock_sock()
Date:   Fri,  5 Jun 2020 13:16:57 -0300
Message-Id: <20200605161657.535043-1-mfo@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes a regression from commit 37f96694cf73 ("crypto: af_alg
 - Use bh_lock_sock in sk_destruct"), which allows the critical regions
of af_alg_accept() and af_alg_release_parent() to run concurrently.

With the "right" timing and ordering of events, release/free the parent
socket can happen while it is still used to accept a child socket, thus
cause an use-after-free error (usually BUG/NULL pointer dereference and
general protection fault).

It mostly happens on the callees security_sk_clone() and release_sock().
The latter indicates the socket was freed elsewhere while still being
used in the critical region / before being released.

Examples:

    BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
    ...
    RIP: 0010:apparmor_sk_clone_security+0x26/0x70
    ...
    Call Trace:
     security_sk_clone+0x33/0x50
     af_alg_accept+0x81/0x1c0 [af_alg]
     alg_accept+0x15/0x20 [af_alg]
     SYSC_accept4+0xff/0x210
     SyS_accept+0x10/0x20
     do_syscall_64+0x73/0x130
     entry_SYSCALL_64_after_hwframe+0x3d/0xa2

    general protection fault: 0000 [#1] SMP PTI
    ...
    RIP: 0010:__release_sock+0x54/0xe0
    ...
    Call Trace:
     release_sock+0x30/0xa0
     af_alg_accept+0x122/0x1c0 [af_alg]
     alg_accept+0x15/0x20 [af_alg]
     SYSC_accept4+0xff/0x210
     SyS_accept+0x10/0x20
     do_syscall_64+0x73/0x130
     entry_SYSCALL_64_after_hwframe+0x3d/0xa2

Root cause:
----------

The problem happens because the patch changed the socket lock operation
from lock_sock() (mutex semantics) to bh_lock_sock() (spinlock only.)

The socket lock combines a spinlock and the 'owned' field so to provide
mutex semantics for lock_sock()/release_sock(), with the spinlock being
held just to modify the 'owned' field; later the spinlock is *released*.

That is, lock_sock() acquires the spinlock, then checks whether 'owned'
is set (i.e., mutex is held). If it's set, release spinlock, and sleep.
If not (i.e., mutex is free), set it, then release spinlock as well.
(and release_sock() clears it later, accordingly.)

Well, this works when only lock/release_sock() are used, as they honor
the 'owned' field. However, bh_lock_sock() does not honor it; just the
spinlock is acquired. (i.e. bh_lock_sock() is NOT enough to coordinate
/synchronize with lock_sock())

This allows for af_alg_accept() to lock_sock() (and believe it is safe
because 'owned' is set/no spinlock needed) AND af_alg_release_parent()
to bh_lock_sock() and succeed, as the spinlock has been released and
it doesn't check for 'owned.'

Now their critical regions are running concurrently, and with "right"
timing and event ordering, the parent socket is released/freed while
in use.

Timing/Events:
-------------

The key point is the (non-atomic) update to parent alg_sock's refcnt,
and use in-register results to sock_put() in af_alg_release_parent().

    af_alg_accept()
    ...
            if (nokey || !ask->refcnt++)
                    sock_hold(sk);
    ...

    af_alg_release_parent()
    ...
    		last = !--ask->refcnt;
    ...
    	if (last)
    		sock_put(sk);
    ...

If the (read-modify-write) updates to ask->refcnt in af_alg_accept()
and af_alg_release_parent() read at the same time (i.e., same value)
the modified value is different for both (+1/-1) and which value is
written to memory (and used for the next read) is undefined (depend
on CPU, cache, NUMA, timing etc.)

If af_alg_release_parent() finds that it decremented that to zero it
calls sock_put(); this decrements the (non-alg) sock's sk_refcnt and
might release/free the sock if it drops to zero.

And if its decremented write does not make it, af_alg_accept() skips
the sock_hold() call to make up for it.. and now the sock->sk_refcnt
value is negatively unbalanced.

If this pattern happens several times, sock->sk_refcnt drops to zero,
and sk_free() will release/free the parent socket, causing the issue.

The problem is reproducible under these timing/events, with parallel
calls to accept()/af_alg_accept() and close()/af_alg_release_parent()
happening on CPU 1 and CPU 2, respectively.
(the * symbol denotes which write to memory made it.)

    CPU 1            CPU 2        ask->refcnt   sk->sk_refcnt
    af_alg_          af_alg_      (in memory)
    accept()         release_
                     parent()         0              1 (after bind())

 Stage 1)

    0++ = 1          (not yet)        1              1
    sock_hold()                                      2

 Stage 2)

    1++ = 2 (*)      --1 = 0          2              2
                     sock_put()                      1
 Stage 3)

    2++ = 3          --2 = 1 (*)      1              1

 Stage 4)

    1++ = 2 (?)      --1 = 0 (?)      ?              1
                     sock_put()                      0 (drop to zero)
                     sk_free()
 Stage 5)

    (BUG/NULL/GPF)

Reproducers:
-----------

The issue is usually reproducible with the Varnish Cache _Plus_ 'crypto'
module [1] which uses the Linux kernel crypto API, under very high load
for several hours.

It is also reproducible with a synthetic test-case that combines a user
space tool to generate parallel calls to af_alg_accept/release_parent()
with a kernel module with kprobes to synchronize both tasks on "right"
instructions (write 'psk->refcnt' to memory) and ensure one does that
after the other (so its local value "wins.")

When either the offending patch is reverted, or this patch is applied,
the issue no longer happens.

Patch:
-----

This patch checks for the 3 possible scenarios af_alg_release_parent()
can be run (task context; BH context w/ owned clear, and w/ ownet set)
and uses the appropriate locking for the socket, scheduling work when
required (i.e. 3rd case, that needs to sleep but cannot in BH context)

In task context, it's OK to lock_sock() (pre-offending patch behavior)
to update psk.

In bottom-halves context, it's not OK (might sleep); use bh_lock_sock()
and check for 'owned' to decide:

If owned is clear (no lock_sock() holding it), it's OK to update psk.

If owned is set (lock_sock() is holding it), it's not OK; so schedule
work (runs in task context) to lock_sock() and update psk.

Testing:
-------

The patch has been tested on a v5.7 based kernel, and runs correctly
for days; previously it usually failed in less than a day. This only
exercises the task context scenario, so synthetic testing was done.

The kprobes module has been tweaked to always set SOCK_RCU_FREE on
sk_destruct() for the test program thus af_alg_release_parent() is
called in bottom halves context.

Then it has been further tweaked to wait or not in af_alg_accept()
before the lock_sock() call; i.e., so that owned is clear or set
when af_alg_release_parent() runs.

Now the 3 scenarios could be exercised, and the process/context
that __af_alg_release_parent() (note these leading underscores:
the new function that actually updates psk->refcnt) is checked
with dump_stack() -- validating the 3 scenarios work correctly:

1) task context

    [  131.653168] CPU: 2 PID: 775 Comm: cryptoops Tainted: G           O      5.7.0.rlzprt #23
    ...
    [  131.663362] RIP: 0010:__af_alg_release_parent+0x20/0x90
    ...
    [  131.675672]  __sk_destruct+0x21/0x150
    [  131.676446]  af_alg_release+0x3b/0x50
    [  131.677218]  __sock_release+0x38/0xa0
    [  131.677982]  sock_close+0xc/0x10
    [  131.678673]  __fput+0xd5/0x240
    [  131.679342]  task_work_run+0x5a/0x90
    [  131.680094]  exit_to_usermode_loop+0x98/0xa0
    [  131.680953]  do_syscall_64+0x113/0x140
    [  131.681725]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

2) bottom halves context w/ owned clear

    [   29.242874] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W  O      5.7.0.rlzprt #23
    ...
    [   29.252933] RIP: 0010:__af_alg_release_parent+0x20/0x90
    ...
    [   29.265542]  <IRQ>
    [   29.266024]  __sk_destruct+0x21/0x150
    [   29.266736]  rcu_core+0x1eb/0x6d0
    [   29.267399]  __do_softirq+0xdb/0x2d8
    [   29.268121]  irq_exit+0x9b/0xa0
    [   29.268758]  smp_apic_timer_interrupt+0x69/0x130
    [   29.269604]  apic_timer_interrupt+0xf/0x20
    [   29.270379]  </IRQ>

3) bottom halves context w/ owned set

    [   30.588811] CPU: 1 PID: 101 Comm: kworker/1:1 Tainted: G        W  O      5.7.0.rlzprt #23
    ...
    [   30.592195] Workqueue: events __af_alg_release_parent_work
    ...
    [   30.601682] RIP: 0010:__af_alg_release_parent+0x20/0x90
    ...
    [   30.614915]  __af_alg_release_parent_work+0x1e/0x30
    [   30.615717]  process_one_work+0x1d3/0x380
    [   30.616393]  worker_thread+0x45/0x3c0
    [   30.617279]  kthread+0xf6/0x130
    [   30.617847]  ? process_one_work+0x380/0x380
    [   30.618574]  ? kthread_park+0x80/0x80
    [   30.619230]  ret_from_fork+0x35/0x40

[1] https://docs.varnish-software.com/varnish-cache-plus/vmods/total-encryption/

Fixes: 37f96694cf73 ("crypto: af_alg - Use bh_lock_sock in sk_destruct")
Reported-by: Brian Moyles <bmoyles@netflix.com>
Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
---
 crypto/af_alg.c | 117 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 105 insertions(+), 12 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index b1cd3535c525..eea3993a7126 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -125,25 +125,118 @@ int af_alg_release(struct socket *sock)
 }
 EXPORT_SYMBOL_GPL(af_alg_release);
 
+void __af_alg_release_parent(struct sock *psk, unsigned int ask_refcnt,
+			     unsigned int ask_nokey_refcnt)
+{
+	struct alg_sock *pask = alg_sk(psk);
+	bool last = ask_nokey_refcnt && !ask_refcnt;
+
+	/*
+	 * The parent sock lock is held on entry (by callers),
+	 * and released on exit (by us), according to context.
+	 * (Particularly for BH context & sock not owned case.)
+	 */
+
+	pask->nokey_refcnt -= ask_nokey_refcnt;
+	if (!last)
+		last = !--pask->refcnt;
+
+	if (in_task()) {
+		release_sock(psk);
+	} else {
+		bh_unlock_sock(psk);
+		local_bh_enable();
+	}
+
+	if (last)
+		sock_put(psk);
+}
+
+struct af_alg_release_parent_work {
+	struct work_struct work;
+	struct sock *psk;
+	unsigned int ask_refcnt;
+	unsigned int ask_nokey_refcnt;
+};
+
+void __af_alg_release_parent_work(struct work_struct *_work)
+{
+	struct af_alg_release_parent_work *work =
+		(struct af_alg_release_parent_work *) _work;
+
+	lock_sock(work->psk);
+	__af_alg_release_parent(work->psk, work->ask_refcnt,
+				work->ask_nokey_refcnt);
+	kfree(work);
+}
+
 void af_alg_release_parent(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	unsigned int nokey = ask->nokey_refcnt;
-	bool last = nokey && !ask->refcnt;
-
-	sk = ask->parent;
-	ask = alg_sk(sk);
+	struct sock *psk = ask->parent;
+	struct af_alg_release_parent_work *work;
+
+	/*
+	 * This function might race with af_alg_accept() on the parent sock.
+	 *
+	 * That uses lock_sock() to set sk->sk_lock.owned (might sleep) and
+	 * then *releases* the spinlock, relying on owned to sync w/ others;
+	 * later it uses release_sock() to clear it (i.e., mutex semantics.)
+	 *
+	 * So, the sk->sk_lock spinlock alone (e.g., bh_lock_sock()) is not
+	 * sufficient for synchronizing with lock_sock() in af_alg_accept();
+	 * we do need sk->sk_lock.owned to be verified and sleep while set.
+	 *
+	 * This function might be called in non-task/bottom halves context,
+	 * which cannot sleep (i.e., call lock_sock()) so only if owned is
+	 * clear we can change the parent sock (while we hold the spinlock)
+	 * but if it is set, schedule work to do so (runs in task context.)
+	 */
+
+	/* Task context: can sleep; just release parent */
+	if (in_task()) {
+		lock_sock(psk);
+		goto release;
+	}
 
+	/* BH context: cannot sleep; only release parent if sock is not owned */
 	local_bh_disable();
-	bh_lock_sock(sk);
-	ask->nokey_refcnt -= nokey;
-	if (!last)
-		last = !--ask->refcnt;
-	bh_unlock_sock(sk);
+	bh_lock_sock(psk);
+
+	if (!sock_owned_by_user(psk)) {
+		/* No need to set sock owned as we're done when unlocking it */
+		goto release;
+	}
+
+	/* BH context: cannot sleep but have to (sock is owned); schedule work */
+
+	/* Release lock before memory allocation */
+	bh_unlock_sock(psk);
 	local_bh_enable();
 
-	if (last)
-		sock_put(sk);
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work) {
+		/* Cannot schedule work; log and take the risk (racy but rare) */
+		local_bh_disable();
+		bh_lock_sock(psk);
+
+		/* Check if still owned before the warning (if not, it's safe) */
+		if (sock_owned_by_user(psk))
+			pr_warn_ratelimited("af_alg: parent sock release under race");
+
+		goto release;
+	}
+
+	/* Copy the values from child socket; cannot access it after we return */
+	work->psk = psk;
+	work->ask_refcnt = ask->refcnt;
+	work->ask_nokey_refcnt = ask->nokey_refcnt;
+	INIT_WORK(&work->work, __af_alg_release_parent_work);
+	schedule_work(&work->work);
+	return;
+
+release:
+	__af_alg_release_parent(psk, ask->refcnt, ask->nokey_refcnt);
 }
 EXPORT_SYMBOL_GPL(af_alg_release_parent);
 
-- 
2.25.1

