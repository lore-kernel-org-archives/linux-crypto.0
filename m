From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH V2 2/3] crypto: ccp - Enable support for AES GCM on v5 CCPs
Date: Tue, 14 Mar 2017 16:09:16 +0100
Message-ID: <2406678.UfN5idp8hP@tauon.atsec.com>
References: <20170310180341.21062.82465.stgit@taos> <4585707.bK1Ho6b7OP@tauon.atsec.com> <58e1a934-4007-1ac3-8588-8267436c62b6@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58060 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752485AbdCNPJT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Mar 2017 11:09:19 -0400
In-Reply-To: <58e1a934-4007-1ac3-8588-8267436c62b6@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 14. März 2017, 15:34:00 CET schrieb Gary R Hook:

Hi Gary,

> On 03/14/2017 02:17 AM, Stephan Müller wrote:
> > Am Montag, 13. März 2017, 20:35:07 CET schrieb Gary R Hook:
> > 
> > Hi Gary,
> 
> Is it acceptable to snip stuff out? Most of this code seems irrelevant
> to this discussion....

Let us snip it :-)

> >> > 
> >> > But then, the key is 4 bytes longer than a normal AES key as it
> >> > contains
> >> > the leading 32 bits of the IV.
> >> 
> >> I had my wires crossed due to an incomplete understanding of an AEAD
> >> cipher
> >> in general, and GCM in particular. I'm hopeful that someone can help me
> >> understand:
> >> 
> >> For the AES GCM encryption tests in testmgr.h, where there is an IV,
> >> they're all
> >> 12 bytes in length. As I understand AES GCM the IV can be anywhere from
> >> 1 to 2^64
> >> bits in length; the value of 96 makes for convenience and efficiency.
> >> But it's
> >> neither a requirement nor restriction.
> > 
> > That is correct. For longer IVs, you would need to use Ghash to compress
> > it to
> > 96 bits. The remaining 32 bits to get to one AES block is the counter
> > that is
> > used for the CTR AES mode in GCM.
> 
> Yes, understood. It's all falling into place now. What seems to be missing
> (to me) is a way for the transform to indicate that it allows all valid
> (GCM)
> IV lengths, as opposed to the (specified in the data structure) 12 bytes.

The kernel crypto API does not support varying IV sizes. So, simply stay with 
12 / 8 bytes as explained should suffice.

> I
> get the context of IPSec, but I would think AF_ALG allowing access to the
> transforms means that we can't rely upon a context. And there seems to be no
> way for an implementation to let a user know about any IV restrictions (or
> not).

In algif_aead, we simply have:

        unsigned ivsize =
                crypto_aead_ivsize(crypto_aead_reqtfm(&ctx->aead_req));
...
                if (con.iv && con.iv->ivlen != ivsize)
                        return -EINVAL;

Thus, if the user space caller does not provide exactly ivsize bytes of IV, he 
gets an error.
> 
> Do we just let the implementation return an error when it can't handle
> something?
> 
> Or (highly possible) am I missing the obvious?
> 
> >> There are no tests (in testmgr.h) that use an IV length other than  0 or
> >> 96.> 
> > See aes_gcm_rfc4106_enc_tv_template for other types of IV.
> 
> All 8 bytes, it seems, which makes sense for 4106.
> 
> >> My comment about RFC4106 has to do with requiring an IV 0f 96 bits + a
> >> word
> >> that
> >> is incremented for each block (making every nonce unique, per the
> >> requirement).
> >> But let's ignore that, please.
> >> 
> >> It looks as if:
> >> 
> >> What seems to be missing is the ability to register a (GCM) transform
> >> that can
> >> handle an IV of arbitrary (allowable) length. I have to specify the
> >> length (ivsize)
> >> when I register an algorithm, and everything I see in the existing code
> >> appears
> >> to expect a GCM ivsize to be 96 bits, period (or zero). This is what I
> >> meant when
> >> I referenced RFC4106: I perceive restrictions not in my code, but n the
> >> way GCM seems
> >> to be supported in the crypto AEAD framework. A complete GCM
> >> implementation would not
> >> seem to have a restriction to a specific IV length (rather, a range of
> >> allowed
> >> values).
> > 
> > 96 bits is the use case in IPSEC. As the kernel crypto API transforms
> > are used
> > for IPSEC. Nobody would prevent you from supporting other IV sizes. But
> > then
> > you would need to add a Ghash operation to compress it to the right
> > length. No
> > other GCM implementation has that and hence the limitation.
> 
> Of course. That's the component that I'm missing, and I want to understand
> whether there's a compelling need.

I would not think that there is any need for it. If there would be, a generic 
helper for the IV compression should be added instead of having the algos 
implementing it itself over and over again.
> 
> > But 96 bits is not the common case. See the 4106 implementations, you
> > see the
> > ivsize being 8. This is correct because setkey requires AES keysize + 4
> > bytes
> > in length (see crypto_rfc4106_setkey for an example). The trailing 4
> > bytes of
> > the key are the initial 4 bytes of the GCM IV.
> 
> Yes. The RFC4106 document is pretty clear on the layout of the IV.
> 
> > My comment was about your comment to refer to RFC4106. I just wanted to
> > understand your code and and make sense of your comments. :-)
> > 
> >> Is my reading of the GCM description in error? Do we need/want the
> >> ability
> >> to have a flexible IV length for GCM? What am I not understanding?
> > 
> > In your case, just change the wording in the comment slightly and we are
> > all good.
> 
> Will do. I appreciate the discussion! Very helpful.
> 

Ciao
Stephan
