From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v5 2/4] crypto: add PKE API
Date: Tue, 16 Jun 2015 07:54:57 +0800
Message-ID: <20150615235457.GB16562@gondor.apana.org.au>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1>
 <20150615201842.15697.59701.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47978 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbbFOXzK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 19:55:10 -0400
Content-Disposition: inline
In-Reply-To: <20150615201842.15697.59701.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 01:18:42PM -0700, Tadeusz Struk wrote:
>
> +static int crypto_akcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
> +{
> +	struct crypto_report_akcipher rakcipher;
> +
> +	strncpy(rakcipher.type, "akcipher", sizeof(rakcipher.type));
> +	strncpy(rakcipher.subtype, alg->cra_name, sizeof(rakcipher.subtype));

There is no point in reporting cra_name.  That's already taken care
of by crypto_user.c.

> +static void crypto_akcipher_show(struct seq_file *m, struct crypto_alg *alg)
> +	__attribute__ ((unused));
> +
> +static void crypto_akcipher_show(struct seq_file *m, struct crypto_alg *alg)
> +{
> +	seq_puts(m, "type         : akcipher\n");
> +	seq_printf(m, "subtype      : %s\n", alg->cra_name);

Ditto please drop subtype.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
