From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Asymmetric cryptography HW offloading
Date: Mon, 23 Sep 2013 15:31:29 +0300
Message-ID: <524034A1.70204@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
	David Howells <dhowells@redhat.com>,
	James Morris - <james.l.morris@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:53013
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988Ab3IWMcz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Sep 2013 08:32:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

CAAM crypto engine (drivers/crypto/caam/*) is capable of asymmetric 
operations, like: modular exponentiation, RSA 
sign/verify/encrypt/decrypt, (EC)DSA sign etc.
I would appreciate some design guidelines on how to harness these 
capabilities, for crypto engines in general.

1. In-kernel interface for asymmetric crypto
Should crypto/asymmetric_keys/* be used, i.e. appended with modular 
exponentiation, other asymmetric operations? I am asking since this 
seems to be closer to key management than to asymmetric crypto...
If so, should an algorithm priority be defined, similar to Crypto API 
interface for symmetric algos (so that for e.g. a HW implementation of 
RSA verify would be preferred over a SW implementation)? Currently 
interface does not allow for two or more implementers of the same 
algo/operation.

Currently, SW implementation of modular exponentiation - mpi_powm() - is 
used by crypto/asymmetric_keys/rsa.c and lib/digsig.c. AFAICT, its users 
could benefit from a HW-accelerated version.

2. User space interface
Should AF_ALG be expanded to provide access to this new asymmetric cypto 
API?
The API would allow user space applications to offload PKC operations in HW.
Possible use: offloading compute-intensive parts of TLS handshake, IKE.

Thanks,
Horia
