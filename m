From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v8 0/4] crypto: add algif_akcipher user space API
Date: Fri, 11 Aug 2017 09:18:09 +0200
Message-ID: <3151047.7kO17u1kNV@tauon.chronox.de>
References: <26359147.tCiuJ5s8mz@positron.chronox.de> <alpine.OSX.2.21.1708101619530.33607@cjee-mobl1.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        dhowells@redhat.com
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58534 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751370AbdHKHSL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2017 03:18:11 -0400
In-Reply-To: <alpine.OSX.2.21.1708101619530.33607@cjee-mobl1.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 11. August 2017, 02:48:37 CEST schrieb Mat Martineau:

Hi Mat,

> 
> AF_ALG is best suited for crypto use cases where a socket is set up once
> and there are lots of reads and writes to justify the setup cost. With
> asymmetric crypto, the setup cost is high when you might only use the
> socket for a brief time to do one verify or encrypt operation.

To me, the entire AF_ALG purpose is solely to export hardware support to user 
space. That said, if user space wants an accelerator, a socket would be opened 
once followed by numerous read/write requests.

Besides, I am aware of Tadeusz' patch to link algif_akcipher to the keyring 
and I planned to port it to the current implementation. But I thought I offer 
a small patch focusing on the externalization of the akcipher API first.

I think the keyctl and AF_ALG are no opponents, but rather are orthogonal to 
each other. The statement I made for the KPP AF_ALG RFC applies here too:

"""
I am aware and in fact supported development of the DH support in the keys
subsystem. The question will be raised whether the AF_ALG KPP interface is
superfluous in light of the keys DH support. My answer is that AF_ALG KPP is
orthogonal to the keys DH support. The keys DH support use case is that
the keys are managed inside the kernel and thus has the focus on the
key management. Contrary, AF_ALG KPP does not really focus on key management
but simply externalizes the DH/ECDH support found in the kernel including
hardware acceleration. User space is in full control of the key life cycle.
This way, AF_ALG could be used to complement user-space network protocol
implementations like TLS or IKE to offload the resource intense DH
calculations to accelerators.
"""

Ciao
Stephan
