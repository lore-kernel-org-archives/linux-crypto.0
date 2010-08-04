From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [linux-cifs-client][PATCH] Enable signing for ntlmv2 within
	NTLMSSP using kernel crypto APIs
Date: Wed, 4 Aug 2010 14:58:41 +0800
Message-ID: <20100804065841.GA370@gondor.apana.org.au>
References: <1280604866-9505-1-git-send-email-shirishpargaonkar@gmail.com> <20100802065508.GA8431@gondor.apana.org.au> <AANLkTimtgejfxW8P_GvGqD3muu2Wh6BfC-xPTpNtJb9+@mail.gmail.com> <20100803083330.GA15074@gondor.apana.org.au> <AANLkTimE0CgvYtrTSxsL5Z-kg5C9k9Lf3pDmW8gkRg7S@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:42961 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259Ab0HDG6n (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Aug 2010 02:58:43 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTimE0CgvYtrTSxsL5Z-kg5C9k9Lf3pDmW8gkRg7S@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 03, 2010 at 09:48:14PM -0500, Shirish Pargaonkar wrote:
>
> @@ -42,21 +43,38 @@ extern void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
>  		       unsigned char *p24);
>  
>  static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
> -				    const struct mac_key *key, char *signature)
> +			struct TCP_Server_Info *server, char *signature)
>  {
> -	struct	MD5Context context;
> +	int rc = 0;
> +	struct shash_desc desc;

That's your problem.  You need to allocate space for the actual
descriptor:

	struct {
		struct shash_desc shash;
		char ctx[crypto_shash_descsize(tfm)];
	} sdesc;

See crypto/testmgr.c for an actual example.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
