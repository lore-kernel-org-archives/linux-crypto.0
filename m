From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: algif_skcipher - Fixed overflow when sndbuf is page
	aligned
Date: Tue, 30 Nov 2010 17:45:00 +0800
Message-ID: <20101130094500.GA29306@gondor.apana.org.au>
References: <4CF4C3BC.4010607@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:43914 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab0K3JpD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Nov 2010 04:45:03 -0500
Content-Disposition: inline
In-Reply-To: <4CF4C3BC.4010607@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dmitry Kasatkin <dmitry.kasatkin@nokia.com> wrote:
> Hi,
> 
> What is the repo with algif patches?

http://git.kernel.org/?p=linux/kernel/git/herbert/cryptodev-2.6.git;a=summary

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
