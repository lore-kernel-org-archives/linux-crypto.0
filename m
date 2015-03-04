From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/3] crypto: caam: fix some compile warnings
Date: Wed, 4 Mar 2015 12:34:19 -0600
Message-ID: <20150304123419.7baecac7320d5b3483449dab@freescale.com>
References: <1425365453-19358-1-git-send-email-yanjiang.jin@windriver.com>
	<1425365453-19358-2-git-send-email-yanjiang.jin@windriver.com>
	<20150303125953.8585904680288a9734566b42@freescale.com>
	<54F66EA3.7080506@windriver.com>	<54F6909D.8040002@windriver.com>
	<54F6CA60.5030905@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: yjin <yanjiang.jin@windriver.com>, <horia.geanta@freescale.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ruchika.gupta@freescale.com>, <NiteshNarayanLal@freescale.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<jinyanjiang@gmail.com>
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0116.outbound.protection.outlook.com ([207.46.100.116]:21267
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759022AbbCDSjp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Mar 2015 13:39:45 -0500
In-Reply-To: <54F6CA60.5030905@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 4 Mar 2015 11:03:28 +0200
Cristian Stoica <cristian.stoica@freescale.com> wrote:

> On 03/04/2015 06:57 AM, yjin wrote:
> > An alternative is moving the definitions to a ".c" file, but I don't
> > think it will be fundamental different.
> > I know I am fixing a potential error which doesn't exist now, it seems
> > useless for the current upstream version, we can abandon my patch. But I
> > still think the current implementation adds unnecessary restrictions for
> > its users.
> 
> I think that both dma_map_sg_chained and dma_unmap_sg_chained should go
> away. They were added to support chained scatterlists, but as far as I
> verified, dma_map_sg should handle that case as well.
> 
> Kim, can you confirm this?

I don't see how, e.g., for one, dma_map_sg is I/O TLB
implementation-dependent.

Kim
