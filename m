Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8AA1A3A9A
	for <linux-crypto@vger.kernel.org>; Tue, 24 Sep 2024 11:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727177015; cv=none; b=WQFYOMRhWKqjfTaXTskpfIA7ErkaWyx20rwwsuNX3zWT7HDb6cRaiY50wXMuHUi3w2gYTYflx+hqdRptb3AQhheIUxgWjEu946uLPOReMWkfUHBC43aBkOj1+uW7ierGa5SvMTyUIXjH+rbrngRlmORNIhS0eTbn4zv7+JS8n+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727177015; c=relaxed/simple;
	bh=bQRUkudaiO8uCsCczaXYpDU5zY+jAYNiEvB1WHfLw9E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zkv/YnSrAIktKkmKrhXwoLCWwij/AIctfnymTvhHKC6pTsNDjb7fON/BZk0bf+AkvLRFUW1ll5o+zkhvtb8FDTRHLTrIbL3zg3uM6bsCZFbDFTAfARYa69s38camRqRMQs1tZOp2QGdG/MWseipT4K3vH8yu4lgCChqGkZNI4W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uzanYcNi; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uzanYcNi"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-501274e2c29so1610712e0c.3
        for <linux-crypto@vger.kernel.org>; Tue, 24 Sep 2024 04:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727177011; x=1727781811; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KjdEl0kfRqlw8okFJhhXvORQBqugd848yp2a6Kz7jtI=;
        b=uzanYcNiTobz+EUbzYKDJ34bFtRNGWkdxvLooX5wgJyq/KgQ8BUvORZIX1RzSf6KWQ
         aAf8FnlN92WT2wYW3EoVfQ6L6FsPYNQ3I9EDkvH9+H9Pod8RRcnuTuJqpfcAusqa+qIC
         j1L4JU2uFsh0T5BaJKXpfyaIYRtP4n6kD4auFWsBrDOBzTychWYsB6B0158ZAGdfbPKh
         VTDD3auXiSpSfvMDUkaKEwR2hRTdz0b8nJI9Ykw1zBrJWUfHVnktLSqql6EPvHxyyW8y
         9JGwEOq8MhgYTTnDcXEEXubtFnUOnsACNuc72euMImJOUUc0OEIEzQ6JEiPDnK7LBwR1
         KKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727177011; x=1727781811;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KjdEl0kfRqlw8okFJhhXvORQBqugd848yp2a6Kz7jtI=;
        b=kr7oSyOkEyyzBfR9dfWppQakCqpUAZzj6TSuFcs/msiORbj+THiuh67uS8YwgCtEKy
         9nfz4QMh8DPNKpyM2ntYcQ0stn7GaeDcC6D9GlQAE9RsIZ0whbPWHZCFX9JysJISBf50
         pTXYroWbn58Y6sw12fOxTyCS9hqAbRgEgrcKZYBsPdf7ibTDEAQA3QSDXlHOaKtiNtpr
         DZdM/hRkNxSVRrRBgwhIUsKbwUgIyaxdnfVwuiDPDSlknb3Cskjvykl7X4ss8ge/eMML
         nMHjxifNrMYBDK57dO9vKQoJgPqxXubxaXArVFKWrdgNZDtpQbS/ZNde9buPqOjrUml1
         9pfA==
X-Forwarded-Encrypted: i=1; AJvYcCW+Nofi4gTT+0FzIoy/xDJWIDoM5CN2UsOA4K97RfEfgQ1EEkD0HvL0HEAzzjfUVvj6JSQEJpOnY1+y/gA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYfaKdnku++CeLhO7NASlIB9dbSnp2U5N6soVs4Ef3CfFk/2cW
	l5BuXRlG7ogQFc4jMrtjw4VIb+YavUhOO7g/9xhZ4mkl52ycIhGCmefaRASFTmuAguB3DSlk98q
	wpEdFqxsnfjuNleOc4kZrGDPJokChn86B0BGfqA==
X-Google-Smtp-Source: AGHT+IEI7XjbuorHGWTR1E3X/+r/7ORf73vJlzjELjbAYRDPDVaPLPO0nhzOjurzdZrh5ZpFYfyg/8r0kv6TUteT69Y=
X-Received: by 2002:a05:6122:2213:b0:503:d875:6a26 with SMTP id
 71dfb90a1353d-503e0400c97mr9329354e0c.5.1727177011299; Tue, 24 Sep 2024
 04:23:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+G9fYtu-h_pp_hNfmx1pBg48oGeRiEDnEc4b-r3AiC_QfWiKg@mail.gmail.com>
In-Reply-To: <CA+G9fYtu-h_pp_hNfmx1pBg48oGeRiEDnEc4b-r3AiC_QfWiKg@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 24 Sep 2024 16:53:18 +0530
Message-ID: <CA+G9fYsHQ_q9e5GYVpdMmaRrgR1zvoyFH0wP0RzbqUFBTuNq9Q@mail.gmail.com>
Subject: Re: af_alg01.c:36: TFAIL: instantiated nested hmac algorithm ('hmac(hmac(md5))')!
To: LTP List <ltp@lists.linux.it>, open list <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc: "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Anders Roxell <anders.roxell@linaro.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, chrubis <chrubis@suse.cz>
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Sept 2024 at 15:16, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> The following LTP crypto tests failed on Linus mainline master branch.
>
> LTP
>   ltp-crypto:
>     * af_alg03
>     * af_alg01
>
> First seen on e8fc317dfca9 (v6.11-2185-ge8fc317dfca9)
>   Good: v6.11-rc7
>   BAD:  e8fc317dfca9 (v6.11-2185-ge8fc317dfca9) and (v6.11)

Also seen on Linux next from next-20240909 tag.

Good:  next-20240906
Bad:   next-20240909

>
> Devices and qemu's:
>   - dragonboard-410c
>   - dragonboard-845c
>   - e850-96
>   - juno-r2
>   - arm64
>   - qemu-arm64
>   - qemu-armv7
>   - qemu-riscv64
>   - qemu-x86_64
>   - rk3399-rock-pi-4b
>   - x15
>   - x86_64
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Warning log:
> ----------
> tst_test.c:1617: TINFO: Timeout per run is 0h 02m 30s
> af_alg01.c:36: TFAIL: instantiated nested hmac algorithm ('hmac(hmac(md5))')!
> tst_af_alg.c:46: TBROK: unexpected error binding AF_ALG socket to hash
> algorithm 'hmac(hmac(md5))': EINVAL (22)
>
> HINT: You _MAY_ be missing kernel fixes:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=af3ff8045bbf
>
> HINT: You _MAY_ be vulnerable to CVE(s):
>
> https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-17806
>
> HINT: You _MAY_ be missing kernel fixes:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=af3ff8045bbf
>
> HINT: You _MAY_ be vulnerable to CVE(s):
>
> https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-17806
>
> ...
> tst_test.c:1617: TINFO: Timeout per run is 0h 02m 30s
> af_alg03.c:22: TFAIL: instantiated rfc7539 template with wrong digest size
>
> HINT: You _MAY_ be missing kernel fixes:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e57121d08c38
>
>
> boot Log links,
> --------
>  - https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v6.11-8836-gf8eb5bd9a818/testrun/25191971/suite/ltp-crypto/test/af_alg03/log
> - https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2m983y1hatxwkXBtrAYvCPw6pK2
>
> Test results history:
> ----------
> - https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v6.11-8836-gf8eb5bd9a818/testrun/25191971/suite/ltp-crypto/test/af_alg01/history/
> - https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v6.11-8836-gf8eb5bd9a818/testrun/25191971/suite/ltp-crypto/test/af_alg01/history/
>
> metadata:
> ----
>   git describe:  v6.11-2185-ge8fc317dfca9 .. v6.11-5002-g200289db261f
>   git repo: https://gitlab.com/Linaro/lkft/mirrors/torvalds/linux-mainline
>   git sha:  abf2050f51fdca0fd146388f83cddd95a57a008d  (v6.11)
>   kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2m980TaGzPk0qjtFUPnMNoDj7Sw/config
>   build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2m980TaGzPk0qjtFUPnMNoDj7Sw/
>   toolchain: gcc-13
>
> Steps to reproduce:
> ---------
> - https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2m983y1hatxwkXBtrAYvCPw6pK2/reproducer
> - https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2m983y1hatxwkXBtrAYvCPw6pK2/tux_plan
>
> --
> Linaro LKFT
> https://lkft.linaro.org

- Naresh
