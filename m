From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 0/9] crypto: caam - Add RTA descriptor creation library
Date: Fri, 18 Jul 2014 17:13:39 -0500
Message-ID: <20140718171339.fe181f6425daa57bc179ef81@freescale.com>
References: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Carmen Iorga <carmen.iorga@freescale.com>,
	Alexandru Porosanu <alexandru.porosanu@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	"Ruchika Gupta" <ruchika.gupta@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:35617
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756227AbaGRWSw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Jul 2014 18:18:52 -0400
In-Reply-To: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 18 Jul 2014 19:37:17 +0300
Horia Geanta <horia.geanta@freescale.com> wrote:

> This patch set adds Run Time Assembler (RTA) SEC descriptor library.
> 
> The main reason of replacing incumbent "inline append" is
> to have a single code base both for user space and kernel space.

that's orthogonal to what this patchseries is doing from the kernel
maintainer's perspective:  it's polluting the driver with a
CodingStyle-violating (see, e.g., Chapter 12) 6000+ lines of code -
which can only mean it's slower and more susceptible to bugs - and
AFAICT for no superior technical advantage:  NACK from me.

Kim
