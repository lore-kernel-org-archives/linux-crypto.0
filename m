From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: set_cpus_allowed_ptr() usage in FREESCALE CAAM
Date: Fri, 5 Oct 2018 14:54:44 +0200
Message-ID: <20181005125443.dfhd2asqktm22ney@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

this block:
|int caam_qi_shutdown(struct device *qidev)
| {
|         struct cpumask old_cpumask = current->cpus_allowed;
…
|         /*
|          * QMan driver requires CGRs to be deleted from same CPU from where they
|          * were instantiated. Hence we get the module removal execute from the
|          * same CPU from where it was originally inserted.
|          */
|         set_cpus_allowed_ptr(current, get_cpu_mask(mod_init_cpu));
…
|          /* Now that we're done with the CGRs, restore the cpus allowed mask */
|         set_cpus_allowed_ptr(current, &old_cpumask);

in drivers/crypto/caam/qi.c needs to go. I saw it twice in the driver.
set_cpus_allowed_ptr() is not intended for this kind of thing.

What you want is to use work_on_cpu_safe() instead. It takes also a CPU
as an argument. You need to check the error code of the function if it
worked because the CPU may have gone offline. This functions also
ensures that the CPU does not vanish in the middle of the work. 
Also please check the error code in both cases of the function because
it may fail if the CPU is not online.

Sebastian
