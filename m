From: "Loc Ho" <lho@amcc.com>
Subject: RE: Linux CryptoAPI Userspace API proposal
Date: Wed, 4 Jun 2008 14:33:34 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D60488CA49@SDCEXCHANGE01.ad.amcc.com>
References: <0CA0A16855646F4FA96D25A158E299D60301C29D@SDCEXCHANGE01.ad.amcc.com> <DB599F406D04E34389140B7D99C71B1B055EE6B2@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60472088A@SDCEXCHANGE01.ad.amcc.com> <20080514103224.GA10416@Chamillionaire.breakpoint.cc> <20080514110311.GA22116@gondor.apana.org.au> <20080514115730.GA10664@Chamillionaire.breakpoint.cc> <20080514121855.GA14949@2ka.mipt.ru> <0CA0A16855646F4FA96D25A158E299D604720974@SDCEXCHANGE01.ad.amcc.com> <20080514160941.GA7419@2ka.mipt.ru> <0CA0A16855646F4FA96D25A158E299D604720DDA@SDCEXCHANGE01.ad.amcc.com> <20080520040043.GA7156@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Shasi Pulijala" <spulijala@amcc.com>,
	<linux-crypto@vger.kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02-ext1.amcc.com ([198.137.200.73]:33566 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbYFDVdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Jun 2008 17:33:37 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080520040043.GA7156@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

We re-work part of the user space API. I would like to run it by you for
comment:

The Linux CryptoAPI User Interface behaves as follow:

1. User access via file descriptor /dev/crypto
2. Each opened file dscriptor represents a tfm
3. Algorithm and properties are set via an I/O control function call.
4. Algorithm name is string based and other properties are the same as
before
5. Use I/O control for per operation such as encrypt, decrypt, compress,
PKA, and hashing.
5a. Synchrnous call supports only (for the moment) as asynchronous
requires notification and complicates the design
5b. Operation destinction/result is byte pointer based, which can be
in-line
5c. Use direct I/O (no memory copy between user space and kernel space,
except key, hash result, IV, and associated data)

We will be submitting soon...

-Loc 

-----Original Message-----
From: Herbert Xu [mailto:herbert@gondor.apana.org.au] 
Sent: Monday, May 19, 2008 9:01 PM
To: Loc Ho
Cc: Evgeniy Polyakov; Sebastian Siewior; Shasi Pulijala;
linux-crypto@vger.kernel.org
Subject: Re: Linux CryptoAPI Userspace API proposal

On Thu, May 15, 2008 at 01:16:03PM -0700, Loc Ho wrote:
> 
> Linux Crypto User Space Interface Requirement:
> 
> 1. Support crypto and hashing/digest
> 2. Flexible to support compression in the future 3. Flexible to 
> support PKA (public key acceleration) in the future

I think extensibility as you've noted is really important.

As the crypto API is really an algorithm API, please make this interface
generic enough so that adding new (potentially non-crypto) operations is
easy.

> 4. A file descriptor per algorithms
> 5. Key and algorithm attributes provided by user space application
> (caller)

I would say that a file descriptor per tfm would make more sense.

> 8. Support cancel a pending operation for user space caller

We don't need to be able to cancel a specific operation.  The ability to
free a tfm and thereby flushing all requests associated with it should
be enough.

> 3. The type of algorithm, key, and other attributes are selected via 
> IO control call. This will be a single call.

Being a single call doesn't matter too much here because this is the
slow path.

> 5. Interface for per operation (such as encrypt, decrypt, compress, 
> PKA, and hashing)

It might be useful to consider an interface that allowed in-place
operations.

