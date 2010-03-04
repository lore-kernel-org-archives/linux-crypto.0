From: Dimitrios Siganos <dimitris@siganos.org>
Subject: Question about async operations
Date: Thu, 04 Mar 2010 17:38:51 +0000
Message-ID: <4B8FF02B.5090600@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lvps94-136-60-187.vps.webfusion.co.uk ([94.136.60.187]:47516
	"EHLO siganos.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab0CDRiz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Mar 2010 12:38:55 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I have a question about the asynchronous characteristics of the crypto api.

1) crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC), does this code create 
an asynchronous sha1 transform?

2) crypto_alloc_hash("sha1", 0, 0), does this code create a synchronous 
sha1 transform?

3) Is synchronous taken to mean the follwoing? When the function returns 
(and is successful) the result is already computed and placed at the 
destination.

4) Is asynchronous taken to mean the following?  "When the function 
returns (and is successful) we know that a request has been posted for 
the operation to take place but we have no guarantees that the operation 
has completed.

5) If the answer to the above is yes then how can the following style of 
code work? I see such code in many places:
    crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
    crypto_hash_init(&desc);
    rc = crypto_hash_update(&desc, &sg, len);
    rc = crypto_hash_final(&desc, dst);
    now_use_dst(dst);
How can we know that the dst has the right contents when we call 
"now_use_dst(dst)"? Is there something that I am missing?

Regards,
Dimitris
