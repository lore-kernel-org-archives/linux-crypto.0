Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4287B3ACA59
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 19:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353884; cv=none; b=sr2rIr2KXtqaW6e3KZYRZIugMrX7OK2YxoCpbtlv3PVTT754KnDDviWxKJpNlXfGYc3s5hknasSBqiXww5yZ+qeBPFs5DNHq8B7LecD4R41bH0JyEbShDMiXVMjNFVOh5iYVun6LBtabe+7lMFi9P+Sle4hK3h4/5/6D69RsLlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353884; c=relaxed/simple;
	bh=x/rRlVoLnYuXwT3efDQi9GUzViJ4obE1kKtouvQkKvQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Jzg4K/BulkphX/qMQ8Tx3i3TTRYI9++EbaVe4+aExBSDFFEuQNTAUfbWQS4Af7ToR4oG+AM9zTL28bHhRTXB20UZH8tMt1EjtFVptx0KwOo2QXmN5zelDi3nKfobXFWrqeHYIbssdItLP0fhjSzCSEyiKLsei4aIy31vm9E0eek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Onw4mA5W; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HSwH0egp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Onw4mA5W";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HSwH0egp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785353882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ce/4jE7SKUx9c/gVXIDISjJnAxGiSvKecY4InIRGaJ0=;
	b=Onw4mA5WXrRVJtwsn5r6j3RnO1S2foX6sBHJQCPfJ0d4WNzYxjibZvtRhusID40E2oyNxd
	ziaiCex6yBUG/BIIFlDYCpgC4+uuW0itiIh0vbLm6LeKh8bnDIA+pz1YAN42FX2YoipQOU
	PQuQ97mU1iSuZhvyTtTM+WJgIjQ9B10=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-DSOKJ3YTNKmcgZ7lHdaJUQ-1; Wed, 29 Jul 2026 15:38:01 -0400
X-MC-Unique: DSOKJ3YTNKmcgZ7lHdaJUQ-1
X-Mimecast-MFC-AGG-ID: DSOKJ3YTNKmcgZ7lHdaJUQ_1785353880
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-9308eafb465so259667985a.2
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 12:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785353880; x=1785958680; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :organization:references:in-reply-to:date:cc:to:from:subject
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ce/4jE7SKUx9c/gVXIDISjJnAxGiSvKecY4InIRGaJ0=;
        b=HSwH0egpcdw6iA4yfDQ1/Ru9YB6LX+0Mub9WUuXjGO7hk2orrSjQSAAq4CJ3HcvVID
         bVoie2xMV2pPKK8UguBidf9H7WfLDHL2EB+LNqEx730nNk/q3qgl4lEm8BoGdmX99/c6
         TiyU1bD+whBzunLZqdiEhCE0HIfYP6ySEPfSanSVSfFerA6Tn5gGZ6PWhuyQ3qppeXY3
         QIIPvMSkYTJPoXor1T66mkyM9XB2EoGBZ/rLHsREvCaPdhEHTEKLa4UcYxfxZ8EuXZUo
         XI3qrZbi79snSTuMe1QnJm967bLvzc4fmmJA8qKKDqnCNBLGXnYG0I6+QdBnfiJMuRyj
         QpNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353880; x=1785958680;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :organization:references:in-reply-to:date:cc:to:from:subject
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ce/4jE7SKUx9c/gVXIDISjJnAxGiSvKecY4InIRGaJ0=;
        b=AZ61h/sOnOH/nMz6Q5kUIByQBBG6972nE/BDvIsKVGPipVh1GwgMGlTtTy8RPh/3xi
         Fk3g0bC5gysFinhgAzdGnp4n01e7ywokCH/JqDTjea7SPYNnL0A5G5uWhembaDUwWl2F
         YZZCUF1YrLmDO+XVtGz0zKYaFwoJAV6t5WxHWRZIGVIWXLxOoWgMHZxcfCfJzVBRfN7O
         W+31fReoGMfRQH7O0hOX69rwk2ngmOWHURY9/8kpYgWU3SqHiRA3/E23op3iZYb7uAc+
         Vf5u5PHY2e4pjlqNkGcHUXd3uRiHkjyC11C+K7im0/cqvPehfjwBqzpNfols0lnj3b2h
         mMcw==
X-Gm-Message-State: AOJu0YzcUlvVcpUuH67HLZh3BYftRxxsgBi1DEYsV0o1oIvnDfbPUsB0
	U3A5F6udDbgJxBW1LU5hVXdwRWfZFb3nN+lNyR0xxmjsWVgs0qp1tuH/wAaz9HeK73nvD8kshS/
	z5H0f8FAZCtVEuFvhDwJEEpeQ8mp4G0VgeFxsAuS+AbE4mzpKuioDZ7lS8f+8cS96Jw==
X-Gm-Gg: AR+sD12PQXHhyPGraHNmrFTJh0zCrppamzEf3N82h/kyWC2UlxckUUZ2zSt1kUKtWgv
	/+q8CAkol47BlojACsUVMghBWeyy52Rf/4foSJPCo2iNlFCV0G/T9JTHAotq2WINWxGCqHsZTud
	8Rh7QOv0txPp3A+8OUY8KvNcjtr1iU6O3BGkRIrpViUtIBKvuHIJQq4jriHNy03k8wYn3b2m7ee
	zlfs55fVZxFS9fUpZEXGw/8JHZ11FaywTvGYKJG9DIsgWzhI0wI7Khmace+dJHnWJxVf8w2R/W5
	6rE6T0Okhyw0igB1r8AcbAw37IPoeGBfXcDTqvTuwMFYGirUtO3S3WIpVjSXHlAq0Qrn4DY=
X-Received: by 2002:a05:620a:471f:b0:92e:e5f1:2bc9 with SMTP id af79cd13be357-93483e9ca5cmr29058485a.65.1785353880352;
        Wed, 29 Jul 2026 12:38:00 -0700 (PDT)
X-Received: by 2002:a05:620a:471f:b0:92e:e5f1:2bc9 with SMTP id af79cd13be357-93483e9ca5cmr29054985a.65.1785353879849;
        Wed, 29 Jul 2026 12:37:59 -0700 (PDT)
Received: from m8.users.ipa.redhat.com ([2603:7000:9400:fe80::7a7])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933e7318323sm237946385a.23.2026.07.29.12.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:37:58 -0700 (PDT)
Message-ID: <86385ae5f9f753e42efde7d0088a494c91639741.camel@redhat.com>
Subject: Re: [PATCH] crypto: ecc - Add NIST P224 curve parameters
From: Simo Sorce <simo@redhat.com>
To: Paul Louvel <paul.louvel@bootlin.com>, Thomas Huth <thuth@redhat.com>, 
 Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>, Stefan
 Berger <stefanb@linux.ibm.com>,  Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas
 Petazzoni <thomas.petazzoni@bootlin.com>
Date: Wed, 29 Jul 2026 15:37:56 -0400
In-Reply-To: <e59088fb-0a47-4379-8583-546b7e4ec337@bootlin.com>
References: <20260729-add-nist-p224-curve-v1-1-334dfbe16683@bootlin.com>
	 <42f6dd7b-8db0-46cc-ad22-c914d64d15bb@redhat.com>
	 <e59088fb-0a47-4379-8583-546b7e4ec337@bootlin.com>
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

On Wed, 2026-07-29 at 21:06 +0200, Paul Louvel wrote:
> Hi Thomas, Simo,
>=20
> On Wed Jul 29, 2026 at 6:43 PM CEST, Thomas Huth wrote:
>  > On 29/07/2026 17.51, Paul Louvel wrote:
>  >> Add the parameters for the NIST P224 curve and define a new curve ID =
for
>  >> it. Make the curve available in ecc_get_curve().
>  >
>  > May I ask: Who's going to consume this?
>=20
> I am in charge of upstreaming the ECDSA and ECDH support of a PKA device.=
 The
> downstream driver is using the NIST P224 curve in it's code internally.
> We are waiting approval to upstream the driver, and I took the initiative=
 to
> send the curve definition ahead of time, as I thought it might be better =
to have
> this definition in the core rather than in the driver itself.
>=20
> This is an old IP that is more than 10 years old, and seeing Simo Sorce's
> comment, it might not be a good idea to use this curve anymore.

I would simply not expose P224 at all, nothing should use it anyway.

Simo.

--=20
Simo Sorce
Distinguished Engineer
RHEL Crypto Team
Red Hat, Inc

