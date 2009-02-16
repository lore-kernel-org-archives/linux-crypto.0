From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Export symbol ksize()
Date: Mon, 16 Feb 2009 09:57:06 +0800
Message-ID: <20090216015706.GA13948@gondor.apana.org.au>
References: <1234454104.28812.175.camel@penberg-laptop> <20090215133638.5ef517ac.akpm@linux-foundation.org> <1234734194.5669.176.camel@calx> <20090215135555.688ae1a3.akpm@linux-foundation.org> <1234741781.5669.204.camel@calx> <20090215170052.44ee8fd5.akpm@linux-foundation.org> <20090216012110.GA13575@gondor.apana.org.au> <1234747726.5669.215.camel@calx> <20090216015229.GA13892@gondor.apana.org.au> <1234749279.5669.225.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	Christoph Lameter <cl@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, Geert.Uytterhoeven@sonycom.com
To: Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:35024 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753245AbZBPB5U (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Feb 2009 20:57:20 -0500
Content-Disposition: inline
In-Reply-To: <1234749279.5669.225.camel@calx>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 15, 2009 at 07:54:39PM -0600, Matt Mackall wrote:
>
> I'll bite.. what's wrong with page boundaries? Do we play per-SKB TLB
> games in virtual network drivers?

Because virtual physical memory is not physically contiguous.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
