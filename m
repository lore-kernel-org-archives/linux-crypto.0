Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B9915B10C
	for <linux-crypto@vger.kernel.org>; Mon, 16 Sep 2024 19:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726515636; cv=none; b=c7J6/TiKAFFB/sa+PJTUAlW8CG24X6RG+iszqIgPm2EwBnQ4efvgAhnwUWvnaZMnjxRPEDUA9mMhuyqfxnpzO9ufp7C4dfciDbsg+xMdmGS35tCeV6kJVwkLrB7UN+MSqyqFicZ4fnzAxYM6DHBs7fq7I/xg2dOLcnNbvj1YX94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726515636; c=relaxed/simple;
	bh=7yRCF6W5FfU3ij3odUYqCq8SxiLvJkMBHMwwpkwMnTk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BdcPPlcJiO7BRyiv8c84/9AiP+W/6E67feSmFWAcCdURnsv8hfpJMJbDCTPS6qOLUvLyJlg2mEIwQmPcCE71dCswP5YTpPZIXFAaj1m4oWNSgeZzbtb8zBQUTajGXSqRxQWGivMRiuOJF8H09e7EsEMYt9ZsljcPcaLISJOBBZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IMzCJTA5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IMzCJTA5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726515633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7yRCF6W5FfU3ij3odUYqCq8SxiLvJkMBHMwwpkwMnTk=;
	b=IMzCJTA5Nggtxv0Bef+0dtt8mYm/ViIEnLBihxMEWPzmolfoqC0cSPDykyFVxNi5R0ke7P
	EIGVGiYuFiRKFccUX1k2kSCVYdo22pQt0+gQoq+EbbWWspRvBrA6PSgrJ/4+LP1pADO7Lb
	UJH1xjGEphqwnB3fgkxhS7ACfZOoMVo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-QQAfsh2LOQSOPGUMGl-10Q-1; Mon, 16 Sep 2024 15:40:32 -0400
X-MC-Unique: QQAfsh2LOQSOPGUMGl-10Q-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a8a8d9a2a52so424816666b.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Sep 2024 12:40:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726515631; x=1727120431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7yRCF6W5FfU3ij3odUYqCq8SxiLvJkMBHMwwpkwMnTk=;
        b=PkwVdIkbBxC0kGXIHJiRCI94esZ2RlabDWXQEY0SjYfXOdNDoN+q680C+Pk9Xm9A03
         KtNnrmS0Q4cBriGy+RQF4oI+gWfX5S0x/7OkONOM/MOv4ugUxeVJ6jWMEKTpLX0GKPzt
         zYg9sK8bOfNfcOdNL7Qsh8ILH2DF6c7KJGRXS74fQdrYuEpZa+cRTZOQSgPsW30fXAgS
         tOIpETZIXlymSpTFO2PRBhTF9Wg6q/3Jn+tZ01y7hnCg57R3IAxQ7ZTQjD+hQC1s/LZL
         ijQeT4MgBpYfHUb+BoVrODGuh/nhZ5tCqx2ABxb/r2wO6QL5r9kynCrHaLUsUCQVr5ck
         //ug==
X-Forwarded-Encrypted: i=1; AJvYcCVVLAletA5K1w0uHngoSAvOAPwsM0PPlKYe7RgiK+zIB5stpRL7X/vTtXpl8zWrLGHhgoaFDabnPOhKOd0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzby1rg+5Q4DEMjmKxPjbM4fs/cZbMKuPgc3nXfFjkvBQ9I4kdx
	ZVbFtptpN3gkgBHEsflfHHxJTHklxcWXjBdsHMrKm8NJMgyvfITK/SHPD/xWGqNFpCpTtaQR/Vl
	8QFGW2yyvwRGmWANs0Ba8Ro3eKtCCJMDonTp5zFSRRUsYimBcp+FWgPFFf0RH34p4+DiSKz8M+w
	V4X6svb0IOY5duB2zOIPnKNIPGOXKDK2w06N4j
X-Received: by 2002:a17:906:fe47:b0:a7a:3928:3529 with SMTP id a640c23a62f3a-a90293b188cmr1868771066b.13.1726515631086;
        Mon, 16 Sep 2024 12:40:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFuZUPKSthj4I2w8hTxO/iTa1QbGDWHgOQucPifVaEN66W/B56Gvsea9nDnlESpuDV/2Wyi7249hfokF3p3ZxE=
X-Received: by 2002:a17:906:fe47:b0:a7a:3928:3529 with SMTP id
 a640c23a62f3a-a90293b188cmr1868769166b.13.1726515630567; Mon, 16 Sep 2024
 12:40:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240828184019.GA21181@eaf> <a8914563-d158-4141-b022-340081062440@quicinc.com>
 <20240828201313.GA26138@eaf> <CABx5tq+ZFpTDdjV7R5HSEFyNoR5VUYDHm89JEHvKb-9TW6Oejw@mail.gmail.com>
 <f6075361-1766-35a5-c7ac-cc3eb416a4e1@quicinc.com> <CABx5tqJomV_Su2NmyBBgipOiiby5sF7LAo_kdvhYT6oNYwVpVA@mail.gmail.com>
 <da23b318-1d65-c001-1dc2-8ba66abe9d6f@quicinc.com> <e6299c6d-dc18-eb05-2af5-8f8d885831c9@quicinc.com>
In-Reply-To: <e6299c6d-dc18-eb05-2af5-8f8d885831c9@quicinc.com>
From: Brian Masney <bmasney@redhat.com>
Date: Mon, 16 Sep 2024 15:40:18 -0400
Message-ID: <CABx5tqKWNCoE_9-MX+9unVLK8eqaJZiK6SC2RWMXDRzVayQLkQ@mail.gmail.com>
Subject: Re: qcom-rng is broken for acpi
To: Jeffrey Hugo <quic_jhugo@quicinc.com>
Cc: =?UTF-8?Q?Ernesto_A=2E_Fern=C3=A1ndez?= <ernesto.mnd.fernandez@gmail.com>, 
	Trilok Soni <quic_tsoni@quicinc.com>, linux-crypto@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-arm-msm@vger.kernel.org, Om Prakash Singh <quic_omprsing@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 16, 2024 at 1:42=E2=80=AFPM Jeffrey Hugo <quic_jhugo@quicinc.co=
m> wrote:
> Bisect pointed to the following which makes zero sense -
[snip]
> I wonder if bisect-ability got broken somehow.
>
> I'm going to try to do a bit of a manual bisect to see if I can avoid
> whatever glitch (possibly self induced) I seem to have hit.

I've seen this happen if the error is due to a race condition and only
happens part of the time. When you are testing a kernel, try booting
the system up to 3 times before you run 'git bisect good' against a
particular iteration.

Brian

