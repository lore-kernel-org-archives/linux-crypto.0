From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: Fix ASN.1 key handling for RSA akcipher
Date: Fri, 28 Aug 2015 16:15:21 -0700
Message-ID: <55E0EB89.6050800@intel.com>
References: <1440739738-19587-1-git-send-email-marcel@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Marcel Holtmann <marcel@holtmann.org>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25470 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbbH1XQn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Aug 2015 19:16:43 -0400
In-Reply-To: <1440739738-19587-1-git-send-email-marcel@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Marcel,
On 08/27/2015 10:28 PM, Marcel Holtmann wrote:
> +++ b/crypto/rsaprivatekey.asn1
> @@ -0,0 +1,13 @@
> +RSAPrivateKey ::= SEQUENCE {
> +	version		Version,
> +	modulus		INTEGER ({ rsa_get_n }),	-- n
> +	publicExponent	INTEGER ({ rsa_get_e }),	-- e
> +	privateExponent	INTEGER ({ rsa_get_d }),	-- d
> +	prime1		INTEGER,			-- p
> +	prime2		INTEGER,			-- q
> +	exponent1	INTEGER,			-- d mod (p-1)
> +	exponent2	INTEGER,			-- d mod (q-1)
> +	coefficient	INTEGER				-- (inverse of q) mod p
> +}
> +
> +Version ::= INTEGER

If you want to do this you should also update the existing RSA test vectors, because
they are failing after this patch is applied.
The reason is that there is no version in the private keys in crypto/testmgr.h
And the QAT RSA implementation should also be updated so they are consistent.

I have already started to do the changes proposed for the akcipher api to add SGLs
support and to split the set_key for set_publickey and set_privatekey so I will
take care of this.
Thanks,
T
