From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [linux-cifs-client][PATCH] Enable signing for ntlmv2 within
	NTLMSSP using kernel crypto APIs
Date: Mon, 2 Aug 2010 14:55:08 +0800
Message-ID: <20100802065508.GA8431@gondor.apana.org.au>
References: <1280604866-9505-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smfrench@gmail.com, linx-cifs@vger.kernel.org,
	samba-technical@samba.org, linux-crypto@vger.kernel.org,
	shirishpargaonkar@gmail.com
To: shirishpargaonkar@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59890 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab0HBGzM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Aug 2010 02:55:12 -0400
Content-Disposition: inline
In-Reply-To: <1280604866-9505-1-git-send-email-shirishpargaonkar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

shirishpargaonkar@gmail.com wrote:
>
> static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
> -                                   const struct mac_key *key, char *signature)
> +                       struct TCP_Server_Info *server, char *signature)
> {
> -       struct  MD5Context context;
> +       int rc = 0;
> +       struct scatterlist sgin[2];
> +       struct hash_desc desc;
> 
> -       if ((cifs_pdu == NULL) || (signature == NULL) || (key == NULL))
> +       if (cifs_pdu == NULL || server == NULL || signature == NULL)
>                return -EINVAL;
> 
> -       cifs_MD5_init(&context);
> -       cifs_MD5_update(&context, (char *)&key->data, key->len);
> -       cifs_MD5_update(&context, cifs_pdu->Protocol, cifs_pdu->smb_buf_length);
> +       desc.tfm = server->ntlmssp.tfm_md5;
> +
> +       rc = crypto_hash_init(&desc);

We're phasing out the crypto_hash_* interface.  Please use the
equivalent crypto_shash_* interface (or if you require access
to asynchronous hardware, the crypto_ahash_* interface).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
