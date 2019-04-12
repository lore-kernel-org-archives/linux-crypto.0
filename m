Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F9B4C10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 13:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5103F2084D
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 13:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfDLNu7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:50:59 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:37315 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfDLNu7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 09:50:59 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hEwa0-0003w7-V2; Fri, 12 Apr 2019 15:50:57 +0200
Date:   Fri, 12 Apr 2019 15:50:56 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, tglx@linutronix.de
Subject: Re: [PATCH 2/2] crypto: scompress: Use per-CPU struct instead
 multiple variables
Message-ID: <20190412135056.6gnjs6a67fc5suyw@linutronix.de>
References: <20190329130956.15935-1-bigeasy@linutronix.de>
 <20190329130956.15935-2-bigeasy@linutronix.de>
 <20190411040734.GA2292@roeck-us.net>
 <20190412084228.lrf2c6r54xsqknhf@linutronix.de>
 <ac7fb436-2286-1eb2-662b-e2236ad02718@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <ac7fb436-2286-1eb2-662b-e2236ad02718@roeck-us.net>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019-04-12 06:43:31 [-0700], Guenter Roeck wrote:
> On 4/12/19 1:42 AM, Sebastian Andrzej Siewior wrote:
> > On 2019-04-10 21:07:35 [-0700], Guenter Roeck wrote:
> > > Hi Sebastian,
> > Hi Guenter,
> > 
> > > Unfortunately, this patch causes random crashes.
> > …
> > > This is seen with an arm64 image running on qemu with machine xlnx-zcu102
> > > and two CPUs, and crypto test options enabled. It happens roughly every
> > > other boot. Reverting the patch fixes the problem. Bisect log (from
> > > crypto/master) is attached.
> > 
> > What is it that you are doing? I had it tcrypt tested on x86-64 before
> > posting. Let me check it again with the next tree on qemu…
> > 
> 
> Nothing special. Booting arm64:defconfig+various debug and test options in qemu.
> It does not seem to depend on specific boot options. Crash failure rate, based
> on the last three of days testing, seems to be roughly 20%. The problem is only
> seen if there is more than one CPU. I have seen it with 2, 4, and 6 CPUs active,
> but it seems to be most likely to happen with 2 CPUs. I don't have enough data
> yet to be sure, though.
> 
> The problem is only seen with arm64, at least in my tests.

I found your test thingy and I managed to run it here. I started 
	rootfs/arm64/run-qemu-arm64.sh

a few times (only with the xlnx-zcu102 targets) and after the third
iteration it exploded once.
So I have this, let me try to dig further.

> Guenter

Sebastian
