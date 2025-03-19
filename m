Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F4C1B3937
	for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 08:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742374073; cv=none; b=rxt3PFYrazh5oBkUtfh0cDdMola7PLbI6CgwmC9+1zjqYfPKd0RWVFLHDHYEayy+KsfG1NnnRfDCHIyb8dJ1/UqMH9FjHbkLvl4vXRi2mvYsSJ0e4hB2aDSORaiuP6PU+qnTGySJTjd5rzYVyKG9tHgO9arStBC0Z4rsWYG7IJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742374073; c=relaxed/simple;
	bh=VB+XYfxjd2Vs43pm8vkr7uALamILl1BBGLgL5P79zyg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hJENSIbUqvK9CG/+YrvU0ni/swViweSlys3pNPn3Mne7SLwnqT8rNCzO+fGTZcmyOUXTWZ33LCVhUudJBw72S1cA2DGDVeoy7TXHv370dCLdWBqueglIA+XkesRO/863Kg6mIkFjEbmm3zvuzLmn0/9Db5OVTWtb5Yf2sjo4l94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TrYqE+GA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TrYqE+GA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D82BC4CEF1
	for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 08:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742374073;
	bh=VB+XYfxjd2Vs43pm8vkr7uALamILl1BBGLgL5P79zyg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TrYqE+GAxVk5FJkvQWmXTGKV+5/CczhBwFuiR5DVFooDmFgfBILq1SCQRzKf3nhiA
	 yZjetmszWcqSlYm62uhZRW7ZkKmW8Jl84ISkE4PJFExsIes8z7Fq/iJN8WRfTilHLH
	 PifCubNmYW6W8h1LNgwxB5xemFDj9z29s8nIYhe8+3CPystHXQEYol73LVtMCukmZm
	 u+wCqK23Ju+lqPFfYXV2JQf5m9R8pJcfWBfKHRZkiTme5hUq+RvJOKUoEcvtsaSLoj
	 TAeLaZGQ88saobl8cnYHN7GNy1RWaKHApKErT+lsnbKD/LXL2sxH/5RWbZSnkBFxDP
	 OrguOqBQ5XZwA==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-30bf5d7d107so58220891fa.2
        for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 01:47:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW3z35n+gNetMfbzgjWRxSs5e8hPmAZuBQOE4ZTmfviP6h/yu2ev00p5rxo1EFJgtk27loog3fz1m2VASI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGjQageM7miWf07s5eTTxC2BqhYuBqfJtOyyfQVBLZ7CHy7WHT
	VJaetZeWaXJ1wanGXJJ07VMCd9I36P8wLf0K76uqJqIP2Tqc+XF30Zp+ctwzCi1laZRv0ZW7ZS6
	DH+8tMfMeFCy9Sr+8cckNnMZYqM8=
X-Google-Smtp-Source: AGHT+IE8Ahqnso4BQYlx/etNEC2vPQE0730DP4x7yDLiaYWGLwaJFeWjmWeVPFVhMOX/Tn2TsswRIFULwkGeg6w77+Q=
X-Received: by 2002:a05:6512:3b06:b0:549:8963:eb04 with SMTP id
 2adb3069b0e04-54acb1fe25amr383924e87.40.1742374071560; Wed, 19 Mar 2025
 01:47:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z9pfpHP783E3W6pz@gondor.apana.org.au> <CAMj1kXFxbUm1NUd2ogVAqOydPhcbU9GwnOhYnbuM9Tg8GNazwg@mail.gmail.com>
 <Z9p_0k7AsqZql-Ye@gondor.apana.org.au>
In-Reply-To: <Z9p_0k7AsqZql-Ye@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 19 Mar 2025 09:47:39 +0100
X-Gmail-Original-Message-ID: <CAMj1kXES_4oM2g9s8TfQaBSgx+whx4++mU2ZHX0B_rA1ipUOhQ@mail.gmail.com>
X-Gm-Features: AQ5f1Jp5neAI1XoFucuKd05biuuMxtS3senYzrCR_0C8vJKJClCtAl4GuonwBOE
Message-ID: <CAMj1kXES_4oM2g9s8TfQaBSgx+whx4++mU2ZHX0B_rA1ipUOhQ@mail.gmail.com>
Subject: Re: Cavium and lzs
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jan Glauber <jglauber@cavium.com>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 19 Mar 2025 at 09:27, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Mar 19, 2025 at 09:18:42AM +0100, Ard Biesheuvel wrote:
> >
> > Not sure whether there are any other SoCs that incorporate the same
> > IP, but the ThunderX SoC that it was added for is hopelessly obsolete.
> >
> > So depending on that, we might either drop just LZS support, or the
> > whole driver.
>
> Removing the driver works for me.  This is the last thing stopping us
> from removing the scratch dst buffer in scomp.
>

Excellent. I was hoping we'd be able to get rid of those at some point.

> Which is ironic because cavium allocates its own scratch buffers so
> the scomp one is only used because the driver isn't acomp.
>

18 files changed, 3794 deletions(-)

Nuff said
