From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 3/8] arm64: add io{read,write}64be accessors
Date: Thu, 5 May 2016 18:25:52 +0100
Message-ID: <20160505172551.GG3703@e104818-lin.cambridge.arm.com>
References: <1462462435-27403-1-git-send-email-horia.geanta@nxp.com>
 <1462462564-27731-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Will Deacon <will.deacon@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Cristian Stoica <cristian.stoica@nxp.com>,
	Scott Wood <scott.wood@nxp.com>, linux-crypto@vger.kernel.org,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:51017 "EHLO foss.arm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbcEERZ5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 13:25:57 -0400
Content-Disposition: inline
In-Reply-To: <1462462564-27731-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 05, 2016 at 06:36:04PM +0300, Horia Geant=C4=83 wrote:
> This will allow device drivers to consistently use io{read,write}XXbe
> also for 64-bit accesses.
>=20
> Signed-off-by: Alex Porosanu <alexandru.porosanu@nxp.com>
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
