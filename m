From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 2/2] crypto: qat - Don't move data inside output buffer
Date: Thu, 13 Aug 2015 23:14:11 -0700
Message-ID: <55CD8733.2000904@intel.com>
References: <20150813035433.25108.3065.stgit@tstruk-mobl1> <20150813035445.25108.76927.stgit@tstruk-mobl1> <20150814051410.GA2370@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: keescook@chromium.org, jwboyer@redhat.com, smueller@chronox.de,
	richard@nod.at, steved@redhat.com, linux-kernel@vger.kernel.org,
	dhowells@redhat.com, linux-crypto@vger.kernel.org,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5601 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbbHNGP2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Aug 2015 02:15:28 -0400
In-Reply-To: <20150814051410.GA2370@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/13/2015 10:14 PM, Herbert Xu wrote:
>> diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
>> > index fe352a6..6ddb13c 100644
>> > --- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
>> > +++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
>> > @@ -144,9 +144,6 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
>> >  		ptr++;
>> >  	}
>> >  
>> > -	if (areq->dst_len != req->ctx->key_sz)
>> > -		memcpy(areq->dst, ptr, areq->dst_len);
>> > -
> This looks wrong.  It appears to be trying to remove leading
> zeroes so you can't just change the length because then you end
> up removing the trailing digits equal to the number of leading
> zeroes.

What it does is it sets the size of the output number, not the size of the output buffer.
The size of the buffer is set beforehand to the size of the modulo, which is the biggest
possible output.

> 
> The existing code is also wrong as you should be using memmove
> instead of memcpy.

Right, but we don't need that anymore.
