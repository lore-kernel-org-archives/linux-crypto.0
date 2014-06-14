From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] crypto/nx: disable NX on little endian builds
Date: Sat, 14 Jun 2014 05:48:14 +0200
Message-ID: <201406140548.14201.marex@denx.de>
References: <20140607113334.474343b8@kryten>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: benh@kernel.crashing.org, paulus@samba.org,
	nfont@linux.vnet.ibm.com, mhcerri@linux.vnet.ibm.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:51291 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbaFNDsW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Jun 2014 23:48:22 -0400
In-Reply-To: <20140607113334.474343b8@kryten>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Saturday, June 07, 2014 at 03:33:34 AM, Anton Blanchard wrote:
> The NX driver has endian issues so disable it for now.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

What kind of issues ? Are they hard to fix ?

Best regards,
Marek Vasut
