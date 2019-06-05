Return-Path: <SRS0=VkFO=UE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F14C46470
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jun 2019 12:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10C03206BA
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jun 2019 12:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfFEMUg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Jun 2019 08:20:36 -0400
Received: from foss.arm.com ([217.140.101.70]:58906 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727553AbfFEMUf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Jun 2019 08:20:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8788E80D;
        Wed,  5 Jun 2019 05:20:35 -0700 (PDT)
Received: from fuggles.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 732363F246;
        Wed,  5 Jun 2019 05:20:33 -0700 (PDT)
Date:   Wed, 5 Jun 2019 13:20:31 +0100
From:   Will Deacon <will.deacon@arm.com>
To:     Ali Saidi <alisaidi@amazon.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ron Rindjunsky <ronrindj@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH 0/3] Add support for Graviton TRNG
Message-ID: <20190605122031.GK15030@fuggles.cambridge.arm.com>
References: <20190604203100.15050-1-alisaidi@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604203100.15050-1-alisaidi@amazon.com>
User-Agent: Mutt/1.11.1+86 (6f28e57d73f2) ()
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 04, 2019 at 08:30:57PM +0000, Ali Saidi wrote:
> AWS Graviton based systems provide an Arm SMC call in the vendor defined
> hypervisor region to read random numbers from a HW TRNG and return them to the
> guest. 
> 
> We've observed slower guest boot and especially reboot times due to lack of
> entropy and providing access to a TRNG is meant to address this. 

Curious, but why this over something like virtio-rng?

Will
