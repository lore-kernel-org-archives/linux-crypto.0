From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5] crypto: rsa - return raw integers for the ASN.1 parser
Date: Tue, 14 Jun 2016 15:53:15 +0200
Message-ID: <1920297.cMHx9vzUDS@tauon.atsec.com>
References: <1465910098-16349-1-git-send-email-tudor-dan.ambarus@nxp.com> <2066344.ohg9RiuaKP@tauon.atsec.com> <20160614133806.GA22193@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36464 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbcFNNxS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2016 09:53:18 -0400
In-Reply-To: <20160614133806.GA22193@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 14. Juni 2016, 21:38:06 schrieb Herbert Xu:

Hi Herbert,

> On Tue, Jun 14, 2016 at 03:20:06PM +0200, Stephan Mueller wrote:
> > memzero_explicit(raw_key) should be added here in success and failure code
> > paths.
> 
> The raw_key is just a bunch of pointers, do we really need to
> zero it?

You are correct.

But then I need to refine my question: isn't rsa_parse_priv_key allocating the 
MPIs (at least rsa_parse_priv_key seems to hint to that considering the error 
code path)? So, shouldn't the MPIs be freed here with free_mpis()? This would 
apply to parse_pub_key too.

Ciao
Stephan
