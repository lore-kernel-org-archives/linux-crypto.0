From: Stephan Mueller <smueller@chronox.de>
Subject: AF_ALG: skb limits
Date: Fri, 08 Dec 2017 13:43:20 +0100
Message-ID: <3071479.2PrSHYvzOR@tauon.chronox.de>
References: <001a1141f050d78763055f85c42e@google.com> <5543369.6UIL7PonCy@positron.chronox.de> <20171208113906.000050aa@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42924 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753047AbdLHMnW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Dec 2017 07:43:22 -0500
In-Reply-To: <20171208113906.000050aa@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 8. Dezember 2017, 12:39:06 CET schrieb Jonathan Cameron:

Hi Jonathan,

> 
> As a heads up, the other nasties we've found so far are around hitting
> limits on the various socket buffers.  When you run into those you can end
> up with parts of the data to be encrypted going through without it being
> obvious.
> 

The entire code uses sock_alloc to prevent user space to chew up kernel 
memory. I am aware that if you have a too low skb buffer limit, parts of the 
cipher operation will not succeed as a malloc will fail.

But that is returned with an error to user space. If you observe such an 
error, the entire message you wanted to read with recvmsg must be considered 
tainted (i.e. you do not know which part of the message has been encrypted or 
not). Thus, the recvmsg must be invoked again on the same buffer sent to the 
kernel if you want to ensure you encrypted the data.

Could you please help me understand where that functionality fails?

PS: If you want to give more memory to your sockets, you have to tweak /proc/
sys/net/core/optmem_max.

Ciao
Stephan
