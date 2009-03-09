From: Milan Broz <mbroz@redhat.com>
Subject: Re: dm/crypt oops in 2.6.28.5 ... but nvidia users aren't supposed
 to report?
Date: Mon, 09 Mar 2009 12:36:44 +0100
Message-ID: <49B4FF4C.9060604@redhat.com>
References: <200903070135.28847@rk-nord.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Melchior FRANZ <mfranz@aon.at>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49089 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbZCILgu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2009 07:36:50 -0400
In-Reply-To: <200903070135.28847@rk-nord.at>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Melchior FRANZ wrote:
> I was about to report an oops in the crypt module (NULL pointer
> dereferencing), but when I was half-way through entering the bug
> in bugzilla, I read that people with nvidia tainted kernels aren't
> supposed to file bug reports.
> 
> So the bug is going to remain unfixed!? Sounds like a smart move ...

If the bug is related to proprietary kernel module, we cannot
do anything.

Anyway, if you mean bug in dm-crypt (it is not clear from you mail)
please can you post the backtrace from this dm-crypt OOps?

Also try these patches first

http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-fix-kcryptd_async_done-parameter.patch
http://lkml.org/lkml/2009/3/5/63 

Milan
--
mbroz@redhat.com
