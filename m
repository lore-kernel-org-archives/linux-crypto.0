From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 6/6] Add support for AEAD algos.
Date: Tue, 08 Nov 2016 12:15:10 +0100
Message-ID: <3617075.SV0YkRBZ96@positron.chronox.de>
References: <cover.1476263960.git.harsh@chelsio.com> <1610250.DL5oKfbMjq@positron.chronox.de> <3420937b-51f3-cc6e-8919-d698ba087170@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, jlulla@chelsio.com,
        atul.gupta@chelsio.com, yeshaswi@chelsio.com,
        hariprasad@chelsio.com
To: Harsh Jain <Harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47090 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932728AbcKHLPU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2016 06:15:20 -0500
In-Reply-To: <3420937b-51f3-cc6e-8919-d698ba087170@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 27. Oktober 2016, 15:36:08 CET schrieb Harsh Jain:

Hi Harsh,

> >> +static void chcr_verify_tag(struct aead_request *req, u8 *input, int
> >> *err)
> >> +{
> >> +	u8 temp[SHA512_DIGEST_SIZE];
> >> +	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> >> +	int authsize = crypto_aead_authsize(tfm);
> >> +	struct cpl_fw6_pld *fw6_pld;
> >> +	int cmp = 0;
> >> +
> >> +	fw6_pld = (struct cpl_fw6_pld *)input;
> >> +	if ((get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106) ||
> >> +	    (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_GCM)) {
> >> +		cmp = memcmp(&fw6_pld->data[2], (fw6_pld + 1), authsize);
> >> +	} else {
> >> +
> >> +		sg_pcopy_to_buffer(req->src, sg_nents(req->src), temp,
> >> +				authsize, req->assoclen +
> >> +				req->cryptlen - authsize);
> > 
> > I am wondering whether the math is correct here in any case. It is
> > permissible that we have an AAD size of 0 and even a zero-sized
> > ciphertext. How is such scenario covered here?
> 
> Here we are trying to copy user supplied tag to local buffer(temp) for
> decrypt operation only. relative index of tag in src sg list will not
> change when AAD is zero and in decrypt operation cryptlen > authsize.

I am just wondering where this is checked. Since all of these implementations 
are directly accessible from unprivileged user space, we should be careful.

> >> +		cmp = memcmp(temp, (fw6_pld + 1), authsize);
> > 
> > I would guess in both cases memcmp should be replaced with crypto_memneq
> 
> Yes can be done
> 
> >> +	}
> >> +	if (cmp)
> >> +		*err = -EBADMSG;
> >> +	else
> >> +		*err = 0;
> > 
> > What do you think about memzero_explicit(tmp)?
> 
> No Idea why we needs explicitly setting of zero for local variable.  Please
> share some online resources to understand this.

In dumps, the stack is also produced. Yet I see that stack memory is very 
volatile and thus will be overwritten soon. Thus my common approach for 
sensitive data is that heap variables must be zeroized. Stack variables are 
suggested to be zeroized. As far as I understand the code, temp will hold a 
copy of the tag value, i.e. a public piece of information. If this is correct, 
that I concur that a memset may not be needed after all.

Ciao
Stephan
