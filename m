Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D0F2DCC13
	for <linux-crypto@vger.kernel.org>; Mon, 17 Nov 2025 16:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763397601; cv=none; b=clpcnHLPUvciow/dS65Da71Ar8C5Mjr9oFYhekmmd8zIh9aGowQFw8SHbBmucAgTzImfAevtJNxGj8qY1poi9I5Oz6FkczW7FLWqOzf3Y2ckFLwANlyk2k0VMgCV4mGrInEZEp1gz8cQrFTCC7/yS6GDDag9FjLLhuw19op2thc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763397601; c=relaxed/simple;
	bh=CERm8fg4ws08oLit1qYwEfZhqnzPhYE3bQGj+8UqMy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUzKuefksf6hHrhGceEkBNz7IU7OgI+AVEgmxdTkOy8Xg9r0X8jRCorhaHw2YN9z5XKiMa2RUV1tIuwN/2dkReaQbLAqLzLJzbqmmLRvrIM6DVrUwQf2LXZJcht+F0SrdQ6SQpyaN1+O32o9pXx2Z6mX2MiPF91G08tWqEsWnvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dxzlc22g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dxzlc22g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40F4C19421;
	Mon, 17 Nov 2025 16:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763397600;
	bh=CERm8fg4ws08oLit1qYwEfZhqnzPhYE3bQGj+8UqMy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dxzlc22ghPf3NgzbI9W7PD6qs8/Km84fjavec/cy+4N3ZFfXFnXGE9DoER1fLVow+
	 cR6rb2uMa2rc0loVi9DTJdmDLEmvNHv1TXyqeHK6Q61U4rTZTASSV11+/TUpX5NXhJ
	 TrvUwVZ2bE/8XfVySFGc27OdvoHUOMja0KwCxEIJ1Izs5ftbx/3U7W8lWqBEsBWUJO
	 q6UZVFHddkJgOuPsySImo7srac8oO2e1bYfLz87SLPTabxBN/z8Lu/Dakux3lvjS+7
	 3J/oTP9NU3Qill+1HvKnQImRw4GSlB6EN/Wglvn0NN3PDSAz2bxyF0FVMGXNwTmHiw
	 5j/a/4zaATLSw==
Date: Mon, 17 Nov 2025 11:39:59 -0500
From: Sasha Levin <sashal@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 6.12] lib/crypto: arm/curve25519: Disable on
 CPU_BIG_ENDIAN
Message-ID: <aRtP3_mtZ6gqmIpU@laps>
References: <20251111202936.242896-1-ebiggers@kernel.org>
 <20251116171942.3613128-1-sashal@kernel.org>
 <20251116193423.GA7489@quark>
 <aRpvevwfpVA4hqr3@laps>
 <20251117012513.GA1761@sol>
 <aRp9sPD7Am9nF-_3@laps>
 <20251117015052.GA177915@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251117015052.GA177915@sol>

On Sun, Nov 16, 2025 at 05:50:52PM -0800, Eric Biggers wrote:
>On Sun, Nov 16, 2025 at 08:43:12PM -0500, Sasha Levin wrote:
>> On Sun, Nov 16, 2025 at 05:25:13PM -0800, Eric Biggers wrote:
>> > On Sun, Nov 16, 2025 at 07:42:34PM -0500, Sasha Levin wrote:
>> > > On Sun, Nov 16, 2025 at 11:42:24AM -0800, Eric Biggers wrote:
>> > > > On Sun, Nov 16, 2025 at 12:19:42PM -0500, Sasha Levin wrote:
>> > > > > Subject: lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
>> > > > >
>> > > > > Thanks!
>> > > >
>> > > > I assume that you meant to write something meaningful in this message.
>> > >
>> > > What else did you expect to see here?
>> >
>> > Maybe some actual information that wasn't already in the email that
>> > you're replying to?  What are you trying to accomplish?
>>
>> Letting you know that your backport was queued up?
>
>Maybe you should have mentioned that then?

Oh!

Apparently if I call git-send-email with --subject, it'll still strip the first
line from the patch file.

The first line was "This patch has been queued up for the ${KERNEL_VERSION}
stable tree." :)

Thanks for pointing it out, I've fixed up the script.

-- 
Thanks,
Sasha
