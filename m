From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] [eSTREAM] stream: Wrapper for eSTREAM ciphers
Date: Tue, 13 Nov 2007 09:43:43 +0800
Message-ID: <E1IrkoZ-0007hT-00@gondolin.me.apana.org.au>
References: <fd3e431c0711121159p4eec500fw5a3caec76f07295d@mail.gmail.com>
Cc: linux-crypto@vger.kernel.org
To: thesweeheng@gmail.com (Tan Swee Heng)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4768 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756917AbXKMBnq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Nov 2007 20:43:46 -0500
In-Reply-To: <fd3e431c0711121159p4eec500fw5a3caec76f07295d@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Tan Swee Heng <thesweeheng@gmail.com> wrote:
> This patch implements a template that wraps around an eSTREAM cipher
> algorithm and its ivsize.

Why couldn't straem ciphers that require an IV just use the
blkcipher interface? Please enlighten me :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
