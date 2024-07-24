Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B68481A3;
	Wed, 24 Jul 2024 06:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721801283; cv=none; b=lLoRD9OBlba++aiEBVB4voYU2g4lxfxuAhDgzjuJL6ApY0vqYRADO+IiomEKi9S0VWq7r2Ji0eTqO1hOD4Z42OEeIdlijsCghdlx65pC9+xEpgtnBbI8EQGYrYxI46r6H/+/+lHUQHO9kjNFUaeA84YSEG90UkJeeJIECA8HBEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721801283; c=relaxed/simple;
	bh=jInSfdolrSb6rZZTNpR8KYUxyhXwMQW98qG0aYlhT7k=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=plRYqaDL29hjmmyURAyrXthW95p96OfW+Q1STcrA+ln/LI7N1wVjG+cfcqpU/v3H0reF55kNzrrTrUXo3Bs2LJOdJKn7v3JhlMTvrwn7TBQKX9BWO2S0LmN4JUb386E5nlKP8PDn6cuKQ5tF+qDvsXQTBm+65DVxISlZLwFEvBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=Jv+PLl69; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="Jv+PLl69"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1721801277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XyjInt3tUidOyksxXpHHpDTL3zQ9fivow6y7hPi+Pno=;
	b=Jv+PLl69onj6PsmLDv9OGGgcsJIk6CcGUDtFNWwsNxrClYC0BX/MWOSwjKLN03FhPovzcy
	yVoxU/Vn7jROb7vesIgxuN+llQ6MX0Jwf3dXSWsn7vtKWjynEqa32D05UMD7IzDv1IpAEz
	QSg93FKdkm7Xo66nuxpChrdZXBYH/d3j8c4WU+/Xeib38kannBWEbVTKWLxHOZkiS8etT6
	Mm37bq289hYMKCgObh8hMcy0lrdVMW7IANkJBOoVyKZF/Mad9vKtCrOFBLDTk6T+C0e/TJ
	hiHlDHfS2xSH2+DzHl25RP0UQpGkrRwbnoyNbIKuH8NV/dNnlGSSu6OCHdZjeQ==
Date: Wed, 24 Jul 2024 08:07:51 +0200
From: Dragan Simic <dsimic@manjaro.org>
To: Diederik de Haas <didi.debian@cknow.org>
Cc: Chen-Yu Tsai <wens@kernel.org>, Daniel Golle <daniel@makrotopia.org>,
 linux-rockchip@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 Rob Herring <robh@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Martin Kaiser <martin@kaiser.cx>, Sascha Hauer <s.hauer@pengutronix.de>,
 Sebastian Reichel <sebastian.reichel@collabora.com>, Ard Biesheuvel
 <ardb@kernel.org>, =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
 devicetree@vger.kernel.org, linux-crypto@vger.kernel.org, Philipp Zabel
 <p.zabel@pengutronix.de>, Olivia Mackall <olivia@selenic.com>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Aurelien Jarno <aurelien@aurel32.net>, Heiko
 Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
In-Reply-To: <4406786.zLnsZ2vfAB@bagend>
References: <cover.1720969799.git.daniel@makrotopia.org>
 <3190961.CRkYR5qTbq@bagend>
 <CAGb2v64Dx7XaJOu0HHzFxYYY2ddUZao5Tar8-s1R_miVZqWcXA@mail.gmail.com>
 <4406786.zLnsZ2vfAB@bagend>
Message-ID: <faa0baebabd3c31adf1afa7efbbdf608@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Diederik and Chen-Yu,

On 2024-07-22 21:03, Diederik de Haas wrote:
> On Monday, 22 July 2024 19:57:05 CEST Chen-Yu Tsai wrote:
>> On Wed, Jul 17, 2024 at 12:54 AM Diederik de Haas 
>> <didi.debian@cknow.org>
> wrote:
>> > On Tuesday, 16 July 2024 17:18:48 CEST Chen-Yu Tsai wrote:
>> > > On Jul 16, 2024 at 10:13 PM Diederik de Haas <didi.debian@cknow.org>
> wrote:
>> > > > On Tuesday, 16 July 2024 15:59:40 CEST Diederik de Haas wrote:
>> > > > > For shits and giggles, I tried it on my PineTab2 too (also rk3566):
>> > > > >
>> > > > > ===========================================================
>> > > > > root@pinetab2:~# uname -a
>> > > > > Linux pinetab2 6.10+unreleased-arm64 #1 SMP Debian 6.10-1~cknow
>> > > > > (2024-04-24) aarch64 GNU/Linux
>> > > > >
>> > > > > root@pinetab2:~# dd if=/dev/hwrng bs=100000 count=1 > /dev/null
>> > > > > 1+0 records in
>> > > > > 1+0 records out
>> > > > > 100000 bytes (100 kB, 98 KiB) copied, 5,69533 s, 17,6 kB/s
>> > > > >
>> > > > > root@plebian-pinetab2:~# cat /dev/hwrng | rngtest -c 1000
>> > > > > rngtest 5
>> > > > > ...
>> > > > > rngtest: starting FIPS tests...
>> > > > > rngtest: bits received from input: 20000032
>> > > > > rngtest: FIPS 140-2 successes: 730
>> > > > > rngtest: FIPS 140-2 failures: 270
>> > > > > ===========================================================
>> > > > >
>> > > > > That's looking quite a lot better ... and I have no idea why.
>> > > > >
>> > > > > The Q64-A is used as headless server and the PineTab2 is not,
>> > > > > but I connected to both over SSH and they were freshly booted
>> > > > > into, thus I haven't actually/normally used the PT2 since boot.
>> > > >
>> > > > I did freshly install rng-tools5 package before running the test, so
>> > > > I rebooted again to make sure that wasn't a factor:
>> > > >
>> > > > ===========================================================
>> > > > root@pinetab2:~# cat /dev/hwrng | rngtest -c 1000
>> > > > rngtest 5
>> > > > ...
>> > > > rngtest: starting FIPS tests...
>> > > > rngtest: bits received from input: 20000032
>> > > > rngtest: FIPS 140-2 successes: 704
>> > > > rngtest: FIPS 140-2 failures: 296
>> > > > ===========================================================
>> > > >
>> > > > So that 704/296 vs 730/270 in the previous run on the PT2.
>> > > >
>> > > On my Rock 3A:
>> > >
>> > > wens@rock-3a:~$ sudo cat /dev/hwrng | rngtest -c 1000
>> > > rngtest 5
>> > > ...
>> > > rngtest: starting FIPS tests...
>> > > rngtest: bits received from input: 20000032
>> > > rngtest: FIPS 140-2 successes: 992
>> > > rngtest: FIPS 140-2 failures: 8
>> > >
>> > > wens@rock-3a:~$ uname -a
>> > > Linux rock-3a 6.10.0-rc7-next-20240712-12899-g7df602fe7c8b #9 SMP Mon
>> > > Jul 15 00:39:32 CST 2024 aarch64 GNU/Linux
>> >
>> > I wondered if ``dd if=/dev/hwrng bs=100000 count=1 > /dev/null`` before
>> > the actual test run made a difference.
>> > Tried it on my Quartz64 Model A: no
>> >
>> > Then I tried it on my Quartz64 Model B:
>> >
>> > root@quartz64b:~# cat /dev/hwrng | rngtest -c 1000
>> > rngtest 5
>> > ...
>> > rngtest: starting FIPS tests...
>> > rngtest: bits received from input: 20000032
>> > rngtest: FIPS 140-2 successes: 120
>> > rngtest: FIPS 140-2 failures: 880
>> >
>> > root@quartz64b:~# dd if=/dev/hwrng bs=100000 count=1 > /dev/null
>> > 1+0 records in
>> > 1+0 records out
>> > 100000 bytes (100 kB, 98 KiB) copied, 5.71466 s, 17.5 kB/s
>> >
>> > root@quartz64b:~# cat /dev/hwrng | rngtest -c 1000
>> > rngtest 5
>> > ...
>> > rngtest: starting FIPS tests...
>> > rngtest: bits received from input: 20000032
>> > rngtest: FIPS 140-2 successes: 104
>> > rngtest: FIPS 140-2 failures: 896
>> >
>> > root@quartz64b:~# uname -a
>> > Linux quartz64b 6.10+unreleased-arm64 #1 SMP Debian 6.10-1~cknow
>> > (2024-04-24) aarch64 GNU/Linux>
>> > :-O
>> 
>> I pulled out my Quartz64 model B, and the results seem better than 
>> yours.
>> 
>> root@quartz64:~# sudo dd if=/dev/hwrng bs=256 | rngtest -c 1000
>> rngtest 5
>> ...
>> rngtest: starting FIPS tests...
>> rngtest: bits received from input: 20000032
>> rngtest: FIPS 140-2 successes: 859
>> rngtest: FIPS 140-2 failures: 141
>> root@quartz64:~# sudo dd if=/dev/hwrng bs=256 | rngtest -c 1000
>> rngtest 5
>> ...
>> rngtest: starting FIPS tests...
>> rngtest: bits received from input: 20000032
>> rngtest: FIPS 140-2 successes: 843
>> rngtest: FIPS 140-2 failures: 157
> 
> I noticed you used ``dd`` instead of ``cat``, so I tried again ...
> 
> Quartz64-A:
> root@quartz64a:~# dd if=/dev/hwrng bs=256 | rngtest -c 1000
> rngtest 5
> ...
> rngtest: starting FIPS tests...
> 
> rngtest: bits received from input: 20000032
> 
> rngtest: FIPS 140-2 successes: 411
> 
> rngtest: FIPS 140-2 failures: 589
> 
> root@quartz64a:~# dd if=/dev/hwrng bs=256 | rngtest -c 1000
> ...
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 391
> rngtest: FIPS 140-2 failures: 609
> 
> root@quartz64a:~# dd if=/dev/hwrng bs=100000 count=1 > /dev/null
> 1+0 records in
> 1+0 records out
> 100000 bytes (100 kB, 98 KiB) copied, 5.66202 s, 17.7 kB/s
> 
> root@quartz64a:~# dd if=/dev/hwrng bs=256 | rngtest -c 1000
> ...
> rngtest: FIPS 140-2 successes: 386
> 
> rngtest: FIPS 140-2 failures: 614
> 
> root@quartz64a:~# dd if=/dev/hwrng bs=256 | rngtest -c 1000
> ...
> rngtest: FIPS 140-2 successes: 356
> rngtest: FIPS 140-2 failures: 644
> 
> Quartz64-B:
> root@quartz64b:~# dd if=/dev/hwrng bs=256 | rngtest -c 1000
> ...
> rngtest: FIPS 140-2 successes: 118
> rngtest: FIPS 140-2 failures: 882
> 
> root@quartz64b:~# dd if=/dev/hwrng bs=256 | rngtest -c 1000
> ...
> rngtest: FIPS 140-2 successes: 133
> rngtest: FIPS 140-2 failures: 867
> 
> root@quartz64b:~# dd if=/dev/hwrng bs=100000 count=1 > /dev/null
> 
> root@quartz64b:~# dd if=/dev/hwrng bs=256 | rngtest -c 1000
> ...
> rngtest: FIPS 140-2 successes: 97
> rngtest: FIPS 140-2 failures: 903
> 
> root@quartz64b:~# dd if=/dev/hwrng bs=256 | rngtest -c 1000
> ...
> rngtest: FIPS 140-2 successes: 130
> rngtest: FIPS 140-2 failures: 870
> 
> And lastly on PineTab2:
> root@pinetab2:~# dd if=/dev/hwrng bs=256 | rngtest -c 1000
> ...
> rngtest: FIPS 140-2 successes: 705
> rngtest: FIPS 140-2 failures: 295
> 
> root@pinetab2:~# dd if=/dev/hwrng bs=256 | rngtest -c 1000
> ...
> rngtest: FIPS 140-2 successes: 678
> rngtest: FIPS 140-2 failures: 322
> 
> root@pinetab2:~# dd if=/dev/hwrng bs=100000 count=1 > /dev/null
> 
> root@pinetab2:~# dd if=/dev/hwrng bs=256 | rngtest -c 1000
> ...
> rngtest: FIPS 140-2 successes: 681
> rngtest: FIPS 140-2 failures: 319
> 
> root@pinetab2:~# dd if=/dev/hwrng bs=256 | rngtest -c 1000
> ...
> rngtest: FIPS 140-2 successes: 669
> rngtest: FIPS 140-2 failures: 331
> 
> 
> So my Q64-B tests are consistently MUCH worse then your Q64-B tests ...
> This seems BAD to me, now that we even have completely different 
> results per
> device of the EXACT same model?!? Hardware revision may be different (I 
> have a
> v1.4), but it seems rather pointless to go into that direction.
> 
> It then also seems rather pointless to try it with different parameters 
> if the
> results on the same SBC model can vary this much.

Thanks a lot for the testing.  Though, such wildly different test 
results
can, regrettably, lead to only one conclusion:  the HWRNG found in 
RK3566
is unusable. :/
