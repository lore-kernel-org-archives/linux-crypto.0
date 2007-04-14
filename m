From: Michael Halcrow <mike@halcrow.us>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Sat, 14 Apr 2007 14:44:35 -0500
Message-ID: <20070414194434.GA18988@halcrow.us>
References: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com> <E1Hco0p-0007np-00@gondolin.me.apana.org.au>
Reply-To: Michael Halcrow <mike@halcrow.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:13437 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbXDOBSV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Apr 2007 21:18:21 -0400
Content-Disposition: inline
In-Reply-To: <E1Hco0p-0007np-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Apr 15, 2007 at 05:34:19AM +1000, Herbert Xu wrote:
> Francis Moreau <francis.moro@gmail.com> wrote:
> > 
> > hmm yes indeed it should do the job, but I don't see how you do that.
> > For example, let say I want to use "aes-foo" with eCryptfs. I can give
> > a higher priority to "aes-foo" than "aes" one. When eCryptfs asks for
> > a aes cipher it will pass "aes" name and since "aes-foo" has a higher
> > priority then the cypto core will return "aes-foo" cipher, right ? But
> > in this scheme, eCryptfs has not a higher priority than other kernel
> > users. How can I prevent others to use "aes-foo" ?
> 
> You would assign "aes-foo" a lower priority and then tell eCryptfs to
> use "aes-foo" instead of "aes".

Note that eCryptfs whitelists the cipher name (see
fs/ecryptfs/crypto.c::ecryptfs_cipher_code_str_map[] and associated
functions). This is because eCryptfs needs to pick a cipher code
(RFC2440-ish) to identify the cipher in the encrypted file
metadata. Shall I go ahead with a patch to add support for the '-'
qualifier?

Mike
