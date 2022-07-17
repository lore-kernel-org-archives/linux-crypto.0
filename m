Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F81C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Jul 2022 11:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiGQL1U (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 17 Jul 2022 07:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiGQL1T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Jul 2022 07:27:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C9914D37;
        Sun, 17 Jul 2022 04:27:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EABE06114B;
        Sun, 17 Jul 2022 11:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937C6C3411E;
        Sun, 17 Jul 2022 11:27:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="J5iiJACV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1658057235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/mv30OlcwjHt5A9TDV/0eRJwg2jVAHcps5518No2l8I=;
        b=J5iiJACVMyJGel0nwTYxsN8RjPlSnSwR1vjt3IV2UTmuRqJBiGm7+avd/LM0/BlkDIdxvT
        gwCb/Z/N74T/OGGu1RpRuWIr7zse6oGDGyY8kqXr26TmqvIiE813Qd0IzBX4FupWAXzsJM
        P5v8lSev9Cjy40lQfjoyPqdCNHYQDuI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id cfb7ee52 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sun, 17 Jul 2022 11:27:15 +0000 (UTC)
Date:   Sun, 17 Jul 2022 13:27:13 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     linux390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        jchrist@linux.ibm.com, dengler@linux.ibm.com
Subject: Re: [PATCH] s390/archrandom: remove CPACF trng invocations in irq
 context
Message-ID: <YtPyEUvw1iCixhWg@zx2c4.com>
References: <20220713131721.257907-1-freude@linux.ibm.com>
 <Ys7NMKkrELPT3T6H@zx2c4.com>
 <38033968bc22cf97427109be0df243e1@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <38033968bc22cf97427109be0df243e1@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Harald,

On Wed, Jul 13, 2022 at 05:18:47PM +0200, Harald Freudenberger wrote:
> ... and then let's see if we can establish something like
> arch_get_random_seed_ bytes() and a way to invoke the trng in interrupt
> context without the network guys complaining.

Alright, I went ahead and implemented this. Patch is here:
https://lore.kernel.org/lkml/20220717112439.1795588-1-Jason@zx2c4.com/

Jason
