Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54052E542C;
	Fri, 21 Aug 2026 06:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787293913; cv=none; b=q17AuRvA2aHRhZgRk/ZRSO45vGpETdTQmlES+8dMfYnidOp4YU5JJgLc2ShqK6Z94/06QHtXWG4RVAc5Am9PngRtkXbnljNapBZ9uNl2jKL6e4nT3aLYANudR0Jc0VaGU3wLAEa0wbwb8iT+ikI7L6+53n8tGCoGQUovRmW2wWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787293913; c=relaxed/simple;
	bh=1Xc7hI67sI71WReYGmfXmfCn6UOYtNv0NbXwkdNGkYM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=U4ViUua14GiIvKMJeJJ2RhIXOGktAWcBnHgZL1CKJltDTz9zlQWv88o8eN/ZA+SZlTHfV/jz3fhObPT890T0R9BOZphoTQ9eLgd2psILhZGhPmbxJj/b6PqXvCEKrG1NCOiBFhzvt8bejTBn79LgG8zCwONnww/p9hxnYENM2I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MK5Qp4xt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MK5Qp4xt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176941F00A3D;
	Fri, 21 Aug 2026 06:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787293912;
	bh=ppsjk/QD+0Fm+sLdI0cG3ucKcpsc989E2jEalJiaUSs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=MK5Qp4xtcyGbQ06m2FeNz8F+E/deGwt2Ji4AyGLSdZYtiD07v3Xq2yTwY5OWyJWGY
	 iYwIsV3YtQB7y7dvA8LXqNm5RzqwQDbXboD9r1vdQtDQZaMJv1Hxnij+zMOEOmVOZN
	 X6Dcqx5t302ZNxI4oLcJJY96A51tHgZ6cHrljYLZay2dFWEr9IGCJcNkce/4tHEDLm
	 7xjMz3DNxDh9lPvSSEKGvMy/SszyaH2aBtaOlwvO2cFQp3hYdMt/BJ2fBADQdJ10Rc
	 67boQqQy+78iNViyLq9B5+i0uRaE2zMjaeXrjm/wteNE9V76hw+sDAH0Hv3U/IJA14
	 60iD8h50rOwMw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 925B0198004A;
	Fri, 21 Aug 2026 02:31:49 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 21 Aug 2026 02:31:49 -0400
X-ME-Sender: <xms:0fCHagY_X6UpRM7sKWnIebaAIUnN5BY5WYrZJFVCJ9AvSF90-qQTNw>
    <xme:0fCHamMNRCVz9azBZjdMhmUrRrbYPG6sMY0F4SorfKLWE-qPVKPmqwdRJb32AoBDq
    ZGUS51KgDoLdgCkwg4AvXg20ecd1g3DHyK4Opbmim2Xlhjw2runO0cG>
X-ME-Proxy-Cause: dmFkZTFfpIZVewL7aRfCoF2sy93oDdmvtvw2VIVShU369Z6Og8JrO0UEQSkC6cEqU6y+wC
    uZrk00tA5vGIdl/8FMBBnxx/LanT2oyl65ruo36dhNeij2MjJWoqFiT8cr+l0ZDC3nMg1b
    ndwS/qdoPGDxpQYyg8Rm0F0nDZ91SSe5N/LYidq21rqwa0Bs7qhGzwfgtdqPu7MTMuLK4y
    Az4Fb4Xyh8qKcrnzBfkW39LHDfn5QG1+l1AF2g/WU9Ny5Wv3EhCeGEmPQHQJ4cIMgsGbn2
    gpoEfwqj5AQ2RCAYG3IrWfuQM3Ulv79siPeZxLH+5txzgSZyquSU8HQXHk9lQJ0D9JE8TO
    GNy+1WVqfZFE+HADDVVKZrz2HllqE+fiMt4vd5ZU8PYQE9GeOYj6+3aK/Caz5agBmFlPxH
    PRjH7PNKuqMt3V0Bmvn7kGCVu8F5sjqK9b3J68yabf0p1xBtxs08vD5jJVd4tQZXPIVJz2
    /oiCh1HUcG7O9hth/RW7O/ynTCD4rEgrMRw2CYgH6mgtcU6gZNrNsrNbwisNDvbwWuRZeY
    BDEfnDfE5nCJWmEXpZIcgSwsYkrxEKVhWK4SxGftf4xNkpK3kiE2wIhJC7okFCwoYlsopR
    Wkr99IrzbLDVdWu1W6t4qOOY59N0ZLXExHRcVyLWdjK57vBOhZJbZA9za3MQ
X-ME-Proxy: <xmx:1fCHasO4zq7V4rrU6fO72Ek-SEspFy0kBcvCDr2GobtVORZUWqSrjg>
    <xmx:1fCHagw6NJqmnnfwS-1nYNFf0zYhTwPRnXDnrC5S50L5yjYM3plhLQ>
    <xmx:1fCHakL-VaAUk7I21L5wfl1eHYBcwLJe94Q9QqxRivMsQzDie0ApBg>
    <xmx:1fCHavqUvH6Q3xJGl5DnNeXIZ640Ib1ogUMJKfLOZkabQo2o6WkxDA>
    <xmx:1fCHaqvBTG6ALjzYoi4CLh1Vb0aBIZ9on-RD0AnYEpJ0BKGILVVm1Pj8>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 1AFCFF80070; Fri, 21 Aug 2026 02:31:45 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 21 Aug 2026 09:31:23 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: "Ross Philipson" <ross.philipson@gmail.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-integrity@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-efi@vger.kernel.org,
 "Daniel P. Smith" <dpsmith@apertussolutions.com>,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
 dave.hansen@linux.intel.com, "Matthew Garrett" <mjg59@srcf.ucam.org>,
 "James Bottomley" <James.Bottomley@hansenpartnership.com>, peterhuewe@gmx.de,
 "Andy Lutomirski" <luto@amacapital.net>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, davem@davemloft.net,
 "Jonathan Corbet" <corbet@lwn.net>, kanth.ghatraju@oracle.com,
 daniel.kiper@oracle.com, "Andrew Cooper" <andrew.cooper3@citrix.com>,
 trenchboot-devel@googlegroups.com
Message-Id: <d853a1aa-49b6-46ae-87e6-62ec038c648a@app.fastmail.com>
In-Reply-To: <aoevs3z1EnTNg2vJ@kernel.org>
References: <20260711160110.267780-1-ross.philipson@gmail.com>
 <20260711160110.267780-11-ross.philipson@gmail.com>
 <alKI9mUBTOCjPbbG@kernel.org>
 <f85782ed-efb3-4045-9d37-2ed4847e1500@app.fastmail.com>
 <aoen10sB5zflLFRw@kernel.org> <aoevs3z1EnTNg2vJ@kernel.org>
Subject: Re: [PATCH v2 10/10] tpm-buf: Add TPM buffer support header for standalone
 reuse
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 21 Aug 2026, at 04:53, Jarkko Sakkinen wrote:
> On Fri, Aug 21, 2026 at 04:20:27AM +0300, Jarkko Sakkinen wrote:
>> On Wed, Aug 19, 2026 at 03:50:42PM +0300, Ard Biesheuvel wrote:
>> > 
>> > 
>> > On Sat, 11 Jul 2026, at 21:18, Jarkko Sakkinen wrote:
>> > > On Sat, Jul 11, 2026 at 09:01:10AM -0700, Ross Philipson wrote:
>> > >> Extract all the functions and definitions for TPM buffer handling
>> > >> and separate them into their own header.
>> > >> 
>> > >> Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
>> > >> ---
>> > >>  drivers/char/tpm/tpm-buf.c |  3 +-
>> > >>  include/linux/tpm.h        | 34 +--------------------
>> > >>  include/linux/tpm_buf.h    | 60 ++++++++++++++++++++++++++++++++++++++
>> > >>  3 files changed, 63 insertions(+), 34 deletions(-)
>> > >>  create mode 100644 include/linux/tpm_buf.h
>> > >> 
>> > ...
>> > >
>> > > I would probably ack them all as I've seen these many times and
>> > > there's not much anything new. Just waiting for additional
>> > > feedback before applying them.
>> > >
>> > 
>> > Will these be going into v7.3 then?
>> > 
>> > 
>> 
>> I can piggyback them with to my PR and see what Linus thinks.
>
> Added:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=for-next-tpm
>
> I'll send v7.3 PR once these show up in -next.
>

Thanks Jarkko
