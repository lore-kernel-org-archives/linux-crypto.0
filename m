From: Fabio Estevam <festevam@gmail.com>
Subject: mxs-dcp: BUG: init/1 still has locks held!
Date: Sun, 11 May 2014 16:57:57 -0300
Message-ID: <CAOMZO5AdHCsCXW-WhRpkZJJcsmoQKvob_zhx-7fu8RSim5-dQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marex@denx.de>,
	Shawn Guo <shawn.guo@freescale.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:40229 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238AbaEKT57 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 May 2014 15:57:59 -0400
Received: by mail-ve0-f172.google.com with SMTP id oz11so7831043veb.3
        for <linux-crypto@vger.kernel.org>; Sun, 11 May 2014 12:57:57 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Running linux-next 20140509 on a mx28evk I observe the following warning:

[    8.526613] Freeing unused kernel memory: 232K (c0683000 - c06bd000)
starting pid 56, tty '': '/etc/rc.d/rcS'
[    9.110314]
[    9.111864] =====================================
[    9.116603] [ BUG: init/1 still has locks held! ]
[    9.121488] 3.15.0-rc4-next-20140509-00001-g319564e #1154 Not tainted
[    9.128071] -------------------------------------
[    9.132825] 1 lock held by init/1:
[    9.136252]  #0:  (global_mutex){+.+.+.}, at: [<c0387d68>] mxs_dcp_probe+0x14
[    9.144196]
[    9.144196] stack backtrace:
[    9.148888] CPU: 0 PID: 1 Comm: init Not tainted 3.15.0-rc4-next-20140509-004
[    9.157610] [<c000da40>] (unwind_backtrace) from [<c000bda4>] (show_stack+0x)
[    9.165595] [<c000bda4>] (show_stack) from [<c00153d4>] (do_fork+0x2c8/0x3cc)
[    9.172921] [<c00153d4>] (do_fork) from [<c0015550>] (sys_vfork+0x20/0x2c)
[    9.179973] [<c0015550>] (sys_vfork) from [<c0009580>] (ret_fast_syscall+0x0)
Mounting /proc and /sys

Should we really use a global mutex here? What is a proper fix for this?

Regards,

Fabio Estevam
