From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: omap-sham: kmap SG pages before appending
Date: Thu, 6 Mar 2014 08:21:15 +0800
Message-ID: <20140306002115.GA30768@gondor.apana.org.au>
References: <1393957854-10961-1-git-send-email-joelf@ti.com>
 <20140305015953.GA20702@gondor.apana.org.au>
 <39412163-4B61-4490-ABC8-5BA633CC6618@ti.com>
 <20140305071109.GA22178@gondor.apana.org.au>
 <531745EE.2060804@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Vutla, Lokesh" <lokeshvutla@ti.com>
To: Joel Fernandes <joelf@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:33807 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbaCFAVT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Mar 2014 19:21:19 -0500
Content-Disposition: inline
In-Reply-To: <531745EE.2060804@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 05, 2014 at 09:42:38AM -0600, Joel Fernandes wrote:
>
> In my testing it wasn't called from softirq, I'm using cryptodev which is
> called from openssl through ioctl, here is a traceback (sorry about wrap):
> 
> [<bf8010bb>] (cryptodev_ioctl+0x282/0x59c [cryptodev])
> [  220.015390] [<bf8010bb>] (cryptodev_ioctl+0x282/0x59c [cryptodev]) from
> [<c00cdaa5>] (do_vfs_ioctl+0x61/0x41c)
> [  220.025909] [<c00cdaa5>] (do_vfs_ioctl+0x61/0x41c) from [<c00cdeab>]
> (SyS_ioctl+0x4b/0x50)
> [  220.034602] [<c00cdeab>] (SyS_ioctl+0x4b/0x50) from [<c000cf01>]
> (ret_fast_syscall+0x1/0x46)
> [  220.045254] CPU: 0 PID: 1798 Comm: openssl Tainted: G           O
> 3.12.9-00581-g5fa084c-dirty #32
> [  220.054636] [<c0012d05>] (unwind_backtrace+0x1/0x9c) from [<c000fa6d>]
> (show_stack+0x11/0x14)
> [  220.063619] [<c000fa6d>] (show_stack+0x11/0x14) from [<c0342edb>]
> (dump_stack+0x4b/0x60)
> [  220.072144] [<c0342edb>] (dump_stack+0x4b/0x60) from [<c02a1b3f>]
> (omap_sham_update+0x1f/0xa4)
> [  220.081214] [<c02a1b3f>] (omap_sham_update+0x1f/0xa4) from [<bf801f67>]
> (cryptodev_hash_update+0x26/0x80 [cryptodev])
> 
> 
> Could you suggest, what other place is update() called in softirq context?
> I may be missing something.

IPsec may call this from softirq context.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
