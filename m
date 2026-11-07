Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794087438;
	b=fgSWPi5dGTrCJIKMa+s/RucHF9N4WjU+hD3rwf3hNwbOirb19OlsH6ndyBhNrE/bFp48
	 YKV95oXw0JcIxKqqgvvFhN5AovHm/+51C2AL641uk8kWD5bL/7CU83LAAzprj6s3Zpjw1
	 gC7/tEA+manDK3LS59O5GTA2Yp7PlagP3bviPvan2BmQ3pICrahdVWAttI375FjCupXjf
	 GUYwkWlO9Zj0Stxcph8VU07iXW8ggkDaZJedMxaxztmLzwK0CQmp3dp4nXzQ0rBmfYIlR
	 y/oSRrFxXX0Rq0QHhpt8WLbBiZyl00u8DnJr4wNHxKWVf5u6mfAHMtMZiPEGs8rlG1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794087438;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=RZICYlEwCNSQrTvDVmUOLS6u4KZIZYM8/Ot1Wf7WUvc=;
	b=3767NWhavo4qY9TYBgKw22KomZSfn7EsJ3U2lwX6e1CobAJWJxPyll3AQFaszDzxqsyg
	 VDmMDG9qg66tJ3hNoU04IS5wdDxWH8H2MzWBLJoocdyrfCNWa/zv4/yQ2UifkNJBZo9+Q
	 7GKWyPNby8gbDCAxUHqHpCxUsWBviP+MbbBU4wCwa7TenrTYbeSSqRKULwGLiVCYI/18p
	 8eSIodEcp1jY8TlyLlC5L64582QrcvBdgpDhWFuPqsOmt1eDVxhLxUNirV4YBk0M4QsGj
	 aWJR9tG/zqEqCkcWU/mL7v4slLDBKXgOHtnSvIed8uCLHoIWCoFr7LTH7m7vBiqeXRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gzSZd4xq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BD8606A326;
	Sat,  7 Nov 2026 21:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gzSZd4xq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62311F0089F;
	Sat,  7 Nov 2026 21:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794087438;
	bh=RZICYlEwCNSQrTvDVmUOLS6u4KZIZYM8/Ot1Wf7WUvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gzSZd4xqZKO7PvkKljWyy95ermHBQf9W4ylW0o8zV4fyMnS3nr1/g46MmRYgIg7Gy
	 7X1k//hkzfdGie5glazqrbad2VfQwRq5oE/B9FJphlYz2h7zP2bI4mbis6z6zuUQp/
	 rZD3wvL/H5Uyr7o8mZhHj7e7UmnY1DcqI9DihdGasDtTp4pVPzp4IAFzhSZ7woNQrj
	 r9OAWDOJKhoZcMlD1mHFAVKyh/+ktvgy2n6wjTL/WdbRzgNWRHzHa61R2TO28XVeby
	 RK/ho6cJfitCUoYPiWetjNwaeqViA/UZT+irbosL1QgFnWGgZbgLfpAjKbUXZA5d1t
	 edyD0+mDl9d7g==
Date: Sat, 7 Nov 2026 13:37:16 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Emanuele Rocca <emanuele.rocca@arm.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crc: arm64: use .arch_extension to enable CRC and
 crypto
Message-ID: <20261107213716.GC137269@quark>
References: <20261105154145.557042-1-emanuele.rocca@arm.com>
 <68e24de8-0c94-473b-b2a1-47b9b79eb974@app.fastmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68e24de8-0c94-473b-b2a1-47b9b79eb974@app.fastmail.com>

On Fri, Nov 06, 2026 at 09:57:01AM +0100, Ard Biesheuvel wrote:
> Hello Emanuele,
> 
> On Thu, 5 Nov 2026, at 16:41, Emanuele Rocca wrote:
> > Instead of using ".cpu generic+crc+crypto", use ".arch_extension crc" and
> > ".arch_extension crypto" to enable the required instructions.
> >
> > The ".cpu generic+crc+crypto" directive replaces the assembler's current
> > feature set with generic+crc+crypto, dropping any other features that were
> > previously enabled, for example by -march or by a toolchain configured with
> > --with-arch=armv9-a. In contrast, ".arch_extension" enables the requested
> > extensions while preserving the current feature set.
> >
> > This is not a functional change: crc32-core.S only uses base A64
> > instructions plus CRC32 and PMULL, which remain available, and BTI landing
> > pads are emitted as HINT instructions. However, using .arch_extension
> > avoids the pitfall of silently disabling features. See commit 9142c2f8f84b
> > ("octeontx2: use arch_extension to enable LSE").
> >
> 
> I don't mind the patch, but I will point out that issues such as these can
> never occur in .S sources. The emitted instructions are always the same, and
> the only reason we need the .arch is so that the assembler permits the use
> of the special ones.
> 
> Commit 9142c2f8f84b is different because it uses .arch in inline asm, where
> it switches the assembler into a different mode behind the back of the
> compiler, leading it to reject instructions generated by the compiler.
> 

Thanks.  Emanuele, could you maybe note that in the commit message?

Also, this patch is not complete even for lib/crc/arm64/, since
lib/crc/arm64/crc-t10dif-core.S still uses "armv8-a+crypto".  If we're
bothering with this, I would suggest just taking care of both
crc32-core.S and crc-t10dif-core.S in one patch.  (The crypto files I
mentioned before should be a different patch.)

- Eric
