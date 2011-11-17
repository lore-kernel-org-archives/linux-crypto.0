From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/5] crypto: talitos - add hmac algorithms
Date: Thu, 17 Nov 2011 11:15:07 -0600
Message-ID: <20111117111507.134f0f1e72cb5b2d31fc8346@freescale.com>
References: <20111116181916.e2473c5856b852dea7bcf83f@freescale.com>
	<CALg11mhubBSZU=MxX_MAw115w5fQT6_v7mbQ74E=ZdWX6yt_2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: <lee.nipper@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:58646 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab1KQRQI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Nov 2011 12:16:08 -0500
In-Reply-To: <CALg11mhubBSZU=MxX_MAw115w5fQT6_v7mbQ74E=ZdWX6yt_2A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 17 Nov 2011 09:01:16 -0600
Lee Nipper <lee.nipper@gmail.com> wrote:

> Thanks Kim for re-submitting this patch, and the fix for avoiding
> sec2.0 problem.

thanks for the code - sorry it took so long - the AH fix below was a
good motivator.

> Since I don't have sec2.1+ h/w, I won't be able to hammer test it. :(

truth be told, I only tested with the alg. registration time tests
myself ;)

> Does AH IPsec now function with talitos hmac with this patch ?

once these:

http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=commitdiff;h=b7ea81a58adc123a4e980cb0eff9eb5c144b5dc7

http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=commitdiff;h=069294e813ed5f27f82613b027609bcda5f1b914

go in, I'm sure it will :)

Kim
