Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23131BE873;
	Tue,  2 Jul 2024 17:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719942840; cv=none; b=ZlRIZyh8G0zfLUFfbazj3+w9O5LgxTsCcMiM9kkCTiZiiiJh4sTGCqt4Fl0TQaNW74DoqrIhFMrYdo2ailXXeGpAdHRBKyArmOF5+T0B/Ye7axFSlnqvnRzrQ89um2v0rPKkg6JEgWcOWGx2EZixUsPwOE/OMFyDk1mOxW66q+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719942840; c=relaxed/simple;
	bh=yvLMvBy0+1otlEibY6ok9ydC9gmPj672qN+b7belio0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OtCjKJJjGl3YWz3WAe+NdPmoULPjoMvtAs83YY4DcG+HLQE1COgrBHNPyeFW/tk1r2Qbt4K/KOUrNjzzBYeJeg/vhH1zgPJpP670eZ3CYZqHqUeUbNgvDKciQfXT2IzWB42BU/8HGRS4M644socqTIhJFy1H3Pbd5gSWgLa4KKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a70c0349b64so596175166b.1;
        Tue, 02 Jul 2024 10:53:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719942837; x=1720547637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WFhXTk49J7JdTh0lfYEvpqmeq+8M8zcqsRkfkO5ZaBg=;
        b=HaKPXUQT3Q0G/VHLwNRATAahOGqOng/2BsW59qBOmrSff6BP0PinFqWnP+jL8aUYHq
         AycB2BEwmTaqzs9rXJjb4pFTl20KfPeoJNipJo91xbKkWWqC43nqG8bAnROYfEhqx+eg
         oH+PrDNOsAJhpg2ez31qvS80i2MkwP1LVd83XADrwgHc0xsZdQVz7y19EQ35PJ4YXl+I
         Yyc8P7txWgdw5C46n6GQDYVwTsSySAgqsVpKbVYrJ7Iwv8iMddKf7tTxg9jvA1TfU3S0
         CF1lJ4C7izaY1KxoFVJ8D8gxgIo7QMf5P+cUC5IbjTNJqngqh2W4k3dWATkrK0CmdGeL
         S7Sg==
X-Forwarded-Encrypted: i=1; AJvYcCWukf+uMVFrJedfWXEDZdL1X0mQDUIdvMzlpUbxA9/+6XXzD3MYZ+KP0bB1rQIQELcNXkxv1KzwcgMU8SDocTfcT5Kqu7zGjqo08pcjI6JZuOzXUFo9Z8iIEQOknm7neyvhkC1fhcVCSfCWSc5lBQWtyK6dqXG5GSVyTZUdKRUCkdQN
X-Gm-Message-State: AOJu0YyJ6x4yxgG63LtZYCtAmxi9UDeRFjybBrfhmnBDzskLJEYaNzTQ
	ouA8TZGM+a03KQ7+K/p0rfQDrOC4lgDAsieQnTrwOEJp0iM85OyTgd+Uww==
X-Google-Smtp-Source: AGHT+IFnAVqJ3O2Q8aIdhmkkjE1j+Fm1XfaodkkcdmoRrrC68/Bn9KyBFsMLV+BTv1FvVW1s5rafow==
X-Received: by 2002:a17:906:29cf:b0:a6f:17a9:947a with SMTP id a640c23a62f3a-a75144a8a9cmr544931866b.71.1719942836902;
        Tue, 02 Jul 2024 10:53:56 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-113.fbsv.net. [2a03:2880:30ff:71::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72ab0651dfsm448430766b.142.2024.07.02.10.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 10:53:56 -0700 (PDT)
Date: Tue, 2 Jul 2024 10:53:54 -0700
From: Breno Leitao <leitao@debian.org>
To: kernel test robot <lkp@intel.com>
Cc: kuba@kernel.org, horia.geanta@nxp.com, pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	horms@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] crypto: caam: Make CRYPTO_DEV_FSL_CAAM
 dependent of COMPILE_TEST
Message-ID: <ZoQ+snH2GTnwKNT2@gmail.com>
References: <20240628161450.2541367-2-leitao@debian.org>
 <202407011309.cpTuOGdg-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202407011309.cpTuOGdg-lkp@intel.com>

On Mon, Jul 01, 2024 at 01:48:21PM +0800, kernel test robot wrote:

> reproduce:
>         git clone https://github.com/intel/lkp-tests.git ~/lkp-tests
>         # apt-get install sparse
>         # sparse version: v0.6.4-66-g0196afe1
>         # https://github.com/intel-lab-lkp/linux/commit/ca1603af1770827216f5f67a91f6f13fbb05a050
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Breno-Leitao/crypto-caam-Make-CRYPTO_DEV_FSL_CAAM-dependent-of-COMPILE_TEST/20240630-073726
>         git checkout ca1603af1770827216f5f67a91f6f13fbb05a050
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-13.2.0 ~/lkp-tests/kbuild/make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__ -fmax-errors=unlimited -fmax-warnings=unlimited' O=build_dir ARCH=m68k olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-13.2.0 ~/lkp-tests/kbuild/make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__ -fmax-errors=unlimited -fmax-warnings=unlimited' O=build_dir ARCH=m68k SHELL=/bin/bash

Thanks, this seems a valid error, but, I am unfortunately not able to
reproduce it:

	#  COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-13.2.0 ~/lkp-tests/kbuild/make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__-fmax-errors=unlimited -fmax-warnings=unlimited' O=build_dir ARCH=m68k SHELL=/bin/bash
	Compiler will be installed in /home/leit/0day
	PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/bin/:/home/leit/.cargo/bin:/usr/share/Modules/bin:/usr/lib64/ccache:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/usr/facebook/ops/scripts:/usr/facebook/scripts:/usr/facebook/ops/scripts:/usr/facebook/scripts:/usr/facebook/scripts:/usr/facebook/scripts/db:/usr/facebook/ops/scripts:/usr/facebook/scripts:/usr/facebook/scripts:/usr/facebook/scripts/db:/usr/local/sbin:/usr/sbin:/sbin:/var/www/scripts/bin:/home/leit/.yarn/bin:/home/leit/bin:/usr/facebook/ops/scripts:/usr/facebook/scripts:/usr/lib/cargo/bin:/home/leit/bin:/home/leit/.local/bin:/home/leit/bin:~/Devel/virtme:/home/leit/bin/virtme:/home/leit/bin/twtf:/home/leit/Devel/git-fuzzy/bin:/home/leit/bin/kernel:/home/leit/bin/git:/home/leit/bin/iterm:/usr/facebook/ops/scripts:/usr/facebook/scripts:/usr/local/sbin:/usr/sbin:/sbin:/var/www/scripts/bin:/home/leit/.yarn/bin
	make --keep-going CROSS_COMPILE=/home/leit/0day/gcc-13.2.0-nolibc/m68k-linux/bin/m68k-linux- --jobs=332 KCFLAGS= -Wtautological-compare -Wno-error=return-type -Wreturn-type -Wcast-function-type -funsigned-char -Wundef -fstrict-flex-arrays=3 -Wformat-overflow -Wformat-truncation -Wrestrict -Wenum-conversion C=1 CF=-fdiagnostic-prefix -D__CHECK_ENDIAN__-fmax-errors=unlimited -fmax-warnings=unlimited O=build_dir ARCH=m68k SHELL=/bin/bash
	make[1]: Entering directory '/home/leit/Devel/upstream/build_dir'
	  GEN     Makefile
	  CALL    ../scripts/checksyscalls.sh
	  CC      drivers/crypto/caam/error.o
	  CC      drivers/crypto/caam/ctrl.o
	  CC      drivers/crypto/caam/debugfs.o
	  CC      drivers/crypto/caam/jr.o
	  CC      drivers/crypto/caam/key_gen.o
	  CC      drivers/crypto/caam/caamalg.o
	  CC      drivers/crypto/caam/caamrng.o
	  CC      drivers/crypto/caam/caampkc.o
	  CC      drivers/crypto/caam/pkc_desc.o
	  CC      drivers/crypto/caam/caamalg_desc.o
	  CHECK   ../drivers/crypto/caam/debugfs.c
	command-line: note: in included file:
	builtin:1:25: sparse: warning: no whitespace before object-like macro body
	  CHECK   ../drivers/crypto/caam/error.c
	command-line: note: in included file:
	builtin:1:25: sparse: warning: no whitespace before object-like macro body
	  CHECK   ../drivers/crypto/caam/key_gen.c
	command-line: note: in included file:
	builtin:1:25: sparse: warning: no whitespace before object-like macro body
	  CHECK   ../drivers/crypto/caam/caamrng.c
	command-line: note: in included file:
	builtin:1:25: sparse: warning: no whitespace before object-like macro body
	  CHECK   ../drivers/crypto/caam/jr.c
	  CHECK   ../drivers/crypto/caam/pkc_desc.c
	command-line: note: in included file:
	builtin:1:25: sparse: warning: no whitespace before object-like macro body
	command-line: note: in included file:
	builtin:1:25: sparse: warning: no whitespace before object-like macro body
	  CHECK   ../drivers/crypto/caam/ctrl.c
	command-line: note: in included file:
	builtin:1:25: sparse: warning: no whitespace before object-like macro body
	  CHECK   ../drivers/crypto/caam/caampkc.c
	command-line: note: in included file:
	builtin:1:25: sparse: warning: no whitespace before object-like macro body
	  CHECK   ../drivers/crypto/caam/caamalg_desc.c
	command-line: note: in included file:
	builtin:1:25: sparse: warning: no whitespace before object-like macro body
	  CHECK   ../drivers/crypto/caam/caamalg.c
	command-line: note: in included file:
	builtin:1:25: sparse: warning: no whitespace before object-like macro body
	  AR      drivers/crypto/caam/built-in.a
	  AR      drivers/crypto/built-in.a
	  AR      drivers/built-in.a
	  AR      built-in.a
	  AR      vmlinux.a
	  LD      vmlinux.o
	  OBJCOPY modules.builtin.modinfo
	  GEN     modules.builtin
	  MODPOST vmlinux.symvers
	  UPD     include/generated/utsversion.h
	  CC      init/version-timestamp.o
	  CHECK   ../init/version-timestamp.c
	command-line: note: in included file:
	builtin:1:25: sparse: warning: no whitespace before object-like macro body
	  LD      .tmp_vmlinux.kallsyms1
	  NM      .tmp_vmlinux.kallsyms1.syms
	  KSYMS   .tmp_vmlinux.kallsyms1.S
	  AS      .tmp_vmlinux.kallsyms1.o
	  LD      .tmp_vmlinux.kallsyms2
	  NM      .tmp_vmlinux.kallsyms2.syms
	  KSYMS   .tmp_vmlinux.kallsyms2.S
	  AS      .tmp_vmlinux.kallsyms2.o
	  LD      vmlinux
	  NM      System.map
	cp vmlinux vmlinux.tmp
	/home/leit/0day/gcc-13.2.0-nolibc/m68k-linux/bin/m68k-linux-strip vmlinux.tmp
	gzip -9c vmlinux.tmp >vmlinux.gz
	rm vmlinux.tmp
	make[1]: Leaving directory '/home/leit/Devel/upstream/build_dir'


# The repo I am building:

	# git show --oneline
	ca1603af1770 (HEAD) crypto: caam: Make CRYPTO_DEV_FSL_CAAM dependent of COMPILE_TEST
	diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
	index c631f99e415f..05210a0edb8a 100644
	--- a/drivers/crypto/caam/Kconfig
	+++ b/drivers/crypto/caam/Kconfig
	@@ -10,7 +10,7 @@ config CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC

	 config CRYPTO_DEV_FSL_CAAM
		tristate "Freescale CAAM-Multicore platform driver backend"
	-       depends on FSL_SOC || ARCH_MXC || ARCH_LAYERSCAPE
	+       depends on FSL_SOC || ARCH_MXC || ARCH_LAYERSCAPE || COMPILE_TEST
		select SOC_BUS
		select CRYPTO_DEV_FSL_CAAM_COMMON
		imply FSL_MC_BUS

My version of tools:

	# sparse --version
	v0.6.4-66-g0196afe1

	# cd ~/lkp-tests; git show --stat
	commit 22f5cf2c860a5604f182f966b1f105ce1c0becb7 (HEAD -> master, origin/master, origin/HEAD)
