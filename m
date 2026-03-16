Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D104E3ED5B2;
	Mon, 16 Mar 2026 20:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773693733; cv=none; b=Y0wZ/4nwQTJy14mbwsDy8u6v3vxIlPGFDDEnOFTxI/weQWkenZxrNfbBAa+BBFSq9DuXvhf2xfHzYrFS1X9r0YpN8jm86YLHUs5axuwABB5oXlmzzON4VbpaO/nuWYfBVmifUWpYrJYScK1qYsIsx0AWU+8Vcj5fxaIDbz+rSm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773693733; c=relaxed/simple;
	bh=y9nSUavmq2qfyNgwjVX9IqHGrA+3BGRBXOrdK7EtY0M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WnZI68CcztNpZCMxICQBGEIbPyGRfcr2ooED2slYYXaOUW7yfnvt/FiuzC62P6uw3WwI1Ua1Kavre1BfSGAMGOH8rU4OhKEyKSuTbeVEc8RX0nvAdaD1fabCieLHQ9g0s8gpkoj7gbykCIyJKTqFc2qPpKqHRbdeAEM5p+WxX/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qoro5yMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qoro5yMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356CFC19424;
	Mon, 16 Mar 2026 20:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773693733;
	bh=y9nSUavmq2qfyNgwjVX9IqHGrA+3BGRBXOrdK7EtY0M=;
	h=Date:From:To:Cc:Subject:From;
	b=Qoro5yMKlIfmbm7vP8ooiisDSQpJ3JIQX/huSoKL2f5gmFuFCvAgknyGtsmTBBlgi
	 nfb+4c98BNBgME1XMMEoigTECT3HaAp8VBd/o8KdHcCM5Mgc6lj6+XyXdWmmaZgkxp
	 xlCeG2rhAsfFHoJNRH6zCCfIO9MIL2tlNcGJZ6JA4ZlgMq+2JaFT/WQaoaeuU5kGtN
	 f4wdGqqGtzWvuCfY/i9PqEp4hEBRdS/hgHSAZeNh7DAcg9trn9m3imRsB7S+7w2xP0
	 OU5cLMyOHdRSIYk4R1S7B4IQ9bjS1kJl1x5klw821LArduWPignjAAg6X8cgtWCHX4
	 U72jSO+p53ALw==
Date: Mon, 16 Mar 2026 13:42:11 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Subject: Does the SPARC optimized crypto and CRC code actually work?
Message-ID: <20260316204211.GA2661@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

The Linux kernel contains various SPARC crypto opcodes optimized
functions in lib/crypto/sparc/, lib/crc/sparc/, and arch/sparc/crypto/.

As the kernel's crypto and CRC code has been refactored over time, we've
been updating how the SPARC optimized code is integrated accordingly.
However, QEMU doesn't support the SPARC crypto opcodes, which means that
even though I (and maybe others) been running the tests on SPARC kernels
in QEMU, this doesn't actually execute the SPARC optimized code.

So I have to ask: is someone in the SPARC community actually testing
this code regularly?  That includes running all the KUnit tests for
crypto and CRC as well as the traditional crypto self-tests.

If not, then unless QEMU support is forthcoming I'd suggest we drop this
code to avoid issues on SPARC systems.  The generic code is much better
tested and we know that it works on any architecture, including SPARC.
Correctness is the first priority, especially for cryptography.

- Eric
