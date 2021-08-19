Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C600BC432BE
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Aug 2021 12:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADF7B61153
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Aug 2021 12:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238475AbhHSMym (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Aug 2021 08:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236481AbhHSMym (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Aug 2021 08:54:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D028A60ED3;
        Thu, 19 Aug 2021 12:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629377646;
        bh=HlixAXCTwMqPZ4hSfOVE2EwrOAOo+Eu0C9tRc5EWGVE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GPCrt8bEdbmy7tnE0wr2COYQnEzrIM7Pook8/lzwdw933EZce8dILmTR7HAX2fjfX
         +dG/WPGtCBET+9xnxC73Duil1km/URi+17CiTJJswPO08iOrX+QETYWFlt4DqeuXpw
         cvzb6oBmCwSEgqHbpIWbSKcMQ5uCJeDi6tLFAJWkBdLwUgVIJLQ7Xrm2xIG2y6sX79
         zvclN7/DA8v724bek4t2bzSqNypK9fl+6cfuSTwzfNwuHLt/4N5tpjUwERSG3y8wf0
         528x/zXW5W5hNosTj29xzQiOJxp3Gn6s+9p4iUMxHK5ywhk590x/qlphkCuT8jmKKw
         JMQpEyzUczYOw==
Message-ID: <f7bc5822c2376aa833e1299a66cb267b098512b2.camel@kernel.org>
Subject: Re: [RESEND] crypto: public_key: fix overflow during implicit
 conversion
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     zhenwei pi <pizhenwei@bytedance.com>
Cc:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 19 Aug 2021 15:54:03 +0300
In-Reply-To: <20210819123710.1170050-1-pizhenwei@bytedance.com>
References: <20210819123710.1170050-1-pizhenwei@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2021-08-19 at 20:37 +0800, zhenwei pi wrote:
> Hit kernel warning like this, it can be reproduced by verifying 256
> bytes datafile by keyctl command, run script:
> RAWDATA=3Drawdata
> SIGDATA=3Dsigdata
>=20
> modprobe pkcs8_key_parser
>=20
> rm -rf *.der *.pem *.pfx
> rm -rf $RAWDATA
> dd if=3D/dev/random of=3D$RAWDATA bs=3D256 count=3D1
>=20
> openssl req -nodes -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem \
>   -subj "/C=3DCN/ST=3DGD/L=3DSZ/O=3Dvihoo/OU=3Ddev/CN=3Dxx.com/emailAddre=
ss=3Dyy@xx.com"
>=20
> KEY_ID=3D`openssl pkcs8 -in key.pem -topk8 -nocrypt -outform DER | keyctl=
 \
>   padd asymmetric 123 @s`
>=20
> keyctl pkey_sign $KEY_ID 0 $RAWDATA enc=3Dpkcs1 hash=3Dsha1 > $SIGDATA
> keyctl pkey_verify $KEY_ID 0 $RAWDATA $SIGDATA enc=3Dpkcs1 hash=3Dsha1
>=20
> Then the kernel reports:
>  WARNING: CPU: 5 PID: 344556 at crypto/rsa-pkcs1pad.c:540
>    pkcs1pad_verify+0x160/0x190
>  ...
>  Call Trace:
>   public_key_verify_signature+0x282/0x380
>   ? software_key_query+0x12d/0x180
>   ? keyctl_pkey_params_get+0xd6/0x130
>   asymmetric_key_verify_signature+0x66/0x80
>   keyctl_pkey_verify+0xa5/0x100
>   do_syscall_64+0x35/0xb0
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>=20
> The reason of this issue, in function 'asymmetric_key_verify_signature':
> '.digest_size(u8) =3D params->in_len(u32)' leads overflow of an u8 value,
> so use u32 instead of u8 for digest_size field. And reorder struct
> public_key_signature, it saves 8 bytes on a 64-bit machine.
>=20
> Thanks to Jarkko Sakkinen for suggestions.

I appreciate this but since it is not relevant for the commit message,
I have to rip it off :-)

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko

> Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> ---
>  include/crypto/public_key.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/crypto/public_key.h b/include/crypto/public_key.h
> index 47accec68cb0..f603325c0c30 100644
> --- a/include/crypto/public_key.h
> +++ b/include/crypto/public_key.h
> @@ -38,9 +38,9 @@ extern void public_key_free(struct public_key *key);
>  struct public_key_signature {
>  	struct asymmetric_key_id *auth_ids[2];
>  	u8 *s;			/* Signature */
> -	u32 s_size;		/* Number of bytes in signature */
>  	u8 *digest;
> -	u8 digest_size;		/* Number of bytes in digest */
> +	u32 s_size;		/* Number of bytes in signature */
> +	u32 digest_size;	/* Number of bytes in digest */
>  	const char *pkey_algo;
>  	const char *hash_algo;
>  	const char *encoding;

