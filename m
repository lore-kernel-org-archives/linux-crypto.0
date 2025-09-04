Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CF72BE628;
	Thu,  4 Sep 2025 22:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757024080; cv=none; b=lGf4J/0jZbbgUfTBemN8bXx7mriZ5qqbt/+6nyMiFucGMg2mhWR9ooDCJI070Os1H66WyA4+jskJcuome0ZNFfWd2/mhaNM/J5PSPD4iZnfcZg21648vbFbj4+27Jx/bvm3dvex111mD1HdHrT0QIl5S7BDuFqy3qYUAlZi+1oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757024080; c=relaxed/simple;
	bh=GcGZtaZSU6b1sUG3mrrzrzTJN/LnPRrVri5+x4KSJeM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UAcpxwSom1zvbRNDoqfaKDIdFF47u0aODz9ssWSHBkHl+xibrwel8vwF1Z+Ff8lQqgk2PaAi91j7JedcaIpivijBJ9NTzk8Q1UmGHgMUHrFZUe8Vi//hkHZKjxitINPmV1vZ4DwDagQ6aYuM1rO6dsN88v5cyMnsKJp//Ux0wrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CRtKEo2z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CRtKEo2z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=e9OcEZhCafmEnhIeOfGwbc4R2zX5aLc1ZQfuyyBMc5I=; b=CRtKEo2ze0aes9KQLectsVmJDt
	67SzQ6WmiGNd03IkxHdgEzFU4KVZ6sjO2NPPNkEwwQ0dKqG6/AaSWkGmWnDWkmR4vKvjL8RgL9IOS
	4SGMvdueqy1wdlDa4ZGQTSt5ZevcEGJvNHxDKtRhuvDRlR8aZXlfs/vR2Sz2yy1GFV+xsb15Fdwvo
	MeZfZvSqvZxr4ChAr58AXD5OW7HxF0plukw6ta9N59n0OUZohuwNQge8pLmGz7DNsF/snat0G5FST
	ebBWIJyJJrVxfnOBGlOtSOiZ5TYzlS3y4AWN2fQ0kRp62AuwRVB1yyXSaf+Yk3xg4uzcn8Ye84UFr
	+d382qBA==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uuIE1-0000000EnUf-1QHV;
	Thu, 04 Sep 2025 22:14:37 +0000
Message-ID: <de23961f-ae2f-414b-8473-ce9eb17646fb@infradead.org>
Date: Thu, 4 Sep 2025 15:14:36 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 103/104] Documentation/crypto: add fips140.rst
To: Vegard Nossum <vegard.nossum@oracle.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
 Vladis Dronov <vdronov@redhat.com>, Stephan Mueller <smueller@chronox.de>,
 Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
 <20250904155216.460962-104-vegard.nossum@oracle.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250904155216.460962-104-vegard.nossum@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/4/25 8:52 AM, Vegard Nossum wrote:
> Add documentation for the FIPS140 standalone module.
> 
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> ---
>  Documentation/crypto/fips140.rst | 231 +++++++++++++++++++++++++++++++
>  Documentation/crypto/index.rst   |   1 +
>  2 files changed, 232 insertions(+)
>  create mode 100644 Documentation/crypto/fips140.rst
> 
> diff --git a/Documentation/crypto/fips140.rst b/Documentation/crypto/fips140.rst
> new file mode 100644
> index 000000000000..14a7fb7a69ed
> --- /dev/null
> +++ b/Documentation/crypto/fips140.rst
> @@ -0,0 +1,231 @@
> +=========================
> +FIPS140 standalone module
> +=========================
> +
> +:Author: Vegard Nossum <vegard.nossum@oracle.com>
> +
> +
> +Target audience
> +===============
> +
> +This document is primarily meant for Linux distribution developers and
> +maintainers. It may also be interesting for kernel developers
> +contributing to the kernel's crypto code as it explains some of the
> +concepts and rationale behind the architecture of the crypto code and
> +how FIPS support is implemented.
> +
> +
> +Introduction
> +============
> +
> +FIPS 140-3 is a Federal Information Protection Standard, "Security
> +Requirements for Cryptographic Modules", maintained by the US National
> +Institute of Standards and Technology (NIST). [#fips140]_
> +
> +Binary implementation of specific approved cryptographic algorithms
> +can be certified as part of the Cryptographic Module Validation
> +Program (CMVP). In practice, the certification process includes both
> +source and binary code, though the end result is a certification
> +attached to the binary code.
> +
> +Having FIPS 140-3 certification is a requirement for running in many
> +secure contexts -- many Linux distros certify their kernels in order
> +to satisfy these requirements.
> +
> +Many distros have certified the entire kernel as a "FIPS module" (not
> +to be confused with kernel modules). Unfortunately, this means that
> +one cannot change any part of the kernel without invalidating the
> +certification. Moreover, certification is a costly process that can
> +last up to or even more than 12 months.
> +
> +The FIPS 140 standalone module (AKA ``fips140.ko``) fixes this situation
> +by allowing one to build the kernel's crypto code once and reuse it in
> +subsequent builds, thus enabling the rest of the kernel to receive bug
> +fixes and updates without invalidating the certification of the FIPS
> +module.
> +
> +
> +Design
> +======
> +
> +Requirements:
> +
> +- the FIPS module must not impose a stable internal kernel API on
> +  mainline or stable kernels
> +- the FIPS module must be a single, contiguous binary file and its HMAC
> +  (for easy verification)
> +- all crypto algorithms and code must reside within the FIPS module
> +- no crypto code in the FIPS module can be used before the FIPS module
> +  has executed its self-tests
> +- the FIPS module only comes into play when the kernel is booted with
> +  ``fips=1``
> +- source code should be shared between the kernel and the FIPS module
> +  where possible
> +
> +In order to satisfy these requirements, we have settled on a design
> +where the FIPS module duplicates the crypto API and all the algorithm
> +implementations that are part of the FIPS module. To avoid source code
> +duplication, we use symlinks from ``fips140/`` to the rest of the kernel
> +tree and build this directory as an external module -- in other words,
> +all the code and algorithms is built twice; once as part of vmlinux
> +and/or regular (non-FIPS) kernel modules, and once as part of
> +``fips140.ko``.
> +
> +To allow hot-swapping the crypto code (API + algorithms) at runtime
> +(i.e. when ``fips=1`` is detected during boot), we wrap any exported
> +symbols in C macros. These macros use static calls (see [#static_call]_)
> +to patch any and all users of the crypto code to call the FIPS module's
> +version of these functions instead of the functions in vmlinux.
> +
> +``fips140.ko`` is not really an ordinary kernel module -- it is not
> +meant to be loaded with ``modprobe`` or ``insmod``; instead, it is
> +embedded into the ``vmlinux`` image at build time. This avoid any
> +chicken-and-egg issues around how to verify cryptographic signatures
> +without using unverified crypto code. ``fips140.ko`` is loaded during
> +early boot -- before any crypto code is used by the kernel.

Hm, I was going to look at how that is done, but I cannot find any
downloadable fips140 source code. Is it available for free download
somewhere?

Is it GPL-v2 licensed?


> +
> +The code for the FIPS 140 standalone module is therefore split into
> +two parts: the module itself (``fips140.ko``) and the loader
> +(``crypto/fips140-loader.c``). The loader is **NOT** part of the module
> +itself and is not covered by the certification; however, it is
> +essentially just a wrapper around the kernel module loader that runs
> +during early boot.
> +
> +We provide no explicit mechanisms to ensure compatibility between a
> +precompiled FIPS module and the rest of the kernel; this is the
> +responsibility of distros that choose to use the standalone FIPS module.
> +
> +
> +Building
> +========
> +
> +First off, ensure that ``CONFIG_CRYPTO_FIPS140_EXTMOD`` is enabled.
> +
> +Prepare for building out-of-tree module::
> +
> +  make modules_prepare
> +
> +Build fips140.ko as an out-of-tree module::
> +
> +  make M=fips140/ KBUILD_MODPOST_WARN=1
> +  cp fips140/fips140.ko crypto/
> +
> +Generate fips140.hmac::
> +
> +  hmac_key=$(awk -F'"' '/^CONFIG_CRYPTO_FIPS140_HMAC_KEY=/{print $2}' .config)
> +  openssl dgst -sha256 -hmac $hmac_key -binary -out crypto/fips140.hmac crypto/fips140.ko
> +
> +Build the rest of the kernel::
> +
> +  make
> +
> +
> +Adopting a standaline FIPS module for your distro
> +=================================================
> +
> +1. Carefully select which algorithms you want your FIPS module to
> +   provide (``CONFIG_FIPS140_*`` and ``CONFIG_CRYPTO_FIPS140_*``
> +   options)
> +
> +2. Integrate building ``fips140/`` as an out-of-tree module with the
> +   build system used by your distro's package manager.
> +
> +   - You may want to strip and separate out debuginfo before copying
> +     ``fips140.ko`` into ``crypto/``.
> +   - You need a mechanism to save and reintroduce the precompiled
> +     ``fips140.ko`` between builds.
> +   - All of this "build support" infrastructure is out of scope for
> +     mainline.
> +
> +3. Verify that the FIPS module satisfies your specific operational
> +   requirements.
> +
> +4. Submit the FIPS module to the certifying lab.
> +
> +.. warning::
> +   Mainline developers cannot and will not assist in getting a specific
> +   FIPS module certified. The code provided in the mainline source tree
> +   is intended to make certification of standalone FIPS modules easier,
> +   but we do not guarantee that a build will be certifiable as-is out of
> +   the box. Moreover, different distributions have different use cases,
> +   different requirements, etc. and all of this influences the specifics
> +   of any given FIPS module. Mainline developers will not be responsible
> +   for the certification or certifiability of your FIPS module.
> +
> +
> +Useful commands
> +===============
> +
> +
> +Extracting ``fips140.ko`` from ``vmlinux``
> +------------------------------------------
> +
> +To extract ``fips140.ko`` and ``fips140.hmac`` from an existing
> +``vmlinux`` build, use::
> +
> +  $ scripts/extract-fips140 /path/to/vmlinux
> +  extracted fips140.ko
> +  extracted fips140.hmac
> +
> +
> +Verifying the ``fips140.ko`` HMAC digest
> +----------------------------------------
> +
> +To verify the HMAC digest of ``fips140.ko``, use::
> +
> +  $ key="Sphinx of black quartz, judge my vow"
> +  $ openssl dgst -sha256 -hmac "$key" -binary fips140.ko > fips140.hmac-computed
> +  $ cmp -s fips140.hmac fips140.hmac-computed && echo ok
> +  ok
> +
> +
> +List the symbols used by ``fips140.ko``
> +---------------------------------------
> +
> +To list the kernel symbols used by ``fips140.ko`` (useful for checking
> +whether all the necessary crypto functions have been included in the
> +module), use::
> +
> +  $ nm --undefined-only fips140.ko
> +
> +
> +Quick crypto verification using AF_ALG
> +--------------------------------------
> +
> +Testing whether the code works properly is fairly easy using Python
> +and the ``AF_ALG`` interface, e.g.::
> +
> +  import socket
> +
> +  ALG_SET_KEY = 1
> +
> +  s = socket.socket(socket.AF_ALG, socket.SOCK_SEQPACKET, 0)
> +  s.bind(('hash', 'hmac(sha256)'))
> +  s.setsockopt(socket.SOL_ALG, ALG_SET_KEY, b'x' * 16)
> +
> +  op, _ = s.accept()
> +  op.sendall(b'x' * 32)
> +  print(op.recv(32))
> +
> +
> +Tracing the crypto code
> +-----------------------
> +
> +Testing whether the FIPS module is used correctly can also be done
> +using a combination of Python (as above) and ``trace-cmd`` like this::
> +
> +  $ sudo trace-cmd record -p function_graph -g __sys_bind python hmac.py
> +  $ trace-cmd report
> +
> +
> +Contributing
> +============
> +
> +Patches welcome.

to what/where?

> +
> +
> +References
> +==========
> +
> +.. [#fips140] <https://csrc.nist.gov/pubs/fips/140-3/final>
> +.. [#static_call] <https://lwn.net/Articles/815908/>

Where are the other 103 patches?

thanks.
-- 
~Randy

