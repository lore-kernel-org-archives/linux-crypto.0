Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA842205E2D
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 09:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080397; cv=none; b=b+Mp9gOBunFS+tMv4r8SOSNrgiycImJOJjtUwCb7+TgbdV+JoGDkFv3OPseIzxL/4d2RJQUBUfvTqw7trDv5gBFo62NPW9GEBpE2SgToR04AyQi/kCxPDGJzcWLPNV5VGpvRqAahNzo+nb+ldlWEw1zjdqI+FSM8hihiVitOdeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080397; c=relaxed/simple;
	bh=b0CdiKYI8plcUd/5o7nrlhwn2YMDkb9s4S0Fm28UjnM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lTV+myThxXNAVukHgHosTpC40Pv3P0olnfSkvYNzH9/icxW0/9+tIqz0im9qnDsX18SspvoVMwf5rXKooijY4Is4ivbqSJ5nTA3WhoL0nnqrQjwDPXlK9rp9XM3VgD3aSNjTDl7GTYtiXotxQQqnII0d+92uwPm03kJz3F/uSnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--elver.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=heQ5cuwt; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--elver.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="heQ5cuwt"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-abf7171eaf2so230972966b.1
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 01:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741080393; x=1741685193; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iDk2VwqwOTTMZfSkXTf6seWDq1RAdZgqLjXPZ94M0QA=;
        b=heQ5cuwtqNsaCbDQI3Bp69jGS6Sl55DcabORQxz3IFOlgNbGqROyexhO8EQYA6K11k
         ByLsbsNm10ys7wRMTWvw8EV3M42znUbPpMAwZB1Jl8dYOlPAeMuQaWTWgCGO+XLMYg+t
         Oe1KoOF39wGt1B3tX8ZDxuFaTjb35wDIAUtxRmS4e5PPRZJKluZHrjOD3zoWKcVQWTUo
         u0pMtXLUkww+kGiD3jc0aAMpZ95CkRYZWFpqoeKaLihqEXHKO1XFNXnWUV9bjbLW+Wcq
         yRf+AiE4MIcps+cPgek24bj3HfOtRbICnBdU9uMy/x8Uss+gz3S+Z4B3ellw6JB9U/Jg
         ZvMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080393; x=1741685193;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iDk2VwqwOTTMZfSkXTf6seWDq1RAdZgqLjXPZ94M0QA=;
        b=LKwyLhidKflGHTLPM5sMiR8nQ/TrJAZ8pXlxz79JQIzTcBBLxx+rNmwfcKNGwUvO07
         lFu0baaQ+n9C99UnmUN8Sc7HbQ4Gvf/eHwrUGJ3srRsGUMPpHFBnDWa3KccmVASRGC4d
         SDVIZQ3OXtRupLJp+7NormGCrW18cvxD0rSFD4GbAYG/NQExqZ73yPXZXIrsI3aBrIyJ
         XXLLOi+OoTTrMUyr4ABPzfnJEy9L4WEqh3AvFtUTHCD1Ts89FYN+KS8eaQxzU88e6mkO
         RjKnY4s6FGqjlO3LNajVe3CVZkreAN0xDAWdUilU96YxheWjmN/9mMAM6+DAoUEwvjHz
         kcOA==
X-Forwarded-Encrypted: i=1; AJvYcCWPOP0X9DRul1cJ25G+llKaoTakPX/27Kne5A+F9YW38U/jRddwtmyDIjXIYAvEsPogLVz/t4tCTQOfx3o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgJVWfTrcZpkDDMvULKEXy04A+AjNGktQfiKhMMsjIBxgE6Mvn
	mckDzFJ7rt7iTd8oAcxNKN08GN70ulRtv1jrUB7eoS7SxDSn/IdWtGwVUqF499YrtpaYrBivPg=
	=
X-Google-Smtp-Source: AGHT+IF8v9zLKhdVdDKTCEZYG8DbcGXKqxfAOcuUpH2RTtDLQJOOCxvLbiKCCrE4y5yhtpae3MqEZYbpjQ==
X-Received: from ejcsn10.prod.google.com ([2002:a17:906:628a:b0:ac1:fb2a:4a65])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3e0f:b0:abf:718f:ef27
 with SMTP id a640c23a62f3a-abf718ff14amr868693766b.1.1741080393090; Tue, 04
 Mar 2025 01:26:33 -0800 (PST)
Date: Tue,  4 Mar 2025 10:21:30 +0100
In-Reply-To: <20250304092417.2873893-1-elver@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304092417.2873893-1-elver@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304092417.2873893-32-elver@google.com>
Subject: [PATCH v2 31/34] drivers/tty: Enable capability analysis for core files
From: Marco Elver <elver@google.com>
To: elver@google.com
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@kernel.org>, 
	Jann Horn <jannh@google.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Joel Fernandes <joel@joelfernandes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, 
	Thomas Gleixner <tglx@linutronix.de>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	Will Deacon <will@kernel.org>, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-serial@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Enable capability analysis for drivers/tty/*.

This demonstrates a larger conversion to use Clang's capability
analysis. The benefit is additional static checking of locking rules,
along with better documentation.

Signed-off-by: Marco Elver <elver@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
---
v2:
* New patch.
---
 drivers/tty/Makefile      |  3 +++
 drivers/tty/n_tty.c       | 16 ++++++++++++++++
 drivers/tty/pty.c         |  1 +
 drivers/tty/sysrq.c       |  1 +
 drivers/tty/tty.h         |  8 ++++----
 drivers/tty/tty_buffer.c  |  8 +++-----
 drivers/tty/tty_io.c      | 12 +++++++++---
 drivers/tty/tty_ioctl.c   |  2 +-
 drivers/tty/tty_ldisc.c   | 35 ++++++++++++++++++++++++++++++++---
 drivers/tty/tty_ldsem.c   |  2 ++
 drivers/tty/tty_mutex.c   |  4 ++++
 drivers/tty/tty_port.c    |  2 ++
 include/linux/tty.h       | 14 +++++++-------
 include/linux/tty_flip.h  |  4 ++--
 include/linux/tty_ldisc.h | 19 ++++++++++---------
 15 files changed, 97 insertions(+), 34 deletions(-)

diff --git a/drivers/tty/Makefile b/drivers/tty/Makefile
index 07aca5184a55..35e1a62cbe16 100644
--- a/drivers/tty/Makefile
+++ b/drivers/tty/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CAPABILITY_ANALYSIS := y
+
 obj-$(CONFIG_TTY)		+= tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o \
 				   tty_buffer.o tty_port.o tty_mutex.o \
 				   tty_ldsem.o tty_baudrate.o tty_jobctrl.o \
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 5e9ca4376d68..45925fc5a8fd 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1088,6 +1088,7 @@ static void __isig(int sig, struct tty_struct *tty)
  * Locking: %ctrl.lock
  */
 static void isig(int sig, struct tty_struct *tty)
+	__must_hold_shared(&tty->termios_rwsem)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 
@@ -1135,6 +1136,7 @@ static void isig(int sig, struct tty_struct *tty)
  * Note: may get exclusive %termios_rwsem if flushing input buffer
  */
 static void n_tty_receive_break(struct tty_struct *tty)
+	__must_hold_shared(&tty->termios_rwsem)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 
@@ -1204,6 +1206,7 @@ static void n_tty_receive_parity_error(const struct tty_struct *tty,
 
 static void
 n_tty_receive_signal_char(struct tty_struct *tty, int signal, u8 c)
+	__must_hold_shared(&tty->termios_rwsem)
 {
 	isig(signal, tty);
 	if (I_IXON(tty))
@@ -1353,6 +1356,7 @@ static bool n_tty_receive_char_canon(struct tty_struct *tty, u8 c)
 
 static void n_tty_receive_char_special(struct tty_struct *tty, u8 c,
 				       bool lookahead_done)
+	__must_hold_shared(&tty->termios_rwsem)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 
@@ -1463,6 +1467,7 @@ static void n_tty_receive_char_closing(struct tty_struct *tty, u8 c,
 
 static void
 n_tty_receive_char_flagged(struct tty_struct *tty, u8 c, u8 flag)
+	__must_hold_shared(&tty->termios_rwsem)
 {
 	switch (flag) {
 	case TTY_BREAK:
@@ -1483,6 +1488,7 @@ n_tty_receive_char_flagged(struct tty_struct *tty, u8 c, u8 flag)
 
 static void
 n_tty_receive_char_lnext(struct tty_struct *tty, u8 c, u8 flag)
+	__must_hold_shared(&tty->termios_rwsem)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 
@@ -1540,6 +1546,7 @@ n_tty_receive_buf_real_raw(const struct tty_struct *tty, const u8 *cp,
 static void
 n_tty_receive_buf_raw(struct tty_struct *tty, const u8 *cp, const u8 *fp,
 		      size_t count)
+	__must_hold_shared(&tty->termios_rwsem)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	u8 flag = TTY_NORMAL;
@@ -1571,6 +1578,7 @@ n_tty_receive_buf_closing(struct tty_struct *tty, const u8 *cp, const u8 *fp,
 static void n_tty_receive_buf_standard(struct tty_struct *tty, const u8 *cp,
 				       const u8 *fp, size_t count,
 				       bool lookahead_done)
+	__must_hold_shared(&tty->termios_rwsem)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	u8 flag = TTY_NORMAL;
@@ -1609,6 +1617,7 @@ static void n_tty_receive_buf_standard(struct tty_struct *tty, const u8 *cp,
 
 static void __receive_buf(struct tty_struct *tty, const u8 *cp, const u8 *fp,
 			  size_t count)
+	__must_hold_shared(&tty->termios_rwsem)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	bool preops = I_ISTRIP(tty) || (I_IUCLC(tty) && L_IEXTEN(tty));
@@ -2188,6 +2197,10 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file, u8 *kbuf,
 				return kb - kbuf;
 		}
 
+		/* Adopted locks from prior call. */
+		__acquire(&ldata->atomic_read_lock);
+		__acquire_shared(&tty->termios_rwsem);
+
 		/* No more data - release locks and stop retries */
 		n_tty_kick_worker(tty);
 		n_tty_check_unthrottle(tty);
@@ -2305,6 +2318,9 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file, u8 *kbuf,
 more_to_be_read:
 				remove_wait_queue(&tty->read_wait, &wait);
 				*cookie = cookie;
+				/* Hand-off locks to retry with cookie set. */
+				__release_shared(&tty->termios_rwsem);
+				__release(&ldata->atomic_read_lock);
 				return kb - kbuf;
 			}
 		}
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 8bb1a01fef2a..8d4eb0f4c84c 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -824,6 +824,7 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 	tty = tty_init_dev(ptm_driver, index);
 	/* The tty returned here is locked so we can safely
 	   drop the mutex */
+	lockdep_assert_held(&tty->legacy_mutex);
 	mutex_unlock(&tty_mutex);
 
 	retval = PTR_ERR(tty);
diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index f85ce02e4725..82dfa964c965 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -149,6 +149,7 @@ static const struct sysrq_key_op sysrq_unraw_op = {
 static void sysrq_handle_crash(u8 key)
 {
 	/* release the RCU read lock before crashing */
+	lockdep_assert_in_rcu_read_lock();
 	rcu_read_unlock();
 
 	panic("sysrq triggered crash\n");
diff --git a/drivers/tty/tty.h b/drivers/tty/tty.h
index 93cf5ef1e857..1a3c2f663b28 100644
--- a/drivers/tty/tty.h
+++ b/drivers/tty/tty.h
@@ -60,15 +60,15 @@ static inline void tty_set_flow_change(struct tty_struct *tty,
 	smp_mb();
 }
 
-int tty_ldisc_lock(struct tty_struct *tty, unsigned long timeout);
-void tty_ldisc_unlock(struct tty_struct *tty);
+int tty_ldisc_lock(struct tty_struct *tty, unsigned long timeout) __cond_acquires(0, &tty->ldisc_sem);
+void tty_ldisc_unlock(struct tty_struct *tty) __releases(&tty->ldisc_sem);
 
 int __tty_check_change(struct tty_struct *tty, int sig);
 int tty_check_change(struct tty_struct *tty);
 void __stop_tty(struct tty_struct *tty);
 void __start_tty(struct tty_struct *tty);
-void tty_write_unlock(struct tty_struct *tty);
-int tty_write_lock(struct tty_struct *tty, bool ndelay);
+void tty_write_unlock(struct tty_struct *tty) __releases(&tty->atomic_write_lock);
+int tty_write_lock(struct tty_struct *tty, bool ndelay) __cond_acquires(0, &tty->atomic_write_lock);
 void tty_vhangup_session(struct tty_struct *tty);
 void tty_open_proc_set_tty(struct file *filp, struct tty_struct *tty);
 int tty_signal_session_leader(struct tty_struct *tty, int exit_session);
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 79f0ff94ce00..dcc56537290f 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -52,10 +52,8 @@
  */
 void tty_buffer_lock_exclusive(struct tty_port *port)
 {
-	struct tty_bufhead *buf = &port->buf;
-
-	atomic_inc(&buf->priority);
-	mutex_lock(&buf->lock);
+	atomic_inc(&port->buf.priority);
+	mutex_lock(&port->buf.lock);
 }
 EXPORT_SYMBOL_GPL(tty_buffer_lock_exclusive);
 
@@ -73,7 +71,7 @@ void tty_buffer_unlock_exclusive(struct tty_port *port)
 	bool restart = buf->head->commit != buf->head->read;
 
 	atomic_dec(&buf->priority);
-	mutex_unlock(&buf->lock);
+	mutex_unlock(&port->buf.lock);
 
 	if (restart)
 		queue_work(system_unbound_wq, &buf->work);
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 449dbd216460..1eb3794fde4b 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -167,6 +167,7 @@ static void release_tty(struct tty_struct *tty, int idx);
  * Locking: none. Must be called after tty is definitely unused
  */
 static void free_tty_struct(struct tty_struct *tty)
+	__capability_unsafe(/* destructor */)
 {
 	tty_ldisc_deinit(tty);
 	put_device(tty->dev);
@@ -965,7 +966,7 @@ static ssize_t iterate_tty_write(struct tty_ldisc *ld, struct tty_struct *tty,
 	ssize_t ret, written = 0;
 
 	ret = tty_write_lock(tty, file->f_flags & O_NDELAY);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	/*
@@ -1154,7 +1155,7 @@ int tty_send_xchar(struct tty_struct *tty, u8 ch)
 		return 0;
 	}
 
-	if (tty_write_lock(tty, false) < 0)
+	if (tty_write_lock(tty, false))
 		return -ERESTARTSYS;
 
 	down_read(&tty->termios_rwsem);
@@ -1391,6 +1392,7 @@ static int tty_reopen(struct tty_struct *tty)
  * Return: new tty structure
  */
 struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx)
+	__capability_unsafe(/* returns with locked tty */)
 {
 	struct tty_struct *tty;
 	int retval;
@@ -1874,6 +1876,7 @@ int tty_release(struct inode *inode, struct file *filp)
  * will not work then. It expects inodes to be from devpts FS.
  */
 static struct tty_struct *tty_open_current_tty(dev_t device, struct file *filp)
+	__capability_unsafe(/* returns with locked tty */)
 {
 	struct tty_struct *tty;
 	int retval;
@@ -2037,6 +2040,7 @@ EXPORT_SYMBOL_GPL(tty_kopen_shared);
  */
 static struct tty_struct *tty_open_by_driver(dev_t device,
 					     struct file *filp)
+	__capability_unsafe(/* returns with locked tty */)
 {
 	struct tty_struct *tty;
 	struct tty_driver *driver = NULL;
@@ -2137,6 +2141,8 @@ static int tty_open(struct inode *inode, struct file *filp)
 		goto retry_open;
 	}
 
+	lockdep_assert_held(&tty->legacy_mutex);
+
 	tty_add_file(tty, filp);
 
 	check_tty_count(tty, __func__);
@@ -2486,7 +2492,7 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
 		return tty->ops->break_ctl(tty, duration);
 
 	/* Do the work ourselves */
-	if (tty_write_lock(tty, false) < 0)
+	if (tty_write_lock(tty, false))
 		return -EINTR;
 
 	retval = tty->ops->break_ctl(tty, -1);
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 85de90eebc7b..a7ae6cbf3450 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -489,7 +489,7 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 		if (retval < 0)
 			return retval;
 
-		if (tty_write_lock(tty, false) < 0)
+		if (tty_write_lock(tty, false))
 			goto retry_write_wait;
 
 		/* Racing writer? */
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index d80e9d4c974b..e07a5980604e 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -237,6 +237,7 @@ const struct seq_operations tty_ldiscs_seq_ops = {
  * to wait for any ldisc lifetime events to finish.
  */
 struct tty_ldisc *tty_ldisc_ref_wait(struct tty_struct *tty)
+	__cond_acquires_shared(nonnull, &tty->ldisc_sem)
 {
 	struct tty_ldisc *ld;
 
@@ -257,6 +258,7 @@ EXPORT_SYMBOL_GPL(tty_ldisc_ref_wait);
  * and timer functions.
  */
 struct tty_ldisc *tty_ldisc_ref(struct tty_struct *tty)
+	__cond_acquires_shared(nonnull, &tty->ldisc_sem)
 {
 	struct tty_ldisc *ld = NULL;
 
@@ -277,26 +279,43 @@ EXPORT_SYMBOL_GPL(tty_ldisc_ref);
  * in IRQ context.
  */
 void tty_ldisc_deref(struct tty_ldisc *ld)
+	__releases_shared(&ld->tty->ldisc_sem)
 {
 	ldsem_up_read(&ld->tty->ldisc_sem);
 }
 EXPORT_SYMBOL_GPL(tty_ldisc_deref);
 
+/*
+ * Note: Capability analysis does not like asymmetric interfaces (above types
+ * for ref and deref are tty_struct and tty_ldisc respectively -- which are
+ * dependent, but the compiler cannot figure that out); in this case, work
+ * around that with this helper which takes an unused @tty argument but tells
+ * the analysis which lock is released.
+ */
+static inline void __tty_ldisc_deref(struct tty_struct *tty, struct tty_ldisc *ld)
+	__releases_shared(&tty->ldisc_sem)
+	__capability_unsafe(/* matches released with tty_ldisc_ref() */)
+{
+	tty_ldisc_deref(ld);
+}
 
 static inline int
 __tty_ldisc_lock(struct tty_struct *tty, unsigned long timeout)
+	__cond_acquires(true, &tty->ldisc_sem)
 {
 	return ldsem_down_write(&tty->ldisc_sem, timeout);
 }
 
 static inline int
 __tty_ldisc_lock_nested(struct tty_struct *tty, unsigned long timeout)
+	__cond_acquires(true, &tty->ldisc_sem)
 {
 	return ldsem_down_write_nested(&tty->ldisc_sem,
 				       LDISC_SEM_OTHER, timeout);
 }
 
 static inline void __tty_ldisc_unlock(struct tty_struct *tty)
+	__releases(&tty->ldisc_sem)
 {
 	ldsem_up_write(&tty->ldisc_sem);
 }
@@ -328,6 +347,8 @@ void tty_ldisc_unlock(struct tty_struct *tty)
 static int
 tty_ldisc_lock_pair_timeout(struct tty_struct *tty, struct tty_struct *tty2,
 			    unsigned long timeout)
+	__cond_acquires(0, &tty->ldisc_sem)
+	__cond_acquires(0, &tty2->ldisc_sem)
 {
 	int ret;
 
@@ -362,16 +383,23 @@ tty_ldisc_lock_pair_timeout(struct tty_struct *tty, struct tty_struct *tty2,
 }
 
 static void tty_ldisc_lock_pair(struct tty_struct *tty, struct tty_struct *tty2)
+	__acquires(&tty->ldisc_sem)
+	__acquires(&tty2->ldisc_sem)
+	__capability_unsafe(/* MAX_SCHEDULE_TIMEOUT ensures acquisition */)
 {
 	tty_ldisc_lock_pair_timeout(tty, tty2, MAX_SCHEDULE_TIMEOUT);
 }
 
 static void tty_ldisc_unlock_pair(struct tty_struct *tty,
 				  struct tty_struct *tty2)
+	__releases(&tty->ldisc_sem)
+	__releases(&tty2->ldisc_sem)
 {
 	__tty_ldisc_unlock(tty);
 	if (tty2)
 		__tty_ldisc_unlock(tty2);
+	else
+		__release(&tty2->ldisc_sem);
 }
 
 /**
@@ -387,7 +415,7 @@ void tty_ldisc_flush(struct tty_struct *tty)
 
 	tty_buffer_flush(tty, ld);
 	if (ld)
-		tty_ldisc_deref(ld);
+		__tty_ldisc_deref(tty, ld);
 }
 EXPORT_SYMBOL_GPL(tty_ldisc_flush);
 
@@ -694,7 +722,7 @@ void tty_ldisc_hangup(struct tty_struct *tty, bool reinit)
 	tty_ldisc_debug(tty, "%p: hangup\n", tty->ldisc);
 
 	ld = tty_ldisc_ref(tty);
-	if (ld != NULL) {
+	if (ld) {
 		if (ld->ops->flush_buffer)
 			ld->ops->flush_buffer(tty);
 		tty_driver_flush_buffer(tty);
@@ -703,7 +731,7 @@ void tty_ldisc_hangup(struct tty_struct *tty, bool reinit)
 			ld->ops->write_wakeup(tty);
 		if (ld->ops->hangup)
 			ld->ops->hangup(tty);
-		tty_ldisc_deref(ld);
+		__tty_ldisc_deref(tty, ld);
 	}
 
 	wake_up_interruptible_poll(&tty->write_wait, EPOLLOUT);
@@ -716,6 +744,7 @@ void tty_ldisc_hangup(struct tty_struct *tty, bool reinit)
 	 * Avoid racing set_ldisc or tty_ldisc_release
 	 */
 	tty_ldisc_lock(tty, MAX_SCHEDULE_TIMEOUT);
+	lockdep_assert_held_write(&tty->ldisc_sem);
 
 	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS)
 		tty_reset_termios(tty);
diff --git a/drivers/tty/tty_ldsem.c b/drivers/tty/tty_ldsem.c
index 3be428c16260..26d924bb5a46 100644
--- a/drivers/tty/tty_ldsem.c
+++ b/drivers/tty/tty_ldsem.c
@@ -390,6 +390,7 @@ void ldsem_up_read(struct ld_semaphore *sem)
 {
 	long count;
 
+	__release_shared(sem);
 	rwsem_release(&sem->dep_map, _RET_IP_);
 
 	count = atomic_long_add_return(-LDSEM_READ_BIAS, &sem->count);
@@ -404,6 +405,7 @@ void ldsem_up_write(struct ld_semaphore *sem)
 {
 	long count;
 
+	__release(sem);
 	rwsem_release(&sem->dep_map, _RET_IP_);
 
 	count = atomic_long_add_return(-LDSEM_WRITE_BIAS, &sem->count);
diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
index 784e46a0a3b1..e5576fd6f5a4 100644
--- a/drivers/tty/tty_mutex.c
+++ b/drivers/tty/tty_mutex.c
@@ -41,12 +41,16 @@ void tty_lock_slave(struct tty_struct *tty)
 {
 	if (tty && tty != tty->link)
 		tty_lock(tty);
+	else
+		__acquire(&tty->legacy_mutex);
 }
 
 void tty_unlock_slave(struct tty_struct *tty)
 {
 	if (tty && tty != tty->link)
 		tty_unlock(tty);
+	else
+		__release(&tty->legacy_mutex);
 }
 
 void tty_set_lock_subclass(struct tty_struct *tty)
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 14cca33d2269..bcb65a26a6bf 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -509,6 +509,7 @@ EXPORT_SYMBOL(tty_port_lower_dtr_rts);
  */
 int tty_port_block_til_ready(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp)
+	__must_hold(&tty->legacy_mutex)
 {
 	int do_clocal = 0, retval;
 	unsigned long flags;
@@ -764,6 +765,7 @@ EXPORT_SYMBOL_GPL(tty_port_install);
  */
 int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 							struct file *filp)
+	__must_hold(&tty->legacy_mutex)
 {
 	spin_lock_irq(&port->lock);
 	++port->count;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 2372f9357240..ee1ba62fc398 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -234,8 +234,8 @@ struct tty_struct {
 	void *disc_data;
 	void *driver_data;
 	spinlock_t files_lock;
-	int write_cnt;
-	u8 *write_buf;
+	int write_cnt __guarded_by(&atomic_write_lock);
+	u8 *write_buf __guarded_by(&atomic_write_lock);
 
 	struct list_head tty_files;
 
@@ -500,11 +500,11 @@ long vt_compat_ioctl(struct tty_struct *tty, unsigned int cmd,
 
 /* tty_mutex.c */
 /* functions for preparation of BKL removal */
-void tty_lock(struct tty_struct *tty);
-int  tty_lock_interruptible(struct tty_struct *tty);
-void tty_unlock(struct tty_struct *tty);
-void tty_lock_slave(struct tty_struct *tty);
-void tty_unlock_slave(struct tty_struct *tty);
+void tty_lock(struct tty_struct *tty) __acquires(&tty->legacy_mutex);
+int  tty_lock_interruptible(struct tty_struct *tty) __cond_acquires(0, &tty->legacy_mutex);
+void tty_unlock(struct tty_struct *tty) __releases(&tty->legacy_mutex);
+void tty_lock_slave(struct tty_struct *tty) __acquires(&tty->legacy_mutex);
+void tty_unlock_slave(struct tty_struct *tty) __releases(&tty->legacy_mutex);
 void tty_set_lock_subclass(struct tty_struct *tty);
 
 #endif
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index af4fce98f64e..2214714059f8 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -86,7 +86,7 @@ static inline size_t tty_insert_flip_string(struct tty_port *port,
 size_t tty_ldisc_receive_buf(struct tty_ldisc *ld, const u8 *p, const u8 *f,
 			     size_t count);
 
-void tty_buffer_lock_exclusive(struct tty_port *port);
-void tty_buffer_unlock_exclusive(struct tty_port *port);
+void tty_buffer_lock_exclusive(struct tty_port *port) __acquires(&port->buf.lock);
+void tty_buffer_unlock_exclusive(struct tty_port *port) __releases(&port->buf.lock);
 
 #endif /* _LINUX_TTY_FLIP_H */
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index af01e89074b2..d834cf115d52 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -14,7 +14,7 @@ struct tty_struct;
 /*
  * the semaphore definition
  */
-struct ld_semaphore {
+struct_with_capability(ld_semaphore) {
 	atomic_long_t		count;
 	raw_spinlock_t		wait_lock;
 	unsigned int		wait_readers;
@@ -33,21 +33,22 @@ do {								\
 	static struct lock_class_key __key;			\
 								\
 	__init_ldsem((sem), #sem, &__key);			\
+	__assert_cap(sem);					\
 } while (0)
 
 
-int ldsem_down_read(struct ld_semaphore *sem, long timeout);
-int ldsem_down_read_trylock(struct ld_semaphore *sem);
-int ldsem_down_write(struct ld_semaphore *sem, long timeout);
-int ldsem_down_write_trylock(struct ld_semaphore *sem);
-void ldsem_up_read(struct ld_semaphore *sem);
-void ldsem_up_write(struct ld_semaphore *sem);
+int ldsem_down_read(struct ld_semaphore *sem, long timeout) __cond_acquires_shared(true, sem);
+int ldsem_down_read_trylock(struct ld_semaphore *sem) __cond_acquires_shared(true, sem);
+int ldsem_down_write(struct ld_semaphore *sem, long timeout) __cond_acquires(true, sem);
+int ldsem_down_write_trylock(struct ld_semaphore *sem) __cond_acquires(true, sem);
+void ldsem_up_read(struct ld_semaphore *sem) __releases_shared(sem);
+void ldsem_up_write(struct ld_semaphore *sem) __releases(sem);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 int ldsem_down_read_nested(struct ld_semaphore *sem, int subclass,
-		long timeout);
+		long timeout) __cond_acquires_shared(true, sem);
 int ldsem_down_write_nested(struct ld_semaphore *sem, int subclass,
-		long timeout);
+		long timeout) __cond_acquires(true, sem);
 #else
 # define ldsem_down_read_nested(sem, subclass, timeout)		\
 		ldsem_down_read(sem, timeout)
-- 
2.48.1.711.g2feabab25a-goog

