From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Mon, 16 Jul 2012 15:52:16 +0200
Message-ID: <20120716135216.GA18870@philter.vipri.net>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
 <1339806021-14271-1-git-send-email-gmbnomis@gmail.com>
 <20120618134718.GL9122@philter.vipri.net>
 <20120618201235.GA20755@schnuecks.de>
 <20120619115123.GN9122@philter.vipri.net>
 <4FE09637.2020802@gmail.com>
 <20120619171304.GQ9122@philter.vipri.net>
 <4FE12478.2030104@gmail.com>
 <20120716093225.GB2489@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "cloudy.linux" <cloudy.linux@gmail.com>,
	Simon Baatz <gmbnomis@gmail.com>, linux-crypto@vger.kernel.org
To: Andrew Lunn <andrew@lunn.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:36174 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab2GPNwZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jul 2012 09:52:25 -0400
Content-Disposition: inline
In-Reply-To: <20120716093225.GB2489@lunn.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey Andrew,

On Mon, Jul 16, 2012 at 11:32:25AM +0200, Andrew Lunn wrote:
> I've not been following this thread too closely..
>=20
> Do you have any patches you want included into mainline?

No need to fix anything mainline, he's just testing my RFC-state DMA
engine addon to MV_CESA. Current state is failing operation on
IDMA-based machines due to errors in hardware configuration I have not
been able to track down yet. On Kirkwood (i.e. TDMA), the only hardware
I have access to, the same code runs fine.

After all, I am not sure why he decided to put you in Cc in the first
place?

Greetings, Phil


Phil Sutter
Software Engineer

--=20
VNet Europe GmbH
Mainzer Str. 43
55411 Bingen am Rhein
Germany

Management Buy-Out at Viprinet - please read
http://www.viprinet.com/en/mbo
Management Buy-Out bei Viprinet - bitte lesen Sie
http://www.viprinet.com/de/mbo

Phone/Zentrale:               +49 6721 49030-0
Direct line/Durchwahl:        +49 6721 49030-134
=46ax:                          +49 6721 49030-109

phil.sutter@viprinet.com
http://www.viprinet.com

Registered office/Sitz der Gesellschaft: Bingen am Rhein, Germany
Commercial register/Handelsregister: Amtsgericht Mainz HRB44090
CEO/Gesch=C3=A4ftsf=C3=BChrer: Simon Kissel
