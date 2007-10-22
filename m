From: Joy Latten <latten@austin.ibm.com>
Subject: Re: GCM & CTR (fwd)
Date: Mon, 22 Oct 2007 16:01:18 -0500
Message-ID: <200710222101.l9ML1IG4026190@faith.austin.ibm.com>
Cc: linux-crypto@vger.kernel.org, mikko.herranen@cs.helsinki.fi
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48607 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbXJVVFt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Oct 2007 17:05:49 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9ML5mK3017023
	for <linux-crypto@vger.kernel.org>; Mon, 22 Oct 2007 17:05:48 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9ML5mdu113920
	for <linux-crypto@vger.kernel.org>; Mon, 22 Oct 2007 17:05:48 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9ML5lqj030250
	for <linux-crypto@vger.kernel.org>; Mon, 22 Oct 2007 17:05:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>On Fri, Oct 19, 2007 at 10:29:32PM +0000, Joy Latten wrote:
>>
>> I think the change to CTR would be simple.  
>> If noncesize + ivsize == blocksize, then use 
>> entire counterblock as counter and pass to  
>> ctr_inc_quad(). Currently, we just fail 
>> if noncesize + ivsize == blocksize.  
>
>How about adding an explicit counter size parameter?
>
>So intead of ctr(aes,4,8) for the standard IPsec CTR we'd have
>ctr(aes,4,8,4).  Then GCM can just use ctr(aes,4,12,4).

GCM begins encryption with the counter at 2. 
CTR initializes its counter with 1 to begin encryption.
GCM then uses counter set to 1, to create authentication
tag. It must do encryption first though because the
encrypted data is passed in to create authentication tag.
Encrypting with counter initialized at 2 doesn't quite
fit into CTR...

The only resolution I can readily think of is to
allow the user to pass in the counter. It could
be part of the IV.

Thus GCM could pass in IV || 0^31 || 1 to CTR for
encryption. It would then later pass in IV || 0^32 to
create authentication tag.

So, if noncesize + ivsize == blocksize, do not initialize
a CTR counter. Instead, use "countersize" bytes from end of
IV as counter to be incremented.

So ctr(aes,0,16,4) would indicate to use last 4 bytes
of IV for counter. 

Does this seem ok?

Would there be some concern of user initializing counter,
because it could be initialized to a high number... then 
counter could rapidly rollover? Would this be a problem? 
If so, then we could use entire counterblock for counter 
in this instance and not allow user to specify countersize...

Regards,
Joy
