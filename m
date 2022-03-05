Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16C7C433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Mar 2022 18:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbiCESjN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Mar 2022 13:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiCESjN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Mar 2022 13:39:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABD460DD
        for <linux-crypto@vger.kernel.org>; Sat,  5 Mar 2022 10:38:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F589B80C75
        for <linux-crypto@vger.kernel.org>; Sat,  5 Mar 2022 18:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E538BC004E1;
        Sat,  5 Mar 2022 18:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646505499;
        bh=X+5XheZZoPEoAGtNpdtKssVpOcfU8kisJHtPXmyuyg0=;
        h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
        b=fMZqskKrffdGNwtjOkh+xFt/AR9nVr3pAbVk5HopWG4eX17WqXBe3RnqP0kgQhi+K
         NDOJ5OglFn6MrcBrOjAFqK1AH52GK/mrd/6TELrivC9bIkVp3SYi/x+GGtKmRIU/09
         /08ow7J5Y46e3YLJ1ITjo2TjnFiDUaGSfiJ4dE/QsBK1pT+MWtlrHJGjjMXYHDd/6Z
         2xAYrNkkVnT08yb9226FJeTlLaHmXf3TjFZkk+87WZB9L/FyUvM3CPKs0toEsc+E8N
         kPCN/hrP/nzDurhKJRZXJM435b17DBlTZmZyEPrExPXAIwyVzcbtPybAWfSLzC01ZM
         8SnEJvr9zKixg==
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailauth.nyi.internal (Postfix) with ESMTP id 9BC9E27C005B;
        Sat,  5 Mar 2022 13:38:17 -0500 (EST)
Received: from imap48 ([10.202.2.98])
  by compute5.internal (MEProxy); Sat, 05 Mar 2022 13:38:17 -0500
X-ME-Sender: <xms:GK4jYkjxXx1JzTCbiH-gTkGGkCwKRViL-25Pb0nf_tUW1-2Kg24aPA>
    <xme:GK4jYtCH9tq0DKhVX9Ypyjvpx-upnOZLncscr8KjdI5YeTWm_z-gHEG7UF_zfg8ev
    hP7ORND0y194rYYNWY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddutddgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedftehn
    ugihucfnuhhtohhmihhrshhkihdfuceolhhuthhosehkvghrnhgvlhdrohhrgheqnecugg
    ftrfgrthhtvghrnheptdfhheettddvtedvtedugfeuuefhtddugedvleevleefvdetleff
    gfefvdekgeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homheprghnugihodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduudeiudek
    heeifedvqddvieefudeiiedtkedqlhhuthhopeepkhgvrhhnvghlrdhorhhgsehlihhnuh
    igrdhluhhtohdruhhs
X-ME-Proxy: <xmx:GK4jYsELHUTmgfRagUHEj6JuihmbWx4beWiupbU_akWS_WNn6zqjEA>
    <xmx:GK4jYlTTvJFgGkSQsBnjZA5Ldmih2BxSi-Cc9BtLxts6CfPjTYjUQw>
    <xmx:GK4jYhw395ilUbVnD5xhvzGDf8kB-lmB5Uc3-5fHRfNcNGMxldMWkQ>
    <xmx:Ga4jYpk4DnhgmF_nTlagsdZPjElbnVDpVwYJIJjq1bKNwt0BbIIIPtrIGi8>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 91BEA21E006E; Sat,  5 Mar 2022 13:38:16 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4778-g14fba9972e-fm-20220217.001-g14fba997
Mime-Version: 1.0
Message-Id: <ba4b74eb-29b9-43b0-9e94-09b696f18961@www.fastmail.com>
In-Reply-To: <0a21fe4d-b135-3696-71f0-aa14ca715d51@intel.com>
References: <1611386920-28579-1-git-send-email-megha.dey@intel.com>
 <CALCETrU06cuvUF5NDSm8--dy3dOkxYQ88cGWaakOQUE4Vkz88w@mail.gmail.com>
 <3878af8d-ac1e-522a-7c9f-fda4a1f5b967@intel.com>
 <CALCETrUWgLwp6yfu9ODY1UYufHeAgsnOOCOAwXZQK6FJk_YdUA@mail.gmail.com>
 <e8ce1146-3952-6977-1d0e-a22758e58914@intel.com>
 <0a10e16b-df77-9a7f-6964-8dc3e114b30b@intel.com>
 <0a21fe4d-b135-3696-71f0-aa14ca715d51@intel.com>
Date:   Sat, 05 Mar 2022 10:37:56 -0800
From:   "Andy Lutomirski" <luto@kernel.org>
To:     "Dey, Megha" <megha.dey@intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Cc:     "Tony Luck" <tony.luck@intel.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, greg.b.tucker@intel.com,
        rajendrakumar.chinnaiyan@intel.com, tomasz.kantecki@intel.com,
        ryan.d.saffores@intel.com, "Ira Weiny" <ira.weiny@intel.com>,
        "Eric Biggers" <ebiggers@kernel.org>,
        "Ard Biesheuvel" <ardb@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        anirudh.venkataramanan@intel.com
Subject: Re: [RFC V2 0/5] Introduce AVX512 optimized crypto algorithms
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Thu, Feb 24, 2022, at 11:31 AM, Dey, Megha wrote:
> Hi all,
>
> On 1/31/2022 11:18 AM, Dave Hansen wrote:
>> On 1/31/22 10:43, Dey, Megha wrote:
>>> With this implementation, we see a 1.5X improvement on ICX/ICL for 16KB
>>> buffers compared to the existing kernel AES-GCM implementation that
>>> works on 128-bit XMM registers.
>> What is your best guess about how future-proof this implementation is?
>>
>> Will this be an ICL/ICX one-off?  Or, will implementations using 256-bit
>> YMM registers continue to enjoy a frequency advantage over the 512-bit
>> implementations for a long time?
>
> Dave,
>
> This would not be an ICL/ICX one off. For the foreseeable future, 
> AVX512VL YMM implementations will enjoy a frequency advantage over 
> AVX512L ZMM implementations.
>
> Although, over time, ZMM and YMM will converge when it comes to performance.
>
> Herbert/Andy,
>
> Could you please let us know if this approach is a viable one and would 
> be acceptable by the community?
>
> Optimizing crypto algorithms using AVX512VL instructions gives a 1.5X 
> performance improvement over existing AES-GCM algorithm in the 
> kernel(using XMM registers) with no frequency drop.

I'm assuming this would be enabled automatically without needing any special command line options.  If so, it seems reasonable to me.

--Andy
