Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4794E79DF
	for <linux-crypto@vger.kernel.org>; Tue,  2 Jul 2024 05:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898490; cv=none; b=Oz/DSiRy6znkJtvI/II+GIsDQbtcnPcpo/33V21yj41G5taxnV9sNHp68PsfXP96manIkZjT8v6URZ3WE86xzyiFp/gW1AhJbV6FC9P3j4/xdchMy3yx057qCpFHs+hZGIppHFHgrSevI38/5uTdGzBHu9SiUU0t4Av9H2tD5lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898490; c=relaxed/simple;
	bh=FjtVOHtZTmMqztivu3c1awxhvlnUREuGjkoEgVHP1aw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=R3QrsiQZ/NcaqwTbaWvBbn7Yy97W/IXi8DKxQ+rTjNSCvB0LMUc47IOEUxPApnMGztnW1uFeKNr2nNit6xvFOyXfauseeN1Lj53+/fG/Ysb03Pu/l40F76kaa4H+AsKL80wtFgKKXkxYj80VVeN93gxxfr2pdv/zYA5lmRE60Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bade.nz; spf=pass smtp.mailfrom=leithalweapon.geek.nz; dkim=pass (2048-bit key) header.d=bade.nz header.i=@bade.nz header.b=MoDIET7e; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bade.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leithalweapon.geek.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bade.nz header.i=@bade.nz header.b="MoDIET7e"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-25c9786835eso2240897fac.3
        for <linux-crypto@vger.kernel.org>; Mon, 01 Jul 2024 22:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bade.nz; s=google; t=1719898486; x=1720503286; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k9AFZnKOW/OV6MX+SwcsEAZ4wLQxlx3trIXu3lIbf/g=;
        b=MoDIET7euHU3CJjqzPZmah6R5X/8ODKz0NUgYKsYkxyn3EvRvTzwgrYTcZPbl1BUJj
         teGuUz0TV8fN7H9PQO0q2gcv+R9shGrPLkFbjb2zEf9Ljv9HI98ycUbUFCG1yn11Owv1
         DPDQqg+vgpTxILOY2tKiiUey0AjH+qS3uOhFCYQ9pb8fqLAXbWh6AJjcKfUNZq6FxIIe
         PVPue/58nbSvyUm6XZer9RPYyxjpOjFKq7EDEa9V+bDmoRVrP7tJ0jeGV/8DTtAAEXE+
         3qRGEqjJjxM5GUvRrLRtdtT9OY+JpsoD6Swax4QD9Zfw7DzvqHV2qAD9CiwNAYaKvvqZ
         xUEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719898486; x=1720503286;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k9AFZnKOW/OV6MX+SwcsEAZ4wLQxlx3trIXu3lIbf/g=;
        b=A7z0HEQMYkFcskSH0ELagmLx1tCPIy+hYjEha2BWI2WpcXFrhTFCYBNKg6qPN1Wp3t
         K+crPTGsL0dAb4HqLLq9VOdm3HytUk4SFrFUBhulPeVXbbrMApBpz+BUQCMIhBOnFLJG
         vwEjpY0MDd/cMOWQfGdwXBwj+ICq8N7IZauoa2beNCGDmul7NrTMwKzWHMFx/RANLh6Z
         2XxF5WnsXASpnSE34giyceHoP2cLGMvSUajOCdgAvHnhdsVjq119hYVP7qRsn8Q9gMRU
         DpuCh4fS8Ygle3T8Qvt3Po5SLN0S8QIz4gGOmKq6Z+tALs73uUjnoEakFmMWTUp3TQEE
         Kstg==
X-Gm-Message-State: AOJu0YxCff66p1JX6QhVFpkkrLP54uyQFqvmsllOyIEvdeJVfnLCKj1t
	BCqoAklJQjzfBNH+g9VQf7b6QA8skQvITOwImqJJwfKkbSjn0hxQz+ab36FwiMa2bjlHUvgZ2eH
	jZIG8kezV8fWr73Fzlqf3RLHBTGV2Um77/ptUXcwGDt/ttaDDmBQH
X-Google-Smtp-Source: AGHT+IGwmszSMGvkr08n3X/1OA+McVqsuTBXL5fJP3TwrrQ1RIEyspXl4H4r6TlV6E4NoKTdD8pvCypu529lgIOLxnA=
X-Received: by 2002:a05:6870:2407:b0:254:bd24:de85 with SMTP id
 586e51a60fabf-25db340de8amr6736728fac.16.1719898486503; Mon, 01 Jul 2024
 22:34:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Leith Bade <leith@bade.nz>
Date: Tue, 2 Jul 2024 15:34:35 +1000
Message-ID: <CAPDEroXky+PJ29VcR6vsrdQ6uk43DekCvmiZGUqxxYHrYXrYoA@mail.gmail.com>
Subject: Failed self-tests with crypto-safexcel on MediaTek MT7986 SoC
To: linux-crypto@vger.kernel.org
Cc: atenart@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I am using a Banana Pi BPI-R3 router board, which has a MediaTek
MT7986 SoC, with Linux  and I have noticed a large number of error
messages and stack traces in my kernel boot log related to the
crypto-safexcel module. The errors all related to a large number of
failed self-tests for both hashing and encryption, thus I believe this
device is not working correctly at all.

I have been using the current Debian unstable distribution with a
variety of kernel builds. I have seen the errors with both Debian and
"vanilla" builds of v6.8.12, v6.9.7 and v6.10.0-rc6.

To reproduce, simply boot Linux on the BPI-R3 using the compiled DTS
file  arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dts with
the crypto-safexcel module enabled via the CONFIG_CRYPTO_DEV_SAFEXCEL
option.

Any help fixing these errors would be appreciated.

The relevant boot log messages:

crypto-safexcel 10320000.crypto:
EIP97:230(0,1,4,4)-HIA:270(0,5,5),PE:150/433(alg:7fcdfc00)/0/0/0

alg: ahash: safexcel-sha384 test failed (wrong result) on test vector
1, cfg="init+update+final aligned buffer"
alg: self-tests for sha384 using safexcel-sha384 failed (rc=-22)

alg: ahash: safexcel-sha512 test failed (wrong result) on test vector
1, cfg="init+update+final aligned buffer"
alg: self-tests for sha512 using safexcel-sha512 failed (rc=-22)

alg: ahash: safexcel-hmac-sha384 setkey failed on test vector 0;
expected_error=0, actual_error=-80, flags=0x1
alg: self-tests for hmac(sha384) using safexcel-hmac-sha384 failed (rc=-80)

alg: ahash: safexcel-hmac-sha512 setkey failed on test vector 0;
expected_error=0, actual_error=-80, flags=0x1
alg: self-tests for hmac(sha512) using safexcel-hmac-sha512 failed (rc=-80)

alg: aead: safexcel-authenc-hmac-sha512-cbc-aes encryption test failed
(wrong result) on test vector 0, cfg="in-place (one sglist)"
alg: self-tests for authenc(hmac(sha512),cbc(aes)) using
safexcel-authenc-hmac-sha512-cbc-aes failed (rc=-22)

alg: aead: safexcel-authenc-hmac-sha512-cbc-des3_ede encryption test
failed (wrong result) on test vector 0, cfg="in-place (one sglist)"
alg: self-tests for authenc(hmac(sha512),cbc(des3_ede)) using
safexcel-authenc-hmac-sha512-cbc-des3_ede failed (rc=-22

alg: aead: safexcel-authenc-hmac-sha384-cbc-des3_ede encryption test
failed (wrong result) on test vector 0, cfg="in-place (one sglist)"
alg: self-tests for authenc(hmac(sha384),cbc(des3_ede)) using
safexcel-authenc-hmac-sha384-cbc-des3_ede failed (rc=-22)

alg: aead: safexcel-authenc-hmac-sha512-cbc-des encryption test failed
(wrong result) on test vector 0, cfg="in-place (one sglist)"
alg: self-tests for authenc(hmac(sha512),cbc(des)) using
safexcel-authenc-hmac-sha512-cbc-des failed (rc=-22)

alg: aead: safexcel-authenc-hmac-sha384-cbc-des encryption test failed
(wrong result) on test vector 0, cfg="in-place (one sglist)"
alg: self-tests for authenc(hmac(sha384),cbc(des)) using
safexcel-authenc-hmac-sha384-cbc-des failed (rc=-22)

Thanks,
Leith Bade
