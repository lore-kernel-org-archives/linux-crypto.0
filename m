From: Dave Watson <davejwatson@fb.com>
Subject: Re: [PATCH 14/14] x86/crypto: aesni: Update aesni-intel_glue to use
 scatter/gather
Date: Tue, 13 Feb 2018 10:22:03 -0800
Message-ID: <20180213182203.GA2122@davejwatson-mba.local>
References: <cover.1518211765.git.davejwatson@fb.com>
 <20180212195128.GA61087@davejwatson-mba.local>
 <dc69bdfa-6dc2-da54-9d9a-b171aeb3212b@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Ilya Lesokhin <ilyal@mellanox.com>
To: Junaid Shahid <junaids@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40356 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965158AbeBMSXE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Feb 2018 13:23:04 -0500
Content-Disposition: inline
In-Reply-To: <dc69bdfa-6dc2-da54-9d9a-b171aeb3212b@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/12/18 03:12 PM, Junaid Shahid wrote:
> Hi Dave,
> 
> 
> On 02/12/2018 11:51 AM, Dave Watson wrote:
> 
> > +static int gcmaes_encrypt_sg(struct aead_request *req, unsigned int assoclen,
> > +			u8 *hash_subkey, u8 *iv, void *aes_ctx)
> >  
> > +static int gcmaes_decrypt_sg(struct aead_request *req, unsigned int assoclen,
> > +			u8 *hash_subkey, u8 *iv, void *aes_ctx)
> 
> These two functions are almost identical. Wouldn't it be better to combine them into a single encrypt/decrypt function, similar to what you have done for the assembly macros?
> 
> > +	if (((struct crypto_aes_ctx *)aes_ctx)->key_length != AES_KEYSIZE_128 ||
> > +		aesni_gcm_enc_tfm == aesni_gcm_enc) {
> 
> Shouldn't we also include a check for the buffer length being less than AVX_GEN2_OPTSIZE? AVX will not be used in that case either.

Yes, these both sound reasonable.  I will send a V2.

Thanks!
