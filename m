From: Stephan Mueller <smueller@chronox.de>
Subject: [RFC] AF_ALG AIO and IV
Date: Fri, 12 Jan 2018 14:21:15 +0100
Message-ID: <2118226.LQArbCsRu5@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: harsh@chelsio.com, jonathan.cameron@huawei.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58232 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932976AbeALNVS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jan 2018 08:21:18 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

The kernel crypto API requires the caller to set an IV in the request data 
structure. That request data structure shall define one particular cipher 
operation. During the cipher operation, the IV is read by the cipher 
implementation and eventually the potentially updated IV (e.g. in case of CBC) 
is written back to the memory location the request data structure points to.

AF_ALG allows setting the IV with a sendmsg request, where the IV is stored in 
the AF_ALG context that is unique to one particular AF_ALG socket. Note the 
analogy: an AF_ALG socket is like a TFM where one recvmsg operation uses one 
request with the TFM from the socket.

AF_ALG these days supports AIO operations with multiple IOCBs. I.e. with one 
recvmsg call, multiple IOVECs can be specified. Each individual IOCB (derived 
from one IOVEC) implies that one request data structure is created with the 
data to be processed by the cipher implementation. The IV that was set with 
the sendmsg call is registered with the request data structure before the 
cipher operation.

In case of an AIO operation, the cipher operation invocation returns 
immediately, queuing the request to the hardware. While the AIO request is 
processed by the hardware, recvmsg processes the next IOVEC for which another 
request is created. Again, the IV buffer from the AF_ALG socket context is 
registered with the new request and the cipher operation is invoked.

You may now see that there is a potential race condition regarding the IV 
handling, because there is *no* separate IV buffer for the different requests. 
This is nicely demonstrated with libkcapi using the following command which 
creates an AIO request with two IOCBs each encrypting one AES block in CBC 
mode:

kcapi  -d 2 -x 9  -e -c "cbc(aes)" -k 
8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -i 
7fbc02ebf5b93322329df9bfccb635af -p 48981da18e4bb9ef7e2e3162d16b1910

When the first AIO request finishes before the 2nd AIO request is processed, 
the returned value is:

8b19050f66582cb7f7e4b6c873819b7108afa0eaa7de29bac7d903576b674c32

I.e. two blocks where the IV output from the first request is the IV input to 
the 2nd block.

In case the first AIO request is not completed before the 2nd request 
commences, the result is two identical AES blocks (i.e. both use the same IV):

8b19050f66582cb7f7e4b6c873819b718b19050f66582cb7f7e4b6c873819b71

This inconsistent result may even lead to the conclusion that there can be a 
memory corruption in the IV buffer if both AIO requests write to the IV buffer 
at the same time.

This needs to be solved somehow. I see the following options which I would 
like to have vetted by the community.

1. Require that the cipher implementations serialize any AIO requests that 
have dependencies. I.e. for CBC, requests need to be serialized by the driver. 
For, say, ECB or XTS no serialization is necessary.

2. Change AF_ALG to require a per-request IV. This could be implemented by 
moving the IV submission via CMSG from sendmsg to recvmsg. I.e. the recvmsg 
code path would obtain the IV.

I would tend to favor option 2 as this requires code change at only location. 
If option 2 is considered, I would recommend to still allow setting the IV via 
sendmsg CMSG (to keep the interface stable). If, however, the caller provides 
an IV via recvmsg, this takes precedence.

If there are other options, please allow us to learn about them.

Ciao
Stephan
