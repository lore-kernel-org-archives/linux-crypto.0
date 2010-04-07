From: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH 3/7] crypto/testmgr: add testing for arc4 based on
 ecb(arc4)
Date: Wed, 07 Apr 2010 02:29:53 -0400
Message-ID: <1270621793.31184.50.camel@mj>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
	 <1270280969-11357-4-git-send-email-sebastian@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:44272 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab0DGG3z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Apr 2010 02:29:55 -0400
In-Reply-To: <1270280969-11357-4-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 2010-04-03 at 09:49 +0200, Sebastian Andrzej Siewior wrote:

> +			if (mode == CRYPT_ARC4)
> +				arc4_setup_iv((struct arc4_iv *)iv,
> +					template[i].key, template[i].klen);
> +			else
> +				ret = crypto_ablkcipher_setkey(tfm, template[i].key,
>  						       template[i].klen);

Can we avoid those special cases?  If the goal is "to make arc4
compliant with the crypto API", this looks like a step in a wrong
direction.

The same applies to many other changes in the series.

I do realize that the original arc4 is not a block cipher at all.

-- 
Regards,
Pavel Roskin
