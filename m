From: "Loc Ho" <lho@amcc.com>
Subject: RE: User Space API for CryptoAPI
Date: Tue, 25 Mar 2008 10:37:23 -0700
Message-ID: <0CA0A16855646F4FA96D25A158E299D6043EDDC3@SDCEXCHANGE01.ad.amcc.com>
References: <20080220202543.3209.47410.stgit@jazz.citi.umich.edu> <20080324131204.GA7324@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6043EDC6C@SDCEXCHANGE01.ad.amcc.com> <20080325030723.GA12830@gondor.apana.org.au> <20080325122656.GA15675@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
	"Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail01-ext1.amcc.com ([198.137.200.72]:42463 "EHLO
	sdcmail01.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174AbYCYRh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Mar 2008 13:37:26 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080325122656.GA15675@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I want this user interface to be compatible with OpenSSL. Therefore, it
musts have the sample API as OpenSSL. Internally, it would wrap around
Linux CryptoAPI instead OCF-Linux. Each file descriptor would allow you
to create any number of cloned fd to create transformation via I/O CTL
call. Let me summary:

1. One sharable fd to issue I/O ctrl
2. I/O ctrl to create transformation on cloned fd
3. I/O ctrl to encrypt/decript/hash (structure of parameter will
determine type of operation)
4. I/O ctrl as below (taken from OCF-Linux):

/*
 * done against open of /dev/crypto, to get a cloned descriptor.
 * Please use F_SETFD against the cloned descriptor.
 */
#define CRIOGET         _IOWR('c', 100, u_int32_t)
#define CRIOASYMFEAT    CIOCASYMFEAT
#define CRIOFINDDEV     CIOCFINDDEV

/* the following are done against the cloned descriptor */
#define CIOCGSESSION    _IOWR('c', 101, struct session_op)
#define CIOCFSESSION    _IOW('c', 102, u_int32_t)
#define CIOCCRYPT       _IOWR('c', 103, struct crypt_op)
#define CIOCKEY         _IOWR('c', 104, struct crypt_kop)
#define CIOCASYMFEAT    _IOR('c', 105, u_int32_t)
#define CIOCGSESSION2   _IOWR('c', 106, struct session2_op)
#define CIOCKEY2        _IOWR('c', 107, struct crypt_kop)
#define CIOCFINDDEV     _IOWR('c', 108, struct crypt_find_op)

Any comments?

-Loc

-----Original Message-----
From: Evgeniy Polyakov [mailto:johnpol@2ka.mipt.ru] 
Sent: Tuesday, March 25, 2008 5:27 AM
To: Herbert Xu
Cc: Loc Ho; linux-crypto@vger.kernel.org
Subject: Re: User Space API for CryptoAPI

Hi.

On Tue, Mar 25, 2008 at 11:07:23AM +0800, Herbert Xu
(herbert@gondor.apana.org.au) wrote:
> > Is there an user space API driver wrap around Linux CryptoAPI? I 
> > notice there is OCF-Linux which has an user interface that works
with OpenSSL.
> > It seems to use Linux CryptoAPI if there is no hardware offload with

> > OCF. In addition, there is a fellow which developed cryptodev patch 
> > around Linux CryptoAPI but it is limited and doesn't support 
> > everything and not compatible with OpenSSL. Are there anything else?
> 
> Evgeniy might have an implementation as well.

What I had for acrypto is not very well suitable for what we have right
now, so better create it from scratch.

> I haven't had much time to look at this recently, but an fd-based 
> scheme involving splice could be interesting.

Yes, I belive the simpler it is, the better result.
Like creating tfm per opened file descriptor with ability to change
cipher/mode/whatever via ioctl.

-- 
	Evgeniy Polyakov
