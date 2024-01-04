Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC041DDC0
	for <linux-crypto@vger.kernel.org>; Thu,  4 Jan 2024 08:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gp0tBZip"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704357462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r4yMLTOTY18ZlQprKfKUPd3eMKBDwxlWLfpj9q5SGZk=;
	b=Gp0tBZipDsTcG5z0rcLrdgwwZxK7F+/Vpdpe8aeWN/RlhYc/Ul3FAf+AAH1fUrSkeFmkjo
	aj2nt4nNkn5eQUcqOFk6FSJfObVOMGM1Axjtm7k5grnlwK6UH0mSuJ6d9ekTLdOQQMjoio
	Gu0k0eFu3WzmB3oZVWvtMd0hf8etITA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-qycUCcWpMKq8cMdiFuLEOQ-1; Thu, 04 Jan 2024 03:37:40 -0500
X-MC-Unique: qycUCcWpMKq8cMdiFuLEOQ-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-28cc1128ebfso283287a91.3
        for <linux-crypto@vger.kernel.org>; Thu, 04 Jan 2024 00:37:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704357459; x=1704962259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r4yMLTOTY18ZlQprKfKUPd3eMKBDwxlWLfpj9q5SGZk=;
        b=px1CWpEb/fh7eT/cMwOknjEV2/HdKQNiFGqRv4PdbMETVER9w9e9hWgjoQGfbPQMBX
         c61E/ygfpPLcYuS4qxSRSIg4cTJDaMaqnQuG0vsWdfy3DUJE4e6WaTO22RAq4gOitRwA
         rQs/dwWXCpIP1tQT+L2tkaiP1D/3UPjrev+qPFiI97eBtQwVehGYueo+E3Sn1aZ6MG75
         isAzs/NdIeDFXdW41wdT4EbrI0F3gXkj3aXeio92Tvs8AFEGq2HWwbA0cSpD4GzS4WLx
         4w19qS6/0W4a13gCix50DiBEVKaefEyaiwCKJiV6B96Q9VAgnpFn+8SGWRk3pTucuGyQ
         uJug==
X-Gm-Message-State: AOJu0YwN31pT5ytRrf8BchTOePGn1H1YIxtHWO+rby+7pnDKhPH7Kvo8
	EnAZA1AKRY2HENoV51WNrPtrMvNCyfnKu4XfRzkbJTeN7znY5vy+VW/kUGzKV5hWsPwrdGcRlj4
	ikyjgQINPahHscbm7+ScCAdoyj+ulWdk0pGobxirCix0gP3Nu
X-Received: by 2002:a17:90a:98d:b0:28b:dd93:a2ee with SMTP id 13-20020a17090a098d00b0028bdd93a2eemr258985pjo.95.1704357459672;
        Thu, 04 Jan 2024 00:37:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCdQEWGQrQ4xm5hLFsMfTv5mouiYJ9JNARw8RqplKfPW5owtuRQP+ob8vEBHzT3rV+OrS0pXTAbtJ6S2POjR0=
X-Received: by 2002:a17:90a:98d:b0:28b:dd93:a2ee with SMTP id
 13-20020a17090a098d00b0028bdd93a2eemr258980pjo.95.1704357459417; Thu, 04 Jan
 2024 00:37:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZYT/beBEO7dAlVO2@gondor.apana.org.au> <AM0PR04MB6004FDAC2B2C0B4D41A92A89E794A@AM0PR04MB6004.eurprd04.prod.outlook.com>
 <CAFqZXNtb1hErawH30dN4vgGPD0tQv9Rd+9s26MBaT3boRYtPCA@mail.gmail.com> <AM0PR04MB6004F095D6800C4BC99E5C4FE760A@AM0PR04MB6004.eurprd04.prod.outlook.com>
In-Reply-To: <AM0PR04MB6004F095D6800C4BC99E5C4FE760A@AM0PR04MB6004.eurprd04.prod.outlook.com>
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Thu, 4 Jan 2024 09:37:28 +0100
Message-ID: <CAFqZXNs-QzXFm+cLN62LrpPjb_R3DqJHgM_yjrOkzen8LEgS9A@mail.gmail.com>
Subject: Re: [EXT] caam test failures with libkcapi
To: Gaurav Jain <gaurav.jain@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Horia Geanta <horia.geanta@nxp.com>, 
	Pankaj Gupta <pankaj.gupta@nxp.com>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Varun Sethi <V.Sethi@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 3, 2024 at 12:50=E2=80=AFPM Gaurav Jain <gaurav.jain@nxp.com> w=
rote:
>
>
>
> > -----Original Message-----
> > From: Ondrej Mosnacek <omosnace@redhat.com>
> > Sent: Saturday, December 23, 2023 7:29 PM
> > To: Gaurav Jain <gaurav.jain@nxp.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>; Horia Geanta
> > <horia.geanta@nxp.com>; Pankaj Gupta <pankaj.gupta@nxp.com>; Linux
> > Crypto Mailing List <linux-crypto@vger.kernel.org>
> > Subject: Re: [EXT] caam test failures with libkcapi
> >
> > Caution: This is an external email. Please take care when clicking link=
s or
> > opening attachments. When in doubt, report the message using the 'Repor=
t this
> > email' button
> >
> >
> > On Fri, Dec 22, 2023 at 11:50=E2=80=AFAM Gaurav Jain <gaurav.jain@nxp.c=
om> wrote:
[...]
> > > Can you please share the logs for libkcapi test failures.
> >
> > A log from our kernel CI testing is available here (it is from CentOS S=
tream 9, but
> > it fails in the same way on the Fedora's 6.6.6-based
> > kernel):
> > https://s3.amaz/
> > onaws.com%2Farr-cki-prod-trusted-artifacts%2Ftrusted-
> > artifacts%2F1109180874%2Ftest_aarch64%2F5766414724%2Fartifacts%2Frun.d
> > one.03%2Fjob.01%2Frecipes%2F15194733%2Ftasks%2F31%2Flogs%2Ftaskout.l
> > og&data=3D05%7C02%7Cgaurav.jain%40nxp.com%7C3b52a83449bf4b3fffe208dc
> > 03bf4b66%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C6383893673
> > 38072709%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2l
> > uMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=3D9SCFiT
> > 1nNsTZg4bh6n75CeicDC51Jw3wacQCaL7w4vQ%3D&reserved=3D0
>
> In this log I cannot see CAAM failures. can you tell which CAAM tfm faile=
d?

The test exercises the kernel crypto API via the AF_ALG interface. The
failures basically detect that for certain inputs the crypto API
returns different results than expected when the CAAM driver is used
(the machine in question has the relevant hardware, so the caam_jr
crypto drivers are registered for certain algorithms and they take
priority).

For example, when you install libkcapi-tools and run:

kcapi -x 2 -s  -e -c "gcm(aes)" -i 16c4b4bd1198f39f4ae817b7 \
    -k 87c91a8b63f66934dd3703415b2538461fbfef55ce7a9ca9bb9425499f4cd1d6 \
    -a "303bb57e4534b08a4d5f001a84b3052c9d0d58ee03eda5211a540950e819dc" \
    -p "b05fbd403c2fa41a8cc702a7474ed9ba6c50fcc6c19732a7d300f1113862bc" -l =
4

...the caam_jr implementation results in
b05fbd403c2fa41a8cc702a7474ed9ba6c50fcc6c19732a7d300f1113862bc6d2756d6,
while the expected output is
9bea5263e7b365d5a06cb3ccab0d43cb9a1ca967dfb7b1a6955b3c493018af6d2756d6.
You can search the test log for "FAILED" to find the other failing
commands (note that in some cases you need to escape the -c argument
as it contains parentheses).

--
Ondrej Mosnacek
Senior Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

