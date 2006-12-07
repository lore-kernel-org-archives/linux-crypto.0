From: Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [RFC][PATCH] Pseudo-random number generator
Date: Thu, 07 Dec 2006 16:19:56 +0100
Message-ID: <1165504796.5607.17.camel@bender>
References: <1164979155.5882.23.camel@bender>
	 <200612071606.33951.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:11744 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032330AbWLGP4p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Dec 2006 10:56:45 -0500
To: Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <200612071606.33951.arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 2006-12-07 at 16:06 +0100, Arnd Bergmann wrote:
> On Friday 01 December 2006 14:19, Jan Glauber wrote:
> > I've chosen the char driver since it allows the user to decide which pseudo-random
> > numbers he wants to use. That means there is a new interface for the s390
> > PRNG, called /dev/prandom.
> > 
> > I would like to know if there are any objections, especially with the chosen device
> > name.
> 
> This may be a stupid question, but what is it _good_ for? My understanding is
> that the crypt_s390_kmc() opcodes work in user mode as well as kernel mode, so
> you should not need a character device at all, but maybe just a small tool
> that spits prandom data to stdout.

Hm, why is /dev/urandom implemented in the kernel?

It could be done completely in user-space (like libica already does)
but I think having a device node where you can read from is the simplest
implementation. Also, if we can solve the security flaw we could use it
as replacement for /dev/urandom.

Jan
