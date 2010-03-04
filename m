From: Roberto Sassu <myrobmail@gmail.com>
Subject: Re: Suspect bug in the authenc module
Date: Thu, 4 Mar 2010 11:54:05 +0100
Message-ID: <201003041154.05369.myrobmail@gmail.com>
References: <201002271214.15414.myrobmail@gmail.com> <20100301132433.GA20729@secunet.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:52880 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab0CDKyK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Mar 2010 05:54:10 -0500
Received: by fxm19 with SMTP id 19so2664819fxm.21
        for <linux-crypto@vger.kernel.org>; Thu, 04 Mar 2010 02:54:08 -0800 (PST)
In-Reply-To: <20100301132433.GA20729@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

i pulled the crypto-2.6 repo today. Issues appear to be solved for both 32-bit 
and 64-bit systems. Many thanks!

I have got another trouble when compiling my test module with a 64-bit 
operating system:

when dumping the data placed pointed by the scatterlist array i noted that the 
assoc is always zero'ed. I investigated further and it seems that the problem 
is the static allocation of the assoc string in my test module. When using the 
kmalloc the dump is correct.   

On Monday 01 March 2010 14:24:33 Steffen Klassert wrote:
> On Sat, Feb 27, 2010 at 12:14:15PM +0100, Roberto Sassu wrote:
> > Hello
> > 
> > i'm trying to use the authenc module and i wrote a small kernel module
> > that simply encrypts/decrypts a fixed data using the hmac(sha1) as
> > authentication algorithm and cbc(aes) as encryption algorithm.
> > The used platform is a KVM quest with Fedora 12 i686 and the latest
> > kernel 2.6.33.
> > I have taken the code from the testmgr and from net/ipv4/esp4.c.
> > But, when testing the code, attached in this mail, the
> > crypto_aead_decrypt() function always replies -EBADMSG.
> 
> I've posted two fixes for authenc to the linux-crypto list last week.
> Could you please try whether these patches fix your problems?
> 
> Thanks,
> 
> Steffen
