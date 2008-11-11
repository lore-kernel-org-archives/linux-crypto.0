From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] libcrc32c: Fix "crc32c undefined" compilation error
Date: Tue, 11 Nov 2008 12:15:16 +0800
Message-ID: <20081111041516.GA8251@gondor.apana.org.au>
References: <1226365166-24472-1-git-send-email-rueegsegger@swiss-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52797 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755175AbYKKEPT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Nov 2008 23:15:19 -0500
Content-Disposition: inline
In-Reply-To: <1226365166-24472-1-git-send-email-rueegsegger@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 11, 2008 at 01:59:26AM +0100, Adrian-Ken Rueegsegger wrote:
> The latest shash changes leave crc32c undefined:
> 
> [...]
> Building modules, stage 2.
>   MODPOST 1381 modules
>   ERROR: "crc32c" [net/sctp/sctp.ko] undefined!
>   ERROR: "crc32c" [net/ipv4/netfilter/nf_nat_proto_sctp.ko] undefined!

Thanks for fixing this Adrian! I've applied to cryptodev.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
