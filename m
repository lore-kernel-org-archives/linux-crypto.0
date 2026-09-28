Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AF54D09F5;
	Mon, 28 Sep 2026 15:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790608653; cv=none; b=gOJv3B4FoUSAoQhYgDjlFi2Bhk0KfZklXKJblNPaYs3mf8s/WXZ1zpqE0TUPt/ZXyHPah4ft35APNqdgMyXNIc0VKjsRRIkZ03X5T37DlALQQbLmrWUyJPhrr5DQ0F54oNcwEcVgjAkxMfyiFAZ3/HyebuGQpTDvde94LvnMmhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790608653; c=relaxed/simple;
	bh=S1D34cwHw1BqFkF7bcWEE/S56n4pkNJ75qlEE9Upi+8=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=qaK35gNFwtV7/JKsUdXzdBPrEQMbvNr14yoGYs8kqXCyIerFZgjeMwlxW0l+46ovcySi0xC2oc75QCpLPGoJNMlknwM7jJotqodnlsTxKDsi2pMNUiIiIyfEXzHxB3+q1/hXpd0M+zOqBZf8k25dlw0Gm1NwwDCZCMYgvsMQqgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JmAmvovt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JmAmvovt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E457E1F000FF;
	Mon, 28 Sep 2026 15:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790608651;
	bh=bazDgST6Pt6E2LsRD74JROMaFIS21Sj5P+1074D68A8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=JmAmvovtrpFq0t+2g8XEldaaplldzoQDGQLwcK/lEkLEYagPT15fXVcKBuFCMCRO0
	 1yOyHU4L5rN6uJ0GSl7MHy4o7JE9yMEj27BgFuIndJJQZBU6bFViWuJPUqrUPTG8iV
	 PuaGLM7KUMC92psVXQ30d9DnSisi3L2St25Elj90czRRY4XeQwQDwPCY8tQu4wUwL7
	 /NYowiG9rj5Sq2BxTFFWOAHGnve7YHzZwswkicLmB1mGHT9c8TcdtA4dJDrvbuYnt8
	 ZbMrd6Nd+TZZw+wwSYZoESNTHK+cvGEs3KnNTj3SFLtZVOO2Qj9+FK87jNPuECp7SZ
	 JDMLYmonCC3jQ==
Content-Type: multipart/mixed; boundary="===============9154150229869040598=="
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <ac5eda3b03141b04642ec2196f06800c2b840d0dd9919df6a232a9c6e1575c89@mail.kernel.org>
In-Reply-To: <179060576723.372125.8212099501235098804.stgit@devnote2>
References: <179060576723.372125.8212099501235098804.stgit@devnote2>
Subject: Re: [RFC PATCH 1/3] rcu/tasks: Export call_rcu_tasks_rude()
From: bot+bpf-ci@kernel.org
To: mhiramat@kernel.org,paulmck@kernel.org,frederic@kernel.org,neeraj.upadhyay@kernel.org,joelagnelf@nvidia.com,josh@joshtriplett.org,boqun@kernel.org,urezki@gmail.com,tgraf@suug.ch,herbert@gondor.apana.org.au,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,rostedt@goodmis.org,mhiramat@kernel.org,akpm@linux-foundation.org
Cc: mathieu.desnoyers@efficios.com,jiangshanlai@gmail.com,qiang.zhang@linux.dev,john.fastabend@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,rcu@vger.kernel.org,linux-kernel@vger.kernel.org,linux-crypto@vger.kernel.org,bpf@vger.kernel.org,linux-trace-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 28 Sep 2026 15:17:29 +0000 (UTC)

--===============9154150229869040598==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 44c07a66edff..dca61b52dc8c 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -198,7 +198,11 @@ void rcu_tasks_torture_stats_print(char *tt, char *tf);
>
>  # ifdef CONFIG_TASKS_RUDE_RCU
>  void synchronize_rcu_tasks_rude(void);
> +void call_rcu_tasks_rude(struct rcu_head *rhp, rcu_callback_t func);
>  void rcu_tasks_rude_torture_stats_print(char *tt, char *tf);
> +# else
> +# define call_rcu_tasks_rude call_rcu
> +# define synchronize_rcu_tasks_rude synchronize_rcu
>  # endif
>
>  #define rcu_note_voluntary_context_switch(t) rcu_tasks_qs(t, false)

[ ... ]

> diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
> index 627295396cd9..f0b524d5f3f5 100644
> --- a/kernel/rcu/tasks.h
> +++ b/kernel/rcu/tasks.h

[ ... ]

> @@ -1376,14 +1376,12 @@ DEFINE_RCU_TASKS(rcu_tasks_rude, rcu_tasks_rude_wait_gp, call_rcu_tasks_rude,
>   *
>   * See the description of call_rcu() for more detailed information on
>   * memory ordering guarantees.
> - *
> - * This is no longer exported, and is instead reserved for use by
> - * synchronize_rcu_tasks_rude().
>   */
> -static void call_rcu_tasks_rude(struct rcu_head *rhp, rcu_callback_t func)
> +void call_rcu_tasks_rude(struct rcu_head *rhp, rcu_callback_t func)
>  {
>  	call_rcu_tasks_generic(rhp, func, &rcu_tasks_rude);
>  }
> +EXPORT_SYMBOL_GPL(call_rcu_tasks_rude);

Do call_rcu_tasks_rude() and synchronize_rcu_tasks_rude() actually provide
the same grace period guarantee?

On architectures that select ARCH_WANTS_NO_INSTR (x86, arm64, riscv, s390,
loongarch), synchronize_rcu_tasks_rude() returns without waiting at all
unless CONFIG_FORCE_TASKS_RUDE_RCU is set:

kernel/rcu/tasks.h:synchronize_rcu_tasks_rude() {
	if (!IS_ENABLED(CONFIG_ARCH_WANTS_NO_INSTR) ||
	    IS_ENABLED(CONFIG_FORCE_TASKS_RUDE_RCU))
		synchronize_rcu_tasks_generic(&rcu_tasks_rude);
}

That option depends on RCU_EXPERT and defaults to n.

But call_rcu_tasks_rude() never takes that shortcut. Every callback goes
through this path:

call_rcu_tasks_rude()
  -> call_rcu_tasks_generic()
    -> rcu_tasks_one_gp()
      -> rcu_tasks_rude_wait_gp()
        -> schedule_on_each_cpu()

which always waits.

The rest of the series relies on these two functions being equivalent.
Commit f0b3c7fc5f82 ("fprobe: Switch fprobe and BPF kprobe-multi to
Tasks-Rude RCU") replaces synchronize_rcu() with
synchronize_rcu_tasks_rude() in unregister_fprobe() and in the error path
of register_fprobe_ips().

On a default x86 or arm64 build (FPROBE selects FUNCTION_GRAPH_TRACER,
which depends on FUNCTION_TRACER, which selects TASKS_RUDE_RCU),
unregister_fprobe() then returns without waiting for handlers that are
still running. Example path:

trace_fprobe_release()
  -> unregister_trace_fprobe()
    -> __unregister_trace_fprobe()
      -> unregister_fprobe(&tf->fp)
        -> unregister_fprobe_async() + synchronize_rcu_tasks_rude() [no-op]
          -> free_trace_fprobe(tf)
            -> kfree(tf)

Meanwhile another CPU can be inside fprobe_ftrace_entry() or
fprobe_return(), holding fp from READ_ONCE(node->fp) or from the shadow
stack, and calling fp->entry_handler / fp->exit_handler, which uses
container_of() to reach the freed trace_fprobe. The same thing happens when
the samples/fprobe module unloads after unregister_fprobe().

Before the series, synchronize_rcu() waited for these preempt-disabled
sections, because consolidated RCU waits for preempt-disabled regions where
RCU is watching.

Other points:

(1) The commit message says callers "cannot safely wait on
    synchronize_rcu_tasks_rude()" and need an async variant. On these
    architectures that wait is a no-op, so the premise is wrong, and the
    synchronize_rcu_tasks_rude() kerneldoc ("Control will return to the
    caller some time after a rude rcu-tasks grace period has elapsed") does
    not match its implementation.

(2) Every grace period needed by a call_rcu_tasks_rude() callback now
    queues work on and context-switches every online CPU, including idle
    and nohz_full CPUs. For the synchronous API that cost was deliberately
    removed on these architectures. Once the series moves fprobe/kprobe-multi
    teardown and rhashtable resizing onto this API, the cost is paid on
    every teardown and resize.

(3) The removed comment ("This is no longer exported, and is instead
    reserved for use by synchronize_rcu_tasks_rude()") recorded a
    deliberate decision to retire the async Rude API. The changelog does
    not explain why that decision is being reversed.

Options include making call_rcu_tasks_rude() match
synchronize_rcu_tasks_rude(), for example falling back to call_rcu() under
the same ARCH_WANTS_NO_INSTR condition. Alternatively the series could keep
using call_rcu()/synchronize_rcu(): these already cover preempt-disabled
readers on noinstr architectures, and rcu_read_lock_sched_notrace() can
replace rcu_read_lock() in the handlers.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/36438713281
--===============9154150229869040598==--
