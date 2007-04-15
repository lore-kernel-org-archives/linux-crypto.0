From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: [CRYPTO] is it really optimized ?
Date: Sun, 15 Apr 2007 16:36:22 +0530
Message-ID: <a781481a0704150406y7d256e8ft47e7ce8d71877f8d@mail.gmail.com>
References: <38b2ab8a0704140615y2ba8145bmd3c2316a41d99265@mail.gmail.com>
	 <E1Hco0p-0007np-00@gondolin.me.apana.org.au>
	 <20070414194434.GA18988@halcrow.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: "Michael Halcrow" <mike@halcrow.us>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:39262 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbXDOLGY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Apr 2007 07:06:24 -0400
Received: by ug-out-1314.google.com with SMTP id 44so876381uga
        for <linux-crypto@vger.kernel.org>; Sun, 15 Apr 2007 04:06:22 -0700 (PDT)
In-Reply-To: <20070414194434.GA18988@halcrow.us>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 4/15/07, Michael Halcrow <mike@halcrow.us> wrote:
> On Sun, Apr 15, 2007 at 05:34:19AM +1000, Herbert Xu wrote:
> >
> > You would assign "aes-foo" a lower priority and then tell eCryptfs to
> > use "aes-foo" instead of "aes".
>
> Note that eCryptfs whitelists the cipher name (see
> fs/ecryptfs/crypto.c::ecryptfs_cipher_code_str_map[] and associated
> functions). This is because eCryptfs needs to pick a cipher code
> (RFC2440-ish) to identify the cipher in the encrypted file
> metadata. Shall I go ahead with a patch to add support for the '-'
> qualifier?

Whitelisting the possible ciphers (and associated parameters) would
make sense if eCryptfs wants to support only a specific subset of the
available ciphers (which is how it ends up, presently).

This seems to be an unfortunate relic of the fact that eCryptfs is
based too tightly on PGP and hence only supports those ciphers that
were mentioned in RFC2440 (minus IDEA and SAFER-SK128, which do not
exist in the kernel CryptoAPI as of now). The downside is that as and
when new ciphers come into the CryptoAPI, you'll need to keep
maintaining / adding on to that ecryptfs_cipher_code_str_map[] list
(or not support them).

The IPsec code (net/xfrm/xfrm_algo.c:{a,e}alg_list[]) does some
similar whitelisting, but then they *have* to be conformant to the
IPsec RFCs. I don't see why eCryptfs is limiting itself by restricting
itself to the decade-old RFC2440. The absence of CAST6 and Twofish
from that list is particularly sad.

A better idea would be a patch that gets rid of whitelisting itself?
