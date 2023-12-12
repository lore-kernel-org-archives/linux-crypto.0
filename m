Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2FaSP8yJ"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEE9185
	for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2023 08:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1t5R4lCpMqAC7TdLx4pToc8upY1ucjgCx1PSqABbd24=; b=2FaSP8yJcr+mw/3e7JeV7m+Q+4
	+8yeaX2INi+dXFa+VKO+M9V0oK/Kmre08IhEMEWiW0vHiuC5dofwm6CqGIRe8mPcEqPXaU5Pbpf9g
	KduMsve/Pi9fEY0SBLVsubTiP1rZ/dbNds28BrJodRWOsDkHjZlXdVjPlbdbxZSY6J/EwmlvowS32
	2GLYLba4nxzuUAF1+2V139egllL4n+JuEl0tpY1/TgHuTB2zUbqvl3CVBIOFTE7Slkn6pPtevvUwu
	D+nxLHe/SPOFLwmH4e5GFDc9xsSiuqNcAoKkhlm2U3+0KCjW9aMg3mwZWrBdoIeyf6Csg+pAECjCk
	ZGOecMAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rD5jM-00CEob-2q;
	Tue, 12 Dec 2023 16:35:36 +0000
Date: Tue, 12 Dec 2023 08:35:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Ard Biesheuvel <ardb@google.com>,
	linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
	kernel-team@android.com, Mark Rutland <mark.rutland@arm.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Eric Biggers <ebiggers@google.com>,
	Kees Cook <keescook@chromium.org>, Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 0/4] arm64: Run kernel mode NEON with preemption
 enabled
Message-ID: <ZXiL2FhAWozC4HVu@infradead.org>
References: <20231208113218.3001940-6-ardb@google.com>
 <170231871028.1857077.10318072500676133330.b4-ty@kernel.org>
 <CAMj1kXE=2H_Jqyuv_gDp6QS2g2Vzdgf=fngp=ZXEUBXKOYWnbQ@mail.gmail.com>
 <20231212105513.GA28416@willie-the-truck>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231212105513.GA28416@willie-the-truck>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 12, 2023 at 10:55:13AM +0000, Will Deacon wrote:
> As discussed off-list, the vague concern was if kernel_neon_begin() is
> nested off the back of a user fault. The BUG_ON() should fire in that case,
> so we're all good.

I think we should really document all these rules, and Samuel's series
to add the portable FPU API would be the right place for it.  I'd also
really love to see objtool support for enforcing the various rules
where possible.

