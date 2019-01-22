Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD70C282C3
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 19:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF6D521726
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 19:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfAVThq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 14:37:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35242 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfAVThq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 14:37:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C0A8714D3CC33;
        Tue, 22 Jan 2019 11:37:45 -0800 (PST)
Date:   Tue, 22 Jan 2019 11:37:45 -0800 (PST)
Message-Id: <20190122.113745.2272490918452641096.davem@davemloft.net>
To:     atul.gupta@chelsio.com
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, dt@chelsio.com
Subject: Re: [net-next 2/3] net/tls: free ctx in sock destruct
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190118045621.2822-1-atul.gupta@chelsio.com>
References: <20190118045621.2822-1-atul.gupta@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 22 Jan 2019 11:37:46 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Atul Gupta <atul.gupta@chelsio.com>
Date: Thu, 17 Jan 2019 20:56:21 -0800

> free tls context in sock destruct. close may not be the last
> call to free sock but force releasing the ctx in close
> will result in GPF when ctx referred again in tcp_done
> 
> [  515.330477] general protection fault: 0000 [#1] SMP PTI
> [  515.330539] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 4.20.0-rc7+ #10
> [  515.330657] Hardware name: Supermicro X8ST3/X8ST3, BIOS 2.0b
> 11/07/2013
> [  515.330844] RIP: 0010:tls_hw_unhash+0xbf/0xd0
> [
> [  515.332220] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  515.332340] CR2: 00007fab32c55000 CR3: 000000009261e000 CR4:
> 00000000000006e0
> [  515.332519] Call Trace:
> [  515.332632]  <IRQ>
> [  515.332793]  tcp_set_state+0x5a/0x190
> [  515.332907]  ? tcp_update_metrics+0xe3/0x350
> [  515.333023]  tcp_done+0x31/0xd0
> [  515.333130]  tcp_rcv_state_process+0xc27/0x111a
> [  515.333242]  ? __lock_is_held+0x4f/0x90
> [  515.333350]  ? tcp_v4_do_rcv+0xaf/0x1e0
> [  515.333456]  tcp_v4_do_rcv+0xaf/0x1e0
> 
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>

Applied.
