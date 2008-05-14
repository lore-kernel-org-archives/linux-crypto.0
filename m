From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 1/1] RFC: Add CryptoAPI User Space Interface Support
Date: Wed, 14 May 2008 15:25:23 +0400
Message-ID: <20080514112523.GA13073@2ka.mipt.ru>
References: <DB599F406D04E34389140B7D99C71B1B055EE51E@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60301C29D@SDCEXCHANGE01.ad.amcc.com> <DB599F406D04E34389140B7D99C71B1B055EE6B2@SDCEXCHANGE01.ad.amcc.com> <0CA0A16855646F4FA96D25A158E299D60472088A@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shasi Pulijala <spulijala@amcc.com>, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:57099 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184AbYENLZo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2008 07:25:44 -0400
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D60472088A@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 13, 2008 at 05:00:58PM -0700, Loc Ho (lho@amcc.com) wrote:
> Hi Herbert,
> 
> I am re-sending this email as I don't believe it got to the mailing
> list. Due to email problem, I am forward this patch on behalf of Shasi
> Pulijala who worked on this user space interface for Linux CryptoAPI.
> This should add support for OpenSSL. Please note that user of this patch
> musts patch OpenSSL. The OpenSSL patch can be found in OCF-Linux as this
> interface uses the same I/O control interface.

There is number of problems with this patchset:
1. codying style - likely the most harmless
2. on-stack allocation should be dropped where possible
3. session id can be generated as pointer to session, not via getting
	random bytes in a loop
4. linked list of in-flight session really does not scale
5. session destruction seems to be racy
6. do not use semaphores, mutex works ok here
7. lots of kmalloc/copy_*_user also much slower than single bigger
	allocation and sinegle copy_*_user
8. use kzalloc instead of kmalloc/memset
9. having pointer in structure shared between kernel and
	userspace is very wrong
10. userspace does not know about u32 and friends, use __u32 abd others
	instead

Please also provide a high-level description of the protocol used for
crypto processing.

-- 
	Evgeniy Polyakov
