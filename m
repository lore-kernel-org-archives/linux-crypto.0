From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUGFIX] crypto: Fix ctr(aes) testing by specifying geniv
Date: Thu, 13 Aug 2009 17:39:10 +1000
Message-ID: <20090813073910.GA21784@gondor.apana.org.au>
References: <1249285483-22286-1-git-send-email-ying.huang@intel.com> <20090805094506.GA12528@gondor.apana.org.au> <1249524767.24238.318.camel@yhuang-dev.sh.intel.com> <1250044020.5337.214.camel@yhuang-dev.sh.intel.com> <20090813045300.GA19993@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46090 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752531AbZHMHjM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2009 03:39:12 -0400
Content-Disposition: inline
In-Reply-To: <20090813045300.GA19993@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 13, 2009 at 02:53:00PM +1000, Herbert Xu wrote:
>
> I'll look into it.

Oh I see what's going on.  It's the switch from chainiv to eseqiv
that created the error.  I'll apply your patch.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
