Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64EB20010A;
	Mon, 28 Sep 2026 14:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790605776; cv=none; b=Kt2ZBOsTHB8EDP2OlNLRU3HMv9aBdKfd9IoipXQMZLfGqxMqSQ3bn1KsdJG6NA9kTX480biYCcOa1ySKllXy42HhA6rqXsxW27+FE1BALuMVCK6hGZg/LO/8V2Qh9DgoxeRhgwN6dpQFL/eZNAr7hn5fvhZ887wDe8GSyXsbGi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790605776; c=relaxed/simple;
	bh=IyMAtB9cbjsiIH/TGlu9jcnjk9wBC5bT3ub/aG6oRTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L9h3kxCnwOtmGWXjWKOTj0uqRAbPHE1lbNU59NMiLHTuP7KYdyrLoleVUkUgX72G6NqMTKVtav0FP86ecoqNSnsTaY7udobq7b+lhjwXs7clpGVP0tQXf2LjfMySBDUzy5boXWMmuSGzktKc2BiDXAiSwdVSpg/xSF8k/VWDwwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cllssm3L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cllssm3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943EE1F00893;
	Mon, 28 Sep 2026 14:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790605775;
	bh=hENkM5jtUQlxWUVRVmB2Y3HGiTekSFtmW2vKEK3DXWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cllssm3LYvSI8akntOXuWzEnLDlf+FJFyRcfB2c1OMLaPesPIIxKYPuXVNS/5EOh8
	 YOtumZ+eJ1+ztycOb0yLkK324ss9N4cbSE1lAxabBLjSCK+0UWaptAwURo2LKcaTtB
	 0sVF03gnmjkGEnli62PjGD/xwxSaVqMmZGvJhE+zwW5EDs7PqCB2a8GXK6TLyXeZys
	 7/ydXGqnFJgpUb19ZUIbZm2UCuuKoeT0IVdkQZpKB2pISoOrGWLLAxHbagBtFwR9to
	 HT8V+dsWBp0EY/Q1lG+NsY+GHeQCl3rBCpNcQBk99+qJ4CUVrBFA1nvD3ZNoqzMVsW
	 O1zHcMolz7c9g==
From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
To: "Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [RFC PATCH 1/3] rcu/tasks: Export call_rcu_tasks_rude()
Date: Mon, 28 Sep 2026 23:29:27 +0900
Message-ID: <179060576723.372125.8212099501235098804.stgit@devnote2>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179060575297.372125.10581329083761385407.stgit@devnote2>
References: <179060575297.372125.10581329083761385407.stgit@devnote2>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Currently call_rcu_tasks_rude() is static and private to
kernel/rcu/tasks.h, while synchronize_rcu_tasks_rude() is exported.
Subsystems that execute handlers under preempt_disable() (such as
fprobe and BPF kprobe-multi) cannot safely wait on
synchronize_rcu_tasks_rude() in atomic or asynchronous contexts
without an asynchronous call_rcu_tasks_rude() variant.

Make call_rcu_tasks_rude() non-static, declare it in
include/linux/rcupdate.h, and export it via EXPORT_SYMBOL_GPL().
Also provide fallbacks to call_rcu when Tasks Rude RCU is not
configured.

Assisted-by: LLM
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 include/linux/rcupdate.h |    6 ++++++
 kernel/rcu/tasks.h       |    8 +++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 44c07a66edff..dca61b52dc8c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -198,7 +198,11 @@ void rcu_tasks_torture_stats_print(char *tt, char *tf);
 
 # ifdef CONFIG_TASKS_RUDE_RCU
 void synchronize_rcu_tasks_rude(void);
+void call_rcu_tasks_rude(struct rcu_head *rhp, rcu_callback_t func);
 void rcu_tasks_rude_torture_stats_print(char *tt, char *tf);
+# else
+# define call_rcu_tasks_rude call_rcu
+# define synchronize_rcu_tasks_rude synchronize_rcu
 # endif
 
 #define rcu_note_voluntary_context_switch(t) rcu_tasks_qs(t, false)
@@ -210,6 +214,8 @@ void exit_tasks_rcu_finish(void);
 #define rcu_note_voluntary_context_switch(t) do { } while (0)
 #define call_rcu_tasks call_rcu
 #define synchronize_rcu_tasks synchronize_rcu
+#define call_rcu_tasks_rude call_rcu
+#define synchronize_rcu_tasks_rude synchronize_rcu
 static inline void exit_tasks_rcu_start(void) { }
 static inline void exit_tasks_rcu_finish(void) { }
 #endif /* #else #ifdef CONFIG_TASKS_RCU_GENERIC */
diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 627295396cd9..f0b524d5f3f5 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1355,7 +1355,7 @@ static void rcu_tasks_rude_wait_gp(struct rcu_tasks *rtp)
 	schedule_on_each_cpu(rcu_tasks_be_rude);
 }
 
-static void call_rcu_tasks_rude(struct rcu_head *rhp, rcu_callback_t func);
+void call_rcu_tasks_rude(struct rcu_head *rhp, rcu_callback_t func);
 DEFINE_RCU_TASKS(rcu_tasks_rude, rcu_tasks_rude_wait_gp, call_rcu_tasks_rude,
 		 "RCU Tasks Rude");
 
@@ -1376,14 +1376,12 @@ DEFINE_RCU_TASKS(rcu_tasks_rude, rcu_tasks_rude_wait_gp, call_rcu_tasks_rude,
  *
  * See the description of call_rcu() for more detailed information on
  * memory ordering guarantees.
- *
- * This is no longer exported, and is instead reserved for use by
- * synchronize_rcu_tasks_rude().
  */
-static void call_rcu_tasks_rude(struct rcu_head *rhp, rcu_callback_t func)
+void call_rcu_tasks_rude(struct rcu_head *rhp, rcu_callback_t func)
 {
 	call_rcu_tasks_generic(rhp, func, &rcu_tasks_rude);
 }
+EXPORT_SYMBOL_GPL(call_rcu_tasks_rude);
 
 /**
  * synchronize_rcu_tasks_rude - wait for a rude rcu-tasks grace period

