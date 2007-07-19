From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Looking for comments on a Linux driver for HW accelerated Kasumi+F8+F9 algorithms.
Date: Thu, 19 Jul 2007 13:48:00 +0400
Message-ID: <20070719094800.GB15839@2ka.mipt.ru>
References: <515423.29711.qm@web81310.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org
To: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33450 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbXGSJsO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Jul 2007 05:48:14 -0400
Content-Disposition: inline
In-Reply-To: <515423.29711.qm@web81310.mail.mud.yahoo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi.

On Wed, Jul 18, 2007 at 04:33:14PM -0700, tirumalareddy marri (tirumalareddymarri@yahoo.com) wrote:
> Hi ,
>   I have created Linux driver for HW accelerated
> kasumi, F8 and F9 algorithms. Could you please look at
> the driver and provide comments about the usage. This
> driver is acts as a character driver. Encryption API's
> can be accessed from kernel and user space. My concern
> is accessing the driver from user space is secure or
> not.
>  
>   If possible can some one please send me rules to
> follow when we write a Linux security driver.
> --------------------------- patch for the driver
> -----------

Sorry, but your patch looks horrible - your mailer broke alignment, you
do not follow Linux kernel coding standards. Please fix that first.

According to patch itself, do all 440epx have that engine, since you
access generic registers? Patch has too many debug prints in the hottest
path, either remove them or wrap into helper which allows to turn them
off - no one wants to read a message each time data is ready.
Encryption is not protected against simultaneous access - there will be
either bug or data corruption if several users simultaneously try to
perfrom a processing. There is number of missed checks of the returned
values of the functions which can fail. There is number of exported
symbols without appropriate in-kernel users - it is not allowed.

And userspace interface - I will not argue if it is good or bad, but be
ready to listen quite a few phrases about your taste.

I would suggest to create a generic userspace interface to deliver
crypto events to/frm userspace and bind it to cryptoapi. You also likely
want to create a cryptoapi driver to allow in-kernel subsystem to use
kasumi at least.

-- 
	Evgeniy Polyakov
