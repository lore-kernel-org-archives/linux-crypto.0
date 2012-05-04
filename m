From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v7 0/3] crypto: ux500 crypto and hash driver
Date: Sat, 5 May 2012 01:22:17 +0200
Message-ID: <CACRpkdbwEhwXyjRyx_7_hkG-ZvC7PYpRobBkjfP9V_EdS_uYww@mail.gmail.com>
References: <1335773479-10441-1-git-send-email-andreas.westin@stericsson.com>
	<20120504095651.GA6994@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Westin <andreas.westin@stericsson.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kim.phillips@freescale.com,
	Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53046 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756783Ab2EDXWR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 May 2012 19:22:17 -0400
Received: by ghrr11 with SMTP id r11so3299819ghr.19
        for <linux-crypto@vger.kernel.org>; Fri, 04 May 2012 16:22:17 -0700 (PDT)
In-Reply-To: <20120504095651.GA6994@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 4, 2012 at 11:56 AM, Herbert Xu <herbert@gondor.apana.org.a=
u> wrote:
> On Mon, Apr 30, 2012 at 10:11:16AM +0200, Andreas Westin wrote:
>> Resending, something seems to have gone wrong the first time.
>>
>> Changed config to depend on correct ARCH, also removed an
>> unnecessary if statement check in the hash driver.
>>
>> This adds a driver for the ST-Ericsson ux500 crypto hardware
>> module. It supports AES, DES and 3DES, the driver implements
>> support for AES-ECB,CBC and CTR.
>>
>> Patches are also available at: http://www.df.lth.se/~triad/ux500-cry=
pto/
>
> All applied to cryptodev. =A0Thanks a lot!

The last patch [3/3] will probably have conflicts since we have a patch
deleting U5500 support pending in the ARM SoC tree.

Stephen usually fixes that up, but you could also drop the hunks
touching devices-db5500.h, board-u5500.c and ste-dma40-db5500.h
from that patch.

Apart from that, THANKS Herbert!

Yours,
Linus Walleij
