From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: vgdisplay problem with hifn795x
Date: Sat, 29 Nov 2008 17:25:14 +0300
Message-ID: <20081129142514.GA354@ioremap.net>
References: <20081129124628.DBB1B36FC0E@mail3-113.sinamail.sina.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: tanglb@sina.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from corega.com.ru ([195.178.208.66]:56280 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbYK2OZR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 29 Nov 2008 09:25:17 -0500
Content-Disposition: inline
In-Reply-To: <20081129124628.DBB1B36FC0E@mail3-113.sinamail.sina.com.cn>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Sat, Nov 29, 2008 at 08:46:28PM +0800, tanglb@sina.com (tanglb@sina.com) wrote:
> I'm testing one hifn card with cryptsetup, but the vgdisplay will hang after I created the LV
> by cryptsetup. If I reboot the system, the system will hang during activating LVs at boot time.
> 
> The system is CentOS5.2+2.6.27.4 kernel. I used all default options to create the encryption disk.

I do not know what is vgdisplay, but HIFN driver got several bug fixes
recently, so if problem is related to the driver, likely it was fixed.
You may try pulling driver from the cryptodev repo [1] into your kernel
build system and compile it, or wait for the kernel update from your
vendor. Likely this bugfixes will be pushed into mainline tree in 2.6.29
merge window.

1. cryptodev tree
http://git.kernel.org/?p=linux/kernel/git/herbert/cryptodev-2.6.git

-- 
	Evgeniy Polyakov
