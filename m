Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85B01CEADB
	for <linux-crypto@vger.kernel.org>; Thu,  1 Jan 2026 23:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767308804; cv=none; b=lnd3vq2SQnYgQU3A0GLzoKn/RDGpCc0yuE5nhOK//qXcYfixXo2K+3AT6YpJr5Ea3M7aafe/XpDRCOkup54+9s+Qnu/z3FQr80cdH/bw+5mLYNeHbmOfZtn8pEKjM5BNTDuk8An2tzrEux7eDDiDk27t2e19VcKKdIsSqU3v3E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767308804; c=relaxed/simple;
	bh=US7g0fT2WrFWVNstxMf1pZ+HNijOdD3MvUsgtVB6Eww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jqjvVVQxoTJFT1sZPNQEaSnpePbsaVm0Hc8XEt1nqVtvdIIl4m4/uWbAJowWPg4eBIWhm5hmqLz6tXBPsFnoIopPUckxx4+tZY1DuCfJnBVG9LKxc+7yTu7+T6dTJ2xnQFPjkfLxTKRX+k8qTGHxqkhnCOwjfG+iN+wvcHuqR2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=cG6qI1vN; arc=none smtp.client-ip=212.77.101.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="cG6qI1vN"
Received: (wp-smtpd smtp.wp.pl 27093 invoked from network); 2 Jan 2026 00:06:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1767308797; bh=US7g0fT2WrFWVNstxMf1pZ+HNijOdD3MvUsgtVB6Eww=;
          h=Subject:To:Cc:From;
          b=cG6qI1vN+bCCYwiSGOjPS9N+FTsDwrZ5n5qwudU3dXzot8rEQPURSiI52gS1EJSXy
           4F/9AqI6COotC7x+CXH/hWRJzLcIHEtdS2a8n9Uyv4vd82yfB45K5cUcuXWxBQnPvQ
           ldcXtbNgSTrpJp/by3YjkOk4gPTmREIZ6IvRlReZfrrdqfKvg8XKQ7XikEfJ4byx53
           7oTFoz+WfFBBw5Clip9hJn+GRSZSMsCA3ykBgyT92sx+fkwoocytIGuWP78wfMxqqB
           72oBRnvkxJm0VjMeWbk0U2PSYUqJqpzsJFXitfYQ8/gdzgFGE7+mw4xTR2vK7sjj5K
           pWLKjC7SvUoEA==
Received: from 83.5.157.18.ipv4.supernova.orange.pl (HELO [192.168.3.246]) (olek2@wp.pl@[83.5.157.18])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <sergio.paracuellos@gmail.com>; 2 Jan 2026 00:06:37 +0100
Message-ID: <53dc4786-a6c3-471a-acc4-67486b8cdea9@wp.pl>
Date: Fri, 2 Jan 2026 00:06:36 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mips: dts: ralink: mt7621: add crypto offload
 support
To: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc: ansuelsmth@gmail.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 chester.a.unal@arinc9.com, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, matthias.bgg@gmail.com, tsbogend@alpha.franken.de,
 angelogioacchino.delregno@collabora.com, linux-crypto@vger.kernel.org,
 linux-mips@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, benjamin.larsson@genexis.eu
References: <20260101172052.1862252-1-olek2@wp.pl>
 <20260101172052.1862252-2-olek2@wp.pl>
 <CAMhs-H_iN7pWsis2HbeJ-xr+9JoMa+EF-+7z9e21DJ1dyNNtuw@mail.gmail.com>
Content-Language: en-US
From: Aleksander Jan Bajkowski <olek2@wp.pl>
In-Reply-To: <CAMhs-H_iN7pWsis2HbeJ-xr+9JoMa+EF-+7z9e21DJ1dyNNtuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-WP-MailID: 2fbea3525d83cf2a46a1adb43f9685ce
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000009 [oVr0]                               

Hi Sergio,

On 1/1/26 22:46, Sergio Paracuellos wrote:
> AFAICS, the crypto engine for mt7621 has also a clock gate[0] and a
> reset line[1]. These two are not present in this binding.
>
> [0]: https://elixir.bootlin.com/linux/v6.18.2/source/include/dt-bindings/clock/mt7621-clk.h#L36
> [1]: https://elixir.bootlin.com/linux/v6.18.2/source/include/dt-bindings/reset/mt7621-reset.h#L33

Will add reset and clock gate in the next iteration. It looks like
the crypto engine in AN7581 also has a clock gate[0] and reset line[1].
Just not sure if these definitions are correct.

CC: Benjamin Larsson

[0] https://elixir.bootlin.com/linux/v6.19-rc3/source/include/dt-bindings/clock/en7523-clk.h#L12
[1] https://elixir.bootlin.com/linux/v6.19-rc3/source/include/dt-bindings/reset/airoha,en7581-reset.h#L45

