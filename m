From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] mxs-dcp: Remove mutex_lock from probe
Date: Mon, 12 May 2014 12:57:16 +0200
Message-ID: <201405121257.17032.marex@denx.de>
References: <1399862123-2631-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	shawn.guo@freescale.com, shc_work@mail.ru,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:58664 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaELLC1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 May 2014 07:02:27 -0400
In-Reply-To: <1399862123-2631-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday, May 12, 2014 at 04:35:23 AM, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
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
> [    9.136252]  #0:  (global_mutex){+.+.+.}, at: [<c0387d68>]
> mxs_dcp_probe+0x14 [    9.144196]
> [    9.144196] stack backtrace:
> [    9.148888] CPU: 0 PID: 1 Comm: init Not tainted
> 3.15.0-rc4-next-20140509-004 [    9.157610] [<c000da40>]
> (unwind_backtrace) from [<c000bda4>] (show_stack+0x) [    9.165595]
> [<c000bda4>] (show_stack) from [<c00153d4>] (do_fork+0x2c8/0x3cc) [   
> 9.172921] [<c00153d4>] (do_fork) from [<c0015550>] (sys_vfork+0x20/0x2c) [
>    9.179973] [<c0015550>] (sys_vfork) from [<c0009580>]
> (ret_fast_syscall+0x0)
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/crypto/mxs-dcp.c | 47
> ++++++++++++++++------------------------------- 1 file changed, 16
> insertions(+), 31 deletions(-)

You can also eliminate the DECLARE_MUTEX() for global_mutex now.

Best regards,
Marek Vasut
