Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141AB3DBB6;
	Thu, 23 Jan 2025 21:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737667337; cv=none; b=JTMvKxxVcU2jw1lLHGfhWd+vu3W5bW2WnE7g1AnxTRL5i6FKI22uWSF1U9CvHXjlRqMyeDem36TkdUODuX1ed3rPRUmnpPtgO15WT1ARGMZvuQhlZALQOKN65bYIG4nLowG1zg2ymsRfJEXVTfFEYn33iJo2uhqjXwYZIgbMSCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737667337; c=relaxed/simple;
	bh=ZC9u95rIRBVi1jdlrCYnz+Uh8eWMbfFSGDHWs38Mkhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T/kNmZ5/HZoUqZC188IFqfhNSKhfNXRTnrZLxtRgV8Lh6eFQJZtDWrJDyFHKlSOFjWux6waRAfVKxU4ZvAzJ22sZuuIEkJNLFxLUMEdgtJHn7xw/fF1mJQMu7XzSkatVQfmcvsZMbFKLl+CzDQiPsEFmOtWoZ9+vkUQsAiXaEB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RFUrgtkw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RFUrgtkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D33C4CED3;
	Thu, 23 Jan 2025 21:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737667335;
	bh=ZC9u95rIRBVi1jdlrCYnz+Uh8eWMbfFSGDHWs38Mkhk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RFUrgtkw+P3shzjg0n9jNasHG/JpQ9EsIkJRGeQddmA6FgV5XavthVTVplQtfw5Jh
	 IspZ6Z2qkyEfJ6NDkxcUq+h7DIYccZ0OydzBquVNSOFZNXDr1WV8UHhhQi+yotxZG6
	 8Cz3EMVLQzMr6Rd+a/4gP5z1rQyhVKXAoA/leNwzDXl5RXSGFImyVCLwTdlTzgg9MC
	 IetAbc9KtvRMD8DXbIncaxF3KJ0imFvNrmj75DYrw8SaFjassfavLHC2gfVr66e+EV
	 kCZtNLYBOccvEBvG5/Jwbq1HTUgGiW7kiZ1yz1AVkInYOw/cbGQqzM6fZD+pfd0C+K
	 2Dl5gR+Bpu8bA==
Date: Thu, 23 Jan 2025 13:22:13 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Chao Yu <chao@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Vinicius Peixoto <vpeixoto@lkcamp.dev>,
	WangYuli <wangyuli@grjsls0nwwnnilyahiblcmlmlcaoki5s.yundunwaf1.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
Message-ID: <20250123212213.GC88607@sol.localdomain>
References: <20250119225118.GA15398@sol.localdomain>
 <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
 <20250123051633.GA183612@sol.localdomain>
 <20250123074618.GB183612@sol.localdomain>
 <20250123140744.GB3875121@mit.edu>
 <20250123181818.GA2117666@google.com>
 <CAHk-=wiVRnaD5zrJHR=022H0g9CXb15OobYSjOwku3m54Vyb4A@mail.gmail.com>
 <20250123211317.GA88607@sol.localdomain>
 <CAHk-=wgmda2CvAiOrg+zznFroPTo2TrdjnHo9f4_Kv1Pwn5iOA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgmda2CvAiOrg+zznFroPTo2TrdjnHo9f4_Kv1Pwn5iOA@mail.gmail.com>

On Thu, Jan 23, 2025 at 01:16:57PM -0800, Linus Torvalds wrote:
> On Thu, 23 Jan 2025 at 13:13, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > x86 unfortunately only has an instruction for crc32c
> 
> Yeah, but isn't that like 90% of the uses?
> 
> IOW, if you'd make the "select" statements a bit more specific, and
> make ext4 (and others) do "select CRC32C" instead, the other ones
> wouldn't even get selected?
> 
>               Linus

There's quite a lot unfortunately.  Try this which finds the regular crc32 (not
crc32c):

    git grep -E '\<(crc32|crc32_le|__crc32_le)\(|"crc32"'

- Eric
