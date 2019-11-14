Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B3EC432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 14:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC809206D5
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 14:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfKNOZP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 09:25:15 -0500
Received: from foss.arm.com ([217.140.110.172]:44140 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfKNOZP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 09:25:15 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F453328;
        Thu, 14 Nov 2019 06:25:15 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD79B3F52E;
        Thu, 14 Nov 2019 06:25:14 -0800 (PST)
Date:   Thu, 14 Nov 2019 14:25:12 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     richard.henderson@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v7] arm64: Implement archrandom.h for ARMv8.5-RNG
Message-ID: <20191114142512.GC37865@lakrids.cambridge.arm.com>
References: <20191114113932.26186-1-richard.henderson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114113932.26186-1-richard.henderson@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 14, 2019 at 12:39:32PM +0100, richard.henderson@linaro.org wrote:
> +bool arch_get_random_seed_long(unsigned long *v)
> +{
> +	bool ok;
> +
> +	if (static_branch_likely(&arm64_const_caps_ready)) {
> +		if (__cpus_have_const_cap(ARM64_HAS_RNG))
> +			return arm64_rndr(v);
> +		return false;
> +	}
> +
> +	/*
> +	 * Before const_caps_ready, check the current cpu.
> +	 * This will generally be the boot cpu for rand_initialize().
> +	 */
> +	preempt_disable_notrace();
> +	ok = this_cpu_has_cap(ARM64_HAS_RNG) && arm64_rndr(v);
> +	preempt_enable_notrace();
> +
> +	return ok;
> +}

As I asked previously, please separate the common case and the boot-cpu
init-time case into separate functions.

The runtime function should just check the RNG cap before using the
instruction, without any preemption check or explicit check of
arm64_const_caps_ready. i.e.

static bool arm64_rndr(unsigned long *v)
{
	bool ok;

	if (!cpus_have_const_cap(ARM64_HAS_RNG))
		return false;

	/*
	 * Reads of RNDR set PSTATE.NZCV to 0b0000 on success,
	 * and set PSTATE.NZCV to 0b0100 otherwise.
	 */
	asm volatile(
		__mrs_s("%0", SYS_RNDR_EL0) "\n"
	"       cset %w1, ne\n"
	: "=r" (*v), "=r" (ok)
	:
	: "cc");

	return ok;
}

Any boot-time seeding should be in a separate function that external
callers cannot invoke at runtime. Either have an arch function that the
common random code calls at init time on the boot CPU, or have some
arch_add_foo_entropy() function that the arm64 code can call somewhere
around setup_arch().

Thanks,
Mark.
