Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF812BAF9;
	Fri, 15 Aug 2025 01:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755220730; cv=none; b=RRsSQurNi4d6n/I+q6PFtJk7fpMSW1XFQKVuNsYgoCA2udHM8AL3ORSJkoepXa3ogSkHEhNuNe4w6NTPXzxUSJfPSwWAbsYNMVBDqNih5PNs+qLfJcSA3qDpjbM9vbLOdX7dH7t76RR0LwTJKbtrYn+BzgxjDzpbLKIxpwNxyLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755220730; c=relaxed/simple;
	bh=gw3mh9DEKhDX9u8JNpskCPWCG6PCHglkhEm70Y13ZRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWGv5g9h3dcyEjgvp0LhaD9Y8c9rtQuNEBAw2D7pC1lWCHxxAJj2gQwKOCsQiYlGWIKvAVfsSN9+qxDJI1fPJ4SHx7/muOFziJbTGggf+tfb/arUCG0y1yEkhadFd8R0sstBzPFzahsiY/fjufifdCNCW3xex5wi76KhkaoiVzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C832mawi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C832mawi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E66C4CEED;
	Fri, 15 Aug 2025 01:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755220729;
	bh=gw3mh9DEKhDX9u8JNpskCPWCG6PCHglkhEm70Y13ZRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C832mawi77pZGNE6eAg3cOTMeejX5ERyanv4/qvnDLk007uKsNPqJNqrgZQwfxPwn
	 PypDDpEsI04fXd/uvRoinw8tttUf3p50ZkfXUdLPgCqszMHg/pIyi8SGgFuKrzZGOh
	 YsMe1TJIiJYo3480rDqW8m97YwzasNwdagUk7ySBZclqhUTq70MtHubGO/O1NbPNF3
	 y33WoMf7BRxcTpgk0gOKBweVTQWdlJgxKwME3L6CjarqCLUCooAQFpC0OjhUwEPnZW
	 ShCH9zxYU+LUEvdND+MVG9eCdKZ8Ofr8BWO8H0dkzU6aLZc0/9SDG0N24DsAefga/d
	 zhINjA1ij2jVg==
Date: Thu, 14 Aug 2025 18:17:44 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: Marco Elver <elver@google.com>,
	Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com,
	glider@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev,
	davidgow@google.com, dvyukov@google.com, jannh@google.com,
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com,
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v1 RFC 6/6] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
Message-ID: <20250815011744.GB1302@sol>
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
 <20250813133812.926145-7-ethan.w.s.graham@gmail.com>
 <CANpmjNMXnXf879XZc-skhbv17sjppwzr0VGYPrrWokCejfOT1A@mail.gmail.com>
 <CALrw=nFKv9ORN=w26UZB1qEi904DP1V5oqDsQv7mt8QGVhPW1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALrw=nFKv9ORN=w26UZB1qEi904DP1V5oqDsQv7mt8QGVhPW1A@mail.gmail.com>

On Thu, Aug 14, 2025 at 04:28:13PM +0100, Ignat Korchagin wrote:
> Not sure if it has been mentioned elsewhere, but one thing I already
> don't like about it is that these definitions "pollute" the actual
> source files. Might not be such a big deal here, but kernel source
> files for core subsystems tend to become quite large and complex
> already, so not a great idea to make them even larger and harder to
> follow with fuzz definitions.
> 
> As far as I'm aware, for the same reason KUnit [1] is not that popular
> (or at least less popular than other approaches, like selftests [2]).
> Is it possible to make it that these definitions live in separate
> files or even closer to selftests?

That's not the impression I get.  KUnit suites are normally defined in
separate files, and KUnit seems to be increasing in popularity.
KFuzzTest can use separate files too, it looks like?

Would it make any sense for fuzz tests to be a special type of KUnit
test, instead of a separate framework?

- Eric
