Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D5F3845AE;
	Tue, 21 Apr 2026 12:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776775387; cv=none; b=FcsrI1i2sENgMpFcei4a+6x3NO2bHCzO2s0P+2q4sxf+UItQQZt0nV2Z9UcdFFFyKQKhDwKSFhgG1a38r31c+1Xn5ZdK+CH6/xPc2S4Lan9dq0MDkkQQjbA7ZIMj8UIZVIcAcGLkuPOWDA0hWxhXkDN5BELwA6kl1h/KF6APUag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776775387; c=relaxed/simple;
	bh=m1DD4aKC1/IaFiEIe653EE1XT3Zbg+htg46Kj+jGB/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FUrC3gAeoock+7l/yUtGET6ncSbDJx3GnYWhsM9EodKqe3oFeRRYk3fNKlU1MegoxvCsiNdHvrWrV1YqmswQgVCnFyPuCBPMRdlMphM+44EcAZyWejUwBzaofdQ0w6i3N42FTxfIswGq6n/F2fDYd4wM8zt5zZuUod5lTgudNXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rMC5kNQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rMC5kNQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEABBC2BCB0;
	Tue, 21 Apr 2026 12:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776775387;
	bh=m1DD4aKC1/IaFiEIe653EE1XT3Zbg+htg46Kj+jGB/8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rMC5kNQcKTFXXeyxYYSYCiZeYJc/iYKHk1FcPipJOxq47Is7+q/vmUT6OByUqydpb
	 cVA2+ktqDLsyhadU8ZS5uBm4cdAUK0pMaujvd0zG/Mds/U+YC8dzoRRKMXsFg4l02J
	 1Qinb8YewYqKUsYb1ZBJqMtbdkkuIR027GjVjNZhNHB8gzRc3+U1fEuXbrwTdQfVEw
	 a0EWSpTOhdepMz9605uEDdo+dr1QKKzUXdpflUvcUEQUWhiIieZl4c+2f8eTX7l7B/
	 UYs7WBPGilIjbSy2NOuDdMBG3774/JvpJbPEOf+7JwJVRQMBJdn/piLcxZDl0K5V71
	 o16GDIhduIYog==
Message-ID: <74c3d4df-4f0c-44b2-9ade-a4b4422d3daf@kernel.org>
Date: Tue, 21 Apr 2026 14:42:47 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] powerpc: Run typos -w
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Link Mauve <linkmauve@linkmauve.fr>
Cc: linuxppc-dev@lists.ozlabs.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
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
 <20260421121420.26079-3-linkmauve@linkmauve.fr>
 <2026042113-shaded-favored-c342@gregkh>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <2026042113-shaded-favored-c342@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/04/2026 14:36, Greg Kroah-Hartman wrote:
> On Tue, Apr 21, 2026 at 02:14:14PM +0200, Link Mauve wrote:
>> diff --git a/arch/powerpc/boot/dts/mpc8308_p1m.dts b/arch/powerpc/boot/dts/mpc8308_p1m.dts
>> index 41f917f97dab..48a98449ecbb 100644
>> --- a/arch/powerpc/boot/dts/mpc8308_p1m.dts
>> +++ b/arch/powerpc/boot/dts/mpc8308_p1m.dts
>> @@ -90,14 +90,14 @@ can@1,0 {
>>  			compatible = "nxp,sja1000";
>>  			reg = <0x1 0x0 0x80>;
>>  			interrupts = <18 0x8>;
>> -			interrups-parent = <&ipic>;
>> +			interrupts-parent = <&ipic>;
>>  		};
>>  
>>  		cpld@2,0 {
>>  			compatible = "denx,mpc8308_p1m-cpld";
>>  			reg = <0x2 0x0 0x8>;
>>  			interrupts = <48 0x8>;
>> -			interrups-parent = <&ipic>;
>> +			interrupts-parent = <&ipic>;
>>  		};
>>  	};
>>  
> 
> Isn't this going to break a working system?  If not, then was this dts
> file ever correct in the first place?

It looks DTS was not correct in the first place, but wrong property
probably did not matter, because parent node has it right. Still this is
beyond trivial language fix and should be a separate.

OTOH, interrupts-parent is clearly the wrong property. There is no such
thing.

Quoting commit msg:
"I have manually reviewed every single"

Clearly not true.

Best regards,
Krzysztof
