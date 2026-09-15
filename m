Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EF54A8FD8
	for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 18:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789496935; cv=none; b=S0IC5kQfw5AsTlo0nOlPTUatzFoqLJ2pHq28JYMIsWTohoJhFgyVsMdI7JmbgVs0bQePd2L5dHwFgOMTBQXQvYH1ZVmCwuGVxqs7V8F9/42nfMkdQ0S+FMM40l9HjBAQXMJa2O7+d9mVh+PHZ9bn/70a4TzNB1FB/u2bv1TxUqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789496935; c=relaxed/simple;
	bh=ExaSFTGuyajSGkffCmNiiOT5gX4RugpQ5HKd+MnvrqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=STkW+Hd2eKFsxaZ7rqwbCOf1qaJRow65ekTEFS+aAUAXISN9cnnkINlPij0reshcg0+o0xkCmFSzilsrVJjLrOXBOKPt6LHiC+nCPBkhn4Uo6joqepISCHjjQpysa1UHX6VGiidWZga8eTDNjnECdTixSKttk5y8r8mqszXsVdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jh54XB8Y; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jh54XB8Y"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-48437356d60so8322f8f.3
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 11:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789496931; x=1790101731; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2OVh9TORSOFM2eLBFL8+9fGSDQsNIFtP4Ssj+M+8PKU=;
        b=jh54XB8YWCe1aiMSLkQdoBxdEiOsF67lTi+047bm/pHMz+mYRwDd33G8uIgxpNCm/4
         DQbRGkukQDu5Tz4RsHIVbiMmaKe27za/IegnbSbl5jE7E0NNo5QiG4Q1nLR5SyBVHqX4
         AWu6+I1d/vcDZH5OmIZK2+rWDHDcn3QTX2GZ8shYKqParQ5C/H1YHGodOc7IyrHhEgL4
         lDyFUZZH1RhY/BSmwLYORiaPe4KvZ2DJaZ0sjUaBz8/2hIjmacg9uQ7ow4HbBGX90cCD
         ieWbBJjc4dNm9gxAe5kDBgfmZedaVM/8v5ktwn9TSwwRfrdFM3x3AoscqG3ahlh8NDUC
         AZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789496931; x=1790101731;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2OVh9TORSOFM2eLBFL8+9fGSDQsNIFtP4Ssj+M+8PKU=;
        b=tKGIqIpQjP3ddUaKLyqtYmtGBqTePOe2hJPXrXJN+iFczEZY0tdM6OutTvZXCEdX7V
         ImTBvj/xqQ5elQKiBQmdsgWdrmzjKOHHuCg927rwvdYN5xCch8TYCs/xPG/KxQy0avro
         09pgE2SRfYvDdhtNjrg7QWDb8QwwqBrE1TXrkSdICyQ5jgfqv+422EbDz+op2qlAoRlF
         HNy5jbwKezxBmYQdmhwRi2y4Jgzw68trzEoJYYQZw3XfFoNgqchkOuqANbk/aAjkepO7
         GHnShqULlcYiTQR7dEKc10eQfr9Io5YyiWrtqFizvJrBe3WLzeCRe279yC9tjly6gKMG
         WnHA==
X-Forwarded-Encrypted: i=1; AKwUvBwxWU07bJ5dSHfbmsf9PWft/1nPZLJOWW3qlN/OPf9d5sZuQmYBBDtGWxBfGJi1M6daPXcKpOVzLoABVbA=@vger.kernel.org
X-Gm-Message-State: AFuF++kPl3lDi0Rq+FCrZvNybg96gjRfKd/EGhovlnmtdUiEL9QQqijf
	AUIT5zI77TDLaZCq9xMip7nQ2xUJmo6r+XQpvKfB4gpgmJHnsxVzTdDc
X-Gm-Gg: AYBFou2UVWTsEJrh9uT7/uqC069FKL7NkZqjlEUQzGxVxeNnEG6qqt9H+CoQwAB0GDB
	iHS+0cANhDvhS3sorYIcVQRj1ngfWs0yw8pW4PxfvYn0b6iXjlQXc/vVITXrezS9bdbv/BOmI69
	UCC6iTbyDxPDQ8C8WhkVELSKuZ81jKaFRGQnSZpc68cFIc2GMhXm6Swytvp8+p6JmuIFXA6v48R
	l9VIBC8mpkbk/TZk6qeDMJ4GXUPhO2Vao/6+ca1VVtL5J3EW/kFWooMvKaZr/4nwn4CIKfuK3NF
	AG5QYL7xekUkVc4AC4o6BhvkvMfpDsiMm/BU8dimeGy9MDiIOy7wSfYvAXBgKmpoQT2RNuW3M4q
	LmPV6zZUZ/boFUne2LXDSdG48BSzcza69zF6anM+sVF5HytNA5NkIZemdVuhTNFbJitpMNv62fN
	564Qsa7pM/pxzuulQtrmCexZedjmiTGMZOv1inNfOG2ZUQyHhSl9Jhb7nzZTnsjFUMq6wj1tWHK
	1Wn3TDdqkNuiVURy2yXBmLpksFw+GgUVdo4XCxdR+30G8efPSkW0eNN9ZIyQOGBXB2ocbWuXg7B
	buZll1Zxyh4g1eHdsuQBRMDE8SjtuUYjA4veD5iqHWtijHPxaSefPD+ug/UUhWWvQvuhTJdDgfz
	D1JZ6WX+1jvXL4SdftUwEEg==
X-Received: by 2002:a05:6000:184a:b0:487:bef:31a8 with SMTP id ffacd0b85a97d-4870bef3228mr766622f8f.0.1789496930649;
        Tue, 15 Sep 2026 11:28:50 -0700 (PDT)
Received: from MBP-von-Karl.localdomain (dynamic-2a02-3100-afd5-c801-ec9e-1a2a-2fc8-3f88.310.pool.telefonica.de. [2a02:3100:afd5:c801:ec9e:1a2a:2fc8:3f88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf1fe7esm805784f8f.6.2026.09.15.11.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 11:28:50 -0700 (PDT)
Date: Tue, 15 Sep 2026 20:28:47 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Haren Myneni <haren@us.ibm.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Dan Streetman <ddstreet@ieee.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <david@davidgow.net>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/3] lib/842: add KUnit tests for the decompressor
Message-ID: <aqmN7Wt4f-DXGEhn@gmail.com>
References: <cover.1787978627.git.kmehltretter@gmail.com>
 <e9659617ce2f1466f227d562f47b961f340ab3c7.1787978627.git.kmehltretter@gmail.com>
 <CAMuHMdVcZ5cV4-HrjLYfFKh6UshiVxq5eXCNyp0Z1k_SMAvF5g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVcZ5cV4-HrjLYfFKh6UshiVxq5eXCNyp0Z1k_SMAvF5g@mail.gmail.com>

On Tue, Sep 15, 2026 at 02:57:55PM +0100, Geert Uytterhoeven wrote:
> > +config 842_DECOMPRESS_KUNIT_TEST
> > +       tristate "KUnit tests for the 842 decompressor" if !KUNIT_ALL_TESTS
> > +       depends on KUNIT
> > +       select 842_DECOMPRESS
> 
> Enabling a (modular) test should not silently enable additional kernel
> functionality, as that may increase the attack vector for a product.
> 

Hi Geert,

Wow, good catch, thank you! I'll prepare a follow-up to fix it.

I also found a few other KUnit tests using the same select pattern,
so I'll look into fixing those as well.

Karl
