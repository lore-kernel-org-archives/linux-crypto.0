From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH][v2] crypto: caam - Correct definition of registers in
 memory map
Date: Thu, 12 Jun 2014 18:14:38 -0500
Message-ID: <20140612181438.4c02cf6f36148e9adaa0c292@freescale.com>
References: <1402597326-30920-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>
To: Ruchika Gupta <ruchika.gupta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:26456
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750961AbaFLXTn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Jun 2014 19:19:43 -0400
In-Reply-To: <1402597326-30920-1-git-send-email-ruchika.gupta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 12 Jun 2014 23:52:06 +0530
Ruchika Gupta <ruchika.gupta@freescale.com> wrote:

> Some registers like SECVID, CHAVID, CHA Revision Number,
> CTPR were defined as 64 bit resgisters.  The IP provides
> a DWT bit(Double word Transpose) to transpose the two words when
> a double word register is accessed. However setting this bit
> would also affect the operation of job descriptors as well as
> other registers which are truly double word in nature.
> So, for the IP to work correctly on big-endian as well as
> little-endian SoC's, change is required to access all 32 bit
> registers as 32 bit quantities.
> 
> Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
> ---
> Changed in v2:
> 1. Review comments incorporated

only 2 out of 3...see previous version's thread.

Also, please start using scripts/get_maintainer.pl.

Thanks,

Kim
