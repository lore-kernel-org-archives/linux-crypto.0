From: Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [PATCH 2/9] crypto: qce: Add register defines
Date: Thu, 03 Apr 2014 19:33:00 +0300
Message-ID: <533D8D3C.4010108@mm-sol.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com> <1396541886-10966-3-git-send-email-svarbanov@mm-sol.com> <69C277DD-FAB2-4102-BA97-8C1985E099CB@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
To: Kumar Gala <galak@codeaurora.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:56839 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbaDCQdC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Apr 2014 12:33:02 -0400
In-Reply-To: <69C277DD-FAB2-4102-BA97-8C1985E099CB@codeaurora.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On 04/03/2014 07:24 PM, Kumar Gala wrote:
>=20
> On Apr 3, 2014, at 11:17 AM, Stanimir Varbanov <svarbanov@mm-sol.com>=
 wrote:
>=20
>> Here are all register addresses and bit/masks used by the driver.
>>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> ---
>> drivers/crypto/qce/regs-v5.h | 327 +++++++++++++++++++++++++++++++++=
++++++++++
>> 1 file changed, 327 insertions(+)
>> create mode 100644 drivers/crypto/qce/regs-v5.h
>=20
> This should be part of the first patch in the series, you shouldn=92t=
 have any patch that doesn=92t build.

Correct, I thought I mentioned in the cover letter that the series is
splitted by files to easier the review. I planned to squash all in one
patch after review is done.

regards,
Stan
