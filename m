From: Joy Latten <latten@austin.ibm.com>
Subject: Re: [PATCH 1/1]: CTR mode implementation
Date: Mon, 24 Sep 2007 19:31:32 -0500
Message-ID: <200709250031.l8P0VWjo014505@faith.austin.ibm.com>
Cc: linux-crypto@vger.kernel.org, tgraf@suug.ch
To: herbert.xu@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47048 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbXIYAfR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Sep 2007 20:35:17 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8P0ajli023475
	for <linux-crypto@vger.kernel.org>; Mon, 24 Sep 2007 20:36:45 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8P0ZG57561746
	for <linux-crypto@vger.kernel.org>; Mon, 24 Sep 2007 20:35:16 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8P0ZGUB020986
	for <linux-crypto@vger.kernel.org>; Mon, 24 Sep 2007 20:35:16 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

>> > I suggest that you make these parameters to your CTR template.
>> > So instead of requesting for "ctr(aes)", you could request for
>> > "ctr(aes, 4, 8)" where 4 is the length of the nonce in the
>> > counter block and 8 is the length of the IV.  The counter
>> > itself would then be calculated as block_size - 4 - 8.
>> > 
>> Ok, pretty much had this coded up when it dawned on me
>> maybe I should include the nonce as parameter too.
>> Whenever you use ctr, it is a given you need the nonce.
>> Couldn't the user of the api, separate the nonce from 
>> the key and pass it in the template? It would solve
>> my problem about sometimes the keylen is bigger than 
>> max-key-length for the algorithm with the additional bytes 
>> for nonce. So, I could pass in ctr(aes, nonce, noncesize, ivsize).
>> Let me know if this sounds ok or did I miss something important?
>
>It would be awkward to have the actual nonce as a parameter
>because for IPsec at least it's negotiated through the same
>process as the encryption key.
>
>More importantly, for the same "ctr(aes, 4, 8)" tuple, there
>are many users (each SA would need two) while for if you
>include the actual nonce then each tuple would be used by just
>one SA.

Ahhhhh, ok. Yes, you are right.

I have another question regarding this change to using a tuple.
The size of my counter is now, csize = blocksize - (noncesize + ivsize).
rfc 3686 (CTR-AES for ESP) states in section 4, that the counter
portion of the counter block be a 32-bit big endian. To keep
code endian-neutral as I can, would it be appropriate if I only did
this when my csize is 2, 4 or 8 bytes so I can easily use be16_to_cpu(), 
be32_to_cpu() and be64_to_cpu() respectively? And for all other 
sizes for csize, don't worry about this "endian" requirement, just store as is. 
Does it matter that I store the 32 bits as big endian?

Regards,
Joy
