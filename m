From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v8 0/4] crypto: add algif_akcipher user space API
Date: Fri, 11 Aug 2017 18:05:47 +0200
Message-ID: <1E882887-3F56-4A4C-AADF-2F25F4D3A7C9@holtmann.org>
References: <26359147.tCiuJ5s8mz@positron.chronox.de>
 <alpine.OSX.2.21.1708101619530.33607@cjee-mobl1.amr.corp.intel.com>
 <3151047.7kO17u1kNV@tauon.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        dhowells@redhat.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:35554 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752724AbdHKQFt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2017 12:05:49 -0400
In-Reply-To: <3151047.7kO17u1kNV@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

>> AF_ALG is best suited for crypto use cases where a socket is set up once
>> and there are lots of reads and writes to justify the setup cost. With
>> asymmetric crypto, the setup cost is high when you might only use the
>> socket for a brief time to do one verify or encrypt operation.
> 
> To me, the entire AF_ALG purpose is solely to export hardware support to user 
> space. That said, if user space wants an accelerator, a socket would be opened 
> once followed by numerous read/write requests.
> 
> Besides, I am aware of Tadeusz' patch to link algif_akcipher to the keyring 
> and I planned to port it to the current implementation. But I thought I offer 
> a small patch focusing on the externalization of the akcipher API first.
> 
> I think the keyctl and AF_ALG are no opponents, but rather are orthogonal to 
> each other. The statement I made for the KPP AF_ALG RFC applies here too:
> 
> """
> I am aware and in fact supported development of the DH support in the keys
> subsystem. The question will be raised whether the AF_ALG KPP interface is
> superfluous in light of the keys DH support. My answer is that AF_ALG KPP is
> orthogonal to the keys DH support. The keys DH support use case is that
> the keys are managed inside the kernel and thus has the focus on the
> key management. Contrary, AF_ALG KPP does not really focus on key management
> but simply externalizes the DH/ECDH support found in the kernel including
> hardware acceleration. User space is in full control of the key life cycle.
> This way, AF_ALG could be used to complement user-space network protocol
> implementations like TLS or IKE to offload the resource intense DH
> calculations to accelerators.
> “""

we do not need two interfaces for doing the same thing. Especially not one that can not handle hardware backed keys. And more important if you can not abstract an accelerator that doesn’t expose the private key at all.

If you only have a hammer, everything looks like a nail. Luckily we have more tools than just a hammer :)

Regards

Marcel
