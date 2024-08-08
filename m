Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D54C185E6E
	for <linux-crypto@vger.kernel.org>; Thu,  8 Aug 2024 06:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723097652; cv=pass; b=mQtdWVvNqiq1ABHuQ7znrkwcT8cwgLVNOZK6vGjCGMbupoyR+Beeju3r4O5m26f7yZtrhIHZoAz3sSH/6ruY1l+Xs+4IU4+vwn25f43KerVO0Yq64SD7FYtUKZbxH4oFl85CD8XkP5G6ddEIZlMm2UlxD+buQMX7J6MqxzOE0eU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723097652; c=relaxed/simple;
	bh=0ZusLN5VHxGu8N+UC42hk8+ubQ2giQW5lICmr3XlIsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jj4zWAAN5XjBo/cLMElo1BSEwJIAgSOOfI3QMvFahdbt9/dXcpUrKOQxYW+arMxzSyHmQ14Bg9gL6cAhmCFp2uD2kfsS6E9b87l0jY6UKwjLYNcwaxhgLXEB7QUMpcCHStA15V5ndgnXiryVfseEPI5UbYs3R2fxG/aTPs0k5Ag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chronox.de; spf=none smtp.mailfrom=chronox.de; dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b=XQdtjytt; dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b=Ik7njBLp; arc=pass smtp.client-ip=85.215.255.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chronox.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chronox.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="XQdtjytt";
	dkim=permerror (0-bit key) header.d=chronox.de header.i=@chronox.de header.b="Ik7njBLp"
ARC-Seal: i=1; a=rsa-sha256; t=1723097636; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=nASUiyZ8rC5ZYccH7e+n9bpDcxMvV6D1Mqx+XFVDgYZC5heOyullp36dKxho7/TsEk
    fIQtGn45e2TadlvjojVHUWcKefnrP6zdbjVSBj4qajYNDKh556VOFm2DbLec54FTqP8L
    Tsldib3Z/7x2t3ZiiDZoHL3yDX+W46ZEa5xO2sCJdo9oJ90xSLdDnArmt+bPQy28uHIx
    cCrZgUxLro1ERtFIDwqyPlIQT9EL3yXtwpGmIiIlaIvPyk6pX5gwOTwsksE+FNZ7Pw3U
    jcBKJFTy9Hsz/2c4NGH0H5SJMm+2AA4Dvnp/fg6CeUzFfJl256OB8/MZLBA9Pr2EKVUg
    CY8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1723097636;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=MRjzn2Ng2b/Qg6WZYdZxloVztunlmC+48TQoyrs9hi0=;
    b=he4CgNzw2WpaOkH5of98uTyx/90W5/Hb8FcfQsxMWqWS4t1fqUnm8lYyyRzPPBbOHB
    5kHjV1HNkJwVAXii4r8Szw2iKFI+Q+We5lEs9LHdI5gnyniNAiKpBHC16y78uqJxAvkU
    LapGX+A/nHOfj6PA9slFkKUOfOdBIv4UWFSRdYHiPEKLqTgqFCArOFmLvX4an/rlWRtD
    gOxxNHkbxHNQtqOmcbqFb/ZOiS6pTR9gOhhx3zXam7wfz8/7ffhajwsSHUV8gFcoZ26L
    cAqorEs8+kEodJtoNRGUQ20IoUOH2nIMZrE+1HgcbRve3MTH0aTaed4xV3XdiRBEa2Wf
    ZCvg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1723097636;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=MRjzn2Ng2b/Qg6WZYdZxloVztunlmC+48TQoyrs9hi0=;
    b=XQdtjyttUHNEgbyZv/F3PBdVryiSbAfKPcnuWe/LSP4x6ynEKZ8IZ1ZDaT39tgv7/y
    RmoMSNql78L5cvLNhcllE37uIrmei/3J9lTS7pAtGlUPcHgtbODIE5ETrxu+z5TkZ2zp
    cj/24APU4u7N/auzWCWbNFOuhFIUAzw3jN+464Md9x8hLzTLwzj0slNXFd/bLwMSPdVS
    u1wPqCvVkevGk+BO5ucIHWrSLgUsuUf/w/wmkypWLs25HdHjcxMbZu0ienCxfZxT4nhC
    rBMO4mpDbLxQPmY8ReBq6+qxqfSa2cQPs4NWeDVIgCJbUXYG7EsL4DiYb4I1Z+5IFh7B
    wc0w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1723097636;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=MRjzn2Ng2b/Qg6WZYdZxloVztunlmC+48TQoyrs9hi0=;
    b=Ik7njBLpSMiR3Vl24fSIELd26QLQw5edzj5y+ELXWgXw6+cqP+Tg5T5FH6FaVLrDhQ
    fUJRJDVSodsIPm+FgNCw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDYIvSdwfQ="
Received: from tauon.atsec.com
    by smtp.strato.de (RZmta 51.1.0 DYNA|AUTH)
    with ESMTPSA id f5d0fe0786Du0ry
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 8 Aug 2024 08:13:56 +0200 (CEST)
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Jeff Barnes <jeffbarnes@microsoft.com>, Vladis Dronov <vdronov@redhat.com>,
 "marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>,
 Tyler Hicks <Tyler.Hicks@microsoft.com>,
 Shyam Saini <shyamsaini@microsoft.com>
Subject:
 Re: Intermittent EHEALTH Failure in FIPS Mode - jitterentropy
 jent_entropy_init() in Kernel 6.6.14
Date: Thu, 08 Aug 2024 08:13:56 +0200
Message-ID: <2416186.INgNo8UaUA@tauon.atsec.com>
In-Reply-To: <ZrRhR-IRZPrQ5DSe@gondor.apana.org.au>
References:
 <DM4PR21MB360932816FA7B848D7D8F7B0C7B82@DM4PR21MB3609.namprd21.prod.outlook.com>
 <2533289.B1Duu4BR7M@tauon.atsec.com> <ZrRhR-IRZPrQ5DSe@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Am Donnerstag, 8. August 2024, 08:10:15 MESZ schrieb Herbert Xu:

Hi Herbert,

> On Thu, Aug 08, 2024 at 07:56:39AM +0200, Stephan Mueller wrote:
> > The user-space version uses an OSR of 3. Using this value, I have not
> > heard of any problems. I will prepare a patch.
> 
> Thanks Stephan.  Jeff, could you please let us know if the value of 3
> fixes your problems?

However, the heart of the problem is the following: This failure mode is 
probabilistic in nature. A number of folks trying to push rules that the 
failure does not need to be handled with a panic.

A changed OSR only changes the probability, but that probability is always 
strictly higher than zero.
> 
> Cheers,


Ciao
Stephan


