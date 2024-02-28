Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524835E060
	for <linux-crypto@vger.kernel.org>; Wed, 28 Feb 2024 20:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709152627; cv=none; b=YEDS9PeUcBOmWnAGeYD6VLjFneodDH8CTuJngfvUiM5KcAgRAV71+y/j4hlNbOlGsT1xspxzpnjHERIQgM4eO2juOE9HoIBAH29XAyEYgdPunB/J3EM8eV6t+az06hC2vN6SVE8j72ZcorHiU4jpwKloc8JDZtzEd4q8IOA+jhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709152627; c=relaxed/simple;
	bh=/4o6M1gCjRC/ElEaDP4uEODFHI2uKiQKQbqnQf/kvHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ljj/ISfRHfRqcRsGrantgCgycFUOFec7xqZbwzqvNqpgdMXkaWAe/lO2O33XDbNWrB/CxNoxub2NPtAaZnofkyStUVlbzTwIvzEkhs6tESXa3DFUqROtN83hBrj7nS+zzjnTsDXM1y82qARfe8gKE+1bp4PpCd1zWxqZl7HqKf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=nAbKtM9g; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="nAbKtM9g"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-33d6f26ff33so129790f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 28 Feb 2024 12:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1709152622; x=1709757422; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Zsi/fOHIEq4EBRWrVheEmgSkmu2TJnXYcW2oJX15Fr4=;
        b=nAbKtM9gaDjoQLqUC7CKyZQIQhZF6fM9Hgurj/uGa1QQXH2dKGPLuMxFo90ZQCL8X4
         m8WwyydKC6UORP8jWAquBHGZL1+BNt877bf10Tgl8DM4pBULsv0slUm3VvnSa7O3i8pD
         4CcWaSY5+UO+ooBEZWgSlyyDcIJKDYtVErVhljJdjPO54FA4IsWtWtKwmCb/LaJOktwD
         0M5pBPAASgj2xPmfTLc6CKa+Yfbye/oWwIHs7ZYd5CrXPTjrzAiGyIa+jz63xPhu6cvm
         WsgGtbFclo0t/+rh+N2KM7dIrJ+KXHu9EPh272s9bRLWn+oWAOUqaG0NhmSyp9aRvQwA
         4LUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709152622; x=1709757422;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zsi/fOHIEq4EBRWrVheEmgSkmu2TJnXYcW2oJX15Fr4=;
        b=ugwFzgHO8gxMp4n4tB/ZMxXwnbEKK/Q/IBhkpO1Wu3gOf+DDin0j5Bc5+GbDLnXFPH
         YF8tdrh55SoXaFZreGDOtlGw2eehV5kySM+Txpyf8jIaw2R2AGozANjyRtvOrkJ3xblc
         wILPunXY/Jt4/W3UA/Ur4FvYku1TC1fwuhbWdeQl9v3xktB9bgTObLA/EjysvymcNQlc
         AZBNyjzsUmE8Mx8wUehdjRZuVP2CX4M7rj2A4KGazsexLjWjhXYSdiV/vi91QqQPTAha
         Nt0ARUG6lp9DNrBDYm5feENVTT/G078JErhH2zxLrUfTVFsfT9xdP+EXoJmLCkZZMore
         EUtA==
X-Gm-Message-State: AOJu0YxxWdC3Q5P94W5Ziadcd8s+jPGXvbBaUOH3L4pLp1JCnNAoROUH
	RjesPJwXOaMR9+4jBmWDuRRq1oj6PhAAMz3PrcDcUVvcSksgkwWV4encxCQL/cAcPMFrIPpDAfd
	c
X-Google-Smtp-Source: AGHT+IFRR8tEO+qMOv0fMGBCosIt+n3klumnNwoIn8fSJczoUvJL73vxzSbiNaJ3VRxWWI+0vy+wZw==
X-Received: by 2002:adf:cf0c:0:b0:33d:274b:ffc7 with SMTP id o12-20020adfcf0c000000b0033d274bffc7mr491706wrj.46.1709152622556;
        Wed, 28 Feb 2024 12:37:02 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id az14-20020adfe18e000000b0033d2541b3e1sm16350316wrb.72.2024.02.28.12.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 12:37:02 -0800 (PST)
Date: Wed, 28 Feb 2024 21:37:00 +0100
From: Corentin LABBE <clabbe@baylibre.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH] crypto: remove CONFIG_CRYPTO_STATS
Message-ID: <Zd-ZbEQZEGU7sWbY@Red>
References: <20240223090334.167519-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240223090334.167519-1-ebiggers@kernel.org>

Le Fri, Feb 23, 2024 at 01:03:34AM -0800, Eric Biggers a écrit :
> From: Eric Biggers <ebiggers@google.com>
> 
> Remove support for the "Crypto usage statistics" feature
> (CONFIG_CRYPTO_STATS).  This feature does not appear to have ever been
> used, and it is harmful because it significantly reduces performance and
> is a large maintenance burden.
> 
> Covering each of these points in detail:
> 
> 1. Feature is not being used
> 
> Since these generic crypto statistics are only readable using netlink,
> it's fairly straightforward to look for programs that use them.  I'm
> unable to find any evidence that any such programs exist.  For example,
> Debian Code Search returns no hits except the kernel header and kernel
> code itself and translations of the kernel header:
> https://codesearch.debian.net/search?q=CRYPTOCFGA_STAT&literal=1&perpkg=1
> 
> The patch series that added this feature in 2018
> (https://lore.kernel.org/linux-crypto/1537351855-16618-1-git-send-email-clabbe@baylibre.com/)
> said "The goal is to have an ifconfig for crypto device."  This doesn't
> appear to have happened.
> 
> It's not clear that there is real demand for crypto statistics.  Just
> because the kernel provides other types of statistics such as I/O and
> networking statistics and some people find those useful does not mean
> that crypto statistics are useful too.
> 
> Further evidence that programs are not using CONFIG_CRYPTO_STATS is that
> it was able to be disabled in RHEL and Fedora as a bug fix
> (https://gitlab.com/redhat/centos-stream/src/kernel/centos-stream-9/-/merge_requests/2947).
> 
> Even further evidence comes from the fact that there are and have been
> bugs in how the stats work, but they were never reported.  For example,
> before Linux v6.7 hash stats were double-counted in most cases.
> 
> There has also never been any documentation for this feature, so it
> might be hard to use even if someone wanted to.
> 
> 2. CONFIG_CRYPTO_STATS significantly reduces performance
> 
> Enabling CONFIG_CRYPTO_STATS significantly reduces the performance of
> the crypto API, even if no program ever retrieves the statistics.  This
> primarily affects systems with large number of CPUs.  For example,
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2039576 reported
> that Lustre client encryption performance improved from 21.7GB/s to
> 48.2GB/s by disabling CONFIG_CRYPTO_STATS.
> 
> It can be argued that this means that CONFIG_CRYPTO_STATS should be
> optimized with per-cpu counters similar to many of the networking
> counters.  But no one has done this in 5+ years.  This is consistent
> with the fact that the feature appears to be unused, so there seems to
> be little interest in improving it as opposed to just disabling it.
> 
> It can be argued that because CONFIG_CRYPTO_STATS is off by default,
> performance doesn't matter.  But Linux distros tend to error on the side
> of enabling options.  The option is enabled in Ubuntu and Arch Linux,
> and until recently was enabled in RHEL and Fedora (see above).  So, even
> just having the option available is harmful to users.
> 
> 3. CONFIG_CRYPTO_STATS is a large maintenance burden
> 
> There are over 1000 lines of code associated with CONFIG_CRYPTO_STATS,
> spread among 32 files.  It significantly complicates much of the
> implementation of the crypto API.  After the initial submission, many
> fixes and refactorings have consumed effort of multiple people to keep
> this feature "working".  We should be spending this effort elsewhere.
> 

Hello

I need to acknowledge that I am very probably the only one user of this.
I wished to have done more and better, but this is clearly a fail.
I am sorry and you can remove all of this.

Acked-by: Corentin Labbe <clabbe@baylibre.com>

Regards

