From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: RFC: support for MV_CESA with TDMA
Date: Tue, 29 May 2012 13:34:17 +0200
Message-ID: <20120529113416.GA5711@philter.vipri.net>
References: <1337962119-5509-1-git-send-email-phil.sutter@viprinet.com>
 <4FC2341B.8080806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: "cloudy.linux" <cloudy.linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:41212 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab2E2Ler (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 May 2012 07:34:47 -0400
Content-Disposition: inline
In-Reply-To: <4FC2341B.8080806@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Sun, May 27, 2012 at 10:03:07PM +0800, cloudy.linux wrote:
> Could the source code from the manufacturers of hardwares using kirkw=
ood=20
> be helpful?
> I saw the source code of ls-wvl from buffalo contains driver for CESA=
=2E=20
> And it deals with both IDMA and TDMA. If you need, I can send you the=
=20
> download link.

Actually, I do have the sources. Just had doubts about how useful it
would be to write code for something I couldn't test at all. OTOH,
that's probably a better start than nothing.

> I also have to point out that CESA of some orion revisions has hardwa=
re=20
> flaws that needs to be addressed which currently doesn't. Information=
=20
> about those flaws can be found in 88F5182_Functional_Errata.pdf which=
 is=20
> available on the net.

OK, thanks for the pointer! Looks like implementing combined
(crypto/digest) operation for Orion will be no fun at least.

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
