From: lee joey <joeyli.kernel@gmail.com>
Subject: Re: [PATCH] X.509: Fix test for self-signed certificate
Date: Wed, 17 Feb 2016 10:57:27 +0800
Message-ID: <CAGLnvc8J4dJSsCUR2Uz4nKpdNbaq6yq2o3E-R=NLXiAw7A0yAA@mail.gmail.com>
References: <1455197665-11199-1-git-send-email-mmarek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	linux-kernel@vger.kernel.org
To: Michal Marek <mmarek@suse.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35662 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933658AbcBQC52 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2016 21:57:28 -0500
In-Reply-To: <1455197665-11199-1-git-send-email-mmarek@suse.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2016-02-11 21:34 GMT+08:00 Michal Marek <mmarek@suse.com>:
> If either the Subject + subjectKeyId or the Issuer + Serial number
> differs between the certificate and the CA, the certificate is not
> self-signed. In practice, both will be equal for self-signed
> certificates and both will differ for CA-signed certificates. It is only
> an issue if the CA used the same serial number for its own self-signed
> certificate and the certificate we are checking. This is probably not
> valid / recommended, but we should not assume that the certificate is
> self-signed because of that.
>
> Fixes: 4573b64a31cd ("X.509: Support X.509 lookup by Issuer+Serial form AuthorityKeyIdentifier")
> Signed-off-by: Michal Marek <mmarek@suse.com>

Tested-by: Lee, Chun-Yi <jlee@suse.com>


Regards

Joey Lee

> ---
>  crypto/asymmetric_keys/x509_public_key.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
> index 7092d5cbb5d3..2c46e022a2a3 100644
> --- a/crypto/asymmetric_keys/x509_public_key.c
> +++ b/crypto/asymmetric_keys/x509_public_key.c
> @@ -308,9 +308,10 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
>         cert->pub->id_type = PKEY_ID_X509;
>
>         /* Check the signature on the key if it appears to be self-signed */
> -       if ((!cert->akid_skid && !cert->akid_id) ||
> -           asymmetric_key_id_same(cert->skid, cert->akid_skid) ||
> -           asymmetric_key_id_same(cert->id, cert->akid_id)) {
> +       if ((!cert->akid_skid ||
> +                       asymmetric_key_id_same(cert->skid, cert->akid_skid)) &&
> +           (!cert->akid_id ||
> +                       asymmetric_key_id_same(cert->id, cert->akid_id))) {
>                 ret = x509_check_signature(cert->pub, cert); /* self-signed */
>                 if (ret < 0)
>                         goto error_free_cert;
> --
> 2.1.4
>
