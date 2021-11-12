Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE09C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 18:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F50D60F5B
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 18:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbhKLSvR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 13:51:17 -0500
Received: from mail.skyhub.de ([5.9.137.197]:60446 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229892AbhKLSvQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 13:51:16 -0500
Received: from zn.tnic (p200300ec2f10ce00d687ada8c7fa1c88.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:ce00:d687:ada8:c7fa:1c88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9571C1EC03AD;
        Fri, 12 Nov 2021 19:48:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1636742904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=7P0Gc5QT+Jnnvq3euA1pLf9Jp6MCAev9KSnQ6MG+GFc=;
        b=irT2Dd7S1WxS/WDMqVP9CS/Vq4WAEsTEmikkHHX2+xapq3GaRe83FLwn6PT8TGOTyurR9p
        EIVRsDMy3hBBBPJCr8mq+NcdZQ5Fdk90VHLiCYtfLlL4w6tpmmXoyh+mU5pL3TsDWg0JBN
        y9mgpdr9YdOCC9jpj3M58sAX/RRBHlM=
Date:   Fri, 12 Nov 2021 19:48:17 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Cristian Marussi <cristian.marussi@arm.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v0 39/42] crypto: ccree - check notifier registration
 return value
Message-ID: <YY628XtLN+IH8D6J@zn.tnic>
References: <20211108101157.15189-1-bp@alien8.de>
 <20211108101157.15189-40-bp@alien8.de>
 <20211112183233.GB6655@e120937-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211112183233.GB6655@e120937-lin>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 12, 2021 at 06:32:33PM +0000, Cristian Marussi wrote:
> Looking at the implementation of atomic_notifier_chain_register() and
> its internal helper down below, I can see that atomic_notifier_chain_register()
> ALWAYS return 0 (O_o) and anyway there is a WARN() in the notifiier core already
> to alert of double registrations.

You can ignore it - we agreed (at least no one has complained against it
yet :)) on doing this instead:

https://lore.kernel.org/r/YYk1xi3eJdMJdjHC@zn.tnic

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
