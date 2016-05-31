From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/8] crypto: caam - add support for LS1043A SoC
Date: Tue, 31 May 2016 18:15:28 +0800
Message-ID: <20160531101528.GD15376@gondor.apana.org.au>
References: <1463670405-1059-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shawn Guo <shawnguo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
	Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36481 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbcEaKQC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 06:16:02 -0400
Content-Disposition: inline
In-Reply-To: <1463670405-1059-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 19, 2016 at 06:06:45PM +0300, Horia Geant=C4=83 wrote:
> v3:
> -DT maintainers - please ack patch 8/8 "arm64: dts: ls1043a: add cryp=
to node"
> (to go into kernel 4.8 via crypto tree)
> -Fixed typo in pdb.h: s/be32/__be32
> -Appended Acks (from v2) into commit messages
> -Tested that current patch set works on top of RSA support being adde=
d by
> Tudor Ambarus:
> [PATCH v6 0/3] crypto: caam - add support for RSA algorithm
> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg19085.ht=
ml

Patches 1 through 7 applied.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
