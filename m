From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v2 1/2] crypto: add PKE API
Date: Thu, 28 May 2015 12:08:56 +0800
Message-ID: <20150528040856.GB3849@gondor.apana.org.au>
References: <20150506193643.9329.75351.stgit@tstruk-mobl1>
 <20150506193648.9329.27232.stgit@tstruk-mobl1>
 <20150511063222.GB2316@gondor.apana.org.au>
 <555F777D.1030509@intel.com>
 <20150523054734.GA14239@gondor.apana.org.au>
 <55608C9F.7040500@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57296 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbE1EJP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 00:09:15 -0400
Content-Disposition: inline
In-Reply-To: <55608C9F.7040500@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, May 23, 2015 at 07:20:15AM -0700, Tadeusz Struk wrote:
>
> The length would be redundant. It can be obtained by sg_nents(reg->inparams)
> I don't limit the number of parameters. You can pass as many as you want. For instance to pass 3 in and 2 out you do:
> 
> 	struct scatterlist in[3];
> 	struct scatterlist out[2];
> 
> 	sg_init_table(in, 3);
> 	sg_init_table(out, 2);
> 
> 	sg_set_buf(in, first_in_param, len_of_first_in_param);
> 	sg_set_buf(in + 1, second_in_param, len_of_second_in_param);
> 	sg_set_buf(in + 2, third_in_param, len_of_third_in_param);
> 		
> 	sg_set_buf(out, first_out_param, len_of_first_out_param);
> 	sg_set_buf(out + 1, second_out_param, len_of_second_out_param);
> 
> 	akcipher_request_set_crypt(req, &in, &out);
> 
> The limitation here is that one parameter can not span multiple sgs. This should be ok as they will never be bigger than one page.
> In fact MPI limits it to 2K max with #define MAX_EXTERN_MPI_BITS 16384.
> I'm ok to rename it to src and dst.

Do you have a specific piece of hardware in mind? What are its
capabilities?

If we are going to go with just contiguous memory then we might
as well just do u8 *src, *dst, unsigned int slen, dlen.

The whole point of the SG complexity is to deal with non-contiguous
memory (e.g., fragmented packets with IPsec).  If you can't do that
then why add the SG complexity?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
