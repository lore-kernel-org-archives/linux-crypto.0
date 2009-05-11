From: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [PATCH] The VIA Hardware RNG driver is for the CPU, not Chipset
Date: Mon, 11 May 2009 12:06:51 +0800
Message-ID: <20090511040651.GH4005@prithivi.gnumonks.org>
References: <20090510062844.GD12152@prithivi.gnumonks.org> <4A076D61.1040608@list.nospam.xutrox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Arjan Koers <4kgluc2fa5qp@list.nospam.xutrox.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:44830 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZEKEKK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2009 00:10:10 -0400
Content-Disposition: inline
In-Reply-To: <4A076D61.1040608@list.nospam.xutrox.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear Arjan,

it seems like it is probably a pragmatic solution to first merge your suggested
changes (Kconfig enable for X86_64 as well as skipping any MSR activity), before
adressing the auto-loading in a potential follow-up patch.

I have sent your modifications (split in two patches, with some additional
comment/explanation) to this list.

The question is: Since according to MAINTAINERS drivers/char/hw_random is
orphaned, which route should patches go?  

Herbert: Do you accept hw_random related patches, or should they go some
different route?

Regards,
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Open Source Liaison
