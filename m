Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A91123AE79;
	Wed, 16 Apr 2025 09:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744797357; cv=none; b=H52uFpG8+qbibzWRENYC+lwqnroaKTq22oI/wCEP7huVBY4gz77hEpOiWqzSaB6tWR2n+VBmwUfTI5dZJwScwQIPT5kJqx4sJISfvzOMn8L1W/mupTY+gIfgAYiswAsZe3B30urg3u3aJb9veJwGeQeafS6jOHMbTWoKOZXGZJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744797357; c=relaxed/simple;
	bh=eDDs43dEmiFVlnLk6aV1gwYevt0KcicPW6D8DnobW7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HlUU4HfLIzp6IFHbtlDmXVAHLz5ZVVgodbAqXZREHKZc2/xPm2NzNgoMAyoIobew7DFW/N3c7nbdMIODIWiqllVb7YFDQ3b21jfHlZR7pZiR2KIP99RdgHNhlzKdgG0MN0bw9ms0ZfKfw71GxhKzLBe+aNohdOdv6SP5GM2mPBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m9QDIN57; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m9QDIN57"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43cf0d787eeso75377495e9.3;
        Wed, 16 Apr 2025 02:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744797354; x=1745402154; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CFOCTI/pVmuX8N5R8+4QyY9BGqjF4fNy/dpUPF7Hk3w=;
        b=m9QDIN57NI/RJsXogHV97ps0sZc9p/bN3lBVaJFDVLP+MZp8q78XD2gfrAdpPtN01I
         kAQ/93uYtU8TMCtYjl8B99fLMJPFwCiYZ+kYfbNlUXCnVMz9nTI20SgyEh2j2v1kAOno
         payQtDhkpHtVRIsKLJGSGOz+tu7DuTDz6Owoj/fiZs8aRg5cMEXY8LVBKkjk86UqkEuH
         eDP2L73RLMh/EyjpL0P0yhf9gv8lLasMyU0iQmsdv8J0JPnuGCKV2bWyO98dT+297ASO
         Y+QDGy2GH2SqWbpaG5qsHpphrzxdfFIzm5KnH4yy+1QMyIBBZSrV/fTnppzZ0eMXTfFG
         md3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744797354; x=1745402154;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CFOCTI/pVmuX8N5R8+4QyY9BGqjF4fNy/dpUPF7Hk3w=;
        b=YaR5nKUsvvjeE8iH9aTPP0RATWvtEPKBj/5D0aVU9b2/TawDNrZ7Ruz8hupubls9WS
         CMML6iYuDVcK54OUUgVrHM4VDd4GRdU0ZojwV+JzeB1y48XcrQiI2EpdDA0hd8qU3Zfk
         WCXYqT/idilYnmT/u2mB1N1yf2IXrCCRhH9qemgCAcOQCuSQQz2TJznsKSZQVr0tlfNl
         +EDIKgKE9J/S0v8pOE8ioxBVWeR4ACEnfwIKevdzCtzM0AkCBAbZH41YFtBPvETYgPxR
         3fuTj6wTo2lHuqzBG5OYwO6tZXidzSVc42qfdRZJZoE7/kwbQnOcPfc6cYfNHjokSQHt
         fVwQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7eOJiZiG973eZTpLiByZpYlISjwxAOXNcNbjos5rh+KJ/mvAuAGL4H+Rh0S/IAeVMaNKpV7vwnTpkqfM=@vger.kernel.org, AJvYcCXyvOfUoJsM2MWKmEEtry5G+kGmPC7Uef5CJ/mVCJa+Fw84IqgMpJTwfbGjS1iymCVHeLGjlp9+YoTg7sCm@vger.kernel.org
X-Gm-Message-State: AOJu0YwM9IuAy7WKGswnmimTctAxoOyGdE7OVMd022Xp2MPOcA9pFg3I
	vFaW+pnw6tAuOvDMmKWkkNVqqommXMJVCWODwmk69PB0OGGweuZr
X-Gm-Gg: ASbGncv+XeKiiD5Erymuye8RmZFdmJNQYcJ+kqpqe0jWxMDhwlCmYS/KECTOwnoYqDG
	BqndpWMQ3NlzUNsEgUXnJ1QHdYXYwWFuZABXRGJQLEgMDCtR2NCWfp338d/YWrM+zCmHrWXgQR8
	b/vsVYee1gljE39QU0enb6YxOA6lGlkeKQr63hQNts8PELcg8wwlRe7vND2EgVTaRR2BCA3saZR
	7PApykEBUlb2kc0HWGk3yUEeY8XUzDqKqenzmxzAaIGPro5AZKIicOXnfglT1XUicFjGxubei2M
	aKvGMt9HbnUzGrPMR/XrcpGMHfZuPqOCjPHt3P+uBoMsmr8ylvzA
X-Google-Smtp-Source: AGHT+IFakZCLJe9/p0oIcP9EVvp0XPStGbEzGdVK/8A3vzfhtwwJ3pEkUIOAa93Xu3jpLcKogUzb/g==
X-Received: by 2002:a05:600c:1994:b0:439:6118:c188 with SMTP id 5b1f17b1804b1-4405d638b04mr9926565e9.19.1744797353330;
        Wed, 16 Apr 2025 02:55:53 -0700 (PDT)
Received: from Red ([2a01:cb1d:898:ab00:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4405b4f3227sm16102365e9.20.2025.04.16.02.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 02:55:51 -0700 (PDT)
Date: Wed, 16 Apr 2025 11:55:48 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] crypto: img-hash - use API helpers to setup fallback
 request
Message-ID: <Z_9-pJ_lXA3AzjGC@Red>
References: <20250407123604.2109561-1-ovidiu.panait.oss@gmail.com>
 <Z_9ie2KwYhCaK_mB@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z_9ie2KwYhCaK_mB@gondor.apana.org.au>

Le Wed, Apr 16, 2025 at 03:55:39PM +0800, Herbert Xu a écrit :
> On Mon, Apr 07, 2025 at 03:36:01PM +0300, Ovidiu Panait wrote:
> > Rather than setting up the fallback request by hand, use
> > ahash_request_set_callback() and ahash_request_set_crypt() API helpers
> > to properly setup the new request.
> > 
> > This also ensures that the completion callback is properly passed down
> > to the fallback algorithm, which avoids a crash with async fallbacks.
> > 
> > Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> > ---
> >  drivers/crypto/img-hash.c | 41 ++++++++++++++++++++++-----------------
> >  1 file changed, 23 insertions(+), 18 deletions(-)
> 
> Patches 1-2,4 applied.  Thanks.

You can merge sun8i-ss patch, it is ok.

Could you add my tested-by on rk3328 patch also ?

Thanks
