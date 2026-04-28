Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B10828B40E
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 16:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777393611; cv=none; b=o2/TYoh8nw1tQKUfyZuIij68NFTQtXq+AX7k8uURQbgnNRH+46cG413QnhqfI5w622cKhOSCJZGi5iYN1F5k6vv+OGJjl4ywlqzmdTH3lfaCkDpnUEuciPDANAr8JUsSByY1kWvOspV+HF3+pvXdlatJQVSnSOa2RPSBCwxN7+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777393611; c=relaxed/simple;
	bh=YOxrYOW2XiUYIkrw5Ws4BEeoJlv7piRCf57Qrembd30=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Tnl0Olf5i3u50vWC9zsz3QV37RVuPLyPFYgXxi76M6GX1fMspD7SLrWHv44V0hl3AlZvQpnyuuZjNCWp37zKFrsT3bY0oPJ+gtiaAQ+4I2hJuIqJGyDHGmasUZSeDRCa6Gamk4rTf4fMmPRXMEh+BXmSNwcMnfpITBlO4CkPPcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JYh+wyVH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GswFMkIv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JYh+wyVH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GswFMkIv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777393609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xrFHh+IXnC+/GYwS6dyvxdLC3SMZIfTMFwt74S3Tudw=;
	b=JYh+wyVHyA0poGbEghbO0T6zKPF8c2X0vr+FdDH4QyGuIxJ/+XpJpaCpY5GCsAvS1WrGTz
	+PUEPo14MRz4lDKYhL2BEoBXJtATpsPsOo2whlE3k41XzOY5QbG5QgQaXjrHmuottkeD7r
	geNVfodFsy+a+3XoQqnjRQ/JRfXL7l8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-Oh_AWcOnNI-EbRbLyJuGkw-1; Tue, 28 Apr 2026 12:26:48 -0400
X-MC-Unique: Oh_AWcOnNI-EbRbLyJuGkw-1
X-Mimecast-MFC-AGG-ID: Oh_AWcOnNI-EbRbLyJuGkw_1777393608
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8d5107ec672so2827883985a.0
        for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 09:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777393608; x=1777998408; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xrFHh+IXnC+/GYwS6dyvxdLC3SMZIfTMFwt74S3Tudw=;
        b=GswFMkIvYXD978xkY2uOlsE4scUqi8x2dBD8jSVxKtl54ackU0dVtRIC+fbSbomHMJ
         jGZX2FwrVpnkRF+7NRtfP5J1oB2lx2mrhld1whT9VuoQff1qfMlYx89wqMB567ipvcSb
         wGFx6+mSoILq5c0MHkLstzOvzdLV1yiQ/ZrT1YqaUrD3VCckIb2bvw7LwRmwJa2085BX
         6GQ0BHGrGYS+axJ0ArCN6rkrJsKWqz8bQyqw/gK98t3F2KDLFjaJI32HpbyZU4T9jDFk
         CMwwX0mo8CnH+L/ZbndeKtsiwYmu5wZpQg9MZG6IPhTvhAP0MHmc6+Vfk26r3vjbsIqR
         qYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777393608; x=1777998408;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xrFHh+IXnC+/GYwS6dyvxdLC3SMZIfTMFwt74S3Tudw=;
        b=tAwEQNFIncIzpx09OLPrCo0rBQvyA5IqgoPnB5LXG37E5zU40vKruHa/18KuA28hz8
         Sy8Tyov9kosme4cg6zqnuUkDyiFrDRIeRBJB8s/lww9isHycS3prGAL1NKjXP0ChETqc
         2HO6AJiEck846M5xtRz/ktOwv1fD7lIDJ5/eEgnplgMUuz461lqcgSaRuBTh1HAO7id4
         L7T0AOYfuuFlDGlg4oW5aH+znjoXAQlJoxc/V2JSLoUuUFJSv6D0gJ5WblMdCs+16Moc
         BoLBVkWA/FLrTIhFMFn7dpQUFO5pdJj/i7u7pCb6Qn+8Nyk6cZBNuNoaWecnAtSlx0Xy
         tUwg==
X-Forwarded-Encrypted: i=1; AFNElJ+0ty+QbVAiEm6jtsDyAtknOKe1lWdOSpVNHdVBl0sWjXsHahDJR4sRRJaOvbTtl4SLtos0ElXa+fJsGlY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLt9pCrHU5g4q8Yg0vFD+vXzSWoRv4pZml6BRJuFjIv13vlCNp
	PkDtaVtEZ6pKWl8r3vLPlLcDFTM6bcZbFjPwkfOtTQgX6110DhJVCMJSFrW/LAdpyyEKacqwhSG
	toHEr2CSHbrFlgrYjD0hHwf248Sn+Stb7/vwVslgrlm0W8l+LfcdoVydloMRZTjxoLA==
X-Gm-Gg: AeBDiesLnrTPnM1hvdvTTJLMdnnXtcDyccnI5nj6n//AhMvEikSyoWTjNDmso0M10AZ
	xwpvzObwBUSgLgKynBld/g24AXOXysG5CBhmMeBQhnLhikRWPaEDIo6jyKG02TGDBR55gFzK5fQ
	SvmjaOekjXShYye6QiLt1Cs2EIzpYlylNm5iJdtFFrl1/vcfqq/X7bNRkJTrouETfXUrlxFE0qK
	VnXF7lEueIqhnfC/hscP+Xf6/A4qy458EDPkHs/XJigOEQCTWCDYoVL7VqoYYVTyiEN0ZjXEKc3
	30tC2D0115cFQiwdjIeuGGhI0Ba7CswPt14K5HPR/X8yskd/N5Ub3nFk9p9joFuBkx3BqO4r9ON
	7DNxMF2TykojTvO6J3D7xUkPY3NA=
X-Received: by 2002:a05:620a:17ac:b0:8eb:f3c7:2248 with SMTP id af79cd13be357-8f7d98fdd73mr490616785a.42.1777393607763;
        Tue, 28 Apr 2026 09:26:47 -0700 (PDT)
X-Received: by 2002:a05:620a:17ac:b0:8eb:f3c7:2248 with SMTP id af79cd13be357-8f7d98fdd73mr490605285a.42.1777393606834;
        Tue, 28 Apr 2026 09:26:46 -0700 (PDT)
Received: from m8.users.ipa.redhat.com ([2603:7000:9400:fe80::fc6])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8f7c7cd2c68sm233679985a.22.2026.04.28.09.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:26:45 -0700 (PDT)
Message-ID: <33613b11328d830f8683fc6ec6900da2b479ae27.camel@redhat.com>
Subject: Re: [PATCH net-next v2 0/5] Reimplement TCP-AO using crypto library
From: Simo Sorce <simo@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>, Neal
 Cardwell	 <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 "David S . Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>,  Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,  "Jason A .
 Donenfeld"	 <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Dmitry Safonov	 <dima@arista.com>
Date: Tue, 28 Apr 2026 12:26:44 -0400
In-Reply-To: <20260427232054.GA2700@sol>
References: <20260427172727.9310-1-ebiggers@kernel.org>
	 <CAJwJo6Z9oJSMMBUL_pbYWN6ha3n4MRpKV_aVut8E+af3JUDFkw@mail.gmail.com>
	 <20260427200116.GA3454259@google.com> <20260427232054.GA2700@sol>
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

On Mon, 2026-04-27 at 16:20 -0700, Eric Biggers wrote:
> On Mon, Apr 27, 2026 at 08:01:16PM +0000, Eric Biggers wrote:
> > > - Ronald P. Bonica (the original RFC5925 author), together with Tony
> > > Li do have an active RFC draft to support the additional algorithms
> [...]
> > > [1] https://www.ietf.org/archive/id/draft-bonica-tcpm-tcp-ao-algs-00.=
html
>=20
> For what it's worth, that draft makes very little sense.  For example,
> it proposes three variants of HMAC-SHA3, instead of just making the
> modern choice of KMAC256.  And it proposes both HMAC-SHA384 and
> HMAC-SHA512, despite them being redundant with each other after the
> specified truncation to 128 bits.

Which is bogus in itself without proper security considerations, the
only considerations cited is an RFC from 1997 ... clearly the pinnacle
of cryptography advice ...

If they need a shorter hash they should make themselves a favor and use
SHAKE and then define the desired output length and desired key size.
That draft is just a disaster as written.

Specifically they should use KMAC128 as defined in NIST SP 800-185
(which uses cSHAKE128 underneath).

Simo.

--=20
Simo Sorce
Distinguished Engineer
RHEL Crypto Team
Red Hat, Inc

