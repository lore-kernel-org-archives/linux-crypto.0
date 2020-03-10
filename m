Return-Path: <SRS0=U1Ok=43=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C6EC10DCE
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 06:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BBDB2467F
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 06:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583822578;
	bh=Dj8K3rSNJUIPQtArbE89vczJwFwz5TIsSyMTjCIOMdE=;
	h=To:Cc:From:Subject:Date:List-ID:From;
	b=CzoF1JHkgamtcxFid4Q6JEwEdpnK6ksMJUNHO+3YUPLAju/aLmCYS11SYBt9dxieX
	 GcVgMoCoAUzN3xKc3xh5jToKF/wFdjzBcdx7Gen+TvpVw7Px8aqWEN2ylthwobgIeW
	 6k31PYdNzAjnLGSeEWXD8TUBUXidrK+75vlu+9MI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgCJGm5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Mar 2020 02:42:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbgCJGm5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Mar 2020 02:42:57 -0400
Received: from [10.44.0.22] (unknown [103.48.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B68D124655;
        Tue, 10 Mar 2020 06:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583822576;
        bh=Dj8K3rSNJUIPQtArbE89vczJwFwz5TIsSyMTjCIOMdE=;
        h=To:Cc:From:Subject:Date:From;
        b=LshjIQdhIUJsa/4A6BTdXxvn2pDkMD9Rkh0kzyjOiaHpJ76lKYxPTQzyB1eE6A2c2
         qZs9OU6CUSzVwEoBPwWFU81/XVsQMOL2gPINtYISJJQCBIWygkbQ2mC3V1QzWNotQE
         mPsix1fDBEr9CMPau6fhrzhU+wrBf2PPERkAjuo8=
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     linux-crypto@vger.kernel.org,
        Iuliana Prodan <iuliana.prodan@nxp.com>
From:   Greg Ungerer <gerg@kernel.org>
Subject: Re: [PATCH] crypto: caam - select DMA address size at runtime
Message-ID: <e19cec7b-0721-391f-f43e-437062a7eab3@kernel.org>
Date:   Tue, 10 Mar 2020 16:42:52 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Andrey,

I am tracking down a caam driver problem, where it is dumping on startup
on a Layerscape 1046 based hardware platform. The dump typically looks
something like this:

------------[ cut here ]------------
kernel BUG at drivers/crypto/caam/jr.c:218!
Internal error: Oops - BUG: 0 [#1] SMP
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.5.0-ac0 #1
Hardware name: Digi AnywhereUSB-8 (DT)
pstate: 40000005 (nZcv daif -PAN -UAO)
pc : caam_jr_dequeue+0x3f8/0x420
lr : tasklet_action_common.isra.17+0x144/0x180
sp : ffffffc010003df0
x29: ffffffc010003df0 x28: 0000000000000001
x27: 0000000000000000 x26: 0000000000000000
x25: ffffff8020aeba80 x24: 0000000000000000
x23: 0000000000000000 x22: ffffffc010ab4e51
x21: 0000000000000001 x20: ffffffc010ab4000
x19: ffffff8020a2ec10 x18: 0000000000000004
x17: 0000000000000001 x16: 6800f1f100000000
x15: ffffffc010de5000 x14: 0000000000000000
x13: ffffffc010de5000 x12: ffffffc010de5000
x11: 0000000000000000 x10: ffffff8073018080
x9 : 0000000000000028 x8 : 0000000000000000
x7 : 0000000000000000 x6 : ffffffc010a11140
x5 : ffffffc06b070000 x4 : 0000000000000008
x3 : ffffff8073018080 x2 : 0000000000000000
x1 : 0000000000000001 x0 : 0000000000000000

Call trace:
  caam_jr_dequeue+0x3f8/0x420
  tasklet_action_common.isra.17+0x144/0x180
  tasklet_action+0x24/0x30
  _stext+0x114/0x228
  irq_exit+0x64/0x70
  __handle_domain_irq+0x64/0xb8
  gic_handle_irq+0x50/0xa0
  el1_irq+0xb8/0x140
  arch_cpu_idle+0x10/0x18
  do_idle+0xf0/0x118
  cpu_startup_entry+0x24/0x60
  rest_init+0xb0/0xbc
  arch_call_rest_init+0xc/0x14
  start_kernel+0x3d0/0x3fc
Code: d3607c21 2a020002 aa010041 17ffff4d (d4210000)
---[ end trace ce2c4c37d2c89a99 ]---


Git bisecting this lead me to commit a1cf573ee95d ("crypto: caam -
select DMA address size at runtime") as the culprit.

I came across commit by Iuliana, 7278fa25aa0e ("crypto: caam -
do not reset pointer size from MCFGR register"). However that
doesn't fix this dumping problem for me (it does seem to occur
less often though). [NOTE: dump above generated with this
change applied].

I initially hit this dump on a linux-5.4, and it also occurs on
linux-5.5 for me.

Any thoughts?

Regards
Greg
