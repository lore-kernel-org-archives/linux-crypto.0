Return-Path: <SRS0=xktg=33=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7339EC352A2
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 07:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C413220838
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 07:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="EafjajYv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgBGH4S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Feb 2020 02:56:18 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:15365 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgBGH4S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Feb 2020 02:56:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581062174;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=1fEM9CnSaXlHJobgsEaq++nNUof1KVyyOdPhR5nQZas=;
        b=EafjajYvVUd5MRfM9hmJqaLXPHbTqsgiB7dh6HxJ5dK0MpDFMAcQvAolZEKvp8PNGm
        3Wif/+PFM5Uas0RgoRtBtnq2LLjRkCNAKh49Nhh7bjzUp0xLvjqlPCCLIRrCpoc/RQhO
        EXoBNzl/ZQJUJzrRZkxikckjF4SxGxlIDHPscG9pWjaLFACANHSXFECai+J5yVht3vjL
        fwUWRUwri4W5lI7JelWxb2fh87OX3YddCgWft3fOzXFB8fC3dA679CY87xPLVhoysiA9
        YSfC3FBzvYPLhREVU+iCmTBWtHZpZrGUjWrE8bek8pNK5yff+roarHSFCzJzLFyICZO8
        OWLw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIfScugJ3"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id 608a92w177u6cd2
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 7 Feb 2020 08:56:06 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Subject: Re: Possible issue with new inauthentic AEAD in extended crypto tests
Date:   Fri, 07 Feb 2020 08:56:05 +0100
Message-ID: <28236835.Fk5ARk2Leh@tauon.chronox.de>
In-Reply-To: <20200207072709.GB8284@sol.localdomain>
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com> <CAOtvUMeVXTDvH5bxVFemYmD9rpZ=xX3MkypAGyZn5VROw6sgZg@mail.gmail.com> <20200207072709.GB8284@sol.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 7. Februar 2020, 08:27:09 CET schrieb Eric Biggers:

Hi Eric,

> On Wed, Feb 05, 2020 at 04:48:16PM +0200, Gilad Ben-Yossef wrote:
> > Probably another issue with my driver, but just in case -
> > 
> > include/crypot/aead.h says:
> >  * The scatter list pointing to the input data must contain:
> >  *
> >  * * for RFC4106 ciphers, the concatenation of
> >  *   associated authentication data || IV || plaintext or ciphertext.
> >  Note, the *   same IV (buffer) is also set with the
> >  aead_request_set_crypt call. Note, *   the API call of
> >  aead_request_set_ad must provide the length of the AAD and *   the IV.
> >  The API call of aead_request_set_crypt only points to the size of *  
> >  the input plaintext or ciphertext.
> > 
> > I seem to be missing the place where this is handled in
> > generate_random_aead_testvec()
> > and generate_aead_message()
> > 
> > We seem to be generating a random IV for providing as the parameter to
> > aead_request_set_crypt()
> > but than have other random bytes set in aead_request_set_ad() - or am
> > I'm missing something again?
> 
> Yes, for rfc4106 the tests don't pass the same IV in both places.  This is
> because I wrote the tests from the perspective of a generic AEAD that
> doesn't have this weird IV quirk, and then I added the minimum quirks to
> get the weird algorithms like rfc4106 passing.
> 
> Since the actual behavior of the generic implementation of rfc4106 is that
> the last 8 bytes of the AAD are ignored, that means that currently the
> tests just avoid mutating these bytes when generating inauthentic input
> tests.  They don't know that they're (apparently) meant to be another copy
> of the IV.
> 
> So it seems we need to clearly define the behavior when the two IV copies
> don't match.  Should one or the other be used, should an error be returned,
> or should the behavior be unspecified (in which case the tests would need
> to be updated)?
> 
> Unspecified behavior is bad, but it would be easiest for software to use
> req->iv, while hardware might want to use the IV in the scatterlist...
> 
> Herbert and Stephan, any idea what was intended here?
> 
> - Eric

The full structure of RFC4106 is the following:

- the key to be set is always 4 bytes larger than required for the respective 
AES operation (i.e. the key is 20, 28 or 36 bytes respectively). The key value 
contains the following information: key || first 4 bytes of the IV (note, the 
first 4 bytes of the IV are the bytes derived from the KDF invoked by IKE - 
i.e. they come from user space and are fixed)

- data block contains AAD || trailing 8 bytes of IV || plaintext or ciphertext 
- the trailing 8 bytes of the IV are the SPI which is updated for each new  
IPSec package

aead_request_set_ad points to the AAD plus the 8 bytes of IV in the use case 
of rfc4106(gcm(aes)) as part of IPSec.

Considering your question about the aead_request_set_ad vs 
aead_request_set_crypt I think the RFC4106 gives the answer: the IV is used in 
two locations considering that the IV is also the SPI in our case. If you see 
RFC 4106 chapter 3 you see the trailing 8 bytes of the IV as, well, the GCM IV 
(which is extended by the 4 byte salt as defined in chapter 4 that we provide 
with the trailing 4 bytes of the key). The kernel uses the SPI for this. In 
chapter 5 RFC4106 you see that the SP is however used as part of the AAD as 
well.

Bottom line: if you do not set the same IV value for both, the AAD and the GCM 
IV, you deviate from the use case of rfc4106(gcm(aes)) in IPSec. Yet, from a 
pure mathematical point of view and also from a cipher implementation point of 
view, it does not matter whether the AAD and the IV point to the same value - 
the implementation must always process that data. The result however will not 
be identical to the IPSec use case.

Some code to illustrate it - this code is from my CAVS test harness used to 
perform the crypto testing for FIPS 140-2:


Preparation of the key:

        /*
         * RFC4106 special handling: append the first 4 bytes of the IV to
         * the key. If IV is NULL, append NULL string (i.e. the fixed field is
         * zero in case of internal IV generation). The first 4 bytes of
         * the IV must be removed from the IV string.
         */
        if (strcasestr(ciphername, "rfc4106")) {
                struct buffer rfc;

                memset(&rfc, 0, sizeof(struct buffer));
                if (alloc_buf(data->key.len + 4, &rfc))
                        goto out;

                /* copy the key into buffer */
                memcpy(rfc.buf, data->key.buf, data->key.len);
                if (data->iv.len >= 4) {
                        uint32_t i = 0;

                        /* Copy first four bytes of the IV into key */
                        memcpy(rfc.buf + data->key.len, data->iv.buf, 4);

                        /* move remaining bytes to the front to be used as IV 
*/
                        for (i = 0; i < (data->iv.len - 4); i++)
                                data->iv.buf[i] = data->iv.buf[(i + 4)];
                        data->iv.len -= 4;
                }


Preparation of the SGL - the IV here is the trailing 8 bytes after the 
operation above:

        if (aead_assoc->len) {
                if (rfc4106) {
                        sg_init_table(sg, 3);
                        sg_set_buf(&sg[0], aead_assoc->data, aead_assoc->len);
                        sg_set_buf(&sg[1], iv->data, iv->len);
                        sg_set_buf(&sg[2], data->data, data->len +
                                (kccavs_test->type & TYPE_ENC ? authsize : 
0));
                } else {
                        sg_init_table(sg, 2);
                        sg_set_buf(&sg[0], aead_assoc->data, aead_assoc->len);
                        sg_set_buf(&sg[1], data->data, data->len +
                                (kccavs_test->type & TYPE_ENC ? authsize : 
0));
                }
        } else {
                if (rfc4106) {
                        sg_init_table(sg, 2);
                        sg_set_buf(&sg[0], iv->data, iv->len);
                        sg_set_buf(&sg[1], data->data, data->len +
                                (kccavs_test->type & TYPE_ENC ? authsize : 
0));
                } else {
                        sg_init_table(sg, 1);
                        sg_set_buf(&sg[0], data->data, data->len +
                                (kccavs_test->type & TYPE_ENC ? authsize : 
0));
                }
        }


Informing the kernel crypto API about the AAD size:

        if (rfc4106)
                aead_request_set_ad(req, aead_assoc->len + iv->len);
        else
                aead_request_set_ad(req, aead_assoc->len);


Set the buffers:

	aead_request_set_crypt(req, sg, sg, data->len, iv->data);

Ciao
Stephan


