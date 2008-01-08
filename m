From: David Miller <davem@davemloft.net>
Subject: Re: [CRYPTO] api: Set default CRYPTO_MINALIGN to unsigned long long
Date: Mon, 07 Jan 2008 22:32:06 -0800 (PST)
Message-ID: <20080107.223206.41816464.davem@davemloft.net>
References: <20080107.221425.140140329.davem@davemloft.net>
	<20080108061548.GE2529@gondor.apana.org.au>
	<20080108061757.GA9321@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58798
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbYAHGcH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Jan 2008 01:32:07 -0500
In-Reply-To: <20080108061757.GA9321@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 8 Jan 2008 17:17:57 +1100

> On Tue, Jan 08, 2008 at 05:15:48PM +1100, Herbert Xu wrote:
> > 
> > Good point.  I'll get rid of that too.
> 
> I've replaced that patch with this:
> 
> [CRYPTO] api: Set default CRYPTO_MINALIGN to unsigned long long

Looks great.
