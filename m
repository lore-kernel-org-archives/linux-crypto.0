From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] libcrc32c: keep intermediate crc state in cpu order
Date: Thu, 8 Nov 2007 21:37:46 +0800
Message-ID: <20071108133746.GE17186@gondor.apana.org.au>
References: <473186E9.5080300@panasas.com> <4731A5C5.3030109@panasas.com> <4731D387.5090901@panasas.com> <20071108001400O.tomof@acm.org> <4731DA0C.5090702@panasas.com> <4731FD41.1090704@panasas.com> <4732C6D2.5000904@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: open-iscsi@googlegroups.com, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Clay Haapala <chaapala@cisco.com>,
	fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu,
	djiang@mvista.com
To: Benny Halevy <bhalevy@panasas.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3551 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753742AbXKHNiE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Nov 2007 08:38:04 -0500
Content-Disposition: inline
In-Reply-To: <4732C6D2.5000904@panasas.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 08, 2007 at 10:20:34AM +0200, Benny Halevy wrote:
> crypto/crc32.c:chksum_final() is computing the digest as
> *(__le32 *)out = ~cpu_to_le32(mctx->crc);
> so the low-level crc32c_le routines should just keep
> the crc in cpu order, otherwise it is getting swabbed
> one too many times on big-endian machines.
> 
> Signed-off-by: Benny Halevy <bhalevy@fs1.bhalevy.com>

Patch applied.  Thanks!

I'll send this to stable too.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
