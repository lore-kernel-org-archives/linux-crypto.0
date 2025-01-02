Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2061B3944;
	Thu,  2 Jan 2025 15:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735832760; cv=none; b=d+BRTpQEe5gkR6MxdosVXdFnRwC/S5/jtaphxIeY1qiyVjEFdwOyoICvbdcI0oVv0tAKMahQkzhmlJj5Wncj/6HDSFvTIbDcIGDmlpbbLdnfHakSqzCHyhQ56cMtvi+eY3A8wrI9DC8p0+W3vWqtLd2hWj/oZ1cpqa9TC7YbCj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735832760; c=relaxed/simple;
	bh=Gt9IgQcdS6zTtWyLM76yOke5d3ktR6jtS0PEnFYEGhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKYZZZiVDqtko/MdoHbouoM9Nh0U6Yn5Idzz1dyz8gf3tFFe14JGr2QzZv2hmzqVSnVKsXxBDaGwJcyxEx7mWTc8iOJqaGTAKxt6gca3gu8bwQgAJHVt5eJjC/hGe1UQ/0/toBYxjHHIjl38OEtJwzbQRsr227QeCIQONy5FT0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aa6a92f863cso1936283366b.1;
        Thu, 02 Jan 2025 07:45:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735832756; x=1736437556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h2g0ivZyP4Gq3elbBwKgtWXwEWLwxdsNB8Grs3eMANo=;
        b=E/UmTHqmunWD5mgrCEqRL4Qo7UMv3IaAXGGMZHlXftcUfWo+J9XBZllAR0w0fI3EBI
         2zmLsenR+PrFwdx8PoWNfNyWCkI+cdkvsEnWrRVu9XgZ5s2B8N23CWUpgKlz54QGlcGq
         V7qg1qs4T/0t0BpKAQ3CCSPd6bbJghv6GfkvFNNOwI+RR9a/FV6DJ+7XX8rSoMtfoVoB
         iOD6hWHrwTiDo16JZB9XhxjQOK3NSti7TToVO9Yj66pNErbBkdlFLGS0hI4CQX3R3XRl
         fEBSpGaqovFdXyLGIthQND689rzPbk4ln854M8lUdWnOn8pilsv5hfPjMHfrfH6+ZsGe
         FT/w==
X-Forwarded-Encrypted: i=1; AJvYcCVcO7dSqGJfmS3VKiOf76lRC71IW63qt4PAEijjkAc57p+/nMLrR1WhTr5a13+xc3IvThXovOrcx22/OVM=@vger.kernel.org, AJvYcCXwCGIPj9bPfKl/b3Ih5QtscWkm/26LLqM4a20IWH+XUtyeIG8IO0KASC4LsPcIaRVVMb2OHoBQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwqX/+IdZOwRjWfBvMQzSs8amqDGeRSD5zBLV+Z4uSqeqJ05q1V
	I3SNEt2HdfIEHAQ7+E5Ga41EGgsfGSP8nXu1RXquFB3n1Xsbx4yoiJz7AQ==
X-Gm-Gg: ASbGncvs2Eff/HEnYK0v1eyEzCzr7CAKlbvB7591Hwe1tTsVjbeWFY3J8C1ItQC1Ifn
	Jh7NUAE4gxD007nMNHIF/yvId+Hir6752qqcN8abfKX4NpUBk4BruU6rSE4+s26pFEUnL8cdIO7
	wQVNlpv62RCXm5NTvWradCaIosZu2JFLnrEThxJshxrE54SxAZy6ywJJp2L+klCDpkz7kZXtUq2
	O9N5MSkoIHgbHv7fOFG1+7rkZtm4BesgERPDINKxSEYT0EI
X-Google-Smtp-Source: AGHT+IF9Opy0LyTeLf+WcovwqPhZVqY0yducz1jeXl63C6Qhux/jKU7KQXgPiT1DvlqzIjf2tKzdQQ==
X-Received: by 2002:a17:907:961f:b0:aa6:abe2:5cba with SMTP id a640c23a62f3a-aac27026cfemr4744580766b.2.1735832755949;
        Thu, 02 Jan 2025 07:45:55 -0800 (PST)
Received: from gmail.com ([2a03:2880:30ff:70::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f06629esm1800682366b.189.2025.01.02.07.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 07:45:55 -0800 (PST)
Date: Thu, 2 Jan 2025 07:45:53 -0800
From: Breno Leitao <leitao@debian.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Tejun Heo <tj@kernel.org>, kernel test robot <oliver.sang@intel.com>,
	oe-lkp@lists.linux.dev, lkp@intel.com, linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [herbert-cryptodev-2.6:master] [rhashtable]  e1d3422c95:
 stress-ng.syscall.ops_per_sec 98.9% regression
Message-ID: <20250102-bizarre-griffin-of-attraction-c1f728@leitao>
References: <202412271017.cad7675-lkp@intel.com>
 <Z3HTN1gvVE9tfa4Y@slm.duckdns.org>
 <Z3XndzXUa9KYYz9f@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z3XndzXUa9KYYz9f@gondor.apana.org.au>

On Thu, Jan 02, 2025 at 09:10:15AM +0800, Herbert Xu wrote:
> On Sun, Dec 29, 2024 at 12:54:47PM -1000, Tejun Heo wrote:
> >
> > Hmm... the only meaningful behavior difference would be that after the
> > patch, rht_grow_above_75() test is done regardless of the return value while
> > before it was done only when the return value is zero. Breno, can you please
> > look into whether this report is valid and whether restoring the NULL check
> > makes it go away?
> 
> Actually I fixed that when committing the patch.  It should be
> conditional on whether the insertion succeeds or not.

Thanks.

I am finally back from vacation. I will try to reproduce the issue
reported in this report, and double-check the regression.

--breno
