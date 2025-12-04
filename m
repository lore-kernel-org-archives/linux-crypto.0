Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4C32D8370;
	Thu,  4 Dec 2025 15:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764863768; cv=none; b=OahbUDj8pU/4gGcUlAmo1mW+Lq4PPvbWIionqZc+/P/8LknfLpoVBtk2i6ugNuzM4QvI6job5yNAedBwgJ3QbwZk4Qd6GebtiSqvb/c6vtB0VPhhpDEGr1Xcl6e9RXVn5ZV4Ittd6L+4zUjKB1PpA+06trAvN2CobsgjlsE4rVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764863768; c=relaxed/simple;
	bh=LpA5JefkR0lHR2JO+irqCZhLEXB0ZXT4LnndG7Qv5YI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WORcqlZ47qraJWXHA7xM0Y9DNEztWAHmXcvGAZQSLwaKLXiLzKW694u296VSbnEeWmahVSNBuK1Ivl9rKoAH/vHWttwb8HoJKQSvqEvhWrRhzb/p7KwgleReRN70/CJcXo3Oo1TJzOK0d5aKPX0rX5foyapoAKVGNHNMMeGjTrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGa2TWiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGa2TWiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C05FC4CEFB;
	Thu,  4 Dec 2025 15:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764863765;
	bh=LpA5JefkR0lHR2JO+irqCZhLEXB0ZXT4LnndG7Qv5YI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JGa2TWiuqtx0qfMMAoyzyqOcsomqaHPrwe+cxr9K7pVsX9xsJOm472jN3O+eHBeDO
	 ghhbW0MwOtb1B71vgTaR1yoP3tS8+4xZCa5FzsdvAWjZUUZVYJNFS98DW8OEgUgUAl
	 k7S/KCqxaj6cI6nUM2JyX3oZsLFrsZ1XK62jQaHY=
Date: Thu, 4 Dec 2025 16:56:01 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marco Elver <elver@google.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
	Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com,
	andreyknvl@gmail.com, andy@kernel.org, brauner@kernel.org,
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com,
	dhowells@redhat.com, dvyukov@google.com,
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
	jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	shuah@kernel.org, sj@kernel.org, tarasmadan@google.com
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
Message-ID: <2025120431-squishier-cold-8cde@gregkh>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com>
 <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
 <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com>
 <CAHp75VfsD5Yj1_JcXS5gxnN3XpLjuA7nKTZMmMHB_q-qD2E8SA@mail.gmail.com>
 <CANpmjNOKBw9qN4zwLzCsOkZUBegzU0eRTBmbt1z3WFvXOP+6ew@mail.gmail.com>
 <CANpmjNNqCe5TxPriN-=OnS0nqGEYd-ChcZe6HQxwG4LZMuOwdA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANpmjNNqCe5TxPriN-=OnS0nqGEYd-ChcZe6HQxwG4LZMuOwdA@mail.gmail.com>

On Thu, Dec 04, 2025 at 04:42:37PM +0100, Marco Elver wrote:
> On Thu, 4 Dec 2025 at 16:35, Marco Elver <elver@google.com> wrote:
> > On Thu, 4 Dec 2025 at 16:34, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> > >
> > > On Thu, Dec 4, 2025 at 5:33 PM Marco Elver <elver@google.com> wrote:
> > > > On Thu, 4 Dec 2025 at 16:26, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> > >
> > > [..]
> > >
> > > > > > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > > > > > Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> > > > >
> > > > > I believe one of two SoBs is enough.
> > > >
> > > > Per my interpretation of
> > > > https://docs.kernel.org/process/submitting-patches.html#developer-s-certificate-of-origin-1-1
> > > > it's required where the affiliation/identity of the author has
> > > > changed; it's as if another developer picked up the series and
> > > > continues improving it.
> > >
> > > Since the original address does not exist, the Originally-by: or free
> > > text in the commit message / cover letter should be enough.
> >
> > The original copyright still applies, and the SOB captures that.
> 
> +Cc Greg - who might be able to shed a light on tricky cases like this.
> 
> tldr; Ethan left Google, but continues to develop series in personal
> capacity. Question about double-SOB requirement above.

It's the same natural person, so only 1 is needed.

thanks,

greg k-h
