Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2742DC4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 13:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D74DB23DE3
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 13:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405989AbgLKNC3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Dec 2020 08:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391594AbgLKNCD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Dec 2020 08:02:03 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDAAC0613CF;
        Fri, 11 Dec 2020 05:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rMzTkRBHUwuuyWZIHH9a6s635U0L90G4G36xFMgcyhQ=; b=SOQLHFFA+ehnBJ6pZS21QAMZ2c
        +GapFcfuB5gMQaGWgZxgCIOLVTNEN0MLdahOuJ433N4ftNOGaGGzrkTGK3YWXWHbD191JZV/+5+5y
        EmM31xnO2wyysHgltCGQfzZOMH8iVQ/skAxfvmBa6Z9OZf2PLXJzLlu0+Jy1WzG0XndSoYXHS3Btb
        Pn4HGZo+fw94dSBKWO8puOxBHnbFTzNt69RleROZ7grLB6i7OaiRVistU90KytjQL4ryLqC91URkH
        KSukG70kZhkCzEG67gLomMPn+ZZTdoJxGtLsDNBsYwGayHKM0DRLf7ues3fIG1C4gBWdBTMy4q2Z5
        tA+ymCXw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kni2g-00036R-5c; Fri, 11 Dec 2020 13:01:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B43883003E5;
        Fri, 11 Dec 2020 14:00:58 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9D8D221BE8D82; Fri, 11 Dec 2020 14:00:58 +0100 (CET)
Date:   Fri, 11 Dec 2020 14:00:58 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, TimGuo-oc@zhaoxin.com,
        CooperYan@zhaoxin.com, QiyuanWang@zhaoxin.com,
        HerryYang@zhaoxin.com, CobeChen@zhaoxin.com,
        SilviaZhao@zhaoxin.com, thomas.lendacky@amd.com
Subject: Re: [PATCH] crypto: x86/crc32c-intel - Don't match some Zhaoxin CPUs
Message-ID: <20201211130058.GZ2414@hirez.programming.kicks-ass.net>
References: <1607686144-2604-1-git-send-email-TonyWWang-oc@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607686144-2604-1-git-send-email-TonyWWang-oc@zhaoxin.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 11, 2020 at 07:29:04PM +0800, Tony W Wang-oc wrote:
> The driver crc32c-intel match CPUs supporting X86_FEATURE_XMM4_2.
> On platforms with Zhaoxin CPUs supporting this X86 feature, When
> crc32c-intel and crc32c-generic are both registered, system will
> use crc32c-intel because its .cra_priority is greater than
> crc32c-generic. This case expect to use crc32c-generic driver for
> some Zhaoxin CPUs to get performance gain, So remove these Zhaoxin
> CPUs support from crc32c-intel.
> 
> Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
> ---
>  arch/x86/crypto/crc32c-intel_glue.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/crypto/crc32c-intel_glue.c b/arch/x86/crypto/crc32c-intel_glue.c
> index feccb52..6dafdae 100644
> --- a/arch/x86/crypto/crc32c-intel_glue.c
> +++ b/arch/x86/crypto/crc32c-intel_glue.c
> @@ -222,8 +222,16 @@ MODULE_DEVICE_TABLE(x86cpu, crc32c_cpu_id);
>  
>  static int __init crc32c_intel_mod_init(void)
>  {
> +	struct cpuinfo_x86 *c = &boot_cpu_data;
> +
>  	if (!x86_match_cpu(crc32c_cpu_id))
>  		return -ENODEV;
> +
> +	if (c->x86_vendor == X86_VENDOR_ZHAOXIN || c->x86_vendor == X86_VENDOR_CENTAUR) {
> +		if (c->x86 == 0x6 || (c->x86 == 0x7 && c->x86_model <= 0x3b))
> +			return -ENODEV;
> +	}

Egads, why can't you use that x86_match_cpu() above, and also this
really wants a comment on why you're excluding these chips. Also, since
(IIRC) ZHAOXIN is basically AND, shouldn't they also be listed?

That is; write it like:

	m = x86_match_cpu(crc32_cpu_id);
	if (!m || !m->data)
		return -ENODEV;

That way you can have positive and negative matches in the array
(obviously the existing FEATURE test would need data=1 and be last).
