Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A1AF4E2
	for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 13:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LBsKTuZV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703339930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ml8loPAoHCaUTkjCCP35WEEpNUNzN3KpRtiyrHAoqRM=;
	b=LBsKTuZVSBHuYSv2iY9UO3V+jcv8pmW9IabOvXA4Z+pfGieNo3UZCsHdxlc08OaXhWYafT
	C0oc5vSGs0G5I6d5eATkpKaiIN5QGxKFa0x1hcveMFQZJ9NYlHZMu40mLdnQsAoq9FnaBl
	UNO4bWaJH7aLODKxVctrvd5JDT/d988=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-LxyGYJwrOsKreKO3Elrwrw-1; Sat, 23 Dec 2023 08:58:49 -0500
X-MC-Unique: LxyGYJwrOsKreKO3Elrwrw-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-59436f69e8cso2042945eaf.0
        for <linux-crypto@vger.kernel.org>; Sat, 23 Dec 2023 05:58:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703339928; x=1703944728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ml8loPAoHCaUTkjCCP35WEEpNUNzN3KpRtiyrHAoqRM=;
        b=iOlhranwLA0Kzmlew3hGYu72HpZW6zhpDkm+FvO/CfHxsyajnTgPaT7Zsl53PSdNPH
         wEqjQ6NlRmsq7KjzXIMgvKMhL0+Z48oAfqPRiqu7ikc0zbbP5VomLOcESTwO6BDQcOz+
         P72GsEMI1L/YMz0QoAyYruAoKL8cQLGoxyDSvW7d5fgnieQ/nRF61iRGk+2aYAj02QJR
         mL/tnDY/4Io2oSxxfrtbjPMTpfHMABnh3A+c1MZpvKTV2FdEV2IgwGkCYsQgILaqDIrH
         x+rmfQ/IV5obPTigOCIjxhV3G4TMnilWQhrLZug5nOrymezCyejP0vqZt6Rta7cFcwqX
         X3cA==
X-Gm-Message-State: AOJu0YyCktgnPrqK51uWunLtiuB/pmZtuOuFEbnDqDwCf3Sad92kFAN/
	ym3HE5V0LeY6+TQRQrPbwbKNtcsMaLhf2E02ds8d8nykvHxZsHF67/rbOdvZ+E+5L+nBMrd4PDy
	dSmIqLg9zUzAKg9ebPlv62ZbbkcqkuTLrKZshj8YKdIJf9/+Y
X-Received: by 2002:a05:6359:1a46:b0:170:b476:d962 with SMTP id ru6-20020a0563591a4600b00170b476d962mr2415976rwb.20.1703339928391;
        Sat, 23 Dec 2023 05:58:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHRD3CtDp5xH12+RxaNKEcmbP3iA3iiji2uVgtBeeOVQnJ9rdmrwcyMpvVCHdUuXELACtx1tGK/qJZyLO0bv0Q=
X-Received: by 2002:a05:6359:1a46:b0:170:b476:d962 with SMTP id
 ru6-20020a0563591a4600b00170b476d962mr2415966rwb.20.1703339928020; Sat, 23
 Dec 2023 05:58:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZYT/beBEO7dAlVO2@gondor.apana.org.au> <AM0PR04MB6004FDAC2B2C0B4D41A92A89E794A@AM0PR04MB6004.eurprd04.prod.outlook.com>
In-Reply-To: <AM0PR04MB6004FDAC2B2C0B4D41A92A89E794A@AM0PR04MB6004.eurprd04.prod.outlook.com>
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Sat, 23 Dec 2023 14:58:36 +0100
Message-ID: <CAFqZXNtb1hErawH30dN4vgGPD0tQv9Rd+9s26MBaT3boRYtPCA@mail.gmail.com>
Subject: Re: [EXT] caam test failures with libkcapi
To: Gaurav Jain <gaurav.jain@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Horia Geanta <horia.geanta@nxp.com>, 
	Pankaj Gupta <pankaj.gupta@nxp.com>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 22, 2023 at 11:50=E2=80=AFAM Gaurav Jain <gaurav.jain@nxp.com> =
wrote:
>
> Hi Herbert
>
> tcrypt tests are passing with kernel crypto CAAM driver.

Is that also with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy ? (We didn't
test that, but we suspect it may be able to trigger the issue.)

> Can you please share the logs for libkcapi test failures.

A log from our kernel CI testing is available here (it is from CentOS
Stream 9, but it fails in the same way on the Fedora's 6.6.6-based
kernel):
https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/1=
109180874/test_aarch64/5766414724/artifacts/run.done.03/job.01/recipes/1519=
4733/tasks/31/logs/taskout.log

You should be able to reproduce it on your machine easily:
1. dnf install -y git-core gcc autoconf automake libtool (or an
equivalent for your distribution)
2. git clone https://github.com/smuellerDD/libkcapi/
3. cd libkcapi/
4. autoreconf -i
5. cd test/
6. ./test-invocation.sh

>
> Regards
> Gaurav Jain
>
> > -----Original Message-----
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Sent: Friday, December 22, 2023 8:46 AM
> > To: Horia Geanta <horia.geanta@nxp.com>; Gaurav Jain
> > <gaurav.jain@nxp.com>; Pankaj Gupta <pankaj.gupta@nxp.com>; Linux Crypt=
o
> > Mailing List <linux-crypto@vger.kernel.org>
> > Cc: Ondrej Mosnacek <omosnace@redhat.com>
> > Subject: [EXT] caam test failures with libkcapi
> >
> > Caution: This is an external email. Please take care when clicking link=
s or
> > opening attachments. When in doubt, report the message using the 'Repor=
t this
> > email' button
> >
> >
> > Hi:
> >
> > It's been brought to my attention that the caam driver fails with libkc=
api test
> > suite:
> >
> >
> > https://github.co/
> > m%2FsmuellerDD%2Flibkcapi%2F&data=3D05%7C02%7Cgaurav.jain%40nxp.com%
> > 7C3dad774d29404c40164908dc029c4da1%7C686ea1d3bc2b4c6fa92cd99c5c30
> > 1635%7C0%7C0%7C638388117546628060%7CUnknown%7CTWFpbGZsb3d8eyJ
> > WIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C
> > 3000%7C%7C%7C&sdata=3DaQ2MLvyfioDjh8a1c600f8A5sTMSlaPSckg8QY6RpVs%
> > 3D&reserved=3D0
> >
> > Can you please have a look into this? It would also be useful to get so=
me
> > confirmation that caam still passes the extra fuzzing tests.
> >
> > Thanks,
> > --
> > Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> > http://gondor.ap/
> > ana.org.au%2F~herbert%2F&data=3D05%7C02%7Cgaurav.jain%40nxp.com%7C3d
> > ad774d29404c40164908dc029c4da1%7C686ea1d3bc2b4c6fa92cd99c5c301635
> > %7C0%7C0%7C638388117546784331%7CUnknown%7CTWFpbGZsb3d8eyJWIjoi
> > MC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000
> > %7C%7C%7C&sdata=3D9YTdCRpZOzKmkYlMKhGvBkuvVG9tmg%2FQ4Y1VnLuVGCg
> > %3D&reserved=3D0
> > PGP Key:
> > http://gondor.ap/
> > ana.org.au%2F~herbert%2Fpubkey.txt&data=3D05%7C02%7Cgaurav.jain%40nxp.c
> > om%7C3dad774d29404c40164908dc029c4da1%7C686ea1d3bc2b4c6fa92cd99c
> > 5c301635%7C0%7C0%7C638388117546784331%7CUnknown%7CTWFpbGZsb3d
> > 8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D
> > %7C3000%7C%7C%7C&sdata=3Djf80tCyfL65DjtCqNfX%2BYnEKIC%2FG8PL63LiZyP
> > GGgdk%3D&reserved=3D0
>


--
Ondrej Mosnacek
Senior Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

