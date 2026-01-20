Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752FC42883A
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 14:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768917890; cv=pass; b=XTZ8ceExPCQR4qSTOW73BV7JMPqpzOuTAmxR8RprIf/zYVfgSFnVIAzt3S6kV1YZDMudl67au7MDTBikRWrlMQX2mwTPBl5F0jSB1feRNIf2cUk450ecVh57Htv/PTKWx7vaRHEkmdkh1iJ18IEgenCLYgg+I3FRIMhHH+cym2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768917890; c=relaxed/simple;
	bh=Abyc2F3eRLO88olo6GqLzz8EmPBFtsnX5eGfE6OvN7s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W3A+P4CIBUgDZhXPgAOKVZfv9j9ag30YQiTIPY7V+vJfMGURvPuGSazI08F296YMLbfmrMcmSHfliu27JtLszt8qSmX1QKDcSMkcUNOnT2tRt7Fx1Pb1iegV0489+B+2sSxxsTr2LR81CxOaICi240Wcka6onPFDp8RoUs6RZbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FLWSE5s6; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FLWSE5s6"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-502a26e8711so21724021cf.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2026 06:04:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768917887; cv=none;
        d=google.com; s=arc-20240605;
        b=Gmwtxkwxssq+Z+YZjbdbwvVA2Zu/UIF1lxkSDePkoptAE39is0nXIGNOhICSjXdgIY
         zt6IHzCe3iXWUbaKWV/xuXYhZBijI8PyZyRS65JtaaBgrWN0UcSZBLAPo/5hk/v6+3FU
         flyfWTHWHF/0Gvf0XJdA15N604t/6SIQpvh0sp5F5G9GkJJ/pLykR1VDF/b9DMX/dCiN
         CZSdCvbdKnzSD6BuFnw/3LQonVEdTh2hQIsnFVuhNK3k9vIZWraOZyw1slBAg7kDCaPp
         inaCWIIalvepRPxaRveB+AuF4zTDniiousORiw4hXq0rFQVx78USd53hs6q3V7UJZVXf
         sumg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jmM/dV1Q0UanGhFdvF+GkJPZvDrrzI7SS6CZEDHOhsM=;
        fh=uJph7XOKo7zOn68kRgIR/+47xa4wrMwvlU5kExYVxVQ=;
        b=jYQywK/JpyWzwiCYDt0x1upb6pGh38ns2qjCf8DHnr47WQIbe5ouAfHuKChcoHt6nZ
         h6YFjCAIYcPxEZ+//6wNLyPHL8QEtv+EZO9NLtKoBpEoWQ8MAvEXzteFTfke2tXBaRnr
         LsyULhcJKk4rl7U/ZekbqgP8bqsrfdyTmFQH2sQ8AAlZTS7wQBnPXevnDNm4Bca0vr1O
         MYs268zwchZuxCYVxUT6BrO6lkKrXslrVsqNTFgZYwMaLmi8szwfHin4lXTcjQwTV6GU
         asPO+pYJwhDKe2b7Qs5EHER+vCn6Vs1l3IyrxGXSB738AHjP8br/wAfFGCFD2ixjkAn5
         kM0g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768917887; x=1769522687; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jmM/dV1Q0UanGhFdvF+GkJPZvDrrzI7SS6CZEDHOhsM=;
        b=FLWSE5s6KAFuKBVfIGY+OeHgNIGrpGEz0YsDFSGaO6OT0iCO33h7RCjNcin1JnrOwn
         cIKkssTKqqhXjIl18Y1knuH23gCNSQc2MDJT2QY+L1x3hqNw6fgtHfBdJyUJVjeRYO3F
         wNL72e/7vWEO0KCu6d3KqRa9eWNAnr+7MtEsV1KxxONQDQViT6Kay4br0TsbqpM05Zlb
         jMxA/H041NBiW4Gusy5Y6Dp1AFZuFSdRY+TXbZsySpDUTeV8t1l8xdY3voWaH/7FKikO
         veoZvgdl8XVLWOIu9bgSbiF36eiyfJTHe2oALECKDI1m943nD6cxkxxIdFtW+s0xy13a
         j+NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768917887; x=1769522687;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jmM/dV1Q0UanGhFdvF+GkJPZvDrrzI7SS6CZEDHOhsM=;
        b=ikjBYmEN5BKBGSHG5LeHyn51yZI3JMtqo6nmEzNnUn1zO8fONp5innyKssU12+af5/
         GLyhLjnjRcx1dK/5nc1Ntyz8XQAgvNWufrZaWJPdUwGjcnf2DJ70KCIDgL/wjkZdlIK8
         VZ3Ao4Mq+xO0nvPdmP0CZmRHsWNKp6Jq+R84KNVWnwV79DKxVTs0LFpbz8Subt68Rt38
         Nbqfm8FAyjXnhioYTpBMbKLlMg/CTWmy+4+e4YNVU55rJ9HEZmGcJhAsbtGo6o7EGTDF
         lGcw6sTUsqA6LmU4rtDebac6sYT/J1rAeNLBUgcn+NCx4dRgMZ07bHHK5ozt0Kee7Fhb
         /pwg==
X-Forwarded-Encrypted: i=1; AJvYcCVSS4TLOQXNdFQulhVVRd0pVqUb3B7lZxHtMSEfGWR9MGzmrIEzEVG5UpZklIcxuP8NmH7qG0M1Df7dc60=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsfoRzQQaHm+UeUQ5g5BokwT9R9A45KcB2/TieREaKVerLtJ9a
	ZQ5rwxilIPloSyc0bz00Vm9tyI3SFWrxmiHg19UNJpqOb7rei8Ueu7vT48eNkAqgbCYszoTJtWG
	QsktmrK346og2XPzOKbJFLEN0qf8UKwWQd+pTz0Ao
X-Gm-Gg: AY/fxX4V1JudQ6GVOc718tp/OuvdfvEXFfO4ZM2uJpJQFmr/RQ4uok1G6xchBeHq/1o
	I+dqeXOkbN/xyFxVHtIq0tjFvyO65nIwzTAWBNOLEwmCEi82yze/qEy8i2qPnYLwbGaMCkeqIUn
	j28aVXXvMgYgCzsCBlSdZVDMlNrNw6CBnWRjImik9KS747jfyKL3WCMJjBGK89gyMcejoGH+cq9
	lsDSIdtrI1f7pnRDyz7TeKO6MMdWQ8EtXwwrJpTozkfDPF4XBc0OXSWvQy6mBs9Ej1bl3lAK/JO
	HJLs8AvTli2M4W2S3dVHTTvY
X-Received: by 2002:ac8:578a:0:b0:4ed:6dde:4573 with SMTP id
 d75a77b69052e-502d8507492mr21826281cf.52.1768917886535; Tue, 20 Jan 2026
 06:04:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com> <20260112192827.25989-5-ethan.w.s.graham@gmail.com>
In-Reply-To: <20260112192827.25989-5-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 20 Jan 2026 15:04:09 +0100
X-Gm-Features: AZwV_QjNl1xBiyaK93_mkyw1s5efrvsnk9WwoFCUyx7252b7lOOknPIAjr9SWYE
Message-ID: <CAG_fn=XG3sGS-_ioH9ThtQf8TCx60vTJZ8Cj33OTfM7FFW62Og@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] kfuzztest: add KFuzzTest sample fuzz targets
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, rmoar@google.com, 
	shuah@kernel.org, sj@kernel.org, skhan@linuxfoundation.org, 
	tarasmadan@google.com, wentaoz5@illinois.edu
Content-Type: text/plain; charset="UTF-8"

> +#include <linux/kfuzztest.h>
> +
> +static void underflow_on_buffer(char *buf, size_t buflen)
> +{
> +       size_t i;
> +

If buflen is 0, buf is a ZERO_SIZE_PTR.
I think we should allow passing such pointers to test functions, but
each test should then correctly bail out on empty data.
