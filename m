Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793045356;
	b=OC9Jjii9WtuLre+ZLtuxZxg4/ceCevI5Aq/I25ea6tex83Fow9jY/moxcLv2h3ZbFS55
	 q9wt2K5vE1Kur/bck4KtbVwHEycFUYY9OOqeISGubfnxzWx9mZilF2OTH41h4Y73qJl3k
	 vcvMM2G7tqHA4R5PxM0913N1rmVHpxQKzAJ29LvtzBwzvLFu+9K0byQE/VBVEqtP3veUW
	 8BwY+shmME5YmljqiF6h/4UZoUHB04CgUbmzO35ojsNVlXbK71mmS2BK3WlEsC54ct3S9
	 PCcGLtyvVjBxCCz2RDWoU2jWH8EnjiqqYJeW27sPTdFtS37dK0dBE5hjdJq/jYWRcaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793045356;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0hf+7Ar2O+3QhiEbe6ApFH5ryjfdfPpxWRr/iLt9AfY=;
	b=E6kACRe2IM6Hx89xf1/Dd0/fBDpzDolaV9CDwp0vuDBhM8W35wOxLyWhmpUe2P51bjiF
	 j6LggAKJCFGezA4jPthoDGC5FnmuaYPYu49U1NrwedAVSHJQTleD6604hLuIpSlQQuwRR
	 rR2i7THlWAPnPsl9N+SQGOOq7QLTzEskOe12VTRzne33ytp9ACgymLsfP4HIjVtlNsv1p
	 EBI6ektAi1h+tDizTOzDGQ1GgHtTcgouaxnj+fUVgoL9DMuSO5N8aLWpiEDfI6GoG8J6O
	 HEIbEBFy5yNw8daU95xATF/jriuWSBp+OZayC3QJrjy3kubzhEF/fXqRc8S3Cg8FyBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VusqJitq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2809F606A31D;
	Mon, 26 Oct 2026 20:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VusqJitq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173F71F01825;
	Mon, 26 Oct 2026 20:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793045355;
	bh=0hf+7Ar2O+3QhiEbe6ApFH5ryjfdfPpxWRr/iLt9AfY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VusqJitqUkRx58oaOLMWIyo721Iz+ZtJFfWNo7IJ+QebhK8Y4iHSpSe+7D2KTmEL4
	 K+wsot8HQnHeUx/aBYy50YrIU49nOYL3nUYQCPVFOP6ojpg+u8Qzz71OR0jDxpfIra
	 pS33btz08sX6JvVMFyZdjfMV/ZohyugJ5OJgeYuVviIy0LAwlD8YXTKer/IBh9qSw0
	 VAEDQNgl+gjB4tgY8+ccxkt3MlUGpZWjDPsi5WMYjsp2CgrJsG1RQzR3cWqc5XpROC
	 OVBn5mF5uxCMHQIl7evy0u389N0aJNjf1tZEgn+gqwooh87wFJQliKWMpzdMO9o3Mq
	 SW0aGWbG87FBg==
Message-ID: <sashiko-outbox-185703@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 2/5] crypto: cmh - add core platform driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alex Ousherovitch" <aousherovitch@rambus.com>, "Saravanakrishnan
 Krishnamoorthy" <skrishnamoorthy@rambus.com>, "Joel Wittenauer" <Joel.Wittenauer@cryptography.com>, "Thi
 Nguyen" <thin@rambus.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20261026-cmh-b4-a-v7-v7-2-500a83faf500@rambus.com>
References: <20261026-cmh-b4-a-v7-v7-0-500a83faf500@rambus.com>
 <20261026-cmh-b4-a-v7-v7-2-500a83faf500@rambus.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 20:09:14 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 13 potential issue=
(s) to consider:
- [Critical] crypto: cmh - uncancelled and unaborted sync timeouts in cmh_t=
xn.c
- [Critical] crypto: cmh - duplicate MBX_ERROR_IRQ processing in cmh_rh_thr=
ead()
- [Critical] crypto: cmh - MBX_COMMAND_FLUSH clobbered by RESTART in cmh_rh=
.c
- [Critical] crypto: cmh - race between submit_vcq() and cmh_rh_drain_mbx()
- [High] crypto: cmh - premature backlog promotion in cmh_tm_thread()
- [High] crypto: cmh - cmh_rh_hardirq() clears R_MBX_INTERRUPT across all m=
ailboxes
- [High] crypto: cmh - cmh_remove() frees DMA buffers before cmh_mqi_cleanu=
p() flush
- [High] crypto: cmh - cmh_tm_quiesce() cancels in-flight txns without flus=
hing HW
- [High] crypto: cmh: missing -EINPROGRESS notification when draining backl=
og
- [Medium] crypto: cmh - of_irq_get() 0 return treated as valid IRQ in cmh_=
config_init()
- [Medium] crypto: cmh - unlocked rh.mbx check in cmh_rh_abort_mbx() races =
teardown
- [Medium] crypto: cmh - dangling dbgfs.config pointer after cmh_debugfs_cl=
eanup()
- [Low] crypto: cmh - missing stub for cmh_debugfs_config_u32() in cmh_debu=
gfs.h
--

commit fafcc004ae237081d15795f4adc63a0fe4baf892
Author: Alex Ousherovitch <aousherovitch@rambus.com>

crypto: cmh - add core platform driver

This commit adds the Rambus CryptoManager Hub (CMH) hardware crypto
accelerator core platform driver, including mailbox queue initialization,
transaction management, threaded-IRQ response handling, DMA helpers, sysfs,
and debugfs support.

> diff --git a/drivers/crypto/cmh/cmh_config.c b/drivers/crypto/cmh/cmh_con=
fig.c
> new file mode 100644
> index 0000000000000..2ef588a3fcb19
> --- /dev/null
> +++ b/drivers/crypto/cmh/cmh_config.c

[ ... ]

> +int cmh_config_init(struct cmh_config *cfg, struct platform_device *pdev)
> +{

[ ... ]

> +		/* Optional per-mailbox interrupt (absent =3D> polling). */
> +		m->irq =3D of_irq_get(child, 0);
> +		if (m->irq =3D=3D -EPROBE_DEFER) {
> +			of_node_put(child);
> +			return -EPROBE_DEFER;
> +		}
> +		if (m->irq < 0)
> +			m->irq =3D -1;

[Severity: Medium]
What happens if of_irq_get() returns 0 on an IRQ mapping failure?

Because of_irq_get() returns 0 (NO_IRQ) when irq_create_of_mapping() fails,
checking only m->irq < 0 leaves m->irq =3D=3D 0. Later, cmh_rh_resolve_irqs=
()
checks cfg->mailboxes[i].irq >=3D 0, treating 0 as a valid Linux IRQ and
passing it to request_threaded_irq(0, ...) in cmh_rh_init(), which fails
probe with -EINVAL instead of falling back to polling or handling the
mapping failure.

Should cmh_config_init() treat m->irq <=3D 0 as no interrupt (or an error),
and cmh_rh_resolve_irqs() check irq > 0?

> diff --git a/drivers/crypto/cmh/cmh_debugfs.c b/drivers/crypto/cmh/cmh_de=
bugfs.c
> new file mode 100644
> index 0000000000000..8cdfb8c47dd6a
> --- /dev/null
> +++ b/drivers/crypto/cmh/cmh_debugfs.c

[ ... ]

> +void cmh_debugfs_init(struct cmh_config *cfg)
> +{
> +	u32 mbx_count =3D cfg->mbx_count;
> +	u32 i;
> +
> +	dbgfs.root =3D debugfs_create_dir("cmh", NULL);
> +	if (IS_ERR_OR_NULL(dbgfs.root)) {
> +		if (!IS_ERR(dbgfs.root))
> +			dev_warn(cmh_dev(), "debugfs: creation returned NULL -- counters disa=
bled\n");
> +		else
> +			dev_warn(cmh_dev(), "debugfs: creation failed (rc=3D%ld) -- counters =
disabled\n",
> +				 PTR_ERR(dbgfs.root));
> +		dbgfs.root =3D NULL;
> +		return;  /* debugfs is optional -- never fail module init */
> +	}
> +
> +	dbgfs.mbx_count =3D mbx_count;
> +	dbgfs.cfg =3D cfg;
> +	dbgfs.mbx =3D kcalloc(mbx_count, sizeof(*dbgfs.mbx), GFP_KERNEL);
> +	if (!dbgfs.mbx) {
> +		debugfs_remove_recursive(dbgfs.root);
> +		dbgfs.root =3D NULL;
> +		return;
> +	}

[ ... ]

> +void cmh_debugfs_cleanup(void)
> +{
> +	debugfs_remove_recursive(dbgfs.root);
> +	dbgfs.root =3D NULL;
> +	kfree(dbgfs.mbx);
> +	dbgfs.mbx =3D NULL;
> +	dev_dbg(cmh_dev(), "debugfs: cleaned up\n");
> +}
> +
> +/**
> + * cmh_debugfs_config_u32() - Publish a subsystem tunable in config/
> + * @name: debugfs file name
> + * @val:  pointer to the u32 tunable (must outlive the debugfs tree)
> + *
> + * Lets a subsystem (e.g. the hwrng) register its own runtime tunable in
> + * the shared config/ directory as it comes up, so this core debugfs file
> + * never references per-algorithm symbols -- each algorithm driver stays
> + * self-contained.  A no-op if debugfs is unavailable.
> + */
> +void cmh_debugfs_config_u32(const char *name, u32 *val)
> +{
> +	if (dbgfs.config)
> +		debugfs_create_u32(name, 0644, dbgfs.config, val);
> +}

[Severity: Medium]
Does cmh_debugfs_cleanup() leave a dangling dentry pointer in dbgfs.config
and a dangling config pointer in dbgfs.cfg?

debugfs_remove_recursive(dbgfs.root) frees the child dbgfs.config dentry
along with dbgfs.root, but cmh_debugfs_cleanup() only clears dbgfs.root and
dbgfs.mbx, leaving dbgfs.config, dbgfs.cfg, and dbgfs.mbx_count populated
(and the kcalloc failure path in cmh_debugfs_init() likewise leaves
dbgfs.cfg and dbgfs.mbx_count set).

If a subsequent probe fails in cmh_debugfs_init() before create_config_dir()
runs, dbgfs.config still points to the freed dentry from the prior instance,
so any call to cmh_debugfs_config_u32() will pass that freed dentry to
debugfs_create_u32().

> diff --git a/drivers/crypto/cmh/cmh_main.c b/drivers/crypto/cmh/cmh_main.c
> new file mode 100644
> index 0000000000000..16e80a7f403f8
> --- /dev/null
> +++ b/drivers/crypto/cmh/cmh_main.c

[ ... ]

> +static void cmh_remove(struct platform_device *pdev)
> +{
> +	struct cmh_device *dev =3D platform_get_drvdata(pdev);
> +	struct cmh_config *cfg;
> +
> +	if (!dev)
> +		return;
> +
> +	cfg =3D &dev->config;
> +
> +	cmh_rh_cleanup(cfg);
> +	cmh_tm_cleanup();
> +	cmh_mqi_cleanup(cfg);
> +	cmh_debugfs_cleanup();
> +	cmh_dma_cleanup();
> +}

[Severity: High]
In cmh_remove(), can calling cmh_tm_cleanup() before cmh_mqi_cleanup(cfg)
unmap and free DMA buffers while the hardware mailboxes are still running?

cmh_rh_cleanup(cfg) masks interrupts and frees the IRQ handlers, but leaves
each mailbox in MBX_COMMAND_RUN state. Next, cmh_tm_cleanup() force-complet=
es
all transactions in tm.txqs (causing completion callbacks to unmap and free
per-request DMA buffers) and calls cmh_dma_reclaim_parked() (which unmaps
and frees all parked orphan DMA buffers).

Only after those DMA buffers have been freed does cmh_mqi_cleanup(cfg) ->
cmh_mbx_teardown_one() write MBX_COMMAND_FLUSH to R_MBX_COMMAND and poll for
the eSW to finish flushing the mailboxes. Should the mailboxes be flushed
before cmh_tm_cleanup() unmaps and frees the in-flight and parked DMA
buffers?

> diff --git a/drivers/crypto/cmh/cmh_rh.c b/drivers/crypto/cmh/cmh_rh.c
> new file mode 100644
> index 0000000000000..dbe4a85b7ec4c
> --- /dev/null
> +++ b/drivers/crypto/cmh/cmh_rh.c

[ ... ]

> +void cmh_rh_abort_mbx(u32 mbx_idx)
> +{
> +	void __iomem *base;
> +
> +	if (!rh.cfg || !rh.mbx || mbx_idx >=3D rh.cfg->mbx_count)
> +		return;
> +
> +	base =3D rh.cfg->mailboxes[mbx_idx].reg_base;
> +
> +	spin_lock_bh(&rh_process_lock);
> +	cmh_reg_write32(MBX_COMMAND_ABORT, base, R_MBX_COMMAND);
> +	spin_unlock_bh(&rh_process_lock);
> +}

[Severity: Medium]
Unlike cmh_rh_force_drain_mbx() right above it, cmh_rh_abort_mbx() checks
rh.cfg and rh.mbx outside rh_process_lock.

Because cmh_remove() and the cmh_probe() error path tear down RH, TM, and
MQI before calling cmh_debugfs_cleanup(), can a concurrent write to the
debugfs inject_abort file pass the unlocked check just before
cmh_rh_cleanup() sets rh.mbx =3D NULL, and then write MBX_COMMAND_ABORT to
R_MBX_COMMAND after the mailbox has been torn down and unlocked?

> +static struct timer_list rh_watchdog;
> +
> +/*
> + * Hardirq handler -- runs with interrupts disabled.
> + *
> + * Read and W1C-clear R_MBX_INTERRUPT for each mailbox.
> + * If any MBX had a pending interrupt, return IRQ_WAKE_THREAD.
> + * Shared-IRQ safe: returns IRQ_NONE if we didn't handle anything.
> + */
> +static irqreturn_t cmh_rh_hardirq(int irq, void *data)
> +{
> +	struct cmh_config *cfg =3D data;
> +	bool handled =3D false;
> +	u32 i;
> +
> +	for (i =3D 0; i < cfg->mbx_count; i++) {
> +		void __iomem *base =3D cfg->mailboxes[i].reg_base;
> +		u32 bits;
> +
> +		bits =3D cmh_reg_read32(base, R_MBX_INTERRUPT);
> +		if (!bits)
> +			continue;
> +
> +		/* W1C: write back the set bits to clear them */
> +		cmh_reg_write32(bits, base, R_MBX_INTERRUPT);

[Severity: High]
When multiple mailboxes have distinct IRQ lines (rh.nirqs > 1), what happens
when cmh_rh_hardirq() ignores the irq parameter and W1C-clears
R_MBX_INTERRUPT on every mailbox?

If mailbox 0 and mailbox 1 both assert their separate interrupt lines at the
same time, the hardirq handler for mailbox 0's IRQ line will clear
R_MBX_INTERRUPT on both mailbox 0 and mailbox 1. When the hardirq handler
for mailbox 1's IRQ line runs, it will read 0 from R_MBX_INTERRUPT on all
mailboxes and return IRQ_NONE, which can trip the kernel's spurious IRQ
detector ("nobody cared") and disable mailbox 1's interrupt line.

Should cmh_rh_hardirq() only inspect and W1C-clear mailboxes whose
configured irq matches the irq argument?

[ ... ]

> +static void cmh_rh_process_mbx(u32 mbx_idx, u32 new_head, u32 irq_bits)
> +{

[ ... ]

> +		txn =3D cmh_tm_peek_transaction(mbx_idx);
> +		if (txn && txn->first_vcq_id !=3D txn->last_vcq_id) {
> +			dev_warn_ratelimited(cmh_dev(),
> +					     "rh: mbx[%u] multi-VCQ error vcq=3D%u..%u -- FLUSH+drain\n",
> +					     mbx_idx, txn->first_vcq_id,
> +					     txn->last_vcq_id);
> +			cmh_rh_stat_inc_errors(mbx_idx);
> +			cmh_reg_write32(MBX_IRQ_MASK, base, R_MBX_INTERRUPT);
> +			cmh_reg_write32(MBX_COMMAND_FLUSH, base, R_MBX_COMMAND);
> +			cmh_rh_poke_tail(base);
> +			cmh_rh_drain_mbx(mbx_idx, error);
> +			return;
> +		}

[Severity: Critical]
When a multi-VCQ transaction fails here (or when cmh_rh_watchdog_fn()
escalates a timed-out RESTART to MBX_COMMAND_FLUSH), can the asynchronous
MBX_COMMAND_FLUSH get immediately overwritten by MBX_COMMAND_RESTART?

In cmh_rh_process_mbx():
1. For a multi-VCQ error, it writes MBX_COMMAND_FLUSH to R_MBX_COMMAND,
   calls cmh_rh_drain_mbx() (which completes all queued transactions, frees
   their DMA buffers, and updates rh.mbx[mbx_idx].last_head to the hardware
   HEAD), and returns without setting rh.mbx[mbx_idx].restart_pending.
2. All three callers of cmh_rh_process_mbx() (both loops in cmh_rh_thread()
   and cmh_rh_watchdog_fn()) then execute:

       cmh_rh_process_mbx(i, new_head, ...);
       rh.mbx[i].last_head =3D new_head;

   overwriting the post-drain last_head with the stale pre-flush new_head.
3. When this runs from the first loop of cmh_rh_thread(), execution
   immediately enters the final hardware poll loop in cmh_rh_thread().
   Because the eSW processes MBX_COMMAND_FLUSH asynchronously, R_MBX_STATUS
   still reports MBX_STATUS_ERROR and restart_pending is false. The final
   poll loop therefore sets poll_irq_bits =3D MBX_ERROR_IRQ and calls
   cmh_rh_process_mbx() a second time on the now-empty queue, which falls
   through to the single-VCQ path and writes MBX_COMMAND_RESTART to
   R_MBX_COMMAND.

As the comment just above notes, RESTART only advances HEAD by one slot
instead of discarding the queue, so clobbering FLUSH with RESTART causes the
eSW to execute the remaining slots of the multi-VCQ transaction whose DMA
buffers were just freed by cmh_rh_drain_mbx(). The same issue occurs in
cmh_rh_watchdog_fn() when restart_retries exceeds CMH_RH_RESTART_MAX_RETRIE=
S,
because it clears restart_pending immediately after writing
MBX_COMMAND_FLUSH.

> +
> +		/* Now pop and fail the transaction that actually errored */
> +		txn =3D cmh_tm_pop_transaction(mbx_idx);
> +		if (txn) {
> +			dev_dbg(cmh_dev(), "rh: mbx[%u] error-complete vcq=3D%u..%u\n",
> +				mbx_idx, txn->first_vcq_id,
> +				txn->last_vcq_id);
> +			cmh_txn_finish(txn, error);
> +			cmh_tm_txq_completion_notify();
> +		} else {

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
> +
> +			/*
> +			 * Clear @pending before consuming @irq_bits so a
> +			 * hardirq landing between the two does not have its
> +			 * freshly-set @pending cleared and its bits stranded.
> +			 * The xchg is a full barrier and captures any bits the
> +			 * hardirq ORs in; @pending then stays set and the outer
> +			 * loop rescans this mailbox.
> +			 */
> +			WRITE_ONCE(rh.mbx[i].pending, false);
> +			irq_bits =3D (u32)atomic_xchg(&rh.mbx[i].irq_bits, 0);
> +
> +			spin_lock_bh(&rh_process_lock);
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

[Severity: Critical]
Can a single hardware mailbox error be processed twice between
cmh_rh_hardirq()/cmh_rh_thread() and the status-polling paths in
cmh_rh_watchdog_fn() or cmh_rh_thread()'s final poll loop?

Consider this sequence when a VCQ fails in hardware:
1. The eSW sets MBX_ERROR_IRQ in R_MBX_INTERRUPT and sets R_MBX_STATUS to
   MBX_STATUS_ERROR.
2. cmh_rh_hardirq() W1C-clears R_MBX_INTERRUPT, ORs MBX_ERROR_IRQ into
   rh.mbx[i].irq_bits, and sets rh.mbx[i].pending =3D true.
3. Before cmh_rh_thread()'s first loop acquires rh_process_lock (or while
   cmh_rh_thread() is in its final poll loop when cmh_rh_hardirq() fires on
   another CPU), cmh_rh_watchdog_fn() or the final poll loop acquires
   rh_process_lock, sees MBX_STATUS_CODE(status) =3D=3D MBX_STATUS_ERROR wi=
th
   restart_pending =3D=3D false, synthesizes MBX_ERROR_IRQ, and calls
   cmh_rh_process_mbx(i, new_head, MBX_ERROR_IRQ).
4. cmh_rh_process_mbx() pops the failed transaction, completes it with -EIO,
   writes MBX_COMMAND_RESTART, and sets rh.mbx[i].restart_pending =3D true,
   without clearing rh.mbx[i].irq_bits or rh.mbx[i].pending.
5. When cmh_rh_thread()'s primary loop runs next, it consumes the latched
   MBX_ERROR_IRQ from rh.mbx[i].irq_bits, does not check rh.mbx[i].wedged or
   rh.mbx[i].restart_pending, and calls cmh_rh_process_mbx(i, new_head,
   MBX_ERROR_IRQ) a second time for the same error.

Because cmh_rh_process_mbx() unconditionally pops the head of txq without
checking whether txn->first_vcq_id <=3D new_head, this second call pops and
fails the next innocent in-flight transaction with -EIO (unmapping and
freeing its DMA buffers) just as the eSW processes MBX_COMMAND_RESTART and
starts executing that transaction's VCQ.

> diff --git a/drivers/crypto/cmh/cmh_txn.c b/drivers/crypto/cmh/cmh_txn.c
> new file mode 100644
> index 0000000000000..5944c17b4da39
> --- /dev/null
> +++ b/drivers/crypto/cmh/cmh_txn.c

[ ... ]

> +static int submit_vcq(struct command_msg *msg, u32 mbx_idx)
> +{

[ ... ]

> +	if (msg->timeout_jiffies)
> +		refcount_set(&txn->refs, 2);
> +	else
> +		refcount_set(&txn->refs, 1);
> +
> +	/* Enqueue transaction under spinlock */
> +	spin_lock_irqsave(&txq->lock, flags);
> +	list_add_tail(&txn->list, &txq->head);
> +	txq->depth++;
> +	spin_unlock_irqrestore(&txq->lock, flags);
> +
> +	/*
> +	 * Arm the per-request timeout BEFORE the doorbell (async only): once
> +	 * the doorbell rings, HW can complete and the TXQ can pop and free the
> +	 * txn concurrently, so arming afterwards races that free and can leave
> +	 * timer_delete() in cmh_txn_finish() unable to drop the timer ref.
> +	 */
> +	if (msg->timeout_jiffies)
> +		mod_timer(&txn->timeout_timer,
> +			  jiffies + msg->timeout_jiffies);
> +
> +	/*
> +	 * Ring doorbell: advance tail by number of VCQs submitted.
> +	 * Serialise against cmh_tm_poke_tail() so a concurrent re-poke
> +	 * cannot roll TAIL back over this advance.
> +	 */
> +	spin_lock_irqsave(&cmh_mbx_tail_lock, flags);
> +	cmh_reg_write32(tail + num_vcqs, mbx->reg_base, R_MBX_QUEUE_TAIL);
> +	spin_unlock_irqrestore(&cmh_mbx_tail_lock, flags);
> +
> +	mutex_unlock(&txq->dispatch_lock);

[Severity: Critical]
Can submit_vcq() race with cmh_rh_drain_mbx() after txq->lock is dropped
here?

submit_vcq() holds only txq->dispatch_lock, while cmh_rh_drain_mbx() (called
on multi-VCQ error, watchdog FLUSH/abort-stall escalation, or debugfs
force_drain) holds only rh_process_lock. Once txn is added to txq->head and
txq->lock is released:
1. cmh_rh_drain_mbx() can pop txn from txq->head and call cmh_txn_finish()
   before mod_timer() and the R_MBX_QUEUE_TAIL doorbell write execute.
2. In cmh_txn_finish(), timer_delete(&txn->timeout_timer) returns false
   because mod_timer() has not run yet, so the timer reference is not
   dropped; for transactions with msg->timeout_jiffies =3D=3D 0 (refs =3D=
=3D 1),
   cmh_txn_finish() frees txn immediately. In both cases txn->complete()
   fires and unmaps/frees the caller's DMA buffers.
3. submit_vcq() then calls mod_timer(&txn->timeout_timer, ...) on the
   already-completed (or freed) txn, leaving an active timer on a dequeued
   transaction, and writes tail + num_vcqs to R_MBX_QUEUE_TAIL so the
   hardware executes a VCQ whose DMA buffers were already freed.

> +
> +	cmh_stat_record_vcq_submit(mbx_idx, num_vcqs, txq->depth);
> +
> +	dev_dbg(cmh_dev(), "tm: submitted %u vcq(s) id=3D%u..%u to mbx[%u] tail=
_now=3D%u\n",
> +		num_vcqs, tail, tail + num_vcqs - 1, mbx_idx,
> +		 tail + num_vcqs);
> +
> +	return 0;
> +}
> +
> +/* TM Thread */
> +
> +static int cmh_tm_thread(void *data)
> +{
> +	struct command_msg *msg, *bl_promoted;
> +	unsigned long flags;
> +	int mbx_idx, ret;
> +
> +	while (!kthread_should_stop()) {
> +		/* Wait for work or stop signal */
> +		wait_event_interruptible(tm.cmq_waitq,
> +					 !list_empty(&tm.cmq) || kthread_should_stop());
> +
> +		if (kthread_should_stop())
> +			break;
> +
> +		/* Dequeue one command message */
> +		spin_lock_irqsave(&tm.cmq_lock, flags);
> +		if (list_empty(&tm.cmq)) {
> +			spin_unlock_irqrestore(&tm.cmq_lock, flags);
> +			continue;
> +		}
> +		msg =3D list_first_entry(&tm.cmq, struct command_msg, list);
> +		list_del_init(&msg->list);
> +		cmq_depth--;
> +
> +		/*
> +		 * Promote one backlogged request into the CMQ now that
> +		 * there is room.  The -EINPROGRESS notification is deferred
> +		 * until after cmq_lock is dropped (below).
> +		 */
> +		bl_promoted =3D NULL;
> +		if (!list_empty(&tm.backlog)) {
> +			bl_promoted =3D list_first_entry(&tm.backlog,
> +						       struct command_msg, list);
> +			list_move_tail(&bl_promoted->list, &tm.cmq);
> +			tm.backlog_depth--;
> +			cmq_depth++;
> +			cmh_stat_record_cmq_post(cmq_depth);
> +		}
> +
> +		spin_unlock_irqrestore(&tm.cmq_lock, flags);
> +
> +		/*
> +		 * Signal -EINPROGRESS for the promoted backlog request with
> +		 * cmq_lock dropped: a consumer that resubmits from this
> +		 * callback would otherwise re-enter cmq_lock and self-deadlock.
> +		 * The promoted msg stays on the CMQ (only this thread dequeues
> +		 * it) until a later iteration, so the -EINPROGRESS still
> +		 * precedes its final completion.
> +		 */
> +		if (bl_promoted && bl_promoted->complete)
> +			bl_promoted->complete(bl_promoted->completion_data,
> +					      -EINPROGRESS);
> +
> +		/* Select a mailbox: pinned or round-robin */
> +		mbx_idx =3D resolve_mbx(msg);

[ ... ]

> +		if (mbx_idx < 0) {
> +			/*
> +			 * Queue full -- re-enqueue at front and wait.
> +			 *
> +			 * Sleep on cmq_waitq with a short timeout.  The RH
> +			 * calls cmh_tm_txq_completion_notify() after each
> +			 * completed transaction, which bumps the generation
> +			 * counter and wakes us immediately.  The timeout is
> +			 * a safety net for missed wakeups.
> +			 */
> +			int gen =3D atomic_read(&txq_completion_gen);
> +			unsigned long tmo;
> +
> +			spin_lock_irqsave(&tm.cmq_lock, flags);
> +			list_add(&msg->list, &tm.cmq);
> +			cmq_depth++;
> +			spin_unlock_irqrestore(&tm.cmq_lock, flags);

[Severity: High]
What happens to cmq_depth and tm.backlog when resolve_mbx(msg) returns
-EAGAIN?

Before calling resolve_mbx(msg), cmh_tm_thread() pops msg (cmq_depth--),
unconditionally promotes a request from tm.backlog into tm.cmq (cmq_depth++)
without checking cmq_depth < cmq_max_depth, and invokes its completion
callback with -EINPROGRESS. When all eligible mailboxes are full and
resolve_mbx(msg) returns -EAGAIN, msg is pushed back onto the front of
tm.cmq and cmq_depth is incremented again.

On each subsequent 500 us backoff wakeup (or completion wakeup from another
mailbox while msg is pinned), cmh_tm_thread() pops msg again, promotes
another entry from tm.backlog into tm.cmq, fires -EINPROGRESS (allowing
throttled callers such as dm-crypt to submit more requests into tm.backlog),
and re-adds msg to tm.cmq, growing tm.cmq without bound past cmq_max_depth.

Also, if queued entries in tm.cmq are cancelled via
cmh_tm_try_cancel_command() (or cmq_max_depth is set to 0 via debugfs) while
tm.backlog is non-empty, cmh_tm_thread() only waits on !list_empty(&tm.cmq),
leaving tm.backlog stranded. Should backlog promotion happen only after msg
is actually dispatched (or when cmq_depth < cmq_max_depth)?

[ ... ]

> +static void cmh_tm_stop_and_drain_cmq(void)
> +{

[ ... ]

> +	for (;;) {
> +		spin_lock_irqsave(&tm.cmq_lock, flags);
> +		msg =3D list_first_entry_or_null(&tm.backlog, struct command_msg,
> +					       list);
> +		if (msg) {
> +			list_del_init(&msg->list);
> +			tm.backlog_depth--;
> +		}
> +		spin_unlock_irqrestore(&tm.cmq_lock, flags);
> +		if (!msg)
> +			break;
> +		if (msg->complete)
> +			msg->complete(msg->completion_data, -ECANCELED);
> +		command_msg_put(msg);
> +	}
> +}

[Severity: High]
When draining tm.backlog here, does msg->complete() need to be called with
-EINPROGRESS before -ECANCELED?

Requests on tm.backlog returned -EBUSY from cmh_tm_post_command() and have
not yet received their initial -EINPROGRESS notification from
cmh_tm_thread(). Crypto API callers that use CRYPTO_TFM_REQ_MAY_BACKLOG
(such as dm-crypt and dm-integrity) block in wait_for_completion() waiting
specifically for the callback with err =3D=3D -EINPROGRESS before continuin=
g;
completing a backlogged request only once with -ECANCELED leaves those
waiters hung in TASK_UNINTERRUPTIBLE.

[ ... ]

> +void cmh_tm_quiesce(void)
> +{

[ ... ]

> +	if (!drained) {
> +		dev_warn(cmh_dev(),
> +			 "tm: quiesce drain timeout (%u ms), cancelling remaining transaction=
s\n",
> +			 drain_timeout_ms);
> +		/*
> +		 * The drain timed out, so the RH is no longer making
> +		 * progress.  Quiesce it first -- cmh_rh_suspend() stops the
> +		 * watchdog, masks the MBX interrupts and synchronize_irq()s
> +		 * out any in-flight handler -- so the force-cancel below owns
> +		 * every remaining transaction exclusively.  Without this a
> +		 * live RH could concurrently finish/txn_put a transaction we
> +		 * are cancelling here (suspend runs cmh_tm_quiesce() before
> +		 * cmh_rh_suspend()).  cmh_rh_suspend() is idempotent, so the
> +		 * caller's later call is a no-op.
> +		 */
> +		cmh_rh_suspend(tm.cfg);
> +
> +		/*
> +		 * Force-cancelling with -ECANCELED/-ETIMEDOUT parks any
> +		 * abnormally-completed DRBG orphan buffer (see
> +		 * cmh_dma_orphan_free()).  Parked buffers are NOT reclaimed on
> +		 * suspend -- the eSW may still be powered/writing -- so they
> +		 * persist across resume and are freed only at module unload.
> +		 */
> +		for (i =3D 0; i < tm.cfg->mbx_count; i++) {
> +			LIST_HEAD(drain);
> +			int old;
> +
> +			spin_lock_irqsave(&tm.txqs[i].lock, flags);
> +			list_splice_init(&tm.txqs[i].head, &drain);
> +			tm.txqs[i].depth =3D 0;
> +			spin_unlock_irqrestore(&tm.txqs[i].lock, flags);
> +
> +			list_for_each_entry_safe(txn, tmp_txn, &drain, list) {
> +				list_del(&txn->list);
> +
> +				if (timer_delete_sync(&txn->timeout_timer))
> +					txn_put(txn);
> +
> +				old =3D atomic_cmpxchg(&txn->state,
> +						     TXN_INFLIGHT,
> +						     TXN_COMPLETE);
> +				if (txn->complete) {
> +					if (old =3D=3D TXN_INFLIGHT)
> +						txn->complete(txn->completion_data,
> +							      -ECANCELED);
> +					else if (old =3D=3D TXN_TIMED_OUT)
> +						txn->complete(txn->completion_data,
> +							      -ETIMEDOUT);
> +				}
> +
> +				txn_put(txn);
> +			}
> +		}
> +	}
> +}

[Severity: High]
When drain_timeout_ms expires during system suspend in cmh_tm_quiesce(), is
it safe to force-complete in-flight transactions without issuing
MBX_COMMAND_FLUSH to the hardware mailboxes?

For async crypto requests, invoking txn->complete() causes the caller to
immediately unmap and free its per-request DMA buffers, while the CMH island
remains powered across suspend-to-idle and the eSW continues executing the
un-flushed VCQs against those freed buffers. In addition, on resume,
cmh_rh_resume() re-syncs last_head and re-enables interrupts without
checking R_MBX_STATUS or flushing pre-suspend VCQs, so a pre-suspend VCQ
that errors while interrupts were masked (or after resume) will cause
cmh_rh_process_mbx() to pop and fail a newly submitted post-resume
transaction.

[ ... ]

> +int cmh_tm_submit_sync_tmo(struct vcq_cmd *vcq_cmds, u32 vcq_count,
> +			   u32 num_vcqs, s32 target_mbx,
> +			   unsigned long timeout_hz)
> +{

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
> +			    (u32)abrt_mbx < tm.cfg->mbx_count) {
> +				void __iomem *abase =3D
> +					tm.cfg->mailboxes[abrt_mbx].reg_base;
> +				u32 head =3D cmh_reg_read32(abase,
> +							  R_MBX_QUEUE_HEAD);
> +
> +				if (READ_ONCE(msg->first_vcq_id) =3D=3D head) {
> +					dev_warn(cmh_dev(),
> +						 "tm: aborting mbx[%d] cmd=3D0x%08x\n",
> +						 abrt_mbx, msg->command_id);
> +					cmh_rh_abort_mbx((u32)abrt_mbx);
> +				}
> +			}
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

[Severity: Critical]
Can a synchronous submission in cmh_tm_submit_sync_tmo() or
cmh_tm_submit_sync_noabort() fail to cancel or abort on timeout while the
VCQ is still queued, leading to hardware DMA against freed caller buffers or
a permanently wedged mailbox?

There are three related cases here:
1. In cmh_tm_thread(), msg is removed from tm.cmq with
   list_del_init(&msg->list) and tm.cmq_lock is dropped before
   resolve_mbx(msg) runs; if resolve_mbx(msg) returns -EAGAIN, msg is
   re-added to tm.cmq. If wait_for_completion_timeout() expires during that
   unlocked window, cmh_tm_try_cancel_command(msg) sees
   list_empty(&msg->list) and returns false, after which cmh_tm_thread()
   puts msg back on tm.cmq. cmh_tm_submit_sync_noabort() then returns
   -EINPROGRESS while msg is still in tm.cmq, and cmh_tm_submit_sync_tmo()
   sees abrt_mbx =3D=3D -1, skips cmh_rh_abort_mbx(), and returns -ETIMEDOUT
   after 5s while msg remains queued.
2. When msg has been submitted to a mailbox (abrt_mbx >=3D 0),
   cmh_tm_submit_sync_tmo() only calls cmh_rh_abort_mbx() if
   READ_ONCE(msg->first_vcq_id) =3D=3D head. If msg is queued behind a slow
   operation (for example, a 300s slow_op_timeout_ms operation at head while
   msg has a 2s vcq_timeout_ms, so head < msg->first_vcq_id), or if msg is a
   multi-VCQ submission stalled on a subsequent VCQ slot (head >
   msg->first_vcq_id), cmh_rh_abort_mbx() is skipped. After 5s,
   cmh_tm_submit_sync_tmo() returns -ETIMEDOUT and the caller unmaps and
   frees its DMA buffers (including DMA_TO_DEVICE input buffers that are
   never parked), after which the hardware executes msg's VCQ against freed
   memory.
3. Both cmh_tm_submit_sync_tmo() and cmh_tm_submit_sync_noabort() leave
   msg->timeout_jiffies =3D=3D 0, so submit_vcq() never arms txn->timeout_t=
imer
   and txn->state stays TXN_INFLIGHT forever. Because the abort-stall
   detector in cmh_rh_watchdog_fn() only triggers when
   atomic_read(&head_txn->state) =3D=3D TXN_TIMED_OUT, the watchdog will ne=
ver
   recover a synchronous transaction (such as an abandoned noabort VCQ) that
   stalls at the head of a mailbox.

> diff --git a/drivers/crypto/cmh/include/cmh_debugfs.h b/drivers/crypto/cm=
h/include/cmh_debugfs.h
> new file mode 100644
> index 0000000000000..5bcc00f240998
> --- /dev/null
> +++ b/drivers/crypto/cmh/include/cmh_debugfs.h

[ ... ]

> +#ifdef CONFIG_CRYPTO_DEV_CMH_DEBUG
> +
> +void cmh_debugfs_init(struct cmh_config *cfg);
> +void cmh_debugfs_cleanup(void);
> +
> +/* Publish a subsystem's u32 tunable in the shared config/ dir. */
> +void cmh_debugfs_config_u32(const char *name, u32 *val);
> +
> +struct cmh_mbx_stats *cmh_debugfs_mbx_stats(u32 mbx_idx);
> +struct cmh_tm_stats  *cmh_debugfs_tm_stats(void);
> +
> +#else /* !CONFIG_CRYPTO_DEV_CMH_DEBUG */
> +
> +static inline void cmh_debugfs_init(struct cmh_config *c) { }
> +static inline void cmh_debugfs_cleanup(void) {}
> +static inline struct cmh_mbx_stats *cmh_debugfs_mbx_stats(u32 i) { retur=
n NULL; }
> +static inline struct cmh_tm_stats  *cmh_debugfs_tm_stats(void)   { retur=
n NULL; }
> +
> +#endif /* CONFIG_CRYPTO_DEV_CMH_DEBUG */

[Severity: Low]
Is a static inline stub for cmh_debugfs_config_u32() missing in the
!CONFIG_CRYPTO_DEV_CMH_DEBUG branch so callers compile when debugfs support
is disabled?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026-cmh-b4-a-v=
7-v7-0-500a83faf500@rambus.com?part=3D2
