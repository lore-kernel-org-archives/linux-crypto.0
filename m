Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894BC23C8A0
	for <linux-crypto@vger.kernel.org>; Mon, 17 Nov 2025 01:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343794; cv=none; b=XDkx7Ewtywi/utFvkveODutA6dkUjmGk3Vyqm9Ct98NqjDD0tg9BQHcb4bcpkEL2QzO0UKXTitNsxIrSBSewULqkF3CP5LbnQmsmrSV4C2dxPUCT3wl350ibDq7HEU03lYg+BPfq6EEmovoeBBiVoxOlGwXmfnBviYvIYKiaQe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343794; c=relaxed/simple;
	bh=DrUHbb1ix4RUn8/wNlTyoRrOa1Byoul9OkPQtejzWhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WCAoOJjdJA9X2eFdqiU6dF/obnmuzPfFihstYkOYb2qT5XiL85uXGzsIhePoyaVC9qYqHuyQfhxAcIlAkjxq88t5hLfCiInqqjEMtJq9YyqKa6c6RRYgUMCYMUAgwpwvgkcfw6vnjtb2LT7UEhNP3/zf1fPlfzjWhG77uuwfoLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q2Rx6VG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q2Rx6VG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6FFC4CEF1;
	Mon, 17 Nov 2025 01:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763343794;
	bh=DrUHbb1ix4RUn8/wNlTyoRrOa1Byoul9OkPQtejzWhI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q2Rx6VG7uUhuKnxzGN9eL/mKX+ONvNTdKZs9YGg26nvFD9GyZNQYwaPYaXDmYuqK8
	 t9hXCkODhA+AiIujn9kWonuh4RETXq9eIyxlcUk94X3UqM2/Ijja0jMDRnHNbh0VCt
	 OlquEioGspv8yncQK3qD7xfSDo6DDyS+MUaLT2c/xvIvQ7XQCZZuHZqS6MeyHlabKT
	 K19oio8y1pAM/XOJxH9IrMhMzw/VjIJQ26dEoSHOpvMKClstvszGpgY3HNO56Lni9Q
	 Mn2hvewdWnRzja3/gDG262Dnptr6g8t6RqYPtixgVdwIYdZ7YTBgXsCclnNh+8MCuW
	 mbtQa2vqETVfQ==
Date: Sun, 16 Nov 2025 20:43:12 -0500
From: Sasha Levin <sashal@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 6.12] lib/crypto: arm/curve25519: Disable on
 CPU_BIG_ENDIAN
Message-ID: <aRp9sPD7Am9nF-_3@laps>
References: <20251111202936.242896-1-ebiggers@kernel.org>
 <20251116171942.3613128-1-sashal@kernel.org>
 <20251116193423.GA7489@quark>
 <aRpvevwfpVA4hqr3@laps>
 <20251117012513.GA1761@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251117012513.GA1761@sol>

On Sun, Nov 16, 2025 at 05:25:13PM -0800, Eric Biggers wrote:
>On Sun, Nov 16, 2025 at 07:42:34PM -0500, Sasha Levin wrote:
>> On Sun, Nov 16, 2025 at 11:42:24AM -0800, Eric Biggers wrote:
>> > On Sun, Nov 16, 2025 at 12:19:42PM -0500, Sasha Levin wrote:
>> > > Subject: lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
>> > >
>> > > Thanks!
>> >
>> > I assume that you meant to write something meaningful in this message.
>>
>> What else did you expect to see here?
>
>Maybe some actual information that wasn't already in the email that
>you're replying to?  What are you trying to accomplish?

Letting you know that your backport was queued up?

"b4 ty"?

Do you want a pretty ascii art here?

   _____                                   _                                          _                _                     _   _ 
  |_   _|                                 | |                                        | |              | |                   | | | |
    | |     __ _ _   _  ___ _   _  ___  __| |  _   _ _ __    _   _  ___  _   _ _ __  | |__   __ _  ___| | ___ __   ___  _ __| |_| |
    | |    / _` | | | |/ _ \ | | |/ _ \/ _` | | | | | '_ \  | | | |/ _ \| | | | '__| | '_ \ / _` |/ __| |/ / '_ \ / _ \| '__| __| |
   _| |_  | (_| | |_| |  __/ |_| |  __/ (_| | | |_| | |_) | | |_| | (_) | |_| | |    | |_) | (_| | (__|   <| |_) | (_) | |  | |_|_|
  |_____|  \__, |\__,_|\___|\__,_|\___|\__,_|  \__,_| .__/   \__, |\___/ \__,_|_|    |_.__/ \__,_|\___|_|\_\ .__/ \___/|_|   \__(_)
              | |                                   | |       __/ |                                        | |                     
              |_|                                   |_|      |___/                                         |_|                     

-- 
Thanks,
Sasha
