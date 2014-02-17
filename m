From: Marco d'Itri <md@linux.it>
Subject: Re: [PATCH] crypto: Add soft module dependency to load HW
 accelerated crypto modules
Date: Mon, 17 Feb 2014 02:21:50 +0100
Message-ID: <20140217012150.GA7542@bongo.bofh.it>
References: <1392405277.27116.72.camel@schen9-DESK>
 <20140214202828.GA17267@hmsreliant.think-freely.org>
 <1392412566.27116.77.camel@schen9-DESK>
 <87ob26d1br.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>, lucas.de.marchi@gmail.com,
	linux-crypto@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from attila.bofh.it ([85.94.204.146]:53981 "EHLO attila.bofh.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbaBQB3K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 16 Feb 2014 20:29:10 -0500
Content-Disposition: inline
In-Reply-To: <87ob26d1br.fsf@rustcorp.com.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Feb 17, Rusty Russell <rusty@rustcorp.com.au> wrote:

> > Do you know if the upstream modprobe has the fixes (or plan) to
> > recognize soft dependencies?  I was under the impression that it
> > is the case.
> Marco CC'd...
I only maintain the Debian package, but Lucas should know.

-- 
ciao,
Marco
