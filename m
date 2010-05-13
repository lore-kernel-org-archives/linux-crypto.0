From: Zdenek Kaspar <zkaspar82@gmail.com>
Subject: Re: Best mode of operation for AES-128 on x86_64?
Date: Thu, 13 May 2010 03:25:58 +0200
Message-ID: <4BEB5526.9000701@gmail.com>
References: <AANLkTikZrBQ8Va2oZAK-D1EVxt9wcniS5kf2W-GqcMWJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:46249 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541Ab0EMBaE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 May 2010 21:30:04 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkc-linux-crypto@m.gmane.org>)
	id 1OCNFS-0001RK-R1
	for linux-crypto@vger.kernel.org; Thu, 13 May 2010 03:30:02 +0200
Received: from r9hh95.net.upc.cz ([78.102.215.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Thu, 13 May 2010 03:30:02 +0200
Received: from zkaspar82 by r9hh95.net.upc.cz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Thu, 13 May 2010 03:30:02 +0200
In-Reply-To: <AANLkTikZrBQ8Va2oZAK-D1EVxt9wcniS5kf2W-GqcMWJ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dne 13.5.2010 2:07, Pedro Ribeiro napsal(a):
> Hello,
> 
> I'm currently using a LUKS volume which contains an encrypted LVM with
> itself contains my root, home and swap partitions.
> 
> My processor is a core 2 duo 2.26ghz and I'm running x86_64. I'm using
> cbc-essiv:sha256 and AES with 128 bit key.
> 
> I was wondering, is CBC mode the fastest?
> I have a fast processor and can't really complain about the read/write
> speed, but I was wondering if I could gain any speed from counter mode
> or other mode.
> 
> I would also like to ask what are the real world speed gains when
> using AES-NI? Can anyone please point me to some benchmarks, if there
> are any?
> 
> Thank for the help,
> Pedro

Hi Pedro, you can get better speeds with lower security. But before you
change your working scheme (which is good imo, I prefer XTS..) do a
quick test and compare if it's worth the pain :) ie:

$ hdparm -t /dev/sda1
$ hdparm -t /dev/mapper/sda1_crypt

Here are some numbers you should check -
http://blog.wpkg.org/2009/04/23/cipher-benchmark-for-dm-crypt-luks

My guess for single drive you're fine with your setup..

>From measuring specific server-loads and the impact on CPU frequency
scaling with cpufreq-ondemand as governor I would recommend lowering
default threshold value (95) for this load on desktop/server. ie:

$ echo 50 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold

HTH, Z.
