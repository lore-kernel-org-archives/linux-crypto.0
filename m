From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH 2/2] crypto/ansi prng: alloc cipher just in in init()
Date: Mon, 29 Jun 2009 23:48:21 +0200
Message-ID: <20090629214821.GC29616@Chamillionaire.breakpoint.cc>
References: <1246281425.3688.13.camel@queen> <20090629140704.GA25939@Chamillionaire.breakpoint.cc> <20090629152027.GA5022@hmsreliant.think-freely.org> <20090629214508.GB29616@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	davem@davemloft.net, Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57924 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295AbZF2VsV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Jun 2009 17:48:21 -0400
Content-Disposition: inline
In-Reply-To: <20090629214508.GB29616@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Sebastian Andrzej Siewior | 2009-06-29 23:45:08 [+0200]:

>From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
>
>As reported by Eric Sesterhenn the re-allocation of the cipher in reset leads

Neil, the patches are untested. Could you please verify them?

Sebastian
