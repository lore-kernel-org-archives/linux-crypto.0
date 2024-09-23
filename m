Received: from relay-b03.edpnet.be (relay-b03.edpnet.be [212.71.1.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866B94AEEA
	for <linux-crypto@vger.kernel.org>; Mon, 23 Sep 2024 08:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.71.1.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727078887; cv=none; b=IaddXOjGU0/eFHeKUnwU+r+ZNMDX+O6S+Bp8jfWtH3tH94M0S4Up1bdIyvRl9YNIIIT1qnzE1tJFSvdnpOva0HwtzzUY21FXkYgxsWJ2CbwEMagHce/ThmEC7a+BLDP76S+YN4mUqsg3kl08QZSczVBOU1YkJD0wn2H4kWLRe7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727078887; c=relaxed/simple;
	bh=9Plzl5SQSlfJE3A9BpmRRDQkNBLFRTJ6hb/qjSKQFe8=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=UMBL9zsPiXWjtpnrquj4GGyOTiHjFNHi940ZDR5koAJgqUDJKgOQKfwTavJoPC89DfF2VfSjmzofEJEk8fKQ344+IZbVkjJekG0YpgMGWVnCxNpvKANatICh4nSjxDIbmADZWhgBqeUHs96PW3c/3+FjN/G8Bif5KbWkiyeevwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kabelmail.de; spf=fail smtp.mailfrom=kabelmail.de; arc=none smtp.client-ip=212.71.1.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kabelmail.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kabelmail.de
X-ASG-Debug-ID: 1727077782-24639c1dae10993b0001-Xm9f1P
Received: from [192.168.177.53] (94.105.112.108.dyn.edpnet.net [94.105.112.108]) by relay-b03.edpnet.be with ESMTP id DvKqFEDaGp8HfWqk; Mon, 23 Sep 2024 09:49:42 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 94.105.112.108.dyn.edpnet.net[94.105.112.108]
X-Barracuda-Apparent-Source-IP: 94.105.112.108
Message-ID: <ef2f6e41-bf9e-470e-a416-fda7ce5d8a51@kabelmail.de>
Date: Mon, 23 Sep 2024 09:48:54 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux.amoon@gmail.com
Cc: Jason@zx2c4.com, clabbe@baylibre.com, heiko@sntech.de,
 herbert@gondor.apana.org.au, hl@rock-chips.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rockchip@lists.infradead.org, mike.rudenko@gmail.com,
 robin.murphy@arm.com, shawn.lin@rock-chips.com, troy.lin@rock-chips.com,
 ty@wevs.org
References: <CANAwSgTTzZOwBaR9zjJ5VMpxm5BydtW6rB2S7jg+dnoX8hAoWg@mail.gmail.com>
Subject: Re: [PATCH] hw_random: rockchip: import driver from vendor tree
Content-Language: nl
X-ASG-Orig-Subj: Re: [PATCH] hw_random: rockchip: import driver from vendor tree
From: Janpieter Sollie <janpieter.sollie@kabelmail.de>
Autocrypt: addr=janpieter.sollie@kabelmail.de; keydata=
 xsBNBFhRXM0BCADnifwYnfbhQtJso1eeT+fjEDJh8OY5rwfvAbOhHyy003MJ82svXPmM/hUS
 C6hZjkE4kR7k2O2r+Ev6abRSlM6s6rJ/ZftmwOA7E8vdSkrFDNqRYL7P18+Iq/jM/t/6lsZv
 O+YcjF/gGmzfOCZ5AByQyLGmh5ZI3vpqJarXskrfi1QiZFeCG4H5WpMInml6NzeTpwFMdJaM
 JCr3BwnCyR+zeev7ROEWyVRcsj8ufW8ZLOrML9Q5QVjH7tkwzoedOc5UMv80uTaA5YaC1GcZ
 57dAna6S1KWy5zx8VaHwXBwbXhDHWvZP318um2BxeTZbl21yXJrUMbYpaoLJzA5ZaoCFABEB
 AAHNMEphbnBpZXRlciBTb2xsaWUgPGphbnBpZXRlci5zb2xsaWVAa2FiZWxtYWlsLmRlPsLA
 pwQTAQgAUQIbIwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAUJD6DYHRYhBGBBYpsrUd7LDG6r
 UrFUjEUPH5JbBQJlAXcQEhhoa3A6Ly9wZ3AubWl0LmVkdQAKCRCxVIxFDx+SW3oXB/9A4g3v
 /Mq6uZlBDWBrQ98AFhlkRLwI2mDiNOlP4zJlejqt8S2GvCvhiQAtXV0BSl42sHo9Uxda8sZM
 d1eOU+oPexaK9iryCEYvOj+IK+n/rR8kyH5P7lzdpHIKYGtZ2y2NtpEuIA9A28MvliGjutJ2
 QIAdUaO1GdFVHXvHConuXvBfpmJsBhJeVfoTdzrTlloFTloCC+00a6Q6ndGnwzQQVgfgzRtq
 +x3O8smVnzsHb7Wu25+sbJl55GONAqyxuRmAF8IB4HAQ9gjgiCxTfjhCt9rhXQgPlT8EAuKT
 9MohNtqpXXZFpuQUYRMEqpM7mPfbm4L8fXiPv/szVM0ZIwVCzsBNBFhRXM0BCAD2fJkCQE6L
 UjUpVltzXjxeRTNQK/W3PC1i3EsjHFSJT04MY12zmXWI0ItNqnRaB2c/X/rtWTuYazSsgQTQ
 P/qZSts2890GD51y3BAw443rN0plVp4dX6JG/p3V0ha7rXwFjn4Hzgt4IDJSVuNa9nGEceId
 qTnvZO+F4ukgzV2YVAUWcuDowCBDfRm3yU0GU3rxOHfBTpYwljqFWbGqijsTjF1/Le4ULF+q
 HUQqwTDY1ijpxRCIeu46WoQEf5Dv0aTIwOJgPK8229uRDHlHhMPvXpqtBYKwQ/rOCz7EfITD
 lPsHhjnqR+mjeLy7tK/qIyaE7A8HTdoxYoYhAR+AqylRABEBAAHCwHwEGAEIACYCGwwWIQRg
 QWKbK1Heywxuq1KxVIxFDx+SWwUCXowzcAUJD6DYIwAKCRCxVIxFDx+SW1J3CADK79k3T1La
 jEHZGkxWPoAuixN8F6pf7hnofoR2KFkMbQk+9WYfiGsOcZwJjiUyQgiaSZcdz6QGkGPDjfLL
 iNDKvGGGAgRT99ruA4uyfAXjObbrMp8VGr0fI6eRF3nWuh5Rk4W2DY/wjaygA0FJ/vpw8XFs
 9NycYvk7yPcXW29N6/56TIc1I7SxmsEzwriGxvuRNZBzuNsEvdgzkF0kTL4nMhH/olPFW1+f
 2Y0kA3aAa1ZyjzHsgDUBSKyv35MJRxPLkLK4I/5DisNfjfygE/gvSh+Iss+ZqtZhYzR9oA6k
 mg7rIQaHeVNOBwFsmkHmXDmH5beCJsgB6hwxiQAUaOaO
In-Reply-To: <CANAwSgTTzZOwBaR9zjJ5VMpxm5BydtW6rB2S7jg+dnoX8hAoWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 94.105.112.108.dyn.edpnet.net[94.105.112.108]
X-Barracuda-Start-Time: 1727077782
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1745
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.130843
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------


Hi everybody,

Is there any chance this random driver will be upstreamed?
I'm using it instead of the built-in crypto driver (rk3328-crypto), as this crypto driver showed 
the following:

> [     9.270549] rk3288-crypto ff060000.crypto: will run requests pump with realtime priority
> [     9.270687] rk3288-crypto ff060000.crypto: Register ecb(aes) as ecb-aes-rk
> [     9.270808] rk3288-crypto ff060000.crypto: Register cbc(aes) as cbc-aes-rk
> [     9.270831] rk3288-crypto ff060000.crypto: Register ecb(des) as ecb-des-rk
> [     9.270848] rk3288-crypto ff060000.crypto: Register cbc(des) as cbc-des-rk
> [     9.270864] rk3288-crypto ff060000.crypto: Register ecb(des3_ede) as ecb-des3-ede-rk
> [     9.270880] rk3288-crypto ff060000.crypto: Register cbc(des3_ede) as cbc-des3-ede-rk
> [     9.270896] rk3288-crypto ff060000.crypto: Register sha1 as rk-sha1
> [     9.270915] rk3288-crypto ff060000.crypto: Register sha256 as rk-sha256
> [     9.270932] rk3288-crypto ff060000.crypto: Register md5 as rk-md5

so the options here are pretty useless:
standard tls / ssh (ktls anyone?) almost never uses ecb or cbc ciphers, and about des ... yeah, 
won't dig into that one.
I think a rk3328 device will actually benefit more from a entropy source (even if it's not 
high-quality) than from sha1/256 which are almost always covered by armv8 crypto extensions.
I tried this patch (and disabled the crypto device in dts), it works.
Off course there are FIPS failures, but the user employing a rk3328 board probably knows this is 
not a high-security device.

Any chances here? applying the patch on 6.6.48 (even with clang thinLTO) works flawlessly.

kind regards,

Janpieter Sollie
