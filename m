Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794333037;
	b=GF4zYBPfhC+WWPE8QoQkL37rIHZchq7KulhgYu27cSrsXgr40gE+9TrHfEbmyv38heIK
	 CFD3pwSMt1aM5qy6wE64Y3Q0QxY+RTGPVKzqhlPahMDxXstJPTx5dAJFT/99OFqD7aKEl
	 U/6kRkn3+Q0gpPztg9PzVDKZcYvWH9OTyWlSTCUFQGoJZkjddaECdywN4JsEutbVHsS2R
	 HgFv44LEdLaTSJxiDGxHdaK3UOOow6P1+KVjEtn1EclwZPiq2sUBgwkmLIDrruWcKGfS2
	 4JMsJcSdR2gbBQTKnwXMpqIZhGvqMCNEjmHoLAZrcc8Xq+PA6f1VQcgzbnLpjU6sTgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794333037;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3fKz0zVtGNM7jv9NEHOa2VfwFazQlE8zad6N8NadQMQ=;
	b=shuFiHDK7ordZjVuhb4PCFdfWDZ7uHi98O7Lsr0Ft2aqZzmVL7POhZOu+NHDdC08dbBg
	 yxUd7s3JDO/osGQ+WiYZzdZzCJ+fG4Gj/r6gsR0zibwz3CtVt/ngx+5w37mD6F3TBW14L
	 zo33NLBsu1bFeaz02XmCpJKBaVl/1Fs0zY16iRdRcbLrF1eownjvlROaETfqWsDWgpi+d
	 9U+QLKfxjeSRqGkXUOaj7NUHH1P79fMXP+L9xoZFhcAMn0QLJEXcAr2i4UZPWIqk0wUxA
	 1aDpHRnksdm4QC6kne8F6YFE0uFHG4d3vofHT5O9iHZUQNPaLQ+N3LBQwfPVvwZjw9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SbkuG57d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080EE60A2607;
	Tue, 10 Nov 2026 17:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SbkuG57d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CA81F008A1;
	Tue, 10 Nov 2026 17:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794333036;
	bh=3fKz0zVtGNM7jv9NEHOa2VfwFazQlE8zad6N8NadQMQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SbkuG57dgplP43gWjsiVrX7JB0IQHyYN8/WesfxSXTKmmxcCZtlRqoT0HvVYm2EdU
	 rCcwQ620j2zMOxep5LpKUJCOXPlMnPVIjuVf6wrN+qRGJVkbx52wYms3VVpRsEHAGq
	 /Hnoqo/7khQgLrfQYrCau1NyrkCIKkvm1I/+FImaFSjztaOVhhTtO/zptBN/J/EdTH
	 emqZHVQxoRskeOJTfoaB+R+G8kg+f/kMM9FC98GbNq5CbKngZdknTD92451hynyQgP
	 irM21CVgzq0D9gc6AuNmMmV2oPtPfF4R04z8/StQe7z2oL3H2fKYdcMNSMVi0i6sk8
	 ROfenBWidazUA==
Message-ID: <sashiko-outbox-207521@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 2/5] crypto: cmh - add core platform driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alex Ousherovitch" <aousherovitch@rambus.com>, "Saravanakrishnan
 Krishnamoorthy" <skrishnamoorthy@rambus.com>, "Joel Wittenauer" <Joel.Wittenauer@cryptography.com>, "Thi
 Nguyen" <thin@rambus.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20261110-cmh-b4-a-v8-v8-2-4cea8ebc1d40@rambus.com>
References: <20261110-cmh-b4-a-v8-v8-0-4cea8ebc1d40@rambus.com>
 <20261110-cmh-b4-a-v8-v8-2-4cea8ebc1d40@rambus.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 17:50:35 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 13 potential
issues to consider:
- [High] crypto: cmh - race in cmh_tm_try_cancel_command() during CMQ
  backoff
- [High] crypto: cmh - unaborted sync timeouts and missing watchdog
  escalation
- [Medium] crypto: cmh - stale new_head overwrites last_head after
  cmh_rh_process_mbx()
- [Medium] crypto: cmh - missing abort_stall_ticks reset and immediate
  flush on stall
- [Medium] crypto: cmh - missing wedged check in cmh_rh_thread()
  restarts wedged mailbox
- [Medium] crypto: cmh - missing tm.dma_live updates and sync timeout
  return value
- [Medium] crypto: cmh - unconditional RESTART on empty queue in
  cmh_rh_process_mbx()
- [Medium] crypto: cmh - missing FLUSH reissue in cmh_rh_flush_poll()
- [Medium] crypto: cmh - missing IRQ clear and tail poke in
  cmh_mbx_flush_wait()
- [Medium] crypto: cmh - cmh_tm_quiesce() ignores pending mailbox
  recovery on suspend
- [Medium] crypto: cmh - unmapped SG source free and stale quiescent
  state on quarantine
- [Medium] crypto: cmh: missing IRQ clear and tail poke in
  cmh_mbx_flush_wait()
- [Low] crypto: cmh - missing vcqs_completed update on pre-error
  retirement
--

commit 9211e09c64c4bde6e31810b1851caacec422996b
Author: Alex Ousherovitch <aousherovitch@rambus.com>

crypto: cmh - add core platform driver

This commit adds the core platform driver for the Rambus CryptoManager Hub
(CMH), including mailbox queue setup, the transaction manager kthread, the
response handler, DMA quarantine tracking, sysfs/debugfs interfaces, and
driver documentation.

> diff --git a/drivers/crypto/cmh/cmh_mqi.c b/drivers/crypto/cmh/cmh_mqi.c
> new file mode 100644
> index 0000000000000..d4edd96093dd2
> --- /dev/null
> +++ b/drivers/crypto/cmh/cmh_mqi.c
[ ... ]
> +static bool cmh_mbx_flush_wait(struct cmh_mbx_config *mbx)
> +{
> +	void __iomem *base =3D mbx->reg_base;
> +	ktime_t deadline;
> +
> +	if (!base) {
> +		mbx->fenced =3D true;
> +		return true;
> +	}
> +	if (MBX_STATUS_CODE(cmh_reg_read32(base, R_MBX_STATUS)) =3D=3D
> +	    MBX_STATUS_OFFLINE)
> +		goto unfenced;
> +
> +	cmh_reg_write32(MBX_COMMAND_FLUSH, base, R_MBX_COMMAND);
> +	deadline =3D ktime_add_us(ktime_get(), MBX_FLUSH_TIMEOUT_US);
> +	for (;;) {
> +		if (cmh_mbx_flush_acked(base)) {
> +			mbx->fenced =3D true;
> +			return true;
> +		}
> +		if (ktime_after(ktime_get(), deadline))
> +			break;
> +		/* Cleared by an earlier command's acknowledgment: reissue. */
> +		if (!cmh_reg_read32(base, R_MBX_COMMAND))
> +			cmh_reg_write32(MBX_COMMAND_FLUSH, base,
> +					R_MBX_COMMAND);
> +		usleep_range(MBX_FLUSH_POLL_US, 2 * MBX_FLUSH_POLL_US);
> +	}

[Severity: Medium]
Does cmh_mbx_flush_wait() need to W1C-clear R_MBX_INTERRUPT and poke
R_MBX_QUEUE_TAIL when issuing MBX_COMMAND_FLUSH, the way
cmh_rh_issue_flush() does?

At probe, cmh_mqi_init() calls cmh_mbx_flush_wait() before
cmh_mbx_setup_one() clears stale interrupt bits, and at teardown it runs
after cmh_rh_cleanup() has stopped the response handler.  If a mailbox was
left in ERROR state with MBX_ERROR_IRQ asserted in R_MBX_INTERRUPT, writing
R_MBX_COMMAND alone may not generate a new SIC interrupt edge to wake the
eSW from WFI, causing probe to fail with -EBUSY or teardown to treat the
mailbox as unfenced and leak its DMA buffers.

[ ... ]

> diff --git a/drivers/crypto/cmh/cmh_rh.c b/drivers/crypto/cmh/cmh_rh.c
> new file mode 100644
> index 0000000000000..fadb860b8d7aa
> --- /dev/null
> +++ b/drivers/crypto/cmh/cmh_rh.c
[ ... ]
> +static void cmh_rh_flush_poll(u32 mbx_idx, bool tick)
> +{
> +	void __iomem *base =3D rh.cfg->mailboxes[mbx_idx].reg_base;
> +	struct cmh_rh_mbx *m =3D &rh.mbx[mbx_idx];
> +
> +	if (cmh_rh_flush_acked(base)) {
> +		m->flush_pending =3D false;
> +		m->flush_count =3D 0;
> +		cmh_rh_drain_mbx(mbx_idx, -ECANCELED, false);
> +		cmh_tm_mbx_admit(mbx_idx, true);
> +		return;
> +	}
> +
> +	if (!tick)
> +		return;
> +
> +	if (++m->flush_ticks <=3D CMH_RH_RESTART_MAX_RETRIES) {
> +		/* Re-poke TAIL in case the eSW missed the interrupt. */
> +		cmh_rh_poke_tail(base);
> +		return;
> +	}

[Severity: Medium]
If an earlier command's acknowledgment clears R_MBX_COMMAND to 0
(MBX_COMMAND_RUN) before the eSW processes MBX_COMMAND_FLUSH, doesn't
cmh_rh_flush_poll() poke R_MBX_QUEUE_TAIL for five ticks without reissuing
MBX_COMMAND_FLUSH?

Unlike cmh_mbx_flush_wait(), which checks !cmh_reg_read32(base,
R_MBX_COMMAND) and rewrites MBX_COMMAND_FLUSH, cmh_rh_flush_poll() leaves
R_MBX_COMMAND at MBX_COMMAND_RUN while poking TAIL.  That wakes the eSW to
execute remaining VCQs in the ring, including surviving slots of a failed
multi-VCQ transaction whose DMA buffers were already freed in
cmh_rh_process_mbx().

[ ... ]

> +		/*
> +		 * HEAD was sampled before the status: the eSW may have
> +		 * completed more VCQs and failed a later one in between.  It
> +		 * does not move HEAD while stopped in ERROR, so re-read it now
> +		 * to pair the error with the VCQ it belongs to.
> +		 */
> +		new_head =3D cmh_reg_read32(base, R_MBX_QUEUE_HEAD);
> +
> +		error =3D cmh_rh_vcq_errno(mbx_idx, base, status);
[ ... ]
> +		/* First: retire transactions completed before the error */
> +		while ((txn =3D cmh_tm_peek_transaction(mbx_idx)) !=3D NULL) {
> +			if ((s32)(new_head - txn->last_vcq_id) <=3D 0)
> +				break;
> +			txn =3D cmh_tm_pop_transaction(mbx_idx);
> +			if (!txn)
> +				break;
> +			dev_dbg(cmh_dev(),
> +				"rh: mbx[%u] pre-error complete vcq=3D%u..%u\n",
> +				mbx_idx, txn->first_vcq_id,
> +				txn->last_vcq_id);
> +			cmh_txn_finish(txn, 0, false);
> +			cmh_tm_txq_completion_notify();
> +		}

[Severity: Low]
Should this pre-error retirement loop call cmh_rh_stat_add_completed() like
the normal completion loop below does, so debugfs vcqs_completed does not
undercount transactions completed before an error?

[ ... ]

> +		/* Now pop and fail the transaction that actually errored */
> +		txn =3D cmh_tm_pop_transaction(mbx_idx);
> +		if (txn) {
> +			dev_dbg(cmh_dev(), "rh: mbx[%u] error-complete vcq=3D%u..%u\n",
> +				mbx_idx, txn->first_vcq_id,
> +				txn->last_vcq_id);
> +			cmh_txn_finish(txn, error, false);
> +			cmh_tm_txq_completion_notify();
> +		} else {
> +			u32 head_reg, tail_reg;
> +
> +			head_reg =3D cmh_reg_read32(base, R_MBX_QUEUE_HEAD);
> +			tail_reg =3D cmh_reg_read32(base, R_MBX_QUEUE_TAIL);
> +			dev_warn_ratelimited(cmh_dev(),
> +					     "rh: mbx[%u] ERROR with empty txn queue (orphaned) status=3D0x=
%08x head=3D%u tail=3D%u core=3D%u ecode=3D%u cmd_idx=3D%u\n",
> +					     mbx_idx, status,
> +					     head_reg, tail_reg,
> +					     MBX_STATUS_CORE_ID(status),
> +					     MBX_STATUS_ERROR_CODE(status),
> +					     MBX_STATUS_CMD_INDEX(status));
> +		}
> +		cmh_rh_stat_inc_errors(mbx_idx);
> +
> +		cmh_reg_write32(MBX_IRQ_MASK, base, R_MBX_INTERRUPT);
> +		cmh_reg_write32(MBX_COMMAND_RESTART, base, R_MBX_COMMAND);

[Severity: Medium]
When cmh_tm_pop_transaction() returns NULL here (for example after an abort
lands just as the last in-flight VCQ completes, or via debugfs
inject_abort), can issuing MBX_COMMAND_RESTART skip a newly submitted VCQ?

Mailbox admission is not closed, and submit_vcq() on the TM kthread does not
take rh_process_lock:

CPU0 (cmh_rh_process_mbx)         CPU1 (cmh_tm_thread)
cmh_tm_pop_transaction() -> NULL
                                  submit_vcq()
                                    tail =3D read(R_MBX_QUEUE_TAIL)
                                    write VCQ to slot[tail]
                                    list_add_tail(&txn->list, &txq->head)
                                    write(tail + 1, R_MBX_QUEUE_TAIL)
write(MBX_COMMAND_RESTART, ...)
cmh_rh_poke_tail()
  /* eSW advances HEAD + 1,
     skipping slot[tail] */

On the next poll, cmh_rh_process_mbx() sees new_head > txn->last_vcq_id and
completes the unexecuted transaction with error =3D 0, returning unwritten
output buffers to the caller.

[ ... ]

> +static irqreturn_t cmh_rh_thread(int irq, void *data)
> +{
> +	struct cmh_config *cfg =3D data;
> +	u32 i;
> +	bool recheck;
> +
> +	do {
> +		recheck =3D false;
> +
> +		for (i =3D 0; i < cfg->mbx_count; i++) {
> +			u32 new_head, irq_bits;
> +
> +			if (!READ_ONCE(rh.mbx[i].pending))
> +				continue;
[ ... ]
> +			WRITE_ONCE(rh.mbx[i].pending, false);
> +			irq_bits =3D (u32)atomic_xchg(&rh.mbx[i].irq_bits, 0);
> +
> +			spin_lock_bh(&rh_process_lock);
> +			if (rh.mbx[i].flush_pending) {
> +				cmh_rh_flush_poll(i, false);
> +				spin_unlock_bh(&rh_process_lock);
> +				continue;
> +			}
> +			new_head =3D cmh_reg_read32(cfg->mailboxes[i].reg_base,
> +						  R_MBX_QUEUE_HEAD);
> +
> +			if (new_head =3D=3D rh.mbx[i].last_head && !irq_bits) {
> +				spin_unlock_bh(&rh_process_lock);
> +				continue;
> +			}
> +
> +			cmh_rh_process_mbx(i, new_head, irq_bits);
> +			rh.mbx[i].last_head =3D new_head;
> +			spin_unlock_bh(&rh_process_lock);
> +		}

[Severity: Medium]
What happens if a wedged mailbox raises an interrupt?

When cmh_rh_flush_poll() marks a mailbox wedged, it clears flush_pending but
leaves R_MBX_INTERRUPT_MASK enabled.  Unlike the second loop in
cmh_rh_thread() and cmh_rh_watchdog_fn(), this first loop (as well as
cmh_rh_process_mbx() and cmh_rh_abort_mbx()) does not check
rh.mbx[i].wedged.  A delayed MBX_ERROR_IRQ or a debugfs inject_abort write
will therefore run cmh_rh_process_mbx() on the wedged mailbox and issue
MBX_COMMAND_RESTART, causing the eSW to advance HEAD and execute VCQ slots
whose transactions were already drained with -ETIMEDOUT.

[ ... ]

> +		if (new_head !=3D rh.mbx[i].last_head || poll_irq_bits) {
> +			cmh_rh_process_mbx(i, new_head, poll_irq_bits);
> +			rh.mbx[i].last_head =3D new_head;
> +		}
> +		spin_unlock_bh(&rh_process_lock);
> +	}

[Severity: Medium]
Does assigning rh.mbx[i].last_head =3D new_head in cmh_rh_thread() and
cmh_rh_watchdog_fn() overwrite last_head with a stale value when
cmh_rh_process_mbx() re-reads R_MBX_QUEUE_HEAD on an error?

In cmh_rh_process_mbx(), when MBX_STATUS_ERROR is observed, new_head is
re-read into the local by-value parameter because the eSW may have completed
more VCQs between the caller's initial R_MBX_QUEUE_HEAD read and the status
check.  cmh_rh_process_mbx() retires those pre-error transactions and sets
restart_head to the updated head, but all three callers then overwrite
rh.mbx[i].last_head with their old pre-status new_head.  The next poll then
falsely sees new_head !=3D last_head, re-enters cmh_rh_process_mbx(), and
resets abort_stall_ticks prematurely.

[ ... ]

> +		if (new_head !=3D rh.mbx[i].last_head || irq_bits) {
> +			if (new_head !=3D rh.mbx[i].last_head)
> +				dev_dbg_ratelimited(cmh_dev(),
> +						    "rh: watchdog: mbx[%u] head %u->%u (missed IRQ recovery)\n",
> +						    i, rh.mbx[i].last_head,
> +						    new_head);
> +			cmh_rh_process_mbx(i, new_head, irq_bits);
> +			rh.mbx[i].last_head =3D new_head;
> +			rh.mbx[i].abort_stall_ticks =3D 0;
> +		}
> +
> +		if (!READ_ONCE(rh.mbx[i].wedged) &&
> +		    !READ_ONCE(rh.mbx[i].restart_pending) &&
> +		    !rh.mbx[i].flush_pending) {
> +			struct transaction_obj *head_txn;
> +
> +			head_txn =3D cmh_tm_peek_transaction(i);
> +			if (head_txn &&
> +			    atomic_read(&head_txn->state) =3D=3D TXN_TIMED_OUT) {
> +				unsigned int stall_max;
> +				void __iomem *base =3D
> +					rh.cfg->mailboxes[i].reg_base;
> +
> +				rh.mbx[i].abort_stall_ticks++;
> +
> +				if (rh.mbx[i].abort_stall_ticks =3D=3D 1) {
> +					dev_warn(cmh_dev(),
> +						 "rh: watchdog: mbx[%u] head txn timed out, issuing ABORT\n",
> +						 i);
> +					cmh_reg_write32(MBX_COMMAND_ABORT,
> +							base,
> +							R_MBX_COMMAND);
> +				}
> +
> +				stall_max =3D DIV_ROUND_UP(CMH_RH_ABORT_STALL_MS,
> +							 max(watchdog_ms,
> +							     CMH_RH_WATCHDOG_MS_MIN));
> +				if (rh.mbx[i].abort_stall_ticks >=3D
> +				    stall_max) {
> +					dev_err(cmh_dev(),
> +						"rh: watchdog: mbx[%u] abort stall (%u ticks) -- FLUSH\n",
> +						i, rh.mbx[i].abort_stall_ticks);
> +					cmh_rh_issue_flush(i);
> +				}
> +			} else {
> +				rh.mbx[i].abort_stall_ticks =3D 0;
> +			}
> +		}

[Severity: Medium]
Doesn't cmh_rh_thread() need to reset rh.mbx[i].abort_stall_ticks =3D 0 when
it advances last_head or completes error recovery?

When the watchdog issues MBX_COMMAND_ABORT on tick 1 and cmh_rh_thread()
processes the resulting MBX_ERROR_IRQ (or a normal completion) before the
next watchdog tick, cmh_rh_thread() updates rh.mbx[i].last_head without
resetting abort_stall_ticks.  On the next watchdog tick, new_head =3D=3D
last_head, so if the next transaction at the head of the queue also timed
out while waiting behind the first, abort_stall_ticks increments from 1 to
2, skipping MBX_COMMAND_ABORT for the new head transaction and counting
straight toward a full mailbox FLUSH.

Also, when watchdog_ms >=3D CMH_RH_ABORT_STALL_MS, stall_max is 1, so tick 1
writes MBX_COMMAND_ABORT and immediately calls cmh_rh_issue_flush() in the
same tick without giving the eSW any time to process the abort.

> diff --git a/drivers/crypto/cmh/cmh_txn.c b/drivers/crypto/cmh/cmh_txn.c
> new file mode 100644
> index 0000000000000..9a84b52781bfe
> --- /dev/null
> +++ b/drivers/crypto/cmh/cmh_txn.c
[ ... ]
> +static void cmh_req_dma_quarantine(struct cmh_req_dma *rd)
> +{
> +	unsigned int i;
> +
> +	if (rd->sgm)
> +		cmh_dma_quarantine_track(NULL, 0, 0, DMA_NONE, rd->sgm);
> +	for (i =3D 0; i < rd->n; i++) {
> +		struct cmh_req_dma_ent *e =3D &rd->ent[i];
> +
> +		if (e->mapped)
> +			cmh_dma_quarantine_track(e->buf, e->dma, e->len,
> +						 e->dir, NULL);
> +		else if (e->sg_src && rd->sgm)
> +			cmh_dma_quarantine_track(e->buf, 0, 0, DMA_NONE,
> +						 NULL);
> +		else if (e->sensitive)
> +			kfree_sensitive(e->buf);
> +		else
> +			kfree(e->buf);
> +	}
> +	rd->n =3D 0;
> +	rd->sgm =3D NULL;
> +}

[Severity: Medium]
In cmh_req_dma_quarantine(), what happens if the GFP_ATOMIC allocation in
cmh_dma_quarantine_track() fails for rd->sgm, but succeeds for a subsequent
e->sg_src entry?

rd->sgm is leaked with its source buffers still DMA-mapped, while the
e->sg_src buffer is tracked with dir =3D=3D DMA_NONE.  When
cmh_dma_quarantine_release(true) runs at module unload, cmh_dma_orphan_reap=
()
sees dir =3D=3D DMA_NONE and frees e->buf with kfree_sensitive() without
cmh_dma_free_sg(rd->sgm) ever having unmapped its active streaming DMA
mapping.

In addition, tm.dma_live is never reset in cmh_tm_init() or in
cmh_tm_cleanup() after cmh_mqi_settle_all() succeeds.

[ ... ]

> +static void cmh_tm_requeue_wait(struct command_msg *msg)
> +{
> +	int gen =3D atomic_read(&txq_completion_gen);
> +	unsigned long flags, tmo;
> +
> +	spin_lock_irqsave(&tm.cmq_lock, flags);
> +	list_add(&msg->list, &tm.cmq);
> +	cmq_depth++;
> +	spin_unlock_irqrestore(&tm.cmq_lock, flags);
> +
> +	tmo =3D usecs_to_jiffies(CMH_TM_BACKOFF_MAX_US);
> +	wait_event_interruptible_timeout(tm.cmq_waitq,
> +					 kthread_should_stop() ||
> +					 atomic_read(&txq_completion_gen) !=3D gen,
> +					 tmo ?: 1);
> +	cmh_stat_inc_tm_backoff();
> +}
> +
> +static int cmh_tm_thread(void *data)
> +{
> +	struct command_msg *msg;
> +	unsigned long flags;
> +	int mbx_idx, ret;
> +
> +	while (!kthread_should_stop()) {
[ ... ]
> +		msg =3D list_first_entry(&tm.cmq, struct command_msg, list);
> +		list_del_init(&msg->list);
> +		cmq_depth--;
> +		spin_unlock_irqrestore(&tm.cmq_lock, flags);
> +
> +		/* Select a mailbox: pinned or round-robin */
> +		mbx_idx =3D resolve_mbx(msg);
[ ... ]
> +		if (mbx_idx < 0) {
> +			/* Rings full or mailboxes recovering -- retry. */
> +			cmh_tm_requeue_wait(msg);
> +			continue;
> +		}

[Severity: High]
Can cmh_tm_try_cancel_command() miss a command that is transiently off
tm.cmq while cmh_tm_thread() checks resolve_mbx() or submit_vcq()?

CPU0 (cmh_tm_thread)              CPU1 (cmh_tm_submit_sync_tmo)
spin_lock_irqsave(&tm.cmq_lock)
list_del_init(&msg->list)
spin_unlock_irqrestore(&tm.cmq_lock)
resolve_mbx(msg) -> -EAGAIN
                                  /* wait_for_completion_timeout() expires =
*/
                                  cmh_tm_try_cancel_command(msg)
                                    spin_lock_irqsave(&tm.cmq_lock)
                                    !list_empty(&msg->list) -> false
                                    spin_unlock_irqrestore(&tm.cmq_lock)
cmh_tm_requeue_wait(msg)
  list_add(&msg->list, &tm.cmq)

Because msg->actual_mbx is still -1, cmh_tm_submit_sync_tmo() issues no
abort, and if the mailboxes stay busy or closed across the 5-second wait, it
returns -ETIMEDOUT while msg is still queued in tm.cmq.  cmh_tm_thread() can
then dispatch the VCQ to hardware after the caller has unmapped and freed
its input DMA buffers (DMA use-after-free).  In cmh_tm_submit_sync_noabort(=
),
this same race returns -EINPROGRESS instead of -EAGAIN for a command that w=
as
never dispatched.

[ ... ]

> +int cmh_tm_quiesce(void)
> +{
> +	unsigned long deadline;
> +	bool drained;
> +	u32 i;
> +
> +	cmh_tm_stop_and_drain_cmq();
> +
> +	/* Wait for in-flight TXQ transactions to complete via RH */
> +	if (!tm.txqs)
> +		return 0;
> +
> +	deadline =3D jiffies + msecs_to_jiffies(drain_timeout_ms);
> +	do {
> +		drained =3D true;
> +		for (i =3D 0; i < tm.cfg->mbx_count; i++) {
> +			if (READ_ONCE(tm.txqs[i].depth)) {
> +				drained =3D false;
> +				break;
> +			}
> +		}
> +		if (drained)
> +			return 0;
> +		usleep_range(1000, 2000);
> +	} while (time_before(jiffies, deadline));

[Severity: Medium]
Can cmh_tm_quiesce() return 0 while a mailbox FLUSH or RESTART recovery
command is still in flight on the device?

In cmh_rh_process_mbx(), the failed transaction is popped from txq before
cmh_rh_issue_flush() or MBX_COMMAND_RESTART is issued.  If no other
transactions were queued on that mailbox, tm.txqs[i].depth is already 0, so
cmh_tm_quiesce() returns 0 immediately and cmh_rh_suspend() stops the
watchdog and masks hardware interrupts before the eSW has acknowledged the
recovery command or reopened the closed mailbox.

Also, debugfs handlers cmh_rh_force_drain_mbx() and cmh_rh_abort_mbx() do
not check rh.active, so they can issue MMIO commands and close mailboxes
while the device is suspended.

[ ... ]

> +	left =3D wait_for_completion_timeout(&sync->done, timeout_hz);
> +	if (!left) {
> +		dev_err(cmh_dev(),
> +			"tm: submit_sync timeout (%lums) cmd=3D0x%08x\n",
> +			timeout_hz * 1000 / HZ, msg->command_id);
> +		if (cmh_tm_try_cancel_command(msg)) {
> +			/*
> +			 * Msg was still queued -- TM never saw it.
> +			 * Drop the callback ref (no txn will fire it)
> +			 * and free msg directly (sole owner).
> +			 */
> +			cmh_sync_ctx_put(sync);  /* no txn -> drop cb ref */
> +			cmh_sync_ctx_put(sync);  /* drop waiter ref */
> +			command_msg_put(msg);    /* matches refcount_set(2) */
> +			command_msg_put(msg);
> +		} else {
> +			/*
> +			 * TM has dequeued msg and the VCQ is in-flight.
> +			 * Issue MBX_COMMAND_ABORT to force-stop the VCQ;
> +			 * the RH will fire MBX_ERROR_IRQ, complete the
> +			 * transaction with -EIO, and issue RESTART.
> +			 *
> +			 * cmh_rh_abort_mbx() serialises the write under
> +			 * rh_process_lock, preventing clobber of a
> +			 * concurrent RESTART/FLUSH from the watchdog.
> +			 */
> +			s32 abrt_mbx =3D READ_ONCE(msg->actual_mbx);
> +
> +			/*
> +			 * Only ABORT if our VCQ is the one currently at the
> +			 * mailbox HEAD.  ABORT stops whatever executes at
> +			 * HEAD, so aborting while a different (older,
> +			 * possibly long-running) transaction is at HEAD would
> +			 * kill an unrelated request.  If ours is queued behind
> +			 * it, the HW has not started ours yet -- leave it to
> +			 * the completion wait / watchdog rather than abort
> +			 * someone else.
> +			 */
> +			if (abrt_mbx >=3D 0 &&
> +			    (u32)abrt_mbx < tm.cfg->mbx_count &&
> +			    cmh_rh_abort_mbx((u32)abrt_mbx,
> +					     READ_ONCE(msg->first_vcq_id)))
> +				dev_warn(cmh_dev(),
> +					 "tm: aborted mbx[%d] cmd=3D0x%08x\n",
> +					 abrt_mbx, msg->command_id);
> +
> +			/*
> +			 * Wait for the RH completion (ABORT triggers
> +			 * MBX_ERROR_IRQ within microseconds).  Fixed
> +			 * 5 s ceiling -- not configurable because if
> +			 * ABORT doesn't complete in this window the
> +			 * HW is wedged and more waiting won't help.
> +			 */
> +			left =3D wait_for_completion_timeout(&sync->done,
> +							   5 * HZ);
> +			if (!left) {
> +				/*
> +				 * ABORT did not complete within 5 s.  Unlike
> +				 * cmh_tm_submit_sync_noabort, this path sets no
> +				 * orphan_cb, so the caller frees its DMA buffers
> +				 * on the -ETIMEDOUT below.  This HW exposes no
> +				 * DMA-stop primitive, so where an ABORT cannot be
> +				 * issued or observed to complete the driver has
> +				 * no positive confirmation the engine has
> +				 * finished with those buffers.
> +				 */
> +				dev_err(cmh_dev(),
> +					"tm: abort timeout (5s) cmd=3D0x%08x - HW wedged\n",
> +					msg->command_id);
> +			}
> +			cmh_sync_ctx_put(sync);  /* drop waiter ref */
> +			command_msg_put(msg);    /* drop waiter ref on msg */
> +		}
> +		return -ETIMEDOUT;
> +	}

[Severity: High]
What happens when a synchronous submission in cmh_tm_submit_sync_tmo() times
out while queued behind an older transaction at R_MBX_QUEUE_HEAD, or after
HEAD has advanced to a later slot of a multi-VCQ submission?

cmh_rh_abort_mbx() only issues MBX_COMMAND_ABORT when R_MBX_QUEUE_HEAD
equals first_vcq_id.  Furthermore, neither cmh_tm_submit_sync_tmo() nor
cmh_tm_submit_sync_noabort() sets msg->timeout_jiffies or transitions
txn->state to TXN_TIMED_OUT, so the abort-stall detector in
cmh_rh_watchdog_fn() (which checks atomic_read(&head_txn->state) =3D=3D
TXN_TIMED_OUT) never triggers for synchronous transactions.  If the VCQ does
not finish within 5 seconds, cmh_tm_submit_sync_tmo() returns -ETIMEDOUT
while the VCQ remains active in the ring (allowing DMA access to input
buffers the caller unmaps and frees on return), and a stalled synchronous
VCQ at HEAD is never aborted or flushed by the watchdog, wedging the mailbox
and blocking suspend with -EBUSY.

[Severity: Medium]
Does cmh_tm_dma_quiescent() stay accurate when synchronous operations time
out or when a mailbox wedges with an empty transaction queue?

cmh_tm_dma_quiescent() only checks !READ_ONCE(tm.dma_live), which is only
set in cmh_txn_quarantine() when draining non-empty txq entries.  It is
never set when the 5-second abort wait in cmh_tm_submit_sync_tmo() expires
(!left), when buffers are quarantined via cmh_dma_quarantine_add() (from
cmh_dma_free_out(), cmh_tm_dma_quarantine_buf(), or cmh_dma_orphan_free()),
or when cmh_rh_flush_poll() marks a mailbox wedged after cmh_rh_process_mbx=
()
already popped the last transaction from txq.

Conversely, cmh_tm_submit_sync_tmo() returns -ETIMEDOUT even when
cmh_tm_try_cancel_command(msg) cancelled the command before dispatch or when
the 5-second post-abort wait succeeded (left > 0), causing callers of
cmh_dma_free_out() to quarantine output buffers that the device is known not
to touch.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-cmh-b4-a-v=
8-v8-0-4cea8ebc1d40@rambus.com?part=3D2
