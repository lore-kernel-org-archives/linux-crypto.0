From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: aead: driver side documentation
Date: Mon, 4 Apr 2011 20:35:43 -0500
Message-ID: <20110404203543.4f80b41b.kim.phillips@freescale.com>
References: <20110404170337.GA1511@orbit.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.182]:31521
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373Ab1DEBfw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Apr 2011 21:35:52 -0400
In-Reply-To: <20110404170337.GA1511@orbit.nwl.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 4 Apr 2011 19:03:37 +0200
Phil Sutter <phil@nwl.cc> wrote:

> I would like to enhance drivers/crypto/mv_cesa.c by an AEAD algorithm
> (at least authenc(hmac(sha1),cbc(aes))), since the driver is able to do
> both operations in one go.
> 
> Unfortunately, I have found little information about this task in
> Documentation/ or the web. Am I missing something? It would be really
> great if you could point me to the right direction here.

use existing drivers for guidance.  The following drivers implement
those types of algorithms:

drivers/crypto/caam/caamalg.c*
drivers/crypto/ixp4xx_crypto.c
drivers/crypto/picoxcell_crypto.c
drivers/crypto/talitos.c

Kim

* only available in Herbert's cryptodev-2.6 tree
