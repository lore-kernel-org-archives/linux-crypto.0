Return-Path: <SRS0=6fPk=5K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579C5C43331
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 12:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3420D20775
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 12:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgCYMDZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Mar 2020 08:03:25 -0400
Received: from foss.arm.com ([217.140.110.172]:47464 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727129AbgCYMDZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Mar 2020 08:03:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D6DE31B;
        Wed, 25 Mar 2020 05:03:25 -0700 (PDT)
Received: from C02TD0UTHF1T.local (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 61BDF3F71F;
        Wed, 25 Mar 2020 05:03:23 -0700 (PDT)
Date:   Wed, 25 Mar 2020 12:03:17 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 0/3] arm64: Open code .arch_extension
Message-ID: <20200325120224.GA34330@C02TD0UTHF1T.local>
References: <20200325114110.23491-1-broonie@kernel.org>
 <CAMj1kXH=g5N4ZtnZeX5N8hf9cnWVam4Htnov6qAmQwD58Wp73Q@mail.gmail.com>
 <20200325115038.GD4346@sirena.org.uk>
 <CAMj1kXEogCrLS1o9sQyiXsKZhykfc2kuOssCeME8HyhSnMEFvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEogCrLS1o9sQyiXsKZhykfc2kuOssCeME8HyhSnMEFvA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 25, 2020 at 12:54:10PM +0100, Ard Biesheuvel wrote:
> On Wed, 25 Mar 2020 at 12:50, Mark Brown <broonie@kernel.org> wrote:
> > Since BTI is a mandatory feature of v8.5 there is no BTI arch_extension,
> > you can only enable it by moving the base architecture to v8.5.  You'd
> > need to use .arch and that feels likely to find us sharp edges to run
> > into.
> 
> I think we should talk to the toolchain folks about this. Even if
> .arch_extension today does not support the 'bti' argument, it *is*
> most definitely an architecture extension, even it it is mandatory in
> v8.5 (given that v8.5 is itself an architecture extension).

It certianly seems unfortunate, as it goes against the premise of having
HINT space instructions. Most software will want to enable HINT space
instructions from ARMv8.x but nothing else to ensure binary
compatibility with existing hardware.

I see the same is true for pointer authentication judging by:

https://sourceware.org/binutils/docs/as/AArch64-Extensions.html#AArch64-Extensions

... so worth raising with toolchain folk as a general principle even if
we have to bodge around it for now.

Thanks,
Mark.
