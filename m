From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: unable to finish booting when "crypto: crct10dif - Wrap crc_t10dif
 function all to use crypto transform framework" applied
Date: Thu, 11 Jul 2013 20:57:52 +0930
Message-ID: <51DE96B8.6000109@internode.on.net>
References: <51D8420C.7010602@internode.on.net> <1373385611.22432.230.camel@schen9-DESK> <51DC52C7.3010101@internode.on.net> <1373405654.22432.258.camel@schen9-DESK> <20130710061621.GA20488@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:11595 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab3GKL16 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jul 2013 07:27:58 -0400
In-Reply-To: <20130710061621.GA20488@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote, on 10/07/13 15:46:
> On Tue, Jul 09, 2013 at 02:34:14PM -0700, Tim Chen wrote:
>>
>>> I'm not sure what the root disk is doing, just using Debian's mk-kpkg
>>> kernel_package to build a kernel with an initial ramdisk.
>>>
>>> On one of the failed boot-up attempts I saw an error like:
>>>
>>> sd_mod - unknown symbol crc*
>>
>> If you have any detailed dumps on the messages from sd_mod that will
>> be helpful.
>
> I think that's the key.  Whatever is creating the initrd of that
> distro isn't including the new crct10dif module.  I can't believe
> they still haven't fixed the initrd tools to do dependency checking.
>
> Cheers,

Hi, sorry for the late reply. Thanks both to Tim Chen and Herbert Xu for 
your help!

In more recent git pulls from Linus' tree the kernel builds and runs 
fine using Debian's mk-kpg.

If it is possible to use git-bisect to find which commit fixed the 
problem I am happy to do so, or run any tools on the created initrd to 
see if there was a problem with its creation that caused the problem I 
reported against the kernel.

Regards,

Arthur.
