From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: Add a flag allowing the self-tests to be
 disabled at runtime.
Date: Tue, 3 May 2016 15:32:30 +0800
Message-ID: <20160503073230.GA16768@gondor.apana.org.au>
References: <1461927784-19114-1-git-send-email-rjones@redhat.com>
 <1461927784-19114-2-git-send-email-rjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, corbet@lwn.net, davem@davemloft.net,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37088 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbcECHck (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 03:32:40 -0400
Content-Disposition: inline
In-Reply-To: <1461927784-19114-2-git-send-email-rjones@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 29, 2016 at 12:03:04PM +0100, Richard W.M. Jones wrote:
> Running self-tests for a short-lived KVM VM takes 28ms on my laptop.
> This commit adds a flag 'cryptomgr.notests' which allows them to be
> disabled.
> 
> Signed-off-by: Richard W.M. Jones <rjones@redhat.com>

Please address the conflict with FIPS mode.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
