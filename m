Return-Path: <SRS0=UDVD=U6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A93C0650E
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jul 2019 17:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A736221473
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jul 2019 17:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562000565;
	bh=II2Jf2pNDbd0s5JMhTlbcxwH6Bk/SNuU/ykYA4KIAZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=zg2csC8DggLmzNBYYzR43IMfnbTwY2NrmKuQrqAycNdxFxyg7ubK9a+TLzaQtX37s
	 EKMQkqvBmel4D1nVkE9J7fZeTHlW9Nu0fXWaE7ebQPlN3JvE3sgQ1lL9DLQGS3kK1K
	 HYutYMbGqsNTHcFjsHIf5ZX0PA/IuWTJCj8wtRsg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbfGARCo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jul 2019 13:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728253AbfGARCo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jul 2019 13:02:44 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B8E621721;
        Mon,  1 Jul 2019 17:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562000563;
        bh=II2Jf2pNDbd0s5JMhTlbcxwH6Bk/SNuU/ykYA4KIAZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ammzUlm18IxuOBkz97uLHm/H+2wb6OsJECZHOpVn8+4aAYGv6rV37Q1dIloW9uUq8
         4IpLok2//Ii7+v2TMx2WpendWYZiDoiKNraL+lAFuswmAGYxQ59isq9I1htEn4GCw/
         DVMLnzr9wOSK+I+Iknby1fiV8sNez+1h7K37G2CA=
Date:   Mon, 1 Jul 2019 18:02:38 +0100
From:   Will Deacon <will@kernel.org>
To:     "Saidi, Ali" <alisaidi@amazon.com>
Cc:     Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Matt Mackall <mpm@selenic.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rindjunsky, Ron" <ronrindj@amazon.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>, marc.zyngier@arm.com
Subject: Re: [PATCH 0/3] Add support for Graviton TRNG
Message-ID: <20190701170237.druloljv4yoanv5i@willie-the-truck>
References: <20190604203100.15050-1-alisaidi@amazon.com>
 <20190605122031.GK15030@fuggles.cambridge.arm.com>
 <7EC45708-38A1-4826-BC82-298EFAAE30B1@amazon.com>
 <3104F396-094F-454C-8308-BF651FAB99AB@amazon.com>
 <20190701082805.pifv4attux4mddld@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701082805.pifv4attux4mddld@willie-the-truck>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[+Marc]

On Mon, Jul 01, 2019 at 09:28:06AM +0100, Will Deacon wrote:
> [Note: this was in my spam folder]
> 
> On Fri, Jun 28, 2019 at 06:05:10PM +0000, Saidi, Ali wrote:
> > On 6/7/19, 7:59 AM, " Ali Saidi" <alisaidi@amazon.com> wrote:
> >     On 6/5/19, 7:20 AM, "Will Deacon" <will.deacon@arm.com> wrote:
> >         On Tue, Jun 04, 2019 at 08:30:57PM +0000, Ali Saidi wrote:
> >         > AWS Graviton based systems provide an Arm SMC call in the vendor defined
> >         > hypervisor region to read random numbers from a HW TRNG and return them to the
> >         > guest. 
> >         > 
> >         > We've observed slower guest boot and especially reboot times due to lack of
> >         > entropy and providing access to a TRNG is meant to address this. 
> >         
> >         Curious, but why this over something like virtio-rng?
> >         
> >     This interface allows us to provide the functionality from both EL2
> >     and EL3 and support multiple different types of our instances which we
> >     unfortunately can't do with virt-io.
> >     
> > Any additional comments?
> > Do you know when you'll have a chance to rebase arm64/smccc-cleanup?
> 
> Sorry, Ali, this slipped through the cracks. Marc and I will chat today and
> look at respinning what we had before; it should then hopefully be
> straightforward enough for you to take that as a base for what you want to
> do.

Ok, I hacked on this a bit today and hopefully you can use this as a
starting point:

https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=kvm/hvc

I haven't given it any real testing, so apologies for the bugs.

Will
