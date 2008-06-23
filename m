From: "Loc Ho" <lho@amcc.com>
Subject: RE: [PATCH 1/1 v2] crypto: Add CryptoAPI User Interface Support
Date: Mon, 23 Jun 2008 14:53:56 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D6049AD50C@SDCEXCHANGE01.ad.amcc.com>
References: <0CA0A16855646F4FA96D25A158E299D604921C4D@SDCEXCHANGE01.ad.amcc.com> <20080623120117.GA29087@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02-ext1.amcc.com ([198.137.200.73]:23241 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbYFWVx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Jun 2008 17:53:56 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080623120117.GA29087@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

IT can't get outlook to not wrap lone line. The only solution is to
attach patch file instead inline. Will do this in the future. With
regard to /dev/crypto as a char device, misc device, or syscall, we are
planning to add AIO. I don't believe it will work with syscall as I want
to use AIO infrastructure. If someone strongly believes that it is a
misc device, I guess it is okay with me. This isn't a straight char
device and we don't do normal read and write.

As for AIO, here is a possible solution: AIO uses function 'aio_read'
and 'aio_write'. I am thinking about using 'aio_write' for per operation
call. For each operation (or list of operations), caller issues an
'aio_write'. As each operation requires input parameters, the
'aio_write' user buffer is used to pass the operation parameters -
struct crypt_op. There is no 'aio_read', 'write', and 'read' functions.
This would allow striaght map to the current implementation.

-Loc
 

-----Original Message-----
From: Evgeniy Polyakov [mailto:johnpol@2ka.mipt.ru] 
Sent: Monday, June 23, 2008 5:01 AM
To: Loc Ho
Cc: Herbert Xu; linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/1 v2] crypto: Add CryptoAPI User Interface Support

Hi.

On Thu, Jun 12, 2008 at 01:54:00PM -0700, Loc Ho (lho@amcc.com) wrote:
> This is CryptoAPI user space interface support patch v2. This version
> includes:
> 
> 1. a file descriptor per tfm
> 2. Direct I/O for user data buffer (with option for single mapping) 3.

> algorithm properties is set via I/O control call 4. Per buffer 
> operation is operated via I/O control call

Number of overall moments:
 * your mailer heavily mangled patch, please fix it or attach patch next
 	time
 * be ready to defend, why /dev/crypto should be char device and not
 	misc, also why it is not a syscall :)
 * overall approach of multiple copy_from_user is noticebly slower than
 	single copy_from_user of the whole structure and they parse it
	according to internal fields
 * the same applies to multiple allocations: try to avoid it as much as
 	possible and allocate whole structure in one go

-- 
	Evgeniy Polyakov
