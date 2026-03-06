Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5BD280035
	for <linux-crypto@vger.kernel.org>; Fri,  6 Mar 2026 05:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772775999; cv=none; b=W1Zjpx5FLZ8OSny1QeEQND9s2nDi28rX7zaH94keSWc+G4jpQVXMZA5C0UW8x7NS4CFEvdNT36zOowR/wscyDJgaIs43ziM3Es9XG+YYpdShOBrNuT+bQq+WbDzC8dVxRdCHuCa0V921g4G5KiNrPIQ/mURLYv6Y6O0mkW1UMHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772775999; c=relaxed/simple;
	bh=zzdM36DZXzpqXW2HCeVuTJfRUIds6cQ/vA2K83YiHiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=atlzjy6yiM0XU4ea/ihsKx68mRZnmUFOtk7uC9K2w2WbJ0d1YWI2zwWD0SlLjKNfzM0Q5pQYAdYS7XrUWJdsIv/YscZ6oQFAP/YcT11JBSZnts8gMxFePsm/r0/fvUVrQwEnNaBj5wr7JUpNAdnmMU7u6uqlKsYDRYry6SvMlF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AWrVqOSC; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AWrVqOSC"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c738b98bfd9so774155a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 05 Mar 2026 21:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772775997; x=1773380797; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8/SUdjzXEhgvW5puvAWCH8rFOth0bt7gLsKBvzrE17w=;
        b=AWrVqOSCF4tVsH3LKrViS0TBB/mCu+XfuJLol9byqdNwtRINAUv//iKW+aoip1jfRt
         dmR7waQY43sMsRDjIgZLU9mBhJ7RJ+KaZr95nKslNdwNxrMWS6GBMlan2DI6JnXzDjha
         Wazc/ANKIq3syQxP5u7N43MZnD4iCfybFbTIZILDhOu4Ukz74x+HpuBVCkUgBCNQMnhC
         8UmN7yOHo53i7Vg4eaMkvD9m6B8HbHHqT7InQomZpVDV1YQxxLD+KKOLr1WEMBjCNW1v
         ITc/VlT2RLKSD0A4kPGpDFE+U9eABBuSTIy4TbqVOnKaMcbxmEQOmxkyaavC4hi9GWzr
         Km0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772775997; x=1773380797;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8/SUdjzXEhgvW5puvAWCH8rFOth0bt7gLsKBvzrE17w=;
        b=lMzxlVv/ITZuqq2+76dOqrfUDLheNjoPx9XF2ArnqYsjK6Zpw05uXIgYPF73vbze9R
         d6z4pd+yfwK6kNWMwHDk9sC7ktU7Uq2v5Q19Su6fnuAzQUMxu3Qcm19dIEBeFUX+u8g4
         T1SyLNBm6zThKCWNhoaUR2JbBY7fsO3tnB7hQSC/Br46RTvtfN8QmJOqXFihiT5TySMj
         wI/bR3QxoDKUS4H+t4hr88i5tGP8E52A1R7JPnX/U+wD0rJc+Q9TKloeocXQlmgFqE+3
         gAvITRDC56uF2aOe2I1c8nG9QI0QrXXWr13rrtNdn2MV2hBCqt6MSv1J39DaWUcWo5eg
         MnnA==
X-Forwarded-Encrypted: i=1; AJvYcCUqyLTS0LWTY48DcrPwOvdGJV6UhGYsbaJrwt4qPjPhOjWE43Ar6MGgekH163Lu2WM8dvW7oMVfh4qrTKw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxA/iK511PorQ937XbUY9Hb7JfrGiEU8YBKNuDdIUTT/S53n/6m
	bLrLacRgazjjzNQZj8tiWBtypv+GZjChweSz79c2N2iCDBZc9JI2I1GR
X-Gm-Gg: ATEYQzyDqD7ClTmeyWnjkrQpg3qgdupiqKkz3iTfyjR3ZI5KA/wvQGUNqhGyPVYpLXU
	C9EljqMXKdvUysFZufMeeFQb3zKGC3r/Sad7A1socHACnIGb3KHihBKDxHQyAY+FppHYrfF8Vb9
	B/PDM4NdELKBRey/2Ra1Tp4ycQvLhh/YDv59cdyFpDc3VdS7iqX8y+8tru7e67/+Ymz1abW3jiT
	X5oTrciuiK2akHx66A9mxqvqAMREW8jFdLV/7EiXkBCm1TY6iS6ZgtvXhpoRZYnZa0pCYMQ2m5i
	Bzh60HafBBmBknCN0VDtfrqdlejhuKVBk6Dzojd1eNVJrE12N2rwVxFhhQPKuaTnZ52qTaMPOLa
	3T+BFkxNjaddhfegBwY/xu2xE2qZFSjgy9FYJvJ3BICa/Gr7uxDPy5ub2HPWiwAgCyTGRgDGviJ
	hA9PsW7P2DHgtSSZElDeKD1HXy0b/Oauwx4YlL7cGtgzhW1VURtDa2XN9G8W2bx2M=
X-Received: by 2002:a05:6300:4045:b0:38e:9405:beff with SMTP id adf61e73a8af0-398590de607mr1154590637.65.1772775997179;
        Thu, 05 Mar 2026 21:46:37 -0800 (PST)
Received: from eric-acer (36-225-117-207.dynamic-ip.hinet.net. [36.225.117.207])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e182d72sm424979a12.25.2026.03.05.21.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 21:46:36 -0800 (PST)
Date: Fri, 6 Mar 2026 13:46:33 +0800
From: Cheng-Yang Chou <yphbchou0911@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	catalin.marinas@arm.com, will@kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, jserv@ccns.ncku.edu.tw
Subject: Re: [PATCH 1/1] crypto: arm64/aes-neonbs - Move key expansion off
 the stack
Message-ID: <aapqOeRMJDmYc4lc@eric-acer>
References: <20260305183229.150599-1-yphbchou0911@gmail.com>
 <20260305183229.150599-2-yphbchou0911@gmail.com>
 <20260305193847.GG2796@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305193847.GG2796@quark>

Hi Eric,

On Thu, Mar 05, 2026 at 11:38:47AM -0800, Eric Biggers wrote:
> Instead of memzero_explicit() followed by kfree(), just use
> kfree_sensitive().
> 
> Also, single patches should not have a cover letter.  Just send a single
> patch email with all the details in the patch itself.
> 
> As for the actual change, I guess it's okay for now.  Ideally we'd
> refactor the aes-bs key preparation to not need temporary space.

Thanks for the feedback.
I'll send a v2 to address your comments.

The arm implementation also allocates struct crypto_aes_ctx on the
stack in aesbs_setkey(). Should I include a fix for it as well?
Note that I can only test on arm64.

Also, I'd be happy to help with the refactoring if you can point me
in the right direction.

-- 
Thanks,
Cheng-Yang
