Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E171A4F22
	for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 05:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740720267; cv=none; b=rRMRyNc/wIAw33POW2Z/WptZ3hfYzxlvUFG5n8ulYM645L0x5AA+zrMBgGy7SF1daBEU9KoF3TekwqzNeAJresgNqvpvcL0BHQW4TI9s/+Ba5gmHYLhy/MWp+r7EAVnESkMJU2TIYXEy+oefiil+zTkKSroBSNR4l51LJClu6R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740720267; c=relaxed/simple;
	bh=x9cRC7ppLMjJrTR1Lidy22LGkBVHgDO8qtmxXgLJn4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FdjIJtuJlleyaC2bDkKQm3ZXrBep83Ky9k1tkYj9zfnxk/JkKoKKVIpgDJzWhXTlVlgub5zO/1G4FeX+gZdDRA570Yu68da/rQUVKGedNuStCO/P2BueixwLrVESu+xyLlUO8UsS6QJiY1BRWqLcz4FOatoSswHdCDioc8UcOa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=dM7TKk/6; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dM7TKk/6"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2232b12cd36so24584445ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 21:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1740720265; x=1741325065; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JzpLqfQwDJ7jyiE79QfQ/fOYIxdjWxJGEJ/bicFu6Ck=;
        b=dM7TKk/6Id+qDj7FFPz4lMyCH1uIcIO8NC//1ed5QIN+xtSSPYVsbWWBxwZaL/DDgI
         evofiBMlwSn9Unr/XJgqQPysLdEBY+AUg/7dscjAe4Csy8albxh1ijzJ28OPdkzMSyy6
         aCMe5CEH8Ag7+H0wOZhX6imT70NwVK7qwIvV8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740720265; x=1741325065;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JzpLqfQwDJ7jyiE79QfQ/fOYIxdjWxJGEJ/bicFu6Ck=;
        b=PBHPHHi8dnrRwfEsYklkhNY4Nr4EdcU30A3VP+l5Ksdzg5Uw88NG6OZGXIIJS43QCk
         YtdYrTrqn0cFpRU9YVrFAqDzNLAZL3RYBaJOAcQ2/T+7dl5KEe8YZHgd3avrB4/5TH9w
         laRNitgomMr2UoMqePwkJqD4/JX0CmACwYfEynBsm4NsQjSFOmO+D07vVBDi4ZXVGogW
         QEjxCFVEwc2vGul+JBl8FqpYCEExSa3ZvE43fGx/f63WbyG9wmyZoCyJx8DsYVLWq/+y
         CbC6kUeiyvyqrLLipzohjCbdUYb8zAT51faWRwWqOfBn9HA8Yb4U/0DyMx7t9EdS6jKj
         FkNA==
X-Forwarded-Encrypted: i=1; AJvYcCVLbOJo14/FgjFommwNFVane3A6gJbjKFkuLQ/ijxgJTtn10jGoUhJlXlS69ywG/dzEMIhlRD6VHIrOfTs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi2T3wkOZykPSfGnZPTIbGuKjmREEtJoCxc5wu6kCbkvVdP1wB
	HYyXGTNNa1xMZn7anyzTRTqG91xjk5v+c9rqSUEw1AP1dOC3LRhA50edyuXMWQ==
X-Gm-Gg: ASbGncuqTDaCceQu/W4fdILDI/BC2dBS291LG2jqMnTDpLcy7uyYqkGxIi/eWyclEle
	hzevpT+iAuL6a1VkSnlSh4oP+mcFE8DF00meSveveHWXwQyFeK89aTZ5BfKAC+WP0yT40tTiqdO
	0yHM/t1Um29pwZ1jupQrkT0rf1XfMPDXwV2n2n3GB5oqcPw4IERhIaMAqeJEeWyY9TkrzwxuVAn
	nDLJpMPWtJ2UYlRIHhOlRqTiSEFQLc9EPIp5aO9BXFqN1poole/JY5IweUHnBEXm9npvKq6C66l
	Xx4bq1YoZ8DjJpBKWmJ6m1VOj5NBvQ==
X-Google-Smtp-Source: AGHT+IHXCM2oCqgzhkwLo+956UUpwtag8tM8m0CdPHYgDQClhrhMVkzcGgl7jqpntegvZ/SQHl9AeQ==
X-Received: by 2002:a17:902:ea0c:b0:223:54aa:6d15 with SMTP id d9443c01a7336-22368f7b08fmr34672055ad.12.1740720265138;
        Thu, 27 Feb 2025 21:24:25 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:2495:cd50:81fd:f0a1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501d2823sm25189645ad.15.2025.02.27.21.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 21:24:24 -0800 (PST)
Date: Fri, 28 Feb 2025 14:24:18 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: David Sterba <dsterba@suse.cz>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Nitin Gupta <nitingupta910@gmail.com>, Richard Purdie <rpurdie@openedhand.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, "Markus F.X.J. Oberhumer" <markus@oberhumer.com>, 
	Dave Rodgman <dave.rodgman@arm.com>
Subject: Re: [PATCH] lib/lzo: Avoid output overruns when compressing
Message-ID: <qahmi4ozfatd4q5h4qiykinucdry6jcbee6eg4rzelyge2zmlg@norwskwechx6>
References: <Z7rGXJSX57gEfXPw@gondor.apana.org.au>
 <20250226130037.GS5777@twin.jikos.cz>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226130037.GS5777@twin.jikos.cz>

On (25/02/26 14:00), David Sterba wrote:
> What strikes me as alarming that you insert about 20 branches into a
> realtime compression algorithm, where everything is basically a hot
> path.  Branches that almost never happen, and never if the output buffer
> is big enough.
> 
> Please drop the patch.

David, just for educational purposes, there's only safe variant of lzo
decompression, which seems to be doing a lot of NEED_OP (HAVE_OP) adding
branches and so on, basically what Herbert is adding to the compression
path.  So my question is - why NEED_OP (if (!HAVE_OP(x)) goto output_overrun)
is a no go for compression, but appears to be fine for decompression?
