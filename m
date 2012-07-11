From: Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [PATCH 1/4] Talitos: move the data structure into header file
Date: Wed, 11 Jul 2012 03:13:17 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70C02CC@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1341899809-20630-1-git-send-email-qiang.liu@freescale.com>
	<1341899809-20630-2-git-send-email-qiang.liu@freescale.com>
 <20120710191107.28347d94783d8c001c67ce57@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	Li Yang-R58472 <r58472@freescale.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
To: Phillips Kim-R1AAHA <R1AAHA@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:52846
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208Ab2GKDNV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jul 2012 23:13:21 -0400
In-Reply-To: <20120710191107.28347d94783d8c001c67ce57@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> -----Original Message-----
> From: Phillips Kim-R1AAHA
> Sent: Wednesday, July 11, 2012 8:11 AM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; Li Yang-
> R58472; Herbert Xu; David S. Miller; Geanta Neag Horia Ioan-B05471
> Subject: Re: [PATCH 1/4] Talitos: move the data structure into header
> file
> 
> On Tue, 10 Jul 2012 13:56:46 +0800
> Qiang Liu <qiang.liu@freescale.com> wrote:
> 
> > Move the declaration of talitos data structure into talitos.h.
> >
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> > ---
> 
> this patch has already been submitted [1].
> 
> Subsequent patches in this series also don't apply cleanly:  can
> you rebase onto [2], which is based on Herbert's cryptodev tree and
> contain's Horia's four patches, and re-send?
Kim, Thanks for your note, I will rebase the cryptodev tree and resend
the patch again.

> 
> Also note that upstream talitos does not yet contain NAPI support
> [3].
Thanks.
> 
> Thanks,
> 
> Kim
> 
> [1] http://www.mail-archive.com/linux-
> crypto@vger.kernel.org/msg07299.html
> [2] git://git.freescale.com/crypto/cryptodev.git
> [3] http://www.mail-archive.com/linux-
> crypto@vger.kernel.org/msg07289.html
