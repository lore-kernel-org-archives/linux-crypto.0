Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9EC1CA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97D1820679
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 15:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440654AbfJYP1h (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:27:37 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36096 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731226AbfJYP1g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 11:27:36 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iO1Ux-0001wH-Rg; Fri, 25 Oct 2019 23:27:31 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iO1Ux-0007uq-9J; Fri, 25 Oct 2019 23:27:31 +0800
Date:   Fri, 25 Oct 2019 23:27:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mark Salter <msalter@redhat.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: ccp - fix uninitialized list head
Message-ID: <20191025152731.v3qbnkeu5qpqswn5@gondor.apana.org.au>
References: <20191021152949.17532-1-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021152949.17532-1-msalter@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 21, 2019 at 11:29:49AM -0400, Mark Salter wrote:
> A NULL-pointer dereference was reported in fedora bz#1762199 while
> reshaping a raid6 array after adding a fifth drive to an existing
> array.
> 
> [   47.343549] md/raid:md0: raid level 6 active with 3 out of 5 devices, algorithm 2
> [   47.804017] md0: detected capacity change from 0 to 7885289422848
> [   47.822083] Unable to handle kernel read from unreadable memory at virtual address 0000000000000000
> ...
> [   47.940477] CPU: 1 PID: 14210 Comm: md0_raid6 Tainted: G        W         5.2.18-200.fc30.aarch64 #1
> [   47.949594] Hardware name: AMD Overdrive/Supercharger/To be filled by O.E.M., BIOS ROD1002C 04/08/2016
> [   47.958886] pstate: 00400085 (nzcv daIf +PAN -UAO)
> [   47.963668] pc : __list_del_entry_valid+0x2c/0xa8
> [   47.968366] lr : ccp_tx_submit+0x84/0x168 [ccp]
> [   47.972882] sp : ffff00001369b970
> [   47.976184] x29: ffff00001369b970 x28: ffff00001369bdb8
> [   47.981483] x27: 00000000ffffffff x26: ffff8003b758af70
> [   47.986782] x25: ffff8003b758b2d8 x24: ffff8003e6245818
> [   47.992080] x23: 0000000000000000 x22: ffff8003e62450c0
> [   47.997379] x21: ffff8003dfd6add8 x20: 0000000000000003
> [   48.002678] x19: ffff8003e6245100 x18: 0000000000000000
> [   48.007976] x17: 0000000000000000 x16: 0000000000000000
> [   48.013274] x15: 0000000000000000 x14: 0000000000000000
> [   48.018572] x13: ffff7e000ef83a00 x12: 0000000000000001
> [   48.023870] x11: ffff000010eff998 x10: 00000000000019a0
> [   48.029169] x9 : 0000000000000000 x8 : ffff8003e6245180
> [   48.034467] x7 : 0000000000000000 x6 : 000000000000003f
> [   48.039766] x5 : 0000000000000040 x4 : ffff8003e0145080
> [   48.045064] x3 : dead000000000200 x2 : 0000000000000000
> [   48.050362] x1 : 0000000000000000 x0 : ffff8003e62450c0
> [   48.055660] Call trace:
> [   48.058095]  __list_del_entry_valid+0x2c/0xa8
> [   48.062442]  ccp_tx_submit+0x84/0x168 [ccp]
> [   48.066615]  async_tx_submit+0x224/0x368 [async_tx]
> [   48.071480]  async_trigger_callback+0x68/0xfc [async_tx]
> [   48.076784]  ops_run_biofill+0x178/0x1e8 [raid456]
> [   48.081566]  raid_run_ops+0x248/0x818 [raid456]
> [   48.086086]  handle_stripe+0x864/0x1208 [raid456]
> [   48.090781]  handle_active_stripes.isra.0+0xb0/0x278 [raid456]
> [   48.096604]  raid5d+0x378/0x618 [raid456]
> [   48.100602]  md_thread+0xa0/0x150
> [   48.103905]  kthread+0x104/0x130
> [   48.107122]  ret_from_fork+0x10/0x18
> [   48.110686] Code: d2804003 f2fbd5a3 eb03003f 54000320 (f9400021)
> [   48.116766] ---[ end trace 23f390a527f7ad77 ]---
> 
> ccp_tx_submit is passed a dma_async_tx_descriptor which is contained in
> a ccp_dma_desc and adds it to a ccp channel's pending list:
> 
> 	list_del(&desc->entry);
> 	list_add_tail(&desc->entry, &chan->pending);
> 
> The problem is that desc->entry may be uninitialized in the
> async_trigger_callback path where the descriptor was gotten
> from ccp_prep_dma_interrupt which got it from ccp_alloc_dma_desc
> which doesn't initialize the desc->entry list head. So, just
> initialize the list head to avoid the problem.
> 
> Reported-by: Sahaj Sarup <sahajsarup@gmail.com>
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  drivers/crypto/ccp/ccp-dmaengine.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
