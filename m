From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUGFIX] dm-crypt: Fix a bug of async cryption complete
	function
Date: Fri, 27 Feb 2009 20:46:02 +0800
Message-ID: <20090227124602.GA24630@gondor.apana.org.au>
References: <1235724971.6204.106.camel@yhuang-dev.sh.intel.com> <20090227114103.GB24024@gondor.apana.org.au> <49A7D3E5.5040706@redhat.com> <20090227115638.GA24221@gondor.apana.org.au> <49A7DC7E.1040307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33983 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752708AbZB0MqK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2009 07:46:10 -0500
Content-Disposition: inline
In-Reply-To: <49A7DC7E.1040307@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 27, 2009 at 01:28:46PM +0100, Milan Broz wrote:
>
> Like this?
> 
> struct ablkcipher_request *req = (char *)dmreq - cc->dmreq_start;
> mempool_free(req, cc->req_pool);

Exactly.  You could also embed the ablkcipher_request at the
end of dmreq, as in

struct dm_crypt_request {
	struct scatterlist sg_in;
	struct scatterlist sg_out;
	struct ablkcipher_request req;
};

Then you can use container_of.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
