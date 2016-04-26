From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2 v2] crypto: Key-agreement Protocol Primitives API
 (KPP)
Date: Tue, 26 Apr 2016 09:19:57 +0800
Message-ID: <20160426011957.GA16114@gondor.apana.org.au>
References: <1460712316-3127-1-git-send-email-salvatore.benedetto@intel.com>
 <1460712316-3127-2-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57455 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbcDZBUD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 21:20:03 -0400
Content-Disposition: inline
In-Reply-To: <1460712316-3127-2-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 15, 2016 at 10:25:15AM +0100, Salvatore Benedetto wrote:
> Add key-agreement protocol primitives (kpp) API which allows to
> implement primitives required by protocols such as DH and ECDH.
> The API is composed mainly by the following functions
>  * set_params() - It allows the user to set the parameters known to
>    both parties involved in the key-agreement session
>  * set_secret() - It allows the user to set his secret, also
>    referred to as his private key
>  * generate_public_key() - It generates the public key to be sent to
>    the other counterpart involved in the key-agreement session. The
>    function has to be called after set_params() and set_secret()
>  * generate_secret() - It generates the shared secret for the session
> 
> Other functions such as init() and exit() are provided for allowing
> cryptographic hardware to be inizialized properly before use
> 
> Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>

I don't have any strong objections to this interface.

However, I'd like to see it along with an actual user.  Because
otherwise I'm afraid that I'll soon start receiving patches adding
drivers using this interface even before we settle on what the
user interface looks like.  And what the user interface looks
like is very important because it may impact how we structure
this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
