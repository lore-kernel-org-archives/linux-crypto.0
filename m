Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454F730C61C
	for <linux-crypto@vger.kernel.org>; Wed, 26 Nov 2025 18:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764182163; cv=none; b=SiN/fPl9rsCPyUJqHxwg9Wo0deV1lz1yppMJH40nNkroBBhjVmfCHu62Oc4+XYYMAx48TqbuOmwGrZJ+52FdZnynxpEJfeQzIjFSP9VF9A5Hm73Ew+FFkDG6JPSnjNHecGbr32SNBNTnZknoxtYeW1zgQX6I5BgP3g49oiqbgx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764182163; c=relaxed/simple;
	bh=l+UpyQQXX4ETUL7fz0/4jQ9/53R6ELtNZ9Z4xa9EpMc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NyhO0M45xWjwQMOLTuIJqiTj0a83PQ4VJptNpvb/cUDaPXx3xdc/d+r5SwG2dazZHWJMGgUSMmnkuSCEpql/895H+s1f70rLt1bat8sZfB5YlwP8mDQHXhwyQVCdBWqojhBhc0FLy/mwYU//gXpsZAiCBAxquNjweajJxQq/8vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jPzA5Cqh; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jPzA5Cqh"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42b38693c4dso56969f8f.3
        for <linux-crypto@vger.kernel.org>; Wed, 26 Nov 2025 10:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764182160; x=1764786960; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=l+UpyQQXX4ETUL7fz0/4jQ9/53R6ELtNZ9Z4xa9EpMc=;
        b=jPzA5Cqhmrbfgc+zL534Z/H4GkxyfEnDr5gk+XEtyfYWXbd+sNtIcjHRihNUVz+9iY
         aM2Ah74wPTlcsiwgq6Z+FdZX3PS8PHm/Tp0t0vxz04YXWFEBofXKZzGx40LVw69icnrU
         gp/R3C/D+FWBYLF8QzdiGSMID3CVCdlMoRjQfqOUHdVXpMCj1OaKmfiWPDOpHZz1YQDE
         UMa4jcnYqp+9pBydFtdJRURgQA0VHaIsx+bE2lgNyh5FVcsqqfxKYXFG4UDufxOa9JQC
         +dRGEdOG6cN9UWscoSOXbAyE0Fr8pw3Txged50rigpp0lVKV/GTggOXVpBV4kBEyIlFJ
         9bFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764182160; x=1764786960;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l+UpyQQXX4ETUL7fz0/4jQ9/53R6ELtNZ9Z4xa9EpMc=;
        b=BOVHFzOyk+LUBrV6+ADYTz0Ulcd3WL1bgXOAQgHIwAI1unWcnZ25BNiNfaKyu4TGyb
         n65kC5d0VAtDCMi1W6bS8QKM3LdonDpEjf/+URrADtGuy1TOHyvmmN9kEeIaqDVEuzSx
         ngOAfHLOzApJtnT7wWYK5Ty9p6L9YwsrpSrtfY22QV59essc8Vm07BOu01u5/9Gn+vQB
         TkD/wuzrCchlH7IWP4LTJC1cjOsVUs28DIyezPagOFDHR4wyWd5dtUmilB+mErr477m7
         Q/nSRfL99LrigVTqv3qyLI5JoiJADNtyPplDTW4kmvnJWywPdikOuLREXYHBqUVU+qiU
         QJkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXI7YS1pJIjhpgST+SLShu9UbYzn7FuZy3CxrlxRPYO4rITF1/kUt0pxMdO7eTwP0dAktkno81AumRdH00=@vger.kernel.org
X-Gm-Message-State: AOJu0Yznb0PePrx1b621nniCUW1lO0+ypZWiK1E+w5e4qeXoduDq7NqC
	/6EHNjDGuyPX5Z/rE+BX8N8E6u+oL4jHHOvGpJEt8+2jkx/WxVvrZBM5
X-Gm-Gg: ASbGnctIKSCQmvPMh3mOvDVjNgi42mMeZ0f2NKybCdd1KJcT8blVQFlZur8AOKmPPk7
	W+MR/sr4b6DxjGSTCur4IaAP6smE/WzbXTBbleCSLkL/FpYMy756+rqPiEQ6Pf5zYVFCF0TRbub
	7DaCaPl4n8Zbm9NKaH3VQ4E1hVlG1gAS+t1PcIWaA2EJGxv0qUtUwJKVZeR3RQvhV+Go6h5fce5
	wVPMc2MhMYZbQgF6Vh5onGn36bHhFejdHWx3JHRKzEPBcKyCP9iYgOunR5vmP4EjOEQohNFEpWm
	moJPhMeAn650/7WqUDVSW7chpykdIe9yC8tgbrJeZsZC+Xma7j8GDbTkPEJdgViepCkimo66k+S
	EMf9XzeAedu945+5uyDrX+INJbujJNEuW3CjXObdJbLSWCuiGN0RmlaMKZZR8Bd+YfehfVCbZWI
	v3uVhPQERtSm1PWNbGqbVeCPk67pW/OFc8uQ==
X-Google-Smtp-Source: AGHT+IEDaKLHkuJUlFxjTNYKXYKXILgs49wv90DIhz+B7Erbl6ou89i0ju5Aozc3Dud2Eq5F+/QLtQ==
X-Received: by 2002:a05:6000:401f:b0:42b:2ac7:7942 with SMTP id ffacd0b85a97d-42e0f1e3433mr8676095f8f.5.1764182159355;
        Wed, 26 Nov 2025 10:35:59 -0800 (PST)
Received: from vitor-nb.Home (bl19-170-125.dsl.telepac.pt. [2.80.170.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fa3a6bsm41766947f8f.28.2025.11.26.10.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 10:35:58 -0800 (PST)
Message-ID: <82e78d56c7df6e1f93de29f9b3a70f7c132603c4.camel@gmail.com>
Subject: Re: CAAM RSA breaks cfg80211 certificate verification on iMX8QXP
From: Vitor Soares <ivitro@gmail.com>
To: Ahmad Fatoum <ahmad@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, imx@lists.linux.dev
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com, 
 herbert@gondor.apana.org.au, john.ernberg@actia.se,
 meenakshi.aggarwal@nxp.com
Date: Wed, 26 Nov 2025 18:35:57 +0000
In-Reply-To: <3d44957f-8c09-47f3-93e0-78a1d34adfd0@kernel.org>
References: <b017b6260075f7ba11c52e71bcc5cebe427e020f.camel@gmail.com>
	 <ac727d79bdd7e20bf390408e4fa4dfeadb4b8732.camel@gmail.com>
	 <3d44957f-8c09-47f3-93e0-78a1d34adfd0@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-11-26 at 13:59 +0100, Ahmad Fatoum wrote:
> Hello Vitor,
>=20
> On 26.11.25 11:55, Vitor Soares wrote:
> > ++imx@lists.linux.dev
> >=20
> > On Mon, 2025-11-24 at 19:03 +0000, Vitor Soares wrote:
> > > I=E2=80=99m currently investigating an issue on our Colibri iMX8QXP S=
oM running
> > > kernel
> > > 6.18-rc6 (also reproducible on v6.17), where cfg80211 fails to load t=
he
> > > compiled-in X.509 certificates used to verify the regulatory database
> > > signature.
> > >=20
> > > During boot, I consistently see the following messages:
> > > =C2=A0cfg80211: Loading compiled-in X.509 certificates for regulatory=
 database
> > > =C2=A0Problem loading in-kernel X.509 certificate (-22)
> > > =C2=A0Problem loading in-kernel X.509 certificate (-22)
> > > =C2=A0cfg80211: loaded regulatory.db is malformed or signature is
> > > missing/invalid
> > >=20
> > > As part of the debugging process, I removed the CAAM crypto drivers a=
nd
> > > manually
> > > reloaded cfg80211. In this configuration, the certificates load corre=
ctly
> > > and
> > > the regulatory database is validated with no errors.
> > >=20
> > > With additional debugging enabled, I traced the failure to
> > > crypto_sig_verify(),
> > > which returns -22 (EINVAL).
> > > At this stage, I=E2=80=99m trying to determine whether:
> > > =C2=A0- This is a known issue involving cfg80211 certificate validati=
on when
> > > the
> > > CAAM
> > > hardware crypto engine is enabled on i.MX SoCs, or
> > > =C2=A0- CAAM may be returning unexpected values to the X.509 verifica=
tion
> > > logic.
> > >=20
> > > If anyone has encountered similar behavior or can suggest areas to
> > > investigate=E2=80=94particularly around CAAM=E2=80=94I would greatly =
appreciate your
> > > guidance.
> > >=20
> > > Thanks in advance for any insights,
> > > V=C3=ADtor Soares
> >=20
> > Following up with additional debugging findings.
> >=20
> > I traced the -EINVAL to rsassa_pkcs1_verify() in the PKCS#1 v1.5
> > verification
> > path. The check that fails expects a leading 0x00 byte in the RSA outpu=
t
> > buffer.
> > To investigate further, I poisoned the output buffer with 0xAA before t=
he
> > RSA
> > operation. CAAM RSA operation returns success, but the output buffer is
> > never
> > written to.
> >=20
> > During debugging, I loaded cfg80211 multiple times and observed that
> > sporadically one of the certificates gets verified correctly, but never
> > both.
> >=20
> > I confirmed that other CAAM operations work correctly by testing hwrng =
via
> > /dev/hwrng, which produces valid random data.
> >=20
> > Given that CAAM reports success but does not populate the RSA output bu=
ffer,
> > the
> > problem appears to be somewhere in the RSA execution flow (possibly in =
how
> > the
> > result buffer is handled or returned), but I don=E2=80=99t have enough =
insight into
> > CAAM's RSA implementation or firmware interaction to pinpoint the exact
> > cause.
> >=20
> > As noted previously, blacklisting caam_pkc to force rsa-generic resolve=
s the
> > issue.
>=20
> Just a shot in the dark, because I have no experience with i.MX8 beyond
> i.MX8M:
>=20
> Is the CAAM cache-coherent on your SoC? If so does the DT specify dma-coh=
erent
> as it should? On i.MX8M, it's not cache-coherent, but on Layerscape it wa=
s and
> the mismatch with the DT leads to symptoms matching what you are observin=
g.
>=20

Thanks for the suggestion. I tested with dma-coherent added to the CAAM and=
 job
ring nodes but the issue persists.
I traced through the DMA path in caampkc.c and confirmed:

- dma_map_sg() is called in rsa_edesc_alloc() with DMA_FROM_DEVICE
- dma_unmap_sg() is called in rsa_io_unmap() from rsa_pub_done() before
completion
- CAAM returns status err=3D0x00000000 (success)
- dst_nents=3D1=20

Yet the output buffer remains untouched (still contains my 0xAA poison patt=
ern).
The kernel DMA handling appears correct. CAAM accepts the job and reports
success, but never writes the RSA result. Given that CAAM reports success b=
ut
does not populate the RSA output buffer, the problem appears to be somewher=
e in
the RSA execution flow (possibly in how the result buffer is handled or
returned), but I don't have enough insight into CAAM's RSA implementation.

> Off-topic remark: If you have performance comparison between running with=
 and
> without CAAM RSA acceleration, I'd be interested to hear about them.
> At least for the hashing algorithms, using the Cortex-A53 (+ CE) CPU was =
a lot
> faster than bothering with the CAAM "acceleration".
>=20

I haven't done a kernel-level CAAM vs software RSA comparison, but OpenSSL =
with
ARM Crypto Extensions shows ~3100 verify ops/sec and ~80 sign ops/sec for R=
SA
2048 on the Cortex-A35.

Regards,
V=C3=ADtor


