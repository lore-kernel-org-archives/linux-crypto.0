From: Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH] crypto: picoxcell: Add terminating entry for
 platform_device_id table
Date: Sun, 4 Nov 2012 15:51:05 +0000
Message-ID: <20121104155105.GA29336@page>
References: <1352043385.11324.4.camel@phoenix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Jamie Iles <jamie@jamieiles.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Axel Lin <axel.lin@ingics.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35707 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2KDPvK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 Nov 2012 10:51:10 -0500
Received: by mail-wi0-f172.google.com with SMTP id hq12so2478962wib.1
        for <linux-crypto@vger.kernel.org>; Sun, 04 Nov 2012 07:51:08 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1352043385.11324.4.camel@phoenix>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Axel,

On Sun, Nov 04, 2012 at 11:36:25PM +0800, Axel Lin wrote:
> The platform_device_id table is supposed to be zero-terminated.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Good spot!  Thanks for fixing.

Acked-by: Jamie Iles <jamie@jamieiles.com>

Jamie
