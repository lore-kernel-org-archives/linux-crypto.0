Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F4921CC78
	for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 13:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740750947; cv=none; b=lN1P4DC4upy3P+2lkqbYi/iiJme3GiWHS1wB0ERKZmXkN6oWYmpPI6/VXjsveR3Tm5dK6kEzDhE/3Fk6YzFT3DiuA8ovUCDPUUSrMcgvvDPjSOMGHRpUFYXiyD1w/5oyWj66KLca4M9ZunBLg6sRub5UNJG5KOirI+u2v+2FTk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740750947; c=relaxed/simple;
	bh=6KiL046IcV7uH4xRI2z1qU+xLJaii1QvrUMBLoolNY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i24zxkNMbobmp0W982kwivXrlPjXF9RwIjv75XfpDYPFxU6HX/ETxkXwAs8qg+Y14TwasxRgMXxIwYM+MGQFuHp2Y0zl9BvtYIHQA6+y2v8B61yN+n+3NIiT97tnIqZxXpQsn1HBLQI81oLZ1Vp6kl+BKEU/akQd3/lkie9JHwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=FgiE3iQG; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FgiE3iQG"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-219f8263ae0so39448805ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 05:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1740750945; x=1741355745; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lVLHs0XU5/L85VoyfMp71rmJgEjP4G3ZmDs/64PCKzM=;
        b=FgiE3iQGo8y+H2OBRg68qJf+vIYs8I4c0hKw0ye/svpM8VRUoofeslB0MHgFl5Jhyh
         b6r+eWdRw28VF35XtYS26sUohP3sqg8TGV+RL8mX8StvOKMUwLtn2KpUWbkQN7rdtsL3
         jzmbNv6QyJ8vk8zDSzdl82YJJSzo8lLL3CQLI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740750945; x=1741355745;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lVLHs0XU5/L85VoyfMp71rmJgEjP4G3ZmDs/64PCKzM=;
        b=e7Fb5wi+WsezjjptNU0Fm9mRJ+N3k5PnfiE6VtEsCGi+s4e8bK2Mi/IsojiGp0L1ws
         JgkiYeD+3CHKMg8xObzWco75FZ7P6GuljJO9lAcNQ56U8dM67sw0EF/CS+TDZ1zYlz6C
         qT7xFy7NwwIJaIZSuh6bRXCaT2O+1pBGfiTadC+KTlPs3F0ikEUgbBh6xyEVV6/OZ2uV
         vVcvl/X/ExCehLKAEpW8a1NgIwtReOY2PzjRZdgP5Vt3lMwfoeXlk0jAE4DydoYAZ6Pp
         xtqsgXjaLH4RK7EkOiA5/eXSFEOG33ExpWuEUeOxN/7WfvpBkvsDr1FgEptk+D7Tr2ED
         phxA==
X-Forwarded-Encrypted: i=1; AJvYcCV2opDK9pPzzd+EX5hznx84DkPa0wauI+wc3Ic+d+qTGFFjNL0oWuTuknvPq0wqSpmslwHDMcWy17kqFPM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yznp+hM2JGKU4oh4wnENxnBrJRd0XtMvXM2hCi9S4ikbz4MvEp8
	algiwoxLPQQuZIlK8KrU3/48OViJUgdFpM5rcb8G5qWh2SEm71bI6Ve5AmYT1A==
X-Gm-Gg: ASbGncufA3RI6IHC/f7EJ1EzSzzo8Pb5hOUBITXNjflZuDCr20GhXrBQ1VHHR4uUiMx
	dAfa/5KAPo8wVhVYGYpSVUOYtPrJWEVn7pSsDpQ6aYANU8T7RrxaDRE1tMHgHMi0UYYWil2WfzV
	uGWcJBm8dyQsSqyMzSR3B6Fxsw+lyh9vlrKrjapzxc2vu6AMBX/M8YgkkA3Y0KDdoU/3MKioa99
	TV4ti+GM6AfdnduLC8hAmNiSAlfgERGO7VNXZL2rr1/0emkgGKUm/1KS3Rt1HdBgwUjPvYyq2jT
	GNNVHdyfz2EesOXR+NuG7q+rNyastw==
X-Google-Smtp-Source: AGHT+IGvbZfjpoPwNPQ+FQ9Yq9mrH0LrYZtW4e1okF1P9EY+vAeuTKzzXKRAk0rMJFCPlq1yObgUJA==
X-Received: by 2002:a17:903:1252:b0:220:c813:dfce with SMTP id d9443c01a7336-22369213d1cmr51486655ad.39.1740750945124;
        Fri, 28 Feb 2025 05:55:45 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:2495:cd50:81fd:f0a1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223504c5bc6sm32607065ad.126.2025.02.28.05.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 05:55:44 -0800 (PST)
Date: Fri, 28 Feb 2025 22:55:35 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	David Sterba <dsterba@suse.cz>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Nitin Gupta <nitingupta910@gmail.com>, Richard Purdie <rpurdie@openedhand.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	"Markus F.X.J. Oberhumer" <markus@oberhumer.com>, Dave Rodgman <dave.rodgman@arm.com>
Subject: Re: [PATCH] lib/lzo: Avoid output overruns when compressing
Message-ID: <bnvklfvsoh34663ttsboec6aidxmu2cib32okb4vyi2iitdqme@lbvte54od7gi>
References: <Z7rGXJSX57gEfXPw@gondor.apana.org.au>
 <20250226130037.GS5777@twin.jikos.cz>
 <qahmi4ozfatd4q5h4qiykinucdry6jcbee6eg4rzelyge2zmlg@norwskwechx6>
 <CAMj1kXFKBynkfBFmQ1tbgZ0fTOP0pg5453NFGxVGvmePrKssug@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFKBynkfBFmQ1tbgZ0fTOP0pg5453NFGxVGvmePrKssug@mail.gmail.com>

On (25/02/28 13:43), Ard Biesheuvel wrote:
> On Fri, 28 Feb 2025 at 06:24, Sergey Senozhatsky
> <senozhatsky@chromium.org> wrote:
> >
> > On (25/02/26 14:00), David Sterba wrote:
> > > What strikes me as alarming that you insert about 20 branches into a
> > > realtime compression algorithm, where everything is basically a hot
> > > path.  Branches that almost never happen, and never if the output buffer
> > > is big enough.
> > >
> > > Please drop the patch.
> >
> > David, just for educational purposes, there's only safe variant of lzo
> > decompression, which seems to be doing a lot of NEED_OP (HAVE_OP) adding
> > branches and so on, basically what Herbert is adding to the compression
> > path.  So my question is - why NEED_OP (if (!HAVE_OP(x)) goto output_overrun)
> > is a no go for compression, but appears to be fine for decompression?
> >
> 
> Because compression has a bounded worst case (compressing data with
> LZO can actually increase the size but only by a limited amount),
> whereas decompressing a small input could produce gigabytes of output.

One can argue that sometimes we know the upper bound.  E.g. zswap
and zram always compress physical pages, so decompression cannot
result in a bigger (than the original physical page) data.
