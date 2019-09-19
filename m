Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E903C4CEC4
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 05:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25B9A21927
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 05:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568872221;
	bh=t+Hw9afisbolBB4SeoGHn41oKq3OIlYIXSWFg2LYd2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=exp+qbYdNhqsrcMa9DCCUQGPwJbb+UmYruy+C++qDGC6LeDykGkjiJwsdLqBAqFD4
	 jrPZETWfb6/i3iCm2kFW88Zz5C5j//idJ5MP2fDgHerCGprR89EqNFTY8MckQvV40y
	 ouM1H9cbpqJavNh5+lqcWJ6lKkeGwv+47CAp6VvI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbfISFuU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 01:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727642AbfISFuT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 01:50:19 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 497EB218AF;
        Thu, 19 Sep 2019 05:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568872218;
        bh=t+Hw9afisbolBB4SeoGHn41oKq3OIlYIXSWFg2LYd2g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XVJuI2xPTQVMUY6x+7MFXnPL9hnz1CKq7r2pb8kTa2yqKT5uVIwnkz4xMNYJdpq55
         vr40UtwWnUbkdV8joSFXhWDR2PdYcV1Dt1nPmIUqR8/SbqrdWSItoJd4iPifhezerD
         1jbbnhfK1Bwhjii/adw0waLAbz+0w5kJVvtM2n/k=
Date:   Wed, 18 Sep 2019 22:50:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     syzbot <syzbot+f39ab8494f6015e62360@syzkaller.appspotmail.com>,
        ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, ilyal@mellanox.com,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        kafai@fb.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: INFO: task hung in cancel_delayed_work_sync
Message-ID: <20190919055016.GF666@sol.localdomain>
Mail-Followup-To: Steffen Klassert <steffen.klassert@secunet.com>,
        syzbot <syzbot+f39ab8494f6015e62360@syzkaller.appspotmail.com>,
        ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, ilyal@mellanox.com,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        kafai@fb.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <0000000000001348750592a8ef50@google.com>
 <20190919051545.GB666@sol.localdomain>
 <20190919053620.GG2879@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919053620.GG2879@gauss3.secunet.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 19, 2019 at 07:36:20AM +0200, Steffen Klassert wrote:
> On Wed, Sep 18, 2019 at 10:15:45PM -0700, Eric Biggers wrote:
> > 
> > Reproducer involves pcrypt, so probably the pcrypt deadlock again...
> > https://lkml.kernel.org/linux-crypto/20190817054743.GE8209@sol.localdomain/
> 
> I'll submit the patch I proposed here in case noone has a better idea
> how to fix this now:
> 
> https://lkml.kernel.org/linux-crypto/20190821063704.GM2879@gauss3.secunet.de/
> 
> The original patch is from you, I did some modifications to forbid
> pcrypt if an underlying algorithm needs a fallback.
> 
> May I leave your 'Signed off' on this patch, or just
> quote that the initial version is from you?
> 

Keeping my Signed-off-by is fine, but please leave a note about what you
changed, like:

Signed-off-by: Eric Biggers <ebiggers@google.com>
[SK: also require that the underlying algorithm doesn't need a fallback]
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Also, a nit: in the commit message,

> Fix this by making pcrypt forbid instantiation if pcrypt appears in the
> underlying ->cra_driver_name and if an underlying algorithm needs a
> fallback.

... the word "and" should be "or".

- Eric
