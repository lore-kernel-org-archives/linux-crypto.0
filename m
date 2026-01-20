Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097644534A1
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 14:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768920297; cv=pass; b=oxPF5lqCOcW9Y3IK0I5+kMMDgXmlBAYSYO6IXf39f6LUkHfkH2AaT7SdWO1ev8vB3v2wxsIkgEhYowk+9+gcwECf/tFpS0upHKqdI8OXRVv7lsWWKm9cKXTYD2FMhS8SHIU3ckS0XPI2IxyfQKfreAs7MjMFZpMgsL/kIvCs6p4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768920297; c=relaxed/simple;
	bh=rz53VO5WEJ6mEttqNh9dmuyaN1HDtXctdjvaFqiWAyI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=We0JcInWu4AbxNXCc8LUUV++bag73v1Dy9y/HK+62erFMrGlZsYBHew7lejnx7lapyTCA9xWzhFj0w/MeUELlIpepxP+ZFIK3/VypZoZvihoNQmkHgttJXBwr+CYB4d/EzPjIuhlKsXWEqxaH3X77COIg6LDlol2cOlIs6M3C2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=RAEsCP5u; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="RAEsCP5u"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5029af2b4bcso23345921cf.0
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 06:44:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768920294; cv=none;
        d=google.com; s=arc-20240605;
        b=eePvJWBM9I0teB8eo4WItKYnzExWc+QhcKnXTZQ4fGse8WQiYxumMwB3jwGNYgn/oC
         XHXF8GBtoAPY99UNhmM4SSGxa4h8Xzux1APJQ/9Ej7F1C0Q9svSrdXUAI3LtQKjleRkQ
         nZtJ54d9sSQXNr5j7513ZAuF6m/g+4epoQ+2wPVNXIkrLQHrneqSwz7Ca5BZ3Ia1gwC5
         2+yp70rFOd4Ue4MsBkHZejnSjc6bOZMIBC6ro6eHq5i9ahDutqCsAe9vtGbdWU9w+hdI
         5JBTsOGNTojFTzVh83/PDdLbL4yH7kMOjaCqiKRY3p4X3eSKJDpmNYgzGJiwn5elTjJk
         Lkwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9TI6H3WwESCL57aO4N/M7cKOKDQ2SmqGN3AlwYF6YfY=;
        fh=4lSBjwXE0BeyQgvGXfYenQl/py6qHlwKYcPcUiHAwxA=;
        b=k9zHXNu684JJLbDl5PxiGvj42jGm3XMFe6dS0iyZN1BpUP4OS9JtZE8UlnM9bs9WAr
         zQHteQFtjzsXqx7k4cprqNe/T2s6a8WQtq10cBLfPG97qs5/v1IBP5ZbRPPzXvFO7fg9
         4ONzzs/no5PvD5CChMoV+OwNR+HXGQDM8zuD4Iubpy+lutxmYKgjpmt9Ql9Kd5+QbwBQ
         Y8J3zE35u4+JLOOaGAXAd3AWK5jLLgA6JarVZTNgtXbLxULwdD7oD07QooE60+2jaVnt
         2zE2QixP8s+X2oUrGPo7N1xyNs5wXuzul/g2/ACse4wWySiWhSxg/jlCwq4ZlDLT4cjE
         WX4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1768920294; x=1769525094; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9TI6H3WwESCL57aO4N/M7cKOKDQ2SmqGN3AlwYF6YfY=;
        b=RAEsCP5uWSwcoqwjgXUxDH8ShyWti1UENOl+fypUwRkC2ol2hwKVPCeKrRBTUkXQvs
         kbwjIbWVkGTVMqYhHJKN5b53WUERJ0dd4nubxVaUnbtizmXJD9xdTU39z6J5qeExq5na
         zkMmhca3udNBBjliEBgzcNeul2H1SgoHnYsb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768920294; x=1769525094;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9TI6H3WwESCL57aO4N/M7cKOKDQ2SmqGN3AlwYF6YfY=;
        b=htZ19/4ic7hCiIzaP9aJMfOmkQCF7dm2A6TRfavK/O+A3UmLqkKG1Eu5vZjuR/zROQ
         4JQ+DGwOTnpdvwAt02z1PmsQJ++64bIuYJba0ETWV9VX8qHr21LipUMXk6CLIc29jmwq
         odEsVxTmyeEQ/bhgvrseXcd5m6tNBtpBLlB6ymZSb5eu41fnNPwOsFKGeWIjMJfot5VZ
         HT7qFriEvrEh02Xi3BWhqRKLFEIGXqFBB4t/NKKDI69dyLUj1swYJm5IWejTZQusesYU
         1F4rz87AITMlWwUWo2Q42Iccq6xdNwnU+5aocmrNEPKRH93obsvg/vfR3fHFkIB5IULm
         ciFw==
X-Forwarded-Encrypted: i=1; AJvYcCUTnK/IUFrm2/4Z/dyI1sRkWIi1ymSTQlf0wfAbhFqJn5fZYu1ZFzb7s41MHn2u5eldxzcPXmqXpb+i/4U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFiyWjDNWLvchtb1+NK9wn/Ma+8ssFdnGE+tAZkRJaFh/QZghd
	YHM/LgA+5CkrF3lJu0OZeE239Q3aW+FTWzSs3wwZZPg882S/LXYiLWUeyVCsGWay/Ux5Nz73PVs
	POdhnlgb/fWQx+TvThCFAqtc3eXGf642TsxK+d3YzRA==
X-Gm-Gg: AY/fxX4Dq/ffmXmyDlwdqV47mXfc9jcT3qp6sH/OHvzaGDGHuCOSotEtHYCn75PUURi
	URUgp8rfDYKmhcZJ7o/5h4gIsj4HHtV5p2LwNqp1nGojX9YrAiLEsrury5e69tOE1V8wWmaKkfO
	54cKmPawZ+NtY1I2klqiIeAGjktbNhkEEsmbQbwv7YKGX4ryXNndwmS54PLyXn+oZq0TOsO3DL3
	+vHvmbjyN2IqvmxZTtSM2+oMpc19Bq05lBO+1p8Xrj9Xy6z28Ut79/403PwXcQRkHX+jPY4Bw==
X-Received: by 2002:ac8:578a:0:b0:501:3bdf:f0eb with SMTP id
 d75a77b69052e-502d850754fmr21826231cf.39.1768920293837; Tue, 20 Jan 2026
 06:44:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1768573690.git.bcodding@hammerspace.com>
 <CAJfpegt=eV=2OxgfiVYG7drw_yN14b7edJhj+bsF_ku7cVGuig@mail.gmail.com> <223B0693-49B1-4370-9F17-A1A71F231EF3@hammerspace.com>
In-Reply-To: <223B0693-49B1-4370-9F17-A1A71F231EF3@hammerspace.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 20 Jan 2026 15:44:42 +0100
X-Gm-Features: AZwV_QhDJIknwKN18eydHboBF4zqKqUes2ycxxJujxBh2JV7RqxmtX4z6Jrqa9Q
Message-ID: <CAJfpegsDTopCcAQzxfqvrMJajfCRt5MnTzEM0oCmVSM=1ik3gw@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] kNFSD Signed Filehandles
To: Benjamin Coddington <bcodding@hammerspace.com>
Cc: Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	NeilBrown <neil@brown.name>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>, Rick Macklem <rick.macklem@gmail.com>, linux-nfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 20 Jan 2026 at 14:03, Benjamin Coddington
<bcodding@hammerspace.com> wrote:
>
> On 20 Jan 2026, at 5:55, Miklos Szeredi wrote:
>
> > On Fri, 16 Jan 2026 at 15:36, Benjamin Coddington
> > <bcodding@hammerspace.com> wrote:
> >
> >>  Documentation/netlink/specs/nfsd.yaml | 12 ++++
> >>  fs/nfsd/export.c                      |  5 +-
> >
> > Would this make sense as a generic utility (i.e. in fs/exportfs/)?
> >
> > The ultimate use case for me would be unprivileged open_by_handle_at(2).
>
> It might - I admit I don't know if signed filehandles would sufficiently
> protect everything that CAP_DAC_READ_SEARCH has.  I've been focused on the
> NFS (and pNFS/flexfiles) cases.

Problem is that keeping access to a file through an open file
descriptor can be better controlled than through a file handle, which
is just a cookie in memory.  Otherwise the two are equivalent, AFAICS.

I guess this is something that can be decided by the admin by weighing
the pros and cons.

> Would open_by_handle_at(2) need the ability to set/change the confidential
> key used, and how can it be persisted?  Neil has some ideas about using a
> per-fs unique value.

I think an automatically generated per-userns key would work in some
situations, for example.

An unprivileged userspace NFS server that can survive a reboot would
need a persistent key, but that would have to be managed by a
privileged entity.

Thanks,
Miklos
