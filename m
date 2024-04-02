Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4293D3BD
	for <linux-crypto@vger.kernel.org>; Tue,  2 Apr 2024 08:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712045281; cv=none; b=H+YNgok2aH8f3S1GTrgodVWHpV2er6Bkm37Kg0lrOix+0+d6UtpxhisWdS5FwePMBIPiBMaKOf3YxdN15hP1jeFDuR/jBolOYJAADIAEmVzZOvVEi7JAnLzPbYeRp+XXoG4ZvOCAcPA6Gk1OQ3wGlOB8JbqKwA2zlxPfju/aUzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712045281; c=relaxed/simple;
	bh=cXgGVUNQnsE+Ujww0696zbcLQrrmpRABWERrZBk4cW8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IN1T85ioRBXHs5rJDIMjWToOnLf0r64DfDO1LSNt23raZmCI6e32WhzkjhYquWLdhZr88CiLTne6Pj4cVbu9kAWi53ofgEYtc9Q0BeZPn0wn0zTNUBD/Zq5vLhuOUVjoFoRP8EqDhczE6bF0/xTfm6X8sN6YPdFlOiLLu++s4Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JxROgAI2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JxROgAI2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712045278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JoFIDsqHrKObELq0jSEditr7BMIC5fqGv2oe/il9p1s=;
	b=JxROgAI2TaH5SClmV5huZ+FxCgEr/lAbdn+iaKVUg95PKMr8e/fMClJ/x3m0eORqkKngex
	tXDYNzzlwX+WiputDHTzz+9qE85qdfU8+z7eNQM9HucaBgXZ0HSJ6Mo9HPh7cVpV3azVNI
	0LJFpvg/FTlzw++8N+YzH4BC7YRxTSw=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-q2qKyElwMi2UHLmep1tSQA-1; Tue, 02 Apr 2024 04:07:55 -0400
X-MC-Unique: q2qKyElwMi2UHLmep1tSQA-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3c4ed46350fso856524b6e.2
        for <linux-crypto@vger.kernel.org>; Tue, 02 Apr 2024 01:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712045274; x=1712650074;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JoFIDsqHrKObELq0jSEditr7BMIC5fqGv2oe/il9p1s=;
        b=KOVBb3yj+o9fOL+4ctloyZRjuAbxtdEWAgosqUC0RxYviF4CU9+JWW9jozg96x5eLb
         n+hyX+2ap3wqYafbQoCZwqdBjR6fNAcOxbPD1GqRfhwmQYRlCB/jGzCQbtUNAvXbF9MQ
         qt6rsqM/u7xdcJVTz2A1T0lfCTivFAeFWrMJ/6bOfke4DUSZpj9z5bI8m2d2TtIBREIv
         HXF9CLSf5skv7PZ4uNV/EV2wCxpSOiV5L5AxYzO2aplg+79ByMMIgF3CuoAsrnWqII+T
         kZQUhfXSwNLqxnD5lp0BrL+0BezTJVDlYVj49UFhZFc1myGAoNa3aSsPUvAJo0tJX4pu
         5YNw==
X-Forwarded-Encrypted: i=1; AJvYcCWxuuAD99gEInBIHp02QCpjDl5X8PXORAlYKp/BhbIquabWI8tWSBpAF2GmbTteeiGeKA+MLwBMFPHi6wIptIBP53ltekGFPzbA+YlP
X-Gm-Message-State: AOJu0YykQYVi2BQoGldTWcXpE94QUdio9uRDQB6IeHjvLXmZg3ELQbbL
	7JUPAP9uNAGCawk5OgrNqD/MnKgK17hH7HPTCvxgwkUnVL7w4SRXW4LMCsLULslkSBRZS7uSa8w
	fWQcycYtpbwyLWsZYwlgOR8O+gtd64veCWKQWQIuUQ5k+daFWPI5Wder0TZe+6S6jqhvsLn1NQb
	MiEk2PuIm+xuIh02XfJiBOU/DY8gpVv+MLct7/hkJ+D8T75nc=
X-Received: by 2002:a05:6808:120e:b0:3c3:dfec:d9ee with SMTP id a14-20020a056808120e00b003c3dfecd9eemr13027918oil.32.1712045274672;
        Tue, 02 Apr 2024 01:07:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgU/W2Po5ga/DbPrfrZWhW/eCABU8ASAlqZGBbaFqX3tu9DHkD0cVewqmhjybHg3hlKVkIsF9RRhsE6QuTCQ0=
X-Received: by 2002:a17:903:2cb:b0:1e0:b2d5:5f46 with SMTP id
 s11-20020a17090302cb00b001e0b2d55f46mr11786625plk.46.1712044823630; Tue, 02
 Apr 2024 01:00:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZYT/beBEO7dAlVO2@gondor.apana.org.au> <AM0PR04MB6004FDAC2B2C0B4D41A92A89E794A@AM0PR04MB6004.eurprd04.prod.outlook.com>
 <CAFqZXNtb1hErawH30dN4vgGPD0tQv9Rd+9s26MBaT3boRYtPCA@mail.gmail.com>
 <AM0PR04MB6004F095D6800C4BC99E5C4FE760A@AM0PR04MB6004.eurprd04.prod.outlook.com>
 <CAFqZXNs-QzXFm+cLN62LrpPjb_R3DqJHgM_yjrOkzen8LEgS9A@mail.gmail.com> <AM0PR04MB6004DD14719CD56D86DB32CEE73E2@AM0PR04MB6004.eurprd04.prod.outlook.com>
In-Reply-To: <AM0PR04MB6004DD14719CD56D86DB32CEE73E2@AM0PR04MB6004.eurprd04.prod.outlook.com>
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Tue, 2 Apr 2024 10:00:12 +0200
Message-ID: <CAFqZXNsOZNzRv=2N1Y1LvDPESF=Uvh_YLkTOiZqqLb8v7Rg+GQ@mail.gmail.com>
Subject: Re: [EXT] caam test failures with libkcapi
To: Gaurav Jain <gaurav.jain@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Horia Geanta <horia.geanta@nxp.com>, 
	Pankaj Gupta <pankaj.gupta@nxp.com>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Varun Sethi <V.Sethi@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 2, 2024 at 9:03=E2=80=AFAM Gaurav Jain <gaurav.jain@nxp.com> wr=
ote:
>
> Hi
>
> > -----Original Message-----
> > From: Ondrej Mosnacek <omosnace@redhat.com>
> > Sent: Thursday, January 4, 2024 2:07 PM
> > To: Gaurav Jain <gaurav.jain@nxp.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>; Horia Geanta
> > <horia.geanta@nxp.com>; Pankaj Gupta <pankaj.gupta@nxp.com>; Linux Cryp=
to
> > Mailing List <linux-crypto@vger.kernel.org>; Varun Sethi <V.Sethi@nxp.c=
om>
> > Subject: Re: [EXT] caam test failures with libkcapi
> >
> > Caution: This is an external email. Please take care when clicking link=
s or opening
> > attachments. When in doubt, report the message using the 'Report this e=
mail'
> > button
> >
> >
> > On Wed, Jan 3, 2024 at 12:50=E2=80=AFPM Gaurav Jain <gaurav.jain@nxp.co=
m> wrote:
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: Ondrej Mosnacek <omosnace@redhat.com>
> > > > Sent: Saturday, December 23, 2023 7:29 PM
> > > > To: Gaurav Jain <gaurav.jain@nxp.com>
> > > > Cc: Herbert Xu <herbert@gondor.apana.org.au>; Horia Geanta
> > > > <horia.geanta@nxp.com>; Pankaj Gupta <pankaj.gupta@nxp.com>; Linux
> > > > Crypto Mailing List <linux-crypto@vger.kernel.org>
> > > > Subject: Re: [EXT] caam test failures with libkcapi
> > > >
> > > > Caution: This is an external email. Please take care when clicking
> > > > links or opening attachments. When in doubt, report the message
> > > > using the 'Report this email' button
> > > >
> > > >
> > > > On Fri, Dec 22, 2023 at 11:50=E2=80=AFAM Gaurav Jain <gaurav.jain@n=
xp.com> wrote:
> > [...]
> > > > > Can you please share the logs for libkcapi test failures.
> > > >
> > > > A log from our kernel CI testing is available here (it is from
> > > > CentOS Stream 9, but it fails in the same way on the Fedora's
> > > > 6.6.6-based
> > > > kernel):
> > > > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2=
Fs3
> > > > .amaz%2F&data=3D05%7C02%7Cgaurav.jain%40nxp.com%7Cb05dbbf9c0d848a
> > f5bef
> > > >
> > 08dc0d006b59%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C638399
> > 5426
> > > >
> > 48069426%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2l
> > uMzI
> > > >
> > iLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=3DykpF%2BM%
> > 2BDWj
> > > > w6GHN6165kLe7c8WFRJSSLTfWd%2FqLxI9w%3D&reserved=3D0
> > > > onaws.com%2Farr-cki-prod-trusted-artifacts%2Ftrusted-
> > > >
> > artifacts%2F1109180874%2Ftest_aarch64%2F5766414724%2Fartifacts%2Frun
> > > > .d
> > > >
> > one.03%2Fjob.01%2Frecipes%2F15194733%2Ftasks%2F31%2Flogs%2Ftaskout.l
> > > >
> > og&data=3D05%7C02%7Cgaurav.jain%40nxp.com%7C3b52a83449bf4b3fffe208dc
> > > >
> > 03bf4b66%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C6383893673
> > > >
> > 38072709%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2l
> > > >
> > uMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=3D9SCFiT
> > > > 1nNsTZg4bh6n75CeicDC51Jw3wacQCaL7w4vQ%3D&reserved=3D0
> > >
> > > In this log I cannot see CAAM failures. can you tell which CAAM tfm f=
ailed?
> >
> > The test exercises the kernel crypto API via the AF_ALG interface. The =
failures
> > basically detect that for certain inputs the crypto API returns differe=
nt results
> > than expected when the CAAM driver is used (the machine in question has=
 the
> > relevant hardware, so the caam_jr crypto drivers are registered for cer=
tain
> > algorithms and they take priority).
> >
> > For example, when you install libkcapi-tools and run:
> >
> > kcapi -x 2 -s  -e -c "gcm(aes)" -i 16c4b4bd1198f39f4ae817b7 \
> >     -k 87c91a8b63f66934dd3703415b2538461fbfef55ce7a9ca9bb9425499f4cd1d6
> > \
> >     -a
> > "303bb57e4534b08a4d5f001a84b3052c9d0d58ee03eda5211a540950e819dc" \
> >     -p "b05fbd403c2fa41a8cc702a7474ed9ba6c50fcc6c19732a7d300f1113862bc"
> > -l 4
> >
> > ...the caam_jr implementation results in
> > b05fbd403c2fa41a8cc702a7474ed9ba6c50fcc6c19732a7d300f1113862bc6d275
> > 6d6,
> > while the expected output is
> > 9bea5263e7b365d5a06cb3ccab0d43cb9a1ca967dfb7b1a6955b3c493018af6d275
> > 6d6.
> > You can search the test log for "FAILED" to find the other failing comm=
ands (note
> > that in some cases you need to escape the -c argument as it contains
> > parentheses).
>
> We have developed an application to run the gcm(aes) algorithm which is o=
ffloaded to caam_jr driver via AF_ALG interface.
> we have used the below test vector
> Plaintext is "b05fbd403c2fa41a8cc702a7474ed9ba6c50fcc6c19732a7d300f111386=
2bc" -> 31 byte
> Key is "87c91a8b63f66934dd3703415b2538461fbfef55ce7a9ca9bb9425499f4cd1d6"=
 -> 32 byte
> Iv is "16c4b4bd1198f39f4ae817b7" -> 12 byte
> Aad is "303bb57e4534b08a4d5f001a84b3052c9d0d58ee03eda5211a540950e819dc" -=
> 31 byte
>
> Our application results matches the expected ciphertext which is "9bea526=
3e7b365d5a06cb3ccab0d43cb9a1ca967dfb7b1a6955b3c493018af6d2756d6".
> I can see the expected output at your end is basically the plaintext appe=
nded by authentication tag of 4 bytes "6d2756d6".
> caam_jr driver aes-gcm implementation is providing the correct output.

How does your application invoke AF_ALG exactly? The libkcapi test
program invokes it in various different ways (to try to discover bugs)
and only some of them fail. In this case the key seems to be to send
the AAD and plaintext separately. This is what an strace of the
failing invocation looks like:

socket(AF_ALG, SOCK_SEQPACKET, 0)       =3D 3
bind(3, {sa_family=3DAF_ALG, salg_type=3D"aead", salg_feat=3D0, salg_mask=
=3D0,
salg_name=3D"gcm(aes)"}, 88) =3D 0
pipe2([4, 5], 0)                        =3D 0
fcntl(4, F_SETPIPE_SZ, 69632)           =3D 131072
fcntl(5, F_SETPIPE_SZ, 69632)           =3D 131072
setsockopt(3, SOL_ALG, ALG_SET_AEAD_AUTHSIZE, NULL, 4) =3D 0
setsockopt(3, SOL_ALG, ALG_SET_KEY,
"\207\311\32\213c\366i4\3357\3A[%8F\37\277\357U\316z\234\251\273\224%I\237L=
\321\326",
32) =3D 0
accept(3, NULL, NULL)                   =3D 6
sendmsg(6, {msg_name=3DNULL, msg_namelen=3D0, msg_iov=3DNULL, msg_iovlen=3D=
0,
msg_control=3D[{cmsg_len=3D20, cmsg_level=3DSOL_ALG, cmsg_type=3D0x3,
cmsg_data=3D"\x01\x00\x00\x00"}, {cmsg_len=3D32, cmsg_level=3DSOL_ALG,
cmsg_type=3D0x2, cmsg_data=3D"\x0c\x00\x00\x00\x16\xc4\xb4\xbd\x11\x98\xf3\=
x9f\x4a\xe8\x17\xb7"},
{cmsg_len=3D20, cmsg_level=3DSOL_ALG, cmsg_type=3D0x4,
cmsg_data=3D"\x1f\x00\x00\x00"}], msg_controllen=3D80, msg_flags=3D0},
MSG_MORE) =3D 0
vmsplice(5, [{iov_base=3D"0;\265~E4\260\212M_\0\32\204\263\5,\235\rX\356\3\=
355\245!\32T\tP\350\31\334",
iov_len=3D31}], 1, SPLICE_F_MORE|SPLICE_F_GIFT) =3D 31
splice(4, NULL, 6, NULL, 31, SPLICE_F_MORE) =3D 31
vmsplice(5, [{iov_base=3D"\260_\275@</\244\32\214\307\2\247GN\331\272lP\374=
\306\301\2272\247\323\0\361\218b\274",
iov_len=3D31}], 1, SPLICE_F_GIFT) =3D 31
splice(4, NULL, 6, NULL, 31, 0)         =3D 31
recvmsg(6, {msg_name=3DNULL, msg_namelen=3D0, msg_iov=3D[{iov_base=3D"0",
iov_len=3D1}, {iov_base=3D";", iov_len=3D1}, {iov_base=3D"\265", iov_len=3D=
1},
{iov_base=3D"~", iov_len=3D1}, {iov_base=3D"E", iov_len=3D1}, {iov_base=3D"=
4",
iov_len=3D1}, {iov_base=3D"\260", iov_len=3D1}, {iov_base=3D"\212",
iov_len=3D1}, {iov_base=3D"M", iov_len=3D1}, {iov_base=3D"_", iov_len=3D1},
{iov_base=3D"\0", iov_len=3D1}, {iov_base=3D"\32", iov_len=3D1},
{iov_base=3D"\204", iov_len=3D1}, {iov_base=3D"\263", iov_len=3D1},
{iov_base=3D"\5,\235\rX\356\3\355\245!\32T\tP\350\31\334\233\352Rc\347\263e=
\325\240l\263\314\253\rC"...,
iov_len=3D48}, {iov_base=3D"m'V\326", iov_len=3D4}], msg_iovlen=3D16,
msg_controllen=3D0, msg_flags=3D0}, 0) =3D 66
newfstatat(1, "", {st_mode=3DS_IFCHR|0600, st_rdev=3Dmakedev(0x88, 0x12),
...}, AT_EMPTY_PATH) =3D 0
write(1, "9bea5263e7b365d5a06cb3ccab0d43cb"..., 71) =3D 71
close(6)                                =3D 0
close(4)                                =3D 0
close(5)                                =3D 0
close(3)                                =3D 0

(This is from a non-caam run on my machine, but the invocation should
be the same, only the results differ.)

--=20
Ondrej Mosnacek
Senior Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

