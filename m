From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] geode: add fallback for unsupported modes, take 2
Date: Sat, 10 Nov 2007 19:31:30 +0800
Message-ID: <20071110113130.GC5485@gondor.apana.org.au>
References: <1192788233-14968-1-git-send-email-linux-crypto@ml.breakpoint.cc> <1192788233-14968-5-git-send-email-linux-crypto@ml.breakpoint.cc> <20071021083158.GD9397@gondor.apana.org.au> <20071104205923.GB25799@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org, Jordan Crouse <jordan.crouse@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1819 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751480AbXKJLbf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Nov 2007 06:31:35 -0500
Content-Disposition: inline
In-Reply-To: <20071104205923.GB25799@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Nov 04, 2007 at 09:59:23PM +0100, Sebastian Siewior wrote:
> The Geode AES crypto engine supports only 128 bit long key. This
> patch adds fallback for other key sizes which are required by the
> AES standard.
> 
> Cc: Jordan Crouse <jordan.crouse@amd.com>
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Patch applied.  Thanks for fixing this.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
