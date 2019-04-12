Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDABC10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 08:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37D8E20818
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 08:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfDLImd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 04:42:33 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:36611 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfDLImc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 04:42:32 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hErlU-0006So-9E; Fri, 12 Apr 2019 10:42:28 +0200
Date:   Fri, 12 Apr 2019 10:42:28 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, tglx@linutronix.de
Subject: Re: [PATCH 2/2] crypto: scompress: Use per-CPU struct instead
 multiple variables
Message-ID: <20190412084228.lrf2c6r54xsqknhf@linutronix.de>
References: <20190329130956.15935-1-bigeasy@linutronix.de>
 <20190329130956.15935-2-bigeasy@linutronix.de>
 <20190411040734.GA2292@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190411040734.GA2292@roeck-us.net>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019-04-10 21:07:35 [-0700], Guenter Roeck wrote:
> Hi Sebastian,
Hi Guenter,

> Unfortunately, this patch causes random crashes.
…
> This is seen with an arm64 image running on qemu with machine xlnx-zcu102
> and two CPUs, and crypto test options enabled. It happens roughly every
> other boot. Reverting the patch fixes the problem. Bisect log (from
> crypto/master) is attached.

What is it that you are doing? I had it tcrypt tested on x86-64 before
posting. Let me check it again with the next tree on qemu…

> Guenter

Sebastian
