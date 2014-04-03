From: Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 2/9] crypto: qce: Add register defines
Date: Thu, 3 Apr 2014 11:24:55 -0500
Message-ID: <69C277DD-FAB2-4102-BA97-8C1985E099CB@codeaurora.org>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com> <1396541886-10966-3-git-send-email-svarbanov@mm-sol.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1396541886-10966-3-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On Apr 3, 2014, at 11:17 AM, Stanimir Varbanov <svarbanov@mm-sol.com> w=
rote:

> Here are all register addresses and bit/masks used by the driver.
>=20
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> ---
> drivers/crypto/qce/regs-v5.h | 327 ++++++++++++++++++++++++++++++++++=
+++++++++
> 1 file changed, 327 insertions(+)
> create mode 100644 drivers/crypto/qce/regs-v5.h

This should be part of the first patch in the series, you shouldn=92t h=
ave any patch that doesn=92t build.

- k

--=20
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, host=
ed by The Linux Foundation
