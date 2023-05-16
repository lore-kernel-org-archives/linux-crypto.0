Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E05C77B7A
	for <linux-crypto@archiver.kernel.org>; Tue, 16 May 2023 05:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjEPFu0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 May 2023 01:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjEPFuZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 May 2023 01:50:25 -0400
X-Greylist: delayed 419 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 May 2023 22:50:20 PDT
Received: from a27-22.smtp-out.us-west-2.amazonses.com (a27-22.smtp-out.us-west-2.amazonses.com [54.240.27.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB9C40D9
        for <linux-crypto@vger.kernel.org>; Mon, 15 May 2023 22:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=s25kmyuhzvo7troimxqpmtptpemzlc6l; d=exabit.dev; t=1684215801;
        h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:Mime-Version:Content-Type:Content-Transfer-Encoding;
        bh=74L/YZxtx3KSMNRkAtfGsObxFGNIU40Nx7IaCnAIASs=;
        b=Fb57bjgi9iNYj6jzCsbxCmfIYnohkIz4bYU+CxnrCz3xlA9U85k5fHpgnFot9onw
        nDwzmtdinp2fK+jgwTl2sti9Nw+UnYaKMRa4m7c2jPTqQz0z9FQQcKl2A/v3wTUBY/6
        Scen8C9NQN3GoscAahkrDpveghZ4aoxRjP5/pdMKwCMgXTm+4vGHudZXo2XvjRVBflN
        XvG8gf2NLHa5TK4Mo17O19wEcyitAgXd5zeg5bdCEG4WcUZHsJvk/wVJB5O9wughXU1
        bu2od+6vHf3aeShGniEYHiv0/TowMR/FwDBJkO/yDWcAQbk9vy0jPkn9t4+uSsW0JVN
        eTQuwa1NuA==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1684215801;
        h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:Mime-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=74L/YZxtx3KSMNRkAtfGsObxFGNIU40Nx7IaCnAIASs=;
        b=c8xFgWBiF4V2XwwMgG32ZlMFOZGSvEG7VbJzn0ETgqC7jc50j9omRhsrhcbWT/FZ
        r4GNlEpuPGfYKbPKHfeoI9TE1pd6ZhyQ7Cnk5IbwA7KiMtfTn/pZe7KTcsbtH5E8ZnC
        oxxoJgSGGKHtfxFNHH6tpQ5IqBuNDgrQnlzTnV+k=
Date:   Tue, 16 May 2023 05:43:21 +0000
Message-ID: <010101882315a489-908f5965-2e67-497f-97f8-5c91bc928673-000000@us-west-2.amazonses.com>
To:     andrew@lunn.ch
Cc:     tomo@exabit.dev, rust-for-linux@vger.kernel.org,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        fujita.tomonori@gmail.com
Subject: Re: [PATCH 2/2] rust: add socket support
From:   FUJITA Tomonori <tomo@exabit.dev>
In-Reply-To: <f22b24f8-f599-4eec-9535-bcca71138057@lunn.ch>
References: <20230515043353.2324288-1-tomo@exabit.dev>
        <010101881db03866-754b644c-682c-44be-8d8e-8376d34c77b3-000000@us-west-2.amazonses.com>
        <f22b24f8-f599-4eec-9535-bcca71138057@lunn.ch>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Feedback-ID: 1.us-west-2.j0GTvY5MHQQ5Spu+i4ZGzzYI1gDE7m7iuMEacWMZbe8=:AmazonSES
X-SES-Outgoing: 2023.05.16-54.240.27.22
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 15 May 2023 16:14:56 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Mon, May 15, 2023 at 04:34:28AM +0000, FUJITA Tomonori wrote:
>> From: FUJITA Tomonori <fujita.tomonori@gmail.com>
>> 
>> minimum abstraction for networking.
> 
>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
>> ---
>>  rust/bindings/bindings_helper.h |   3 +
>>  rust/kernel/lib.rs              |   2 +
>>  rust/kernel/net.rs              | 174 ++++++++++++++++++++++++++++++++
> 
> The full networking API is huge. So trying to put it all into net.rs
> is unlikely to work in the long run. Maybe it would be better to name
> this file based on the tiny little bit of the network API you are
> writing an abstraction for?

Yeah, in the long run. I tried the simplest but if the maintainers
prefer that approach as the first step, I'll update the patch. how
about rust/net/socket.rs ?


> If i'm reading the code correctly, you are abstracting the in kernel
> socket API for only TCP over IPv4. Probably with time that will get
> extended to IPv6, and then UDP. So maybe call this net-kern-socket.rs?

Yes. It's thin abstraction, just wrapping socket APIs. So it's easy to
extend it for IPv6, non IP protocols, etc.

Thanks,
