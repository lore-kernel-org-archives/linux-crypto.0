Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0B330BF59
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 13:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758202673; cv=none; b=rJn53B06xgU/eO4R1NsllHI9wRH4oG6wOkszB2N6SDLVTjcbWul1gf+7g2naHrt53cpYYzUiYVUeeP3jK09afnteaAoMEovoxfb9MayZSSH7mMVH/riZX+ZqAIggxwE92R7DrxYxgs+W4rigdi5LNS+ZvJaqK3JrLXjSiKGviwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758202673; c=relaxed/simple;
	bh=n8wqbNC7TwNoaaYef6EcHWdcxxI5L83jQK5vBDzFaRY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jmqZR6LjheyqnXldPs70NGMojDA1q+OU37mCYg+LIHpKuTyJ1SfwXg0a3F9yRzz8gqSh2cE/Yi2JZLOu6Fzf7SNEgW/AV5HdzmVkrIrqByNvmdkD4KIO5EP1E9cykT4ugeLEw8ohLkoGaxAM0jeKHNDIt1Zf03q3hbQVAy46QwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HAoFsEkh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HAoFsEkh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758202670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZqDcLlQhQfJNiTTliZvIXGDLjpV1JlcwODn1aQ5tYuc=;
	b=HAoFsEkhr1kf7z3aBEjJrx8PR3vEnFz6ouJF56ssy5OcAWaeCgvN9q+HkDsjTIFZPJs3KF
	7EsdGoaj7p9e2wtTiA9K6rjQ1FLiOE65Z5pNrRBAXBtJdUMqzzz6VQMah5gXczdDp64TK8
	uVbRIZwEbpZRLjIAxHiqnjvmAu5PgM0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290-H9H7mfgBMEK9m8NvJv5X0Q-1; Thu, 18 Sep 2025 09:37:47 -0400
X-MC-Unique: H9H7mfgBMEK9m8NvJv5X0Q-1
X-Mimecast-MFC-AGG-ID: H9H7mfgBMEK9m8NvJv5X0Q_1758202667
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4b5e178be7eso25526811cf.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 06:37:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758202667; x=1758807467;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZqDcLlQhQfJNiTTliZvIXGDLjpV1JlcwODn1aQ5tYuc=;
        b=KW/78MDVFbuSDcJ6dYGWIykbT6gqE9pUvNlh/NHD58ppd7H31pDjuwgZR9BoCWRwkr
         6814z9NG8+aTSAgIRmLLUN235+diYv9s1dFQGpUPgCygpH2f3+XiJDrm2X8+pKazMkqI
         qaDDe19iZpgiP8edoQn4rmpz/HkmhcCsKZ5GIIgmFP/6BL9CNw00RoWB3iT5X7YNsr6X
         AoijaenkI6bjC4FUHZzK3ZJAAMeoNuovIS2n5IQytEMoxRCBLY/h8iCnJr0ftHVJVHt7
         qjf6yb76wCYrAfFvI5/sfS/Rv5ddYf1Tv5O1KvU/EGwZFF7q1lDpOzAUWLFDmjXtF9B8
         Ml4g==
X-Forwarded-Encrypted: i=1; AJvYcCXzMs6rkZg1PNETGUsekNWvd1GVO3uuf7QNkIZQTjYw0kwMTdZ/RcnbHpTgTyahxBtm1FO9SUlqtMgynEA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyikwYteT6UwoN3mTYEuL6q0ftSVNC5bSSGrgqQ+ZlPSHsW1XiS
	ovVJM+n/EmPVJe8VWqlI8fgUcx5Vq1exfuBjHPK3bzqxwMSoBp99XO0nWRRV/VZzX4LEKRCK5wD
	tUNMKAp1hBt2L5F3Uxl3GG9SQUlUzgP+4poAGSwPVwwqbMr5TIzhWwYVQhxlhxR3oYg==
X-Gm-Gg: ASbGnctzvUmgBxDX2VSaxRo0t8NDDox6TgDNTKeL6hDdXyCNErdcMZYkCBnjkMjB3Tz
	krtv+e8+5Y43vMAWr/vs/ULzoYzdw6pQJTcjFPek/YH/YTJBtIEqJoDNA3wvz0hjm6zXotNzwdS
	/CCufm+ccnLgrLIjitquUurSuPPfcs9yha6qav7cwTwNTe278A0XvnW3VcZEst06REc1KXC0icG
	alibLOphlhRFFaGmETkqtaf45m7XmDkXYOYCR8AM8ch9nuTbHaZMMOaMry1K2kQCv6Voqmccn5O
	KUSU4O6q2F2VsDr5oWB47P8W28dJRtHPBg==
X-Received: by 2002:a05:622a:4e06:b0:4b7:9d73:ec9e with SMTP id d75a77b69052e-4ba6cc7b60bmr64962981cf.48.1758202666906;
        Thu, 18 Sep 2025 06:37:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbOzpfb3wIp9mITkdpWB22BggbSF+qbj7ZEUrtdgXipVXipJcb507G8SRye7bkQiyRSb+j9Q==
X-Received: by 2002:a05:622a:4e06:b0:4b7:9d73:ec9e with SMTP id d75a77b69052e-4ba6cc7b60bmr64962511cf.48.1758202666234;
        Thu, 18 Sep 2025 06:37:46 -0700 (PDT)
Received: from m8.users.ipa.redhat.com ([2603:7000:9400:fe80::318])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4bda943c27bsm13747021cf.40.2025.09.18.06.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 06:37:45 -0700 (PDT)
Message-ID: <635d76553b73a2b004a447dcc7d680e0658689c9.camel@redhat.com>
Subject: Re: SHAKE256 support
From: Simo Sorce <simo@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>, Joachim Vandersmissen <git@jvdsn.com>
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org
Date: Thu, 18 Sep 2025 09:37:45 -0400
In-Reply-To: <20250918041702.GA12019@quark>
References: <20250915220727.GA286751@quark>
	 <2767539.1757969506@warthog.procyon.org.uk>
	 <2768235.1757970013@warthog.procyon.org.uk>
	 <3226361.1758126043@warthog.procyon.org.uk> <20250917184856.GA2560@quark>
	 <783702f5-4128-4299-996b-fe95efb49a4b@jvdsn.com>
	 <20250918041702.GA12019@quark>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-09-17 at 23:17 -0500, Eric Biggers wrote:
> On Wed, Sep 17, 2025 at 10:53:12PM -0500, Joachim Vandersmissen wrote:
> > Hi Eric, David,
> >=20
> > On 9/17/25 1:48 PM, Eric Biggers wrote:
> > > On Wed, Sep 17, 2025 at 05:20:43PM +0100, David Howells wrote:
> > >=20
> > > > For FIPS compliance, IIRC, you *have* to run tests on the algorithm=
s,
> > > > so wouldn't using kunit just be a waste of resources?
> > > The lib/crypto/ KUnit tests are real tests, which thoroughly test eac=
h
> > > algorithm.  This includes computing thousands of hashes for each hash
> > > algorithm, for example.
> > >=20
> > > FIPS pre-operational self-testing, if and when it is required, would =
be
> > > a completely different thing.  For example, FIPS often requires only =
a
> > > single test (with a single call to the algorithm) per algorithm.  Ref=
er
> > > to section 10.3.A of "Implementation Guidance for FIPS 140-3 and the
> > > Cryptographic Module Validation Program"
> > > (https://csrc.nist.gov/csrc/media/Projects/cryptographic-module-valid=
ation-program/documents/fips%20140-3/FIPS%20140-3%20IG.pdf)
> > >=20
> > > Of course, so far the people doing FIPS certification of the whole
> > > kernel haven't actually cared about FIPS pre-operational self-tests f=
or
> > > the library functions.  lib/ has had SHA-1 support since 2005, for
> > > example, and it's never had a FIPS pre-operational self-test.
> > I'm not too familiar with the history of lib/crypto/, but I have notice=
d
> > over the past months that there has been a noticeable shift to moving
> > in-kernel users from the kernel crypto API to the library APIs. While t=
his
> > seems to be an overall improvement, it does make FIPS compliance more
> > challenging. If the kernel crypto API is the only user of lib/crypto/, =
it is
> > possible to make an argument that the testmgr.c self-tests cover the
> > lib/crypto/ implementations (since those would be called at some point)=
.
> > However since other code is now calling lib/crypto/ directly, that
> > assumption may no longer hold.
> > >=20
> > > *If* that's changing and the people doing FIPS certifications of the
> > > whole kernel have decided that the library functions actually need FI=
PS
> > > pre-operational self-tests after all, that's fine.
> >=20
> > Currently I don't see how direct users of the lib/crypto/ APIs can be F=
IPS
> > compliant; self-tests are only one of the requirements that are not
> > implemented. It would be one of the more straightforward requirements t=
o
> > implement though, if this is something the kernel project would accept =
at
> > that (lib/crypto/) layer.
>=20
> If you find that something specific you need is missing, then send a
> patch, with a real justification.  Vague concerns about unspecified
> "requirements" aren't very helpful.

Eric,
as you well know writing patches does not come for free.

The questions here are:
- Are you open to accept patches that enforce some behavior that is
only useful for FIPS compliance?
- Are there any constraints you want followed?

Fundamentally people are asking in advance for guidance of what would
be acceptable so that a patch submission wouldn't waste the submitter
time writing it and your maintainer time reviewing it, if there is
guidance that can be taken in account early on.

As you have seen recently in Oracle's submission some changes could be
quite invasive, would you allow similar changes to what you've seen to
that patchset to land directly in lib/crypto functions ?

Simo.

--=20
Simo Sorce
Distinguished Engineer
RHEL Crypto Team
Red Hat, Inc

