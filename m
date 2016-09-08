From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: rmmod crypto driver when ipsec is in use
Date: Thu, 8 Sep 2016 19:19:50 +0800
Message-ID: <20160908111950.GA25853@gondor.apana.org.au>
References: <CAFXBA==cKF9DgBtMSEK42D-ukw4VX6NRVXgCAbiLf-XqMUAGOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46272 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753022AbcIHLUB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Sep 2016 07:20:01 -0400
Content-Disposition: inline
In-Reply-To: <CAFXBA==cKF9DgBtMSEK42D-ukw4VX6NRVXgCAbiLf-XqMUAGOA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 08, 2016 at 03:17:46PM +0530, Harsh Jain wrote:
> Hi,
> 
> What is the expected behavior when driver is unregistered(Rmmod ) with
> active ipsec session.?
> I am getting stacktrace(BUG_ON in crypto_unregister_alg) instead of
> "module in use".

The driver is supposed to set cra_module to itself.  If it doesn't
then it's buggy.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
