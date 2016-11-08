From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 6/6] Add support for AEAD algos.
Date: Tue, 08 Nov 2016 13:59:38 +0100
Message-ID: <46208469.tzXHy1sfql@positron.chronox.de>
References: <cover.1476263960.git.harsh@chelsio.com> <3617075.SV0YkRBZ96@positron.chronox.de> <ab295a27-cb83-0ee7-0cf1-03d7c05b20c5@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, jlulla@chelsio.com,
        atul.gupta@chelsio.com, yeshaswi@chelsio.com,
        hariprasad@chelsio.com
To: Harsh Jain <Harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47100 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933325AbcKHM7q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2016 07:59:46 -0500
In-Reply-To: <ab295a27-cb83-0ee7-0cf1-03d7c05b20c5@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 8. November 2016, 17:16:38 CET schrieb Harsh Jain:

Hi Harsh,

> On 08-11-2016 16:45, Stephan Mueller wrote:
> > Am Donnerstag, 27. Oktober 2016, 15:36:08 CET schrieb Harsh Jain:
> > 
> > Hi Harsh,
> > 
> >>>> +static void chcr_verify_tag(struct aead_request *req, u8 *input, int
> >>>> *err)
> >>>> +{
> >>>> +	u8 temp[SHA512_DIGEST_SIZE];
> >>>> +	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> >>>> +	int authsize = crypto_aead_authsize(tfm);
> >>>> +	struct cpl_fw6_pld *fw6_pld;
> >>>> +	int cmp = 0;
> >>>> +
> >>>> +	fw6_pld = (struct cpl_fw6_pld *)input;
> >>>> +	if ((get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106) ||
> >>>> +	    (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_GCM)) {
> >>>> +		cmp = memcmp(&fw6_pld->data[2], (fw6_pld + 1), authsize);
> >>>> +	} else {
> >>>> +
> >>>> +		sg_pcopy_to_buffer(req->src, sg_nents(req->src), temp,
> >>>> +				authsize, req->assoclen +
> >>>> +				req->cryptlen - authsize);
> >>> 
> >>> I am wondering whether the math is correct here in any case. It is
> >>> permissible that we have an AAD size of 0 and even a zero-sized
> >>> ciphertext. How is such scenario covered here?
> >> 
> >> Here we are trying to copy user supplied tag to local buffer(temp) for
> >> decrypt operation only. relative index of tag in src sg list will not
> >> change when AAD is zero and in decrypt operation cryptlen > authsize.
> > 
> > I am just wondering where this is checked. Since all of these
> > implementations are directly accessible from unprivileged user space, we
> > should be careful.
> chcr_verify_tag() will be called when req->verify is set to "VERIFY_SW", 
> same will set in decrypt callback function of Algo(like chcr_aead_decrypt)
> only. It will ensure calling of chcr_verify_tag() in de-crypt operation
> only.

I think that limiting to the decryption path may not be enough. What happens 
if a caller sets some assoclen, but when invoking the decryption operation it 
provides input data that is smaller than the assoclen? The API allows this 
scenario.

Ciao
Stephan
