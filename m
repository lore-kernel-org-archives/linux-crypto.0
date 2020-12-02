Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BFCCC64E7B
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Dec 2020 21:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 047F02222F
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Dec 2020 21:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgLBVAT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Dec 2020 16:00:19 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:36354 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgLBVAS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Dec 2020 16:00:18 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606942776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=taIfbIJFc06Wgj9BGKuuNGwAkjIFWbU5Zsh2o+YzsmA=;
        b=00QEUXqAFNKpQ6+e5uJM2FH3qEVe0kNWxdqkxUkLsnTRW/qVHm1WpHVM6DJZ7AbBHK7Iq+
        VZ0r7sqvRZf+RuX5goBhbvpl6tPmBYq2/xH0QOMaOns/pFLWlJu1kb4QYH0xcNfaBvg37Z
        kQ7eGTdfLZDwwTSy+ua1m9NCWv5czucLn3fPEm6b7nmbb/Zi/d10RP/+Lr9BXo5GF9C2Ab
        QAAZdYC0TQF2BaOftCBFZ7h7Bpa8nXYNGlb5Nte0xgQ4UBZWyJVjApKZOePqnCUlWheC65
        g4Fu2piPzfV+H2VoWvsznG7A37log5bbPogZj15C10Rlo+Y8SAMWWgQppa1IEQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606942776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=taIfbIJFc06Wgj9BGKuuNGwAkjIFWbU5Zsh2o+YzsmA=;
        b=cMkLtZVB5OpYFgq8AsudqRSf7/MtS1a5WgE9/jZBaicoWs3bRSxi47qMfD0fNNZXsGFuAE
        yoi1PV6wXF0hsABg==
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: crypto: sun4i-ss: error with kmap
In-Reply-To: <20201202195501.GA29296@Red>
References: <20201201130102.GA23461@Red> <87ft4phcyx.fsf@nanos.tec.linutronix.de> <20201201135252.GA9584@Red> <87y2ihfw6z.fsf@nanos.tec.linutronix.de> <20201201144529.GA6786@Red> <87v9dlfthf.fsf@nanos.tec.linutronix.de> <20201202195501.GA29296@Red>
Date:   Wed, 02 Dec 2020 21:59:36 +0100
Message-ID: <877dpzexfr.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 02 2020 at 20:55, Corentin Labbe wrote:
> On Tue, Dec 01, 2020 at 04:15:08PM +0100, Thomas Gleixner wrote:
>
> The result could be seen at http://kernel.montjoie.ovh/129768.log
> The log is 9Mb, but the ftrace dump seems not terminated, tell me if you need more.

Correct, the interesting entries right before the crash are missing. Can
you try to make the trace buffers smaller or wait longer before
terminating the thing?

16k buffer size per CPU should be completely sufficient. That should
give us roughly the last 100 entries per CPU.

'trace_buf_size=16k'

is the command line option for that.

Thanks,

        tglx



