From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto:caam - Improved support of CAAM era retrieval.
Date: Wed, 19 Sep 2012 16:21:45 -0500
Message-ID: <20120919162145.a15eb11c1a0ef25f5717e8c9@freescale.com>
References: <1348044311-23506-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:40571 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787Ab2ISVYA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Sep 2012 17:24:00 -0400
Received: from mail233-tx2 (localhost [127.0.0.1])	by
 mail233-tx2-R.bigfish.com (Postfix) with ESMTP id 2447DD00188	for
 <linux-crypto@vger.kernel.org>; Wed, 19 Sep 2012 21:23:59 +0000 (UTC)
Received: from TX2EHSMHS023.bigfish.com (unknown [10.9.14.253])	by
 mail233-tx2.bigfish.com (Postfix) with ESMTP id D61B16800AC	for
 <linux-crypto@vger.kernel.org>; Wed, 19 Sep 2012 21:23:56 +0000 (UTC)
In-Reply-To: <1348044311-23506-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

missing patch version

On Wed, 19 Sep 2012 14:15:11 +0530
Vakul Garg <vakul@freescale.com> wrote:

> CAAM era retrieval api caam_get_era() currently supports devices upto ERA-4.
> The CAAM era is looked up from a table mapping SECVID register to an ERA number.
> Post ERA-6, era can be directly read from register CCBVID. This patch enhances
> api caam_get_era() to support additional pre ERA-6 devices in the mapping table.
> For ERA-6 and later devices, it returns ERA directly by reading CCBVID.

wrap this text to ~75 cols please

> +	if (ccb_vid->era)
> +		return ccb_vid->era;
> +	else

unnecessary else

Kim
