Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795598371;
	b=Z57fqlSYAOHfnFkpfTROLrvOPMx0pjKAL8gdeVNfoXFcGd2CH4kp4/OV4QRoqGxdEglI
	 ztBQoJwsvP5ZVAd1YvVqu80yT07jab7WuUvtk+VyFhRRt7iMBTs3hITDUAb+0WyuUGh6y
	 aT/iGXIb3IzRs9rdJ0vNQmhN7vzkbo8WkTarADhxcdAayuDHff6k/oZI3nL26Mni37tX3
	 /yOyjbHeKhqko/QCF2qHMiGhuKGRq6Sa2ToqXueV2QrOpnPzYKX4QdT5HUgAkiu3UDkmr
	 CTejsWvrdZKix+VVRPJcNhBz/ov/ITbG5YaPd9uuYYywKBr04J5xBJwT36hqbcDYOqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795598371;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HM/80FJuhfrnMxC/IfbUvOR9owLp0+IkW3x6Etq4fS4=;
	b=rIV3vhCFMG0NtCpOg5KETIiT4gI0E9gB8g+Yn7sqJNOz1aYiJdbncg2+IXZhNQYhXcOz
	 ZwNHWhu/nwmiL7hvS1mDM2yU98eis0sNmxGNdwtbSVpkKuNey7m4djBaB4mZZ4M7mm+oY
	 jol/mQPg2WPLaWnLmmA8KFkUgM2QSvar+Syj+pQYcEoCLZ+SXPKWkbNWMK5XbaIjNcMah
	 Tgzf985SlQPL/YHTrK6bfnEHf6uNZyg77glZ7fDilOm5OtsuZZEwKqAkWM+j6RrVZweFo
	 lpj7bvt+R2p3a+K23Ulk97JLwiuAmFuqPDFmfTzncYIQMwgZv+vhS8IdKvVuHOkWJlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zmg4qrAM;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135B0606A692
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 09:19:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 135B0606A692
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zmg4qrAM
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bba5e17cbeso3974185e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 01:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795598363; x=1796203163; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HM/80FJuhfrnMxC/IfbUvOR9owLp0+IkW3x6Etq4fS4=;
        b=zmg4qrAMEyL+6l/4oysXmbs6l1nqhC0voMmFglVAX4rEfGv9PDMaZF9yiMvP8KOc/m
         9IHUI6UU5taUhdpu8AXhe1ivoR3R1si3RvjmEmtzBHlSdJUZfc5WTrI8RI4LJRHRBd4U
         XnWI6h9PeS1F+bBNm0A6uQKTqMX/poXGwI0tZ2CEWUpt6B9j8yf2a/SCOUyBw95K8lE8
         BDCno7072yeJloNnuvBcPhoz+eV7xLeZRQ5JjgPA/p0WH1gjsHNz3d0Aet3OWEyymye3
         YO+8AyxbGx99Z03rk5RzGLFeUuwSRQ8MpxhOUTKQIIPqqx5QTbF5/pwR1H0z+WXROOiR
         qr6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795598363; x=1796203163;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HM/80FJuhfrnMxC/IfbUvOR9owLp0+IkW3x6Etq4fS4=;
        b=kMkTRonsB0H2f8Ifo8CCMaUOH8rSM3NB4qGTV5G1cekPEPV8+Bj5LLbEzNHMUmY3hA
         Gx+Ul8AR2F2hlhvke/amBlSEiRHlryHERxbm/d3ctGTIbGwiMN2R1jSyahplofkUPGm+
         6U/GmfPT9gG4c5RyJrXy6ISDWmYAk8NZ2uKaqpw+hPme9HIK4gn+cxwBJOxgFDZqTET3
         QNKZE+aN3ywszRUVbZ52NkkW79uoeSEOhWI+foBh4Zo9Hgm99RLKn9xdlCabE5Kz+6/g
         iZKeUZWQ2nT00JTzovnjNdEAfMnVIhmdzegf65D2hg6THDALD/Zn5SmzYVRGmCQo9JlR
         c+Ag==
X-Forwarded-Encrypted: i=1; AL+hErFiZ5cG8+1YFpyOC069Zx5VemEizJdlHGzJqGDDoniyqTrqRwNZR/rFF7bLoY4EZCU5hB0SsgcicW0I05w=@vger.kernel.org
X-Gm-Message-State: APuU4Z9/wqgQJFaTmwpZXtTovYpssoW8qVAFoIpmkb9WS+FfQCALzkKl
	pZVwPTLbmXoc3ONjM91UKS6kPJesDbaXOiGsnvmfAz+Bx9NQWsY2cmDn
X-Gm-Gg: AZFdTZdh28ScGpA3acdW3OaYaC3IsgoGXOZxoad+PQAzdhSEP+7vPBBg6sE+jxu7Ji4
	tkWYVf3kTN8nbg9moj8pKjuOxooNz8CnLlzK2cshRlEQJOxKCjF5mtc1/+qNJa1w+Xi9QbVbj05
	Lb8TvXun8HNJR0n9xPjSVIP9NIKK+Ht2ffO41vvMnT2gxZwL5jbyjbU1xlGj0GU/mzuijKkS9om
	x/3+VWmbuWAIHo8wPSOMaRNdJOY0SXNxZMiWVoLScKmzOfi+Z9EmQ5kKop0S2+Q+s4NdtNUXvo5
	GLu3ihuCxaKXU82xA9tRHT51C2CpksdbmIKFDucYgqjrwxWA3VzTjRppSwCxewkC8F2qBjUM+PE
	9Eo74HCxe+69RDtFr78ATWOe/aF8Uun6KFn5MJR6qb/VUEyKVxysdLGST1GpnEy7j85RMI2E1FQ
	PMTTfvIERThn1umMLY8rPZXoXLqLbDeAdp7hAZFSakFGAuovPhmT0zSU1C8Qmuh+3mxHC2Va+rJ
	SvHDhd6+9NjmJz5EsdB2XKUYLbGpuGzPKf1Pd847Y0NwPIP0es04fCR9hrBkLVMJvknArbZ7pef
	9rHCDN2sDIck+RXNWGATZqCNtODz/WA+E0mq+1t78LB7CiABV9gc21dh9I/3bTrt+w==
X-Received: by 2002:a05:600d:8449:b0:4bb:8e95:8ce1 with SMTP id 5b1f17b1804b1-4bb8e958ce4mr235915585e9.23.1795598363338;
        Wed, 25 Nov 2026 01:19:23 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b39b6sm461330575e9.12.2026.11.25.01.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 01:19:23 -0800 (PST)
Date: Wed, 25 Nov 2026 09:19:21 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: keyrings@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, Ahmad Fatoum
 <a.fatoum@pengutronix.de>, Alasdair Kergon <agk@redhat.com>, Andrew Morton
 <akpm@linux-foundation.org>, Benjamin Marzinski <bmarzins@redhat.com>,
 David Gstir <david@sigma-star.at>, David Howells <dhowells@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, David Woodhouse
 <dwmw2@infradead.org>, Herbert Xu <herbert@gondor.apana.org.au>, Ignat
 Korchagin <ignat@linux.win>, James Bottomley
 <James.Bottomley@HansenPartnership.com>, James Morris <jmorris@namei.org>,
 James Prestwood <prestwoj@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Lukas Wunner <lukas@wunner.de>, Mike
 Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Mimi
 Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>, Peter Huewe
 <peterhuewe@gmx.de>, Randy Dunlap <rdunlap@infradead.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, Shuah Khan <skhan@linuxfoundation.org>, Sumit
 Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v2 2/9] lib/asn1_encoder: Add
 asn1_encode_integer_bytes()
Message-ID: <20261125091921.4bf40279@pumpkin>
In-Reply-To: <20261124194043.1651679-3-jarkko@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
	<20261124194043.1651679-3-jarkko@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 24 Nov 2026 21:40:36 +0200
Jarkko Sakkinen <jarkko@kernel.org> wrote:

> Add a helper encoding a positive integer from a byte array in big-endian
> format.

Interesting...
You allow for integer values longer than 127 bytes but don't allow for the
much more common likelyhood of the encoding being 'implicit'.

David

> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  include/linux/asn1_encoder.h |  3 ++
>  lib/asn1_encoder.c           | 56 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/include/linux/asn1_encoder.h b/include/linux/asn1_encoder.h
> index d17484dffb74..e206bd425854 100644
> --- a/include/linux/asn1_encoder.h
> +++ b/include/linux/asn1_encoder.h
> @@ -12,6 +12,9 @@ unsigned char *
>  asn1_encode_integer(unsigned char *data, const unsigned char *end_data,
>  		    s64 integer);
>  unsigned char *
> +asn1_encode_integer_bytes(unsigned char *data, const unsigned char *end_data,
> +			  const unsigned char *integer, u32 integer_len);
> +unsigned char *
>  asn1_encode_oid(unsigned char *data, const unsigned char *end_data,
>  		u32 oid[], int oid_len);
>  unsigned char *
> diff --git a/lib/asn1_encoder.c b/lib/asn1_encoder.c
> index 92f35aae13b1..8fea70dc0846 100644
> --- a/lib/asn1_encoder.c
> +++ b/lib/asn1_encoder.c
> @@ -10,6 +10,8 @@
>  #include <linux/string.h>
>  #include <linux/module.h>
>  
> +static int asn1_encode_length(unsigned char **data, int *data_len, int len);
> +
>  /**
>   * asn1_encode_integer() - encode positive integer to ASN.1
>   * @data:	pointer to the pointer to the data
> @@ -85,6 +87,60 @@ asn1_encode_integer(unsigned char *data, const unsigned char *end_data,
>  }
>  EXPORT_SYMBOL_GPL(asn1_encode_integer);
>  
> +/**
> + * asn1_encode_integer_bytes() - encode positive integer bytes to ASN.1
> + * @data:		pointer to the pointer to the data
> + * @end_data:		end of data pointer, points one beyond last usable byte in @data
> + * @bytes:		integer bytes
> + * @bytes_len:		amount of bytes
> + *
> + * Encode a positive integer from a byte array in big-endian format. Strip
> + * leading zeros.
> + */
> +unsigned char *
> +asn1_encode_integer_bytes(unsigned char *data, const unsigned char *end_data,
> +			  const unsigned char *bytes, u32 bytes_len)
> +{
> +	int data_len = end_data - data;
> +	bool add_pad;
> +	int ret;
> +
> +	if (IS_ERR(data))
> +		return data;
> +
> +	if (!bytes || !bytes_len)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* Strip leading zeros: */
> +	while (bytes_len > 1 && bytes[0] == 0) {
> +		bytes++;
> +		bytes_len--;
> +	}
> +
> +	add_pad = bytes[0] & 0x80;
> +
> +	if (data_len < 2)
> +		return ERR_PTR(-EINVAL);
> +
> +	*(data++) = _tag(UNIV, PRIM, INT);
> +	data_len--;
> +
> +	ret = asn1_encode_length(&data, &data_len, bytes_len + add_pad);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	if (data_len < bytes_len + add_pad)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (add_pad)
> +		*(data++) = 0;
> +
> +	memcpy(data, bytes, bytes_len);
> +	data += bytes_len;
> +	return data;
> +}
> +EXPORT_SYMBOL_GPL(asn1_encode_integer_bytes);
> +
>  /* calculate the base 128 digit values setting the top bit of the first octet */
>  static int asn1_encode_oid_digit(unsigned char **_data, int *data_len, u32 oid)
>  {

