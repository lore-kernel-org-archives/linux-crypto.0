Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2DDC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 08:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0B8E206A1
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 08:40:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="g6xv4XrK";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="TB7jk4ii"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgGIIkp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 04:40:45 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34672 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgGIIko (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 04:40:44 -0400
Date:   Thu, 9 Jul 2020 10:40:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594284042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ieSBot/weRM1U5QEdd7MCkjc4QsLbq7KhjhwH8iFh8o=;
        b=g6xv4XrKRyQ3aPVu6RyEH2opLJSzoWIezuhAdkoJQlr6HdURCxra93x8IV8pGbnpn7Wqxp
        oIX2mNGvsZX4dlbIH33sun9YPonGswuB5r4Jxg0gjLkD8kvALBGsyAg1ClSFbfMOg9G+dp
        X8a7+NNABkaPl+lURmisc5FOelII2pMzcKsdrHrKbctKJu+dHq+ZKJtvyN8H/HFyEdK6yS
        YgsTDBTD3UlEaXIj/vq67lwqmn/rnSkTpbB+/Qkx/ngP2l8d5VMHMRE+6kAR9OECszU8z4
        bEVszu8x+mn+maLRzLN6d/nmsQgYgnQD7CbMcWwwHkAbGTvnsSi6+PfvcUaBTQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594284042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ieSBot/weRM1U5QEdd7MCkjc4QsLbq7KhjhwH8iFh8o=;
        b=TB7jk4iiWHREpoBXtKoUJDi3kx2Hxev64lmh1lDE+9keDrgXurcyq91Z2CSwcV2J38JQcS
        7bOUrK+lgNH/W2BQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
Cc:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH v4] mm/zswap: move to use crypto_acomp API for hardware
 acceleration
Message-ID: <20200709084040.cf3jzkndiaefky4r@linutronix.de>
References: <20200707125210.33256-1-song.bao.hua@hisilicon.com>
 <20200708145934.4w3qk53mgavyyln7@linutronix.de>
 <B926444035E5E2439431908E3842AFD25610B7@DGGEMI525-MBS.china.huawei.com>
 <20200709073905.lgs5kvccnz6eqsyd@linutronix.de>
 <B926444035E5E2439431908E3842AFD2561D4E@DGGEMI525-MBS.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B926444035E5E2439431908E3842AFD2561D4E@DGGEMI525-MBS.china.huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-07-09 07:55:22 [+0000], Song Bao Hua (Barry Song) wrote:
> Hello Sebastian, thanks for your reply and careful review.
Hi,

> I don't think we can simply "forward the result to the caller and let him decide".
> Would you like to present some pseudo code?

I provided just some pseudo code to illustrate an example how the async
interface should look like (more or less). The essential part is where
you allow to feed multiple requests without blocking.
I went up the call-chain and found one potential user which seem to have
a list of pages which are processed. This looked like a nice example. I
haven't looked at the details.

I have no opinion whether or not it makes sense to switch to the async
interface in a sync way.

> Thanks
> Barry

Sebastian
