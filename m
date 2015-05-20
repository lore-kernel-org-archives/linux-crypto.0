From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] random: add random_initialized command line param
Date: Wed, 20 May 2015 08:29:19 +0200
Message-ID: <3005024.K2tYVGR0qE@tauon>
References: <477328243.LmeEDk1ili@tauon> <20150518225807.GA25931@gondor.apana.org.au> <CACXcFmnZw9eS1EuokG54OYgCXnju2iD2q2o9miWmQMab5SJmDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Theodore Ts'o <tytso@mit.edu>, linux-crypto@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:57986 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbbETG30 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 May 2015 02:29:26 -0400
In-Reply-To: <CACXcFmnZw9eS1EuokG54OYgCXnju2iD2q2o9miWmQMab5SJmDQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 19. Mai 2015, 18:40:20 schrieb Sandy Harris:

Hi Sandy,
>
>When we do do it, I see no reason to support anything other than 128
>and 256, and I am not sure about retaining 128. Nor do I see any
>reason this should be a command-line option rather than just a
>compile-time constant.

I would hazard to guess that a compile time option is a bit difficult for 
distributions which typically only want one kernel for all their user base. As 
that user base is typically large, they would potentially be unable to please 
everybody with a compile time option.

But I see that such a change may not be warranted at this point. Though, I see 
that discussion may rise again in the future when such new requirements for 
256 bit keys (not only AES, thanks Sandy for mentioning :-) ) are commonly 
raised.

So, let us disregard the patch until hard requirements are coming up.

Ciao
Stephan
