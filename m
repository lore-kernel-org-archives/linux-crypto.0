Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0AA2D8DDF
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 18:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777919243; cv=none; b=LUw6QG084CANQWyOWr4EDPuejvavqqZ9O4a8XE8W0z6CwREPSzJMCfWsXZ35ItFwmEMGL3rj2OtmsvAlkQoEMPV8qTWb45S57PymKvCDrf8BbVMsk2j+405EqT70uGfN9O3S8PNG1qvRIJlVemFGAgkVZDf0cf/F1M4vGkoOj8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777919243; c=relaxed/simple;
	bh=y/kTyLZ+HlrQ86LL8qEx3AHdGjyMN0oqqtY2orbYvNk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t7/7MlpFO2sPOar5w3qymA8FZsm845PGTmG8qC7L1iPgq0BDJN4STtZ5MLJfw8mOhzCo7J0mQwaKg1pCfCpc5iGx33BxuQ1pYEknIqmc/CEvcudTsCe6m6wgl/qCfR7lGRuuXL0ZoqEzT4W23tpJEL46rjQ/UbeJ5ZJkXxekvys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ajFqOG7n; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=X0TACS4X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ajFqOG7n";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="X0TACS4X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777919241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QcIoIPVGpy+t+hQB2IAxs25ATlafdN5syK1oi+kQ6lo=;
	b=ajFqOG7npDB9cr38r1KHbO6t0tbncY2+MTX6CEOyHqNrMpqCftF7ObSow3Ut8ncyHv12BB
	gqQfWPUwReD6wAmbyb8TgXUTdwQne+EZ2KeY/ojPRawQFyXNwi8av0Nc2q1xpzfVBfBSHx
	k6EfqxfFdRJOoTRLxmaDy3l43OEEipQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-K76z_r-WNsOz3EczvvlAzg-1; Mon, 04 May 2026 14:27:19 -0400
X-MC-Unique: K76z_r-WNsOz3EczvvlAzg-1
X-Mimecast-MFC-AGG-ID: K76z_r-WNsOz3EczvvlAzg_1777919239
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50edf01172bso123511091cf.2
        for <linux-crypto@vger.kernel.org>; Mon, 04 May 2026 11:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777919239; x=1778524039; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QcIoIPVGpy+t+hQB2IAxs25ATlafdN5syK1oi+kQ6lo=;
        b=X0TACS4XXf3YLMC+ZSqUzPgih6j7BGfb0qvSALIdbFSgXDcnSq2D+/roChPmKAB2i/
         I9xJTYPXRGwYI9krqrt4HBBkZt1iTt2kuy7+n5nE4y7RW48VgHJC5RRCpBnEFGgGW6Jw
         qvYJ3XN/yC6htjdvm+27ZEePZy/0sx6u4mZGt8KF9dj72Bjip+70Ps1XFczIH7jQHNdu
         rXLWE4L6lKh8kKrA5Fm4OQajZjqFBqOU6/iPZLvmzB3Exzjo19dsWjDQtBpGJ4czXSQX
         uOapTF9697atNxMLgyuiRMPiUj6qJMg5X7WofJaEKn1wx3ZOtGJ5TvtomBXLoUHifK0M
         8cvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777919239; x=1778524039;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QcIoIPVGpy+t+hQB2IAxs25ATlafdN5syK1oi+kQ6lo=;
        b=rfPIGxvwXlSMbjJGNOPnkK57R/Lml2IwUV3dJDIq8n/Nx51ZuY8dVzkl4mNPbqaP1f
         tmhFF+XFk/awFGDnGoiVK1neOielxyCbz1yDpYWRjHf2zRzewtLf/yx471YiobGPgYOJ
         KxzK4ZPSC93/jHf85vks+5cjwbv33EEQ8TxdnRXiL1XHP1BrKAT3HHWtpgAgAZ2/2vDl
         dJF3Uy9JNzhQjdHhqIGmmnTg+QsCE5XSVze9xxJAQa/A7SyRv82sTzgBk0PIyGgAwV0a
         yxNiLMinl7yBv5zv6vtPuUG1M1P+ZXt7YjmK+gJtiIzoje6eRvFKs7bY0MsttK8zhuhd
         0ujQ==
X-Forwarded-Encrypted: i=1; AFNElJ+WMxVcIxOPATtjOvlSXuANQNntOJLU2dzncSDPxqYM0QEaj27dIjlGvbKPvp1IGybsRqaXDTT2OiDx6xg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg9EY1ZIN+0Wy8Oin+G3eWu7ifBkMnThpxJxEH8fhwlWBdMNEq
	R+bymhzw2PtmgXxUDzfRtYjBky9XbI2Kp9vEwP9Tf/VMGG5xCK45xhb02d8/kFmnDdJQvmqr6WW
	lIxVzwMl1NFa3h8sy0TPodtPelM8YrIV/HG6tASd4S6S+mGtmNV95YBTOkU4T/Jr7zA==
X-Gm-Gg: AeBDiesWOhTka1uRev2o2AWZrvPxKJS8y5QqUG00OEtylHIX5mHbAF3Qb3H0DYn6VE3
	ds6p+uu7rftdsk37oGce54EiTAQ6Mky1m/lJeSLTl3BEh2lA8V6kiMAKmD9zYbXhbyxLCD16uXu
	04hLVW0MfdTcXl8rDP0+6Ep3jtSBm0X4Lm3nwUHHOCCmNCVEDlxmjRM3JCKcXfaKih4pwgKWWXq
	Glsimq9y0a5qgftK1LZ6FzNDsZWSDMsIQ5m3tMwYoaGBpbCxR1RXXMAmuRymFBehde56ti5rKDR
	hQy9yBUElei0hI+SklAw1D4V/3cx7Zw0GrRIL2yTdtV+yUo7pNciS/o6fNapy6qS4xrxZD1qeUb
	Ep2AHoa7SEJszQg+37R+F+sc8IwQ=
X-Received: by 2002:a05:622a:5c09:b0:509:26f4:64e9 with SMTP id d75a77b69052e-5104bfa3385mr199674321cf.51.1777919239174;
        Mon, 04 May 2026 11:27:19 -0700 (PDT)
X-Received: by 2002:a05:622a:5c09:b0:509:26f4:64e9 with SMTP id d75a77b69052e-5104bfa3385mr199673581cf.51.1777919238563;
        Mon, 04 May 2026 11:27:18 -0700 (PDT)
Received: from m8.users.ipa.redhat.com ([2603:7000:9400:fe80::fc6])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b53ca982a1sm142199276d6.38.2026.05.04.11.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 11:27:18 -0700 (PDT)
Message-ID: <2890ba9558b503c5316f04aed958337455b8f7ad.camel@redhat.com>
Subject: Re: [PATCH] crypto: af_alg - Document the deprecation of AF_ALG
From: Simo Sorce <simo@redhat.com>
To: Jeff Barnes <jeffbarnes@linux.microsoft.com>, Eric Biggers
	 <ebiggers@kernel.org>
Cc: Jon Kohler <jon@nutanix.com>, "linux-crypto@vger.kernel.org"
	 <linux-crypto@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "linux-doc@vger.kernel.org"
	 <linux-doc@vger.kernel.org>, "linux-api@vger.kernel.org"
	 <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>, "netdev@vger.kernel.org"
	 <netdev@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 04 May 2026 14:27:16 -0400
In-Reply-To: <F100C726-F841-461B-BE2F-C2018C122426@getmailspring.com>
References: <20260504173952.GA2291@sol>
	 <F100C726-F841-461B-BE2F-C2018C122426@getmailspring.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-05-04 at 14:12 -0400, Jeff Barnes wrote:
>=20
> On May 4 2026, at 1:39 pm, Eric Biggers <ebiggers@kernel.org> wrote:
> > =20
> > That seems to be an implementation of FIPS 140-3's integrity self-check=
.
> > A few observations:
> > =20
> > - It could easily use userspace SHA-512 code instead.  If including
> >  libcrypto.so in the "FIPS cryptographic boundary" would cause
> >  certification difficulties, then a sha512.c file could simply be added
> >  to 'libkcapi-hmaccalc' which is already in it.
>=20
> Indeed expanding the crypto boundary to include libcrypto.so would cause
> certification difficulties, it would mean certifying all of libcrypto.so
> with the kernel. There *may* be a case for saying that it is outside the
> module boundary but only if:
>=20
>     * The integrity mechanism is clearly external
>     * The cryptographic module refuses to operate unless integrity is con=
firmed
>     * The trust relationship is clearly documented
>=20
> I don't see how this could be justified cleanly without significant pushb=
ack.
>=20
> > =20
> > - It's compatible with all of the proposed hardening.  It doesn't
> >  require zero-copy performance.  It runs as root, so it would be
> >  compatible with a capability check.  "hmac(sha512)" will need to be on
> >  the algorithm allowlist anyway for iwd.
> > =20
> > - FIPS 140-3 might also allow it to be simplified to use a plain hash
> >  instead of pointlessly using HMAC with a fixed key.
>=20
> FIPS 140=E2=80=913 (via ISO/IEC 19790) draws a hard distinction between:
>     * Integrity checking (cryptographic protection)
>     * Integrity measurement (detection only)
>=20
> A plain hash provides no protection against an attacker who can modify
> both the object and its reference hash.

The integrity mechanism is not build to detect adversarial tampering
(at least at level 1), that is not its purpose.

That said a HMAC is just a hash with a secret key in the mix, it does
not change the conditions wrt Hash if the key is known.

=20
> > By the way, also on the topic of FIPS 140-3, some people do use AF_ALG
> > for ACVP (even though it's not all that great for that purpose, either)=
.
> > But ACVP is a testing thing, not something that is needed on production
> > systems.  ACVP can just be run as root on a testing build; there's no
> > need to enable support for it in the actual production build.
>=20
> Agreed it's not a good use case. Unless/until pkcs1 is supported, I
> don't see how you can use it for all of the test cases. Plus as
> evidenced by Ubuntu's new cert, it requires validating the library.

Of course it requires validating the library, validating the
cryptography implementation is what FIPS is for. libcrypto.so can never
be outside the boundary, unless you turn it off at runtime ...

The problems are rather that libcrypto is not instrumented to enforce
KAT tests are executed before it allows operation (crypto-API did this
via test manager) and does not provide an indicator (or blocks)
unapproved algorithms ...

Simo.

--=20
Simo Sorce
Distinguished Engineer
RHEL Crypto Team
Red Hat, Inc

