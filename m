From: "Loc Ho" <lho@amcc.com>
Subject: Linux CryptoAPI Userspace API proposal
Date: Thu, 15 May 2008 13:16:03 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D604720DDA@SDCEXCHANGE01.ad.amcc.com>
References: <DB599F406D04E34389140B7D99C71B1B055EE51E@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60301C29D@SDCEXCHANGE01.ad.amcc.com> <DB599F406D04E34389140B7D99C71B1B055EE6B2@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60472088A@SDCEXCHANGE01.ad.amcc.com> <20080514103224.GA10416@Chamillionaire.breakpoint.cc> <20080514110311.GA22116@gondor.apana.org.au> <20080514115730.GA10664@Chamillionaire.breakpoint.cc> <20080514121855.GA14949@2ka.mipt.ru> <0CA0A16855646F4FA96D25A158E299D604720974@SDCEXCHANGE01.ad.amcc.com> <20080514160941.GA7419@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Sebastian Siewior" <linux-crypto@ml.breakpoint.cc>,
	"Shasi Pulijala" <spulijala@amcc.com>,
	<linux-crypto@vger.kernel.org>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
	"Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02-ext1.amcc.com ([198.137.200.73]:16006 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437AbYEOUQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 May 2008 16:16:27 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080514160941.GA7419@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Linux Crypto User Space Interface Requirement:

1. Support crypto and hashing/digest
2. Flexible to support compression in the future
3. Flexible to support PKA (public key acceleration) in the future
4. A file descriptor per algorithms
5. Key and algorithm attributes provided by user space application
(caller)
6. Support non-blocking and blocking mode
7. Support multiple operation requests concurrently
8. Support cancel a pending operation for user space caller
9. Flexible to avoid double memory copy for future
10. scalable - meaning can operate on large amount of data if the
underlying algorithm support it. Hardware algorithm (such as HMAC
hashing) have a limit. This requirement complicate the interface. May
not support initially.

Linux Crypto User Space Interface Proposal:

1. Use file descriptor named '/dev/crypto'
2. Each opened file creates a new 'crypto' context that represents a
crypto algorithms - crypto, hash, compression, PKA, and etc
3. The type of algorithm, key, and other attributes are selected via IO
control call. This will be a single call.
4. Algorithm name maps directly into Linux CryptoAPI algorithm name
5. Interface for per operation (such as encrypt, decrypt, compress, PKA,
and hashing)
	5a. Read and write functions 
		5a.1. Read and write functions are stream based. We are
packet based. Using this interface isn't quite appropriate. In addition,
the input data also has an output data. Read and write doesn't quite
correlate properly. This can be a problem as the output buffer isn't
available until the read operation is performed. In addition, the caller
will have to correlate between the write and read. If it is AIO, then
this would be simpler to correlate but still doesn't solve the problem
with an output buffer requirement. For crypto, the output can be the
input buffer. But what about hashing operation. This model just does fit
well. In addition, for PKA, input operands are bundled into a single
byte array. This makes it difficults to understand.
	5b. I/O control calls
		5b.1. The objection to this is 'I/O control hell'. This
isn't that bad. To handle asynchronous I/O, once can implement
asynchronous I/O control.
	5c. System calls
		5c.1. This can be used if majority of the community
don't like to use I/O control. The first input will be the file
descriptor.

Any comments or objection?

Herbert, 

I haven't heard your comment. What do you think?

-Loc


