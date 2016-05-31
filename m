From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 1/3] crypto: Key-agreement Protocol Primitives API
 (KPP)
Date: Tue, 31 May 2016 14:42:10 +0800
Message-ID: <20160531064210.GA13948@gondor.apana.org.au>
References: <1462830041-7582-1-git-send-email-salvatore.benedetto@intel.com>
 <1462830041-7582-2-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36814 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbcEaGmT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 02:42:19 -0400
Content-Disposition: inline
In-Reply-To: <1462830041-7582-2-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 09, 2016 at 10:40:39PM +0100, Salvatore Benedetto wrote:
> Add key-agreement protocol primitives (kpp) API which allows to
> implement primitives required by protocols such as DH and ECDH.
> The API is composed mainly by the following functions
>  * set_params() - It allows the user to set the parameters known to
>    both parties involved in the key-agreement session
>  * set_secret() - It allows the user to set his secret, also
>    referred to as his private key

Why can't we just have one function, set_secret or better yet setkey?

>  * generate_public_key() - It generates the public key to be sent to
>    the other counterpart involved in the key-agreement session. The
>    function has to be called after set_params() and set_secret()
>  * generate_secret() - It generates the shared secret for the session

Ditto, we only need one operation and that is multiplication by the
secret.

I'm OK with you keeping them separate for kpp users so that they
don't have to explicitly provide G but please ensure that drivers
only have to implement one of them.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
