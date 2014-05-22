From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] mxs-dcp: Remove global mutex
Date: Thu, 22 May 2014 21:08:38 +0800
Message-ID: <20140522130838.GA3598@gondor.apana.org.au>
References: <1399895068-3326-1-git-send-email-fabio.estevam@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, shawn.guo@freescale.com,
	marex@denx.de, shc_work@mail.ru
To: Fabio Estevam <fabio.estevam@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:60416 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbaEVNIp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 May 2014 09:08:45 -0400
Content-Disposition: inline
In-Reply-To: <1399895068-3326-1-git-send-email-fabio.estevam@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 12, 2014 at 08:44:28AM -0300, Fabio Estevam wrote:
> Remove mutex_lock from probe in order to avoid the following warning:
> 
> [    8.526613] Freeing unused kernel memory: 232K (c0683000 - c06bd000)
> starting pid 56, tty '': '/etc/rc.d/rcS'
> [    9.110314]
> [    9.111864] =====================================
> [    9.116603] [ BUG: init/1 still has locks held! ]
> [    9.121488] 3.15.0-rc4-next-20140509-00001-g319564e #1154 Not tainted
> [    9.128071] -------------------------------------
> [    9.132825] 1 lock held by init/1:
> [    9.136252]  #0:  (global_mutex){+.+.+.}, at: [<c0387d68>] mxs_dcp_probe+0x14
> [    9.144196]
> [    9.144196] stack backtrace:
> [    9.148888] CPU: 0 PID: 1 Comm: init Not tainted 3.15.0-rc4-next-20140509-004
> [    9.157610] [<c000da40>] (unwind_backtrace) from [<c000bda4>] (show_stack+0x)
> [    9.165595] [<c000bda4>] (show_stack) from [<c00153d4>] (do_fork+0x2c8/0x3cc)
> [    9.172921] [<c00153d4>] (do_fork) from [<c0015550>] (sys_vfork+0x20/0x2c)
> [    9.179973] [<c0015550>] (sys_vfork) from [<c0009580>] (ret_fast_syscall+0x0)
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
