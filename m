Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034763B7763;
	Tue, 21 Apr 2026 12:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776774421; cv=none; b=cbuNzfsb2WxMz8IqsfdBvutFHzCIz+5eNwFHbYd6liVnSAKMGmFIumHNH/UfGgzM1noFmxgrnc4lhvY4coadlgBwt2M95GjUmQpQjDDAn+4hTaNAzoedl960Dh3klsmI3ZbBbX7r6gG0yoVRfWwMHfWQp/eeqsBJ2SPsjY0E/M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776774421; c=relaxed/simple;
	bh=ZaGWM8jA4mMH9NwO+YqwAWjdiVWdlYlvmNHObCEIt6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YyQL/SgHlQewIhWFre1zTnWtjsLseQaqLN7ypMQX6TpGE935s3E34f3C0XGM1EPC5kXYFXx7IBuK3VUMCnZpQBZEUvFaXHALpb9VqUV5eA9dECak7GIk+Xd7FZ/6ccxyl+gDhOIRVMyuz0tBHAolllxqUhkgg7xnQUZ2QY7+Z94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IfI9Jb9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IfI9Jb9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B97C2BCB0;
	Tue, 21 Apr 2026 12:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776774420;
	bh=ZaGWM8jA4mMH9NwO+YqwAWjdiVWdlYlvmNHObCEIt6k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IfI9Jb9gKqz+z+jxmbqO6X6SzZtsSqVQArsbwBQxWe62W+RTooyaT3ghb7Me8n5V4
	 z0M2A0w8RDm2rHw2yGhmhcsg02rGaSBg1IJ2xJCeSRULv7XvNbWHgO25wR3yL56Y2m
	 DYgdPHlTj9+y32EzGWMtZjnfvnL/KH254IDnPgRXGW0Wk+l3HPdwgERwEN4zIui4R3
	 baXKtsdlysBs0yk13sxZlyF6ed5iih8ie2NzrkDNwF3OzQnOn9rAKOv+pj+iLgM4Bd
	 wbVrOG5S+xzIHWl/w+oBedgHWZ6eK2eyUazcS9rTqv0QvV6PjNyDoLJvmraSwkXDFh
	 bwtSbxOIiPvlw==
Message-ID: <215f12d6-62c1-4837-9f78-ef270684950c@kernel.org>
Date: Tue, 21 Apr 2026 14:26:35 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] powerpc: Add a typos.toml file
To: Link Mauve <linkmauve@linkmauve.fr>, linuxppc-dev@lists.ozlabs.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 Juergen Gross <jgross@suse.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Geoff Levand <geoff@infradead.org>,
 Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
 Oliver O'Halloran <oohall@gmail.com>, Anatolij Gustschin <agust@denx.de>,
 =?UTF-8?Q?Breno_Leit=C3=A3o?= <leitao@debian.org>,
 Nayna Jain <nayna@linux.ibm.com>,
 Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
 Eric Biggers <ebiggers@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Ard Biesheuvel <ardb@kernel.org>, Thorsten Blum <thorsten.blum@linux.dev>,
 Thomas Huth <thuth@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 David Hildenbrand <david@kernel.org>, Alistair Popple <apopple@nvidia.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Donet Tom <donettom@linux.ibm.com>, Andrew Morton
 <akpm@linux-foundation.org>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@rivosinc.com>, Will Deacon <will@kernel.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Paul Moore
 <paul@paul-moore.com>, Nam Cao <namcao@linutronix.de>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Sourabh Jain <sourabhjain@linux.ibm.com>,
 Hari Bathini <hbathini@linux.ibm.com>,
 Srikar Dronamraju <srikar@linux.ibm.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>, Jiri Bohac <jbohac@suse.cz>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Kees Cook <kees@kernel.org>, Stephen Rothwell <sfr@cab.auug.org.au>,
 Xichao Zhao <zhao.xichao@vivo.com>, Gautam Menghani <gautam@linux.ibm.com>,
 Peter Zijlstra <peterz@infradead.org>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Guangshuo Li <lgs201920130244@gmail.com>, Li Chen
 <chenl311@chinatelecom.cn>, Aboorva Devarajan <aboorvad@linux.ibm.com>,
 Petr Mladek <pmladek@suse.com>, Feng Tang <feng.tang@linux.alibaba.com>,
 "Nysal Jan K.A." <nysal@linux.ibm.com>, Aditya Gupta
 <adityag@linux.ibm.com>, Sayali Patil <sayalip@linux.ibm.com>,
 Rohan McLure <rmclure@linux.ibm.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Yeoreum Yun
 <yeoreum.yun@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Donnellan <andrew+kernel@donnellan.id.au>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Athira Rajeev <atrajeev@linux.ibm.com>, Kajol Jain <kjain@linux.ibm.com>,
 Thomas Gleixner <tglx@kernel.org>, Chen Ni <nichen@iscas.ac.cn>,
 Haren Myneni <haren@linux.ibm.com>,
 Jonathan Greental <yonatan02greental@gmail.com>,
 Ingo Molnar <mingo@kernel.org>, "Yury Norov (NVIDIA)"
 <yury.norov@gmail.com>, Gaurav Batra <gbatra@linux.ibm.com>,
 Nilay Shroff <nilay@linux.ibm.com>, Vivian Wang <wangruikang@iscas.ac.cn>,
 =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 "Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
 Thierry Reding <treding@nvidia.com>, Yury Norov <ynorov@nvidia.com>,
 "Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
 Ruben Wauters <rubenru09@aol.com>, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev, x86@kernel.org
References: <20260421121420.26079-1-linkmauve@linkmauve.fr>
 <20260421121420.26079-2-linkmauve@linkmauve.fr>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <20260421121420.26079-2-linkmauve@linkmauve.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/04/2026 14:14, Link Mauve wrote:
> This file is used by the typos tool[1] to determine which words to fix,
> which ones not to fix, and what the target word should be.
> 
> [1] https://github.com/crate-ci/typos
> 
> Signed-off-by: Link Mauve <linkmauve@linkmauve.fr>

This typos.toml file does not belong to the kernel, IMO, but that's up
to PowerPC folks.

My note here is: please use your real, full name. See submitting patches.

Best regards,
Krzysztof
