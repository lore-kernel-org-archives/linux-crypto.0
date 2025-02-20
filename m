Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D6F215191;
	Thu, 20 Feb 2025 16:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740070105; cv=none; b=rG4kJqRnoEteCtAJ+5N9XvtaF4qGd/8WxPpbwglGwVk3YS8eGYTtYDlTNPHPSiUnr5hiOw1WY5Zjy/Hi/gSAJUXY4kpfDW2nGWXP5CeTuY8qKFgK/4P1+2NvXsSJD5DHw7TlryS66zeylw/pjNtC5pXUWW5uHcUinOooSQQjiiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740070105; c=relaxed/simple;
	bh=jEKXyJsq815S7Qv/o6aF3HGgxLaohHFwHlAqbySCAjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H1UJCJ20pz787JG/+MKAeArVF4DXEiNZPzguNIyD2381+8CBSL1mOpuIN+76Zdy+tR82hUwEJ8OvvHG/BarqUu4fvD9jGZEiyvRUhaKGHOdIK+22Wh35DTo2mSN1OPnA21hZ9PAI/DAqgSvBTGVXhoArPc/MgeqtfWH15vR3A7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GknnQj6k; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GknnQj6k"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E583440E01A1;
	Thu, 20 Feb 2025 16:48:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id X9RZHqK9RFS0; Thu, 20 Feb 2025 16:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1740070096; bh=vWx4o7S0RRKESClOuZ3E/T2A4yda+ROzseKFSp9zPNU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GknnQj6keN3uGkbr5LNNENH/Wk+wv7igFroifGq/MdJkja5ZU+njbSG4eSRc2EsTx
	 B+kZytVU3pnXd+p/A5ZMSK/84KFqPLloVkbmPS2JoxmSM1+aPUCqhk8wIBE+qFt3NY
	 PFfsghIriihNzC2MmeZ+RwgaxvTDrK9iiPNx4kENrkJTVSKxq5hCjTkNNkYCpSvUmM
	 cHV8qq9ODQEnKcQk+spKZN7hrRwEEzfaY2xJ+J4r3FkRRedg3EL2vqElHXNNUpzJlG
	 EgeOwoMRgq5JdgQpwjTGJQbE6ksBgL2APX75rr92FqCJkAPssm5Fea5l/5aG+KxzYf
	 shEj49fkRQpOxnozpq58UjNKlaPlwrzeuno6fEL+1a++Bpk3kGKaT+6kDTGvIfU5z2
	 rCYd5kXYHPPSBFUMnA7eihWa8JP+s0kiJThpKzAXL20abjkQ46gbw7bUUFyXWDvbov
	 B4uLpZhG1yqKxOmiyOQYS4d27UmeAjPbC4tchWM5AX3sGzb9YFRYuVJ/bz8uWlpR9a
	 E8rY/zuIwOByye3l8WshcY5YYrNQUXfEEke7nZRDwMh8pXYjOY+BhcePWTQlnteDpB
	 mCaBWsOiA/t7DWAW36UAX0VudrXIYM4TGFZOBNCWvock1nx10Lc0/dZ0c0NmRH0SmN
	 ugCx0HxKC1uT3cdNPHoDy69w=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A6E1140E0177;
	Thu, 20 Feb 2025 16:47:51 +0000 (UTC)
Date: Thu, 20 Feb 2025 17:47:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Russ Weight <russ.weight@linux.dev>,
	Danilo Krummrich <dakr@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Tianfei zhang <tianfei.zhang@intel.com>, stable@vger.kernel.org,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH v6 4/8] crypto: ccp: Fix uapi definitions of PSP errors
Message-ID: <20250220164745.GGZ7dcsXRG2hFOphRz@fat_crate.local>
References: <20241112232253.3379178-1-dionnaglaze@google.com>
 <20241112232253.3379178-5-dionnaglaze@google.com>
 <d6ad4239-eb8a-9618-5be4-226dcf3e946c@amd.com>
 <d72dbe54-2d50-9859-7004-03daf419be86@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d72dbe54-2d50-9859-7004-03daf419be86@amd.com>

On Thu, Feb 20, 2025 at 10:34:51AM -0600, Tom Lendacky wrote:
> @Boris or @Herbert, can we pick up this fix separate from this series?
> It can probably go through either the tip tree or crypto tree.

This usually goes through the crypto tree. Unless Herbert really wants me to
pick it up...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
