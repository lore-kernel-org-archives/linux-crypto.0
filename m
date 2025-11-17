Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F6F17A2E0
	for <linux-crypto@vger.kernel.org>; Mon, 17 Nov 2025 00:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763340156; cv=none; b=oy3F3RAiFMgqLq3OILIsM5ZFmnE+MJWXpL17wLLYOqzY3ueRoJCiWvbHKfGbth7DxmjZV4taohhbi7B8KSA+lMfCaCySULY2T+iS1pmS4CspJMUFi3a5QUqtn8Wq5JepWhaTfHrQ9G27YonPf6y2T7uiHPfu4uiW/vhT+0CcQYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763340156; c=relaxed/simple;
	bh=a9+qEB07wrgRXtCX6w+k8yt+vZZKNvjMbF5ynHtAs+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jCV1PX9gmcgy6ccIDLC2tsHMW5l96lhfVqmWd9vZ+xP7z5f/AAdO9zFgsEfRTMdBs24KiWPahLRipQprBNtfOGsZiON97s3aoq92t6djU358qB2P4Gu5T5cYAWg95b2XgGgz35VhlhwAfbx5dEwiQWKZ+b9rnAWLgeTIhP1YoV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rv7oGxN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rv7oGxN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D65C2BC9E;
	Mon, 17 Nov 2025 00:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763340156;
	bh=a9+qEB07wrgRXtCX6w+k8yt+vZZKNvjMbF5ynHtAs+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rv7oGxN0+jLLkBTbPj2CQ0LkJLbqnkn0PEE0n18a0aI7z1d/nOcw71WhcIOcaaRUZ
	 rrCahkuEKIWgdQ9xeEdWSJPWzV/YC2DGosGHCrTPnJlg0s202L1VQAIZG5c3G7eK+o
	 d7VRVTPTH1TASVqWumTqWLtqDuXITTnzvBra7YXe3oWVx/zSZTikqFfOzIj+r6JYrG
	 RH4C1uDc9s9hVV/95q/gkxjnYBwl/25IOkWdRQX3QPSSo7ELyJf5zi7ZzdUdnu15L/
	 iiQheNem26ThiwnACJnDttrLNI8f3xdlezsts41mSsXbTp/PRQTQSqGnlsQA2R3gup
	 1zjrq3/EMlryQ==
Date: Sun, 16 Nov 2025 19:42:34 -0500
From: Sasha Levin <sashal@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 6.12] lib/crypto: arm/curve25519: Disable on
 CPU_BIG_ENDIAN
Message-ID: <aRpvevwfpVA4hqr3@laps>
References: <20251111202936.242896-1-ebiggers@kernel.org>
 <20251116171942.3613128-1-sashal@kernel.org>
 <20251116193423.GA7489@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251116193423.GA7489@quark>

On Sun, Nov 16, 2025 at 11:42:24AM -0800, Eric Biggers wrote:
>On Sun, Nov 16, 2025 at 12:19:42PM -0500, Sasha Levin wrote:
>> Subject: lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
>>
>> Thanks!
>
>I assume that you meant to write something meaningful in this message.

What else did you expect to see here?

>Also, you forgot to include all the original recipients in Cc.

Yes! I'm trying to automate this workflow, and this is one of the issues I've
fixes with the scripts.

-- 
Thanks,
Sasha
