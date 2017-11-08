From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v2 1/3] staging: ccree: copy IV to DMAable memory
Date: Wed, 8 Nov 2017 10:26:33 +0000
Message-ID: <VI1PR0402MB3342B8E2BF19C2C5E298981F98560@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <1509610224-14708-1-git-send-email-gilad@benyossef.com>
 <1509610224-14708-2-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "driverdev-devel@linuxdriverproject.org"
 <driverdev-devel@linuxdriverproject.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

On 11/2/2017 10:14 AM, Gilad Ben-Yossef wrote:
> We are being passed an IV buffer from unknown origin, which may be
> stack allocated and thus not safe for DMA. Allocate a DMA safe
> buffer for the IV and use that instead.
> 
IIUC this fixes only the (a)blkcipher / skcipher algorithms.
What about aead, authenc?

The fact that only the skcipher tcrypt tests use IVs on stack doesn't
mean aead, authenc implementations are safe - other crypto API users
could provide IVs laying in non-DMAable memory.

To reiterate, the proper approach is to fix the crypto API to guarantee
IVs are DMAable.
However Herbert suggests he is not willing to do this work:
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg28821.html

A few high-level details mentioning what this implies would be helpful,
in case somebody else decides its worth pursuing this path.

The compromise is to fix all crypto drivers that need DMAable IVs.
IMHO this is suboptimal, both in terms of performance (memory
allocation, memcpy) and increased code complexity.

Horia
