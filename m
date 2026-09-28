Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9570F2C87F;
	Mon, 28 Sep 2026 14:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790605790; cv=none; b=PSwtIEgCQ4mukYu9712wLFbdegbVAhIRWJXhdcNJrVb0ImInv1ECDLomoY+lAka+hHxcZfUxMcD6Gp9P0N/6yyY56NVJ/d6+5I0pNYBx1+pkeqDGiLrf3r6/z95sOrANQNmr3s2ctBU/D5ZLoosZUJPjYMq6cICy+8Z/8UKXIlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790605790; c=relaxed/simple;
	bh=yAfaUdlNkYGOV2PLARpoh9jWQe1Tm8S+gfdOOIrolWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D+Nj3l3aTUGqWs08VhQ+G6WR7NAhrkjAuy/4rsvK0Tk/3Nb8XTq+bEFtgbDU4ufsGUTywq5vRcgpfL5fPS9EBRoHGLQGMqzn9EigXy/qde2FXcRvK4Lesv/9rW3fXxR5hdF7fWWAKPq+oOBRjCAtlOBGIzpRUSKz5SB4LhLjnSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ft63nYHQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ft63nYHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BFC1F00893;
	Mon, 28 Sep 2026 14:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790605789;
	bh=Ntn7r+Vsgp7Fwjs6rTL9YfF6MrIpPWgwFf1ZDe8coX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ft63nYHQzrghS7loMrOvhdSff5jhuEQ7X0ikeX7gLKglwTZAc8xLBGWCQMwOxkVrB
	 GWWjuDwyqVsGukoGHJjLb8lcBgvRbdrujca85uE5vlBv0uJI5tuH/c2veCkEDIsTwo
	 hFcbzeNYaihTzHNuzUAVbfOnhycQIbHx22Sha2sY2UOJrHY7Vo1BMrLyhIVeJBQAnY
	 /z9EiqeIor1ztA8v5AHtOJdB8nXi4ZeIPP5j4N4heHsfldyLD3g2AK8KAabjlZo7z3
	 t1uv7evCR3FPhL/c3gX8eq9CUkm3mCc3pjhRdNnuR9Uit54Tc35X4lPBRniC1nmPhS
	 YzaEDWt3jXo0A==
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
Subject: [RFC PATCH 2/3] rhashtable: Add use_tasks_rude parameter to defer bucket table free
Date: Mon, 28 Sep 2026 23:29:40 +0900
Message-ID: <179060578063.372125.17243688315867196392.stgit@devnote2>
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

Currently rhashtable always uses call_rcu() to free old bucket tables
upon table resizing. However, some callers (such as fprobe) operate
under preempt_disable() without holding rcu_read_lock(), relying on
Tasks Rude RCU grace periods instead of standard RCU.

Add a use_tasks_rude boolean flag to struct rhashtable_params. When
enabled, rhashtable_rehash_table() frees old bucket tables using
call_rcu_tasks_rude() instead of call_rcu(). Existing callers continue
to default to call_rcu().

Assisted-by: LLM
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 include/linux/rhashtable-types.h |    2 ++
 lib/rhashtable.c                 |    5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtable-types.h
index 57c11ec9dc64..24282ae68409 100644
--- a/include/linux/rhashtable-types.h
+++ b/include/linux/rhashtable-types.h
@@ -52,6 +52,7 @@ typedef int (*rht_obj_cmpfn_t)(struct rhashtable_compare_arg *arg,
  * @min_size: Minimum size while shrinking
  * @insecure_elasticity: Set to true to disable chain length checks
  * @automatic_shrinking: Enable automatic shrinking of tables
+ * @use_tasks_rude: Use call_rcu_tasks_rude() to free bucket tables
  * @hashfn: Hash function (default: jhash2 if !(key_len % 4), or jhash)
  * @obj_hashfn: Function to hash object
  * @obj_cmpfn: Function to compare key with object
@@ -65,6 +66,7 @@ struct rhashtable_params {
 	u16			min_size;
 	bool			insecure_elasticity;
 	bool			automatic_shrinking;
+	bool			use_tasks_rude;
 	rht_hashfn_t		hashfn;
 	rht_obj_hashfn_t	obj_hashfn;
 	rht_obj_cmpfn_t		obj_cmpfn;
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 6362896e4f09..b183fb112a70 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -359,7 +359,10 @@ static int rhashtable_rehash_table(struct rhashtable *ht)
 	 * rhashtable_walk_stop() can use rcu_head_after_call_rcu()
 	 * to check if it should not re-link the table.
 	 */
-	call_rcu(&old_tbl->rcu, bucket_table_free_rcu);
+	if (ht->p.use_tasks_rude)
+		call_rcu_tasks_rude(&old_tbl->rcu, bucket_table_free_rcu);
+	else
+		call_rcu(&old_tbl->rcu, bucket_table_free_rcu);
 	spin_unlock(&ht->lock);
 
 	return rht_dereference(new_tbl->future_tbl, ht) ? -EAGAIN : 0;

