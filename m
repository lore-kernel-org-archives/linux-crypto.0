From: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: [patch 0/3] crypto: padlock-aes: enable on VIA Nano
Date: Thu, 11 Jun 2009 00:48:53 +0800
Message-ID: <20090610164853.GI4131@prithivi.gnumonks.org>
References: <20090609103533.0c334594@dhcp-100-2-144.bos.redhat.com> <20090609184203.GA22084@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chuck Ebbert <cebbert@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:35323 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbZFJQuP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2009 12:50:15 -0400
Content-Disposition: inline
In-Reply-To: <20090609184203.GA22084@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

On Tue, Jun 09, 2009 at 08:42:03PM +0200, Sebastian Andrzej Siewior wrote:
> * Chuck Ebbert | 2009-06-09 10:35:33 [-0400]:
> 
> >The VIA Nano has a bug that makes the padlock unit fetch extra data
> >during encryption operations. Add workarounds for that, and enable
> >the driver on x86_64.
> Nice. The X86_64 padlock will make it mainline in next merge window so
> I'm asking you kindly to rebase it against Herbert's cryptodev tree [0].
> 
> I guess the bug can trigger on 32bit if you boot the affected 64bit CPU
> in 32bit mode? I'm not sure if it is better to send this patches via
> stable tree _or_ deactivate the padlock on affected CPUs.

I have now re-confirmed the errata with VIA/Centaur guys, and it seems correct.
Also, reviewing [but not testing] the patch, it looks correct to me.

The check for stepping '2' is also correct, as stepping 3 no longer has this
issue.

Chuck, I'd be more than thankful if you could rebase and resubmit as requested.
If not, please drop me a not so i can put it on my todo list.

Acked-by: HaraldWelte <HaraldWelte@viatech.com>
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
