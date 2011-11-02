From: Luis Henriques <henrix@camandro.org>
Subject: Re: [PATCH v4 12/17] crypto: Add userspace report for aead type algorithms
Date: Wed, 2 Nov 2011 14:25:10 +0000 (UTC)
Message-ID: <loom.20111102T152212-21@post.gmane.org>
References: <20110927052050.GB1808@secunet.com> <20110927054422.GO1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:59665 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536Ab1KBOaR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Nov 2011 10:30:17 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkc-linux-crypto@m.gmane.org>)
	id 1RLbpX-0002lB-KA
	for linux-crypto@vger.kernel.org; Wed, 02 Nov 2011 15:30:15 +0100
Received: from 170.252.70.4 ([170.252.70.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Wed, 02 Nov 2011 15:30:15 +0100
Received: from henrix by 170.252.70.4 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Wed, 02 Nov 2011 15:30:15 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Steffen Klassert <steffen.klassert <at> secunet.com> writes:

...

> +	raead.blocksize = alg->cra_blocksize;
> +	raead.maxauthsize = aead->maxauthsize;
> +	raead.ivsize = aead->ivsize;
> +
> +	NLA_PUT(skb, CRYPTOCFGA_REPORT_AEAD,
> +		sizeof(struct crypto_report_aead), &raead);

This patch seems to break the build if you have a config file without CONFIG_NET.
Other patches in this serie have the same effect -- they add dependencies over
nla_put, which is defined only on CONFIG_NET.

Cheers,
--
Luis Henriques
