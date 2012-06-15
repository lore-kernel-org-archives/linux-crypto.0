From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: RFC: support for MV_CESA with IDMA or TDMA
Date: Fri, 15 Jun 2012 11:51:24 +0200
Message-ID: <20120615095124.GK9122@philter.vipri.net>
References: <20120612113941.GA14757@gondor.apana.org.au>
 <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
 <4FDA928C.6030601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: "cloudy.linux" <cloudy.linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:34146 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246Ab2FOJvd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jun 2012 05:51:33 -0400
Content-Disposition: inline
In-Reply-To: <4FDA928C.6030601@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Fri, Jun 15, 2012 at 09:40:28AM +0800, cloudy.linux wrote:
> I would like to have a try on those patches. But what version of kern=
el=20
> should I apply those patches on?

Sorry for the caused confusion. I have applied those patches to linus'
git, preceded by the three accepted ones of the earlier four. Yay.

Long story short, please just fetch git://nwl.cc/~n0-1/linux.git and
checkout the 'cesa-dma' branch. It's exactly what I formatted the
patches from.

Greetings, Phil


Phil Sutter
Software Engineer

--=20


Viprinet GmbH
Mainzer Str. 43
55411 Bingen am Rhein
Germany

Phone/Zentrale:         +49-6721-49030-0
Direct line/Durchwahl:  +49-6721-49030-134
=46ax:                    +49-6721-49030-209

phil.sutter@viprinet.com
http://www.viprinet.com

Registered office/Sitz der Gesellschaft: Bingen am Rhein
Commercial register/Handelsregister: Amtsgericht Mainz HRB40380
CEO/Gesch=C3=A4ftsf=C3=BChrer: Simon Kissel
