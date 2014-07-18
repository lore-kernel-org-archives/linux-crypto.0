From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 00/10] CAAM - DMA API fixes
Date: Fri, 18 Jul 2014 18:04:13 -0500
Message-ID: <20140718180413.2f70940e9cbaa4605188c3c4@freescale.com>
References: <1405082095-30146-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Vakul Garg <vakul@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:41448
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752278AbaGRXYq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Jul 2014 19:24:46 -0400
In-Reply-To: <1405082095-30146-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 11 Jul 2014 15:34:45 +0300
Horia Geanta <horia.geanta@freescale.com> wrote:

Hi Horia,

> Enabling DMA-API debugging reveals quite a lot of problems in CAAM module.
> Patches below fix them - tested on P3041DS QorIQ platform. Please apply.

In an attempt to try and test these patches on a t4240qds, I get:

caam ffe300000.crypto: failed to acquire DECO 0

even on the existing cryptodev master.  Any ideas?

Kim
