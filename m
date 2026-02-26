Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E043E95A3
	for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 15:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772119676; cv=none; b=pvBebwvEQsRMZCssph/CnXqbjR4aeob9GDbu37vPSdl/Q785ZFgBHpzZmsSP763vRcBfRV8T6EFf0AIvHksQTwxdeI+X5J508a8GAMYm4GDwhGH8+C6gfv9WHIfxv3H1VFKlzciV8TrRJNloDwEboe/S/p9fPPUkXucWorj0Ijw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772119676; c=relaxed/simple;
	bh=WdeCGCTL6JPLNjQboPf6jlsCpxs5JFZtnDaqVpFIDdc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lI8Ah5DqWNhlb8gTdM+Pn+aGWUhc2zJQd7rn02Be9PnMDSFKVaG+es8IbHkEH3vRy7VGNrLYXqQbIC+C2KER5OqPJMExYN57D6e5MkGxhZYMyIKSE+/iCQbidgEzf52FNLJ69nBTTNIOgidUrNdbevde+TB/uEtaJANqzoknFNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S5ltdFD6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WX2LLoxW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S5ltdFD6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WX2LLoxW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772119674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RAyu0qMgQFztjvGBxM+KVZ6vBWyzEz+Ckm03PfSHbXI=;
	b=S5ltdFD6tpgV6e3qmfxhGsJV+xEQBfui2Zs973WoZm928uTJwFLAkBU4GSmaIak/BTMGgd
	xvXZQpp806b8LgM49AxJBLT49Gk057eW6G72ChqjkuiLPv8CiR642Z+ghbIGT0iTu/7oOi
	sgbQn1lEBy5iAt82q1ZC9/dTcpDeJ/Q=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-8P2vbXkJOSG_VBWXgTu50Q-1; Thu, 26 Feb 2026 10:27:47 -0500
X-MC-Unique: 8P2vbXkJOSG_VBWXgTu50Q-1
X-Mimecast-MFC-AGG-ID: 8P2vbXkJOSG_VBWXgTu50Q_1772119666
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cb390a0c4eso897827585a.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 07:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772119666; x=1772724466; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RAyu0qMgQFztjvGBxM+KVZ6vBWyzEz+Ckm03PfSHbXI=;
        b=WX2LLoxWt6hvLP3jV0Og6ZzYw9aYiPL+n5Mnja/lU2r30Q3d5LDZauYt2p/i4wYnyB
         b8fZEBzsCEiUVzeJ1c6F/FneoNVZCNuaDdJy+Si3xE54E6et0IFAFB8HKK0TxBPtdCwj
         5WdaVp/fb0HPdi1y7G3Q1zgZa3G6uXpgsXz2b71yORhhksnSYT+FMkYD4Wyu/fgtNF2y
         o1R/1ZyrSFactKQ3SQ5LrK9kgv09l9MV7EiQo3EqDIU8kqK1s9kWCR3o/Yv0OrMQi+ul
         gseZJl3BJaPOG0Y9e0hfnyq3vINyMqusFA2IDHC9FlZe6r4J7QWHtqLc42yx0oUxjLp/
         2dYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772119666; x=1772724466;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RAyu0qMgQFztjvGBxM+KVZ6vBWyzEz+Ckm03PfSHbXI=;
        b=teZTMY7BTrqyqpT8W/zMWaw6798lxzBW9z4xm2+6eEIr8tQ2qiRIF6XipuUbNnQpxA
         A3BOgRhk4te0whmkzyZNtXvX7ajZG99F1RFN6cwMvr3XGVroP9DJ1Uf55YrEDp6S5i5o
         PqAJakC/1oLFZrBSAkSCzwPjqgDve9SDtyPda2RJ9/vX/K65VPQshdMCoaW4TrJLvgvH
         wze+Ma03x1B7wwzL0Cq+2t9dKxDqieGbppWam/qjwUkZcATCAw02uMTk7NQnMSB6TjVo
         DpQc5pJa/cPapW2NheZO0ZqwT4FLMgEHzocX5W926O5AwvONvw14EevtSDVV1taMcT90
         1wxQ==
X-Forwarded-Encrypted: i=1; AJvYcCU80WHdgb7ZCAN7z9qL8cyknXvYv8N8WUd3DVOii4/BrtRBWoPFaWIK1sQU+Jo3/sHfXTfLWLi+cuvFH1E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxETQH90QXMLjgWsh0ldfzTMToNmv0Zlgi9rouUUIqtTRToOoub
	8RgkjEFPClJ32C00KlpIRWRPsJ1AWhegGcDH4PEuApPXPXF2ClsC5GKgevkITcYOeeRa3YYBvI/
	/fMDtkDNbT86zgX4fOAIVVvQJcHERxHhIsJSDLj1GfI+332XjFfQK4sV70fzLSA/t1w==
X-Gm-Gg: ATEYQzwzQfwzkamHqTAxA7R0oVZQ9qQF5ersho7xWhjHRQM1FzIfTC/Bp3AbX3P+0a+
	fWxf7fw71tk9cNH1lylfoZjtMJGWxAhfHNSw6/Hh/HA6BWTtsByDfurqNe+8Vp9quyQoKXEGHVS
	vEACfHvco2XQjQzBrEhyMcbBIl0sTBHxVDHcfw0ymV+I9ybJtZswJd50QXySPwQhvk5goinqoLs
	puK6R8ttoy3YaQx9W2nQ/RP6Eg1EQu+7YPf1xUdIfGrqCP8PuaKRrJoUG6Re+Ge9kp/ssXx3F/M
	25w8lmay1Kz81iSsOXfSKEj6coLxdOMBq03uZEEAT0A5Jp7IZMiTs3hqev0F5inW3ebC/9TdcvH
	AbrDCPyu0+nb8g3gN
X-Received: by 2002:a05:620a:d8a:b0:8a3:1b83:1036 with SMTP id af79cd13be357-8cbbcf7e84amr649027885a.29.1772119666329;
        Thu, 26 Feb 2026 07:27:46 -0800 (PST)
X-Received: by 2002:a05:620a:d8a:b0:8a3:1b83:1036 with SMTP id af79cd13be357-8cbbcf7e84amr649021385a.29.1772119665670;
        Thu, 26 Feb 2026 07:27:45 -0800 (PST)
Received: from m8.users.ipa.redhat.com ([2603:7000:9400:fe80::7a7])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf6730afsm262894585a.13.2026.02.26.07.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 07:27:44 -0800 (PST)
Message-ID: <da190dbbc692b9da8464bbbfffdde7bab26b3f1c.camel@redhat.com>
Subject: Re: IMA and PQC
From: Simo Sorce <simo@redhat.com>
To: Stefan Berger <stefanb@linux.ibm.com>, Eric Biggers <ebiggers@kernel.org>
Cc: Coiby Xu <coxu@redhat.com>, Johannes =?ISO-8859-1?Q?Wiesb=F6ck?=	
 <johannes.wiesboeck@aisec.fraunhofer.de>, dhowells@redhat.com, 
	dmitry.kasatkin@gmail.com, eric.snowberg@oracle.com,
 keyrings@vger.kernel.org, 	linux-crypto@vger.kernel.org,
 linux-integrity@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-modules@vger.kernel.org, 	roberto.sassu@huawei.com,
 zohar@linux.ibm.com, michael.weiss@aisec.fraunhofer.de
Date: Thu, 26 Feb 2026 10:27:43 -0500
In-Reply-To: <dc09be79-5efe-4756-a295-5b0428985525@linux.ibm.com>
References: <aXrKaTem9nnWNuGV@Rk>
	 <20260130203126.662082-1-johannes.wiesboeck@aisec.fraunhofer.de>
	 <aYHznG6vbptVOjHQ@Rk> <ee36981d-d658-4296-9acb-874c72606b3e@linux.ibm.com>
	 <20260226001049.GA3135@quark>
	 <cba10ac6-3557-4fc1-9b86-55361d14156d@linux.ibm.com>
	 <dc09be79-5efe-4756-a295-5b0428985525@linux.ibm.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-02-26 at 09:16 -0500, Stefan Berger wrote:
>=20
> On 2/26/26 7:42 AM, Stefan Berger wrote:
> >=20
> >=20
> > On 2/25/26 7:10 PM, Eric Biggers wrote:
> > > On Wed, Feb 25, 2026 at 09:25:43AM -0500, Stefan Berger wrote:
> > > > To avoid duplicate work: Is either one of you planning on writing=
=20
> > > > patches
> > > > for IMA to use ML-DSA and convert the current ML-DSA to also suppor=
t=20
> > > > HashML?
> > > > I had done the work on this before and could dig out the patches=
=20
> > > > again...
> > >=20
> > > IMA already had to add its own digest prefixing support, since it was
> > > needed to disambiguate between full-file digests and fsverity digests=
.
> > > See 'struct ima_file_id'.=C2=A0 Thus the message signed is at most 66=
 bytes.
> >=20
> > The hash there is still only a hash over a file and that hash is signed=
,=20
> > isn't it?
> >=20
> > >=20
> > > With that being the case, HashML-DSA isn't necessary.=C2=A0 It's not =
even
> > > possible to use here, since there are no OIDs assigned for the fsveri=
ty
> > > digests, so it cannot replace the ima_file_id.
> >=20
> > For non-fsverify IMA signatures it is 'possible' to use HashML-DSA and=
=20
> > it's 'working' (recycled old patches yesterday):
> >=20
> > Linux: https://github.com/stefanberger/linux/commits/=20
> > dhmlsa%2Bima.202602025/
> >=20
> > ima-evm-utils: https://github.com/linux-integrity/ima-evm-utils/pull/19=
/=20
> > commits
> >=20
> > >=20
> > > I'll also note that HashML-DSA is controversial (e.g. see
> > > https://keymaterial.net/2024/11/05/hashml-dsa-considered-harmful/),
> >=20
> > The problem with this is that NIST would have to react to these=20
> > controversies as we race to support PQC. If something is wrong with the=
=20
> > standard then it would be best for NIST to withdraw/modify HashML-DSA=
=20
> > asap. Otherwise it's the best to follow the standard IMO because if you=
=20
> > don't you get criticism otherwise.
>=20
> What I am not clear about from FIPS-204 is whether availability of=20
> HashML-DSA is a "must-use" or  a "may-use". What speaks against it for=
=20
> our use case is performance. The lookup of a hash's ID (last digit of=20
> OID) and the creation of the 11 byte encoding to prepend before every=20
> digest for every signature takes cycles.

It is a recommendation, but there are plenty of protocols (TLS,
OpenPGP, etc...) where the decision has been made to use "pure" ML-DSA
only, even if what you are signing is not the full data, but something
containing a hash.

Ideally you do not sign *just* a hash, but some structured data, like a
context label that identifies the hash and some other related metadata
for example. In order to make forgeries much harder should the hashing
algorithm used to hash the data weaken over time. But it is not
strictly necessary (NIST mentioned in some forum, sorry I do not have
the message handy for quoting, that a structured packet is perfectly
fine for use with pure ML-DSA, because it does enough to address the
same issues that a separate internal context does with HashML-DSA).

If pure-ML-DSA works better for IMA, just use pure ML-DSA.

> Maybe it should explicitly state in FIPS-204 something along the lines=
=20
> of "with a given hash either ML-DSA or HashML-DSA can be used (for as=20
> long as you use it in the same way from then on)." At least this way=20
> nobody can point out that HashML-DSA should have been used when you didn'=
t.

NIST will not change the standard documents any time soon, but for FIPS
certification there are Implementation Guidelines.

In any case a FIPS module cannot distinguish between data that happens
to be 32 bytes long and a hash of larger data, so the point is kind of
moot. From the FIPS perspective HashML-DSA is just an available
algorithm that protocol implementations can use, or not.

There are additional guidelines on what this may be useful for, but so
far NIST has not objected to the use of pure ML-DSA even where
theoretically HashML-DSA could be used.

> >=20
> > > since it was added to the ML-DSA specification at a late stage withou=
t
> > > sufficient review, and what it does can be achieved in better ways.
> >=20
> > In case of doubt I would use the standard, though. It's probably not a=
=20
> > good idea for everyone to implement their own (bad) solution.
> >=20
> > > Which is exactly what we are seeing here, since again, IMA needs to d=
o
> > > the digest calculation and prefixing itself anyway.
> >=20
> > Use the standard...
> >=20
> >  =C2=A0=C2=A0 Stefan
> >=20
> > >=20
> > > - Eric
> >=20
> >=20
>=20

--=20
Simo Sorce
Distinguished Engineer
RHEL Crypto Team
Red Hat, Inc

