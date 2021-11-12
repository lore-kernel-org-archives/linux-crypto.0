Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7EEC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 18:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 324C760551
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 18:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbhKLSf2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 13:35:28 -0500
Received: from foss.arm.com ([217.140.110.172]:43370 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235122AbhKLSf1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 13:35:27 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D1BA101E;
        Fri, 12 Nov 2021 10:32:36 -0800 (PST)
Received: from e120937-lin (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08E443F718;
        Fri, 12 Nov 2021 10:32:35 -0800 (PST)
Date:   Fri, 12 Nov 2021 18:32:33 +0000
From:   Cristian Marussi <cristian.marussi@arm.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v0 39/42] crypto: ccree - check notifier registration
 return value
Message-ID: <20211112183233.GB6655@e120937-lin>
References: <20211108101157.15189-1-bp@alien8.de>
 <20211108101157.15189-40-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108101157.15189-40-bp@alien8.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 08, 2021 at 11:11:54AM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Avoid homegrown notifier registration checks.
> 
> No functional changes.
> 

Hi Borislav,

> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: linux-crypto@vger.kernel.org
> ---
>  drivers/crypto/ccree/cc_fips.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccree/cc_fips.c b/drivers/crypto/ccree/cc_fips.c
> index 702aefc21447..de842da7d51c 100644
> --- a/drivers/crypto/ccree/cc_fips.c
> +++ b/drivers/crypto/ccree/cc_fips.c
> @@ -146,7 +146,9 @@ int cc_fips_init(struct cc_drvdata *p_drvdata)
>  	tasklet_init(&fips_h->tasklet, fips_dsr, (unsigned long)p_drvdata);
>  	fips_h->drvdata = p_drvdata;
>  	fips_h->nb.notifier_call = cc_ree_fips_failure;
> -	atomic_notifier_chain_register(&fips_fail_notif_chain, &fips_h->nb);
> +
> +	if (atomic_notifier_chain_register(&fips_fail_notif_chain, &fips_h->nb))
> +		pr_warn("Failure notifier already registered\n");
>  

Looking at the implementation of atomic_notifier_chain_register() and
its internal helper down below, I can see that atomic_notifier_chain_register()
ALWAYS return 0 (O_o) and anyway there is a WARN() in the notifiier core already
to alert of double registrations.

What is the aim of this patch ?
It's not clear from the commit message what are you trying to achieve.
Am I missing something ?
(Is it to circumvent some static checker to avoid this false positive ?
just guessing...)

Thanks,
Cristian

-----8<----------
static int notifier_chain_register(struct notifier_block **nl,
                struct notifier_block *n)
{
        while ((*nl) != NULL) {
                if (unlikely((*nl) == n)) {
                        WARN(1, "double register detected");
                        return 0;
                }
                if (n->priority > (*nl)->priority)
                        break;
                nl = &((*nl)->next);
        }
        n->next = *nl;
        rcu_assign_pointer(*nl, n);
        return 0;
}

/**
 *      atomic_notifier_chain_register - Add notifier to an atomic notifier chain
 *      @nh: Pointer to head of the atomic notifier chain
 *      @n: New entry in notifier chain
 *
 *      Adds a notifier to an atomic notifier chain.
 *
 *      Currently always returns zero.
 */
int atomic_notifier_chain_register(struct atomic_notifier_head *nh,
                struct notifier_block *n)
{
        unsigned long flags;
        int ret;

        spin_lock_irqsave(&nh->lock, flags);
        ret = notifier_chain_register(&nh->head, n);
        spin_unlock_irqrestore(&nh->lock, flags);
        return ret;
}
EXPORT_SYMBOL_GPL(atomic_notifier_chain_register);
------
