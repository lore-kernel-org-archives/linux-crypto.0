From: Milan Broz <mbroz@redhat.com>
Subject: Re: aesni-intel as module = cryptsetup failure
Date: Sat, 07 May 2011 21:40:20 +0200
Message-ID: <4DC5A024.2000400@redhat.com>
References: <BANLkTi=RF-FiHj5Qyh2LT5Eno+FOmvJbDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Andrew Lutomirski <luto@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050Ab1EGTkX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 7 May 2011 15:40:23 -0400
In-Reply-To: <BANLkTi=RF-FiHj5Qyh2LT5Eno+FOmvJbDw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/07/2011 04:21 AM, Andrew Lutomirski wrote:
> I just moved my boot disk from an old machine to a new machine.  The
> new machine has AES-NI and it failed to boot.
> 
> The problem appears to be that aesni-intel, when loaded as a module,
> makes cryptsetup fail on an aes-xts-plain drive.  The error looks
> like:
 
> device-mapper: reload ioctl failed: Invalid argument
> device-mapper: table: 253:0: crypt: Error allocating crypto tfm
> device-mapper: ioctl: error adding target to table

dmcrypt works with AES-NI without problem.

If it is during boot, probably just some modules are missing in your initramfs.

I remember exactly the same problem and it was caused by missing crypto/fpu.ko
kernel module, adding module to initrams explicitly
like "dracut --force --add-drivers fpu" helped in this case (on Fedora).

Milan
