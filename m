From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: Mon, 15 Dec 2014 06:32:43 -0500
Message-ID: <20141215113243.GA3803@hmsreliant.think-freely.org>
References: <20141215102149.18731.qmail@ns.horizon.com>
 <3548771.c3zGADVhRW@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Spelvin <linux@horizon.com>, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46004 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaLOLc6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2014 06:32:58 -0500
Content-Disposition: inline
In-Reply-To: <3548771.c3zGADVhRW@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 15, 2014 at 11:46:15AM +0100, Stephan Mueller wrote:
> Am Montag, 15. Dezember 2014, 05:21:49 schrieb George Spelvin:
> 
> Hi George,
> 
> > > Ah, now I see it. Yes, all AES 128 are covered.
> > > 
> > > What about AES 192 and 256?
> > 
> > The implementation doesn't support them, and I didn't add them.
> 
> Sorry, my bad.  :-)
> 
> Then, I think the updated implementation matches with the spec.
With that then, I'm really fine with the changes given that they pass the NIST
tests.

Acked-by: Neil Horman <nhorman@tuxdriver.com>
