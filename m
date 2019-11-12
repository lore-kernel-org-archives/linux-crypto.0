Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D48C43331
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 09:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0FBA206BB
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 09:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfKLJwm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Nov 2019 04:52:42 -0500
Received: from foss.arm.com ([217.140.110.172]:59180 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726376AbfKLJwm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Nov 2019 04:52:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB94D1FB;
        Tue, 12 Nov 2019 01:52:41 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44FD03F534;
        Tue, 12 Nov 2019 01:52:41 -0800 (PST)
Date:   Tue, 12 Nov 2019 09:52:39 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Richard Henderson <richard.henderson@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        ard.biesheuvel@linaro.org
Subject: Re: [PATCH v5] arm64: Implement archrandom.h for ARMv8.5-RNG
Message-ID: <20191112095238.GB32269@lakrids.cambridge.arm.com>
References: <20191108135751.3218-1-rth@twiddle.net>
 <20191108143025.GD11465@lakrids.cambridge.arm.com>
 <846ba15f-b777-c0c9-6720-32b96d6c45ed@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <846ba15f-b777-c0c9-6720-32b96d6c45ed@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Nov 09, 2019 at 10:04:28AM +0100, Richard Henderson wrote:
> On 11/8/19 3:30 PM, Mark Rutland wrote:
> > On Fri, Nov 08, 2019 at 02:57:51PM +0100, Richard Henderson wrote:
> >> From: Richard Henderson <richard.henderson@linaro.org>
> >>
> >> Expose the ID_AA64ISAR0.RNDR field to userspace, as the
> >> RNG system registers are always available at EL0.
> >>
> >> Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
> >> ---
> >> v2: Use __mrs_s and fix missing cc clobber (Mark),
> >>     Log rng failures with pr_warn (Mark),
> > 
> > When I suggested this, I meant in the probe path.
> > 
> > Since it can legitimately fail at runtime, I don't think it's worth
> > logging there. Maybe it's worth recording stats, but the generic wrapper
> > could do that.
> 
> Ah, ok, dropped.
> 
> >> +#ifdef CONFIG_ARCH_RANDOM
> >> +	{
> >> +		.desc = "Random Number Generator",
> >> +		.capability = ARM64_HAS_RNG,
> >> +		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
> > 
> > As above, if we're advertisting this to userspace and/or VMs, this must
> > be a system-wide feature, and cannot be a weak local feature.
> 
> Could you draw me the link between struct arm64_cpu_capabilities, as seen here,
> and struct arm64_ftr_bits, which exposes the system registers to userspace/vms?
> 
> AFAICS, ARM64_HAS_RNG is private to the kernel; there is no ELF HWCAP value
> exposed to userspace by this.

The cap is kernel-private, but in arm64_ftr_bits the field was marked
FTR_VISIBLE, which means the field is exposed to userspace and VMs via
ID register emulation.

> The adjustment of ID_AA64ISAR0.RNDR is FTR_LOWER_SAFE, which means the minimum
> value of all online cpus.  (Which seems to generate a pr_warn in
> check_update_ftr_reg for hot-plug secondaries that do not match.)

You're right that we'll warn (due to the STRICT mask), but I think that
given we're fairly certain we'll see mismatched systems, we should
handle that now rather than punt it a few months down the line.

> > We don't bother with special-casing local handling mismatch like this
> > for other features. I'd ratehr that:
> > 
> > * On the boot CPU, prior to detecting secondaries, we can seed the usual
> >   pool with the RNG if the boot CPU has it.
> > 
> > * Once secondaries are up, if the feature is present system-wide, we can
> >   make use of the feature as a system-wide feature. If not, we don't use
> >   the RNG.
> 
> Unless I'm mis-reading things, there is not a setting for ARM64_CPUCAP_* that
> allows exactly this.  If I use ARM64_CPUCAP_SYSTEM_FEATURE, then the feature is
> not detected early enough for the boot cpu.

Early in the boot process you can use this_cpu_has_cap(). My suggestion
was to have an explicit point (e.g. somewhere in setup_arch(), or an
initcall), were we check that and seed entropy on the boot CPU if
possible.

> I can change this to ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE.  That way it is
> system-wide, and also detected early enough to be used for rand_initialize().
> However, it has the side effect that secondaries are not allowed to omit RNG if
> the boot cpu has RNG.

Can we refactor things so that early-on (at rand_initialize() time), we
call a different arch helper, e.g. a new arch_get_early_random*()?

Then that could do the this_cpu_has_cap() check to initialize things,
and at runtime we cna rely on the system-wide cap.

> Is there some setting that I've missed?  Is it ok to kick the problem down the
> road until someone actually builds mis-matched hardware?

As above, I think that we an be fairly certain we're going to encounter
such systems, and it's going to be more painful to retrofit support
later (e.g. as we'll have to backport that), so I'd rather we handle
that up-front.

Thanks,
Mark.
