From: Milan Broz <mbroz@redhat.com>
Subject: Re: [BUGFIX] dm-crypt: Fix a bug of async cryption complete	function
Date: Fri, 27 Feb 2009 12:52:05 +0100
Message-ID: <49A7D3E5.5040706@redhat.com>
References: <1235724971.6204.106.camel@yhuang-dev.sh.intel.com> <20090227114103.GB24024@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40102 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbZB0LwI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2009 06:52:08 -0500
In-Reply-To: <20090227114103.GB24024@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> On Fri, Feb 27, 2009 at 04:56:11PM +0800, Huang Ying wrote:
>> @@ -830,7 +838,7 @@ static void kcryptd_async_done(struct cr
>>  		return;
>>  	}
>>  
>> -	mempool_free(ablkcipher_request_cast(async_req), cc->req_pool);
>> +	mempool_free(dmreq->req, cc->req_pool);
> 
> Why do we need all this complexity? Can't just fix it by using
> cc->req?

No. There can be parallel req allocated, also cc->req can be NULL.
(seems that these structs are overcomplicated already:-)

(And becuse sometimes the bio request is split into 2 pieces because
of hw restrictions, there can be two ablkcipher_requests for one bio...)

I think that patch is the best what we can do now as bugfix.
(I am just running some tests with that.)

Milan
--
mbroz@redhat.com

