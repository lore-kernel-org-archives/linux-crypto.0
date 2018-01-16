From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC] AF_ALG AIO and IV
Date: Tue, 16 Jan 2018 07:28:06 +0100
Message-ID: <4179402.uxQ6q131It@tauon.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <9541120.PIfOYyT9eV@tauon.chronox.de> <20180115144258.00002dbe@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, harsh@chelsio.com,
        linuxarm@huawei.com
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58308 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbeAPG2J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jan 2018 01:28:09 -0500
In-Reply-To: <20180115144258.00002dbe@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 15. Januar 2018, 15:42:58 CET schrieb Jonathan Cameron:

Hi Jonathan,

> > What about:
> > 
> > sendmsg(IV, data)
> > sendmsg(data)
> > ..
> > AIO recvmsg with multiple IOCBs
> > AIO recvmsg with multiple IOCBs
> > ..
> > sendmsg(IV, data)
> > ..
> > 
> > This implies, however, that before the sendmsg with the second IV is sent,
> > all AIO operations from the first invocation would need to be finished.
> Yes that works fine, but rather restricts the flow - you would end up
> waiting until you could concatenate a bunch of data in userspace so as to
> trade off against the slow down whenever you need to synchronize back up to
> userspace.

I think the solution is already present and even libkcapi's architecture is 
set up to handle this scenario:

We have 2 types of FDs: one obtained from socket() and one from accept(). The 
socket-FD is akin to the TFM. The accept FD is exactly what you want:

tfmfd = socket()
setkey(tfmfd)
opfd = accept()
opfd2 = accept()
sendmsg(opfd, IV, data)
recvmsg(opfd, data)

sendmsg(opfd2, IV, data)
recvmsg(opfd2, data)

sendmsg(opfd, data)
..

There can be multipe FDs from accept and these are the "identifiers" for your 
cipher operation stream that belongs together.

libkcapi has already the architecture for this type of work, but it is not 
exposed to the API yet. The internal calls for sendmsg/recvmsg all take an 
(op)FD parameter. E.g. _kcapi_common_send_meta_fd has the fdptr variable. 
internal.h currently wraps this call into _kcapi_common_send_meta where the 
handle->opfd variable is used.

The idea why I implemented that is because the caller could maintain an array 
of opfds. If we would expose these internal calls with the FD argument, you 
can maintain multiple opfds implementing your use case.

The only change would be to expose the internal libkcapi calls.

Ciao
Stephan
