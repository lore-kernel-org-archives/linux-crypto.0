From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Typos and RSA
Date: Wed, 18 May 2016 00:56:29 +0200
Message-ID: <6203568.4quGhfsc99@positron.chronox.de>
References: <573B8BA3.8020902@amd.com> <ae33e745-feca-c588-015d-bf2b4ca461f0@intel.com> <573B9F54.7050006@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39552 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbcEQW4a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 May 2016 18:56:30 -0400
In-Reply-To: <573B9F54.7050006@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 17. Mai 2016, 17:46:44 schrieb Gary R Hook:

Hi Gary,

> Thanks so much.
> 
> There are exactly 3 references to that symbol (in my freshly pulled copy
> of cryptodev-2.6).
> testmgr.c precipitates my questions, and public_key.c doesn't actually
> provide any content
> in the source input buffer, neither modulus nor plaintext. Thus, it
> doesn't clarify things
> either.
> 
> But I truly appreciate your attention.
> 
> So I'll go ahead and ask, because I did look at the two areas mentioned
> by Stephan, but
> neither seem to clarify (to my admittedly ignorant eyes... I'm a real
> newbie on crypto here)
> usage.

Here is an example from a current code of mine (all kccavs symbols are private 
to my code):

        tfm = crypto_alloc_akcipher(kccavs_test->name, 0, 0);
        if (IS_ERR(tfm)) {
                pr_info("could not allocate akcipher handle for %s %ld\n",
                        kccavs_test->name, PTR_ERR(tfm));
                return PTR_ERR(tfm);
        }

        req = akcipher_request_alloc(tfm, GFP_KERNEL);
        if (!req)
                goto err;

        if (crypto_akcipher_maxsize(tfm) > MAXDATALEN) {
                err = -ENOMEM;
                pr_info("output datasize is too big\n");
                goto err;
        }

        err = crypto_akcipher_set_pub_key(tfm, key->data, key->len);
        if (err)
                goto err;

        err = kccavs_akcipher_hashdata();
        if (err)
                goto err;

        rsa.tfm = tfm;
        rsa.req = req;
        init_completion(&rsa.result.completion);

        sg_init_one(&src, rsa_sig->data, rsa_sig->len);
        akcipher_request_set_crypt(req, &src, &src, rsa_sig->len,
                                   crypto_akcipher_maxsize(tfm));

        err = crypto_akcipher_verify(req);
        kccavs_akcipher_wait(&rsa, err);

        dbg("RSA signature verification result %d\n", err);

        rsa_sig->len = min_t(u64, rsa_sig->len, data->len);

        if (!err) {
                /* sig ver passed */
                if (data->len == rsa_sig->len &&
                    !memcmp(rsa_sig->data, data->data, rsa_sig->len)) {
                        dbg("sig ver op passed, good data");
                        memcpy(kccavs_test->data.data, "\xbe\xef\xbe\xef", 4);
                } else {
                        dbg("sig ver op passed, wrong data");
                        memcpy(kccavs_test->data.data, "\xde\xad\xbe\xef", 4);
                }
        } else {
                /*
                 * Signature verify failed
                 * Note, the CAVS vectors may sometimes even provide wrong
                 * input data that do not comply with some requirements. In
                 * this case, the kernel returns errors other than EBADMSG.
                 */
                memcpy(kccavs_test->data.data, "\xde\xad\xbe\xef", 4);
        }


> 
> Here's my question:
> 
> The source input (as set via akcipher_request_set_crypt()) to akcipher
> is supposed to be
> the modulus + plaintext. testmgr hands this in via a scatterlist with 2
> elements, wherein
> the first is the modulus, the second the payload. The source length
> however, appears to
> be the aggregate length of these two elements. Okay, good enough.
> 
> Since the API provides no information about the modulus length, one

crypto_akcipher_maxsize(tfm)?

> might guess that the
> only way to ascertain the separate lengths of the two parts is to read
> the values from
> the scatterlist structures. I get that the key (exponent) length is what
> really matters,
> but the source input fields are clearly of arbitrary and unequal length.

Depending on what type of RSA operation you use (raw or pkcs1) or the 
operation type (siggen/ver), the input is not just the modulus.

So, to help you, you need to give a bit more information about what type of 
RSA operation you want to perform.
> 
> So please forgive my ignorance, but I'm not seeing it: how do we
> decompose the two parts
> of src and get their lengths? What can we expect on the receiving end of
> the encrypt
> function with respect to the source data structure? A two-element
> scatterlist? Or...?
> What can we conclude from the calls made in do_test_rsa() in testmgr.c,
> vs the call in
> public_key_verify_signature() in public_key.c re: invocation and
> provided data.
> 
> Any clarification is greatly appreciated.


> 
> Gary
> 
> On 05/17/2016 05:18 PM, Tadeusz Struk wrote:
> > On 05/17/2016 03:16 PM, Stephan Mueller wrote:
> >>> I am working on hooking up RSA functionality to the akcipher API. It
> >>> appears>>> 
> >>>> that no other code, to date, uses this API. Can anyone confirm or deny
> >>>> that
> >>>> conclusion?
> >> 
> >> This is not correct. The asymmetric key API uses that code. So does the
> >> module signing code.
> > 
> > Also you can have a look at testmgr.c for examples.
> > "git grep crypto_alloc_akcipher" is also useful.
> > 
> > Thanks,


Ciao
Stephan
