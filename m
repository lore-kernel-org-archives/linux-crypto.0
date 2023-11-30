Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CD555772;
	Thu, 30 Nov 2023 16:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ep5mfn6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C48C433C9;
	Thu, 30 Nov 2023 16:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1701363418;
	bh=jNTamNThZ0rAs2o+KORaTzGsMmcQ2kdIW/zV+pisW9M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ep5mfn6/d/046KNhMrPxYSVs2b/H1SbZQJJM57P3hzC8hmlHC+aL7jEbzQHe/bzLV
	 ZDl9UEr14ekcpfCJk6RDza5apPq9i/1g5VSUREK4wQ/5Ib8LBFZY5NsHmgDKwcsJd5
	 raSV/4nqny+fZeQRHQXL35saZ9wB+AO2cAuRD2YA=
Date: Thu, 30 Nov 2023 08:56:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <bhe@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Vivek Goyal <vgoyal@redhat.com>,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, x86@kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
 eric_devolder@yahoo.com
Subject: Re: [PATCH 1/2] kexec: fix KEXEC_FILE dependencies
Message-Id: <20231130085657.6f7f500cc17b663747e4ee76@linux-foundation.org>
In-Reply-To: <ZUNXxp9AIkjQkP9s@MiWiFi-R3L-srv>
References: <20231023110308.1202042-1-arnd@kernel.org>
	<ZTe8NOgAjvKDA6z0@MiWiFi-R3L-srv>
	<b71034f4-5cdc-44e0-b72f-1a8ffae0593e@app.fastmail.com>
	<ZUNXxp9AIkjQkP9s@MiWiFi-R3L-srv>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 2 Nov 2023 16:03:18 +0800 Baoquan He <bhe@redhat.com> wrote:

> > > CONFIG_KEXEC_FILE, but still get purgatory code built in which is
> > > totally useless.
> > >
> > > Not sure if I think too much over this.
> > 
> > I see your point here, and I would suggest changing the
> > CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY symbol to just indicate
> > the availability of the purgatory code for the arch, rather
> > than actually controlling the code itself. I already mentioned
> > this for s390, but riscv would need the same thing on top.
> > 
> > I think the change below should address your concern.
> 
> Since no new comment, do you mind spinning v2 to wrap all these up?

This patchset remains in mm-hotfixes-unstable from the previous -rc
cycle.  Eric, do you have any comments?  Arnd, do you plan on a v2?  If
not, should I merge v1?  If so, should I now add cc:stable?
