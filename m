Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2C9301460;
	Tue,  2 Dec 2025 06:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764657176; cv=none; b=k6yzUQlwJkfMV67tQh6P7kqLDTJ/X1nHV+WZf6nFLi/i1NRn8wnIYb/70SiAzCDuPz6wPcv9XaE8NwCok88W+avrP7JNTDR7ViOoiMnx5XPjsgeMFvPDPBUkxqFWcFzL/ZmoyNOilGXE7e5wxLN8VscVedahoYJuoklF2W2xcAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764657176; c=relaxed/simple;
	bh=uq4FzFhbXgEfjRtm0v8jPvu/3eFqEqCLEHIabRwZTMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dNEVgXmAuWHSIq/G9PNCULkjG8tf2grN6fUa6K4ZHqNCryqL1dqCrIaAjdRnBOwFec4euHq4N2181aXLeZ4+cYB5ppQ17k6n/o+NDQETcgcfjrGHfA7zBoVBGyTJUVUoX4ZHeESlMd1MbmlSRdBnkrmPLSDZOS2V8D8lFzfgHQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLuJ0Ckm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLuJ0Ckm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154CDC4CEF1;
	Tue,  2 Dec 2025 06:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764657175;
	bh=uq4FzFhbXgEfjRtm0v8jPvu/3eFqEqCLEHIabRwZTMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JLuJ0Ckm5IS7nlUqKLi3MCoZ31aWBOxanAN27rKbwY03DJG26511TZawyBvPHgKZK
	 ZN6qa+FfikT8uVMcvZNDtWVjcj3CT2mdNqi+czrktL9QusIdMPELIwXmDPJffg+bpu
	 KErw7lDbdliaGRVu8au8yuVGNxv8jf05s9D4Gwkd8GQg05Cg3SWlnFiQeakYaIcLSG
	 8B7TQ7+cFtH3Fv/hdz3D30e3i9RLjKQVofjKv1ZkwrBEiCS0M5e+k/+4XgCFkz3Pxo
	 ZGGraR5KWVe0hasmv4ivp55mSi3M4guLzpGpN52fd3fsQZDVsV/jMIilGy0eOsPbSi
	 fqfo2lCAcUBbg==
Date: Mon, 1 Dec 2025 22:31:03 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Vivian Wang <wangruikang@iscas.ac.cn>
Cc: Jerry Shih <jerry.shih@sifive.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lib/crypto: riscv/chacha: Avoid s0/fp register
Message-ID: <20251202063103.GA100366@sol>
References: <20251202-riscv-chacha_zvkb-fp-v2-1-7bd00098c9dc@iscas.ac.cn>
 <20251202053119.GA1416@sol>
 <80cb6553-af8f-4fce-a010-dff3a33c3779@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80cb6553-af8f-4fce-a010-dff3a33c3779@iscas.ac.cn>

On Tue, Dec 02, 2025 at 02:24:46PM +0800, Vivian Wang wrote:
> On 12/2/25 13:31, Eric Biggers wrote:
> > On Tue, Dec 02, 2025 at 01:25:07PM +0800, Vivian Wang wrote:
> >> In chacha_zvkb, avoid using the s0 register, which is the frame pointer,
> >> by reallocating KEY0 to t5. This makes stack traces available if e.g. a
> >> crash happens in chacha_zvkb.
> >>
> >> No frame pointer maintenence is otherwise required since this is a leaf
> >> function.
> > maintenence => maintenance
> >
> Ouch... I swear I specifically checked this before sending, but
> apparently didn't see this. Thanks for the catch.
> 
> >>  SYM_FUNC_START(chacha_zvkb)
> >>  	addi		sp, sp, -96
> >> -	sd		s0, 0(sp)
> > I know it's annoying, but would you mind also changing the 96 to 88, and
> > decreasing all the offsets by 8, so that we don't leave a hole in the
> > stack where s0 used to be?  Likewise at the end of the function.
> 
> No can do. Stack alignment on RISC-V is 16 bytes, and 80 won't fit.
> 

Hmm, interesting.  It shouldn't actually matter, since this doesn't call
any other function, but we might as well leave it at 96 then.  I don't
think this was considered when any of the RISC-V crypto code was
written, but fortunately this is the only one that uses the stack.

Anyway, I guess I'll apply this as-is then.

- Eric
