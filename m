From: "Lingbo Tang (SINA)" <tanglb@sina.com>
Subject: Re: =?UTF-8?B?5Zue5aSN77yaUmU6IHZnZGlzcGxheSBwcm9ibGVtIHdpdGggaGk=?=
 =?UTF-8?B?Zm43OTV4?=
Date: Sat, 06 Dec 2008 22:09:55 +0800
Message-ID: <493A87B3.3050209@sina.com>
References: <20081130082600.C00C836FC34@mail3-113.sinamail.sina.com.cn> <20081130101208.GA20720@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3-167.sinamail.sina.com.cn ([202.108.3.167]:51469 "EHLO
	smtp3-75.sinamail.sina.com.cn" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755871AbYLFOKU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Dec 2008 09:10:20 -0500
Received: from mail5-202.sinamail.sina.com.cn (unknown [10.55.5.202])
	by smtp3-75.sinamail.sina.com.cn (SINAMAIL) with ESMTP id 0E84DD632CC
	for <linux-crypto@vger.kernel.org>; Sat,  6 Dec 2008 22:10:17 +0800 (CST)
In-Reply-To: <20081130101208.GA20720@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Evgeniy Polyakov wrote:
> On Sun, Nov 30, 2008 at 04:26:00PM +0800, tanglb@sina.com (tanglb@sina.com) wrote:
>> I downloaded the source file from your link and compiled successfully.
>> But it still hang when I tried to run "mkfs.xfs".
> 
> Please enable debug mode with attached patch and send dmesg output.
> Thank you.

The weird thing is that there is no problem if I turned on the debug
option. I can see kcryptd taking 99% CPU time and there are many
debug output from the serial port, but the encrypted LVM worked eventually.

In some cases the non-debug version can work with "mkfs.xfs", but it
could not in most case.
I tried to disable most services in the system, but it seems have no
related to the system load.

> 
> diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
> index 6e9b39c..ca621f6 100644
> --- a/drivers/crypto/hifn_795x.c
> +++ b/drivers/crypto/hifn_795x.c
> @@ -38,7 +38,7 @@
>  
>  #include <asm/kmap_types.h>
>  
> -//#define HIFN_DEBUG
> +#define HIFN_DEBUG
>  
>  #ifdef HIFN_DEBUG
>  #define dprintk(f, a...) 	printk(f, ##a)
> 


