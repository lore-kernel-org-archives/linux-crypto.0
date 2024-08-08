Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFA218B46F;
	Thu,  8 Aug 2024 11:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723117122; cv=none; b=dzzuyEzF4nUZ77o5QzvsCsjO8MdWrvg5kOEG8LUuncQgyp3EKtCJBFy5TiMbw6jiYWZ5KL01zRO6WGk9rt8511mRxm4r7sRRq18/iLqvsa5LKcWCOHnftJTHW5qCDN/6frWUsh/fQujHFFMaXATgu4mN32Ls2K+xxYnphswAdG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723117122; c=relaxed/simple;
	bh=0QhIHepQ4W5RWZkKNBeD1mFueKO6/2K0r+4hkW97G38=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IEzEk+OYrAuBl36oJf8yGUjWoNWUFaqVepTKgbkcGKjyji5txJ8HOZKFMucinApXhm6cw+Zon0FBkm4/vU0saDfy075/SRPOhM7vHRwFN/BfxZr69Bc3T7q1+RWchjcLnfNIO28t7nPH7tDqv/Y1G8FlZ8ejRJT09EDL1q8eRQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=Rf8WmADm; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="Rf8WmADm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=acqOcHsGUtxrd17wuEdfjC1lIs0K5TQddeGAbJ4eZlc=; t=1723117120;
	x=1723549120; b=Rf8WmADmnVDoAMuj8NxNIX6yDHRoZDdPvbTYUrb19pMZN23crfmtRcBERJnsS
	Py/gJsPLm+/jfo+Gs952+9JnL7bVN/2mgGFc/H8yzQfUvGYnm63zWtmnqMXTpnzt+9Blne+1+K5Tv
	1bJAHMR25ZWfjNgUYoE7E2a7aqkr5xidJAcmvSXH0nC0/d5OdA37aCMmQ4C6Id2n33rnz+RQoeNBu
	IWBSgcu6am5wOFozkfxpu3ZguJycMwXx+gefymKE6NnciIlsDkEBz5BkCfXaQu+67DOjKdZqQF712
	qiCAooQ9kP/jvM+wX5tO8DXBQ53UGAzp5FLT+28OcnTnHC8pIQ==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1sc1TR-0004Yy-2b; Thu, 08 Aug 2024 13:38:29 +0200
Message-ID: <7a153163-e9d8-4e0f-95cb-7688f3425a68@leemhuis.info>
Date: Thu, 8 Aug 2024 13:38:28 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] crypto: arm64/poly1305 - move data to rodata section
To: Daniel Gomez <da.gomez@samsung.com>, Jia He <justin.he@arm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Andy Polyakov <appro@cryptogams.org>, "David S. Miller"
 <davem@davemloft.net>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240806055444.528932-1-justin.he@arm.com>
 <CGME20240806125547eucas1p2016c788b38c2bc55e6b7614c3b0cf381@eucas1p2.samsung.com>
 <qd2jxjle5zf6u4vyu5x32wjhzj4t5cxrc7dbi46inhlhjxhw4s@llhfvho4l2e6>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: en-US, de-DE
Autocrypt: addr=linux@leemhuis.info; keydata=
 xsFNBFJ4AQ0BEADCz16x4kl/YGBegAsYXJMjFRi3QOr2YMmcNuu1fdsi3XnM+xMRaukWby47
 JcsZYLDKRHTQ/Lalw9L1HI3NRwK+9ayjg31wFdekgsuPbu4x5RGDIfyNpd378Upa8SUmvHik
 apCnzsxPTEE4Z2KUxBIwTvg+snEjgZ03EIQEi5cKmnlaUynNqv3xaGstx5jMCEnR2X54rH8j
 QPvo2l5/79Po58f6DhxV2RrOrOjQIQcPZ6kUqwLi6EQOi92NS9Uy6jbZcrMqPIRqJZ/tTKIR
 OLWsEjNrc3PMcve+NmORiEgLFclN8kHbPl1tLo4M5jN9xmsa0OZv3M0katqW8kC1hzR7mhz+
 Rv4MgnbkPDDO086HjQBlS6Zzo49fQB2JErs5nZ0mwkqlETu6emhxneAMcc67+ZtTeUj54K2y
 Iu8kk6ghaUAfgMqkdIzeSfhO8eURMhvwzSpsqhUs7pIj4u0TPN8OFAvxE/3adoUwMaB+/plk
 sNe9RsHHPV+7LGADZ6OzOWWftk34QLTVTcz02bGyxLNIkhY+vIJpZWX9UrfGdHSiyYThHCIy
 /dLz95b9EG+1tbCIyNynr9TjIOmtLOk7ssB3kL3XQGgmdQ+rJ3zckJUQapLKP2YfBi+8P1iP
 rKkYtbWk0u/FmCbxcBA31KqXQZoR4cd1PJ1PDCe7/DxeoYMVuwARAQABzSdUaG9yc3RlbiBM
 ZWVtaHVpcyA8bGludXhAbGVlbWh1aXMuaW5mbz7CwZQEEwEKAD4CGwMFCwkIBwMFFQoJCAsF
 FgIDAQACHgECF4AWIQSoq8a+lZZX4oPULXVytubvTFg9LQUCX31PIwUJFmtPkwAKCRBytubv
 TFg9LWsyD/4t3g4i2YVp8RoKAcOut0AZ7/uLSqlm8Jcbb+LeeuzjY9T3mQ4ZX8cybc1jRlsL
 JMYL8GD3a53/+bXCDdk2HhQKUwBJ9PUDbfWa2E/pnqeJeX6naLn1LtMJ78G9gPeG81dX5Yq+
 g/2bLXyWefpejlaefaM0GviCt00kG4R/mJJpHPKIPxPbOPY2REzWPoHXJpi7vTOA2R8HrFg/
 QJbnA25W55DzoxlRb/nGZYG4iQ+2Eplkweq3s3tN88MxzNpsxZp475RmzgcmQpUtKND7Pw+8
 zTDPmEzkHcUChMEmrhgWc2OCuAu3/ezsw7RnWV0k9Pl5AGROaDqvARUtopQ3yEDAdV6eil2z
 TvbrokZQca2808v2rYO3TtvtRMtmW/M/yyR233G/JSNos4lODkCwd16GKjERYj+sJsW4/hoZ
 RQiJQBxjnYr+p26JEvghLE1BMnTK24i88Oo8v+AngR6JBxwH7wFuEIIuLCB9Aagb+TKsf+0c
 HbQaHZj+wSY5FwgKi6psJxvMxpRpLqPsgl+awFPHARktdPtMzSa+kWMhXC4rJahBC5eEjNmP
 i23DaFWm8BE9LNjdG8Yl5hl7Zx0mwtnQas7+z6XymGuhNXCOevXVEqm1E42fptYMNiANmrpA
 OKRF+BHOreakveezlpOz8OtUhsew9b/BsAHXBCEEOuuUg87BTQRSeAENARAAzu/3satWzly6
 +Lqi5dTFS9+hKvFMtdRb/vW4o9CQsMqL2BJGoE4uXvy3cancvcyodzTXCUxbesNP779JqeHy
 s7WkF2mtLVX2lnyXSUBm/ONwasuK7KLz8qusseUssvjJPDdw8mRLAWvjcsYsZ0qgIU6kBbvY
 ckUWkbJj/0kuQCmmulRMcaQRrRYrk7ZdUOjaYmjKR+UJHljxLgeregyiXulRJxCphP5migoy
 ioa1eset8iF9fhb+YWY16X1I3TnucVCiXixzxwn3uwiVGg28n+vdfZ5lackCOj6iK4+lfzld
 z4NfIXK+8/R1wD9yOj1rr3OsjDqOaugoMxgEFOiwhQDiJlRKVaDbfmC1G5N1YfQIn90znEYc
 M7+Sp8Rc5RUgN5yfuwyicifIJQCtiWgjF8ttcIEuKg0TmGb6HQHAtGaBXKyXGQulD1CmBHIW
 zg7bGge5R66hdbq1BiMX5Qdk/o3Sr2OLCrxWhqMdreJFLzboEc0S13BCxVglnPqdv5sd7veb
 0az5LGS6zyVTdTbuPUu4C1ZbstPbuCBwSwe3ERpvpmdIzHtIK4G9iGIR3Seo0oWOzQvkFn8m
 2k6H2/Delz9IcHEefSe5u0GjIA18bZEt7R2k8CMZ84vpyWOchgwXK2DNXAOzq4zwV8W4TiYi
 FiIVXfSj185vCpuE7j0ugp0AEQEAAcLBfAQYAQoAJgIbDBYhBKirxr6Vllfig9QtdXK25u9M
 WD0tBQJffU8wBQkWa0+jAAoJEHK25u9MWD0tv+0P/A47x8r+hekpuF2KvPpGi3M6rFpdPfeO
 RpIGkjQWk5M+oF0YH3vtb0+92J7LKfJwv7GIy2PZO2svVnIeCOvXzEM/7G1n5zmNMYGZkSyf
 x9dnNCjNl10CmuTYud7zsd3cXDku0T+Ow5Dhnk6l4bbJSYzFEbz3B8zMZGrs9EhqNzTLTZ8S
 Mznmtkxcbb3f/o5SW9NhH60mQ23bB3bBbX1wUQAmMjaDQ/Nt5oHWHN0/6wLyF4lStBGCKN9a
 TLp6E3100BuTCUCrQf9F3kB7BC92VHvobqYmvLTCTcbxFS4JNuT+ZyV+xR5JiV+2g2HwhxWW
 uC88BtriqL4atyvtuybQT+56IiiU2gszQ+oxR/1Aq+VZHdUeC6lijFiQblqV6EjenJu+pR9A
 7EElGPPmYdO1WQbBrmuOrFuO6wQrbo0TbUiaxYWyoM9cA7v7eFyaxgwXBSWKbo/bcAAViqLW
 ysaCIZqWxrlhHWWmJMvowVMkB92uPVkxs5IMhSxHS4c2PfZ6D5kvrs3URvIc6zyOrgIaHNzR
 8AF4PXWPAuZu1oaG/XKwzMqN/Y/AoxWrCFZNHE27E1RrMhDgmyzIzWQTffJsVPDMQqDfLBhV
 ic3b8Yec+Kn+ExIF5IuLfHkUgIUs83kDGGbV+wM8NtlGmCXmatyavUwNCXMsuI24HPl7gV2h n7RI
In-Reply-To: <qd2jxjle5zf6u4vyu5x32wjhzj4t5cxrc7dbi46inhlhjxhw4s@llhfvho4l2e6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1723117120;e55b1f0c;
X-HE-SMSGID: 1sc1TR-0004Yy-2b

On 06.08.24 14:55, Daniel Gomez wrote:
> On Tue, Aug 06, 2024 at 05:54:44AM GMT, Jia He wrote:
>> When objtool gains support for ARM in the future, it may encounter issues
>> disassembling the following data in the .text section:
>>> .Lzeros:
>>> .long   0,0,0,0,0,0,0,0
>>> .asciz  "Poly1305 for ARMv8, CRYPTOGAMS by \@dot-asm"
>>> .align  2
>>
>> Move it to .rodata which is a more appropriate section for read-only data.
>>
>> There is a limit on how far the label can be from the instruction, hence
>> use "adrp" and low 12bits offset of the label to avoid the compilation
>> error.
> [...]
> 
> I'm getting the following error with next-20240806
> 
> make LLVM=1 ARCH=arm64 allyesconfig
> make LLVM=1 ARCH=arm64 -j$(nproc)
> 
> ld.lld: error: vmlinux.a(arch/arm64/crypto/poly1305-core.o):(function poly1305_blocks_neon: .text+0x3d4): relocation R_AARCH64_ADR_PREL_LO21 out of range: 269166444 is not in [-1048576, 1048575]

Hmmm, I ran into build problems with -next today for arm64 and x86-64
(ppc64le failed at a later stage for a different reason) on all current
Fedora releases (yesterday everything worked fine). The error looks
different, but mentions R_AARCH64_ADR_PREL_LO21 as well on arm64.

/usr/bin/ld: /tmp/ccgC3toO.o: relocation R_AARCH64_ADR_PREL_PG_HI21 against symbol `stderr@@GLIBC_2.17' which may bind externally can not be used when making a shared object; recompile with -fPIC
/usr/bin/ld: /tmp/ccgC3toO.o(.text+0x8): unresolvable R_AARCH64_ADR_PREL_PG_HI21 relocation against symbol `stderr@@GLIBC_2.17'
/usr/bin/ld: final link failed: bad value

That's what brought be here, so allow me to ask: might that be related
somehow or is that likely a different problem?

arm64: https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/next/fedora-39-aarch64/07889669-next-next-all/builder-live.log.gz
"""
> + /usr/bin/make -s 'HOSTCFLAGS=-O2  -fexceptions -g -grecord-gcc-switches -pipe -Wall -Werror=format-security -Wp,-U_FORTIFY_SOURCE,-D_FORTIFY_SOURCE=3 -Wp,-D_GLIBCXX_ASSERTIONS -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -fstack-protector-strong -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1  -mbranch-protection=standard -fasynchronous-unwind-tables -fstack-clash-protection   ' 'HOSTLDFLAGS=-Wl,-z,relro -Wl,--as-needed  -Wl,-z,now -specs=/usr/lib/rpm/redhat/redhat-hardened-ld -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1  -Wl,--build-id=sha1 -specs=/usr/lib/rpm/redhat/redhat-package-notes ' ARCH=arm64 'KCFLAGS= ' WITH_GCOV=0 -j4 vmlinuz.efi
> /usr/bin/ld: /tmp/ccgC3toO.o: relocation R_AARCH64_ADR_PREL_PG_HI21 against symbol `stderr@@GLIBC_2.17' which may bind externally can not be used when making a shared object; recompile with -fPIC
> /usr/bin/ld: /tmp/ccgC3toO.o(.text+0x8): unresolvable R_AARCH64_ADR_PREL_PG_HI21 relocation against symbol `stderr@@GLIBC_2.17'
> /usr/bin/ld: final link failed: bad value
> collect2: error: ld returned 1 exit status
> make[4]: *** [Makefile:47: /builddir/build/BUILD/kernel-next-20240808/linux-6.11.0-0.0.next.20240808.225.vanilla.fc39.aarch64/tools/bpf/resolve_btfids/fixdep] Error 1
> make[3]: *** [/builddir/build/BUILD/kernel-next-20240808/linux-6.11.0-0.0.next.20240808.225.vanilla.fc39.aarch64/tools/build/Makefile.include:15: fixdep] Error 2
> make[2]: *** [Makefile:76: bpf/resolve_btfids] Error 2
> make[1]: *** [/builddir/build/BUILD/kernel-next-20240808/linux-6.11.0-0.0.next.20240808.225.vanilla.fc39.aarch64/Makefile:1362: tools/bpf/resolve_btfids] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [Makefile:226: __sub-make] Error 2
> error: Bad exit status from /var/tmp/rpm-tmp.iEcjn7 (%build)
"""

x86_64
https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/next/fedora-39-x86_64/07889669-next-next-all/builder-live.log.gz
"""
> + /usr/bin/make -s 'HOSTCFLAGS=-O2  -fexceptions -g -grecord-gcc-switches -pipe -Wall -Werror=format-security -Wp,-U_FORTIFY_SOURCE,-D_FORTIFY_SOURCE=3 -Wp,-D_GLIBCXX_ASSERTIONS -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -fstack-protector-strong -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1  -m64   -mtune=generic -fasynchronous-unwind-tables -fstack-clash-protection -fcf-protection   ' 'HOSTLDFLAGS=-Wl,-z,relro -Wl,--as-needed  -Wl,-z,now -specs=/usr/lib/rpm/redhat/redhat-hardened-ld -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1  -Wl,--build-id=sha1 -specs=/usr/lib/rpm/redhat/redhat-package-notes ' ARCH=x86_64 'KCFLAGS= ' WITH_GCOV=0 -j2 bzImage
> /usr/bin/ld: /tmp/ccSPE2cG.o: relocation R_X86_64_32 against `.rodata' can not be used when making a PIE object; recompile with -fPIE
> /usr/bin/ld: failed to set dynamic section sizes: bad value
> collect2: error: ld returned 1 exit status
> make[4]: *** [Makefile:47: /builddir/build/BUILD/kernel-next-20240808/linux-6.11.0-0.0.next.20240808.225.vanilla.fc39.x86_64/tools/objtool/fixdep] Error 1
> make[3]: *** [/builddir/build/BUILD/kernel-next-20240808/linux-6.11.0-0.0.next.20240808.225.vanilla.fc39.x86_64/tools/build/Makefile.include:15: fixdep] Error 2
> make[2]: *** [Makefile:73: objtool] Error 2
> make[1]: *** [/builddir/build/BUILD/kernel-next-20240808/linux-6.11.0-0.0.next.20240808.225.vanilla.fc39.x86_64/Makefile:1362: tools/objtool] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [Makefile:226: __sub-make] Error 2
> error: Bad exit status from /var/tmp/rpm-tmp.MPS2x4 (%build)
"""

Ciao, Thorsten
