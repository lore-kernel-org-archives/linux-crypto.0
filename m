From: "Loc Ho" <lho@amcc.com>
Subject: RE: Userspace API proposal was: Re: [PATCH 1/1] RFC: Add CryptoAPI User Space Interface Support
Date: Wed, 14 May 2008 08:40:43 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D604720974@SDCEXCHANGE01.ad.amcc.com>
References: <DB599F406D04E34389140B7D99C71B1B055EE51E@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60301C29D@SDCEXCHANGE01.ad.amcc.com> <DB599F406D04E34389140B7D99C71B1B055EE6B2@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60472088A@SDCEXCHANGE01.ad.amcc.com> <20080514103224.GA10416@Chamillionaire.breakpoint.cc> <20080514110311.GA22116@gondor.apana.org.au> <20080514115730.GA10664@Chamillionaire.breakpoint.cc> <20080514121855.GA14949@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Shasi Pulijala" <spulijala@amcc.com>,
	<linux-crypto@vger.kernel.org>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
	"Sebastian Siewior" <linux-crypto@ml.breakpoint.cc>,
	"Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02-ext1.amcc.com ([198.137.200.73]:43173 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbYENPlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2008 11:41:07 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080514121855.GA14949@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

We here would like to create an user space interface that can be
accepted into Linux CryptoAPI. Therefore, let me summary the current
suggestion:

Option #1:
1. Use file descriptor named '/dev/crypto' or use syscall
2. Each opened file creates a new 'crypto' context that represents a
crypto algorithms - crypto, hash, compression, etc
3. The type of algorithm (#2) is selected via IO control call - like I/O
control with algorithm ASCII name
4. The key and other attributes are set via I/O control
5. Operation such as encrypt, decrypt, hash, and etc are operated via
function write and read. Caller is expected to read the entire result
blocks. If not, failed with an error code.
6. It supports asyncrhonous as file descriptor can be in non-blocking
mode
7. For hash and possible other operation, a read will also execute
final. I don't like this unless it is preceded with a flush call.

Option #2:
1. Use syscall with algorithm name and its associated parameters
2. Operation such as encrypt, decrypt, hash, and etc are operated via
another two system call - crypto_read and crypto_write
3. For this option, how should one handle asynchronous operation???

Option #3:

1. Use syscall to create a special crypto device folder per an algorithm
2. A handle is returned and a crypto filesystem entry is create for that
handle
3. Crypto parameter can be set based on read/write on that folder
4. Crypto operation will be based on file created under that folder. It
will inherit all crypto attributes of that folder.
5. And etc... (See previous email)
6. This approach is overkill and totally unnecessary.

Does this email summary all suggested solution? If not please add to
this list. Which one will like be accepted into the crypto tree???

-Loc
