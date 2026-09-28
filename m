Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94F62DB7BE;
	Mon, 28 Sep 2026 14:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790605805; cv=none; b=HoqTVlExkmqNvhNYC4wlDddv94D5LRC/EEpETcowUQzSycqeVQ4XExcpIAiERoW9v6NDo9/J1/hrbbNCDxSuptEKZb1ropdtUQTnmsTMrpe2trWWXxhLrNsq1UBCkr4fE5Xx/n2l4qsH/VZO+J7aKgIYgAxt8NEwk9EJfQXALLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790605805; c=relaxed/simple;
	bh=ALOZrwJaPASWoWZe70D4z6OGKN/ML+VMCN4PlBJgd5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sx2GIgjFLYsoGX+48qL853a0PlRsEg+gCfKxx9YagMOukmeXXIl2BisUUM9SkPdBtXLoJ0mKjg/jS5Wb3noeEHzjy6ik1NnMk0hrmtIXiEIGE/dhJ/z/RYcp9kle4lWXfP7sk9vMkLMivxrclVyqokd/PVBizHwv5iZNnMLEpig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iZnTWbHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iZnTWbHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B585D1F00893;
	Mon, 28 Sep 2026 14:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790605803;
	bh=n7vbmP5TU47LIjERe/7XNEu+RXwsLdobyskztSAHT+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZnTWbHK5cRk4SzkwD/W+vSGwE6F//rNoy6AfGW9ORnyf/Eo9y2CV4OrDNebegTbl
	 Mu0tqROn4LqvSOP+CVBVPOUC8q0XvbyZ3gTyrZBs2LUn7ghopwdlO1kNWzxhiGeacn
	 eoe0riPriUkY5nYyry1j8chzQ+wF+N1EcShbF6ZpbYJQ7H5P/BwFD98ersWOYujSSr
	 G8QsoWVPqI2XCCz1LFXoKw/mFMXTJ+hqnLv2ksHBofKEUIs9KGaJ3sjFsZcAaq6A1v
	 qdmQdrYO0LVHxK2Dlt+i6HRlXbz7IJ6yY2lW3TCcJfzzkp3rHU9B7s6Ub7TdBSpUGx
	 9Xdtj2d9523TQ==
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
Subject: [RFC PATCH 3/3] fprobe: Switch fprobe and BPF kprobe-multi to Tasks-Rude RCU
Date: Mon, 28 Sep 2026 23:29:54 +0900
Message-ID: <179060579456.372125.8753302103085829884.stgit@devnote2>
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

Currently, fprobe entry and exit callbacks are called from the tracing
path where preemption is disabled. However, because rhashtable deferred
bucket table reclamation using standard RCU and unregister_fprobe()
waited for standard RCU grace periods, guard(rcu)() and rcu_read_lock()
were used around hash lookups. Calling rcu_read_lock() in the trace path
introduces unnecessary overhead and potential recursion risks.

Furthermore, BPF_LINK_TYPE_KPROBE_MULTI attaches to fprobe via
register_fprobe_ips() and unregisters it asynchronously via
unregister_fprobe_async(), relying on bpf_link_free() to wait for
an RCU grace period before freeing the link structure.

If fprobe switches to Tasks-Rude RCU without simultaneously updating
BPF, a Use-After-Free race window opens during bpf_link_free() because
standard RCU grace periods do not wait for pure preempt-disabled
execution contexts to complete.

Atomically switch both fprobe and BPF kprobe-multi to Tasks-Rude RCU.

Assisted-by: LLM
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 kernel/bpf/syscall.c  |    2 +
 kernel/trace/fprobe.c |   66 +++++++++++++++++++++++++++----------------------
 2 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c7bc9ba9b331..f9356262ff76 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3350,6 +3350,8 @@ static void bpf_link_free(struct bpf_link *link)
 		/* We need to do a SRCU grace period wait for non-faultable tracepoint BPF links. */
 		else if (bpf_link_is_tracepoint(link))
 			call_tracepoint_unregister_atomic(&link->rcu, bpf_link_defer_dealloc_rcu_gp);
+		else if (link->type == BPF_LINK_TYPE_KPROBE_MULTI)
+			call_rcu_tasks_rude(&link->rcu, bpf_link_defer_dealloc_rcu_gp);
 		else
 			call_rcu(&link->rcu, bpf_link_defer_dealloc_rcu_gp);
 	} else if (ops->dealloc) {
diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 9f2d98181779..b7850df17575 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -36,11 +36,11 @@
  *
  * When unregistering the fprobe, fprobe_hlist::fp and fprobe_hlist::array[*].fp
  * are set NULL and delete those from both hash tables (by hlist_del_rcu).
- * After an RCU grace period, the fprobe_hlist itself will be released.
+ * After a Tasks-Rude RCU grace period, the fprobe_hlist itself will be released.
  *
  * fprobe_table and fprobe_ip_table can be accessed from either
  *  - Normal hlist traversal and RCU add/del under 'fprobe_mutex' is held.
- *  - RCU hlist traversal under disabling preempt
+ *  - Tasks-Rude RCU / preempt-disabled hlist traversal
  */
 static struct hlist_head fprobe_table[FPROBE_TABLE_SIZE];
 static struct rhltable fprobe_ip_table;
@@ -76,8 +76,14 @@ static const struct rhashtable_params fprobe_rht_params = {
 	.obj_hashfn		= fprobe_node_obj_hashfn,
 	.obj_cmpfn		= fprobe_node_cmp,
 	.automatic_shrinking	= true,
+	.use_tasks_rude		= true,
 };
 
+DEFINE_LOCK_GUARD_0(rcu_sched_notrace, rcu_read_lock_sched_notrace(),
+		    rcu_read_unlock_sched_notrace())
+DECLARE_LOCK_GUARD_0_ATTRS(rcu_sched_notrace, __acquires_shared(RCU),
+			   __releases_shared(RCU))
+
 /* Node insertion and deletion requires the fprobe_mutex */
 static int __insert_fprobe_node(struct fprobe_hlist_node *node, struct fprobe *fp)
 {
@@ -333,27 +339,22 @@ static void fprobe_ftrace_entry(unsigned long ip, unsigned long parent_ip,
 	if (bit < 0)
 		return;
 
-	/*
-	 * ftrace_test_recursion_trylock() disables preemption, but
-	 * rhltable_lookup() checks whether rcu_read_lcok is held.
-	 * So we take rcu_read_lock() here.
-	 */
-	rcu_read_lock();
-	head = rhltable_lookup(&fprobe_ip_table, &ip, fprobe_rht_params);
-
-	rhl_for_each_entry_rcu(node, pos, head, hlist) {
-		if (node->addr != ip)
-			break;
-		fp = READ_ONCE(node->fp);
-		if (unlikely(!fp || fprobe_disabled(fp) || fp->exit_handler))
-			continue;
+	scoped_guard(rcu_sched_notrace) {
+		head = rhltable_lookup(&fprobe_ip_table, &ip, fprobe_rht_params);
 
-		if (fprobe_shared_with_kprobes(fp))
-			__fprobe_kprobe_handler(ip, parent_ip, fp, fregs, NULL);
-		else
-			__fprobe_handler(ip, parent_ip, fp, fregs, NULL);
+		rhl_for_each_entry_rcu(node, pos, head, hlist) {
+			if (node->addr != ip)
+				break;
+			fp = READ_ONCE(node->fp);
+			if (unlikely(!fp || fprobe_disabled(fp) || fp->exit_handler))
+				continue;
+
+			if (fprobe_shared_with_kprobes(fp))
+				__fprobe_kprobe_handler(ip, parent_ip, fp, fregs, NULL);
+			else
+				__fprobe_handler(ip, parent_ip, fp, fregs, NULL);
+		}
 	}
-	rcu_read_unlock();
 	ftrace_test_recursion_unlock(bit);
 }
 NOKPROBE_SYMBOL(fprobe_ftrace_entry);
@@ -452,7 +453,7 @@ static bool fprobe_exists_on_hash(unsigned long ip, bool ftrace)
 	struct fprobe_hlist_node *node;
 	struct fprobe *fp;
 
-	guard(rcu)();
+	guard(rcu_sched_notrace)();
 	head = rhltable_lookup(&fprobe_ip_table, &ip,
 				fprobe_rht_params);
 	if (!head)
@@ -526,7 +527,7 @@ static bool fprobe_exists_on_hash(unsigned long ip, bool ftrace __maybe_unused)
 	struct fprobe_hlist_node *node;
 	struct fprobe *fp;
 
-	guard(rcu)();
+	guard(rcu_sched_notrace)();
 	head = rhltable_lookup(&fprobe_ip_table, &ip,
 				fprobe_rht_params);
 	if (!head)
@@ -570,7 +571,7 @@ static int fprobe_fgraph_entry(struct ftrace_graph_ent *trace, struct fgraph_ops
 	if (WARN_ON_ONCE(!fregs))
 		return 0;
 
-	guard(rcu)();
+	guard(rcu_sched_notrace)();
 	head = rhltable_lookup(&fprobe_ip_table, &func, fprobe_rht_params);
 	reserved_words = 0;
 	rhl_for_each_entry_rcu(node, pos, head, hlist) {
@@ -671,7 +672,7 @@ static void fprobe_return(struct ftrace_graph_ret *trace,
 	size_words = SIZE_IN_LONG(size);
 	ret_ip = ftrace_regs_get_instruction_pointer(fregs);
 
-	preempt_disable_notrace();
+	guard(rcu_sched_notrace)();
 
 	curr = 0;
 	while (size_words > curr) {
@@ -687,7 +688,6 @@ static void fprobe_return(struct ftrace_graph_ret *trace,
 		}
 		curr += size;
 	}
-	preempt_enable_notrace();
 }
 NOKPROBE_SYMBOL(fprobe_return);
 
@@ -1025,7 +1025,7 @@ int register_fprobe_ips(struct fprobe *fp, unsigned long *addrs, int num)
 	if (ret) {
 		unregister_fprobe_nolock(fp);
 		/* In error case, wait for clean up safely. */
-		synchronize_rcu();
+		synchronize_rcu_tasks_rude();
 	}
 
 	return ret;
@@ -1070,6 +1070,14 @@ bool fprobe_is_registered(struct fprobe *fp)
 	return true;
 }
 
+static void free_fprobe_hlist_array(struct rcu_head *head)
+{
+	struct fprobe_hlist *hlist_array;
+
+	hlist_array = container_of(head, struct fprobe_hlist, rcu);
+	kfree(hlist_array);
+}
+
 static int unregister_fprobe_nolock(struct fprobe *fp)
 {
 	struct fprobe_hlist *hlist_array = fp->hlist_array;
@@ -1101,7 +1109,7 @@ static int unregister_fprobe_nolock(struct fprobe *fp)
 	else
 		fprobe_graph_remove_ips(addrs, count);
 
-	kfree_rcu(hlist_array, rcu);
+	call_rcu_tasks_rude(&hlist_array->rcu, free_fprobe_hlist_array);
 	fp->hlist_array = NULL;
 	kfree(addrs);
 
@@ -1140,7 +1148,7 @@ int unregister_fprobe(struct fprobe *fp)
 	int ret = unregister_fprobe_async(fp);
 
 	if (!ret)
-		synchronize_rcu();
+		synchronize_rcu_tasks_rude();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(unregister_fprobe);

