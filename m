From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH v1] crypto: driver for tegra AES hardware
Date: Mon, 14 Nov 2011 13:13:55 -0600
Message-ID: <20111114131355.88f3b5e782c1bd67625ed914@freescale.com>
References: <1320489734-9085-1-git-send-email-vwadekar@nvidia.com>
	<20111105181025.69918e625a169ccb30d9b7c8@freescale.com>
	<4EBE48E8.60205@nvidia.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805AB5@HQMAIL01.nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Varun Wadekar <vwadekar@nvidia.com>,
	"herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
To: Stephen Warren <swarren@nvidia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1.bigfish.com ([213.199.180.138]:3435 "EHLO
	AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751817Ab1KNTQH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Nov 2011 14:16:07 -0500
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740805AB5@HQMAIL01.nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 14 Nov 2011 09:26:16 -0800
Stephen Warren <swarren@nvidia.com> wrote:

> Varun Wadekar wrote at Saturday, November 12, 2011 3:23 AM:
> > >> +	/* assign new context to device */
> > >> +	ctx->dd = dd;
> > >> +	dd->ctx = ctx;
> > >> +
> > >> +	if (ctx->flags & FLAGS_NEW_KEY) {
> > >> +		/* copy the key */
> > >> +		memset(dd->ivkey_base, 0, AES_HW_KEY_TABLE_LENGTH_BYTES);
> > >> +		memcpy(dd->ivkey_base, ctx->key, ctx->keylen);
> > > these really should be writes to mutually exclusive addresses.
> > 
> > Why?
> 
> To avoid redundant work; there's little point memset()ing a region that's
> going to be copied over the top of immediately afterwards.

plus, why is the memset needed at all?

Kim
