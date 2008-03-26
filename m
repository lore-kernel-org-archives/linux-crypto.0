From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: User Space API for CryptoAPI
Date: Thu, 27 Mar 2008 00:48:21 +0300
Message-ID: <20080326214821.GA4066@2ka.mipt.ru>
References: <20080220202543.3209.47410.stgit@jazz.citi.umich.edu> <20080324131204.GA7324@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D6043EDC6C@SDCEXCHANGE01.ad.amcc.com> <20080325030723.GA12830@gondor.apana.org.au> <20080325122656.GA15675@2ka.mipt.ru> <0CA0A16855646F4FA96D25A158E299D6043EDDC3@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53738 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbYCZVpS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Mar 2008 17:45:18 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D6043EDDC3@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Tue, Mar 25, 2008 at 10:37:23AM -0700, Loc Ho (lho@amcc.com) wrote:
> I want this user interface to be compatible with OpenSSL. Therefore, it
> musts have the sample API as OpenSSL. Internally, it would wrap around
> Linux CryptoAPI instead OCF-Linux. Each file descriptor would allow you
> to create any number of cloned fd to create transformation via I/O CTL
> call. Let me summary:
> 
> 1. One sharable fd to issue I/O ctrl
> 2. I/O ctrl to create transformation on cloned fd
> 3. I/O ctrl to encrypt/decript/hash (structure of parameter will
> determine type of operation)
> 4. I/O ctrl as below (taken from OCF-Linux):

Besides the fact, that it is completely non-understandible for me, idea
might look not that bad.

I believe you will create a tf object for each opened file descriptor
and then setup it via ioctls. Probably it is the easiest and simplest
solution, but there are lots of people who believe ioctls should not
exist and instead new system call has to be implemented... So, cook up
your code to be easily transferred from char device ioctl to syscall
interface.

-- 
	Evgeniy Polyakov
