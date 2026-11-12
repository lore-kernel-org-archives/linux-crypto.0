Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794444014;
	b=kZ/3/ZDVB/oSWIvRyhrcIFw68cpbRXcAt28/OsLpMwJNlMH19bY0A8r2NJ9C//loFQU3
	 WdazFeqtxYwaFOP3x0WowqavoR1ujOJlDDYJ7QsKsufVpMgLGdjgC4Pedh1V979wrKell
	 IYpOA6tJ9FQZUr/Z+jq+LPYW9mdIBts/8dOujcnhvtNbZdysAnsOPF+/AW72NPJIIEvkW
	 B1GP9zadyo3Pa8a3PiZgfyAuuEUDPw900WyKxW1dhPS7MFuRAJ4JLxFHqHm+LRlv0Ay5B
	 llDXh4pqw4MXP1jQshKfrld8/HIs+rBECEyEhSRq3AhH84PKsarfTUNN6YOMrFjOtSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794444014;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LctdR/JCjxXqXaUQaTN2ULstUn/j3yJ+h0QrraA+KO8=;
	b=UPlfktxrhSn+TrVPh1e043LARUOn6MVU5CU/lAN43E1w31n4l9TQjKGI8EL/faJXf+QU
	 yNsbuUQpIDYibkzu4Qk/ZqlxPBNgXQ4x8u1iSgUfcVeQRGsOkq497UX7hAm2EyvfSZGLk
	 C9yY9DfMkkHBGh5KikNEig4xA3s0RfG1ig2Y7YCEXpBT4klo+OwBowthjjhYqmAJoW2E8
	 hDFe5mXBe/DyO7h9UseJ0P5RFD2VEGAh+OnRpNY9cSLvGa5xUY7kFWiJ0y842SoS3tNc3
	 3Ig2+ABlHKvIxtsg+U/0pcLaAGOShP7IkVfAxyOaUqe8TsJqRw4XV/ymuL4FUQB06dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ays3K3pI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C9D93606A335;
	Thu, 12 Nov 2026 00:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ays3K3pI
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B06BA1F00A0F;
	Thu, 12 Nov 2026 00:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794444014;
	bh=LctdR/JCjxXqXaUQaTN2ULstUn/j3yJ+h0QrraA+KO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ays3K3pIaLgkjHtf67+YKirgb77xzOsgoaqDmEP/g+4Qe5AaNi4B39YOWoUh1lzKI
	 Zi7/z86Ihs4YZJJ7R6sbJJTlh5U25IRSQr2M7CbZ/l7oNky3/H7pWxOAAd114X/FkD
	 us95OeCkgMlJcVkMHJa/dfAOSB0NI5+dzyms7qN+3irdnRQ1F1OX0RH9RxzbQMO8cp
	 6xLiuz/R5U8PMqbIT0nhOaUPAqqSFg+K4xa9+ieDK9b2fmrnW3Kzp1B2GrWtApoU8e
	 t2UaBe6LeHGtWas9QjH/p4y+yHYGzcFiBYW/QLy86NrTZsAr71hHZWfAUUcMexFnCv
	 5LECeq1WSVyww==
Date: Thu, 12 Nov 2026 02:40:10 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Pavel Popov <pavel.e.popov@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Arnd Bergmann <arnd@arndb.de>, Len Brown <lenb@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	"David S . Miller" <davem@davemloft.net>, x86@kernel.org,
	linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	platform-driver-x86@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] tpm: Include <asm/cpu_device_id.h> unconditionally
Message-ID: <avUK6uzoAJax0ZKn@kernel.org>
References: <20261111234821.4814-1-pavel.e.popov@intel.com>
 <20261111234821.4814-7-pavel.e.popov@intel.com>
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
In-Reply-To: <20261111234821.4814-7-pavel.e.popov@intel.com>

On Wed, Nov 11, 2026 at 04:48:19PM -0700, Pavel Popov wrote:
> <asm/cpu_device_id.h> now has a generic version, so the #ifdef
> CONFIG_X86 around the include is no longer needed.
> 
> Signed-off-by: Pavel Popov <pavel.e.popov@intel.com>

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

Are these expected to be picked separately by subsystems?

Br, Jarkko
