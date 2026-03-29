Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D2B314B63
	for <linux-crypto@vger.kernel.org>; Sun, 29 Mar 2026 22:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774825078; cv=none; b=SBDsLzW6toUXEtI5lCq/3eY1ptX+MbPQck39pc+ZulW7zIO+Il13Rui6EU+DkHUjn8j+tTVtPW/PX0xQB8+7ecvOx/blbRd6NaVTg4qwgx1L9gnFWOcnYUb8r0itOYToNxSByCj/vai5i8rkuXbY8V4wyE8uny6M9sdQ54HQlB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774825078; c=relaxed/simple;
	bh=DkXLUmcpu+vp7QMomsKqeu+nj8dpLA67HJln8CiZhFw=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jTUPSYXjDxTE+iYT7E7TuivyqGKL1KCBE4x5DP460wRima+a9UiLwfV/fVmWnflBZCGss35KJ9TUh0V5Es6dHbEbaU6ZVGhTqAzeFjAo9SoMmYRqjXml68MdTlyIq1HEiavMMui8CotNDahJ9aeL/71c5hWYxzRqBDxl/wvtORo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=code406.com; spf=pass smtp.mailfrom=code406.com; dkim=pass (1024-bit key) header.d=code406.com header.i=@code406.com header.b=Fbh9/3k5; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=code406.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=code406.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=code406.com header.i=@code406.com header.b="Fbh9/3k5"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-128b9b7e3edso1936119c88.0
        for <linux-crypto@vger.kernel.org>; Sun, 29 Mar 2026 15:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=code406.com; s=google; t=1774825076; x=1775429876; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EmjkZkbbVjjgaCUxuu5+nE0xjPd5gN1qT4GlMrecGi4=;
        b=Fbh9/3k5YE4y04oqhexqsWQeQ2Y6SKUKF3WuZwp0/6sj4phYuWiRBU/C08fCMQ2EHr
         BTyUJU8glTj+XLWy4pSTzGR2CL+smGXsOx1wY2z0jpGncGQmq+hfW8XyZbnfVMVXViUl
         GswqzKhrEh+7vquNe+fGCoklacbwOR0ccnIpI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774825076; x=1775429876;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EmjkZkbbVjjgaCUxuu5+nE0xjPd5gN1qT4GlMrecGi4=;
        b=j3LJTpqnujC03sizGfPw/+8lYYj2puoF9L2jGgglSqxR5fo5VTC6J/6tRi3ECUBooX
         jqT+jgkwad4PWydlfnI6GIJiBf25SbQcpnfgC1rzTTZV/ivxJbDY5AhoJvCfAoG4+D1K
         wScdP5RuhFPJKvuawoxK+5sfu525SdTPxjYSNYyMZd6T64fQmar26LaOmY9neFSi8PkO
         2+rSOIHzI5sx4uUKizbciL2TOretfH78/3qTRGNjBpkJ+uzr0d1KIrv0nay0IPRmgSvc
         lnEykoBexvIFUtBk+U3kYitkiSy2/4H+hZN+FsR9JJVGQ4zx7fs7PxETg6IsTjPoQctx
         ztKA==
X-Forwarded-Encrypted: i=1; AJvYcCXO5OkWggrEL3HuSrMQL196jtFhH6GXqTCdxsBEOo8Z+Nj4nC1ZCFwbm7u3xYDPGbgk4/vC4M8Wx3r61wg=@vger.kernel.org
X-Gm-Message-State: AOJu0YymcW88I2uHhRD5YSt/V+4T6kYuZ3bZxzOU/QYTSPIXtU+mGOza
	JveDs30ggq1oVkxpQTIbtwZY5qo9OCFR4Tdk0l6rTEEWN3g2gxxjjtQtrcfm/uW00w==
X-Gm-Gg: ATEYQzwQx0gH7vvfMe9fBvgWQAjafwxJgZHw3uzte4zoLNqUgY91OAxlbAkItet2Rj6
	lyTtc9HMEWBEPTtlvGzQQIdz+cL5T3epjmRuf8AyGzkda90zt+eps6S9sMirXAwI3KwcPZLSpyK
	76KxqygdK+LgvVXyBil1jeD8jXyeWx3jE0NdQi/vf5Ew203r1oiAZzxBXrnLEy8LAAtx3mpMKY9
	uo/EzWgQBRUpaoEMrQiB324PvQFeE+bCCwoNc1GzM42PPlsYktDGWjI9Q+cZ6Z6UddgeptoKRLD
	kWnh0mBvlrYtcdAQSeK3hQdT8f4m1cPsSuWKMqpqskwkuQAXBKRGmR4SIDr99RtQYgtpFrT5qeb
	3R/qc6q0h7rc6uzNJwY39VxLTO+0Ftzyyv2ud6RDQ/WZkGehIWtM8JXAj1MdUwkcl6JRZetbwEH
	kXNaiO4xOarCV3OF6Ci83mzXCuWoCjsLmqtFY/sNTxhVEMzYPC5EznmoO0SbZEQ9pdZc7QkKsmG
	+uR1uroK1iKPIS24oz5BhC/55mv
X-Received: by 2002:a05:7022:2209:b0:11d:f89d:85a0 with SMTP id a92af1059eb24-12ab2912740mr5861569c88.27.1774825075962;
        Sun, 29 Mar 2026 15:57:55 -0700 (PDT)
Received: from ubuntu ([2601:645:8a00:6e44:958e:90e9:e30b:7ecc])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12ab970da7fsm6096026c88.0.2026.03.29.15.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 15:57:55 -0700 (PDT)
From: Josh Snyder <josh@code406.com>
X-Google-Original-From: Josh Snyder <josh@cod406.com>
Date: Sun, 29 Mar 2026 15:57:51 -0700
To: Ross Philipson <ross.philipson@oracle.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org, 
	kexec@lists.infradead.org, linux-efi@vger.kernel.org, iommu@lists.linux.dev, 
	dpsmith@apertussolutions.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	hpa@zytor.com, dave.hansen@linux.intel.com, ardb@kernel.org, 
	mjg59@srcf.ucam.org, James.Bottomley@hansenpartnership.com, peterhuewe@gmx.de, 
	jarkko@kernel.org, jgg@ziepe.ca, luto@amacapital.net, nivedita@alum.mit.edu, 
	herbert@gondor.apana.org.au, davem@davemloft.net, corbet@lwn.net, ebiederm@xmission.com, 
	dwmw2@infradead.org, baolu.lu@linux.intel.com, kanth.ghatraju@oracle.com, 
	andrew.cooper3@citrix.com, trenchboot-devel@googlegroups.com
Subject: Re: [PATCH v15 08/28] tpm/tpm_tis: Close all localities
Message-ID: <v2l4v5imh2lmsayevxz3palyjeglpxo3qu475gjpchitgfzil2@l24ax4vevjp7>
References: <20251215233316.1076248-1-ross.philipson@oracle.com>
 <20251215233316.1076248-9-ross.philipson@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251215233316.1076248-9-ross.philipson@oracle.com>

On Mon, Dec 15, 2025 at 03:32:56PM -0800, Ross Philipson wrote:
> From: "Daniel P. Smith" <dpsmith@apertussolutions.com>
> +		if (check_locality(chip, i))
> +			tpm_tis_relinquish_locality(chip, i);

When I applied this patch locally, tpm_chip's locality_count underflowed to -1
and no IO was performed. That is because tpm_tis_relinquish_locality is
implemented like so:

  struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);

  mutex_lock(&priv->locality_count_mutex);
  priv->locality_count--;
  if (priv->locality_count == 0)
	  __tpm_tis_relinquish_locality(priv, l);

I was able to work around the issue by calling __tpm_tis_relinquish_locality
instead.

Thanks,
Josh
