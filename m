Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E40C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 15:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3015164DFB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 15:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbhCAPX3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Mar 2021 10:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236673AbhCAPXO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Mar 2021 10:23:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1999BC061756
        for <linux-crypto@vger.kernel.org>; Mon,  1 Mar 2021 07:22:33 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1lGkNU-0005ir-6h; Mon, 01 Mar 2021 16:22:32 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1lGkNT-000394-OS; Mon, 01 Mar 2021 16:22:31 +0100
Date:   Mon, 1 Mar 2021 16:22:31 +0100
To:     linux-crypto@vger.kernel.org
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>, kernel@pengutronix.de
Subject: CAAM: kernel BUG at drivers/crypto/caam/jr.c:230!
Message-ID: <20210301152231.GC5549@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:18:25 up 11 days, 18:42, 82 users,  load average: 0.02, 0.12,
 0.16
User-Agent: Mutt/1.10.1 (2018-07-13)
From:   Sascha Hauer <sha@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

I am on a Layerscape LS1046a using Linux-5.11. The CAAM driver sometimes
crashes during the run-time self tests with:

> kernel BUG at drivers/crypto/caam/jr.c:247!
> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.11.0-20210225-3-00039-g434215968816-dirty #12
> Hardware name: TQ TQMLS1046A SoM on Arkona AT1130 (C300) board (DT)
> pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
> pc : caam_jr_dequeue+0x98/0x57c
> lr : caam_jr_dequeue+0x98/0x57c
> sp : ffff800010003d50
> x29: ffff800010003d50 x28: ffff8000118d4000
> x27: ffff8000118d4328 x26: 00000000000001f0
> x25: ffff0008022be480 x24: ffff0008022c6410
> x23: 00000000000001f1 x22: ffff8000118d4329
> x21: 0000000000004d80 x20: 00000000000001f1
> x19: 0000000000000001 x18: 0000000000000020
> x17: 0000000000000000 x16: 0000000000000015
> x15: ffff800011690230 x14: 2e2e2e2e2e2e2e2e
> x13: 2e2e2e2e2e2e2020 x12: 3030303030303030
> x11: ffff800011700a38 x10: 00000000fffff000
> x9 : ffff8000100ada30 x8 : ffff8000116a8a38
> x7 : 0000000000000001 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000
> x3 : 00000000ffffffff x2 : 0000000000000000
> x1 : 0000000000000000 x0 : 0000000000001800
> Call trace:
>  caam_jr_dequeue+0x98/0x57c
>  tasklet_action_common.constprop.0+0x164/0x18c
>  tasklet_action+0x44/0x54
>  __do_softirq+0x160/0x454
>  __irq_exit_rcu+0x164/0x16c
>  irq_exit+0x1c/0x30
>  __handle_domain_irq+0xc0/0x13c
>  gic_handle_irq+0x5c/0xf0
>  el1_irq+0xb4/0x180
>  arch_cpu_idle+0x18/0x30
>  default_idle_call+0x3c/0x1c0
>  do_idle+0x23c/0x274
>  cpu_startup_entry+0x34/0x70
>  rest_init+0xdc/0xec
>  arch_call_rest_init+0x1c/0x28
>  start_kernel+0x4ac/0x4e4
> Code: 91392021 912c2000 d377d8c6 97f24d96 (d4210000)

The driver iterates over the descriptors in the output ring and matches them
with the ones it has previously queued. If it doesn't find a matching
descriptor it complains with the BUG_ON() seen above. What I see sometimes is
that the address in the output ring is 0x0, the job status in this case is
0x40000006 (meaning DECO Invalid KEY command). It seems that the CAAM doesn't
write the descriptor address to the output ring at least in some error cases.
When we don't have the descriptor address of the failed descriptor we have no
way to find it in the list of queued descriptors, thus we also can't find the
callback for that descriptor. This looks very unfortunate, anyone else seen
this or has an idea what to do about it?

I haven't investigated yet which job actually fails and why. Of course that would
be my ultimate goal to find that out.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
