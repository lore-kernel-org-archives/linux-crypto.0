From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: akcipher use
Date: Thu, 25 Jun 2015 12:19:32 -0700
Message-ID: <558C5444.4000105@intel.com>
References: <1708764.x5PFhLSanv@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58546 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbbFYTTp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Jun 2015 15:19:45 -0400
In-Reply-To: <1708764.x5PFhLSanv@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/25/2015 04:58 AM, Stephan Mueller wrote:
> Hi Tadeusz,
> 
> I do have a few questions around the akcipher API.
> 
> The API offers access to the raw asym encryption and decryption operations.
> 
> The "normal" use of asym ciphers is the hybrid mode. That opens the following 
> questions:
> 
> - how would a hardware implementation offering only a hybrid asym cipher 
> implementation (i.e. a full signature mechanism or bulk data encryption 
> mechanism) be usable via that API?

Usually the HW offers acceleration for encryption primitives.
To support the encryption schemes we can introduce templates for instance
pkcs1_v15(rsa) or oaep(rsa) as it was proposed by Horia Geanta.

> 
> - currently I only see one user in the kernel for asym ciphers: the module 
> signing mechanism. Do you expect more to come? Or am I missing others?
> 
> - If no, then it sounds like that the akcipher API is a means to make asym 
> ciphers implemented in hardware and only accessible from supervisor state 
> available. I would assume that the majority of the users that may be 
> interested in that kind of support resides in user space. Is the intention to 
> develop an AF_ALG interface (note, I personally already thought about that 
> subject for some time now)?

Yes, that's the main use case for this. We want to be able to accelerate SSL
handshakes.

> 
> - If user space shall also be able to use akcipher, how do you think that 
> should be handled in general? Should user space simply have access to the raw 
> asym ciphers and use that together with the hashes/sym ciphers to implement 
> the hybrid system? Or shall the kernel interface extend the skcipher/hash 
> interface with an akcipher wrapper for the hybrid system? I am currently not 
> sure which is better considering:
> 
> 	- raw asym interface: pro: lean, most flexible; con: user land must 
> know of sym key (i.e. it is located in two places), potentially more round 
> trips between kernel/user land
> 
> 	- hybrid cipher interface: just take the opposite of the raw asym 
> interface
> 
> - If the hybrid system is intended to be implemented in the kernel, would then 
> the ton of different padding schemes need to be implemented in the kernel side 
> or should user space do the padding? I would think they could stay in user 
> land (provided that there is no kernel space user).

Ideally or the padding and hashing should be done by user space and only the expensive
operations like modular exponentiation should be offloaded to HW via PF_ALG and akcipher.

regards,
T
