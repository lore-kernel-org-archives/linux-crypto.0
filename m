From: Michael Buesch <mb@bu3sch.de>
Subject: Re: [HIFN 00/03]: RNG support v2
Date: Mon, 19 Nov 2007 20:04:35 +0100
Message-ID: <200711192004.35489.mb@bu3sch.de>
References: <20071118213241.9217.7696.sendpatchset@localhost.localdomain> <200711191919.42466.mb@bu3sch.de> <4741D515.3050900@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, johnpol@2ka.mipt.ru,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43924
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbXKSTFg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Nov 2007 14:05:36 -0500
In-Reply-To: <4741D515.3050900@trash.net>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Monday 19 November 2007 19:25:25 Patrick McHardy wrote:
> Michael Buesch wrote:
> > On Sunday 18 November 2007 22:32:52 Patrick McHardy wrote:
> >> These patches add support for using the HIFN rng.
> > 
> > Acked-by: Michael Buesch <mb@bu3sch.de>
> > 
> > Patrick, can you send this patchset to Andrew for inclusion into -mm?
> 
> 
> I think he already pulls from Herbert's cryptodev-2.6 tree
> (otherwise the patches useless anyway since the HIFN driver
> is only in that tree).
> 
> 
> 

Ok, well. Then apply it to any tree you like and push it
upstream somehow. I'm OK with it.

-- 
Greetings Michael.
