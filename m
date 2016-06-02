From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v7 1/3] crypto: Key-agreement Protocol Primitives API
 (KPP)
Date: Thu, 2 Jun 2016 17:44:03 +0800
Message-ID: <20160602094403.GA16560@gondor.apana.org.au>
References: <1464708983-61664-1-git-send-email-salvatore.benedetto@intel.com>
 <1464708983-61664-2-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34948 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbcFBJoI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 05:44:08 -0400
Content-Disposition: inline
In-Reply-To: <1464708983-61664-2-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 31, 2016 at 04:36:21PM +0100, Salvatore Benedetto wrote:
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

You totally ignored my comments about this patch in the round v5.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
