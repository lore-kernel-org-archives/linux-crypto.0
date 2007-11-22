From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [0/11] Add IV generators and givcrypt
Date: Thu, 22 Nov 2007 15:37:02 +0300
Message-ID: <20071122123701.GA16262@2ka.mipt.ru>
References: <20071122084758.GA7536@gondor.apana.org.au> <20071122112558.GE2444@2ka.mipt.ru> <20071122113116.GD8781@gondor.apana.org.au> <20071122115707.GE28024@2ka.mipt.ru> <20071122120937.GA9357@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:60695 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbXKVMhI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 07:37:08 -0500
Content-Disposition: inline
In-Reply-To: <20071122120937.GA9357@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 08:09:37PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Thu, Nov 22, 2007 at 02:57:07PM +0300, Evgeniy Polyakov wrote:
> >
> > Somehow you described that to others - just combine things together and
> > put to Documentation/crypto and that will be enough.
> 
> Patches are welcome :)

I still do not understand thow whole concept.

> > For example this patchset looks like possible first step in proper
> > chaining mechanism for hardware devices, but if this will be impemented
> > this way, then each hardware completion callback should be wrapped with
> > proper geniv methods (like those which copy iv back to req->info). Is
> > this right approach (for those users who care about correct returned
> > IV), or will it just use software implementation only?
> 
> I'm not sure I understand your question.
> 
> First of all givcrypt is designed to work for hardware devices too.
> If they can generate their own IVs then they should directly hook
> up to the givcrypt method and use the givcipher type.

But for example chainiv_givcrypt() will not return correct iv when
called fro async device, since when givcrypt() returned operation is not
yet completed.

> If not then they can use one of the precanned geniv wrappers and
> declare their preference in the in crypto_ablkcipher_alg->geniv.
> 
> As to chaining, I presume you mean something like encryption
> followed by hashing? If so then this really doesn't have much to
> do with chaining at all.

Yes, that what I meant. And also other possible crypto modes, which can
require iv-based tweaks.

> I think we don't really need chaining in general because the
> hardware doesn't do arbitrary chaining.  Instead what they do
> is specific chains that are useful for particular applications.
> 
> Case in point would be encryption followed by hashing which is
> designed for IPsec.
> 
> Therefore instead of having a general chaining abstraction I've
> chosen to do chaining support on a case-by-case basis.  For
> instance, the above chaining is now supported by the new crypto_aead
> transform type.
> 
> It just so happens that people are also designing algorithms
> to make crypto_aead useful for software as well which is a
> bonus :)

This sheds some light on, thanks.

-- 
	Evgeniy Polyakov
