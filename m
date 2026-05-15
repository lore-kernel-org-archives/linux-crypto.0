Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7BA3F6C35
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 23:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778886356; cv=none; b=d+RY9yUIPrpJVvLs3mNpFAY1nwq7NtKqWXI0qWJ4uGLsR5nQ9L2Ghw3L33WxpC1KsBDV9srCrHd1t6PEOlvG0NBcondEG/2qA0g1qc+XXf2zK1N8lFQiBpfux/FXgsSoGf8zNwjYX1oHikEk3ddRNoGBQdEUd5T6l+ycudMTm3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778886356; c=relaxed/simple;
	bh=Efl9eGRUvRUSMKgeJbT5viBCvrEY9UH6Bmru0k/SItc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qqo0jC0Qw4nGsfa7zO+ia/Ylgcc+jxD5ZQpNmQin+5O+hqhu/ObieWZ4LURM4pDL+Ob+qNlPJGGQvY1NXykmxisBb/6ns0/bq8+aWTsnEXWY4vsetdawpXLVIQopS6HB87nMTL3mET8lnUrnbFdBuSEJPLEvezyP1t95zvJ8zf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=VjGrlCzq; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="VjGrlCzq"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8b62ca1d28eso5086986d6.2
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 16:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1778886354; x=1779491154; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D7nklUCScqv2NitQOcHmOlp1LpHmTXVfX8MzcU0yUSA=;
        b=VjGrlCzqH+mUAoPngtAUQe7YHCLoMhJG1fiIHQCxDz32VqGSoi3tCJsSFgtxVM188x
         B1I46C1Bx8QQzngPeK7/vA6iCd3CpAt8owSY3Qk2nCELXf16tY5ju7NULVy1Bs7iU46b
         28cIKMzc8eLyongezBRMR3VmA7o08PT5Z7liMeIlm/EM5roeQ11TGTFe8o8pwEKpBde2
         Fsx6ppNY5QSyuK/iYmvX45MZQEdYg6mnwLgbubPjDSn55db4gxyjHGOWFH4aH1iAqKvc
         eCuseZOZeg7y7OGNf1zOhuZ+/BsETUblnI4pCL/GGB+CYb73uPazR/wccxYK74Yh0spW
         gQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778886354; x=1779491154;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D7nklUCScqv2NitQOcHmOlp1LpHmTXVfX8MzcU0yUSA=;
        b=qS2HDFn0X1/i2jtD77AfiLk2pd+uv0vXsS8jC0Z07HRMlr2zce/o5iBHHF3kfONHqN
         Wb9IUQ8zKrZlvvU6+K6Svuz+nb1XBogMbd4lpVx2bAFxqguu0vWmN9tT0VKQvfFF3qqt
         FCtuEBzFnGF0VIhEX4HzH1htGsEx8wk7KYiydguKhHHM469GYDe1xPv4ZCf88XnJiV+s
         Xg0J6HalDnNMTvZXau71lW/+yzWVlat9AQ5GBRof5cCslB5w3kuvF5Q+DfDAmPqL/BOz
         syyYg8xP1Pl+PDSKjwsczDx1Qyx4hX/DhiwFtf2MQAfBRX779EH2QMsFyWme3EtpDNVw
         B8jQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Nghi4IPWykoYYsmwk20dqjm1ET1wjN4i4DxYCi+JJvrzP1jPjf9ot9w4HeLJZaPKtlfw5mcilLTHOp6A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQIIriIDuuk4f+XPxRm9c7CphecEgCDICPscAwDWeRy6PaSccs
	HQ+isrvY0+uyDrbA2nK21WPCAWkv1XBMpMs1GnUNIlaYZjOzFHBJJcNR+tjdBfQxVLo=
X-Gm-Gg: Acq92OHQ0PwWWQskZ2e2vt9W2Ll02encfWYSpdXD54KYWlinAQEc4GRoLGGgB8jo1P+
	7Ni8iIQ23m5H4JrMSmd5EFsp6jdugGsuV4YzPg0gkTNLcZg2g74ImSoY6AnhcyhCrp3M5pvU1Tx
	bR2hiEoEyUhojlXk2e46SQNf6HcAgp8K/pTcUaMyMb7QYZru2r9CxCrh3f708E5askAl94L5wUI
	bUK37raldE+aMA/zzcfz8VF9Z9hX3B8VwFjWN5SclbM1rtAI16mDBm2NeNKf+qowvFZmIuFQH03
	P7T0RMs9DETi15cvObLd2v3lh7PJgBCCOmHAZwzLQOT2GqBJ/pQf55UEbAySzgEzkNB+Iv+N5gl
	QE8uZozni+hjFwnHiAjMUTWUmCNM3ICUPZ05YO1P7Ete+Fvm1sgkQkljgkxcdVtgkObtsTVpv8i
	FgZEn4x4+WhnBqoYVxSkNkLg/+ObfCdcWRAbNK99f9V0zXP/m9GSg47cAh9JpOHfPz7kKBRTI54
	s1D9A==
X-Received: by 2002:a05:6214:1c82:b0:8c2:b36d:4fc1 with SMTP id 6a1803df08f44-8ca0f66afc4mr87385476d6.14.1778886354080;
        Fri, 15 May 2026 16:05:54 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90c374469sm64030376d6.49.2026.05.15.16.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 16:05:53 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wO1bN-00000008GrB-0jOE;
	Fri, 15 May 2026 20:05:53 -0300
Date: Fri, 15 May 2026 20:05:53 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Ross Philipson <ross.philipson@gmail.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-integrity@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org, linux-efi@vger.kernel.org,
	iommu@lists.linux.dev, dpsmith@apertussolutions.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	dave.hansen@linux.intel.com, ardb@kernel.org, mjg59@srcf.ucam.org,
	James.Bottomley@hansenpartnership.com, peterhuewe@gmx.de,
	luto@amacapital.net, nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au, davem@davemloft.net, corbet@lwn.net,
	ebiederm@xmission.com, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com, andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: Re: [PATCH v16 01/38] tpm: Initial step to reorganize TPM public
 headers
Message-ID: <20260515230553.GO7702@ziepe.ca>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
 <20260515211410.31440-2-ross.philipson@gmail.com>
 <agemXwxVb9jvAbYM@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agemXwxVb9jvAbYM@kernel.org>

On Sat, May 16, 2026 at 02:03:59AM +0300, Jarkko Sakkinen wrote:

> LGTM
> 
> I'll hold on from actual tags up until there is some consensus with the
> patch set.

This patch set is huge, and I know there is alot of interest now in
DRTM.

Can we please split out and progress the TPM reorg mini-series at the
front?

Jason
