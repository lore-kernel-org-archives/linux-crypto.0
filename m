Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA16AD39;
	Sun,  2 Mar 2025 18:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740941810; cv=none; b=C21EaNGotR62zPa4PFZR4d1OFfr+4p7qFscwF0BQc2bVppZCXwAD5ZuVcjdTEY7Kk/ZL7B/LdmVoPB7BlKsY776ROlOLYgHBFpXouGMOiqtCAQVIMYlUrj8vOdImvWp9XETwi77CLWXQXJPLp+H1lcuH19KO84xgUBA+ZVzImh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740941810; c=relaxed/simple;
	bh=DTcCsDl3YelRsQhkIZb+/zokvSAEsX2KGI4N1591F4M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SbCLDEN+gf7/d1eHCnl+zTT/KxbqmsZeDwT+Zdd1ybuGckNUFaCfCtNvC8hdtGAPC4r+GTOicDbeVHNR2C11vMSZmSfCDZkThDx+70qIMurb2QDb3O1AZVJ0+I9ink7EsISrFGZWRtuxBc2ZrMeh9/a8b8o8+XAJtApWiJ3t+HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nd9IjvFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nd9IjvFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0EEC4CED6;
	Sun,  2 Mar 2025 18:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740941809;
	bh=DTcCsDl3YelRsQhkIZb+/zokvSAEsX2KGI4N1591F4M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=nd9IjvFOUXZ+RLxOgZhmCkp8QM3VbjdqTzRbSZBE68IrpG6IPMsTP1yRSHtgP2xT1
	 4DVchWwrJvsEchapv0jduNp/rnQqvM3j5ja3IjL8fQUY70TpcSCd7LKgkihoFE1EIK
	 GY7Z8gjygFKhF6t/DRXpDfM9CIzUPNPs7HUalFwIVrts4LtbipnIG5MEVsdIcbu9eP
	 eScjGANA1gTJz+9M5lEPl245qo6LR6sPDfLPH6NEQ2+l4zMFIn+yXU4Eco25bfj1n1
	 CzSyjqxoJJPNTVDdsRUOGXjJUE3CNmAS4N9Cg69JR7Y+AkaKYyDTtR3U1gENnjyrCW
	 /f4LOUShUa8ig==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org, Zhihang
 Shao <zhihang.shao.iscas@gmail.com>, Ard Biesheuvel <ardb@kernel.org>,
 Xiao Wang <xiao.w.wang@intel.com>, Charlie Jenkins <charlie@rivosinc.com>,
 Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: Re: [PATCH 0/4] RISC-V CRC optimizations
In-Reply-To: <20250224180614.GA11336@google.com>
References: <20250216225530.306980-1-ebiggers@kernel.org>
 <20250224180614.GA11336@google.com>
Date: Sun, 02 Mar 2025 19:56:46 +0100
Message-ID: <87ikorl0r5.fsf@all.your.base.are.belong.to.us>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Eric!

Eric Biggers <ebiggers@kernel.org> writes:

> On Sun, Feb 16, 2025 at 02:55:26PM -0800, Eric Biggers wrote:
>> This patchset is a replacement for
>> "[PATCH v4] riscv: Optimize crct10dif with Zbc extension"
>> (https://lore.kernel.org/r/20250211071101.181652-1-zhihang.shao.iscas@gm=
ail.com/).
>> It adopts the approach that I'm taking for x86 where code is shared
>> among CRC variants.  It replaces the existing Zbc optimized CRC32
>> functions, then adds Zbc optimized CRC-T10DIF and CRC64 functions.
>>=20
>> This new code should be significantly faster than the current Zbc
>> optimized CRC32 code and the previously proposed CRC-T10DIF code.  It
>> uses "folding" instead of just Barrett reduction, and it also implements
>> Barrett reduction more efficiently.
>>=20
>> This applies to crc-next at
>> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?=
h=3Dcrc-next.
>> It depends on other patches that are queued there for 6.15, so I plan to
>> take it through there if there are no objections.
>>=20
>> Tested with crc_kunit in QEMU (set CONFIG_CRC_KUNIT_TEST=3Dy and
>> CONFIG_CRC_BENCHMARK=3Dy), both 32-bit and 64-bit.  I don't have real Zbc
>> capable hardware to benchmark this on, but the new code should work very
>> well; similar optimizations work very well on other architectures.
>
> Any feedback on this series from the RISC-V side?

I have not reviewed your series, but I did a testrun the Milk-V Jupiter
which sports a Spacemit K1 that has Zbc.

I based the run on commit 1973160c90d7 ("Merge tag
'gpio-fixes-for-v6.14-rc5' of
git://git.kernel.org/pub/scm/linux/kernel/git/brgl/linux"), plus your
crc-next branch (commit a0bd462f3a13 ("x86/crc: add ANNOTATE_NOENDBR to
suppress objtool warnings")) merged:

  | --- base1.txt	2025-03-02 18:31:16.169438876 +0000
  | +++ eric.txt	2025-03-02 18:35:58.683017223 +0000
  | @@ -11,7 +11,7 @@
  |      # crc16_benchmark: len=3D127: 153 MB/s
  |      # crc16_benchmark: len=3D128: 153 MB/s
  |      # crc16_benchmark: len=3D200: 153 MB/s
  | -    # crc16_benchmark: len=3D256: 153 MB/s
  | +    # crc16_benchmark: len=3D256: 154 MB/s
  |      # crc16_benchmark: len=3D511: 154 MB/s
  |      # crc16_benchmark: len=3D512: 154 MB/s
  |      # crc16_benchmark: len=3D1024: 155 MB/s
  | @@ -20,94 +20,94 @@
  |      # crc16_benchmark: len=3D16384: 155 MB/s
  |      ok 2 crc16_benchmark
  |      ok 3 crc_t10dif_test
  | -    # crc_t10dif_benchmark: len=3D1: 48 MB/s
  | -    # crc_t10dif_benchmark: len=3D16: 125 MB/s
  | -    # crc_t10dif_benchmark: len=3D64: 136 MB/s
  | -    # crc_t10dif_benchmark: len=3D127: 138 MB/s
  | -    # crc_t10dif_benchmark: len=3D128: 138 MB/s
  | -    # crc_t10dif_benchmark: len=3D200: 138 MB/s
  | -    # crc_t10dif_benchmark: len=3D256: 138 MB/s
  | -    # crc_t10dif_benchmark: len=3D511: 139 MB/s
  | -    # crc_t10dif_benchmark: len=3D512: 139 MB/s
  | -    # crc_t10dif_benchmark: len=3D1024: 139 MB/s
  | -    # crc_t10dif_benchmark: len=3D3173: 140 MB/s
  | -    # crc_t10dif_benchmark: len=3D4096: 140 MB/s
  | -    # crc_t10dif_benchmark: len=3D16384: 140 MB/s
  | +    # crc_t10dif_benchmark: len=3D1: 28 MB/s
  | +    # crc_t10dif_benchmark: len=3D16: 236 MB/s
  | +    # crc_t10dif_benchmark: len=3D64: 450 MB/s
  | +    # crc_t10dif_benchmark: len=3D127: 480 MB/s
  | +    # crc_t10dif_benchmark: len=3D128: 540 MB/s
  | +    # crc_t10dif_benchmark: len=3D200: 559 MB/s
  | +    # crc_t10dif_benchmark: len=3D256: 600 MB/s
  | +    # crc_t10dif_benchmark: len=3D511: 613 MB/s
  | +    # crc_t10dif_benchmark: len=3D512: 635 MB/s
  | +    # crc_t10dif_benchmark: len=3D1024: 654 MB/s
  | +    # crc_t10dif_benchmark: len=3D3173: 665 MB/s
  | +    # crc_t10dif_benchmark: len=3D4096: 669 MB/s
  | +    # crc_t10dif_benchmark: len=3D16384: 673 MB/s
  |      ok 4 crc_t10dif_benchmark
  |      ok 5 crc32_le_test
  |      # crc32_le_benchmark: len=3D1: 31 MB/s
  | -    # crc32_le_benchmark: len=3D16: 456 MB/s
  | -    # crc32_le_benchmark: len=3D64: 682 MB/s
  | -    # crc32_le_benchmark: len=3D127: 620 MB/s
  | -    # crc32_le_benchmark: len=3D128: 744 MB/s
  | -    # crc32_le_benchmark: len=3D200: 768 MB/s
  | -    # crc32_le_benchmark: len=3D256: 777 MB/s
  | -    # crc32_le_benchmark: len=3D511: 758 MB/s
  | -    # crc32_le_benchmark: len=3D512: 798 MB/s
  | -    # crc32_le_benchmark: len=3D1024: 807 MB/s
  | -    # crc32_le_benchmark: len=3D3173: 807 MB/s
  | -    # crc32_le_benchmark: len=3D4096: 814 MB/s
  | -    # crc32_le_benchmark: len=3D16384: 816 MB/s
  | +    # crc32_le_benchmark: len=3D16: 439 MB/s
  | +    # crc32_le_benchmark: len=3D64: 1209 MB/s
  | +    # crc32_le_benchmark: len=3D127: 1067 MB/s
  | +    # crc32_le_benchmark: len=3D128: 1616 MB/s
  | +    # crc32_le_benchmark: len=3D200: 1739 MB/s
  | +    # crc32_le_benchmark: len=3D256: 1951 MB/s
  | +    # crc32_le_benchmark: len=3D511: 1855 MB/s
  | +    # crc32_le_benchmark: len=3D512: 2174 MB/s
  | +    # crc32_le_benchmark: len=3D1024: 2301 MB/s
  | +    # crc32_le_benchmark: len=3D3173: 2347 MB/s
  | +    # crc32_le_benchmark: len=3D4096: 2407 MB/s
  | +    # crc32_le_benchmark: len=3D16384: 2440 MB/s
  |      ok 6 crc32_le_benchmark
  |      ok 7 crc32_be_test
  | -    # crc32_be_benchmark: len=3D1: 27 MB/s
  | -    # crc32_be_benchmark: len=3D16: 258 MB/s
  | -    # crc32_be_benchmark: len=3D64: 388 MB/s
  | -    # crc32_be_benchmark: len=3D127: 402 MB/s
  | -    # crc32_be_benchmark: len=3D128: 424 MB/s
  | -    # crc32_be_benchmark: len=3D200: 438 MB/s
  | -    # crc32_be_benchmark: len=3D256: 444 MB/s
  | -    # crc32_be_benchmark: len=3D511: 449 MB/s
  | -    # crc32_be_benchmark: len=3D512: 455 MB/s
  | -    # crc32_be_benchmark: len=3D1024: 461 MB/s
  | -    # crc32_be_benchmark: len=3D3173: 463 MB/s
  | -    # crc32_be_benchmark: len=3D4096: 465 MB/s
  | -    # crc32_be_benchmark: len=3D16384: 466 MB/s
  | +    # crc32_be_benchmark: len=3D1: 25 MB/s
  | +    # crc32_be_benchmark: len=3D16: 251 MB/s
  | +    # crc32_be_benchmark: len=3D64: 458 MB/s
  | +    # crc32_be_benchmark: len=3D127: 496 MB/s
  | +    # crc32_be_benchmark: len=3D128: 547 MB/s
  | +    # crc32_be_benchmark: len=3D200: 569 MB/s
  | +    # crc32_be_benchmark: len=3D256: 605 MB/s
  | +    # crc32_be_benchmark: len=3D511: 621 MB/s
  | +    # crc32_be_benchmark: len=3D512: 637 MB/s
  | +    # crc32_be_benchmark: len=3D1024: 657 MB/s
  | +    # crc32_be_benchmark: len=3D3173: 668 MB/s
  | +    # crc32_be_benchmark: len=3D4096: 671 MB/s
  | +    # crc32_be_benchmark: len=3D16384: 674 MB/s
  |      ok 8 crc32_be_benchmark
  |      ok 9 crc32c_test
  |      # crc32c_benchmark: len=3D1: 31 MB/s
  | -    # crc32c_benchmark: len=3D16: 457 MB/s
  | -    # crc32c_benchmark: len=3D64: 682 MB/s
  | -    # crc32c_benchmark: len=3D127: 620 MB/s
  | -    # crc32c_benchmark: len=3D128: 744 MB/s
  | -    # crc32c_benchmark: len=3D200: 769 MB/s
  | -    # crc32c_benchmark: len=3D256: 779 MB/s
  | -    # crc32c_benchmark: len=3D511: 758 MB/s
  | -    # crc32c_benchmark: len=3D512: 797 MB/s
  | -    # crc32c_benchmark: len=3D1024: 807 MB/s
  | -    # crc32c_benchmark: len=3D3173: 806 MB/s
  | -    # crc32c_benchmark: len=3D4096: 813 MB/s
  | -    # crc32c_benchmark: len=3D16384: 816 MB/s
  | +    # crc32c_benchmark: len=3D16: 446 MB/s
  | +    # crc32c_benchmark: len=3D64: 1188 MB/s
  | +    # crc32c_benchmark: len=3D127: 1066 MB/s
  | +    # crc32c_benchmark: len=3D128: 1600 MB/s
  | +    # crc32c_benchmark: len=3D200: 1727 MB/s
  | +    # crc32c_benchmark: len=3D256: 1941 MB/s
  | +    # crc32c_benchmark: len=3D511: 1854 MB/s
  | +    # crc32c_benchmark: len=3D512: 2164 MB/s
  | +    # crc32c_benchmark: len=3D1024: 2300 MB/s
  | +    # crc32c_benchmark: len=3D3173: 2345 MB/s
  | +    # crc32c_benchmark: len=3D4096: 2402 MB/s
  | +    # crc32c_benchmark: len=3D16384: 2437 MB/s
  |      ok 10 crc32c_benchmark
  |      ok 11 crc64_be_test
  | -    # crc64_be_benchmark: len=3D1: 64 MB/s
  | -    # crc64_be_benchmark: len=3D16: 144 MB/s
  | -    # crc64_be_benchmark: len=3D64: 154 MB/s
  | -    # crc64_be_benchmark: len=3D127: 156 MB/s
  | -    # crc64_be_benchmark: len=3D128: 156 MB/s
  | -    # crc64_be_benchmark: len=3D200: 156 MB/s
  | -    # crc64_be_benchmark: len=3D256: 156 MB/s
  | -    # crc64_be_benchmark: len=3D511: 157 MB/s
  | -    # crc64_be_benchmark: len=3D512: 157 MB/s
  | -    # crc64_be_benchmark: len=3D1024: 157 MB/s
  | -    # crc64_be_benchmark: len=3D3173: 158 MB/s
  | -    # crc64_be_benchmark: len=3D4096: 158 MB/s
  | -    # crc64_be_benchmark: len=3D16384: 158 MB/s
  | +    # crc64_be_benchmark: len=3D1: 29 MB/s
  | +    # crc64_be_benchmark: len=3D16: 264 MB/s
  | +    # crc64_be_benchmark: len=3D64: 476 MB/s
  | +    # crc64_be_benchmark: len=3D127: 499 MB/s
  | +    # crc64_be_benchmark: len=3D128: 558 MB/s
  | +    # crc64_be_benchmark: len=3D200: 576 MB/s
  | +    # crc64_be_benchmark: len=3D256: 611 MB/s
  | +    # crc64_be_benchmark: len=3D511: 621 MB/s
  | +    # crc64_be_benchmark: len=3D512: 638 MB/s
  | +    # crc64_be_benchmark: len=3D1024: 659 MB/s
  | +    # crc64_be_benchmark: len=3D3173: 667 MB/s
  | +    # crc64_be_benchmark: len=3D4096: 671 MB/s
  | +    # crc64_be_benchmark: len=3D16384: 674 MB/s
  |      ok 12 crc64_be_benchmark
  |      ok 13 crc64_nvme_test
  | -    # crc64_nvme_benchmark: len=3D1: 64 MB/s
  | -    # crc64_nvme_benchmark: len=3D16: 144 MB/s
  | -    # crc64_nvme_benchmark: len=3D64: 154 MB/s
  | -    # crc64_nvme_benchmark: len=3D127: 156 MB/s
  | -    # crc64_nvme_benchmark: len=3D128: 156 MB/s
  | -    # crc64_nvme_benchmark: len=3D200: 156 MB/s
  | -    # crc64_nvme_benchmark: len=3D256: 156 MB/s
  | -    # crc64_nvme_benchmark: len=3D511: 157 MB/s
  | -    # crc64_nvme_benchmark: len=3D512: 157 MB/s
  | -    # crc64_nvme_benchmark: len=3D1024: 157 MB/s
  | -    # crc64_nvme_benchmark: len=3D3173: 158 MB/s
  | -    # crc64_nvme_benchmark: len=3D4096: 158 MB/s
  | -    # crc64_nvme_benchmark: len=3D16384: 158 MB/s
  | +    # crc64_nvme_benchmark: len=3D1: 36 MB/s
  | +    # crc64_nvme_benchmark: len=3D16: 479 MB/s
  | +    # crc64_nvme_benchmark: len=3D64: 1340 MB/s
  | +    # crc64_nvme_benchmark: len=3D127: 1179 MB/s
  | +    # crc64_nvme_benchmark: len=3D128: 1766 MB/s
  | +    # crc64_nvme_benchmark: len=3D200: 1965 MB/s
  | +    # crc64_nvme_benchmark: len=3D256: 2201 MB/s
  | +    # crc64_nvme_benchmark: len=3D511: 2087 MB/s
  | +    # crc64_nvme_benchmark: len=3D512: 2464 MB/s
  | +    # crc64_nvme_benchmark: len=3D1024: 2331 MB/s
  | +    # crc64_nvme_benchmark: len=3D3173: 2673 MB/s
  | +    # crc64_nvme_benchmark: len=3D4096: 2745 MB/s
  | +    # crc64_nvme_benchmark: len=3D16384: 2782 MB/s
  |      ok 14 crc64_nvme_benchmark
  |  # crc: pass:14 fail:0 skip:0 total:14
  |  # Totals: pass:14 fail:0 skip:0 total:14

That's a significant speed up for this popular SoC, and it would be
great to get this series in for the next merge window! Thank you!

Tested-by: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>


Bj=C3=B6rn
