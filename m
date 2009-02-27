From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUGFIX] dm-crypt: Fix a bug of async cryption complete function
Date: Fri, 27 Feb 2009 22:19:39 +0800
Message-ID: <20090227141939.GA25275@gondor.apana.org.au>
References: <1235724971.6204.106.camel@yhuang-dev.sh.intel.com> <20090227114103.GB24024@gondor.apana.org.au> <49A7D3E5.5040706@redhat.com> <20090227115638.GA24221@gondor.apana.org.au> <49A7DC7E.1040307@redhat.com> <20090227124602.GA24630@gondor.apana.org.au> <49A7EFD3.9080107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alasdair G Kergon <agk@redhat.com>,
	Huang Ying <ying.huang@intel.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58282 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755346AbZB0OTr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2009 09:19:47 -0500
Content-Disposition: inline
In-Reply-To: <49A7EFD3.9080107@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 27, 2009 at 02:51:15PM +0100, Milan Broz wrote:
>
> Is the attached and reworked patch ok?

Looks good to me.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
