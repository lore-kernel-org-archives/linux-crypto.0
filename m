From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] crypto: Add support for ALG_SET_KEY_ID for skcipher
Date: Wed, 28 Oct 2015 11:28:31 +0900
Message-ID: <A35F1B5B-1AEA-4FDD-AB78-9285CA811B1F@holtmann.org>
References: <1445994171-30914-1-git-send-email-marcel@holtmann.org> <2166343.GZ3f8gdiNx@myon.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	herbert@gondor.apana.org.au
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:45354 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbbJ1C2j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Oct 2015 22:28:39 -0400
In-Reply-To: <2166343.GZ3f8gdiNx@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

>> This adds support for a new socket options called ALG_SET_KEY_ID that
>> allows providing the symmetric key via a key serial from the keys
>> subsystem.
>> 
>> NOTE: Currently we do not have a dedicated symmetric key type and using
>> the user key type is not optional. Also lookup_user_key() is currently
>> private to the keys subsystem and might need to be exposed to usage by
>> the crypto subystem first. This is just a RFC and not for merging !!!
> 
> First, thanks for sharing.
> 
> Albeit I have not had a deep look into that code, but I think your patch is 
> incomplete: you have to tie the kernel crypto API to the key retention system 
> in the Kconfig.
> 
> I guess that is one of the concerns that Herbert may have? See my other email 
> regarding this.

of course we have to tie this together. And I need to deal with Kconfig once we have symmetric key type support.

However I am not too much worried since reality is that the keys subsystem is pretty much mandatory if you use module signing (or firmware signing in the future). And with moving the keys subsystem to use akcipher and consolidate on a single RSA implementation in the kernel, I am not convinced that this is actually a real problem.

Also it is perfectly valid to return EOPNOTSUPP when using ALG_SET_KEY_ID and you do not have the keys subsystem configured. I do not see that as a problem.

Regards

Marcel
