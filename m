Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795012390;
	b=cuZxZ26pEXyEUZL9X3xvGQET3zUB4zYkoe9/eRXY9WCZAOY9XbPKd9NXwGow7BhcLKr+
	 njIuAITQ2qQnUjrP/BiWtuaq0iXa7cNv702Yl9PXDyozsUjHdXmFp1mAb4T9SQcvxvWTf
	 G6J4m1pVumF6VDSaiOSCdfLuyToN7prIZnrb57LeJYMMoWETuPt3yKannGXajErGQyc7A
	 2jW96s48WicEEmDDspKdbaRCUqFgSXXOk7jJKjyHMwmV5DbOIf0dRy7VRw7tvD0sG593S
	 2gotT2lJDTi6IFZ+p22vWxiguPDbbaepFM4MpFwYhx9jfZeg+DmZqyYZmRHKZ/BqDAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795012390;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UbKKKwuSqmqLTt5+7BE++XpAc29t2C2cKUALxdXI6xc=;
	b=xqh24hPdJBD7+4WwLd+loHUVFpJkIktA1FDgOiKsoXTcNYh5QzrVqMKlHhDcp5ZxABxh
	 tjW0qEQg+/mK8xBgXudA15ONwFIHn/JmiRt7TwoglbQnQS0cWP44QvrppdQGASd0BxfVx
	 rfgR+5PPIH43fOw8ap6QTQ3214u4bavqqPCFewyZ2JNa/Qmhp2Tz8ZlWL+VeFHXvu+q0J
	 uw8TKAIc2iJ2QpgBV4jobXJgbWH6UNpEAH7nLZbfrr4CtwHsVEsBIRMZlsGYgB/DvnLWZ
	 x80/CtdIcUEDbbkYksmgGOpr+zLUNyJAAEN+U1DMrs9hpitHa34wkad3vBmV4akX+ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aKsKwoar;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9AB606A339;
	Wed, 18 Nov 2026 14:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aKsKwoar
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00781F000C6;
	Wed, 18 Nov 2026 14:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012390;
	bh=UbKKKwuSqmqLTt5+7BE++XpAc29t2C2cKUALxdXI6xc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aKsKwoar7e0Ra6XiwKT/7z8u6kEiledf3bbg3prwX+2CfHTPA8N88AVHSkgadsRZk
	 hEoeym3oodfOUSlx1z5W75iZ+EGi+35iK5jA7UzVK6CsT7ZsSnduqmqvCPCSgPqAG3
	 41e6gDciB8zkAAkIM2YaJ+Ym/f6udYcdpYnS940I3GWzK4uuYa+PpPa3y/k59gNkKf
	 4TLJhzKow5l/8qYR3UU+hplToQZNGAOns5IjU0MCnXO82m5hQm6TTy26FEqmAH8MOV
	 1dbRNOsI7HLzIeVKpr82dKHZqJ8h3RT2AoPq7CKk5Gpmm63ubnxGacXHAN0nMuIoOy
	 toD0PUObwlYVQ==
Message-ID: <sashiko-outbox-221217@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 3/9] KEYS: keycrypt: Add the OP-TEE backend
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rodolfo Giometti" <giometti@enneenne.com>, "David Howells" <dhowells@redhat.com>, "Jarkko
 Sakkinen" <jarkko@kernel.org>, keyrings@vger.kernel.org
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Jens
 Wiklander" <jenswi@kernel.org>, "Sumit Garg" <sumit.garg@kernel.org>, op-tee@lists.trustedfirmware.org,
 =?utf-8?b?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@nxp.com>, "Pankaj Gupta" <pankaj.gupta@nxp.com>, "Sahil
 Malhotra" <sahil.malhotra@nxp.com>, "Ahmad Fatoum" <a.fatoum@pengutronix.de>, "Richard
 Weinberger" <richard@nod.at>, =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAoQ1MgR1JP?=
 =?utf-8?b?VVAp?= <chleroy@kernel.org>, "Eric Biggers" <ebiggers@kernel.org>, "Demi
 Marie Obenour" <demiobenour@gmail.com>, "Arnd Bergmann" <arnd@arndb.de>, "Paul
 Moore" <paul@paul-moore.com>, "James Morris" <jmorris@namei.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <20261118140421.584086-4-giometti@enneenne.com>
References: <20261118140421.584086-1-giometti@enneenne.com>
 <20261118140421.584086-4-giometti@enneenne.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 14:33:08 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] keys: keycrypt: NULL dereference in kc_optee_remove() after
  shutdown
--

commit 8da0e0d8cf01260109b52bb935a051203beb3758
Author: Rodolfo Giometti <giometti@enneenne.com>

KEYS: keycrypt: Add the OP-TEE backend

This commit adds the "optee" keycrypt backend driver for the tee tier,
using sessions to the keycrypt OP-TEE Trusted Application to seal, load,
and run operations on keys.

> diff --git a/security/keys/keycrypt/optee.c b/security/keys/keycrypt/opte=
e.c
> new file mode 100644
> index 0000000000000..5a3ab6f825f17
> --- /dev/null
> +++ b/security/keys/keycrypt/optee.c

[ ... ]

> +static void kc_optee_remove(struct tee_client_device *tdev)
> +{
> +	keycrypt_unregister_backend(&keycrypt_optee);
> +	tee_client_close_session(kc_optee.tee, kc_optee.ctl);
> +	tee_shm_free(kc_optee.ctl_shm);
> +	tee_client_close_context(kc_optee.tee);
> +	kc_optee.tee =3D NULL;
> +}
> +
> +static const struct tee_client_device_id kc_optee_id_table[] =3D {
> +	{ UUID_INIT(0x65a0d9f0, 0xf057, 0x414c,
> +		    0x9d, 0x5a, 0x9a, 0xac, 0x7c, 0x8b, 0xa4, 0x61) },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(tee, kc_optee_id_table);
> +
> +static struct tee_client_driver kc_optee_driver =3D {
> +	.probe		=3D kc_optee_probe,
> +	.remove		=3D kc_optee_remove,
> +	/* Sessions left open would outlive a kexec in the secure world */
> +	.shutdown	=3D kc_optee_remove,

[Severity: High]
Can kc_optee_remove() run a second time when .remove is called after
.shutdown?

device_shutdown() invokes .shutdown without unbinding the driver.  On
Arm FF-A OP-TEE platforms, device_shutdown() first calls
tee_client_device_shutdown() -> kc_optee_remove() on the TA child device,
setting kc_optee.tee to NULL, and then reaches the parent FF-A device
whose .shutdown callback (ffa_remove() -> ... ->
optee_unregister_devices()) unregisters the TA device and calls
tee_client_device_remove() -> kc_optee_remove() again.

The second call hits WARN_ON_ONCE(!h) in keycrypt_unregister_backend(),
dereferences NULL kc_optee.tee in tee_client_close_session() and
tee_client_close_context(), and double frees kc_optee.ctl_shm.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118140421.5840=
86-1-giometti@enneenne.com?part=3D3
