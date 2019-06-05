Return-Path: <SRS0=VkFO=UE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4471DC28CC5
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jun 2019 11:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18238206BA
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jun 2019 11:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfFELCi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Jun 2019 07:02:38 -0400
Received: from foss.arm.com ([217.140.101.70]:57470 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbfFELCh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Jun 2019 07:02:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A58E374;
        Wed,  5 Jun 2019 04:02:37 -0700 (PDT)
Received: from e107155-lin (e107155-lin.cambridge.arm.com [10.1.196.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD2F63F690;
        Wed,  5 Jun 2019 04:02:34 -0700 (PDT)
Date:   Wed, 5 Jun 2019 12:02:32 +0100
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Ali Saidi <alisaidi@amazon.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Matt Mackall <mpm@selenic.com>,
        Will Deacon <will.deacon@arm.com>,
        Ron Rindjunsky <ronrindj@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/3] arm64: export acpi_psci_use_hvc
Message-ID: <20190605110232.GB20813@e107155-lin>
References: <20190604203100.15050-1-alisaidi@amazon.com>
 <20190604203100.15050-3-alisaidi@amazon.com>
 <20190605094031.GB28613@e107155-lin>
 <20190605103840.GA30925@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605103840.GA30925@lakrids.cambridge.arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 05, 2019 at 11:38:40AM +0100, Mark Rutland wrote:
> On Wed, Jun 05, 2019 at 10:40:31AM +0100, Sudeep Holla wrote:
> > On Tue, Jun 04, 2019 at 08:30:59PM +0000, Ali Saidi wrote:
> > > Allow a module that wants to make SMC calls to detect if it should be
> > > using smc or hvc.
> > >
> > > Signed-off-by: Ali Saidi <alisaidi@amazon.com>
> > > ---
> > >  arch/arm64/kernel/acpi.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> > > index 803f0494dd3e..ea41c6541d3c 100644
> > > --- a/arch/arm64/kernel/acpi.c
> > > +++ b/arch/arm64/kernel/acpi.c
> > > @@ -119,6 +119,7 @@ bool acpi_psci_use_hvc(void)
> > >  {
> > >  	return acpi_gbl_FADT.arm_boot_flags & ACPI_FADT_PSCI_USE_HVC;
> > >  }
> > > +EXPORT_SYMBOL_GPL(acpi_psci_use_hvc);
> > >
> > 
> > I would rather have this in drivers/firmware/psci/psci.c checking the
> > value of psci_ops.conduit so that it's not just ACPI specific and can
> > be used on DT platforms too if required.
> 
> I'd also like this to not hook into PSCI internals. This code cares
> about SMCCC, not PSCI. We also really shouldn't need to spread the
> conduit management everywhere, too.

I agree. I remember suggesting the same to Xilinx a while ago but I
didn't see your patches in the mainline.

--
Regards,
Sudeep
