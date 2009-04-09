From: Karl Hiramoto <karl@hiramoto.org>
Subject: Re: help for ixp4xx crypto panic
Date: Thu, 09 Apr 2009 09:05:07 +0200
Message-ID: <49DD9E23.9070101@hiramoto.org>
References: <200904091256010463689@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: hzlyc <hzlyc@tom.com>, linux-crypto@vger.kernel.org
To: timenhhf <timenhhf@163.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:35697 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbZDIHGT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2009 03:06:19 -0400
Received: from spunkymail-a7.g.dreamhost.com (balanced.mail.policyd.dreamhost.com [208.97.132.119])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 327AA17BA7F
	for <linux-crypto@vger.kernel.org>; Thu,  9 Apr 2009 00:06:18 -0700 (PDT)
In-Reply-To: <200904091256010463689@163.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

timenhhf wrote:
> hi,
> i read your mail list on net about ixp4xx_crypto panic.
> i'm using linux kernel 2.6.28.9, but i can't make the IXP425 NPEs work
> all right.
> the steps i've done as followed:
> (1) download "ixp4xx-microcode_2.4.orig.tar.gz" through the URL:
> http://packages.debian.org/zh-cn/source/sid/ixp4xx-microcode
I don't think that includes the crypto microcode. You have to get that
from intel.

> (2)tar -zxvf ixp4xx-microcode_2.4.orig.tar.gz
> (3)cp ./IxNpeMicrocode.h ixp4xx-microcode/npeDl
You have to modify the .h to select the crypto when you have correct code

> (4)gcc -Wall IxNpeMicrocode.c -o IxNpeMicrocode
> (5)./IxNpeMicrocode, can get NPE-B and NPE-C
> (6)cp NPEs to /lib/firmware : cp -a NPE-* /lib/firmware/
> echo "/sbin/mdev" > /proc/sys/kernel/hotplug
> /sbin/mdev -s
> (7)set the NPE MAC address: ifconfig eth0 hw ether 00:03:05:06:07:08
> (8)ifconfig eth0 192.168.1.1 netmask 255.255.255.0
> after so many steps have done, i can't ping out any packet through
> IXP425 mainboard.
> could you give me some advice? thanks in advance.
> best regards,

It would probally be best if we made ixp4xx_crytpo BUG() or WARN_ON() if
it does not have a crypto compatable microcode.

--
Karl
