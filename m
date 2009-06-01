From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Use kzfree in crypto API context initialization and
	key/iv handling
Date: Mon, 1 Jun 2009 22:33:42 +1000
Message-ID: <20090601123342.GA13261@gondor.apana.org.au>
References: <20090601085814.3e010533@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, riel@redhat.com, research@subreption.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu,
	linux-mm@kvack.org, torvalds@osdl.org, linux-crypto@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:35424 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753275AbZFAMeD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2009 08:34:03 -0400
Content-Disposition: inline
In-Reply-To: <20090601085814.3e010533@lxorguk.ukuu.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> Zeroing long term keys makes sense but for the short lifepsan keys used on
> the wire its a bit pointless irrespective of speed (I suspect done
> properly the performance impact would be close to nil anyway)

Sure, though we're not actually arguing whether keys should be
zeroed here, but the metadata, i.e., pointers to keys, buffers,
etc.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
