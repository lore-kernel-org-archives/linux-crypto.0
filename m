From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: geode: Kill AES_MIN_BLOCK_SIZE
Date: Thu, 22 May 2014 21:08:52 +0800
Message-ID: <20140522130852.GB3598@gondor.apana.org.au>
References: <1400060201-11519-1-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
	Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Kent Yoder <key@linux.vnet.ibm.com>,
	Michal Ludvig <michal@logix.cz>,
	Varun Wadekar <vwadekar@nvidia.com>,
	Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
	linux-geode@lists.infradead.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:48433 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaEVNJK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 May 2014 09:09:10 -0400
Content-Disposition: inline
In-Reply-To: <1400060201-11519-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 14, 2014 at 11:36:38AM +0200, Marek Vasut wrote:
> This is actually defined in include/crypto/aes.h , no need to have
> a a different symbol for the same thing twice.
>=20
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> Cc: Eric B=E9nard <eric@eukrea.com>
> Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Cc: Kent Yoder <key@linux.vnet.ibm.com>
> Cc: Michal Ludvig <michal@logix.cz>
> Cc: Varun Wadekar <vwadekar@nvidia.com>
> Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> Cc: linux-geode@lists.infradead.org

All applied.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
