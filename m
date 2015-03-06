From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/3] crypto: caam_rng: fix rng_unmap_ctx's DMA_UNMAP
 size problem
Date: Thu, 5 Mar 2015 18:28:14 -0600
Message-ID: <20150305182814.4a34d15df2638da5f20d1d29@freescale.com>
References: <1425365453-19358-1-git-send-email-yanjiang.jin@windriver.com>
	<1425365453-19358-3-git-send-email-yanjiang.jin@windriver.com>
	<20150303133120.6706da49d0f7188a8213fe36@freescale.com>
	<54F69922.6080404@windriver.com>
	<20150304123623.324ab9594f04dd95c587b628@freescale.com>
	<54F7C4F5.1040204@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <horia.geanta@freescale.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <ruchika.gupta@freescale.com>,
	<cristian.stoica@freescale.com>, <NiteshNarayanLal@freescale.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<jinyanjiang@gmail.com>
To: yjin <yanjiang.jin@windriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0101.outbound.protection.outlook.com ([207.46.100.101]:44896
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750868AbbCFAde (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Mar 2015 19:33:34 -0500
In-Reply-To: <54F7C4F5.1040204@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 5 Mar 2015 10:52:37 +0800
yjin <yanjiang.jin@windriver.com> wrote:

> On 2015=E5=B9=B403=E6=9C=8805=E6=97=A5 02:36, Kim Phillips wrote:
> > On Wed, 4 Mar 2015 13:33:22 +0800
> > yjin <yanjiang.jin@windriver.com> wrote:
> >
> >> On 2015=E5=B9=B403=E6=9C=8804=E6=97=A5 03:31, Kim Phillips wrote:
> >>> On Tue, 3 Mar 2015 14:50:52 +0800
> >>> <yanjiang.jin@windriver.com> wrote:
> >>>
> >>>> -		dma_unmap_single(jrdev, ctx->sh_desc_dma, DESC_RNG_LEN,
> >>>> -				 DMA_TO_DEVICE);
> >>>> +		dma_unmap_single(jrdev, ctx->sh_desc_dma,
> >>>> +				desc_bytes(ctx->sh_desc), DMA_TO_DEVICE);
> >>> alignment: the 'd' in desc_bytes should fall directly under the '=
j'
> >>> in jrdev.
> >>>
> >>> Also, DESC_RNG_LEN should be corrected to (4 * CAAM_CMD_SZ).
> >>
> >> I can't find the obvious limitation for the RNG descriptor length =
in
> >> Freescale documents, could you point out it?
> > ?  rng_create_sh_desc() creates a fixed descriptor of exactly 4
> > command-lengths.
>=20
> Do you mean that the code itself limits the descriptor length? Not a=20
> hardware limitation.

the code writes descriptors such that they don't reach h/w
limitations.

> If so, I prefer to dma_unmap with desc_bytes(ctx->sh_desc) as my=20
> previous patch, and correct DESC_RNG_LEN to (4 * CAAM_CMD_SZ).

please.

Kim
