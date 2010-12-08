From: Kent Borg <kentborg@borg.org>
Subject: Crypto Hardware Drivers?
Date: Wed, 08 Dec 2010 16:13:48 -0500
Message-ID: <4CFFF50C.4000406@borg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from borg.org ([64.105.205.123]:42528 "EHLO borg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab0LHVnD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Dec 2010 16:43:03 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: kentborg)
	by borg.org (Postfix) with ESMTP id 0C814186781
	for <linux-crypto@vger.kernel.org>; Wed,  8 Dec 2010 16:13:48 -0500 (EST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Is this the right place to ask questions about writing a Linux device 
driver to make some crypto hardware on an ARM SoC work under the Linux 
crypto API?

I have some hardware documentation that I don't yet know whether I can 
talk about (I know, if I can't then the driver will have difficulty 
being be GPL, and if it isn't an open license, it won't work...).

I have some sample code for the hardware that is an incomplete and 
obsolete Linux module.
I can see source code examples for things like the Padlock, IXP4xx 
hardware, etc.
I have never touched any Linux kernel crypto code before this project.  
(I have done some stuff in userland, so the fact of crypto doesn't scare 
me.)

At the moment I am trying to understand things like the parameter to 
crypto_register_alg(), how that is different from crypto_register_ahash()...

And for a DMA case how data moves and who owns the memory. 

Stuff like that...

Yes, the sources and Google are my friends, and 
Documentation/crypto/api-intro.txt has a very promising title but 
doesn't say terribly much inside.

Are there any obvious key resources I should know about?  (Any general 
pointers would be appreciated, too.)


Thanks,

-kb
