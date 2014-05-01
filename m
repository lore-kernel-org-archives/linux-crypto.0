From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto:caam - Modify width of few read only registers
Date: Thu, 1 May 2014 15:45:13 -0500
Message-ID: <20140501154513.70af868ccc62066a2d5a8870@freescale.com>
References: <1398765877-24779-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>
To: Ruchika Gupta <ruchika.gupta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:10151
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751770AbaEAUuY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 May 2014 16:50:24 -0400
In-Reply-To: <1398765877-24779-1-git-send-email-ruchika.gupta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 29 Apr 2014 15:34:37 +0530
Ruchika Gupta <ruchika.gupta@freescale.com> wrote:

> Few read only registers like CHAVID, CTPR etc were wrongly defined
> as 64 bit registers. This functioned properly on the powerpc platforms.
> However ARM SoC's wouldn't function correctly if these registers
> are defined as 64 bit. 

why wouldn't they function correctly?

Kim
