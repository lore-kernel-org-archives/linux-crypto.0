From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto:caam - Define setbits32() and clrbits32() for
 ARM in the Freescale CAAM driver
Date: Thu, 1 May 2014 15:46:50 -0500
Message-ID: <20140501154650.48fde3cbe2036a062de08fb3@freescale.com>
References: <1398766299-30412-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	"Victoria Milhoan" <vicki.milhoan@freescale.com>
To: Ruchika Gupta <ruchika.gupta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:15344
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751481AbaEAUvz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 May 2014 16:51:55 -0400
In-Reply-To: <1398766299-30412-1-git-send-email-ruchika.gupta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 29 Apr 2014 15:41:39 +0530
Ruchika Gupta <ruchika.gupta@freescale.com> wrote:

> The kernel defines setbits32() and clrbits32() macros only for
> Power-based architectures.  This patch modifies the Freescale CAAM
> driver to add macros for use on ARM architectures.
> 
> Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
> Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
> ---

Add these macros to arch/arm's io.h instead of duplicating their
definitions in drivers such as caam.

Thanks,

Kim
