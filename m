From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC][PATCH] Pseudo-random number generator
Date: Thu, 7 Dec 2006 19:43:13 +0100
Message-ID: <200612071943.14153.arnd@arndb.de>
References: <1164979155.5882.23.camel@bender> <200612071606.33951.arnd@arndb.de> <1165504796.5607.17.camel@bender>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:63865 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163183AbWLGSnV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Dec 2006 13:43:21 -0500
To: Jan Glauber <jan.glauber@de.ibm.com>
In-Reply-To: <1165504796.5607.17.camel@bender>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday 07 December 2006 16:19, Jan Glauber wrote:
> Hm, why is /dev/urandom implemented in the kernel?
> 
> It could be done completely in user-space (like libica already does)
> but I think having a device node where you can read from is the simplest
> implementation. Also, if we can solve the security flaw we could use it
> as replacement for /dev/urandom.

urandom is more useful, because can't be implemented in user space at
all. /dev/urandom will use the real randomness from the kernel as a seed
without depleting the entropy pool. How does your /dev/prandom device
compare to /dev/urandom performance-wise? If it can be made to use
the same input data and it turns out to be significantly faster, I can
see some use for it.

	Arnd <><
