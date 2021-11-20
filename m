Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E794FC433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Nov 2021 04:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbhKTEay (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Nov 2021 23:30:54 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:56900 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236885AbhKTEaw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Nov 2021 23:30:52 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1moHyb-0001Il-4E; Sat, 20 Nov 2021 12:27:45 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1moHyZ-0006jI-MD; Sat, 20 Nov 2021 12:27:43 +0800
Date:   Sat, 20 Nov 2021 12:27:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Meng Li <Meng.Li@windriver.com>
Cc:     horia.geanta@nxp.com, pankaj.gupta@nxp.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] driver: crypto: caam: replace this_cpu_ptr with
 raw_cpu_ptr
Message-ID: <20211120042743.GD25752@gondor.apana.org.au>
References: <20211101031353.2119-1-Meng.Li@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211101031353.2119-1-Meng.Li@windriver.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 01, 2021 at 11:13:53AM +0800, Meng Li wrote:
> When enable the kernel debug config, there is below calltrace detected:
> BUG: using smp_processor_id() in preemptible [00000000] code: cryptomgr_test/339
> caller is debug_smp_processor_id+0x20/0x30
> CPU: 9 PID: 339 Comm: cryptomgr_test Not tainted 5.10.63-yocto-standard #1
> Hardware name: NXP Layerscape LX2160ARDB (DT)
> Call trace:
>  dump_backtrace+0x0/0x1a0
>  show_stack+0x24/0x30
>  dump_stack+0xf0/0x13c
>  check_preemption_disabled+0x100/0x110
>  debug_smp_processor_id+0x20/0x30
>  dpaa2_caam_enqueue+0x10c/0x25c
>  ......
>  cryptomgr_test+0x38/0x60
>  kthread+0x158/0x164
>  ret_from_fork+0x10/0x38
> According to the comment in commit ac5d15b4519f("crypto: caam/qi2
>  - use affine DPIOs "), because preemption is no longer disabled
> while trying to enqueue an FQID, it might be possible to run the
> enqueue on a different CPU(due to migration, when in process context),
> however this wouldn't be a functionality issue. But there will be
> above calltrace when enable kernel debug config. So, replace this_cpu_ptr
> with raw_cpu_ptr to avoid above call trace.
> 
> Fixes: ac5d15b4519f ("crypto: caam/qi2 - use affine DPIOs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Meng Li <Meng.Li@windriver.com>
> ---
> v2:
> 
> Add comment to describe why the raw_cpu_ptr is safe.
>  drivers/crypto/caam/caamalg_qi2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
