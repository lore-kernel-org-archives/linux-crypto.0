Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC4186346
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 05:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741154305; cv=none; b=RPHzAwHM4VDm8/qN4xvkCHSPOqHCqq2E+0hyzvfUhvmFAIY4N/2wqN3zyYnf6x6SklGDtdXN/L3ZXbKH4ovVJfCYCZ5gAbmWxYccuJP+JBlIkQIFzBHjPrPkSGZfAQjE7qNsIBGCifccc92yXN/PgJoadQd/dt6QOrkKvK7awt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741154305; c=relaxed/simple;
	bh=1b1taHKIY9Unt2X1m50zUhII8qqe97dfQLOzfB1JlR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tMrLyjsgt60f2aMXhBUQYU6IGTnZAsJRG2nlgrA3uxIiZ1m7RC2go2RZdLfFELnpIQyWAR1SEblnO48m69cetc4muuIiC2BQBfTF/YzlkXxJ7Go6itqt0MokQpqUQqLqc9HatbDLjwWD5R9KLLIbWsgI9/PQI4WOvrICjPDjp0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ntonwrFT; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ntonwrFT"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2fe848040b1so13188549a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 21:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1741154303; x=1741759103; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WFx3HVx1ekj0J7+6k40k0Xz2bHIz2ICDjN2/6AA4QOc=;
        b=ntonwrFT0fANzzD31mYAwpdle0u3yUsYxboHB79cUoZs2fFPKOGSvzAPrSEKNP7B2y
         Zv4ycMhnzi70+ftviOgQBrkR6sTpHHkYDiuWc/inQL6+7o42HgQd+ht3hlpAkbbJWL57
         L9abkIjhyx76bnlvIHDA2er3rRGwP+0wYxWyk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741154303; x=1741759103;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WFx3HVx1ekj0J7+6k40k0Xz2bHIz2ICDjN2/6AA4QOc=;
        b=Y/yehdOLI8Zi07vd1sHz/kggQR8k0AJol7EhVSgxMwlLJ8TwR69GbqbS/7UGCaAZA6
         88BogeIFokpJX+TWm61dW751OI9d0r+jSMhUI6lHVgc32H7+ffUAWRGyCnuwCY4PcXRR
         B9fvY2FttSGFJCv/8BpzPC48M2OydWxmEYgMYuJY/fi5kVZzvNopVWSJeth+oGyIKDXM
         2vngsV5qgDR7iRM7KjtU6kMjIT5eN0nmk4itWa6gh9Qw/5f/zYFtcRTQzyId27SEVd1P
         r7Ck1AzuXQLLI8FCEFNd1ZpmGUgDO6FkStE/JrJDDAoPad3cwiciyAo8I79D3zI1mlm+
         jbDA==
X-Forwarded-Encrypted: i=1; AJvYcCWp8fTxiqd/eA083/znLibp9TAariCXTP9kbaMXHttQscgWi0wTJlZdEjw/tdnV5cGh1IldYLAAW7w3vWI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj3scRVMvip6Jpjffeplw5bh3+jjngbOE4qHE6HBTaE8TG27Yz
	h8zsjPl3M5zfOB5C8/5mpRgWsjqMt2zvZeB56ozjCeNjbVhpKPG18G7Epg7uKQ==
X-Gm-Gg: ASbGncu4Ho2l6gjUpyjGAKSBdSBX0xtbcnRUHSQgX+xs8e4D1ZBqPSXWbGqWAX579jx
	rNmmDYR4OkjNSL6we/JPM65JtP1kvj3286ZZNUpO9VSNIYDC/ifRnFpjqPxFCKkdJW5Vt8aO0Eh
	Pyq+vEretE/GOxJCuec0YkO07geaWQqCIWjYeDOpfq7Vmb7eKWA0a4DWpdmaIqJL0LnjJQ1Ki0y
	zEZwNwTe0w1tgAaVSGT//VzD8ahudlTvh/DLjaRQaINUlKbxsh6llfMFbFsZbNWCg8HLynh8xOe
	G2ayQkqJsBC3mb2RMa3U7GBxeWTPeVJsVw/ZiXMDOlOsIGU=
X-Google-Smtp-Source: AGHT+IH4q1lElOivsxsmEe6oaaT8+eRvKyjA6lSP10wHv71PZSCUZkWEAOHOdSfkrXVYKu/CiPicMw==
X-Received: by 2002:a17:90b:524f:b0:2fe:ba82:ca5 with SMTP id 98e67ed59e1d1-2ff497283aamr3582792a91.11.1741154303336;
        Tue, 04 Mar 2025 21:58:23 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:5a4:b795:7bd9:7ab7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff4e789387sm468858a91.25.2025.03.04.21.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 21:58:22 -0800 (PST)
Date: Wed, 5 Mar 2025 14:58:17 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Eric Biggers <ebiggers@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <fcjhjs3yp7odqskzvfzvovhdabov6hnilqnjb6rkvmngodqwze@ln2isck2a6im>
References: <Z8Hcur3T82_FiONj@google.com>
 <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
 <Z8dm9HF9tm0sDfpt@google.com>
 <Z8fI1zdqBNGmqW2d@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8fI1zdqBNGmqW2d@gondor.apana.org.au>

On (25/03/05 11:45), Herbert Xu wrote:
> > IIUC, what Herbert is suggesting is that we rework all of this to use SG
> > lists to reduce copies, but I am not sure which copies can go away? We
> > have one copy in the compression path that probably cannot go away.
> > After the zsmalloc changes (and ignoring highmem), we have one copy in
> > the decompression path for when objects span two pages. I think this
> > will still happen with SG lists, except internally in the crypto API.
> 
> It's the decompression copy when the object spans two pages that
> will disappear.  Because I have added SG support to LZO:

Hmm at a price of diverging code bases?  Is it really worth it?

And it's not guaranteed that all algorithms will switch over to SG,
so the linerisation will stay around.
