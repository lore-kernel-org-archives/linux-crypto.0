From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC 2/5] [crypto] geode: relax in busy loop and care about
	return value
Date: Mon, 22 Oct 2007 19:30:44 +0200
Message-ID: <20071022173044.GB16319@Chamillionaire.breakpoint.cc>
References: <1192788233-14968-1-git-send-email-linux-crypto@ml.breakpoint.cc> <1192788233-14968-3-git-send-email-linux-crypto@ml.breakpoint.cc> <20071021081452.GB9397@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:39065 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892AbXJVRap (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Oct 2007 13:30:45 -0400
Content-Disposition: inline
In-Reply-To: <20071021081452.GB9397@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-10-21 16:14:52 [+0800]:

>I'd like to see the error propagated up though.  We'd need
>to change the simple cipher interface to allow errors to be
>returned.
okey.

>Cheers,
Sebastian
